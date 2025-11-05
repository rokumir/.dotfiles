return {
	'folke/snacks.nvim',
	keys = {
		{ ';d', function() Snacks.picker.projects { patterns = { '*' } } end, desc = 'Vaults' },
		{ ';D', function() Snacks.picker.projects() end, desc = 'Projects' },
	},
	---@type snacks.Config
	opts = {
		picker = {
			sources = {
				projects = {
					dev = require('config.const.project_dirs').all(),
					layout = 'vscode_focus',
					patterns = {
						'.git',
						'_darcs',
						'.hg',
						'.bzr',
						'.svn',
						'package.json',
						'Makefile',
						'README.md',
					},
					matcher = {
						sort_empty = true,
						cwd_bonus = false,
						frecency = true,
						history_bonus = true,
					},
					win = {
						input = {
							keys = {
								['<c-.>'] = { 'tcd', mode = { 'n', 'i' } },
								['<c-l>'] = { 'confirm', mode = { 'n', 'i' } },
								['<c-w>'] = { '<cmd>normal! diw<cr><right>', mode = 'i', expr = true, desc = 'Delete Word' },
								['<a-n>'] = { 'new_neovide_window', mode = { 'n', 'i' }, desc = 'New Project' },
							},
						},
					},
					actions = {
						new_neovide_window = function(_, item)
							local path = Snacks.picker.util.path(item) or error()
							vim.cmd('OpenNewNeovide "' .. path .. '"')
						end,
					},
				},
			},
		},
	},
}
