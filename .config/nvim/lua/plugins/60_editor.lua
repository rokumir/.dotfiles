---@diagnostic disable: no-unknown, missing-fields, missing-parameter
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
				settings = {
					save_on_toggle = true,
					sync_on_ui_close = true,
					key = function() return vim.loop.cwd() or '' end,
				},
			}
			harpoon:extend {
				UI_CREATE = function(cx)
					local opts = { buffer = cx.bufnr }
					vim.keymap.set({ 'n', 'i' }, '<c-q>', function() harpoon.ui:close_menu() end, opts)
					vim.keymap.set('n', '<c-l>', function() harpoon.ui:select_menu_item {} end, opts)
					vim.keymap.set('n', 'v', function() harpoon.ui:select_menu_item { vsplit = true } end, opts)
					vim.keymap.set('n', 's', function() harpoon.ui:select_menu_item { split = true } end, opts)
					vim.keymap.set('n', 't', function() harpoon.ui:select_menu_item { tabedit = true } end, opts)
				end,
			}
		end,
	},

	{ -- Flash
		'folke/flash.nvim',
		event = 'VeryLazy',
		vscode = true,
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
		keys = function()
			return {
				{ 'f', function() require('flash').jump { forward = true, continue = true } end, mode = { 'n', 'x', 'o' }, desc = 'Flash' },
				{ 'F', function() require('flash').jump { forward = false, continue = true } end, mode = { 'n', 'x', 'o' }, desc = 'Flash' },
				{ '<c-s>', function() require('flash').toggle() end, mode = { 'c' }, desc = 'Toggle Flash Search' },
			}
		end,
	},

	{ -- Fuzzy picker
		'ibhagwan/fzf-lua',
		opts = {
			file_icons = 'mini',
			multiprocess = true,

			winopts = {
				preview = { wrap = 'nowrap', hidden = 'hidden' },
			},

			keymap = {
				fzf = {
					['ctrl-l'] = 'accept',
					['🔥'] = 'accept',
				},
				builtin = {
					['<a-/>'] = 'toggle-help',
					['<a-p>'] = 'toggle-preview',
					['<c-u>'] = 'preview-up',
					['<c-d>'] = 'preview-down',
					['<a-z>'] = 'toggle-preview-wrap',
				},
			},

			-- PROVIDERS
			grep = {
				formatter = 'path.filename_first',
			},
			live_grep = {
				formatter = 'path.filename_first',
			},
			files = {
				cmd = 'rg --no-require-git --follow --hidden --files --sortr modified',
				formatter = 'path.filename_first',
				cwd_prompt = false,
				silent = true,
				winopts = {
					width = 0.6,
					preview = { layout = 'vertical' },
				},
			},
		},

		keys = function()
			local function symbols_filter(entry, ctx)
				if ctx.symbols_filter == nil then ctx.symbols_filter = LazyVim.config.get_kind_filter(ctx.bufnr) or false end
				if ctx.symbols_filter == false then return true end
				return vim.tbl_contains(ctx.symbols_filter, entry.kind)
			end

			local pretty_pwd = string.format('  %s  ', vim.fn.getcwd():gsub(vim.env.HOME, '~')) -- static "prettify" pwd

			return {
				{ '\\\\', '<cmd>FzfLua resume <cr>' },
				{
					'<c-e>',
					function() require('fzf-lua').files { winopts = { title_pos = 'center', title = pretty_pwd } } end,
					desc = 'Files',
				},

				{ ';b', '<cmd>FzfLua buffers sort_mru=true sort_lastused=true <cr>', desc = 'Find Buffer' },
				{ ';r', LazyVim.pick('live_grep', { root = false }), desc = 'Grep' },
				{ ';r', LazyVim.pick('grep_visual', { root = false }), mode = 'v', desc = 'Grep' },
				{ ';w', LazyVim.pick('grep_cword', { root = false }), desc = 'Grep word' },
				{ ';q', LazyVim.pick('grep_cWORD', { root = false }), desc = 'Grep WORD' },

				-- { ';o', '<cmd>FzfLua lsp_document_symbols <cr>', desc = 'Symbols' },
				-- { ';O', '<cmd>FzfLua lsp_workspace_symbols <cr>', desc = 'Symbols [ws]' },
				{ ';o', function() require('fzf-lua').lsp_document_symbols { regex_filter = symbols_filter } end, desc = 'Symbol' },
				{ ';O', function() require('fzf-lua').lsp_live_workspace_symbols { regex_filter = symbols_filter } end, desc = 'Symbol [ws]' },
				{ ';d', '<cmd>FzfLua diagnostics_document<cr>', desc = 'Diagnostics' },
				{ ';D', '<cmd>FzfLua diagnostics_workspace<cr>', desc = 'Diagnostics [ws]' },

				{ ';:', '<cmd>FzfLua commands <cr>', desc = 'Commands' },
				{ ';t', '<cmd>FzfLua help_tags <cr>', desc = 'Help Tags' },
				{ ';e', LazyVim.pick('oldfiles', { cwd = vim.uv.cwd() }), desc = 'Oldfiles' },

				{ ';xr', LazyVim.pick 'live_grep', desc = 'Grep [root]' },
				{ ';xr', LazyVim.pick 'grep_visual', mode = 'v', desc = 'Grep [root]' },
				{ ';xw', LazyVim.pick 'grep_cword', desc = 'Grep word [root]' },
				{ ';xq', LazyVim.pick 'grep_cWORD', desc = 'Grep WORD [root]' },
				{ ';xc', LazyVim.pick 'colorschemes', desc = 'Colorschemes' },
				{ ';xe', '<cmd>FzfLua oldfiles <cr>', desc = 'Oldfiles [root]' },
				{ ';xh', '<cmd>FzfLua highlights <cr>', desc = 'Highlights' },
				{ ';xl', '<cmd>FzfLua loclist <cr>', desc = 'Locations' },
				{ ';xq', '<cmd>FzfLua quickfix <cr>', desc = 'Quickfixes' },
				{ ';xk', '<cmd>FzfLua keymaps <cr>', desc = 'Keymaps' },
				{ ';xb', '<cmd>FzfLua grep_curbuf <cr>', desc = 'Buffers' },
				{ ';xg', '<cmd>FzfLua git_files <cr>', desc = 'Find Git Files' },
			}
		end,
	},
	{
		'fzf-lua',
		opts = function(_, opts)
			if vim.env.GLOBAL_IGNORE_FILE then opts.files.cmd = opts.files.cmd .. ' --ignore-file ' .. vim.env.GLOBAL_IGNORE_FILE end

			local actions = require 'fzf-lua.actions'
			local trouble_actions = require('trouble.sources.fzf').actions
			opts.actions = opts.actions or {}
			opts.actions.files = opts.actions.files or { true }
			opts.actions.files['alt-q'] = trouble_actions.open_selected
		end,
	},

	{ -- File explorer
		'nvim-neo-tree/neo-tree.nvim',

		keys = function()
			local function open_file(opts)
				return function()
					require('neo-tree.command').execute(vim.tbl_extend('force', {}, opts, {
						position = 'float',
					}))
				end
			end

			return {
				{ ';f', open_file {}, desc = 'Files' },
				{ 'ss', open_file { reveal = true }, desc = 'Reveal File' },
				{ 'sf', open_file { toggle = true }, desc = 'Files' },
				{ 'sF', open_file { position = 'current' }, desc = 'File (fullscreen)' },
			}
		end,

		opts = {
			sources = { 'filesystem', 'git_status' },
			source_selector = { winbar = true },
			hide_root_node = true,
			show_path = 'relative',
			retain_hidden_root_indent = true, -- IF the root node is hidden, keep the indentation anyhow.
			popup_border_style = 'rounded',

			default_component_configs = {
				git_status = { symbols = { unstaged = '󰄱', staged = '󰱒' } },
				indent = {
					with_expanders = false,
					with_markers = true,
					indent_size = 2,
					padding = 0,
				},
			},

			commands = {
				open_with_file_explorer = function(state) pcall(vim.ui.open, state.tree:get_node().path) end,

				-- https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/370#discussioncomment-4144005
				path_copy_selector = function(state)
					local node = state.tree:get_node()
					local filepath = node:get_id()
					local filename = node.name
					local modify = vim.fn.fnamemodify

					local options_map = {
						['Extension of the filename'] = modify(filename, ':e'),
						['File path URI'] = vim.uri_from_fname(filepath),
						['Absolute path'] = filepath,
						['Path relative to HOME'] = modify(filepath, ':~'),
						['Filename without extention'] = modify(filename, ':r'),
						['Filename'] = filename,
						['Path relative to CWD'] = modify(filepath, ':.'),
					}

					local options = vim.tbl_filter(function(val) return not options_map[val] or options_map[val] ~= '' end, vim.tbl_keys(options_map))
					if vim.tbl_isempty(options) then
						vim.notify('No values to copy', vim.log.levels.WARN)
						return
					end

					vim.ui.select(options, {
						prompt = 'Choose to copy to clipboard:',
						format_item = function(item) return ('%s  (%s)'):format(item, options_map[item]) end,
					}, function(choice)
						local result = options_map[choice]
						if result then vim.fn.setreg('+', result) end
					end)
				end,

				open_without_losing_focus = function(state)
					local node = state.tree:get_node()
					if require('neo-tree.utils').is_expandable(node) then
						state.commands['toggle_node'](state)
					else
						state.commands['open'](state)
						vim.cmd 'Neotree reveal'
					end
				end,

				better_open = function(state)
					local node = state.tree:get_node()
					if node.type == 'directory' then
						if not node:is_expanded() then
							require('neo-tree.sources.filesystem').toggle_directory(state, node)
						elseif node:has_children() then
							require('neo-tree.ui.renderer').focus_node(state, node:get_child_ids()[1])
						end
					else
						state.commands['open'](state)
					end
				end,
			},

			-- neo-tree neo-tree-popup
			use_default_mappings = false,
			window = {
				mappings = {
					['?'] = 'show_help',
					['sf'] = 'close_window',
					['q'] = 'close_window',
					['<c-q>'] = 'close_window',
					['<esc>'] = 'cancel',
					['R'] = 'refresh',
					['<'] = 'prev_source',
					['>'] = 'next_source',

					['h'] = 'close_node',
					['l'] = 'better_open',
					['o'] = 'open_without_losing_focus',
					['<cr>'] = 'open',
					['t'] = 'open_tabnew',
					['<a-s>'] = 'open_split',
					['<a-v>'] = 'open_vsplit',
					['z<s-c>'] = 'close_all_nodes',
					['z<s-o>'] = 'expand_all_nodes',

					['<a-i>'] = 'show_file_details',
					['<a-y>'] = 'path_copy_selector',
					['<c-a-o>'] = 'open_with_file_explorer',

					['<a-o>c'] = 'order_by_created',
					['<a-o>d'] = 'order_by_diagnostics',
					['<a-o>g'] = 'order_by_git_status',
					['<a-o>m'] = 'order_by_modified',
					['<a-o>n'] = 'order_by_name',
					['<a-o>s'] = 'order_by_size',
					['<a-o>t'] = 'order_by_type',
				},
			},

			filesystem = {
				bind_to_cwd = true,
				hijack_netrw_behavior = 'open_current',
				follow_current_file = { enabled = true },
				use_libuv_file_watcher = true,
				window = {
					mappings = {
						-- none, relative, absolute
						['<a-n>'] = { 'add', nowait = true, config = { show_path = 'relative' } },
						['<a-c>'] = { 'copy', nowait = true, config = { show_path = 'relative' } },
						['<a-m>'] = { 'move', nowait = true, config = { show_path = 'relative' } },
						['<a-d>'] = 'delete',
						['<a-r>'] = 'rename',

						['<a-p>'] = 'paste_from_clipboard',
						['<a-x>'] = 'cut_to_clipboard',

						['<a-f>'] = 'filter_on_submit',
						['<a-h>'] = 'toggle_hidden',

						['H'] = 'navigate_up',
						['.'] = 'set_root',

						-- ['/'] = 'fuzzy_finder',
						-- ['#'] = 'fuzzy_sorter',
						-- ['<c-c>'] = 'clear_filter',
						-- ['A'] = 'add_directory',
						-- ['D'] = 'fuzzy_finder_directory',
					},
				},
			},
		},
	},

	{ -- Easy location list
		'folke/trouble.nvim',
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
		keys = function()
			return {
				{ '<leader>xx', '<cmd>Trouble diagnostics toggle filter.buf=0 <cr>', desc = 'Diagnostics (buffer)' },
				{ '<leader>xX', '<cmd>Trouble diagnostics toggle <cr>', desc = 'Diagnostics' },
				{ '<leader>xl', '<cmd>Trouble loclist toggle <cr>', desc = 'Locations' },
				{ '<leader>xq', '<cmd>Trouble quickfix toggle <cr>', desc = 'Quickfixes' },
				{
					'[q',
					function()
						if require('trouble').is_open() then
							require('trouble').prev { skip_groups = true, jump = true }
						else
							local ok, err = pcall(vim.cmd.cprev)
							if not ok then vim.notify(err, vim.log.levels.ERROR) end
						end
					end,
					desc = 'Previous Trouble/Quickfix Item',
				},
				{
					']q',
					function()
						if require('trouble').is_open() then
							require('trouble').next { skip_groups = true, jump = true }
						else
							local ok, err = pcall(vim.cmd.cnext)
							if not ok then vim.notify(err, vim.log.levels.ERROR) end
						end
					end,
					desc = 'Next Trouble/Quickfix Item',
				},
			}
		end,
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

	{ -- better ts error ui
		'OlegGulevskyy/better-ts-errors.nvim',
		ft = { 'typescript', 'typescriptreact' },
		opts = {
			keymaps = {
				toggle = '<leader>dd', -- default '<leader>dd'
				go_to_definition = '<leader>dx', -- default '<leader>dx'
			},
		},
	},

	-- Automatically set indent settings base on the content of the file
	{
		'tpope/vim-sleuth',
		event = 'VeryLazy',
		priority = 1000,
		init = function()
			vim.g.sleuth_heuristics = 1
			vim.g.sleuth_ps1_heuristics = 0
		end,
	},

	{
		'SuperBo/fugit2.nvim',
		opts = {
			width = 100,
		},
		cmd = { 'Fugit2', 'Fugit2Diff', 'Fugit2Graph' },
		keys = {
			{ '<leader>gf', mode = 'n', '<cmd>Fugit2<cr>' },
		},
	},
	{
		'sindrets/diffview.nvim',
		cmd = {
			'DiffviewFileHistory',
			'DiffviewOpen',
			'DiffviewToggleFiles',
			'DiffviewFocusFiles',
			'DiffviewRefresh',
		},
	},
}
