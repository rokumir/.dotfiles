local excluded_filetypes = require('config.const.filetype').ignored_list

---@diagnostic disable: no-unknown, missing-fields, missing-parameter
---@type LazyPluginSpec[]
return {
	{ -- Harpoon
		'ThePrimeagen/harpoon',
		branch = 'harpoon2',
		---@type fun(): LazyKeysSpec[]
		keys = function()
			return {
				{ ';h', '', desc = 'harpoon' },
				{ ';hh', function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end, desc = 'List' },
				{ ';hp', function() require('harpoon'):list():prepend() end, desc = 'Prepend' },
				{ ';ha', function() require('harpoon'):list():add() end, desc = 'Add' },
				{ '<c-a-]>', function() require('harpoon'):list():next() end, desc = 'Harpoon next' },
				{ '<c-a-[>', function() require('harpoon'):list():prev() end, desc = 'Harpoon prev' },

				{ '<c-a-u>', function() require('harpoon'):list():select(1) end, desc = 'Harpoon 1st entry' },
				{ '<c-a-i>', function() require('harpoon'):list():select(2) end, desc = 'Harpoon 2nd entry' },
				{ '<c-a-o>', function() require('harpoon'):list():select(3) end, desc = 'Harpoon 3rd entry' },
				{ '<c-a-p>', function() require('harpoon'):list():select(4) end, desc = 'Harpoon 4th entry' },

				{ '<c-q>', function() require('harpoon').ui:close_menu() end, mode = { 'n', 'i' }, ft = 'harpoon', desc = 'Harpoon Quit' },
				{ '<c-l>', function() require('harpoon').ui:select_menu_item {} end, ft = 'harpoon', desc = 'Harpoon Open' },
				{ 's', function() require('harpoon').ui:select_menu_item { split = true } end, ft = 'harpoon', desc = 'Harpoon Split' },
				{ 'v', function() require('harpoon').ui:select_menu_item { vsplit = true } end, ft = 'harpoon', desc = 'Harpoon V Split' },
				{ 't', function() require('harpoon').ui:select_menu_item { tabedit = true } end, ft = 'harpoon', desc = 'Harpoon New Tab' },
			}
		end,
		opts = function(_, opts)
			-- Settings for the greatest script of all time
			vim.api.nvim_create_autocmd({ 'FileType' }, {
				group = vim.api.nvim_create_augroup('nihil_tmux_harpoon', { clear = true }),
				pattern = 'tmux-harpoon', -- in config.filetype
				callback = function(ev)
					vim.opt_local.showmode = false
					vim.opt_local.ruler = false
					vim.opt_local.laststatus = 0
					vim.opt_local.showcmd = false
					vim.opt_local.wrap = false

					require('utils.keymap').map { '<c-s>', '<cmd>write | quit <cr>', buffer = ev.buf }
				end,
			})

			return vim.tbl_deep_extend('force', opts or {}, {
				menu = { width = vim.api.nvim_win_get_width(0) - 4 },
				settings = {
					save_on_toggle = true,
					sync_on_ui_close = true,
					key = function() return vim.uv.cwd() or '' end,
				},
			})
		end,
	},

	{ -- Flash
		'flash.nvim',
		version = false,
		optional = true,
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
		'trouble.nvim',
		optional = true,
		version = false,
		opts = {
			use_diagnostic_signs = true,
			height = 6,
			padding = false,
			keys = { ['<c-q>'] = 'close' },
		},
	},
	{ -- Todo Comments
		'folke/todo-comments.nvim',
		optional = true,
		keys = function()
			return {
				{ '<leader>xt', '<cmd>Trouble todo toggle<cr>', desc = 'Todo (Trouble)' },
				{ '<leader>xT', '<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>', desc = 'Todo/Fix/Fixme (Trouble)' },
				{ ';T', function() Snacks.picker['todo_comments']() end, desc = 'Todo Trouble' },
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
		lazy = true,
		cmd = 'Oil',
		keys = {
			{ ';E', function() require('oil').toggle_float() end, desc = 'Oil' },
		},
		opts = function()
			vim.api.nvim_create_autocmd('User', {
				group = vim.api.nvim_create_augroup('nihil_snacks_oil_rename', { clear = true }),
				pattern = 'OilActionsPost',
				callback = function(event)
					if event.data.actions.type == 'move' then Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url) end
				end,
			})

			---@type oil.SetupOpts
			return {
				cleanup_delay_ms = 2000,
				skip_confirm_for_simple_edits = false,
				confirmation = {
					border = 'rounded',
					win_options = { winblend = 0 },
				},
				win_options = {
					winblend = 0,
					number = false,
					relativenumber = false,
					signcolumn = 'auto:2',
				},
				view_options = {
					show_hidden = true,
					case_insensitive = false,
					natural_order = 'fast',
				},
				float = {
					padding = 2,
					max_width = 0.4,
					max_height = 0.6,
					border = 'rounded',
				},
				keymaps_help = { border = 'rounded' },
				keymaps = {
					['?'] = { 'actions.show_help', mode = 'n' },
					['<c-l>'] = 'actions.select',
					['<c-s>'] = { function() require('oil').save() end, mode = { 'n', 'i' } },
					['l'] = { 'actions.select', mode = 'n' },
					['v'] = { 'actions.select', opts = { vertical = true }, mode = 'n' },
					['s'] = { 'actions.select', opts = { horizontal = true }, mode = 'n' },
					['<c-q>'] = { 'actions.close', mode = { 'n', 'i' } },
					['<c-c>'] = { 'actions.close', mode = { 'n', 'i' } },
					['<a-p>'] = 'actions.preview',
					['<a-r>'] = 'actions.refresh',
					['<a-y>'] = 'actions.yank_entry',
					['<a-<>'] = { 'actions.parent', mode = 'n' },
					['<a->>'] = { 'actions.select', mode = 'n' },
					['o'] = { 'actions.open_cwd', mode = 'n' }, -- goto active working project dir
					['<c-.>'] = 'actions.cd',
					['<a-s>'] = { 'actions.change_sort', mode = 'n' },
					['<a-h>'] = { 'actions.toggle_hidden', mode = 'n' },
					['<a-T>'] = { 'actions.toggle_trash', mode = 'n' },
					['gx'] = { 'actions.open_external', mode = { 'n', 'v' } },
					['g.'] = { 'actions.toggle_hidden', mode = 'n' },
					['g\\'] = { 'actions.toggle_trash', mode = 'n' },
					['gd'] = function() require('oil').set_columns { 'icon', 'permissions', 'size', 'mtime' } end,
					['J'] = { '', mode = 'n' },
				},
			}
		end,
	},

	{ -- Change text case
		'johmsalas/text-case.nvim',
		priority = 1000,
		keys = {
			{ ';C', function() require('utils.text-case'):picker() end, desc = 'Change Text Case', mode = { 'n', 's', 'x' } },
		},
		opts = { default_keymappings_enabled = false },
	},
}
