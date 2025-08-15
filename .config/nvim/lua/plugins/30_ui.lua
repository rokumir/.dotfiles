---@diagnostic disable: no-unknown, assign-type-mismatch
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

			commands = {
				all = { -- options for the message history that you get with `:Noice`
					view = 'split',
					opts = { enter = true, format = 'details' },
					filter = {},
				},
			},

			lsp = {
				progress = { enabled = false },
				hover = {
					enabled = true,
					silent = true,
					---@type NoiceViewOptions
					opts = {
						size = { max_width = 80 },
					},
				},
				override = {
					['vim.lsp.util.convert_input_to_markdown_lines'] = true,
					['vim.lsp.util.stylize_markdown'] = true,
					['cmp.entry.get_documentation'] = true,
				},
			},

			signature = {
				enabled = true,
				---@type NoiceViewOptions
				opts = {
					max_size = 80,
				},
			},
		},
	},

	{ -- Statusline
		'nvim-lualine/lualine.nvim',
		opts = {
			options = {
				globalstatus = true,
				component_separators = { left = '', right = '' },
				section_separators = { left = '', right = '' },
			},
			sections = {
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
							modified_sign = ' ✨ ',
							readonly_icon = ' 🔒 ',
						},
					},
					{
						'diagnostics',
						symbols = {
							error = LazyVim.config.icons.diagnostics.Error,
							warn = LazyVim.config.icons.diagnostics.Warn,
							info = LazyVim.config.icons.diagnostics.Info,
							hint = LazyVim.config.icons.diagnostics.Hint,
						},
					},
				},

				lualine_y = {
					'location',
					{ function() return require('utils.datetime').format.pretty_date() end },
				},
				lualine_z = {
					{ function() return require('utils.datetime').format.pretty_time() end },
				},
			},
		},
	},
	{ -- Statusline
		'nvim-lualine/lualine.nvim',
		opts = function(_, opts)
			local get_hl_color = require('utils.highlight').get
			local hl_color = { -- precall color
				muted = get_hl_color('Comment').fg,
				special = get_hl_color('PreCondit').fg,
			}

			local theme = opts.options.theme
			if type(theme) ~= 'table' then opts.options.theme = require('lualine.themes.' .. (theme or 'auto')) end

			for _, s in ipairs {
				{ path = { 'c', 'bg' }, color = 'none' },
				{ path = { 'c', 'fg' }, color = hl_color.muted },
			} do
				for _, mode in ipairs { 'normal', 'insert', 'visual', 'replace', 'command' } do
					opts.options.theme[mode][s.path[1]][s.path[2]] = 'none'
				end
			end

			vim.list_extend(opts.sections.lualine_x, {
				{ -- word count
					function()
						local wc = vim.fn.wordcount()
						return wc.words .. 'w ' .. wc.chars .. 'c'
					end,
					color = { gui = 'italic', fg = hl_color.special },
					separator = '',
					cond = function() return require('utils.const').filetype.document_map[vim.bo.ft] end,
				},
				{
					'encoding',
					color = { gui = 'italic', fg = hl_color.special },
					separator = '',
					cond = function() return (vim.bo.fenc or vim.go.enc) ~= 'utf-8' end,
				},
				{
					'fileformat',
					symbols = { unix = 'lf', dos = 'crlf', mac = 'cr' },
					color = { gui = 'italic', fg = hl_color.special },
					separator = '',
					cond = function() return vim.bo.ff ~= 'unix' end,
				},
			})

			--#region FIX: better macros' status updating
			local refresh_statusline = function() require('lualine').refresh { place = { 'statusline' } } end
			vim.api.nvim_create_autocmd('RecordingEnter', { callback = refresh_statusline })
			vim.api.nvim_create_autocmd('RecordingLeave', {
				callback = function()
					local callback = vim.schedule_wrap(refresh_statusline)
					vim.loop.new_timer():start(50, 0, callback)
				end,
			})
			--#endregion
		end,
	},
	-- disable navic in lualine
	{ 'SmiteshP/nvim-navic', optional = true, opts = function() return { lazy_update_context = true } end },

	{ -- Tabs
		'akinsho/bufferline.nvim',
		keys = {
			{ '<tab>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
			{ '<s-tab>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
			{ '<c-s-right>', '<cmd>BufferLineMoveNext<cr>', desc = 'Move buffer next' },
			{ '<c-s-left>', '<cmd>BufferLineMovePrev<cr>', desc = 'Move buffer prev' },
		},
		---@module 'bufferline'
		---@param opts bufferline.UserConfig
		opts = function(_, opts)
			opts.options = vim.tbl_extend('force', opts.options, {
				mode = 'buffers',
				indicator = { style = 'underline' },
				show_tab_indicators = true,
				always_show_bufferline = false,
				show_close_icon = false,
				show_buffer_close_icons = false,
				show_buffer_icons = true,
				separator_style = { '', '' },
				modified_icon = '✨ ',
				enforce_regular_tabs = true,
				hover = { enabled = true, delay = 200 },
			})

			opts.highlights = {
				fill = { bg = 'none' },
			}

			local indicator_color = ({
				['rose-pine'] = function() return require('rose-pine.palette').love end,
			})[vim.g.colors_name]

			if indicator_color then
				local color = indicator_color()
				for _, hl in ipairs {
					'indicator',
					'buffer',
					'separator',
					'tab_separator',
					'tab',
					'modified',
					'close_button',
					'duplicate',
					'hint',
					'info',
					'pick',
					'error',
					'numbers',
					'warning',
					'diagnostic',
					'hint_diagnostic',
					'info_diagnostic',
					'error_diagnostic',
					'warning_diagnostic',
				} do
					opts.highlights[hl .. '_selected'] = { sp = color }
				end
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
				local map = require('utils.keymap').map_factory { buffer = buffer }

				map { ']h', '<cmd>Gitsigns nav_hunk next<cr>', desc = 'Next Hunk' }
				map { '[h', '<cmd>Gitsigns nav_hunk prev<cr>', desc = 'Prev Hunk' }

				map { '<leader>ghu', '<cmd>Gitsigns undo_stage_hunk<cr>', desc = 'Undo Stage Hunk' }
				map { '<leader>ghp', '<cmd>Gitsigns preview_hunk_inline<cr>', desc = 'Preview Hunk Inline' }
				map { '<leader>ghb', '<cmd>Gitsigns toggle_current_line_blame<cr>', desc = 'Toggle line blame' }

				map { '<leader>ghs', '<cmd>Gitsigns stage_hunk<cr>', mode = { 'n', 'v' }, desc = 'Stage Hunk' }
				map { '<leader>gh<s-s>', '<cmd>Gitsigns stage_buffer<cr>', desc = 'Stage Buffer' }
				map { '<leader>ghr', '<cmd>Gitsigns reset_hunk<cr>', mode = { 'n', 'v' }, desc = 'Reset Hunk' }
				map { '<leader>gh<s-r>', '<cmd>Gitsigns reset_buffer<cr>', desc = 'Reset Buffer' }
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
			-- TODO: add ft exclude snacks_picker_input
			sources = {
				path = { max_depth = 1, modified = function(sym) return sym:merge { name = sym.name .. ' ✨', name_hl = 'Error' } end },
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
		---@module 'edgy'
		---@param opts Edgy.Config
		opts = function(_, opts)
			table.insert(opts.right, {
				ft = 'copilot-chat',
				title = 'Copilot Chat',
				size = { width = 40 },
				pinned = true,
				open = 'CopilotChatToggle',
			})

			opts.keys['<c-a-left>'] = function(win) win:resize('width', 1) end
			opts.keys['<c-a-right>'] = function(win) win:resize('width', -1) end
			opts.keys['<c-a-up>'] = function(win) win:resize('height', 1) end
			opts.keys['<c-a-down>'] = function(win) win:resize('height', -1) end
		end,
	},

	{ -- better folding treesitter
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
			enable_get_fold_virt_text = true,
			fold_virt_text_handler = require('utils.ufo').make_fold_handler {
				icon = '',
			},
		},
	},
}
