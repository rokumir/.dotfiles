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
	{ "<c-q>", "<cmd>quitall!<cr>" },
	{ "ZZ", "<cmd>quitall!<cr>" },
	{ "<a-z>", "<cmd>set wrap!<cr>" },

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
