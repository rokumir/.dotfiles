---@module 'lazy'
---@type LazyPluginSpec[]
return {
	{ 'mini.pairs', opts = {
		modes = { terminal = true },
	} },

	{ -- better yanking
		'gbprod/yanky.nvim',
		opts = {
			ring = {
				history_length = 50,
				sync_with_numbered_registers = true,
			},
			highlight = {
				on_put = true,
				on_yank = true,
				timer = 500,
			},
			textobj = { enabled = false },
		},
		keys = function()
			return {
				{ '<leader>p', '', desc = 'yanky' },
				---@diagnostic disable-next-line: undefined-field
				{ '<leader>pp', function() Snacks.picker.yanky() end, mode = { 'n', 'x' }, desc = 'Open Yank History' },
				{ '<leader>pc', function() require('yanky').history.clear() end, desc = 'Clear Yank History' },

				{ '<c-a-n>', '<Plug>(YankyNextEntry)', mode = { 'n', 'i' }, desc = 'Next Entry' },
				{ '<c-a-b>', '<Plug>(YankyPreviousEntry)', mode = { 'n', 'i' }, desc = 'Prev Entry' },

				{ 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' }, desc = 'Yank Text' },
				{ 'p', '<Plug>(YankyPutAfter)', desc = 'Put Text After Cursor' },
				{ 'p', '<Plug>(YankyPutBefore)', mode = { 'x' }, desc = 'Put Text After Cursor' },
				{ 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' }, desc = 'Put Text Before Cursor' },
				{ 'gp', '<Plug>(YankyGPutAfter)', mode = { 'n', 'x' }, desc = 'Put Text After Selection' },
				{ 'gP', '<Plug>(YankyGPutBefore)', mode = { 'n', 'x' }, desc = 'Put Text Before Selection' },
				{ '[y', '<Plug>(YankyCycleForward)', desc = 'Cycle Forward Through Yank History' },
				{ ']y', '<Plug>(YankyCycleBackward)', desc = 'Cycle Backward Through Yank History' },
				{ ']p', '<Plug>(YankyPutIndentAfterLinewise)', desc = 'Put Indented After Cursor (Linewise)' },
				{ '[p', '<Plug>(YankyPutIndentBeforeLinewise)', desc = 'Put Indented Before Cursor (Linewise)' },
				{ ']P', '<Plug>(YankyPutIndentAfterLinewise)', desc = 'Put Indented After Cursor (Linewise)' },
				{ '[P', '<Plug>(YankyPutIndentBeforeLinewise)', desc = 'Put Indented Before Cursor (Linewise)' },
				{ '>p', '<Plug>(YankyPutIndentAfterShiftRight)', desc = 'Put and Indent Right' },
				{ '<p', '<Plug>(YankyPutIndentAfterShiftLeft)', desc = 'Put and Indent Left' },
				{ '>P', '<Plug>(YankyPutIndentBeforeShiftRight)', desc = 'Put Before and Indent Right' },
				{ '<P', '<Plug>(YankyPutIndentBeforeShiftLeft)', desc = 'Put Before and Indent Left' },
				{ '=p', '<Plug>(YankyPutAfterFilter)', desc = 'Put After Applying a Filter' },
				{ '=P', '<Plug>(YankyPutBeforeFilter)', desc = 'Put Before Applying a Filter' },
			}
		end,
	},

	{ -- Delimiter pairs surroundability
		'echasnovski/mini.surround',
		lazy = true,
		opts = {
			n_lines = 30,
			respect_selection_type = true,
			search_method = 'cover_or_nearest', ---@type 'cover'|'cover_or_next'|'cover_or_prev'|'cover_or_nearest'|'next'|'prev'|'nearest'
			mappings = {
				add = 'sa', -- Add surrounding in Normal and Visual modes
				delete = 'sd', -- Delete surrounding
				find = 'sf', -- Find surrounding (to the right)
				find_left = 'sF', -- Find surrounding (to the left)
				highlight = 'sh', -- Highlight surrounding
				replace = 'sc', -- Replace surrounding
				update_n_lines = 'sn', -- Update `n_lines`
				suffix_last = 'l', -- Suffix to search with "prev" method
				suffix_next = 'n', -- Suffix to search with "next" method
			},
		},
	},

	{ -- Refactoring (primeagen)
		'ThePrimeagen/refactoring.nvim',
		keys = function()
			return {
				{ '<leader>r', '', desc = 'refactor' },
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
				{
					'<leader>ri',
					function() require('refactoring').refactor 'Inline Variable' end,
					mode = { 'n', 'v' },
					desc = 'Inline Variable',
				},
				{ '<leader>rb', function() require('refactoring').refactor 'Extract Block' end, desc = 'Extract Block' },
				{ '<leader>rf', function() require('refactoring').refactor 'Extract Block To File' end, desc = 'Extract Block To File' },
				{ '<leader>rf', function() require('refactoring').refactor 'Extract Function' end, mode = 'v', desc = 'Extract Function' },
				{
					'<leader>rF',
					function() require('refactoring').refactor 'Extract Function To File' end,
					mode = 'v',
					desc = 'Extract Function To File',
				},
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

	{
		'CopilotC-Nvim/CopilotChat.nvim',
		opts = function(_, opts) opts.auto_insert_mode = false end,
	},
}
