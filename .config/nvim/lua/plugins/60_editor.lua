---@diagnostic disable: undefined-field
local excluded_filetypes = require('utils.const').filetype.ignored_list

---@diagnostic disable: no-unknown, missing-fields, missing-parameter
---@type LazyPluginSpec[]
return {
	{ -- Harpoon
		'ThePrimeagen/harpoon',
		branch = 'harpoon2',
		---@type fun(): LazyKeysSpec[]
		keys = function()
			local function harpoon_goto(index)
				return function() require('harpoon'):list():select(index) end
			end
			return {
				{ ';h', '', desc = 'harpoon' },
				{ ';hh', function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end, desc = 'List' },
				{ ';hp', function() require('harpoon'):list():prepend() end, desc = 'Prepend' },
				{ ';ha', function() require('harpoon'):list():add() end, desc = 'Add' },
				{ '<a-}>', function() require('harpoon'):list():next() end, desc = 'Harpoon next' },
				{ '<a-{>', function() require('harpoon'):list():prev() end, desc = 'Harpoon prev' },

				{ '<a-U>', harpoon_goto(1), desc = 'Harpoon 1st entry' },
				{ '<a-I>', harpoon_goto(2), desc = 'Harpoon 2nd entry' },
				{ '<a-O>', harpoon_goto(3), desc = 'Harpoon 3rd entry' },
				{ '<a-P>', harpoon_goto(4), desc = 'Harpoon 4th entry' },

				{ '<c-q>', function() require('harpoon').ui:close_menu() end, mode = { 'n', 'i' }, ft = 'harpoon', desc = 'Harpoon Quit' },
				{ '<c-l>', function() require('harpoon').ui:select_menu_item {} end, ft = 'harpoon', desc = 'Harpoon Open' },
				{ 's', function() require('harpoon').ui:select_menu_item { split = true } end, ft = 'harpoon', desc = 'Harpoon Split' },
				{ 'v', function() require('harpoon').ui:select_menu_item { vsplit = true } end, ft = 'harpoon', desc = 'Harpoon V Split' },
				{ 't', function() require('harpoon').ui:select_menu_item { tabedit = true } end, ft = 'harpoon', desc = 'Harpoon New Tab' },
			}
		end,
		opts = {
			menu = { width = vim.api.nvim_win_get_width(0) - 4 },
			settings = {
				save_on_toggle = true,
				sync_on_ui_close = true,
				key = function() return vim.uv.cwd() or '' end,
			},
		},
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
			{ 'f', function() require('flash').jump { forward = true, continue = true } end, mode = { 'n', 'x', 'o' }, desc = 'Flash Forward 󱞣' },
			{ 'F', function() require('flash').jump { forward = false, continue = true } end, mode = { 'n', 'x', 'o' }, desc = 'Flash Backward 󱞽' },
		},
	},

	{ -- Easy location list
		'folke/trouble.nvim',
		optional = true,
		opts = {
			use_diagnostic_signs = true,
			height = 6,
			padding = false,
			keys = {
				['<c-q>'] = 'close',
			},
		},
	},
	{ -- Todo Comments
		'folke/todo-comments.nvim',
		version = false,
		keys = function()
			return {
				{ ';T', '', desc = 'todo-comments' },
				{
					';TT',
					function()
						local commentstring = vim.bo.commentstring or ''
						local keywords = require('todo-comments.config').keywords
						local todo_comments_map = require('utils.table').map(keywords, function(text, tag) return { text = text, tag = tag } end)
						Snacks.picker.pick {
							title = 'Todo comment',
							layout = 'select',
							items = todo_comments_map,
							format = function(item)
								local fg = 'TodoFg' .. item.tag
								local bg = 'TodoBg' .. item.tag
								return { { '  ', fg }, { item.tag, bg }, { ' ' .. item.text, fg } }
							end,
							confirm = function(picker, item)
								picker:close()
								local row, col = unpack(vim.api.nvim_win_get_cursor(0))
								vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { string.format(commentstring, item.text) .. ': ' })
								vim.cmd.startinsert()
							end,
						}
					end,
					desc = 'Insert',
				},
				{ '<leader>xt', '<cmd>Trouble todo toggle<cr>', desc = 'Todo (Trouble)' },
				{ '<leader>xT', '<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>', desc = 'Todo/Fix/Fixme (Trouble)' },
				{ ';sT', function() Snacks.picker.todo_comments() end, desc = 'Todo Trouble' },
			}
		end,
	},

	{ -- better indent guessing
		'tpope/vim-sleuth',
		init = function()
			-- 1: true, 0: false
			for _, ft in ipairs(excluded_filetypes) do
				vim.g['sleuth_' .. ft .. '_heuristics'] = 0
			end
		end,
	},

	{ -- Fugit2
		'SuperBo/fugit2.nvim',
		build = false,
		opts = { width = 100 },
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

	{ -- Undo tree
		'jiaoshijie/undotree',
		priority = 1000,
		keys = { -- load the plugin only when using it's keybinding:
			{ '<leader>U', function() require('undotree').toggle() end, desc = 'Undotree' },
		},
		opts = {
			float_diff = false, -- using float window previews diff, set this `true` will disable layout option
			layout = 'left_left_bottom', -- "left_bottom", "left_left_bottom"
			position = 'left', -- "right", "bottom"
			ignore_filetype = excluded_filetypes,
			window = { winblend = 100 },
			keymaps = {
				['j'] = 'move_next',
				['k'] = 'move_prev',
				['gj'] = 'move2parent',
				['J'] = 'move_change_next',
				['K'] = 'move_change_prev',
				['<cr>'] = 'action_enter',
				['p'] = 'enter_diffbuf',
				['q'] = 'quit',
			},
		},
	},

	{ -- best color picker (including oklch)
		'eero-lehtinen/oklch-color-picker.nvim',
		event = 'BufReadPre',
		cmd = { 'ColorPickOklch' },
		keys = {
			{
				'<leader>cp',
				function() require('oklch-color-picker').pick_under_cursor { fallback_open = { initial_color = '#000' } } end,
				desc = 'Open color picker under cursor',
			},
		},
		---@type oklch.Opts
		opts = {
			register_cmds = false,
			auto_download = false,
			wsl_use_windows_app = true,

			highlight = {
				enabled = true,
				edit_delay = 100,
				scroll_delay = 10,
				virtual_text = '  ',
				style = 'virtual_left',
				bold = true,
				italic = true,
				ignore_ft = excluded_filetypes,
				disable_builtin_lsp_colors = vim.version().minor == 12,
			},

			---@type table<string, oklch.PatternList | false>?
			patterns = {
				hex = { priority = -1, '()#%x%x%x+%f[%W]()' },
				hex_literal = { priority = -1, '()0x%x%x%x%x%x%x+%f[%W]()' },

				-- Rgb and Hsl support modern and legacy formats:
				-- rgb(10 10 10 / 50%) and rgba(10, 10, 10, 0.5)
				css_rgb = { priority = -1, '()rgba?%(.-%)()' },
				css_hsl = { priority = -1, '()hsla?%(.-%)()' },
				css_oklch = { priority = -1, '()oklch%([^,]-%)()' },

				tailwind = {
					priority = -2,
					custom_parse = function(m) return require('oklch-color-picker.tailwind').custom_parse(m) end,
					'%f[%w][%l%-]-%-()%l-%-%d%d%d?%f[%W]()',
				},

				-- Allows any digits, dots, commas or whitespace within brackets.
				numbers_in_brackets = { priority = -10, '%(()[%d.,%s]+()%)' },
			},
		},
	},

	{ -- A vim-vinegar like file explorer that lets you edit your filesystem like a normal Neovim buffer.
		'stevearc/oil.nvim',
		cmd = 'Oil',
		keys = {
			{ ';e', function() require('oil').toggle_float() end, desc = 'Oil' },
		},
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			win_options = {
				winblend = 0,
				number = false,
				relativenumber = false,
				signcolumn = 'auto:2',
			},
			view_options = {
				show_hidden = false,
				case_insensitive = false,
				natural_order = 'fast',
			},
			float = {
				padding = 2,
				max_width = 0.4,
				max_height = 0.6,
				border = 'rounded',
			},
			keymaps = {
				['?'] = { 'actions.show_help', mode = 'n' },
				['<c-l>'] = 'actions.select',
				['<c-v>'] = { 'actions.select', opts = { vertical = true } },
				['<c-s>'] = { 'actions.select', opts = { horizontal = true } },
				['<c-q>'] = { 'actions.close', mode = { 'n', 'i' } },
				['<c-c>'] = { 'actions.close', mode = { 'n', 'i' } },
				['<a-p>'] = 'actions.preview',
				['<a-r>'] = 'actions.refresh',
				['-'] = { 'actions.parent', mode = 'n' },
				['_'] = { 'actions.open_cwd', mode = 'n' },
				['`'] = { 'actions.cd', mode = 'n' },
				['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
				['<a-s>'] = { 'actions.change_sort', mode = 'n' },
				['<a-h>'] = { 'actions.toggle_hidden', mode = 'n' },
				['<a-T>'] = { 'actions.toggle_trash', mode = 'n' },
				['gx'] = { 'actions.open_external', mode = { 'n', 'v' } },
			},
		},
	},
}
