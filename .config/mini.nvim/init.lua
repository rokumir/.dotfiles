-- ==========================================
-- Options & Appearance
-- ==========================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--- Behavior
vim.opt.backup = false
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.clipboard = ""
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.mouse = "n"
vim.opt.mousefocus = true
vim.opt.smoothscroll = true
vim.opt.timeoutlen = 500
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
vim.opt.wrap = false
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
vim.opt.laststatus = 0 -- (0 = never show)
vim.opt.statusline = " "
vim.opt.pumblend = 0
vim.opt.relativenumber = true
vim.opt.scrolloff = 6
vim.opt.showtabline = 1
vim.opt.splitbelow = true
vim.opt.splitkeep = "cursor"
vim.opt.splitright = true
vim.opt.winblend = 0

--- Search
vim.opt.hlsearch = true
vim.opt.ignorecase = true -- case insensitive searching UNLESS /C or capital in search
vim.opt.path:append({ "**" }) -- Finding files - Search down into subfolders
vim.opt.wildignore:append({ "*/node_modules/*" })

-- Transparent background
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		vim.api.nvim_set_hl(0, "NonText", { bg = "none" })
	end,
})
-- Trigger it immediately in case no colorscheme is explicitly loaded
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NonText", { bg = "none" })

-- ==========================================
-- Treesitter
-- ==========================================
vim.pack.add({ { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = vim.version.range("*") } })
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"javascript",
		"typescript",
		"python",
		"c",
		"lua",
		"vim",
		"vimdoc",
		"query",
		"htmldjango",
		"gdscript",
		"godot_resource",
		"gdshader",
		"fish",
		"bash",
	},
	sync_install = false,
	auto_install = true,
	ignore_install = {},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

-- ==========================================
-- Keymaps
-- ==========================================
vim.pack.add({ "https://github.com/folke/which-key.nvim" })
local wk = require("which-key")
wk.setup({
	win = { border = "rounded" },
	layout = { spacing = 4 },
	preset = "helix",
	keys = {
		scroll_down = "<a-J>",
		scroll_up = "<a-K>",
	},
})
wk.add({
	-- Go to line start/end
	{ "H", "^", mode = { "n", "v", "o" } },
	{ "L", "$", mode = { "n", "v", "o" } },

	-- Better "Goto Bottom"
	{ "G", "Gzz", mode = { "n", "v" }, nowait = true },

	-- Move by visual lines rather than physical lines
	{ "j", [[v:count == 0 ? 'gj' : 'j']], mode = { "n", "x" }, expr = true },
	{ "k", [[v:count == 0 ? 'gk' : 'k']], mode = { "n", "x" }, expr = true },

	-- Move by 5 lines
	{ "<c-k>", "5k", mode = { "n", "v" }, nowait = true },
	{ "<c-j>", "5j", mode = { "n", "v" }, nowait = true },

	-- Better search navigation (center results)
	{ "n", [['Nn'[v:searchforward].'zzzv']], expr = true, desc = "Next Search Result" },
	{ "N", [['nN'[v:searchforward].'zzzv']], expr = true, desc = "Prev Search Result" },
	{ "n", [['Nn'[v:searchforward].'zz']], mode = { "x", "o" }, expr = true, desc = "Next Search Result" },
	{ "N", [['nN'[v:searchforward].'zz']], mode = { "x", "o" }, expr = true, desc = "Prev Search Result" },

	{ "<c-q>", "<c-c>", mode = "c", desc = "Quit CommandLine" },

	{
		nowait = true,
		mode = { "o", "n", "s", "x" },
		{ ",s", '"+', desc = "System Clipboard Register" },
		{ ",sp", '"+p', desc = "System Clipboard Register" },
		{ ",sP", '"+P', desc = "System Clipboard Register" },
	},
})
