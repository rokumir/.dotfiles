vim.g.mapleader = " "
vim.g.maplocalleader = " "

--- Behavior
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = false
vim.opt.syntax = "on" -- Standard syntax is often more stable for huge files than TS
vim.opt.lazyredraw = true -- Don't redraw screen while executing macros/scripts
vim.opt.shada = ""
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.clipboard = "unnamedplus"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.mouse = "n"
vim.opt.mousefocus = true
vim.opt.smoothscroll = true
vim.opt.timeoutlen = 500
vim.opt.listchars = { space = " " }
vim.opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}

--- Editing & Text
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.breakindentopt = { "shift:4", "min:40", "sbr" }
vim.opt.complete = ""
vim.opt.completeopt = ""
vim.opt.expandtab = false
vim.opt.formatoptions:append({ "r" }) -- Add asterisks in block comments
vim.opt.linebreak = true
-- vim.opt.shiftwidth = 2
vim.opt.showbreak = ""
vim.opt.smartindent = true
vim.opt.smarttab = true
-- vim.opt.tabstop = 2
vim.opt.wrap = false -- Usually better for diffs
vim.opt.spell = false

--- UI & Appearance
vim.opt.background = "dark"
-- vim.opt.colorcolumn = '80,120'
vim.opt.concealcursor = "ivc"
vim.opt.conceallevel = 0
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.guicursor:append({ "n-i-r:blinkwait700-blinkon500-blinkoff500" })
vim.opt.inccommand = "split"
vim.opt.foldcolumn = "0"
vim.opt.cmdheight = 0
vim.opt.laststatus = 0 -- (0 = never show)
vim.opt.statusline = " "
vim.opt.statuscolumn = ""
vim.opt.signcolumn = "no"
vim.opt.pumblend = 0
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.scrolloff = 5
vim.opt.showtabline = 0
vim.opt.splitbelow = true
vim.opt.splitkeep = "cursor"
vim.opt.splitright = true
vim.opt.winblend = 0

--- Search
vim.opt.hlsearch = true
vim.opt.ignorecase = true -- case insensitive searching UNLESS /C or capital in search
vim.opt.path:append({ "**" }) -- Finding files - Search down into subfolders
vim.opt.wildignore:append({ "*/node_modules/*" })
