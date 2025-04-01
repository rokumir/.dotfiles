return {
	{ -- Lua Type: Wezterm object
		'justinsgithub/wezterm-types',
		lazy = true,
		dependencies = { 'lazydev.nvim', opts = function(_, opts) table.insert(opts.library, { path = 'wezterm-types', mods = { 'wezterm' } }) end },
		cond = function() return vim.fn.fnamemodify(vim.fn.expand '%', ':t') == 'wezterm.lua' end,
	},
}
