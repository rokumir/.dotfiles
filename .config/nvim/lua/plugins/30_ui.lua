---@diagnostic disable: no-unknown
return {
	{ -- Lazy snacks
		'folke/snacks.nvim',
		priority = 1000,
		lazy = false,

		---@type snacks.Config
		opts = {
			scroll = { enabled = false },

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
						arrow = '',
					},
				},
			},

			terminal = {
				win = {
					relative = true,
					style = 'terminal',
					border = 'rounded',
				},
			},

			zen = {
				-- You can add any `Snacks.toggle` id here.
				-- Toggle state is restored when the window is closed.
				-- Toggle config options are NOT merged.
				---@type table<string, boolean>
				toggles = {
					dim = false,
					git_signs = false,
					mini_diff_signs = false,
					diagnostics = true,
					inlay_hints = false,
				},
				show = {
					statusline = false,
					tabline = false,
				},
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

	-- { -- Tabline
	-- 	'bufferline.nvim',
	-- 	keys = {
	-- 		{ '<tab>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
	-- 		{ '<s-tab>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
	-- 	},
	-- 	opts = function(_, _opts)
	-- 		local opts = vim.tbl_deep_extend('keep', _opts, {
	-- 			options = {
	-- 				close_command = 'bp|sp|bn|bd! %d',
	-- 				right_mouse_command = 'bp|sp|bn|bd! %d',
	-- 				left_mouse_command = 'buffer %d',
	-- 				buffer_close_icon = '',
	-- 				modified_icon = '',
	-- 				close_icon = '',
	-- 				show_close_icon = false,
	-- 				left_trunc_marker = '',
	-- 				right_trunc_marker = '',
	-- 				max_name_length = 14,
	-- 				max_prefix_length = 13,
	-- 				tab_size = 10,
	-- 				show_tab_indicators = true,
	-- 				indicator = {
	-- 					style = 'underline',
	-- 				},
	-- 				enforce_regular_tabs = false,
	-- 				view = 'multiwindow',
	-- 				show_buffer_close_icons = true,
	-- 				separator_style = 'thin',
	-- 				-- separator_style = "slant",
	-- 				always_show_bufferline = true,
	-- 				diagnostics = false,
	-- 				themable = true,
	-- 			},
	-- 		})
	--
	-- 		-- Buffers belong to tabs
	-- 		local cache = {}
	-- 		local last_tab = 0
	--
	-- 		local utils = {}
	--
	-- 		utils.is_valid = function(buf_num)
	-- 			if not buf_num or buf_num < 1 then return false end
	-- 			local exists = vim.api.nvim_buf_is_valid(buf_num)
	-- 			return vim.bo[buf_num].buflisted and exists
	-- 		end
	--
	-- 		utils.get_valid_buffers = function()
	-- 			local buf_nums = vim.api.nvim_list_bufs()
	-- 			local ids = {}
	-- 			for _, buf in ipairs(buf_nums) do
	-- 				if utils.is_valid(buf) then ids[#ids + 1] = buf end
	-- 			end
	-- 			return ids
	-- 		end
	--
	-- 		local autocmd = vim.api.nvim_create_autocmd
	--
	-- 		autocmd('TabEnter', {
	-- 			callback = function()
	-- 				local tab = vim.api.nvim_get_current_tabpage()
	-- 				local buf_nums = cache[tab]
	-- 				if buf_nums then
	-- 					for _, k in pairs(buf_nums) do
	-- 						vim.api.nvim_set_option_value('buflisted', true, { buf = k })
	-- 					end
	-- 				end
	-- 			end,
	-- 		})
	-- 		autocmd('TabLeave', {
	-- 			callback = function()
	-- 				local tab = vim.api.nvim_get_current_tabpage()
	-- 				local buf_nums = utils.get_valid_buffers()
	-- 				cache[tab] = buf_nums
	-- 				for _, k in pairs(buf_nums) do
	-- 					vim.api.nvim_set_option_value('buflisted', false, { buf = k })
	-- 				end
	-- 				last_tab = tab
	-- 			end,
	-- 		})
	-- 		autocmd('TabClosed', { callback = function() cache[last_tab] = nil end })
	-- 		autocmd('TabNewEntered', {
	-- 			callback = function(e) vim.api.nvim_set_option_value('buflisted', true, { buf = e.buf }) end,
	-- 		})
	-- 	end,
	-- },

	{ -- Statusline
		'nvim-lualine/lualine.nvim',
		init = function(self)
			vim.g.lualine_laststatus = 3

			if self then self.init() end

			-- recording cmp: init refresh to avoid delay
			local refresh_statusline = function() require('lualine').refresh { place = { 'statusline' } } end
			vim.api.nvim_create_autocmd('RecordingEnter', { callback = refresh_statusline })
			vim.api.nvim_create_autocmd('RecordingLeave', {
				callback = function() vim.uv.new_timer():start(50, 0, vim.schedule_wrap(refresh_statusline)) end,
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
