local root_util = require 'utils.root_dir'

return {
	{ -- Lua Type: Wezterm object
		'justinsgithub/wezterm-types',
		lazy = true,
		cond = function()
			local active_directory = vim.fn.expand '%:p:h:t'
			local active_filename = vim.fn.expand '%:t'
			local config_directory = vim.fn.fnamemodify(vim.env.WEZTERM_CONFIG_DIR, ':t')
			local config_filename = vim.fn.fnamemodify(vim.env.WEZTERM_CONFIG, ':t')
			return config_directory == active_directory and active_filename == config_filename
		end,
		dependencies = {
			'lazydev.nvim',
			opts = function(_, opts)
				table.insert(opts.library, {
					path = 'wezterm-types',
					mods = { 'wezterm' },
				})
			end,
		},
	},
}
