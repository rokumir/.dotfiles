---@module 'lazy'
---@type LazyPluginSpec[]
return {
	{ -- better yanking
		'gbprod/yanky.nvim',
		version = false,
		lazy = false,
		opts = {
			ring = {
				history_length = 50,
				permanent_wrapper = function(...) return require('yanky.wrappers').remove_carriage_return(...) end,
			},
			preserve_cursor_position = { enabled = true },
			highlight = { on_put = true, on_yank = true, timer = 500 },
			system_clipboard = { sync_with_ring = false },
		},
		keys = function()
			return {
				{ '<leader>yc', function() require('yanky').history.clear() end, desc = 'Clear Yank History' },
				{ '<leader>yp', function() Snacks.picker['yanky']() end, mode = { 'n', 'x' }, desc = 'Open Yank History' },
				{ ';sy', function() Snacks.picker['yanky']() end, mode = { 'n', 'x' }, desc = 'Open Yank History' },

				{ '<a-<>', function() require('yanky').cycle(1) end, mode = { 'n', 'i' }, desc = 'Next Entry' },
				{ '<a->>', function() require('yanky').cycle(-1) end, mode = { 'n', 'i' }, desc = 'Prev Entry' },

				{ 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' }, desc = 'Yank Text' },
				{ 'p', '<Plug>(YankyPutAfter)', desc = 'Put Text After Cursor' },
				{ 'p', '<Plug>(YankyPutBefore)', mode = { 'x' }, desc = 'Put Text After Cursor' },
				{ 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' }, desc = 'Put Text Before Cursor' },
			}
		end,
	},

	{
		'nvim-mini/mini.pairs',
		optional = true,
		opts = {
			modes = { insert = true, command = false, terminal = false },
			skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
			skip_ts = { 'string' },
			skip_unbalanced = true,
			markdown = true,
		},
		config = function(_, opts) require('nihil.plugin.mini-pairs').setup(opts) end,
	},

	{ -- Delimiter pairs surroundability
		'mini.surround',
		lazy = true,
		optional = true,
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

	{ -- Refactoring
		'ThePrimeagen/refactoring.nvim',
		keys = function()
			return {
				{ '<leader>rr', function() require('refactoring').select_refactor() end, mode = { 'n', 'v' }, desc = 'Options' },
				{ '<leader>rp', function() require('refactoring').debug.print_var { normal = true } end, desc = 'Print Debug Variable' },
				{ '<leader>rp', function() require('refactoring').debug.print_var {} end, mode = 'v', desc = 'Print Debug Variable' },
				{ '<leader>rc', function() require('refactoring').debug.cleanup {} end, desc = 'Cleanup Debug Code' },
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

	{ -- Better UX than inc-rename
		'saecki/live-rename.nvim',
		priority = 1000,
		event = 'VeryLazy',
		lazy = true,
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
					{ 'n', '<c-s>' },
					{ 'v', '<c-s>' },
					{ 'i', '<c-s>' },
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

	{ ---@module 'lazydev'
		'lazydev.nvim',
		optional = true,
		opts = function(_, opts)
			vim.list_extend(opts.library, {
				{ path = 'which-key.nvim', words = { 'Nihil%.keymap', 'Nihil%.keymap%.map' } },
			})
		end,
	},
}
