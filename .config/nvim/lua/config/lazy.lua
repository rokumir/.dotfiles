local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazypath,
	}
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
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
				},
			},
		},

		-- import any extras modules here
		{ import = 'lazyvim.plugins.extras.editor.refactoring' },
		{ import = 'lazyvim.plugins.extras.editor.dial' },
		{ import = 'lazyvim.plugins.extras.coding.neogen' },
		{ import = 'lazyvim.plugins.extras.coding.blink' },
		-- { import = 'lazyvim.plugins.extras.coding.yanky' },

		{ import = 'lazyvim.plugins.extras.linting.eslint' },
		{ import = 'lazyvim.plugins.extras.formatting.prettier' },

		{ import = 'lazyvim.plugins.extras.dap.core' },
		{ import = 'lazyvim.plugins.extras.lang.typescript' },
		{ import = 'lazyvim.plugins.extras.lang.json' },
		{ import = 'lazyvim.plugins.extras.lang.tailwind' },
		-- { import = 'lazyvim.plugins.extras.lang.astro' },
		-- { import = 'lazyvim.plugins.extras.lang.omnisharp' },
		-- { import = 'lazyvim.plugins.extras.lang.svelte' },

		{ import = 'lazyvim.plugins.extras.util.dot' },

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
