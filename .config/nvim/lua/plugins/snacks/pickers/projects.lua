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
					dev = {
						vim.fs.normalize '~/documents',
						vim.env.XDG_CONFIG_HOME,
						vim.env.RH_THROWAWAY,
						vim.env.RH_PROJECT,
						vim.env.RH_WORK,
						vim.env.RH_SCRIPT,
					},

					layout = 'vscode_focus',

					win = {
						input = {
							keys = {
								['<c-.>'] = { 'tcd', mode = { 'n', 'i' } },
								['<c-l>'] = { 'confirm', mode = { 'n', 'i' } },
								['<c-w>'] = { '<cmd>normal! diw<cr><right>', mode = 'i', expr = true, desc = 'delete word' },
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
