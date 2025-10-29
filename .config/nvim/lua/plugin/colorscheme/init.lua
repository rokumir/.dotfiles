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

return {
	{ 'tokyonight.nvim', optional = true, enabled = false },
	{ import = 'plugin.colorscheme' },
}
