local map = require('utils.keymap').map
local function augroup(name, opts) return vim.api.nvim_create_augroup('nihil_' .. name, opts or { clear = true }) end

-- Settings for the greatest script of all time
vim.api.nvim_create_autocmd('FileType', {
	group = augroup 'simple_window',
	pattern = 'tmux-harpoon', -- in config.filetype
	callback = function(e)
		vim.opt.showmode = false
		vim.opt.ruler = false
		vim.opt.laststatus = 0
		vim.opt.showcmd = false
		vim.opt.wrap = false

		map { 'n', '<c-q>', '<cmd>quit <cr>', buffer = e.buf }
		map { 'n', '<c-s>', '<cmd>write | quit <cr>', buffer = e.buf }
	end,
})

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd('InsertLeave', {
	group = augroup 'no_paste',
	pattern = '*',
	command = 'set nopaste',
})

vim.api.nvim_create_autocmd('FileType', {
	group = augroup 'concealment',
	pattern = { 'json', 'jsonc', 'markdown' },
	callback = function() vim.opt.wrap = false end,
})

-- Advanced LSP progress
---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd('LspProgress', {
	group = augroup 'better_lsp_progress',
	---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
		if not client or type(value) ~= 'table' then return end
		local p = progress[client.id]

		for i = 1, #p + 1 do
			if i == #p + 1 or p[i].token == ev.data.params.token then
				p[i] = {
					token = ev.data.params.token,
					msg = ('[%3d%%] %s%s'):format(
						value.kind == 'end' and 100 or value.percentage or 100,
						value.title or '',
						value.message and (' **%s**'):format(value.message) or ''
					),
					done = value.kind == 'end',
				}
				break
			end
		end

		local msg = {} ---@type string[]
		progress[client.id] = vim.tbl_filter(function(v) return table.insert(msg, v.msg) or not v.done end, p)

		local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
		Snacks.notify.info(table.concat(msg, '\n'), {
			id = 'lsp_progress',
			title = client.name,
			opts = function(notif) notif.icon = #progress[client.id] == 0 and ' ' or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1] end,
		})
	end,
})

-- Function to check and disable diagnostics based on modeline in the first 3 lines
-- Create an autocommand to run the function when a buffer is read or entered
-- vim.api.nvim_create_autocmd({ 'FileType', 'BufRead', 'BufEnter' }, {
-- 	group = augroup 'disable_diagnostics_comment',
-- 	pattern = { 'typescript', 'typescriptreact' },
-- 	callback = function()
-- 		local bufnr = vim.api.nvim_get_current_buf()
-- 		local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 3, false)
-- 		if not lines or #lines == 0 then
-- 			return -- Buffer is empty
-- 		end
--
-- 		-- Get the comment string for the current filetype
-- 		local comment_string = vim.bo[bufnr].commentstring:match '^(.-)%%s'
-- 		if not comment_string then return end -- No valid comment string found
--
-- 		-- Build a Lua pattern to match the modeline
-- 		-- Allows for flexible whitespace between the comment and the directive
-- 		local pattern = string.format('^%s%s%s$', comment_string, '%s+', 'vim:diagnostics%s*disable')
--
-- 		for _, line in ipairs(lines) do
-- 			if line:match(pattern) then
-- 				vim.diagnostic.enable(false, { bufnr = bufnr })
-- 				Snacks.notify.info '-------Match-------'
-- 				return
-- 			end
-- 		end
-- 	end,
-- })
