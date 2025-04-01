-- use source-specific icons, and `kind_icon` only for items from LSPs
local sourceIcons = {
	emmet = '',
	cmdline = '󰘳',
}

---@module 'lazy'
---@type table<number, LazyPluginSpec>
return {
	{ -- Blink.cmp
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
				default = { 'lsp', 'snippets', 'path', 'buffer' },

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
					},

					buffer = {
						max_items = 4,
						min_keyword_length = 4,
						score_offset = -7,
					},
				},
			},

			---@diagnostic disable: missing-fields
			completion = {
				trigger = {
					show_on_insert_on_trigger_character = true,
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
							label = {
								width = { max = 35 },
								-- text = function(ctx) return require('colorful-menu').blink_components_text(ctx) end,
								-- highlight = function(ctx) return require('colorful-menu').blink_components_highlight(ctx) end,
							},
							kind_icon = {
								text = function(ctx)
									local source, client = ctx.item.source_id, ctx.item.client_id
									local lspName = client and vim.lsp.get_client_by_id(client).name

									-- detect emmet-ls
									if lspName == 'emmet_language_server' then source = 'emmet' end

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
				use_nvim_cmp_as_default = false,

				nerd_font_variant = 'normal',
				kind_icons = {
					-- different icons of the corresponding source
					Text = '󰦨', -- `buffer`
					Snippet = '󰩫', -- `snippets`
					File = '', -- `path`

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

			fuzzy = {
				max_typos = function(keyword) return math.floor(#keyword / 10) end,
				use_frecency = true,
				use_proximity = true,
				sorts = {
					'exact',
					'score',
					'kind',
					'label',
					'sort_text',
				},
			},
		},
	},

	-- Colorize completion menu
	-- { 'xzbdmw/colorful-menu.nvim', lazy = true },
}
