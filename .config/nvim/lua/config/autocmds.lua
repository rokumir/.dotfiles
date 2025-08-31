local const = require 'utils.const'
local map = vim.keymap.set
local function augroup(name, opts) return vim.api.nvim_create_augroup('nihil_' .. name, opts or { clear = true }) end

-- Settings for the greatest script of all time
vim.api.nvim_create_autocmd('FileType', {
	group = augroup 'simple_window',
	pattern = 'tmux-harpoon', -- in config.filetype
	callback = function(ev)
		vim.opt_local.showmode = false
		vim.opt_local.ruler = false
		vim.opt_local.laststatus = 0
		vim.opt_local.showcmd = false
		vim.opt_local.wrap = false

		map('n', '<c-q>', '<cmd>quit <cr>', { buffer = ev.buf })
		map('n', '<c-s>', '<cmd>write | quit <cr>', { buffer = ev.buf })
	end,
})

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd('InsertLeave', {
	group = augroup 'no_paste',
	pattern = '*',
	command = 'set nopaste',
})

vim.api.nvim_create_autocmd('FileType', {
	group = augroup 'lang_markdown',
	pattern = { 'markdown' },
	callback = function()
		vim.opt_local.wrap = false
		vim.opt_local.spell = false
		vim.opt_local.concealcursor = 'ivc'
	end,
})

-- Advanced LSP progress
vim.api.nvim_create_autocmd('LspProgress', {
	callback = function(ev) ---@param ev {data: {client_id: number, params: lsp.ProgressParams}}
		local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
		vim.notify(vim.lsp.status(), 'info', {
			id = 'lsp_progress',
			title = 'LSP Progress',
			opts = function(notif) notif.icon = ev.data.params.value.kind == 'end' and ' ' or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1] end,
		})
	end,
})

--[[
local DISABLE_AUTOFORMAT_PATTERNS = { 'nvim:autoformat=true', 'nvim:autoformat=1', }
vim.api.nvim_create_autocmd('BufReadPost', {
	group = augroup 'modeline_disable_autoformat',
	pattern = { '*' },
	callback = function(ev)
		local buf = ev.buf
		local lines_to_read = vim.o.modelines or 5 -- Use vim.o.modelines, default to 5

		for i = 1, math.min(lines_to_read, vim.api.nvim_buf_line_count(buf)) do
			local line = vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1]
			if line and string.find(line, DISABLE_AUTOFORMAT_PATTERNS, 1, true) then
				-- Found the pattern (case-insensitive search)
				vim.api.nvim_buf_set_var(buf, 'autoformat', false)
				break
			end
		end
	end,
})
--]]

vim.api.nvim_create_autocmd({ 'BufEnter', 'FileType' }, {
	group = augroup 'disable_completion',
	callback = function(ev)
		local filetype = vim.bo[ev.buf].filetype
		---@diagnostic disable-next-line: inject-field
		if const.filetype.ignored_map[filetype] then vim.b.completion = false end
	end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
	group = augroup 'checktime',
	callback = function()
		if vim.o.buftype ~= 'nofile' then vim.cmd 'checktime' end
	end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
	group = augroup 'resize_splits',
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd 'tabdo wincmd ='
		vim.cmd('tabnext ' .. current_tab)
	end,
})

-- Go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
	group = augroup 'last_loc',
	callback = function(ev)
		local buf = ev.buf
		local filetype = vim.bo[ev.buf].filetype
		if const.filetype.ignored_map[filetype] or vim.b[buf].lazyvim_last_loc then return end
		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
	group = augroup 'close_with_q',
	pattern = const.filetype.ignored_list,
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.schedule(function()
			local opts = { buffer = event.buf, silent = true, desc = 'Quit buffer' }
			local func = function()
				vim.cmd 'close'
				pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
			end

			map('n', 'q', func, opts)
			map('n', '<c-q>', func, opts)
		end)
	end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd('FileType', {
	group = augroup 'man_unlisted',
	pattern = 'man',
	callback = function(event) vim.bo[event.buf].buflisted = false end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd('FileType', {
	group = augroup 'wrap_spell',
	pattern = { 'text', 'plaintex', 'typst', 'gitcommit' },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

vim.api.nvim_create_autocmd('FileType', {
	group = augroup 'lang_json',
	pattern = { 'json', 'jsonc', 'json5' },
	callback = function()
		vim.opt_local.conceallevel = 0
		vim.opt_local.wrap = false
		vim.opt_local.spell = false
	end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
	group = augroup 'auto_create_dir',
	callback = function(event)
		if event.match:match '^%w%w+:[\\/][\\/]' then return end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
	end,
})

vim.api.nvim_create_autocmd('FileType', {
	group = augroup 'oil_win_options',
	pattern = 'oil',
	callback = function() vim.opt.signcolumn = 'yes:2' end,
})
