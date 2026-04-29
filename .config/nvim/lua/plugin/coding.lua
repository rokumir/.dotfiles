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
				{
					'<leader>yp',
					function() Snacks.picker['yanky']() end,
					mode = { 'n', 'x' },
					desc = 'Open Yank History',
				},
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

	{ 'nvim-mini/mini.align', config = true },
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
				{
					'<leader>rr',
					function() require('refactoring').select_refactor() end,
					mode = { 'n', 'v' },
					desc = 'Options',
				},
				{
					'<leader>rp',
					function() require('refactoring').debug.print_var { normal = true } end,
					desc = 'Print Debug Variable',
				},
				{
					'<leader>rp',
					function() require('refactoring').debug.print_var {} end,
					mode = 'v',
					desc = 'Print Debug Variable',
				},
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

	{ -- Change text case
		'gregorias/coerce.nvim',
		lazy = false,
		config = function()
			local coerce = require 'coerce'
			local case = require 'coerce.case'
			local cs = require 'coerce.string'

			coerce.setup {
				keymap_registry = require('coerce.keymap').keymap_registry(),
				default_mode_keymap_prefixes = {
					normal_mode = ';c',
					visual_mode = ';c',
				},
				default_mode_mask = {
					normal_mode = true,
					visual_mode = true,
					motion_mode = false,
				},
				cases = {
					{ keymap = 'c', case = case.to_camel_case, description = 'camelCase' },
					{ keymap = 'k', case = case.to_kebab_case, description = 'kebab-case' },
					{ keymap = 'p', case = case.to_pascal_case, description = 'PascalCase' },
					{ keymap = '_', case = case.to_snake_case, description = 'snake_case' },
					{ keymap = 'C', case = case.to_upper_case, description = 'CONSTANT_CASE' },
					{ keymap = '/', case = case.to_path_case, description = 'path/case' },
					{ keymap = ' ', case = case.to_space_case, description = 'space case' },
					{ keymap = 'n', case = case.to_numerical_contraction, description = 'numeronym (n7m)' },
					{ keymap = '.', case = case.to_dot_case, description = 'dot.case' },
					{
						keymap = ',',
						case = function(str)
							local parts = case.split_keyword(str)
							return table.concat(parts, ',')
						end,
						description = 'comma.case',
					},
					{
						keymap = 'U',
						case = function(str)
							local parts = case.split_keyword(str)
							parts = vim.tbl_map(vim.fn.toupper, parts)
							return table.concat(parts, ' ')
						end,
						description = 'UPPER CASE',
					},
					{
						keymap = 'u',
						case = function(str)
							local parts = case.split_keyword(str)
							parts = vim.tbl_map(vim.fn.tolower, parts)
							return table.concat(parts, ' ')
						end,
						description = 'lower case',
					},
					{
						keymap = 't',
						case = function(str)
							local parts = case.split_keyword(str)
							for i = 1, #parts, 1 do
								local part_graphemes = cs.str2graphemelist(parts[i])
								part_graphemes[1] = vim.fn.toupper(part_graphemes[1])
								parts[i] = table.concat(part_graphemes, '')
							end
							return table.concat(parts, ' ')
						end,
						description = 'Title Case',
					},
				},
			}
		end,
	},

	{ -- "tiny" plugin for displaying inline diagnostic messages with customizable styles and icons
		'rachartier/tiny-inline-diagnostic.nvim',
		event = 'VeryLazy',
		priority = 1000,
		keys = {
			{ '<leader><leader>uD', '<cmd>TinyInlineDiag toggle<cr>', desc = 'Toggle Tiny Inline Diagnostic' },
		},
		opts = {
			-- Preset style: classic modern minimal powerline ghost simple nonerdfont amongus
			preset = 'modern', -- disabled if `use_icons_from_diagnostic=true`
			transparent_bg = false,
			transparent_cursorline = true, -- Make cursorline background transparent for diagnostics

			disabled_ft = Nihil.config.exclude.filetypes,

			options = {
				show_source = { enabled = false, if_many = true },
				show_code = true, -- Display the diagnostic code of diagnostics (e.g., "F401", "no-dupe-args")
				use_icons_from_diagnostic = true, -- Use icons from vim.diagnostic.config instead of preset icons
				set_arrow_to_diag_color = true, -- Color the arrow to match the severity of the first diagnostic
				throttle = 20,
				softwrap = 30, -- Minimum number of characters before wrapping long messages

				-- Control how diagnostic messages are displayed
				-- NOTE: When using display_count = true, you need to enable multiline diagnostics with multilines.enabled = true
				--       If you want them to always be displayed, you can also set multilines.always_show = true.
				add_messages = {
					messages = true, -- Show full diagnostic messages
					display_count = true, -- Show diagnostic count instead of messages when cursor not on line
					use_max_severity = true, -- When counting, only show the most severe diagnostic
					show_multiple_glyphs = true, -- Show multiple icons for multiple diagnostics of same severity
				},

				-- Settings for multiline diagnostics
				multilines = {
					enabled = true, -- Enable support for multiline diagnostic messages
					always_show = false, -- Always show messages on all lines of multiline diagnostics
					trim_whitespaces = false, -- Remove leading/trailing whitespace from each line
					tabstop = 4, -- Number of spaces per tab when expanding tabs
					severity = nil, -- Filter multiline diagnostics by severity (e.g., { vim.diagnostic.severity.ERROR })
				},
				-- Show all diagnostics on the current cursor line, not just those under the cursor
				show_all_diags_on_cursorline = false,
				-- Only show diagnostics when the cursor is directly over them, no fallback to line diagnostics
				show_diags_only_under_cursor = false,

				show_related = { enabled = true, max_count = 3 }, -- Display related diagnostics from LSP relatedInformation
				enable_on_insert = false, -- Enable diagnostics display in insert mode. May cause visual artifacts; consider setting throttle to 0 if enabled
				enable_on_select = false, -- Enable diagnostics display in select mode (e.g., during auto-completion)

				overflow = { -- Handle messages that exceed the window width
					mode = 'wrap', -- "wrap": split into lines, "none": no truncation, "oneline": keep single line
					padding = 0, -- Extra characters to trigger wrapping earlier
				},

				-- Break long messages into separate lines
				break_line = {
					enabled = true, -- Enable automatic line breaking
					after = 30, -- Number of characters before inserting a line break
				},

				-- Virtual text display priority
				-- Higher values appear above other plugins (e.g., GitBlame)
				virt_texts = { priority = 2048 },
				override_open_float = false, -- Automatically disable diagnostics when opening diagnostic float windows

				-- Experimental options, subject to misbehave in future NeoVim releases
				experimental = {
					-- Make diagnostics not mirror across windows containing the same buffer
					-- See: https://github.com/rachartier/tiny-inline-diagnostic.nvim/issues/127
					use_window_local_extmarks = true,
				},
			},
		},
	},
}
