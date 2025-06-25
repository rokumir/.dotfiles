---@diagnostic disable: no-unknown, missing-fields, missing-parameter
---@type table<number, LazyPluginSpec>
return {
	{ -- Harpoon: maneuvering throught files like the flash
		'ThePrimeagen/harpoon',
		branch = 'harpoon2',
		---@type fun(): LazyKeysSpec[]
		keys = function()
			local harpoon = require 'harpoon'

			local function harpoon_goto(index)
				return function() harpoon:list():select(index) end
			end

			return {
				{ ';h', '', desc = 'harpoon' },
				{ ';hh', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = 'Harpoon list' },
				{ ';hp', function() harpoon:list():prepend() end, desc = 'Harpoon prepend' },
				{ ';ha', function() harpoon:list():add() end, desc = 'Harpoon add' },
				{ '<c-a-]>', function() harpoon:list():next() end, desc = 'Harpoon next' },
				{ '<c-a-[>', function() harpoon:list():prev() end, desc = 'Harpoon prev' },

				{ '<c-a-u>', harpoon_goto(1), desc = 'Harpoon 1st entry' },
				{ '<c-a-i>', harpoon_goto(2), desc = 'Harpoon 2nd entry' },
				{ '<c-a-o>', harpoon_goto(3), desc = 'Harpoon 3rd entry' },
				{ '<c-a-p>', harpoon_goto(4), desc = 'Harpoon 4th entry' },
			}
		end,
		config = function()
			local harpoon = require 'harpoon'
			harpoon:setup {
				menu = {
					width = vim.api.nvim_win_get_width(0) - 4,
				},
				settings = {
					save_on_toggle = true,
					sync_on_ui_close = true,
					key = function() return vim.uv.cwd() or '' end,
				},
			}
			harpoon:extend {
				UI_CREATE = function(cx)
					local map = require('utils.keymap').map
					map {
						'<c-q>',
						function() harpoon.ui:close_menu() end,
						mode = { 'n', 'i' },
						buffer = cx.bufnr,
						desc = 'Harpoon Buffer: Quit',
					}
					map {
						'<c-l>',
						function() harpoon.ui:select_menu_item {} end,
						buffer = cx.bufnr,
						desc = 'Harpoon Buffer: Open',
					}
					map {
						's',
						function() harpoon.ui:select_menu_item { split = true } end,
						buffer = cx.bufnr,
						desc = 'Harpoon Buffer: Split',
					}
					map {
						'v',
						function() harpoon.ui:select_menu_item { vsplit = true } end,
						buffer = cx.bufnr,
						desc = 'Harpoon Buffer: V Split',
					}
					map {
						't',
						function() harpoon.ui:select_menu_item { tabedit = true } end,
						buffer = cx.bufnr,
						desc = 'Harpoon Buffer: Open New Tab',
					}
				end,
			}
		end,
	},

	{ -- Flash
		'folke/flash.nvim',
		event = 'VeryLazy',
		---@type Flash.Config
		opts = {
			modes = {
				char = {
					jump_labels = true,
					keys = { 'f', 'F' },
				},
			},
			search = {
				multi_window = false,
				wrap = true,
				mode = 'fuzzy',
			},
		},
		keys = {
			{
				'f',
				function() require('flash').jump { forward = true, continue = true } end,
				mode = { 'n', 'x', 'o' },
				desc = 'Flash Forward 󱞣',
			},
			{
				'F',
				function() require('flash').jump { forward = false, continue = true } end,
				mode = { 'n', 'x', 'o' },
				desc = 'Flash Backward 󱞽',
			},
			{ '<c-f>', function() require('flash').toggle(false) end, mode = { 'c' }, desc = 'Quit Flash Mode' },
		},
	},

	{ -- Easy location list
		'folke/trouble.nvim',
		cond = vim.g.vscode ~= 1,
		opts = {
			use_diagnostic_signs = true,
			height = 6,
			padding = false,
			action_keys = {
				close = '<c-q>',
				close_folds = 'zC',
				open_folds = 'zO',
			},
		},
	},

	{ -- Automatically set indent settings base on the content of the file
		'Darazaki/indent-o-matic',
		opts = {
			standard_widths = { 2, 4 },
			-- filetype_lisp = { max_lines = 0, }, -- Disable indent-o-matic for LISP files

			filetype_rust = { standard_widths = { 4 } },
			filetype_fish = { standard_widths = { 4 } },
			filetype_ = { standard_widths = { 2, 4 } },
		},
	},

	{ -- Fugit2
		'SuperBo/fugit2.nvim',
		build = false,
		opts = {
			width = 100,
		},
		cmd = { 'Fugit2', 'Fugit2Diff', 'Fugit2Graph' },
		keys = {
			{ ';gF', '<cmd>Fugit2<cr>', desc = 'Open Fugit2' },
			{ ';gFd', '<cmd>Fugit2Diff<cr>', desc = 'Fugit2 Diff' },
			{ ';gg', '<cmd>Fugit2Graph<cr>', desc = 'Fugit2 Graph' },
		},
	},
	{ -- diffview
		'sindrets/diffview.nvim',
		priority = 1000,
		cmd = {
			'DiffviewFileHistory',
			'DiffviewOpen',
			'DiffviewToggleFiles',
			'DiffviewFocusFiles',
			'DiffviewRefresh',
		},
		keys = {
			{ ';gD', '<cmd>DiffviewOpen<cr>', desc = 'DiffView' },
		},
	},

	{
		'kevinhwang91/nvim-ufo',
		dependencies = 'kevinhwang91/promise-async',
		event = 'VimEnter',
		init = function()
			vim.o.foldcolumn = '1' -- '0' is not bad
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
		end,
		opts = {
			open_fold_hl_timeout = 150,
			close_fold_kinds_for_ft = {
				default = { 'imports', 'comment' },
				json = { 'array' },
				c = { 'comment', 'region' },
			},
		},
	},

	{
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
				{ '<leader>pc', '<cmd>YankyClearHistory<cr>', desc = 'Clear Yank History' },

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
}
