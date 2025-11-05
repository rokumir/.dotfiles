local map = require('util.keymap').map
local ft_config = require 'config.const.filetype'
local augroup = require('util.autocmd').augroup

-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
	group = augroup 'close_with_q',
	pattern = ft_config.ignored_list,
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		local function quit_fn()
			vim.cmd 'close'
			pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
		end
		vim.schedule(function()
			map { 'q', quit_fn, buffer = event.buf, silent = true, desc = 'Quit buffer' }
			map { '<c-q>', quit_fn, buffer = event.buf, silent = true, desc = 'Quit buffer' }
		end)
	end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
	group = augroup 'checktime',
	callback = function()
		if vim.o.buftype ~= 'nofile' then vim.cmd 'checktime' end
	end,
})

vim.api.nvim_create_autocmd('TermOpen', {
	group = augroup 'term_startinsert',
	command = 'startinsert',
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ 'FileType' }, {
	group = augroup 'conceal',
	pattern = { 'markdown', 'mdx', 'json', 'jsonc', 'json5' },
	command = 'set conceallevel=0',
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd('VimResized', {
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
		local bufnr = ev.buf
		local filetype = vim.bo[bufnr].filetype
		if ft_config.ignored_map[filetype] or vim.b[bufnr].nihil_last_loc then return end

		vim.b[bufnr].nihil_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(bufnr, '"')
		local lcount = vim.api.nvim_buf_line_count(bufnr)
		if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
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

vim.api.nvim_create_autocmd('FileType', {
	group = augroup 'plugin_ft_oil',
	pattern = 'oil',
	callback = function() vim.opt.signcolumn = 'yes:2' end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd('BufWritePre', {
	group = augroup 'auto_create_dir',
	callback = function(event)
		if event.match:match '^%w%w+:[\\/][\\/]' then return end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
	end,
})

vim.api.nvim_create_autocmd('BufDelete', {
	group = augroup 'track_closed_buffers',
	callback = function(ev)
		local bufnr = ev.buf
		local bo = vim.bo[bufnr]
		local buf_path = vim.api.nvim_buf_get_name(bufnr)

		local is_buffer_valid = vim.api.nvim_buf_is_valid(bufnr) and bo.modifiable and #buf_path > 0 and not ft_config.ignored_map[bo.filetype]
		if is_buffer_valid then require('util.buffer').history:store(buf_path) end
	end,
})

vim.api.nvim_create_autocmd('FileType', {
	group = augroup 'disable_folding',
	pattern = ft_config.ignored_list,
	callback = function()
		vim.opt_local.foldenable = false
		vim.opt_local.foldcolumn = '0'
	end,
})

vim.api.nvim_create_autocmd('DirChanged', {
	group = augroup 'notify_dir_changed',
	callback = function() Snacks.notify { '**Changed Directory:**', '**[' .. vim.uv.cwd() .. ']**' } end,
})
