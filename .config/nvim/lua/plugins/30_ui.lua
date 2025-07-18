---@diagnostic disable: no-unknown
---@module 'lazy'
---@type table<number, LazyPluginSpec>
return {
	{ -- Better general UI (should be deprecated soon)
		'folke/noice.nvim',
		opts = {
			commands = {
				all = { -- options for the message history that you get with `:Noice`
					view = 'split',
					opts = { enter = true, format = 'details' },
					filter = {},
				},
			},

			presets = {
				bottom_search = true,
				command_palette = true,
				lsp_doc_border = true,
				inc_rename = true,
				cmdline_output_to_split = true,
				long_message_to_split = true,
			},

			lsp = {
				progress = { enabled = false },
				hover = { enabled = true, silent = true },
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

		init = function()
			-- recording cmp: init refresh to avoid delay
			local refresh_statusline = function() require('lualine').refresh { place = { 'statusline' } } end
			vim.api.nvim_create_autocmd('RecordingEnter', { callback = refresh_statusline })
			vim.api.nvim_create_autocmd('RecordingLeave', {
				callback = function() vim.loop.new_timer():start(50, 0, vim.schedule_wrap(refresh_statusline)) end,
			})
		end,

		opts = function(_, opts)
			opts.options.component_separators = { left = '', right = '' }
			opts.options.section_separators = { left = '', right = '' }

			opts.sections.lualine_c[4] = {
				LazyVim.lualine.pretty_path {
					length = 3,
					relative = 'cwd',
					modified_hl = '@variable.builtin',
					directory_hl = '@comment',
					filename_hl = '@attribute',
					modified_sign = ' ✨ ',
					readonly_icon = ' 󰌾 ',
				},
			}

			-- word count
			table.insert(opts.sections.lualine_x, {
				function()
					local wc = vim.fn.wordcount()
					return wc.words .. 'w ' .. wc.chars .. 'c'
				end,
				cond = function() return vim.tbl_contains({ 'markdown', 'vimwiki', 'latex', 'text', 'tex' }, vim.bo.ft) end,
				color = { fg = '#9E6E80', gui = 'italic' },
			})

			opts.sections.lualine_y = {
				{ 'encoding', cond = function() return (vim.bo.fenc or vim.go.enc) ~= 'utf-8' end },
				{ 'fileformat', symbols = { unix = 'lf', dos = 'crlf', mac = 'cr' }, cond = function() return vim.bo.ff == 'dos' end },
				'progress',
			}

			opts.sections.lualine_z = {
				'location',
			}

			if vim.g.colors_name == 'rose-pine' then
				local t = require 'lualine.themes.rose-pine'
				local bg = require('rose-pine.palette').base
				t.normal.c.bg = bg
				t.insert.c.bg = bg
				t.visual.c.bg = bg
				t.replace.c.bg = bg
				t.command.c.bg = bg
				t.inactive.a.bg = bg
				t.inactive.b.bg = bg
				t.inactive.c.bg = bg
				opts.options.theme = t
			end
		end,
	},

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
			opts.options = opts.options or {}

			opts.options.mode = 'buffers'
			opts.options.indicator = { style = 'underline' }

			opts.options.show_tab_indicators = true
			opts.options.always_show_bufferline = false
			opts.options.show_close_icon = false
			opts.options.show_buffer_close_icons = false
			opts.options.show_buffer_icons = true

			opts.options.separator_style = { '', '' }
			opts.options.modified_icon = ' '
			-- opts.options.left_trunc_marker = ' '
			-- opts.options.right_trunc_marker = ' '

			opts.options.enforce_regular_tabs = true
			-- opts.options.hover = { enabled = true, delay = 200 }

			----------------------------------------
			-- Themes based stuffs -------------
			opts.highlights = opts.highlights or {}

			--#region Styling indicators
			local indicator_highlight_list = {
				'indicator_selected',
				'buffer_selected',
				'separator_selected',
				'tab_separator_selected',
				'tab_selected',
				'modified_selected',
				'close_button_selected',
				'duplicate_selected',
				'hint_selected',
				'info_selected',
				'pick_selected',
				'error_selected',
				'numbers_selected',
				'warning_selected',
				'diagnostic_selected',
				'hint_diagnostic_selected',
				'info_diagnostic_selected',
				'error_diagnostic_selected',
				'warning_diagnostic_selected',
			}
			local scheme_to_color = {
				['rose-pine'] = function() return require('rose-pine.palette').love end,
			}
			local incicator_color = scheme_to_color[vim.g.colors_name]
			if incicator_color then
				for _, hl in ipairs(indicator_highlight_list) do
					opts.highlights[hl] = { sp = incicator_color() }
				end
			end
			--#endregion

			if vim.g.colors_name == 'rose-pine' then
				local rosepine = require 'rose-pine.palette'
				opts.highlights.fill = { bg = rosepine.base }
			end
		end,
	},

	{ -- Git status in line number
		'lewis6991/gitsigns.nvim',
		opts = function(_, opts)
			opts.signs = {
				add = { text = '│' },
				change = { text = '│' },
				delete = { text = '' },
				topdelete = { text = '' },
				changedelete = { text = '│' },
				untracked = { text = '│' },
			}

			opts.on_attach = function(buffer)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc }) end

				map('n', ']h', gs.next_hunk, 'Next Hunk')
				map('n', '[h', gs.prev_hunk, 'Prev Hunk')

				map('n', '<leader>ghu', gs.undo_stage_hunk, 'Undo Stage Hunk')
				map('n', '<leader>ghp', gs.preview_hunk_inline, 'Preview Hunk Inline')
				map('n', '<leader>ghb', gs.toggle_current_line_blame, 'Toggle line blame')

				map({ 'n', 'v' }, '<leader>ghs', '<cmd>Gitsigns stage_hunk<cr>', 'Stage Hunk')
				map('n', '<leader>gh<s-s>', gs.stage_buffer, 'Stage Buffer')
				map({ 'n', 'v' }, '<leader>ghr', '<cmd>Gitsigns reset_hunk<cr>', 'Reset Hunk')
				map('n', '<leader>gh<s-r>', gs.reset_buffer, 'Reset Buffer')
			end
		end,
	},
}
