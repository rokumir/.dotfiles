return {
	'folke/snacks.nvim',
	keys = {
		{'<f2>D', function()Snacks.dashboard()end, desc = 'Open Snacks Dashboard'},
	},
	---@module 'snacks'
	---@type snacks.Config
	opts = {
		dashboard = {
			enabled = true,
			preset = {
				---@type snacks.dashboard.Item[]
				keys = {
					{ icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
					{ icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
					{
						icon = ' ',
						key = 'c',
						desc = 'Open Config',
						action = function()
							vim.fn.chdir(vim.fn.stdpath 'config', 'global')
							vim.schedule(function() Snacks.picker.files { layout = 'vscode_focus' } end)
						end,
					},
					{ icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy' },
					{ icon = ' ', key = 'Q', desc = 'Quit', action = 'ZZ' },
				},
			},
			sections = {
				{ pane = 2, section = 'terminal', cmd = 'macchina', random = 100, ttl = 0, height = 13 },
				{ section = 'keys', gap = 1, padding = 1 },
				{ icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 2 },
				{ section = 'startup' },
			},
		},
	},
}
