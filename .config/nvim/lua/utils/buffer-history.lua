-- NOTE: Cross session tab restore is not supported.
local M = {}

-- Internal state
---@type BufferHistoryEntries
M.state = {
	nodes = {},
	head = nil,
	tail = nil,
	size = 0,
}

local MAX_ENTRIES = 30

-- Unified notifier
---@param msg string|string[]
---@param lvl snacks.notifier.level?
local function notice(msg, lvl)
	local notify = Snacks.notify or LazyVim.notify
	local title = 'Buffer History'
	if notify then
		notify(msg, { title = title, level = lvl or vim.log.levels.INFO })
	else
		vim.notify(title .. ': ' .. msg, vim.log.levels.INFO)
	end
end

--- Clears the entire history.
function M:clear()
	self.state.nodes = {}
	self.state.head = nil
	self.state.tail = nil
	self.state.size = 0
	notice 'History cleared'
end

--- Adds (or moves) a buffer path to the front of history.
---@param path string
function M:put(path)
	-- No-op if already at front
	if path == self.state.head then return end

	local nodes = self.state.nodes
	local node = nodes[path]

	-- Decouple/preprocessing stuffs
	if node then
		-- Detach existing node
		if node.next then nodes[node.next].prev = node.prev end
		if node.prev then nodes[node.prev].next = node.next end
		if path == self.state.tail then self.state.tail = node.next end
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
		if self.state.size == MAX_ENTRIES then
			local oldTail = self.state.tail ---@cast oldTail string
			local newTail = nodes[oldTail].next
			nodes[newTail].prev = nil -- detach
			nodes[oldTail] = nil -- terminate
			self.state.tail = newTail
		end

		self.state.size = self.state.size + 1
	end

	-- Insert at head (newest)
	node.next = nil
	node.prev = self.state.head
	local prev_head = nodes[self.state.head]
	if prev_head then prev_head.next = path end

	self.state.head = path
	if self.state.size == 1 then self.state.tail = path end
end

--- Pops and reopens the most recent buffer, or a specific one if `path` is provided.
---@param path? string
function M:pop(path)
	local target = path or self.state.head
	if not target then
		if self.state.size == 0 then
			notice 'History is empty'
		else
			notice({ 'Incorrect state!', 'Initiate factory reset!' }, 'error')
			self:clear()
		end
		return
	end

	local node = self.state.nodes[target]
	if not node then return notice('Not in history: ' .. target) end

	local newer = node.next
	local older = node.prev

	-- Unlink from newer neighbor (toward head)
	if newer then
		self.state.nodes[newer].prev = older
	else
		-- if no newer, we popped the head
		self.state.head = older
	end

	-- Unlink from older neighbor (toward tail)
	if older then
		self.state.nodes[older].next = newer
	else
		-- if no older, we popped the tail
		self.state.tail = newer
	end

	-- Remove the node and update size
	self.state.nodes[target] = nil
	self.state.size = self.state.size - 1

	-- Attempt to open the file
	if vim.fn.filereadable(target) == 0 then return notice('File not found: ' .. target, 'error') end
	vim.cmd('edit ' .. vim.fn.fnameescape(target))
end

--- Launches a Snacks.nvim picker for buffer history.
function M:picker()
	if not Snacks then return notice({ '**Snacks.nvim** picker not found!', 'Picker disabled.' }, 'error') end
	if self.state.size == 0 then return notice 'Empty!' end

	Snacks.picker.pick {
		title = 'Buffer History',
		layout = 'vscode_focus_min',
		format = 'file',
		items = vim.tbl_values(self.state.nodes),
		confirm = function(picker)
			local selections = picker:selected { fallback = true }
			picker.list:set_selected()
			if vim.tbl_isempty(selections) then return end

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

-- Aliases
M.restore = M.pop
M.store = M.put
M.snacks = M.picker

return M

---@class BufferHistoryEntries
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
