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

		local map = function(m, l, r) vim.keymap.set(m, l, r, { buffer = e.buf, silent = true }) end
		map('n', '<c-q>', '<cmd>quit <cr>')
		map('n', '<c-s>', '<cmd>write | quit <cr>')
	end,
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd('FileType', {
	group = augroup 'no_conceal',
	pattern = { 'json', 'jsonc', 'markdown' },
	callback = function(e)
		vim.opt.conceallevel = 0
		vim.opt.wrap = false
	end,
})

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd('InsertLeave', {
	group = augroup 'no_paste',
	pattern = '*',
	command = 'set nopaste',
})

vim.api.nvim_create_autocmd('FileType', {
	group = augroup 'ts_config',
	pattern = { 'astro', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
	callback = function()
		vim.opt.tabstop = 2
		vim.opt.softtabstop = 2
		vim.opt.shiftwidth = 2
	end,
})
