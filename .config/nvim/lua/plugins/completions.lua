return {
	{
		'hrsh7th/nvim-cmp',
		opts = {
			window = {
				completion = { border = 'rounded' },
				documentation = { border = 'rounded' },
			},
			-- completion = { autocomplete = true },
			-- experimental = { ghost_text = true },

			lsp_kind_priority = {
				Supermaven = 120,

				Variable = 100,
				Reference = 95,
				Constant = 90,
				Interface = 90,
				TypeParameter = 90,
				Function = 85,
				Field = 85,
				Method = 85,
				Class = 85,
				Property = 80,
				Enum = 75,
				EnumMember = 75,
				Constructor = 75,
				Struct = 70,
				Module = 70,

				Color = 60,
				Unit = 60,
				Value = 60,
				File = 55,
				Folder = 55,
				Event = 40,
				Operator = 40,
				Keyword = 30,

				Snippet = 15,
				Text = 10,

				Codeium = 0,
				TabNine = 0,
				Copilot = 0,
			},
		},
	},
	{
		'hrsh7th/nvim-cmp',
		dependencies = { 'hrsh7th/cmp-emoji' },
		opts = function(_, opts)
			vim.list_extend(opts.sources, {
				{ name = 'emoji' },
				{ name = 'supermaven' },
			})
		end,
	},
	{
		'hrsh7th/nvim-cmp',
		opts = function(_, opts)
			local cmp = require 'cmp'

			-----------------------------------------------------
			--- Mappings
			local select_behavior = { behavior = cmp.SelectBehavior.Select } ---@diagnostic disable-line: no-unknown
			local cmp_close = { i = cmp.mapping.abort(), c = cmp.mapping.close() }
			local sm = require 'supermaven-nvim.completion_preview'

			opts.mapping = cmp.mapping.preset.insert {
				---@type function
				['<c-space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
				['<c-u>'] = cmp.mapping.scroll_docs(-4),
				['<c-d>'] = cmp.mapping.scroll_docs(4),
				['<c-j>'] = cmp.mapping.select_next_item(select_behavior),
				['<c-k>'] = cmp.mapping.select_prev_item(select_behavior),
				['<c-y>'] = cmp.mapping.confirm { select = true },
				['<cr>'] = cmp.mapping.confirm { select = true },
				['<c-q>'] = cmp_close,
				['<c-e>'] = cmp_close,
				['<tab>'] = function(fallback) return cmp.visible() and cmp.confirm { select = true } or fallback() end,

				-- SuperMaven mappings
				['<c-l>'] = function() return sm.has_suggestion() and sm.on_accept_suggestion(true) end,
			}

			-----------------------------------------------------
			--- Formatting
			local icons = vim.deepcopy(LazyVim.config.icons.kinds)
			icons.Supermaven = ''

			opts.formatting = { ---@type cmp.FormattingConfig
				expandable_indicator = false,
				fields = { 'kind', 'abbr' },
				format = function(_, item)
					item.kind = icons[item.kind] or ' ' -- icon
					return item
				end,
			}

			-----------------------------------------------------
			--- Order/Sorting
			local compare = cmp.config.compare
			local cmp_lsp_kind = require('cmp.types').lsp.CompletionItemKind
			local kind_priority = opts.lsp_kind_priority ---@type table<string, number>
			opts.sorting = { ---@type cmp.SortingConfig
				priority_weight = 1,
				comparators = {
					compare.score,
					compare.exact,

					---@param entry1 cmp.Entry
					---@param entry2 cmp.Entry
					function(entry1, entry2) -- kind priority
						local prio1 = kind_priority[cmp_lsp_kind[entry1:get_kind()]] or 0
						local prio2 = kind_priority[cmp_lsp_kind[entry2:get_kind()]] or 0
						if prio1 == prio2 then return nil end

						local locality = compare.locality(entry1, entry2)
						local offset = compare.offset(entry1, entry2)

						local diff = prio2 - prio1
						return locality or offset or diff < 0
					end,

					compare.recently_used,
					compare.kind,
					compare.sort_text,
				},
			}
		end,
	},
}
