local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then vim.fn.system {
	'git',
	'clone',
	'--filter=blob:none',
	'https://github.com/folke/lazy.nvim.git',
	'--branch=stable',
	lazypath,
} end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
	---@diagnostic disable-next-line: assign-type-mismatch
	dev = {
		path = vim.fn.stdpath 'config' .. '/nihil',
		-- path = '~/.config/nvim/nihil',
		patterns = { 'nihil' },
		fallback = false,
	},
	spec = {
		{
			'LazyVim/LazyVim',
			import = 'lazyvim.plugins',
			opts = {
				colorscheme = 'rose-pine',
				news = {
					lazyvim = true,
					neovim = true,
				},
				defaults = {
					keymaps = false,
					autocmds = false,
				},
			},
		},

		--#region Disable default plugins
		{ 'folke/persistence.nvim', enabled = false },
		{ 'echasnovski/mini.pairs', enabled = false },
		-- { 'echasnovski/mini.ai', enabled = false },
		{ 'nvim-neo-tree/neo-tree.nvim', enabled = false },
		{ 'ibhagwan/fzf-lua', enabled = false },
		--#endregion

		--#region Extras modules
		{ import = 'lazyvim.plugins.extras.ui.edgy' },

		{ import = 'lazyvim.plugins.extras.editor.refactoring' },
		{ import = 'lazyvim.plugins.extras.editor.dial' },

		{ import = 'lazyvim.plugins.extras.util.dot' },

		-- { import = 'lazyvim.plugins.extras.lang.typescript' },
		{ import = 'lazyvim.plugins.extras.lang.tailwind' },
		{ import = 'lazyvim.plugins.extras.lang.json' },
		{ import = 'lazyvim.plugins.extras.lang.rust' },
		{ import = 'lazyvim.plugins.extras.lang.go' },
		{ import = 'lazyvim.plugins.extras.lang.astro' },
		-- { import = 'lazyvim.plugins.extras.lang.omnisharp' },
		-- { import = 'lazyvim.plugins.extras.lang.svelte' },

		{ import = 'lazyvim.plugins.extras.coding.neogen' },
		{ import = 'lazyvim.plugins.extras.coding.blink' },
		{ import = 'lazyvim.plugins.extras.coding.yanky' },
		{ import = 'lazyvim.plugins.extras.linting.eslint' },
		{ import = 'lazyvim.plugins.extras.formatting.biome' },
		{ import = 'lazyvim.plugins.extras.formatting.prettier' },
		-- { import = 'lazyvim.plugins.extras.dap.core' },

		{ import = 'lazyvim.plugins.extras.ai.copilot-chat' },
		--#endregion

		{ import = 'plugins' },
	},
	checker = { enabled = false }, -- automatically check for plugin updates
	performance = {
		cache = { enabled = true },
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				'gzip',
				-- "matchit",
				-- "matchparen",
				'netrwPlugin',
				'tarPlugin',
				'tohtml',
				'tutor',
				'zipPlugin',
			},
		},
	},
	ui = {
		border = 'rounded',
		backdrop = 0,
	},
}
