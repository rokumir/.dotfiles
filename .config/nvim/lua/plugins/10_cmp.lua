return {
	{
		'blink.cmp',
		---@module 'blink.cmp'
		---@type blink.cmp.Config | {}
		opts = {
			keymap = {
				preset = 'enter',
				['<c-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
				['<cr>'] = { 'select_and_accept' },
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

			---@diagnostic disable: missing-fields
			completion = {
				ghost_text = { enabled = true },
				menu = { border = 'rounded' },
				documentation = {
					window = {
						border = 'rounded',
						max_width = 80,
					},
				},
			},

			fuzzy = {
				use_frecency = true,
				use_proximity = true,
			},
		},
	},
}
