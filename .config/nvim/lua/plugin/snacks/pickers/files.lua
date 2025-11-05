return {
	'folke/snacks.nvim',
	keys = {
		{ '<c-e>', function() Snacks.picker.files() end, desc = 'Find Files' },
		{ ';ff', function() Snacks.picker.files() end, desc = 'Find Files' },
		{ ';fF', function() Snacks.picker.files { layout = 'default' } end, desc = 'Files (with preview)' },
		{ ';r', function() Snacks.picker.recent { filter = { cwd = true } } end, desc = 'Recent' },
	},
	---@type snacks.Config
	opts = {
		picker = {
			sources = {
				files = {
					cmd = 'rg',
					args = { '--sortr', 'modified' },
					filter = { cwd = true },
					transform = 'unique_file',
					layout = 'vscode_focus',
				},

				smart = {
					multi = { 'recent', 'files' },
					sort = { fields = { 'recent', 'sort', 'score:desc', 'idx' } },
					filter = { cwd = true },
					matcher = {
						fuzzy = true,
						filename_bonus = true,
						history_bonus = true,
						ignorecas = true,
						smartcase = true,
						cwd_bonus = true, -- boost cwd matches
						frecency = false, -- use frecency boosting
						sort_empty = true, -- sort even when the filter is empty
					},
					transform = 'unique_file',
				},
			},
		},
	},
}
