return {
	'folke/snacks.nvim',
	keys = {
		{ '<c-e>', function() Snacks.picker.files { layout = 'vscode_unfocus' } end, desc = 'Find Files' },
		{ ';ff', function() Snacks.picker.files() end, desc = 'Find Files' },
		{ ';fc', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = 'Find Config File' },
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
