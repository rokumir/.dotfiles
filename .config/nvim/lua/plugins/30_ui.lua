---@diagnostic disable: no-unknown
return {
	{ -- Lazy snacks
		'folke/snacks.nvim',
		priority = 1000,
		lazy = false,

		---@type snacks.Config
		opts = {
			indent = {
				priority = 200,
				indent = { enabled = true, hl = 'IndentChar' },
				animate = { enabled = true, style = 'out' },
				scope = { enabled = false },
				chunk = {
					enabled = true,
					hl = 'IndentCharActive',
					char = {
						corner_top = '╭',
						corner_bottom = '╰',
						horizontal = '─',
						vertical = '│',
						arrow = '>',
					},
				},
			},
			scroll = {
				animate = {
					fps = 10,
					duration = { step = 1, total = 5 },
				},
				spamming = 5,
			},

			terminal = {
				win = { style = 'terminal', border = 'rounded' },
			},
		},
	},

	{ -- Better general UI (should be deprecated soon)
		'folke/noice.nvim',
		opts = {
			routes = {
				{
					opts = { skip = true },
					filter = {
						event = 'notify',
						find = 'No information available',
					},
				},
				{ -- show messages in mini
					view = 'mini',
					filter = {
						event = 'msg_show',
						any = {
							{ find = '%d+L, %d+B' },
							{ find = '; after #%d+' },
							{ find = '; before #%d+' },
							{ find = '%d+ more' },
							{ find = '%d+ fewer' },
							{ find = '%d+ lines' },
							{ find = 'Already at' },
						},
					},
				},
			},

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
		},
	},

	{ -- Statusline
		'nvim-lualine/lualine.nvim',
		init = function(self)
			if self then self.init() end

			-- recording cmp: init refresh to avoid delay
			local refresh_statusline = function() require('lualine').refresh { place = { 'statusline' } } end
			vim.api.nvim_create_autocmd('RecordingEnter', { callback = refresh_statusline })
			vim.api.nvim_create_autocmd('RecordingLeave', {
				callback = function() vim.loop.new_timer():start(50, 0, vim.schedule_wrap(refresh_statusline)) end,
			})
		end,

		opts = function(_, opts)
			local palette_exists, palette = pcall(require, 'lualine.themes.' .. (vim.g.colors_name or ''))
			palette.normal.c.bg = 'NONE'
			palette.insert.c.bg = 'NONE'
			palette.visual.c.bg = 'NONE'
			palette.replace.c.bg = 'NONE'
			palette.command.c.bg = 'NONE'
			opts.options.theme = palette

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

	{ -- General Color highlight & picker (with oklch)
		'eero-lehtinen/oklch-color-picker.nvim',
		event = 'VeryLazy',
		lazy = false,
		opts = {
			highlight = {
				enabled = true,
				edit_delay = 60,
				scroll_delay = 0,
			},
			patterns = {
				css_oklch = { priority = -1, '()oklch%([^,]-%)()' },
				hex_literal = { priority = -1, '()0x%x%x%x%x%x%x+%f[%W]()' },
				tailwind = {
					priority = -2,
					custom_parse = function(str) return require('oklch-color-picker.tailwind').custom_parse(str) end,
					'%f[%w][%l%-]-%-()%l-%-%d%d%d?%f[%W]()',
				},
				hex = false,
				css_rgb = false,
				css_hsl = false,
				numbers_in_brackets = false,
			},
			auto_download = false,
			register_cmds = false,
		},
	},

	{ -- highlight hex colors
		'brenoprata10/nvim-highlight-colors',
		event = 'VeryLazy',
		lazy = false,
		keys = {
			{ '<leader>uh', '<cmd>HighlightColors Toggle <cr>', desc = 'Toggle color highlight (HEX, RGB, etc.)' },
		},
		opts = {
			render = 'virtual', --- background | foreground | virtual
			virtual_symbol = '', -- requires `vitual` mode
			virtual_symbol_prefix = '',
			virtual_symbol_suffix = ' ',
			virtual_symbol_position = 'inline',

			enable_hex = true, ---Highlight hex colors, e.g. '#FFFFFF'
			enable_short_hex = false, ---Highlight short hex colors e.g. '#fff'
			enable_rgb = true, ---Highlight rgb colors, e.g. 'rgb(0 0 0)'
			enable_hsl = true, ---Highlight hsl colors, e.g. 'hsl(150deg 30% 40%)'
			enable_var_usage = true, ---Highlight CSS variables, e.g. 'var(--testing-color)'
			enable_named_colors = true, ---Highlight named colors, e.g. 'green'
			enable_tailwind = true, ---Highlight tailwind colors, e.g. 'bg-blue-500'
			exclude_filetypes = { 'text', 'lazy', 'help' },
		},
	},
}
