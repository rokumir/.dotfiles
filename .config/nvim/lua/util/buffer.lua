local M = {}

---@param file? string
---@return integer?
function M.get_buf_from_file(file)
	local buffers = vim.api.nvim_list_bufs()
	for _, bufnr in ipairs(buffers) do
		if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_name(bufnr) ~= '' then
			local buffer_file_name = vim.api.nvim_buf_get_name(bufnr)
			if buffer_file_name == file then return bufnr end
		end
	end
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
	Snacks.notify 'History cleared'
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
			Snacks.notify 'History is empty'
		else
			Snacks.notify.error { 'Incorrect state!', 'Initiate factory reset!' }
			self:clear()
		end
		return
	end

	local node = state.nodes[target]
	if not node then return Snacks.notify { 'Not in history:', '**[' .. target .. ']**' } end

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
		return Snacks.notify.error { 'File not found:', '**[' .. readable_target .. ']**' }
	end
	vim.cmd('edit ' .. vim.fn.fnameescape(target))
end

--- Launches a Snacks.nvim picker for buffer history.
function M.history:picker()
	if not Snacks then return Snacks.notify.error '**[Snacks.nvim]** picker not found!' end
	if self._state.size == 0 then return Snacks.notify 'Empty!' end

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
---@field head? string
---@field tail? string
---@field size number
---
---@class BufferHistoryEntry
---@field _path string
---@field cwd string
---@field file string
---@field text string
---@field next? string
---@field prev? string
---
---@class BufferDeleteOptions : snacks.bufdelete.Opts
---@field ft_passthru? false  Ignored filetypes/buffertypes
