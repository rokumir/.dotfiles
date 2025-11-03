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
	spec = {
		{
			'LazyVim/LazyVim',
			version = false,
			import = 'lazyvim.plugins',
			opts = {
				colorscheme = 'rose-pine',
				defaults = { keymaps = false, autocmds = false },
				news = { lazyvim = true, neovim = true },
			},
		},

		--#region Extras modules
		{ import = 'lazyvim.plugins.extras.editor.snacks_picker' },
		{ import = 'lazyvim.plugins.extras.editor.snacks_explorer' },
		{ import = 'lazyvim.plugins.extras.editor.refactoring' },
		{ import = 'lazyvim.plugins.extras.editor.dial' },
		{ import = 'lazyvim.plugins.extras.editor.navic' },

		{ import = 'lazyvim.plugins.extras.util.dot' },

		{ import = 'lazyvim.plugins.extras.lang.typescript' },
		{ import = 'lazyvim.plugins.extras.lang.json' },
		{ import = 'lazyvim.plugins.extras.lang.tailwind' },
		-- { import = 'lazyvim.plugins.extras.lang.rust' },
		-- { import = 'lazyvim.plugins.extras.lang.go' },
		-- { import = 'lazyvim.plugins.extras.lang.astro' },
		-- { import = 'lazyvim.plugins.extras.lang.omnisharp' },
		-- { import = 'lazyvim.plugins.extras.lang.svelte' },

		{ import = 'lazyvim.plugins.extras.coding.mini-surround' },
		{ import = 'lazyvim.plugins.extras.coding.blink' },
		{ import = 'lazyvim.plugins.extras.coding.neogen' },
		{ import = 'lazyvim.plugins.extras.dap.core' },

		-- { import = 'lazyvim.plugins.extras.linting.eslint' },
		{ import = 'lazyvim.plugins.extras.formatting.biome' },
		{ import = 'lazyvim.plugins.extras.formatting.prettier' },

		-- { import = 'lazyvim.plugins.extras.ui.edgy' },

		{ import = 'lazyvim.plugins.extras.ai.sidekick' },
		--#endregion

		-- user settings
		{ import = 'plugin' },
	},
	defaults = {
		-- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
		-- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
		lazy = false,
		version = false, -- always use the latest git commit
	},
	ui = { border = 'rounded' },
	rocks = { enabled = false },
	checker = { enabled = false }, -- auto updates
	performance = {
		cache = { enabled = true },
		rtp = { -- disable some rtp plugins
			disabled_plugins = {
				'gzip',
				'netrwPlugin',
				'tarPlugin',
				'tohtml',
				'tutor',
				'zipPlugin',
			},
		},
	},
}
