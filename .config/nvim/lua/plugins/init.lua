---@module 'lazy'
---@type LazyPluginSpec[]
return {
	{ -- npm package management
		'mason.nvim',
		optional = true,
		keys = function() return {} end,
		opts = {
			ui = { border = 'rounded' },
			ensure_installed = {
				'stylua',
			},
		},
	},

	{ -- keymaps helper
		'which-key.nvim',
		lazy = false,
		optional = true,
		priority = 1000,
		opts = {
			win = { border = 'rounded' },
			layout = { spacing = 4 },
		},
	},

	{ -- sessions manager
		'persistence.nvim',
		opts = {
			options = { 'globals' },
			pre_save = function() vim.api.nvim_exec_autocmds('User', { pattern = 'SessionSavePre' }) end,
		},
	},
}
