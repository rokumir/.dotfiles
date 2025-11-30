local file_path = vim.fn.system 'wezterm-config'

return {
	{ -- Lua Type: Wezterm object
		'justinsgithub/wezterm-types',
		lazy = true,
		event = {
			'BufReadPre ' .. file_path,
			'BufNewFile ' .. file_path,
		},
		dependencies = {
			'lazydev.nvim',
			optional = true,
			opts = function(_, opts)
				table.insert(opts.library, {
					path = 'wezterm-types',
					mods = { 'wezterm' },
				})
			end,
		},
	},
}
