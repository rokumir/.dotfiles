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

vim.api.nvim_create_autocmd('FileType', {
	group = augroup 'strip_of_unneccessary_features',
	pattern = { 'json', 'jsonc', 'json5', 'markdown', 'mdx' },
	command = [[
		set conceallevel=0
		set nowrap
		set nospell
	]],
})

vim.api.nvim_create_autocmd('FileType', {
	group = augroup 'plugin_ft_oil',
	pattern = 'oil',
	command = 'set signcolumn=yes:2',
})

vim.api.nvim_create_autocmd('FileType', {
	group = augroup 'disable_folding',
	pattern = ft_config.ignored_list,
	command = [[
		set nofoldenable
		set foldcolumn=0
	]],
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

-- Go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
	group = augroup 'last_loc',
	callback = function(ev)
		local buf = ev.buf
		local ft = vim.bo[buf].filetype
		if ft_config.ignored_map[ft] or vim.b[buf].lazyvim_last_loc then return end

		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
	end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
	callback = function(event)
		local exclude = { 'gitcommit' }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then return end
		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
	end,
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
		local buf = ev.buf
		local bo = vim.bo[buf]
		local path = vim.api.nvim_buf_get_name(buf)

		local is_buffer_valid = vim.api.nvim_buf_is_valid(buf) and bo.modifiable and #path > 0 and not ft_config.ignored_map[bo.filetype]
		if is_buffer_valid then require('util.buffer').history:store(path) end
	end,
})

vim.api.nvim_create_autocmd('DirChanged', {
	group = augroup 'notify_dir_changed',
	callback = function()
		local cwd = vim.uv.cwd():gsub('^' .. vim.env.HOME, '~')
		Snacks.notify { '**Changed Directory:**', '**[' .. cwd .. ']**' }
	end,
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
