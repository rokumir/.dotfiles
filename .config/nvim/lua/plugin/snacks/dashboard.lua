---@diagnostic disable: missing-parameter
---@type snacks.dashboard.Item[]
local sep_line_text = { { ('─'):rep(20), hl = 'WinSeparator', align = 'center' } }
local projects_exist_fn = function() return #Snacks.dashboard.sections.projects { session = true } > 0 end
local recents_exist_fn = function() return #Snacks.dashboard.sections.recent_files { cwd = true }() > 0 end
local note_dir = require('config.const.project_dirs').second_brain

return {
	'folke/snacks.nvim',
	keys = {
		{ '<f2><f2>', '<cmd>lua Snacks.dashboard.open() <cr><cmd>stopinsert <cr>', desc = 'Open Snacks Dashboard' },
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
					{ icon = ' ', key = 'c', desc = 'Open Config', action = ":cd `=stdpath('config')`" },
					{ icon = ' ', key = 'n', desc = 'Open Note', action = ':cd ' .. note_dir, enabled = note_dir ~= nil },
					{ icon = ' ', key = 'Q', desc = 'Quit', action = 'ZZ' },
				},
			},
			sections = {
				{ pane = 2, section = 'terminal', cmd = 'macchina', align = 'center', height = 12, padding = 1 },
				{ section = 'keys' },
				{ text = sep_line_text, enabled = projects_exist_fn },
				{ section = 'projects', icon = ' ', title = 'Projects', indent = 4, limit = 5, session = true },
				{ text = sep_line_text, enabled = recents_exist_fn },
				{ section = 'recent_files', icon = ' ', title = 'Recent Files', padding = 1, indent = 4, limit = 4, cwd = true },
				{ section = 'startup', align = 'center' },
			},
		},
	},
}
