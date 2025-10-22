---@diagnostic disable: missing-parameter
---@type snacks.dashboard.Item[]
local sep_line_text = { { ('─'):rep(20), hl = 'WinSeparator', align = 'center' } }
local open_dashboard = function()
	Snacks.dashboard.open()
	vim.cmd.stopinsert()
end

return {
	'folke/snacks.nvim',
	keys = {
		{ '<f2>D', open_dashboard, desc = 'Open Snacks Dashboard' },
		{ '<leader><f2>', open_dashboard, desc = 'Open Snacks Dashboard' },
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
					{ icon = ' ', key = 'c', desc = 'Open Config', action = ":cd `=stdpath('config')` | lua Snacks.picker.files()" },
					{ icon = ' ', key = 'Q', desc = 'Quit', action = 'ZZ' },
				},
			},
			sections = {
				{ pane = 2, section = 'terminal', cmd = "macchina | awk 'NR >= 12 { print }'", align = 'center', height = 12, padding = 1 },
				{ section = 'keys', gap = 1, padding = 1 },
				{ text = sep_line_text, enabled = function() return #Snacks.dashboard.sections.projects { session = true } > 0 end },
				{ section = 'projects', icon = ' ', title = 'Projects', indent = 4, limit = 5, session = true },
				{ text = sep_line_text, enabled = function() return #Snacks.dashboard.sections.recent_files { cwd = true }() > 0 end },
				{ section = 'recent_files', icon = ' ', title = 'Recent Files', padding = 1, indent = 4, limit = 4, cwd = true },
				{ section = 'startup', align = 'center' },
			},
		},
	},
}
