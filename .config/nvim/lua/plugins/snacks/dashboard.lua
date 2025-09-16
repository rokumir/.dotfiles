return {
	{
		'folke/snacks.nvim',
		---@type snacks.Config
		opts = {
			dashboard = {
				enabled = true,
				preset = {
					---@type snacks.dashboard.Item[]
					keys = {
						{ icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
						{ icon = ' ', key = 'p', desc = 'Projects', action = 'lua Snacks.picker.projects()' },
						{ icon = ' ', key = 's', desc = 'Restore Session', section = 'session', action = 'lua require("persistence").load()' },
						{ icon = ' ', key = 'x', desc = 'Lazy Extras', action = ':LazyExtras' },
						{ icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy' },
						{ icon = '󰒲 ', key = 'L', desc = 'Update Lazy', action = ':Lazy update' },
						{ icon = ' ', key = 'Q', desc = 'Quit', action = 'ZZ' },
					},
				},
			},
		},
	},
}
