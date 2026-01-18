vim.schedule(function()
	local snacks_util = require 'snacks.util'
	local groups = { 'WinBar', 'WinBarNC', 'StatusLine', 'StatusLineNC', 'LazyBackdrop' }
	local hl_entries = Nihil.table.map(
		groups,
		function(_, group)
			return { group, {
				fg = snacks_util.color(group, 'fg'),
				ctermbg = 'none',
				bg = 'none',
			} }
		end
	)

	snacks_util.set_hl(Nihil.table.from_entries(hl_entries))
end)

return {
	{ 'catppuccin', optional = true, enabled = false },
	{ 'tokyonight.nvim', optional = true, enabled = false },
	{ import = 'plugin.colorscheme', priority = 1000 },
}
