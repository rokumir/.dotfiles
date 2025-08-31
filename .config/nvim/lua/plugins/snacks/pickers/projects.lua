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

					layout = 'vscode_unfocus',

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
						-- load_new_session = function(picker, item)
						-- 	picker:close()
						-- 	if not item then return end
						-- 	local dir = item.file
						-- 	local session_loaded = false
						-- 	vim.api.nvim_create_autocmd('SessionLoadPost', {
						-- 		once = true,
						-- 		callback = function() session_loaded = true end,
						-- 	})
						-- 	vim.defer_fn(function()
						-- 		if not session_loaded then Snacks.picker.files() end
						-- 	end, 100)
						-- 	vim.fn.chdir(dir)
						-- 	local session = Snacks.dashboard.sections.session()
						-- 	if session then vim.cmd(session.action:sub(2)) end
						-- end,
					},
				},
			},
		},
	},
}
