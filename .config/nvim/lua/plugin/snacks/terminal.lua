Nihil.keymap {
	{ '<c-`>', function() Snacks.terminal.toggle() end, mode = { 'n', 'i', 't' }, desc = 'Terminal: Toggle Recent' },
}

return {
	'folke/snacks.nvim',
	---@type snacks.Config
	opts = {
		terminal = {
			win = {
				style = 'terminal',
				noautocmd = true,
				wo = { winhighlight = 'SnacksNormal:NormalFloat' },
				keys = {
					nav_h = false,
					nav_j = false,
					nav_k = false,
					nav_l = false,
				},
			},
		},
	},
}
