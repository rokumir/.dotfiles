return {
	{
		'blink.cmp',

		dependencies = {
			'moyiz/blink-emoji.nvim',
		},

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

			sources = {
				default = {
					'emoji',
				},
				providers = {
					emoji = {
						module = 'blink-emoji',
						name = 'Emoji',
						score_offset = 15, -- Tune by preference
					},
				},
			},

			---@diagnostic disable: missing-fields
			completion = {
				trigger = {
					show_on_trigger_character = true,
				},
				menu = {
					auto_show = true,
					border = 'rounded',
					draw = {
						gap = 2,
						padding = 2,
						components = {
							kind_icon = {
								ellipsis = true,
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
