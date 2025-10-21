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
					dev = require 'config.const.project_dirs'.all_working_dirs,
					layout = 'vscode_focus',
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
					actions = {
						tab = function(picker)
							vim.cmd 'tabnew'
							Snacks.notify 'New tab opened'
							picker:close()
							Snacks.picker.projects()
						end,
					},
				},
			},
		},
	},
}
