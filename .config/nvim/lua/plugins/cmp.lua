return {
	{ 'saghen/blink.compat' },
	{
		'saghen/blink.cmp',
		build = 'cargo build --release',
		dependencies = { 'hrsh7th/cmp-emoji' },
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			sources = {
				completion = {
					enabled_providers = { 'lsp', 'path', 'emoji', 'buffer' },
				},

				providers = {
					emoji = {
						name = 'emoji',
						module = 'blink.compat.source',
						score_offset = 3,
						opts = { cache_digraphs_on_start = true },
					},
				},
			},

			keymap = {
				['<c-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
				['<cr>'] = { 'select_and_accept', 'fallback' },
				['<c-y>'] = { 'select_and_accept', 'fallback' },
				['<c-l>'] = { 'select_and_accept', 'fallback' },
				['<tab>'] = { 'select_and_accept', 'fallback' },
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

			windows = {
				autocomplete = {
					selection = 'preselect',
					border = 'rounded',
				},
				documentation = {
					border = 'rounded',
				},
			},

			fuzzy = {
				use_frecency = true,
				use_proximity = true,
				max_items = 100,
			},
		},
	},
}
