---@module 'lazy'
---@type LazyPluginSpec[]
return {
	{ -- NOTE: highligh OKLCH colors only
		'eero-lehtinen/oklch-color-picker.nvim',
		event = 'BufReadPre',
		cmd = { 'ColorPickOklch' },
		keys = {
			{
				'<a-c><a-o>',
				function()
					require('oklch-color-picker').pick_under_cursor {
						fallback_open = {
							initial_color = '#fff',
						},
					}
				end,
				desc = 'Open color picker under cursor',
			},
		},

		---@type oklch.Opts
		opts = {
			highlight = {
				enabled = true,
				edit_delay = 100,
				scroll_delay = 10,
				virtual_text = '  ',
				style = 'virtual_left',
				bold = true,
				italic = true,
			},

			---@type table<string, oklch.PatternList | false>?
			patterns = {
				hex = { priority = -1, '()#%x%x%x+%f[%W]()' },
				hex_literal = { priority = -1, '()0x%x%x%x%x%x%x+%f[%W]()' },

				-- Rgb and Hsl support modern and legacy formats:
				-- rgb(10 10 10 / 50%) and rgba(10, 10, 10, 0.5)
				css_rgb = { priority = -1, '()rgba?%(.-%)()' },
				css_hsl = { priority = -1, '()hsla?%(.-%)()' },
				css_oklch = { priority = -1, '()oklch%([^,]-%)()' },

				tailwind = {
					priority = -2,
					custom_parse = function(m) return require('oklch-color-picker.tailwind').custom_parse(m) end,
					'%f[%w][%l%-]-%-()%l-%-%d%d%d?%f[%W]()',
				},

				-- Allows any digits, dots, commas or whitespace within brackets.
				numbers_in_brackets = { priority = -10, '%(()[%d.,%s]+()%)' },
			},
			register_cmds = false,
			auto_download = false,
			wsl_use_windows_app = true,
		},
	},
}
