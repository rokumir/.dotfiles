--- Globals
vim.g.autoformat = false
vim.g.lazyvim_picker = 'snacks'
vim.g.lsp_doc_max_size = 50
vim.g.mapleader = ' '
vim.g.trouble_lualine = true -- disable navic in lualine

local opt = vim.opt

--- Behavior
opt.backup = false
opt.backupskip = { '/tmp/*', '/private/tmp/*' }
opt.backspace = { 'start', 'eol', 'indent' }
opt.clipboard = ''
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'
opt.mouse = 'n'
opt.mousefocus = true
opt.smoothscroll = true
opt.timeoutlen = 500

--- Editing & Text
opt.autoindent = true
opt.breakindent = true
opt.breakindentopt = { 'shift:4', 'min:40', 'sbr' }
opt.complete = ''
opt.completeopt = ''
opt.expandtab = false
opt.formatoptions:append { 'r' } -- Add asterisks in block comments
opt.linebreak = true
-- opt.shiftwidth = 2
opt.showbreak = ''
opt.smartindent = true
opt.smarttab = true
opt.spell = false
-- opt.tabstop = 2
opt.wrap = false

--- UI & Appearance
opt.background = 'dark'
-- opt.colorcolumn = '80,120'
opt.concealcursor = 'ivc'
opt.conceallevel = 0
opt.cursorline = true
opt.cursorlineopt = 'number'
opt.guicursor:append { 'n-i-r:blinkwait700-blinkon500-blinkoff500' }
opt.inccommand = 'split'
opt.laststatus = 3
opt.pumblend = 0
opt.relativenumber = true
opt.scrolloff = 6
opt.showtabline = 1
opt.splitbelow = true
opt.splitkeep = 'cursor'
opt.splitright = true
opt.winblend = 0

--- Search
opt.hlsearch = true
opt.ignorecase = true -- case insensitive searching UNLESS /C or capital in search
opt.path:append { '**' } -- Finding files - Search down into subfolders
opt.wildignore:append { '*/node_modules/*' }
