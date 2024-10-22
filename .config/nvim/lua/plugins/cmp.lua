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
				Supermaven = 0,
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
			})
		end,
	},
	{
		'hrsh7th/nvim-cmp',
		dependencies = { 'roobert/tailwindcss-colorizer-cmp.nvim' },
		opts = function(_, opts)
			local cmp = require 'cmp'

			-----------------------------------------------------
			--- Mappings
			local select_behavior = { behavior = cmp.SelectBehavior.Select } ---@diagnostic disable-line: no-unknown
			local cmp_close = { i = cmp.mapping.abort(), c = cmp.mapping.close() }
			local function select_mapping(fun)
				return function(fallback)
					if fun then fun() end
					if cmp.visible() then
						cmp.confirm { select = true }
					else
						fallback()
					end
				end
			end

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
				['<tab>'] = select_mapping(),
				['<c-l>'] = select_mapping(),
			}

			-----------------------------------------------------
			--- Formatting
			local icons = vim.deepcopy(LazyVim.config.icons.kinds)
			opts.formatting = { ---@type cmp.FormattingConfig
				expandable_indicator = false,
				fields = { 'kind', 'abbr' },
				format = function(entry, item)
					local tw_item = require('tailwindcss-colorizer-cmp').formatter(entry, item)
					if tw_item.kind == 'XX' then return tw_item end

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
