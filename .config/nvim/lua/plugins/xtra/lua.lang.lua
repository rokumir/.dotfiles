local root_util = require 'utils.root_dir'

return {
	{ -- Lua Type: Wezterm object
		'justinsgithub/wezterm-types',
		lazy = true,
		dependencies = { 'lazydev.nvim', opts = function(_, opts) table.insert(opts.library, { path = 'wezterm-types', mods = { 'wezterm' } }) end },
		cond = function() return root_util.exact_match('/mnt/c/Users/' .. vim.env.NAME .. '/.config/wezterm') end,
	},
}
