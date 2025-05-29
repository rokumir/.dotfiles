---@module 'lazy'
---@type table<number, LazyPluginSpec>
return {
	{
		'williamboman/mason.nvim',
		opts = {
			ui = { border = 'rounded' },
			ensure_installed = {
				'stylua',
			},
		},
	},

	{ -- keymaps helper
		'folke/which-key.nvim',
		event = 'VeryLazy',
		opts = {
			win = { border = 'rounded' },
			default = {
				mode = { 'n', 'v' },
				{ '<leader>r', group = 'refactor', icon = '' },
				{ '<leader>m', group = 'menu', icon = '󰒲' },
				{ '<leader>!', group = 'shell', icon = '' },
				{ '<leader><leader>', group = 'toggle' },
				{ '<leader><leader>a', group = 'AI' },
				{ '<leader><tab>', group = 'tab' },
				{ '<leader>b', group = 'buffer' },
				{ '<leader>c', group = 'code' },
				{ '<leader>g', group = 'git' },
				{ '<leader>gh', group = 'hunks' },
				{ '<leader>n', group = 'notify' },
				{ '<leader>s', group = 'search' },
				{ '<leader>u', group = 'ui' },
				{ '<leader>x', group = 'diagnostics/quickfix' },
				{ '[', group = 'prev' },
				{ ']', group = 'next' },
				{ 'g', group = 'goto' },
			},
		},
	},
}
