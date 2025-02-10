return {
	{
		'saghen/blink.cmp',

		---@module 'blink.cmp'
		---@type blink.cmp.Config | {}
		opts = {
			keymap = {
				preset = 'enter',
				['<c-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
				['<cr>'] = { 'select_accept_and_enter' },
				['<c-y>'] = { 'select_and_accept' },
				['<c-l>'] = { 'select_and_accept' },
				['<c-e>'] = { 'hide', 'fallback' },
				['<c-q>'] = { 'hide', 'fallback' },

				--- movements
				['<c-u>'] = { 'scroll_documentation_up', 'fallback' },
				['<c-d>'] = { 'scroll_documentation_down', 'fallback' },
				['<c-k>'] = { 'select_prev', 'fallback' },
				['<c-j>'] = { 'select_next', 'fallback' },
				['<up>'] = { 'select_prev', 'fallback' },
				['<down>'] = { 'select_next', 'fallback' },
			},

			sources = {
				per_filetype = {
					['rip-substitute'] = { 'buffer' },
					gitcommit = {},
				},
				providers = {
					snippets = {
						-- don't show when triggered manually (= length 0),
						-- useful when manually showing completions to see available fields
						min_keyword_length = 1,
						score_offset = -1000,
						opts = { clipboard_register = '+' },
					},

					lsp = {
						fallbacks = {}, -- do not use `buffer` as fallback
						enabled = function()
							if vim.bo.ft ~= 'lua' then return true end

							-- prevent useless suggestions when typing `--` in lua, but
							-- keep the useful `---@param;@return` suggestion
							local col = vim.api.nvim_win_get_cursor(0)[2]
							local charsBefore = vim.api.nvim_get_current_line():sub(col - 2, col)
							local luadocButNotComment = not charsBefore:find '^%-%-?$' and not charsBefore:find '%s%-%-?'
							return luadocButNotComment
						end,
					},
					path = {
						opts = { get_cwd = vim.uv.cwd },
					},
					buffer = {
						max_items = 4,
						min_keyword_length = 4,

						-- with `-7`, typing `then` in lua prioritize the `then .. end`
						-- snippet, effectively acting as `nvim-endwise`
						score_offset = -7,

						opts = {
							-- show completions from all buffers used within the last x minutes
							get_bufnrs = function()
								local mins = 15
								local allOpenBuffers = vim.fn.getbufinfo { buflisted = 1, bufloaded = 1 }
								local recentBufs = vim.iter(allOpenBuffers)
									:filter(function(buf)
										local recentlyUsed = os.time() - buf.lastused < (60 * mins)
										local nonSpecial = vim.bo[buf.bufnr].buftype == ''
										return recentlyUsed and nonSpecial
									end)
									:map(function(buf) return buf.bufnr end)
									:totable()
								return recentBufs
							end,
						},
					},
				},
			},

			---@diagnostic disable: missing-fields
			completion = {
				trigger = {
					show_on_trigger_character = true,
				},
				accept = {
					create_undo_point = true,
					auto_brackets = {
						enabled = false,
					},
				},
				list = {
					selection = { preselect = true, auto_insert = false },
				},

				menu = {
					auto_show = true,
					border = 'rounded',
					draw = {
						gap = 2,
						padding = 2,
						align_to = 'none', -- keep in place
						treesitter = { 'lsp' },
						columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
						components = {
							label = { width = { max = 35 } },
							label_description = { width = { max = 20 } },
							kind_icon = {
								text = function(ctx)
									-- detect emmet-ls
									local source, client = ctx.item.source_id, ctx.item.client_id
									local lspName = client and vim.lsp.get_client_by_id(client).name
									if lspName == 'emmet_language_server' then source = 'emmet' end

									-- use source-specific icons, and `kind_icon` only for items from LSPs
									local sourceIcons = {
										snippets = '󰩫',
										buffer = '󰦨',
										emmet = '',
										path = '',
										cmdline = '󰘳',
									}
									return sourceIcons[source] or ctx.kind_icon
								end,
							},
						},
					},
				},
				ghost_text = { enabled = false },
				documentation = {
					treesitter_highlighting = true,
					update_delay_ms = 300,
					auto_show = false,
					auto_show_delay_ms = 500,
					window = {
						border = 'rounded',
						max_width = 80,
					},
				},
			},

			appearance = {
				-- supported: tokyonight
				-- not supported: nightfox, gruvbox-material
				use_nvim_cmp_as_default = true,

				nerd_font_variant = 'normal',
				kind_icons = {
					-- different icons of the corresponding source
					Text = '󰉿', -- `buffer`
					Snippet = '󰞘', -- `snippets`
					File = '', -- `path`

					Folder = '󰉋',
					Method = '󰊕',
					Function = '󰡱',
					Constructor = '',
					Field = '󰇽',
					Variable = '󰀫',
					Class = '󰜁',
					Interface = '',
					Module = '',
					Property = '󰜢',
					Unit = '',
					Value = '󰎠',
					Enum = '',
					Keyword = '󰌋',
					Color = '󰏘',
					Reference = '',
					EnumMember = '',
					Constant = '󰏿',
					Struct = '󰙅',
					Event = '',
					Operator = '󰆕',
					TypeParameter = '󰅲',
				},
			},
		},
	},
}
