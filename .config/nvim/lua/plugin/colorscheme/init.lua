vim.schedule(function()
	local snacks_util = require 'snacks.util'
	local groups = { 'WinBar', 'WinBarNC', 'StatusLine', 'StatusLineNC', 'LazyBackdrop' }
	snacks_util.set_hl(require('util.table').map_to_table(groups, function(_, group)
		return group, {
			fg = snacks_util.color(group, 'fg'),
			ctermbg = 'none',
			bg = 'none',
		}
	end))
end)

require('util.keymap').map {
	'<leader><leader>`',
	function()
		local is_vesper = vim.g.colors_name == 'vesper'
		local scheme = is_vesper and 'rose-pine' or 'vesper'
		vim.cmd.colorscheme(scheme)
		Snacks.notify('Swapping over to colorscheme: **[' .. scheme .. ']**')
	end,
	desc = 'Swapping Colorschemes',
}

return {
	{ 'catppuccin', optional = true, enabled = false },
	{ 'tokyonight.nvim', optional = true, enabled = false },
	{ import = 'plugin.colorscheme' },
}
