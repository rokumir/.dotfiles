---------------------------------------------
-- Treesitter
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

---------------------------------------------
-- ANSI Escape Parsing
vim.pack.add({ { src = "https://github.com/m00qek/baleia.nvim", version = vim.version.range("*") } })
vim.api.nvim_create_autocmd("StdinReadPost", {
	pattern = "*",
	callback = function(ev)
		local baleia = require("baleia").setup({ line_starts_at = 1 })
		baleia.once(ev.buf)
	end,
})
