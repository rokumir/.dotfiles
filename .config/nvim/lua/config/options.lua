vim.g.mapleader = ' '
vim.g.lazyvim_picker = 'auto'
vim.g.lazyvim_blink_main = true

local _ = vim.opt

_.encoding = 'utf-8'
_.fileencoding = 'utf-8'
_.clipboard = ''
_.path:append { '**' } -- Finding files - Search down into subfolders
_.wildignore:append { '*/node_modules/*' }
_.formatoptions:append { 'r' } -- Add asterisks in block comments
_.backup = false
_.backupskip = { '/tmp/*', '/private/tmp/*' }
_.relativenumber = false
_.ignorecase = true -- case insensitive searching UNLESS /C or capital in search
_.hlsearch = true
_.timeoutlen = 500
_.showtabline = 1
_.scrolloff = 6
_.inccommand = 'split'
_.splitbelow = true
_.splitright = true
_.splitkeep = 'cursor'
_.winblend = 0
_.pumblend = 0
_.guicursor:append { 'n-i-r:blinkwait700-blinkon500-blinkoff500' }
_.mouse = 'n'
_.mousefocus = true
_.smoothscroll = true
_.cursorline = false
_.cursorline = true
_.cursorlineopt = 'number'
_.wrap = false
_.colorcolumn = '80,120'
_.conceallevel = 0

_.smarttab = true
_.expandtab = false
-- _.shiftwidth = 2
-- _.tabstop = 2
_.showbreak = ''
_.linebreak = true
_.autoindent = true
_.smartindent = true
_.breakindent = true
_.breakindentopt = { 'shift:4', 'min:40', 'sbr' }
_.backspace = { 'start', 'eol', 'indent' }

-- global statusline
_.laststatus = 3
vim.go.laststatus = 3
