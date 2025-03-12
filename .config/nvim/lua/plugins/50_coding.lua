---@diagnostic disable: no-unknown
---@type table<number, LazyPluginSpec>
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

	{ -- Refactoring (primeagen)
		'ThePrimeagen/refactoring.nvim',
		keys = function()
			return {
				{
					'<leader>rs',
					function()
						local fzf_lua = require 'fzf-lua'
						local results = require('refactoring').get_refactors()
						local refactoring = require 'refactoring'
						fzf_lua.fzf_exec(results, {
							fzf_opts = {},
							fzf_colors = true,
							actions = {
								['default'] = function(selected) refactoring.refactor(selected[1]) end,
							},
						})
					end,
					mode = 'v',
					desc = 'Refactor',
				},
				{ '<leader>ri', function() require('refactoring').refactor 'Inline Variable' end, mode = { 'n', 'v' }, desc = 'Inline Variable' },
				{ '<leader>rb', function() require('refactoring').refactor 'Extract Block' end, desc = 'Extract Block' },
				{ '<leader>rf', function() require('refactoring').refactor 'Extract Block To File' end, desc = 'Extract Block To File' },
				{ '<leader>rf', function() require('refactoring').refactor 'Extract Function' end, mode = 'v', desc = 'Extract Function' },
				{ '<leader>rF', function() require('refactoring').refactor 'Extract Function To File' end, mode = 'v', desc = 'Extract Function To File' },
				{ '<leader>rx', function() require('refactoring').refactor 'Extract Variable' end, mode = 'v', desc = 'Extract Variable' },
				{ '<leader>rp', function() require('refactoring').debug.print_var { normal = true } end, desc = 'Debug Print Variable' },
				{ '<leader>rp', function() require('refactoring').debug.print_var {} end, mode = 'v', desc = 'Debug Print Variable' },
				{ '<leader>rP', function() require('refactoring').debug.printf { below = false } end, desc = 'Debug Print' },
				{ '<leader>rc', function() require('refactoring').debug.cleanup {} end, desc = 'Debug Cleanup' },
			}
		end,
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
}
