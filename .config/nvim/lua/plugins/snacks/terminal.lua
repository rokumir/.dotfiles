local function term_nav(dir)
	return function()
		return vim.schedule(function() vim.cmd.wincmd(dir) end)
	end
end

require('utils.keymap').map {
	{ '<c-`>', function() Snacks.terminal() end, mode = { 'n', 'i', 't' }, desc = 'Terminal: Toggle' },
	{
		expr = true,
		mode = 't',
		{ '<a-H>', term_nav 'h', desc = 'Go to Left Window' },
		{ '<a-J>', term_nav 'j', desc = 'Go to Lower Window' },
		{ '<a-K>', term_nav 'k', desc = 'Go to Upper Window' },
		{ '<a-L>', term_nav 'l', desc = 'Go to Right Window' },
	},
}

return {
	'folke/snacks.nvim',
	---@type snacks.Config
	opts = {
		terminal = {
			win = {
				style = 'terminal',
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

