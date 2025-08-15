return {
	{
		'folke/snacks.nvim',
		keys = {
			{ '<c-/>', function() Snacks.terminal() end, desc = 'Terminal (cwd)' },
			{ '<c-_>', function() Snacks.terminal() end, desc = 'Terminal (cwd)' },
			{ '<c-`>', function() Snacks.terminal() end, desc = 'Terminal (cwd)' },
		},
		---@type snacks.Config
		opts = {
			terminal = {
				win = {
					style = 'terminal',
					actions = {
						term_toggle = function() Snacks.terminal.toggle() end,
					},
					keys = {
						['<c-/>'] = { 'term_toggle', expr = true, mode = 't', desc = 'Toggle Terminal' },
						['<c-_>'] = { 'term_toggle', expr = true, mode = 't', desc = 'Toggle Terminal' },
						['<c-`>'] = { 'term_toggle', expr = true, mode = 't', desc = 'Toggle Terminal' },
					},
				},
			},
		},
	},
	{
		'folke/snacks.nvim',
		---@param opts snacks.Config
		opts = function(_, opts)
			opts.terminal.win.keys.nav_h[1] = '<a-H>'
			opts.terminal.win.keys.nav_j[1] = '<a-J>'
			opts.terminal.win.keys.nav_k[1] = '<a-K>'
			opts.terminal.win.keys.nav_l[1] = '<a-L>'
		end,
	},
}
