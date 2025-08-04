vim.g.mapleader = ' '
vim.g.autoformat = false
vim.g.lazyvim_picker = 'snacks'
vim.g.trouble_lualine = true -- disable navic in lualine

vim.opt.background = 'dark'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.clipboard = ''
vim.opt.path:append { '**' } -- Finding files - Search down into subfolders
vim.opt.wildignore:append { '*/node_modules/*' }
vim.opt.formatoptions:append { 'r' } -- Add asterisks in block comments
vim.opt.backup = false
vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }
vim.opt.relativenumber = true
vim.opt.ignorecase = true -- case insensitive searching UNLESS /C or capital in search
vim.opt.hlsearch = true
vim.opt.timeoutlen = 500
vim.opt.showtabline = 1
vim.opt.scrolloff = 6
vim.opt.inccommand = 'split'
vim.opt.splitkeep = 'screen'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = 'cursor'
vim.opt.winblend = 0
vim.opt.pumblend = 0
vim.opt.guicursor:append { 'n-i-r:blinkwait700-blinkon500-blinkoff500' }
vim.opt.mouse = 'n'
vim.opt.mousefocus = true
vim.opt.smoothscroll = true
vim.opt.cursorline = false
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'
vim.opt.wrap = false
-- vim.opt.colorcolumn = '80,120'
vim.opt.conceallevel = 0
vim.opt.spell = false

vim.opt.smarttab = true
vim.opt.expandtab = false
-- vim.opt.shiftwidth = 2
-- vim.opt.tabstop = 2
vim.opt.showbreak = ''
vim.opt.linebreak = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.breakindentopt = { 'shift:4', 'min:40', 'sbr' }
vim.opt.backspace = { 'start', 'eol', 'indent' }
vim.opt.complete = ''
vim.opt.completeopt = ''
vim.opt.laststatus = 3
