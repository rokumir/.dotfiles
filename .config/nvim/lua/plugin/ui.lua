local hl_color = require('snacks.util').color

---@module 'lazy'
---@type LazyPluginSpec[]
return {
	{ ---@module 'noice' Better general UI (should be deprecated soon)
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
		'nvim-lualine/lualine.nvim',
		optional = true,
		lazy = false,
		opts = function()
			local icons = LazyVim.config.icons
			local opts = {
				options = {
					disabled_filetypes = {
						statusline = require('config.const.filetype').ignored_list,
					},
					globalstatus = true,
					always_show_tabline = false,
					always_divide_middle = true,
					component_separators = { left = '', right = '' },
					section_separators = { left = '', right = '' },
					refresh = { refresh_time = 16, statusline = 16 }, -- ~60fps
				},
				sections = {
					lualine_a = { 'mode' },
					lualine_b = {
						'branch',
						{
							'diff',
							symbols = {
								added = icons.git.added,
								modified = icons.git.modified,
								removed = icons.git.removed,
							},
							source = function()
								local gitsigns = vim.b.gitsigns_status_dict
								if gitsigns then return {
									added = gitsigns.added,
									modified = gitsigns.changed,
									removed = gitsigns.removed,
								} end
							end,
						},
					},

					lualine_c = {
						LazyVim.lualine.root_dir(),
						{ 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
						{
							LazyVim.lualine.pretty_path {
								length = 3,
								relative = 'cwd',
								modified_hl = 'Error',
								directory_hl = 'Comment',
								filename_hl = 'Conditional',
								modified_sign = icons.misc.modified,
								readonly_icon = icons.misc.readonly,
							},
						},
						{
							'diagnostics',
							symbols = {
								error = icons.diagnostics.Error,
								warn = icons.diagnostics.Warn,
								info = icons.diagnostics.Info,
								hint = icons.diagnostics.Hint,
							},
						},
					},

					lualine_x = {
						require('snacks.profiler').status(),
						{ -- shows key typing
							function() return require('noice').api.status.command.get() end,
							cond = function() return package.loaded['noice'] and require('noice').api.status.command.has() end,
							color = { fg = hl_color 'Statement' },
						},
						{
							function() return require('noice').api.status.mode.get() end,
							cond = function() return package.loaded['noice'] and require('noice').api.status.mode.has() end,
							color = { fg = hl_color 'Constant' },
						},
						{ -- Dap
							function() return '  ' .. require('dap').status() end,
							cond = function() return package.loaded['dap'] and require('dap').status() ~= '' end,
							color = { fg = hl_color 'Debug' },
						},
						{ -- word count
							function()
								local wc = vim.fn.wordcount()
								return wc.words .. 'w ' .. wc.chars .. 'c'
							end,
							color = 'PreCondit',
							separator = '',
							cond = function() return require('config.const.filetype').document_map[vim.bo.ft] end,
						},
						{
							'encoding',
							color = 'PreCondit',
							separator = '',
							cond = function() return (vim.bo.fenc or vim.go.enc) ~= 'utf-8' end,
						},
						{
							'fileformat',
							symbols = { unix = 'lf', dos = 'crlf', mac = 'cr' },
							color = 'PreCondit',
							separator = '',
							cond = function() return vim.bo.ff ~= 'unix' end,
						},
					},

					lualine_y = {
						'location',
						{ function() return require('util.datetime').format.pretty_date() end },
					},
					lualine_z = {
						{ function()
							return require('util.datetime').format.pretty_time(nil, {
								hour12 = false,
							})
						end },
					},
				},
			}

			-- -- do not add trouble symbols if aerial is enabled
			-- -- And allow it to be overriden for some buffer types (see autocmds)
			-- if vim.g.trouble_lualine and LazyVim.has 'trouble.nvim' then
			-- 	local trouble = require 'trouble'
			-- 	local symbols = trouble.statusline {
			-- 		mode = 'symbols',
			-- 		groups = {},
			-- 		title = false,
			-- 		filter = { range = true },
			-- 		format = '{kind_icon}{symbol.name:Normal}',
			-- 		hl_group = 'lualine_c_normal',
			-- 	}
			-- 	table.insert(opts.sections.lualine_c, {
			-- 		symbols and symbols.get,
			-- 		cond = function() return vim.b.trouble_lualine ~= false and symbols.has() end,
			-- 	})
			-- end

			-- Transparent lualine fill bg
			local theme = require 'lualine.themes.auto'
			local lualine_modes = { 'insert', 'normal', 'visual', 'command', 'replace', 'inactive', 'terminal' }
			for _, mode in ipairs(lualine_modes) do
				if theme[mode] then
					if theme[mode].c then
						theme[mode].c.bg = 'NONE'
						theme[mode].c.fg = hl_color 'MutedText'
					end
					-- if theme[mode].x then theme[mode].x.bg = 'NONE' end
				end
			end
			opts.options.theme = theme

			return opts
		end,
	},

	{ -- Tabs
		'akinsho/bufferline.nvim',
		keys = function()
			--stylua: ignore
			local cycle_keys = vim.g.neovide
				and { next = '<c-tab>', prev = '<c-s-tab>' }
				or { next = '<tab>', prev = '<s-tab>' }
			return {
				{ cycle_keys.next, '<cmd>BufferLineCycleNext<cr>', desc = 'Tab: Next' },
				{ cycle_keys.prev, '<cmd>BufferLineCyclePrev<cr>', desc = 'Tab: Prev' },
				{ '<c-s-right>', '<cmd>BufferLineMoveNext<cr>', desc = 'Tab: Move Right' },
				{ '<c-s-left>', '<cmd>BufferLineMovePrev<cr>', desc = 'Tab: Move Left' },

				{ '<a-1>', '<cmd>BufferLineGoToBuffer 1<cr>', desc = 'Tab: Go To 1' },
				{ '<a-2>', '<cmd>BufferLineGoToBuffer 2<cr>', desc = 'Tab: Go To 2' },
				{ '<a-3>', '<cmd>BufferLineGoToBuffer 3<cr>', desc = 'Tab: Go To 3' },
				{ '<a-4>', '<cmd>BufferLineGoToBuffer 4<cr>', desc = 'Tab: Go To 4' },
				{ '<a-5>', '<cmd>BufferLineGoToBuffer 5<cr>', desc = 'Tab: Go To 5' },
				{ '<a-6>', '<cmd>BufferLineGoToBuffer 6<cr>', desc = 'Tab: Go To 6' },
				{ '<a-7>', '<cmd>BufferLineGoToBuffer 7<cr>', desc = 'Tab: Go To 7' },
				{ '<a-8>', '<cmd>BufferLineGoToBuffer 8<cr>', desc = 'Tab: Go To 8' },
				{ '<a-9>', '<cmd>BufferLineGoToBuffer 9<cr>', desc = 'Tab: Go To 9' },
				{ '<a-0>', '<cmd>BufferLineGoToBuffer -1<cr>', desc = 'Tab: Go To Last' },

				{ '<leader>b', '', desc = 'buffer/tab' },
				{ '<leader>bp', '<cmd>BufferLineTogglePin<cr>', desc = 'Pin/Unpin' },
				{ '<leader>bb', '<cmd>BufferLinePick<cr>', desc = 'Pick' },
				{ '<leader>bB', '<cmd>BufferLinePickClose<cr>', desc = 'Delete Pick' },

				{
					desc = 'Sort',
					'<leader>bs',
					function()
						Snacks.picker.pick {
							source = 'tabs_sort_actions',
							title = 'Sort tabs by',
							layout = 'vscode_focus',
							-- stylua: ignore
							items = {
								{ icon = '󰥨 ', text = 'Directory'         , cmd = 'BufferLineSortByDirectory'        , hl = 'DiagnosticInfo' },
								{ icon = '󰥨 ', text = 'Relative Directory', cmd = 'BufferLineSortByRelativeDirectory', hl = '@namespace'     },
								{ icon = ' ', text = 'Extension'         , cmd = 'BufferLineSortByExtension'        , hl = 'Error'     },
								{ icon = '󱎅 ', text = 'Tabs'              , cmd = 'BufferLineSortByTabs'             , hl = 'DiagnosticHint' },
							},
							format = function(item)
								return {
									{ item.icon, item.hl },
									{ ' ' .. item.text .. ' ', item.hl },
									{ item.cmd, 'Comment' },
								}
							end,
							confirm = function(picker, item)
								picker:close()
								if not item then Snacks.notify.error('Picker "' .. picker.opts.source .. '":\nItem not found!') end
								vim.cmd[item.cmd]()
								Snacks.notify('Bufferline sort by ' .. item.text)
							end,
						}
					end,
				},
			}
		end,
		opts = function()
			---@module 'bufferline'
			---@type bufferline.UserConfig
			local opts = {
				options = {
					show_close_icon = false,
					always_show_bufferline = false,
					show_buffer_close_icons = false,
					show_buffer_icons = true,
					show_tab_indicators = true,
					enforce_regular_tabs = true,

					mode = 'buffers',
					indicator = { style = 'underline' },
					separator_style = { '', '' },
					modified_icon = LazyVim.config.icons.misc.modified,
					sort_by = 'insert_at_end',
					hover = { enabled = true, delay = 200 },
					diagnostics = 'nvim_lsp',
					diagnostics_indicator = function(_, _, diag)
						local icons = LazyVim.config.icons.diagnostics
						local ret = (diag.error and icons.Error .. diag.error .. ' ' or '') .. (diag.warning and icons.Warn .. diag.warning or '')
						return vim.trim(ret)
					end,
					offsets = {
						{ filetype = 'snacks_layout_box' },
					},
					get_element_icon = function(opts) return LazyVim.config.icons.ft[opts.filetype] end,

					close_command = function(n) Snacks.bufdelete(n) end,
					middle_mouse_command = function(n) Snacks.bufdelete(n) end,
				},
				highlights = {},
			}

			local config = require 'config.const.bufferline'
			for _, hl in pairs(config.transparent_bg_highlights) do
				opts.highlights[hl] = vim.tbl_extend('force', opts.highlights[hl] or {}, { bg = 'none' })
			end

			local _, indicator_color = pcall(({
				['rose-pine'] = function() return require('rose-pine.palette').love end,
			})[vim.g.colors_name] or function() return '#E84D4F' end)
			for _, hl in pairs(config.underline_highlights) do
				opts.highlights[hl] = vim.tbl_extend('force', opts.highlights[hl] or {}, { sp = indicator_color })
			end

			return opts
		end,
	},

	{ -- filename
		'b0o/incline.nvim',
		event = 'BufReadPre',
		priority = 1200,
		opts = function()
			local opts = {
				window = {
					margin = { vertical = 0, horizontal = 1 },
				},
				hide = {
					cursorline = true,
				},
				ignore = {
					filetypes = require('config.const.filetype').ignored_list,
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
						{ ' ' },
						{ filename },
					}
				end,
			}

			return opts
		end,
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
				require('util.keymap').map {
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
			{ '<leader>;', function() require('dropbar.api').pick() end, desc = 'Pick symbols in winbar' },
			{ '[;', function() require('dropbar.api').goto_context_start() end, desc = 'Go to start of current c }ontext' },
			{ '];', function() require('dropbar.api').select_next_context() end, desc = 'Select next context' },
		},
		opts = function()
			local sources = require 'dropbar.sources'
			local source_fallback = require('dropbar.utils').source.fallback
			---@type dropbar_configs_t
			return {
				sources = {
					path = { max_depth = 1, modified = function(sym)
						return sym:merge {
							name = sym.name,
							name_hl = 'Error',
						}
					end },
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
			{ 'zO', '<cmd>set foldlevel=99 <cr>', nowait = true, desc = 'Unfold All' },
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
			fold_virt_text_handler = require('util.ufo').make_fold_handler {
				icon = '',
			},
		},
	},
}
