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
					dev = require('config.const.project_dirs').all_working_dirs,
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
							},
						},
					},
				},
			},
		},
	},
}
