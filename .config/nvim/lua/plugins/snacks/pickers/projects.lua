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
								['<c-w>'] = { '<cmd>normal! diw<cr><right>', mode = 'i', expr = true, desc = 'Delete Word' },
								['<a-X>'] = { 'delete_projects', desc = 'Delete Projects' },
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
						delete_projects = function(picker)
							local items = picker:selected { fallback = true }
							Snacks.picker.actions.close(picker)
							vim.defer_fn(function()
								require('utils.buffer').shada.clear_shada_entries_with_regex(items)
								vim.cmd 'bwipeout!'
								Snacks.picker.projects()
							end, 100)
						end,
					},
				},
			},
		},
	},
}
