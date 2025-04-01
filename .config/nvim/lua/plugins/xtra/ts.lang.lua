---@module 'lazy'
---@type table<number, LazyPluginSpec>
return {
	{ -- better ts error ui
		'OlegGulevskyy/better-ts-errors.nvim',
		priority = 1000,
		ft = { 'typescript', 'typescriptreact' },
		opts = {
			keymaps = {
				toggle = '<leader>dd', -- default '<leader>dd'
				go_to_definition = '<leader>dx', -- default '<leader>dx'
			},
		},
	},

	{ -- Typescript type debug
		'marilari88/twoslash-queries.nvim',
		ft = { 'typescript', 'typescriptreact' },
		opts = {
			multi_line = true,
			is_enabled = true,
			highlight = 'Comment',
		},
	},
}
