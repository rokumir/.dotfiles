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

	{ -- Copilot code completion
		'zbirenbaum/copilot.lua',
		priority = 1000,
		lazy = false,
		keys = {
			{ '<leader><leader>ai', '<cmd>Copilot toggle <cr>', silent = true, desc = 'Toggle Copilot' },
		},
		opts = {
			panel = { enabled = false },
			suggestion = {
				enabled = true,
				auto_trigger = true,
				hide_during_completion = true,
				debounce = 75,
				keymap = {
					accept = '<m-h>',
					accept_word = '<m-l>',
					accept_line = '<m-L>',
					next = '<m-]>',
					prev = '<m-[>',
					dismiss = '<c-[>',
				},
			},
		},
	},

	{ -- Bizarre markdown ui rendering
		'MeanderingProgrammer/render-markdown.nvim',
		ft = { 'markdown', 'codecompanion' },
		cmd = 'RenderMarkdown',
		keys = { { '<leader><leader>M', '<cmd>RenderMarkdown toggle <cr>', desc = 'Toggle Render Markdown' } },
	},
	{
		'olimorris/codecompanion.nvim',
		dependencies = {
			{ 'github/copilot.vim', lazy = true, commands = 'Copilot' },
		},
		keys = {
			{ '<a-L>', '<cmd>CodeCompanionActions <cr>', mode = { 'n', 'v' }, desc = 'CodeCompanion Action Menu' },
			{ '<leader><leader>ac', '<cmd>CodeCompanionChat Toggle <cr>', mode = { 'n', 'v' }, desc = 'Toggle CodeCompanion Chat' },
		},
		config = true,
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
}
