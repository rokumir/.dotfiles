-- use source-specific icons, and `kind_icon` only for items from LSPs
local source_icons = {
	emmet = '',
	cmdline = '󰘳',
}
local source_priorities = {
	lsp = 100,
	buffer = 50,
	path = 40,
	lazydev = 50,
	snippets = -10,
	todo_comments = -100,
}
local ts_reject_nodes = {
	comment = true,
	line_comment = true,
	block_comment = true,
	comment_content = true,
	doc = true,
	doc_comment = true,
}
local function is_reject_ts_nodes()
	if require('config.const.filetype').document_map[vim.bo.filetype] then return true end
	local row, column = unpack(vim.api.nvim_win_get_cursor(0))
	local node = vim.treesitter.get_node {
		bufnr = 0,
		pos = { row - 1, math.max(0, column - 1) }, -- seems to be necessary...
	}
	return node and ts_reject_nodes[node:type()]
end

---@module 'lazy'
---@type LazyPluginSpec
return { -- Blink.cmp
	'saghen/blink.cmp',
	build = 'cargo build --release',
	version = false,

	dependencies = {
		-- Colorize completion menu
		{ 'xzbdmw/colorful-menu.nvim', lazy = true, priority = 1000 },
	},

	---@module 'blink.cmp'
	---@type blink.cmp.Config | {}
	opts = {
		enabled = function() return not require('config.const.filetype').ignored_map[vim.bo.filetype] end,

		keymap = {
			preset = 'enter',
			['<c-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
			['<cr>'] = { 'select_accept_and_enter' },
			['<c-l>'] = { 'select_and_accept' },
			['<c-e>'] = { 'hide', 'fallback' },
			['<c-q>'] = { 'hide', 'fallback' },
			['<c-y>'] = false,

			--- movements
			['<c-u>'] = { 'scroll_documentation_up', 'fallback' },
			['<c-d>'] = { 'scroll_documentation_down', 'fallback' },
			['<c-k>'] = { 'select_prev', 'fallback' },
			['<c-j>'] = { 'select_next', 'fallback' },
			['<up>'] = { 'select_prev', 'fallback' },
			['<down>'] = { 'select_next', 'fallback' },
		},

		sources = {
			default = { 'lsp', 'snippets', 'path', 'buffer', 'todo_comments' },
			providers = {
				buffer = { max_items = 4, min_keyword_length = 4 },
				snippets = {
					opts = {
						friendly_snippets = true,
					},
				},
				todo_comments = {
					name = 'TodoComments',
					module = 'util.todo-comments',
					score_offset = -100,
					async = true,
					should_show_items = is_reject_ts_nodes,
					min_keyword_length = 3,
				},
			},

			per_filetype = {
				['rip-substitute'] = { 'buffer' },
				gitcommit = {},
			},
		},

		---@diagnostic disable: missing-fields
		completion = {
			trigger = {
				show_on_insert_on_trigger_character = true,
			},
			accept = {
				create_undo_point = true,
				auto_brackets = { enabled = false },
			},
			list = {
				selection = { preselect = true, auto_insert = false },
			},

			menu = {
				auto_show = true,
				border = 'rounded',
				direction_priority = { 'n', 's' },
				draw = {
					gap = 2,
					padding = 2,
					align_to = 'none', -- keep in place
					treesitter = { 'lsp' },
					columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
					components = {
						label = {
							width = { max = 35 },
							text = function(ctx) return require('colorful-menu').blink_components_text(ctx) end,
							highlight = function(ctx) return require('colorful-menu').blink_components_highlight(ctx) end,
						},
						kind_icon = {
							text = function(ctx)
								local source, client = ctx.item.source_id, ctx.item.client_id
								local lspName = client and vim.lsp.get_client_by_id(client).name

								-- detect emmet-ls
								if lspName == 'emmet_language_server' then source = 'emmet' end

								return source_icons[source] or ctx.kind_icon
							end,
						},
					},
				},
			},
			ghost_text = {
				enabled = true,
				show_without_menu = true,
			},
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
			implementation = 'prefer_rust_with_warning',
			max_typos = function(keyword) return math.floor(#keyword / 10) end,
			use_frecency = false,
			use_proximity = true,
			sorts = {
				function(a, b)
					if a.source_name == 'snippets' then return false end
					local a_priority = source_priorities[a.source_id]
					local b_priority = source_priorities[b.source_id]
					if a_priority == nil or b_priority == nil then return false end
					if a_priority ~= b_priority then return a_priority > b_priority end
				end,
				'exact',
				'score',
				'kind',
				'label',
				'sort_text',
			},
		},

		-- Built-in sources configs
		signature = { enabled = false },
		cmdline = { enabled = true },
	},
}
