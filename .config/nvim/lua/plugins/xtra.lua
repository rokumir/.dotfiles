return {
	{ -- Fun Animations
		'eandrju/cellular-automaton.nvim',
		cmd = 'CellularAutomaton',
		lazy = true,
	},

	{ -- Typescript type debug
		'marilari88/twoslash-queries.nvim',
		ft = { 'typescript', 'typescriptreact', 'astro' },
		opts = {
			multi_line = true,
			is_enabled = true,
			highlight = 'Comment',
		},
	},

	{ -- Lua Type: Wezterm object
		'justinsgithub/wezterm-types',
		lazy = true,
		dependencies = { 'lazydev.nvim', opts = function(_, opts) table.insert(opts.library, { path = 'wezterm-types', mods = { 'wezterm' } }) end },
		cond = function() return vim.fn.fnamemodify(vim.fn.expand '%', ':t') == 'wezterm.lua' end,
	},

	{ -- virt columns
		'nihil/virt-column',
		-- name = 'virt-column',
		-- config = function() require('virt-column').setup() end,
	},
}
