---@diagnostic disable: missing-parameter
---@type snacks.dashboard.Item[]
local sep_line_text = { { ('─'):rep(20), hl = 'WinSeparator', align = 'center' } }

local header = {
	'                                                                       ',
	'                                                                       ',
	'                                                                     ',
	'       ████ ██████           █████      ██                     ',
	'      ███████████             █████                             ',
	'      █████████ ███████████████████ ███   ███████████   ',
	'     █████████  ███    █████████████ █████ ██████████████   ',
	'    █████████ ██████████ █████████ █████ █████ ████ █████   ',
	'  ███████████ ███    ███ █████████ █████ █████ ████ █████  ',
	' ██████  █████████████████████ ████ █████ █████ ████ ██████ ',
	'                                                                       ',
	'                                                                       ',
}

return {
	'folke/snacks.nvim',
	keys = {
		{ '<f2><f2>', '<cmd>lua Snacks.dashboard(); vim.cmd.stopinsert() <cr>', desc = 'Open Snacks Dashboard' },
	},
	---@module 'snacks'
	---@type snacks.Config
	opts = {
		dashboard = {
			enabled = true,
			preset = {
				---@type snacks.dashboard.Item[]
				keys = {
					{ icon = '󰑏 ', key = 's', desc = 'Restore Session', section = 'session' },
					{ icon = ' ', key = 'c', desc = 'Open Config', action = ":tcd `=stdpath('config')`" },
					{ icon = ' ', key = 'Q', desc = 'Quit', action = 'ZZ' },
				},
			},
			sections = {
				{ text = { { table.concat(header, '\n'), hl = 'Tag' } } }, -- Header with highlight color
				{ section = 'keys' },
				{ text = sep_line_text },
				{ section = 'projects', icon = ' ', title = 'Projects', indent = 4, limit = 5, session = true },
				{ text = sep_line_text },
				{
					section = 'recent_files',
					icon = ' ',
					title = 'Recent Files',
					padding = 1,
					indent = 4,
					limit = 4,
					cwd = true,
				},
				{ section = 'startup', align = 'center' },
			},
		},
	},
}
