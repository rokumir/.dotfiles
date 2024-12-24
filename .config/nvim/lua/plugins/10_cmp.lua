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
				trigger = {
					show_on_trigger_character = true,
				},
				menu = {
					auto_show = false,
					border = 'rounded',
					draw = {
						gap = 2,
						padding = 2,
						columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
						components = {
							kind_icon = {
								ellipsis = false,
								text = function(ctx)
									local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
									return kind_icon
								end,
							},
						},
					},
				},
				ghost_text = { enabled = false },
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
					window = {
						border = 'rounded',
						max_width = 80,
					},
				},
			},
		},
	},
}
