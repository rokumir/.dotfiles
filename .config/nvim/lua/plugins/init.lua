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
			keys = {
				scroll_down = '<a-J>',
				scroll_up = '<a-K>',
			},
		},
	},

	{ -- sessions manager
		'persistence.nvim',
		optional = true,
		opts = {
			options = { 'globals' },
			pre_save = function() vim.api.nvim_exec_autocmds('User', { pattern = 'SessionSavePre' }) end,
		},
		keys = {
			{ '<leader>qQ', function() require('persistence').save() end, desc = 'Save Session' },
		},
	},
}
