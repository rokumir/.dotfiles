---@diagnostic disable: missing-fields
local icons = LazyVim.config.icons
icons.misc.modified = '✨'
icons.misc.readonly = '🔒'

local bt_config = require 'config.const.buffertype'
local ft_config = require 'config.const.filetype'

---@module 'lazy'
---@type LazyPluginSpec[]
return {
	{ ---@module 'noice' Better general UI (should be deprecated soon)
		'folke/noice.nvim',
		keys = function() return {} end,
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
				progress = { enabled = false },
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
		dependencies = {
			-- disable navic in lualine
			{ 'SmiteshP/nvim-navic', optional = true, opts = function() return { lazy_update_context = true } end },
		},
		opts = function(_, opts)
			opts.options.globalstatus = true
			opts.options.always_show_tabline = false
			opts.options.always_divide_middle = true
			opts.options.component_separators = { left = '', right = '' }
			opts.options.section_separators = { left = '', right = '' }
			opts.options.refresh = { refresh_time = 16, statusline = 16 } -- ~60fps

			opts.sections.lualine_c = {
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
			}

			vim.list_extend(opts.sections.lualine_x, {
				{ -- word count
					function()
						local wc = vim.fn.wordcount()
						return wc.words .. 'w ' .. wc.chars .. 'c'
					end,
					color = 'PreCondit',
					separator = '',
					cond = function() return ft_config.document_map[vim.bo.ft] end,
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
			})

			opts.sections.lualine_y = {
				'location',
				{ function() return require('utils.datetime').format.pretty_date() end },
			}
			opts.sections.lualine_z = {
				{ function() return require('utils.datetime').format.pretty_time() end },
			}

			---- Highlights config
			-- Transparent lualine fill bg
			local theme = require 'lualine.themes.auto'
			local lualine_modes = { 'insert', 'normal', 'visual', 'command', 'replace', 'inactive', 'terminal' }
			for _, mode in ipairs(lualine_modes) do
				if theme[mode] and theme[mode].c then theme[mode].c.bg = 'NONE' end
			end
			opts.options.theme = theme
		end,
	},

	{ -- Tabs
		'akinsho/bufferline.nvim',
		keys = function()
			local keys = {
				{ '<tab>', '<cmd>BufferLineCycleNext<cr>', desc = 'Tab: Next' },
				{ '<s-tab>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Tab: Prev' },
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
							{ icon = '󰥨 ', text = 'Directory'          , cmd = 'BufferLineSortByDirectory'         , hl = 'DiagnosticInfo' },
							{ icon = '󰥨 ', text = 'Relative Directory' , cmd = 'BufferLineSortByRelativeDirectory' , hl = '@namespace'     },
							{ icon = ' ', text = 'Extension'          , cmd = 'BufferLineSortByExtension'         , hl = 'Error'     },
							{ icon = '󱎅 ', text = 'Tabs'               , cmd = 'BufferLineSortByTabs'              , hl = 'DiagnosticHint' },
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

			keys[#keys + 1] = { '<c-tab>', '<cmd>BufferLineCycleNext<cr>', desc = 'Tab: Next' }
			keys[#keys + 1] = { '<c-s-tab>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Tab: Prev' }

			return keys
		end,
		---@module 'bufferline'
		---@type bufferline.UserConfig
		opts = {
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
				modified_icon = icons.misc.modified,
				sort_by = 'insert_at_end',
				hover = { enabled = true, delay = 200 },

				close_command = function(bufnr) require('utils.buffer').bufremove(bufnr) end,
				middle_mouse_command = function(bufnr) require('utils.buffer').bufremove(bufnr) end,
			},
			highlights = {},
		},
	},
	{
		'akinsho/bufferline.nvim',
		optional = true,
		opts = function(_, opts)
			local config = require 'config.const.bufferline'

			for _, hl in pairs(config.transparent_bg_highlights) do
				opts.highlights[hl] = vim.tbl_extend('force', opts.highlights[hl] or {}, { bg = 'none' })
			end

			local indicator_color = setmetatable({
				['rose-pine'] = function() return require('rose-pine.palette').love end,
			}, {
				__index = function(t, k)
					return rawget(t, k) or function() return '#E84D4F' end
				end,
			})[vim.g.colors_name]()
			for _, hl in pairs(config.underline_highlights) do
				opts.highlights[hl] = vim.tbl_extend('force', opts.highlights[hl] or {}, { sp = indicator_color })
			end
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
				require('utils.keymap').map {
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
		---@type dropbar_configs_t
		opts = {
			sources = {
				path = { max_depth = 1, modified = function(sym)
					return sym:merge {
						name = sym.name .. ' ' .. icons.misc.modified,
						name_hl = 'Error',
					}
				end },
			},
			bar = {
				padding = { left = 2, right = 2 },
				sources = function(buf)
					local sources = require 'dropbar.sources'
					local fallback = require('dropbar.utils').source.fallback

					if vim.bo[buf].ft == 'markdown' then return { sources.path, sources.markdown } end
					if vim.bo[buf].buftype == 'terminal' then return { sources.terminal } end

					return {
						-- dropbar_sources.path,
						fallback { sources.lsp, sources.treesitter },
					}
				end,
			},
		},
	},

	{ -- A Neovim plugin to easily create and manage predefined window layouts, bringing a new edge to your workflow.
		'folke/edgy.nvim',
		optional = true,
		keys = {
			{ '<c-\\><c-\\>', function() require('edgy').goto_main() end, mode = { 'n', 'i', 't' }, desc = 'Edgy Focus Main' },
		},
		---@module 'edgy'
		---@param opts Edgy.Config
		opts = function(_, opts)
			opts.keys['<c-a-left>'] = function(win) win:resize('width', 1) end
			opts.keys['<c-a-right>'] = function(win) win:resize('width', -1) end
			opts.keys['<c-a-up>'] = function(win) win:resize('height', 1) end
			opts.keys['<c-a-down>'] = function(win) win:resize('height', -1) end

			vim.list_extend(opts.right, {
				{
					ft = 'copilot-chat',
					size = { width = 0.35, height = 0.35 },
					pinned = true,
					open = 'CopilotChatToggle',
				},
			})
		end,
	},

	{ -- better folding treesitter
		'kevinhwang91/nvim-ufo',
		dependencies = 'kevinhwang91/promise-async',
		lazy = false,
		keys = {
			{ 'zO', function() require('ufo').openAllFolds() end, nowait = true, desc = 'Unfold All' },
			{ 'zC', function() require('ufo').closeAllFolds() end, nowait = true, desc = 'Fold All' },
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
			fold_virt_text_handler = require('utils.ufo').make_fold_handler {
				icon = '',
			},
		},
	},
}
