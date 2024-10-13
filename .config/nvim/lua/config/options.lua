vim.g.mapleader = ' '
vim.g.markdown_recommended_style = 0 -- Fix markdown indentation settings
vim.g.lazyvim_picker = 'fzf' -- fzf | telescope | auto

vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.clipboard = ''
vim.opt.path:append { '**' } -- Finding files - Search down into subfolders
vim.opt.wildignore:append { '*/node_modules/*' }
vim.opt.formatoptions:append { 'r' } -- Add asterisks in block comments
vim.opt.backup = false
vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }
vim.opt.relativenumber = false
vim.opt.ignorecase = true -- case insensitive searching UNLESS /C or capital in search
vim.opt.hlsearch = true
vim.opt.timeoutlen = 500
vim.opt.showtabline = 1
vim.opt.scrolloff = 6
vim.opt.inccommand = 'split'
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
vim.opt.wrap = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.showbreak = ''
vim.opt.linebreak = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.breakindentopt = { 'shift:4', 'min:40', 'sbr' }
vim.opt.backspace = { 'start', 'eol', 'indent' }
