---@diagnostic disable: no-unknown
return {
	{ -- Delimiter pairs
		'windwp/nvim-autopairs',
		event = 'InsertEnter',
		opts = { disable_in_visualblock = true },
	},

	{ -- Delimiter pairs surroundability
		'kylechui/nvim-surround',
		version = false,
		lazy = false,
		keys = {
			{ 'sa', desc = 'Add Surround', mode = { 'v', 'n' } },
			{ 'sc', desc = 'Delete Surround', mode = { 'v', 'n' } },
			{ 'sd', desc = 'Change Surround' },
		},
		opts = {
			keymaps = {
				visual = 'sa',
				change = 'sc',
				delete = 'sd',
				insert = false,
				insert_line = false,
				normal = false,
				normal_cur = false,
				normal_line = false,
				normal_cur_line = false,
				visual_line = false,
				change_line = false,
			},
		},
	},

	{ -- Tabout
		'kawre/neotab.nvim',
		event = 'InsertEnter',
		opts = {
			tabkey = '<tab>',
			behavior = 'nested',
			pairs = {
				{ open = '(', close = ')' },
				{ open = '[', close = ']' },
				{ open = '{', close = '}' },
				{ open = "'", close = "'" },
				{ open = '"', close = '"' },
				{ open = '`', close = '`' },
				{ open = '<', close = '>' },
				{ open = '/', close = '/' },
				{ open = ',', close = ',' },
				{ open = ';', close = ';' },
			},
		},
	},

	{ -- better rename
		'saecki/live-rename.nvim',
		priority = 1000,
		event = 'VeryLazy',
		opts = {
			prepare_rename = true,
			request_timeout = 2000,
			show_other_ocurrences = true,
			use_patterns = true,
			keys = {
				submit = {
					{ 'n', '<cr>' },
					{ 'v', '<cr>' },
					{ 'i', '<cr>' },
					{ 'n', '<c-j>' },
					{ 'v', '<c-j>' },
					{ 'i', '<c-j>' },
					{ 'n', '<c-l>' },
					{ 'v', '<c-l>' },
					{ 'i', '<c-l>' },
				},
				cancel = {
					{ 'n', '<esc>' },
					{ 'n', 'q' },
					{ 'n', '<c-q>' },
					{ 'v', '<c-q>' },
					{ 'i', '<c-q>' },
				},
			},
			hl = {
				current = 'CurSearch',
				others = 'Search',
			},
		},
	},

	{ -- NOTE: DEPRECATED in favor of custom made plugin
		-- Convert color likes hex to smth else
		'cjodo/convert.nvim',
		enabled = false,
		cond = false,
		dependencies = 'MunifTanjim/nui.nvim',
		ft = { 'lua', 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'json', 'yaml', 'html', 'css', 'scss', 'less', 'markdown' },
		keys = {
			{ '<a-c><a-n>', '<cmd>ConvertFindNext <cr>', desc = 'Color Convertor: Find next' },
			{ '<a-c><a-c>', '<cmd>ConvertFindCurrent <cr>', desc = 'Color Convertor: Find current line' },
			{ '<a-c><a-a>', '<cmd>ConvertAll <cr>', desc = 'Color Convertor: Convert all' },
		},
		opts = {
			keymaps = {
				focus_next = { 'j', '<down>' },
				focus_prev = { 'k', '<up>' },
				close = { '<esc>', '<c-c>', '<c-q>' },
				submit = { '<cr>', '<space>', 'l' },
			},
		},
	},
}
