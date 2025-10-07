local ft_config = require 'config.const.filetype'
local map = require('utils.keymap').map

local function augroup(name) return vim.api.nvim_create_augroup('nihil_' .. name, { clear = true }) end

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

		map { '<c-s>', '<cmd>write | quit <cr>', buffer = ev.buf }
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
	pattern = 'markdown',
	callback = function()
		vim.opt_local.wrap = false
		vim.opt_local.spell = false
		vim.opt_local.concealcursor = 'nv'
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

-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
	group = augroup 'q_easy_closing',
	pattern = ft_config.ignored_list,
	callback = function(ev)
		local bufnr = ev.buf
		vim.bo[bufnr].buflisted = false
		local quit = function() require('utils.buffer').bufremove(bufnr, false) end
		vim.schedule(function()
			map {
				buffer = bufnr,
				{ 'q', quit },
				{ '<c-q>', quit },
			}
		end)
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
		if is_buffer_valid then require('utils.buffer').history:store(buf_path) end
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

if vim.g.neovide then
	-- FIX: Temporary https://github.com/neovide/neovide/issues/1331#issuecomment-1261545158
	vim.api.nvim_create_autocmd('UIEnter', {
		group = augroup 'clipboard_neovide_fix',
		callback = function()
			if (vim.v.event.chan or 0) > 1 then
				if vim.g.loaded_clipboard_provider then
					vim.g.loaded_clipboard_provider = nil
					vim.api.nvim_cmd({ cmd = 'runtime', args = { 'autoload/provider/clipboard.vim' } }, {})
				end
			end
		end,
	})
end
