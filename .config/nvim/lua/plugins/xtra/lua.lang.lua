local root_util = require 'utils.root_dir'

local WEZTERM_CONF_DIR = '/mnt/c/Users/' .. vim.env.NAME .. '/.config/wezterm' ---@type string

return {
	{ -- Lua Type: Wezterm object
		'justinsgithub/wezterm-types',
		lazy = true,
		dependencies = {
			'lazydev.nvim',
			opts = function(_, opts) table.insert(opts.library, { path = 'wezterm-types', mods = { 'wezterm' } }) end,
		},
		cond = function()
			local current_path = vim.fn.expand '%:p:h'
			return current_path == WEZTERM_CONF_DIR
		end,
	},
}
