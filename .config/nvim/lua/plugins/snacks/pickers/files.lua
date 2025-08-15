return {
	'folke/snacks.nvim',
	---@type snacks.Config
	opts = {
		picker = {
			sources = {
				files = {
					cmd = 'rg',
					args = { '--sortr', 'modified' },

					filter = { cwd = true },
					transform = 'unique_file',

					layout = {
						preset = 'default',
						preview = false, ---@diagnostic disable-line: assign-type-mismatch
						layout = {
							backdrop = { transparent = true, blend = 60 },
							row = 1,
							width = 0.4,
							min_width = 80,
							height = 0.7,
							border = 'none',
							box = 'vertical',
							{ win = 'input', height = 1, border = 'rounded', title = '{title} {live} {flags}', title_pos = 'center' },
							{ win = 'list', border = 'hpad' },
							{ win = 'preview', title = '{preview}', height = 0.3, border = 'top' },
						},
					},
				},

				smart = {
					multi = { 'recent', 'files' },
					format = 'file', -- use `file` format for all sources

					sort = {
						fields = { 'recent', 'sort', 'score:desc', 'idx' },
					},
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
