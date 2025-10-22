local M = {}

-- Unified notifier
---@param msg string|string[]
---@param lvl snacks.notifier.level?
local function notice(msg, lvl)
	local ext_notify = Snacks.notify or LazyVim.notify
	ext_notify(msg, { title = 'Buffer History', level = lvl or vim.log.levels.INFO })
end

---@param bufnr number?  Buffer to delete (0 or nil = current)
---@param opts BufferRemoveOptions?  Fallback buffers if windows show it (default: true)
function M.bufremove(bufnr, opts)
	bufnr = bufnr or 0
	bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr
	opts = opts or {}
	opts.failsafe = opts.failsafe ~= false
	opts.buffer_guard = opts.buffer_guard ~= false

	local function close_buffer()
		if vim.api.nvim_buf_is_valid(bufnr) then pcall(vim.api.nvim_buf_delete, bufnr, { force = true }) end
	end

	-- skip certain filetypes/buffertypes
	if opts.buffer_guard then
		local filetype = vim.bo[bufnr].filetype
		local buftype = vim.bo[bufnr].buftype
		local ft_excludes = require('config.const.filetype').ignored_map
		local bt_excludes = require('config.const.buffertype').ignored_map
		if ft_excludes[filetype] or (buftype ~= '' and bt_excludes[buftype]) then return close_buffer() end
	end

	-- prompt to save if modified
	if vim.bo.modified then
		local prompt = 'Save changes to ' .. require('utils.path').shorten(vim.fn.bufname()) .. '?'
		Snacks.picker.select({ 'Yes', 'No' }, { prompt = prompt }, function(_, idx)
			if idx == 1 then vim.cmd.write() end
		end)
		return
	end

	-- reassign any windows showing this buffer
	if opts.failsafe then
		for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
			vim.api.nvim_win_call(win, function()
				if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= bufnr then return end

				-- try alternate buffer
				local alt = vim.fn.bufnr '#'
				if alt ~= bufnr and vim.fn.buflisted(alt) == 1 then
					vim.api.nvim_win_set_buf(win, alt)
					return
				end

				-- try previous buffer
				local has_previous = pcall(vim.cmd.bprevious)
				if has_previous and bufnr ~= vim.api.nvim_win_get_buf(win) then return end

				-- fallback to a new listed buffer
				local new_buf = vim.api.nvim_create_buf(true, false)
				vim.api.nvim_win_set_buf(win, new_buf)
			end)
		end
	end

	-- Finally, delete the buffer
	close_buffer()
end

--#region Buffer History -------------------------
-- NOTE: Cross session tab restore is not supported.
M.history = {
	MAX_ENTRIES = 30,
	---@type BufferHistoryState
	_state = {
		nodes = {},
		head = nil,
		tail = nil,
		size = 0,
	},
}

--- Clears the entire history.
function M.history:clear()
	self._state.nodes = {}
	self._state.head = nil
	self._state.tail = nil
	self._state.size = 0
	notice 'History cleared'
end

--- Adds (or moves) a buffer path to the front of history.
---@param path string
function M.history:put(path)
	local state = self._state
	-- No-op if already at front
	if path == state.head then return end

	local nodes = state.nodes
	local node = nodes[path]

	-- Decouple/preprocessing stuffs
	if node then
		-- Detach existing node
		if node.next then nodes[node.next].prev = node.prev end
		if node.prev then nodes[node.prev].next = node.next end
		if path == state.tail then state.tail = node.next end
	else
		-- Create new node
		local cwd = vim.fn.getcwd()
		local file_rel_path = path:sub(#cwd + 2)
		node = {
			_path = path,
			cwd = cwd,
			text = file_rel_path,
			file = file_rel_path,
		}
		nodes[path] = node

		-- Enforce max size: drop oldest
		if state.size == self.MAX_ENTRIES then
			local oldTail = state.tail ---@cast oldTail string
			local newTail = nodes[oldTail].next
			nodes[newTail].prev = nil -- detach
			nodes[oldTail] = nil -- terminate
			state.tail = newTail
		end

		state.size = state.size + 1
	end

	-- Insert at head (newest)
	node.next = nil
	node.prev = state.head
	local prev_head = nodes[state.head]
	if prev_head then prev_head.next = path end

	state.head = path
	if state.size == 1 then state.tail = path end
end

--- Pops and reopens the most recent buffer, or a specific one if `path` is provided.
---@param path? string
function M.history:pop(path)
	local state = self._state
	local target = path or state.head
	if not target then
		if state.size == 0 then
			notice 'History is empty'
		else
			notice({ 'Incorrect state!', 'Initiate factory reset!' }, 'error')
			self:clear()
		end
		return
	end

	local node = state.nodes[target]
	if not node then return notice('Not in history: ' .. target) end

	local newer = node.next
	local older = node.prev

	-- Unlink from newer neighbor (toward head)
	-- if no newer, we popped the head
	if newer then
		state.nodes[newer].prev = older
	else
		state.head = older
	end

	-- Unlink from older neighbor (toward tail)
	-- if no older, we popped the tail
	if older then
		state.nodes[older].next = newer
	else
		state.tail = newer
	end

	-- Remove the node and update size
	state.nodes[target] = nil
	state.size = state.size - 1

	-- Attempt to open the file
	if vim.fn.filereadable(target) == 0 then
		local readable_target = target:gsub('^' .. vim.fn.getcwd() .. '/', '')
		return notice('File not found: **' .. readable_target .. '**', 'error')
	end
	vim.cmd('edit ' .. vim.fn.fnameescape(target))
end

--- Launches a Snacks.nvim picker for buffer history.
function M.history:picker()
	if not Snacks then return notice({ '**Snacks.nvim** picker not found!', 'Picker disabled.' }, 'error') end
	if self._state.size == 0 then return notice 'Empty!' end

	Snacks.picker.pick {
		source = 'buffer_history',
		title = 'Buffer History',
		layout = 'vscode_focus_min',
		format = 'file',
		items = vim.tbl_values(self._state.nodes),
		confirm = function(picker)
			local selections = picker:selected { fallback = true }
			picker.list:set_selected()

			-- Process each selected entry
			for _, item in ipairs(selections) do
				if item.file then
					local raw = item.cwd and (item.cwd .. '/' .. item.file) or item.file
					local path = item._path or vim.fs.normalize(raw, { _fast = true, expand_env = false })
					self:pop(path)
				end
			end
		end,
		win = {
			input = { keys = { ['<a-X>'] = { 'clear_history', mode = { 'n', 'i' } } } },
		},
		actions = {
			clear_history = function(picker)
				picker:close()
				self:clear()
			end,
		},
	}
end

M.history.restore = M.history.pop
M.history.store = M.history.put
M.history.snacks = M.history.picker
--#endregion

--#region Shada -------------------------
M.shada = {}

--- Clears shada entries for specific files using the provided regex pattern.
---
--- This function improves on the original script by combining all file paths
--- into a single regex for a more efficient one-pass substitution. It operates
--- on a temporary, in-memory buffer to avoid any UI disruption.
---
---@param items table<{file: string}> A list of tables, where each table has a `file` key
---
function M.shada.clear_shada_entries_with_regex(items)
	-- Collect and escape file paths for the Vim regex engine.
	local file_patterns = {}
	for _, item in ipairs(items) do
		if item.file and item.file ~= '' then
			-- Escape characters that are special in Vim's regex, like '.', '*', '[', etc.
			-- This is critical for ensuring file paths with such characters don't break the regex.
			local pattern = vim.fn.escape(item.file, [[\.*^$[]])
			table.insert(file_patterns, pattern)
		end
	end

	if #file_patterns == 0 then
		vim.notify('No valid file paths provided to clear.', vim.log.levels.WARN)
		return
	end

	-- Construct the full regex using the provided template.
	local files_regex_part = '\\(' .. table.concat(file_patterns, '\\|') .. '\\)'
	local full_regex = '^\\S\\(\\n\\s\\|[^\\n]\\)\\{-}' .. files_regex_part .. '\\_.\\{-}\\n*\\ze\\(^\\S\\|\\%$\\)'

	-- check for shada
	local shada_path = vim.fn.stdpath 'state' .. '/shada/main.shada'
	local file, err = io.open(shada_path, 'r')
	if not file then return Snacks.notify.info 'Shada file not found, nothing to clear.' end
	local content = file:read '*a'
	file:close()

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, '\n'))

	-- Find a safe separator for the substitute command that does not appear anywhere in the regex itself.
	local sep = (vim.tbl_filter(function(char) return not full_regex:find(char, 1, true) end, { '#', '@', '!', '%', '&', ';' }))[1]
	if not sep then
		vim.api.nvim_buf_delete(buf, { force = true })
		return Snacks.notify.error 'Could not find a safe separator for regex substitution.'
	end

	-- Execute the substitution command within the context of the temporary buffer.
	local substitute_cmd = string.format('%%s%s%s%s%sg', sep, full_regex, sep, sep)
	vim.api.nvim_buf_call(buf, function() vim.cmd(substitute_cmd) end)

	-- Get the modified content and clean up the temporary buffer.
	local new_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	vim.api.nvim_buf_delete(buf, { force = true })

	-- Write the cleaned content back to the shada file and reload.
	file, err = io.open(shada_path, 'w')
	if not file then return Snacks.notify.error('Could not write to shada file: ' .. tostring(err)) end
	file:write(table.concat(new_lines, '\n'))
	file:close()

	vim.cmd 'rshada!'
	Snacks.notify.info 'Shada cache cleared of specified entries using regex.'
end
--#endregion

return M

---@class BufferHistoryState
---@field nodes table <string?, BufferHistoryEntry>
---@field head string?
---@field tail string?
---@field size number
---
---@class BufferHistoryEntry
---@field _path string
---@field cwd string
---@field file string
---@field text string
---@field next string?
---@field prev string?
---
---@class BufferRemoveOptions
---@field buffer_guard false?  Ignored filetypes/buffertypes
---@field failsafe false?  Fallback buffers if windows show it
