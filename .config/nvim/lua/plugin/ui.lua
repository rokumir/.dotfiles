local function hl_color(groups, prop) return require('snacks.util').color(groups, prop) end
local snacks_tabpages = require('nihil.plugin.bufferline').picker.tabpages

---@module 'lazy'
---@type LazyPluginSpec[]
return {
	{ ---@module 'noice' Better general UI
		'folke/noice.nvim',
		keys = function() return {} end,
		---@module 'noice'
		---@type NoiceConfig
		opts = {
			presets = {
				bottom_search = true,
				command_palette = true,
				lsp_doc_border = true,
				inc_rename = false,
				cmdline_output_to_split = true,
				long_message_to_split = true,
			},

			lsp = {
				progress = { enabled = true },
				hover = {
					enabled = true,
					silent = true,
					opts = {
						size = { max_width = 80 },
					},
				},
				signature = {
					enabled = true,
					opts = { max_size = 80 },
					auto_open = { enabled = false, trigger = false, throttle = 50 },
				},
				override = {
					['vim.lsp.util.convert_input_to_markdown_lines'] = true,
					['vim.lsp.util.stylize_markdown'] = true,
					['cmp.entry.get_documentation'] = true,
				},
			},
		},
	},

	{ -- Statusline
		'lualine.nvim',
		optional = true,
		event = 'VeryLazy',

		keys = {
			{
				'<leader><leader>ul',
				function()
					vim.g.nihil_lualine_unhide = not vim.g.nihil_lualine_unhide
					require('lualine').hide { place = { 'statusline' }, unhide = vim.g.nihil_lualine_unhide }
					Snacks.notify((vim.g.nihil_lualine_unhide and 'Enable' or 'Disable') .. ' Lualine Statusline')
				end,
				desc = 'Toggle Lualine Statusline',
			},
		},

		opts = function(_, opts)
			require('lualine_require').require = require -- PERF: we don't need this lualine require madness 🤷
			vim.o.laststatus = vim.g.lualine_laststatus

			local Icons = LazyVim.config.icons

			local function color_fn(group)
				return function() return { fg = hl_color(group, 'fg') } end
			end

			local o = opts.options
			o.globalstatus = vim.o.laststatus == 3
			o.always_show_tabline = false
			o.always_divide_middle = true
			o.component_separators = { left = '', right = '' }
			o.section_separators = { left = '', right = '' }
			o.refresh = { refresh_time = 16, statusline = 16 } -- ~60fps
			o.disabled_filetypes = {
				statusline = {
					'dashboard',
					'alpha',
					'ministarter',
					'snacks_dashboard',
				},
			}

			local s = opts.sections
			s.lualine_a = { 'mode' }
			s.lualine_b = {
				{ 'branch', color = color_fn 'SnacksPickerGitBranch' },
				{
					'diff',
					symbols = {
						added = Icons.git.added,
						modified = Icons.git.modified,
						removed = Icons.git.removed,
					},
					source = function()
						local gitsigns = vim.b.gitsigns_status_dict
						if gitsigns then
							return {
								added = gitsigns.added,
								modified = gitsigns.changed,
								removed = gitsigns.removed,
							}
						end
					end,
				},
			}
			s.lualine_c = {
				LazyVim.lualine.root_dir(),
				{
					'filetype',
					colored = true,
					icon_only = true,
					separator = '',
					padding = { left = 1, right = 0 },
					color = color_fn 'Attribute',
				},
				{
					LazyVim.lualine.pretty_path {
						length = 3,
						relative = 'cwd',
						modified_hl = 'Error',
						directory_hl = 'Comment',
						filename_hl = 'Conditional',
						modified_sign = ' ' .. Icons.misc.modified,
						readonly_icon = ' ' .. Icons.misc.readonly,
					},
				},
				{
					'diagnostics',
					symbols = {
						error = Icons.diagnostics.Error,
						warn = Icons.diagnostics.Warn,
						info = Icons.diagnostics.Info,
						hint = Icons.diagnostics.Hint,
					},
				},
			}

			s.lualine_x = {
				Snacks.profiler.status(),
				{ -- shows key typing
					function() return require('noice').api.status.command['get']() end,
					cond = function() return package.loaded['noice'] and require('noice').api.status.command['has']() end,
					color = color_fn 'Statement',
				},
				{
					function() return require('noice').api.status.mode['get']() end,
					cond = function() return package.loaded['noice'] and require('noice').api.status.mode['has']() end,
					color = color_fn 'Constant',
				},
				{ -- Dap
					function() return '  ' .. require('dap').status() end,
					cond = function() return package.loaded['dap'] and require('dap').status() ~= '' end,
					color = color_fn 'Debug',
				},
			}
			s.lualine_y = {
				{ -- word count
					function()
						local wc = vim.fn.wordcount()
						return wc.words .. 'w ' .. wc.chars .. 'c'
					end,
					cond = function() return Nihil.config.exclude.document_filetypes_map[vim.bo.ft] end,
				},
				{ 'encoding', cond = function() return (vim.bo.fenc or vim.go.enc) ~= 'utf-8' end },
				{
					'fileformat',
					symbols = { unix = 'lf', dos = 'crlf', mac = 'cr' },
					cond = function() return vim.bo.ff ~= 'unix' end,
				},
				{ 'location', separator = ' ', padding = { left = 1, right = 0 } },
				{ 'progress', padding = { left = 0, right = 1 } },
			}
			s.lualine_z = {
				{ function() return Nihil.datetime.pretty_date() end, cond = function() return vim.g.nihil_lualine_time_expanded end },
				{ function() return Nihil.datetime.pretty_time(nil, { hour12 = false }) end },
			}

			return opts
		end,
	},

	{ ---@module 'bufferline' Tabs
		'akinsho/bufferline.nvim',
		keys = function()
			local is_tmux = vim.env.TERM_PROGRAM == 'tmux'
			local next_tab_key = is_tmux and 'tn' or '<c-tab>'
			local prev_tab_key = is_tmux and 'tp' or '<c-s-tab>'

			return {
				{ '<tab>', '<cmd>BufferLineCycleNext <cr>', desc = 'Next Buffer', mode = { 'n', 't' } },
				{ '<s-tab>', '<cmd>BufferLineCyclePrev <cr>', desc = 'Prev Buffer', mode = { 'n', 't' } },
				{ next_tab_key, '<cmd>tabnext <cr>', desc = 'Next Tab' },
				{ prev_tab_key, '<cmd>tabprevious <cr>', desc = 'Prev Tab' },
				{ '<c-s-right>', '<cmd>BufferLineMoveNext <cr>', desc = 'Move Tab to Right' },
				{ '<c-s-left>', '<cmd>BufferLineMovePrev <cr>', desc = 'Move Tab to Left' },

				{ '<a-1>', '<cmd>BufferLineGoToBuffer 1 <cr>', desc = 'Go To Buffer 1' },
				{ '<a-2>', '<cmd>BufferLineGoToBuffer 2 <cr>', desc = 'Go To Buffer 2' },
				{ '<a-3>', '<cmd>BufferLineGoToBuffer 3 <cr>', desc = 'Go To Buffer 3' },
				{ '<a-4>', '<cmd>BufferLineGoToBuffer 4 <cr>', desc = 'Go To Buffer 4' },
				{ '<a-5>', '<cmd>BufferLineGoToBuffer 5 <cr>', desc = 'Go To Buffer 5' },
				{ '<a-6>', '<cmd>BufferLineGoToBuffer 6 <cr>', desc = 'Go To Buffer 6' },
				{ '<a-7>', '<cmd>BufferLineGoToBuffer 7 <cr>', desc = 'Go To Buffer 7' },
				{ '<a-8>', '<cmd>BufferLineGoToBuffer 8 <cr>', desc = 'Go To Buffer 8' },
				{ '<a-9>', '<cmd>BufferLineGoToBuffer 9 <cr>', desc = 'Go To Buffer 9' },
				{ '<a-0>', '<cmd>BufferLineGoToBuffer -1 <cr>', desc = 'Go To Last Buffer' },

				{ '<leader>b', '', desc = 'buffer' },
				{ '<leader>bp', '<cmd>BufferLineTogglePin <cr>', desc = 'Pin/Unpin' },
				{ '<leader>bb', '<cmd>BufferLinePick <cr>', desc = 'Pick' },
				{ '<leader>bB', '<cmd>BufferLinePickClose <cr>', desc = 'Delete Pick' },

				{
					'<leader>bs',
					function() require('nihil.plugin.bufferline').picker.sort_actions() end,
					desc = 'Sort Actions',
				},

				{ ';T', snacks_tabpages, desc = 'Tabpages' },
				{ '<leader>tt', snacks_tabpages, desc = 'Picker' },
				{ '<leader>td', '<cmd>tabclose<cr>', desc = 'Close' },
				{
					'<leader>tr',
					function() Snacks.input.input({ icon = '󰓪 ', prompt = 'Rename tab' }, vim.cmd.BufferLineTabRename) end,
					desc = 'Rename',
				},
				{
					'<leader>tN',
					function()
						Snacks.input.input({ icon = '󰓪 ', prompt = 'New tab' }, function(new_name)
							vim.cmd.tabnew()
							vim.cmd.BufferLineTabRename(new_name)
						end)
					end,
					desc = 'New with Name',
				},
			}
		end,
		---@type bufferline.UserConfig
		opts = {
			options = {
				show_close_icon = false,
				always_show_bufferline = false,
				auto_toggle_bufferline = true,
				show_buffer_close_icons = false,
				show_buffer_icons = true,
				show_tab_indicators = true,
				enforce_regular_tabs = false,

				mode = 'buffers',
				indicator = { style = 'underline' },
				separator_style = { '', '' },
				sort_by = 'insert_at_end',
				hover = { enabled = true, delay = 200 },

				close_command = function(n) Snacks.bufdelete(n) end,
				middle_mouse_command = function(n) Snacks.bufdelete(n) end,
			},
			highlights = function()
				local settings = {}
				local hl = require('nihil.plugin.bufferline').highlights
				hl.set_bg_transparent(settings)
				hl.style_underline(settings)
				return settings
			end,
		},
	},

	{ -- filename
		'b0o/incline.nvim',
		event = 'BufReadPre',
		priority = 1200,
		opts = {
			window = {
				margin = { vertical = 0, horizontal = 1 },
				zindex = 1,
			},
			hide = {
				cursorline = true,
			},
			ignore = {
				filetypes = Nihil.config.exclude.filetypes,
				floating_wins = true,
				unlisted_buffers = true,
			},
			render = function(props)
				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
				local ft_icon, ft_color = require('nvim-web-devicons').get_icon_color(filename)

				if vim.bo[props.buf].modified then
					local modified_icon = LazyVim.config.icons.misc.modified or '[+]'
					filename = filename .. ' ' .. modified_icon
				end

				return {
					{ ft_icon, guifg = ft_color },
					{ '  ' },
					{ filename },
				}
			end,
		},
	},

	{ -- Git status in line number
		'lewis6991/gitsigns.nvim',
		opts = function(_, opts)
			local char_bar = '│'
			local char_chev = ''
			opts.signs.add.text = char_bar
			opts.signs.change.text = char_bar
			opts.signs.delete.text = char_chev
			opts.signs.topdelete.text = char_chev
			opts.signs.changedelete.text = char_bar
			opts.signs.untracked.text = char_bar

			opts.on_attach = function(buffer)
				Nihil.keymap {
					buffer = buffer,
					{ ']h', '<cmd>Gitsigns nav_hunk next<cr>', desc = 'Next Hunk' },
					{ '[h', '<cmd>Gitsigns nav_hunk prev<cr>', desc = 'Prev Hunk' },

					{ '<leader>ghu', '<cmd>Gitsigns undo_stage_hunk<cr>', desc = 'Undo Stage Hunk' },
					{ '<leader>ghp', '<cmd>Gitsigns preview_hunk_inline<cr>', desc = 'Preview Hunk Inline' },
					{ '<leader>ghb', '<cmd>Gitsigns toggle_current_line_blame<cr>', desc = 'Toggle line blame' },

					{ '<leader>ghs', '<cmd>Gitsigns stage_hunk<cr>', mode = { 'n', 'v' }, desc = 'Stage Hunk' },
					{ '<leader>gh<s-s>', '<cmd>Gitsigns stage_buffer<cr>', desc = 'Stage Buffer' },
					{ '<leader>ghr', '<cmd>Gitsigns reset_hunk<cr>', mode = { 'n', 'v' }, desc = 'Reset Hunk' },
					{ '<leader>gh<s-r>', '<cmd>Gitsigns reset_buffer<cr>', desc = 'Reset Buffer' },
				}
			end
		end,
	},

	{ -- breadcrumb
		'Bekaboo/dropbar.nvim',
		lazy = false,
		keys = {
			{ ';so', function() require('dropbar.api').pick() end, desc = 'Pick symbols in winbar' },
			{ '[;', function() require('dropbar.api').goto_context_start() end, desc = 'Previous LSP context' },
			{ '];', function() require('dropbar.api').select_next_context() end, desc = 'Next LSP context' },
		},
		opts = function()
			local sources = require 'dropbar.sources'
			local source_fallback = require('dropbar.utils').source.fallback
			---@type dropbar_configs_t
			return {
				sources = {
					path = {
						max_depth = 1,
						modified = function(sym)
							return sym:merge {
								name = sym.name,
								name_hl = 'Error',
							}
						end,
					},
				},
				bar = {
					padding = { left = 2, right = 2 },
					sources = function(buf)
						if vim.bo[buf].ft == 'markdown' then return { sources.markdown } end
						if vim.bo[buf].buftype == 'terminal' then return { sources.terminal } end

						return {
							-- dropbar_sources.path,
							source_fallback { sources.lsp, sources.treesitter },
						}
					end,
				},
			}
		end,
	},

	{ -- better folding treesitter
		'kevinhwang91/nvim-ufo',
		dependencies = 'kevinhwang91/promise-async',
		lazy = false,
		keys = {
			-- { 'zO', function() require('ufo').openAllFolds() end, nowait = true, desc = 'Unfold All' },
			-- { 'zC', function() require('ufo').closeAllFolds() end, nowait = true, desc = 'Fold All' },
			{ 'zO', '<cmd>set foldlevel=30 <cr>', nowait = true, desc = 'Unfold All' },
			{ 'zC', '<cmd>set foldlevel=0  <cr>', nowait = true, desc = 'Fold All' },
			{ ']u', function() require('ufo').goNextClosedFold() end, nowait = true, desc = 'Fold: Next' },
			{ '[u', function() require('ufo').goPreviousClosedFold() end, nowait = true, desc = 'Fold: Prev' },
		},
		opts = {
			open_fold_hl_timeout = 150,
			close_fold_kinds_for_ft = {
				default = { 'imports', 'comment' },
				json = { 'array' },
				c = { 'comment', 'region' },
			},
			enable_get_fold_virt_text = true,
			fold_virt_text_handler = require('nihil.plugin.ufo').make_fold_handler {
				icon = '',
				pad_right = '   ',
				pad_left = '  ',
				fill_char = '─',
			},
		},
	},
}
