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

---@param file_or_buf? string|integer?
---@param opts? {no_prompt:boolean?, job_opts?: vim.fn.jobstart.Opts}
function M.delete(file_or_buf, opts)
	file_or_buf = file_or_buf or 0 ---@type string|integer? default to current buffer
	opts = opts or {}
	opts.job_opts = opts.job_opts or {}

	local file_path ---@type string
	local bufnr ---@type number?
	if type(file_or_buf) == 'number' then
		file_path = vim.api.nvim_buf_get_name(file_or_buf)
		bufnr = file_or_buf
	elseif type(file_or_buf) == 'string' then
		file_path = file_or_buf
		bufnr = M.get_buf_from_file(file_or_buf)
	else
		Snacks.notify.error { 'Buffer/file not found:', '**[' .. file_or_buf .. ']**' }
		return
	end

	if not file_path or file_path == '' then
		Snacks.notify.error 'Cannot delete unnamed buffer!'
		return
	end

	local rel_file_path = require('nihil.util.path').relative(file_path)
	local file_id = '**[' .. rel_file_path .. ']**'

	-- Confirmations
	if opts.no_prompt ~= true then
		local c = vim.fn.confirm
		-- stylua: ignore
		if c('Do want to delete ' .. rel_file_path .. '?', '&Yes\n&No', 2) ~= 1
			or (bufnr and vim.bo[bufnr].modified
			and c('This file is modified! Continue to delete ' .. rel_file_path .. '?', '&Yes\n&No', 2) ~= 1)
		then return end
	end

	Snacks.notify.info('Deleting ' .. file_id, { id = file_id })

	-- Close buffer before deleting file
	if bufnr then Snacks.bufdelete.delete(bufnr) end

	-- Delete file via cli
	vim.fn.jobstart(
		'trash put --debug ' .. vim.fn.shellescape(file_path),
		vim.tbl_extend('keep', {
			detach = true,
			on_exit = function(_, code)
				local success = code == 0
				local message = success and 'Successfully deleted' or 'Failed to delete'
				Snacks.notify({ message, file_id }, {
					level = success and 'info' or 'error',
					id = file_id,
				})
				pcall(opts.job_opts.on_exit or 0) ---@diagnostic disable-line: param-type-mismatch
			end,
		}, opts.job_opts)
	)
end

--#region Buffer History -------------------------
M.buf_history = {
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
function M.buf_history:clear()
	self._state.nodes = {}
	self._state.head = nil
	self._state.tail = nil
	self._state.size = 0
	Snacks.notify 'History cleared'
end

--- Adds (or moves) a buffer path to the front of history.
---@param path string
function M.buf_history:put(path)
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
			idx = state.size,
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
function M.buf_history:pop(path)
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
function M.buf_history:picker()
	if not Snacks then return Snacks.notify.error '**[Snacks.nvim]** picker not found!' end
	if self._state.size == 0 then return Snacks.notify 'Empty!' end

	Snacks.picker.pick {
		title = 'Buffer History',
		source = 'buffer_history',
		layout = 'vscode_min',
		format = 'file',
		sort = { fields = { 'idx' } },
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

M.buf_history.restore = M.buf_history.pop
M.buf_history.store = M.buf_history.put
M.buf_history.snacks = M.buf_history.picker
--#endregion

return M
