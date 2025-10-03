return {
	{
		'folke/snacks.nvim',
		keys = {
			{ '<c-`>', function() Snacks.terminal.toggle() end, mode = { 'n', 'i' }, desc = 'Terminal: Toggle' },
		},
		---@type snacks.Config
		opts = {
			terminal = {
				win = {
					style = 'terminal',
					wo = { winhighlight = 'SnacksNormal:NormalFloat' },
					actions = {
						term_toggle = function(self) self:hide() end,
						term_normal = function() vim.cmd 'stopinsert' end,
					},
					keys = {
						['<c-`>'] = { 'term_toggle', expr = true, mode = 't', desc = 'Terminal Toggle' },
					},
				},
			},
		},
	},
	{
		'folke/snacks.nvim',
		---@param opts snacks.Config
		opts = function(_, opts)
			opts.terminal.win.keys.nav_h[1] = '<a-H>'
			opts.terminal.win.keys.nav_j[1] = '<a-J>'
			opts.terminal.win.keys.nav_k[1] = '<a-K>'
			opts.terminal.win.keys.nav_l[1] = '<a-L>'
		end,
	},
}
