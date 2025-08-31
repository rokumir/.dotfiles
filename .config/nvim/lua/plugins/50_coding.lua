---@module 'lazy'
---@type LazyPluginSpec[]
return {
	{ 'mini.pairs', opts = { modes = {
		terminal = false,
	} } },

	{ -- better yanking
		'gbprod/yanky.nvim',
		opts = {
			ring = {
				history_length = 50,
				sync_with_numbered_registers = true,
				ignore_registers = { '_' },
			},
			highlight = {
				on_put = true,
				on_yank = true,
				timer = 500,
			},
			textobj = { enabled = false },
			preserve_cursor_position = {
				enabled = true,
			},
		},
		keys = function()
			return {
				{ '<leader>p', '', desc = 'yanky' },
				{ '<leader>pp', function() Snacks.picker['yanky']() end, mode = { 'n', 'x' }, desc = 'Open Yank History' },
				{ '<leader>pc', function() require('yanky').history.clear() end, desc = 'Clear Yank History' },

				{ '<a-N>', '<Plug>(YankyNextEntry)', mode = { 'n', 'i' }, desc = 'Next Entry' },
				{ '<a-B>', '<Plug>(YankyPreviousEntry)', mode = { 'n', 'i' }, desc = 'Prev Entry' },

				{ 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' }, desc = 'Yank Text' },
				{ 'p', '<Plug>(YankyPutAfter)', desc = 'Put Text After Cursor' },
				{ 'p', '<Plug>(YankyPutBefore)', mode = { 'x' }, desc = 'Put Text After Cursor' },
				{ 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' }, desc = 'Put Text Before Cursor' },
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
				{ '<leader>rr', function() require('refactoring').select_refactor() end, mode = { 'n', 'v' }, desc = 'Options' },
				{ '<leader>rp', function() require('refactoring').debug.print_var { normal = true } end, desc = '[Debug] Print Variable' },
				{ '<leader>rp', function() require('refactoring').debug.print_var {} end, mode = 'v', desc = '[Debug] Print Variable' },
				{ '<leader>rc', function() require('refactoring').debug.cleanup {} end, desc = '[Debug] Cleanup' },
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

	{ -- better UX than inc-rename
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
		opts = {
			auto_insert_mode = false,
		},
	},
}
