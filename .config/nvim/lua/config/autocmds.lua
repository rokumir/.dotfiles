local map = require('nihil.keymap').map
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

		map { 'n', '<c-q>', '<cmd>quit <cr>', buf = e.buf }
		map { 'n', '<c-s>', '<cmd>write | quit <cr>', buf = e.buf }
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
