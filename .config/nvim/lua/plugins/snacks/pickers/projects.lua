return {
	{
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
	},
	{
		'folke/snacks.nvim',
		optional = true,
		cond = vim.g.neovide,
		---@param opts snacks.Config
		opts = function(_, opts)
			opts.picker.sources.projects.win.input.keys['<a-N>'] = { 'open_new_neovide_window', mode = { 'i', 'n' } }

			opts.picker.sources.projects.actions.open_new_neovide_window = function(picker)
				local paths = vim.tbl_map(Snacks.picker.util.path, picker:selected { fallback = true })
				picker.list:set_selected()
				if #paths == 0 then return end
				for _, path in ipairs(paths) do
					vim.schedule(function()
						local success = os.execute('neovide.exe -- --cmd "cd ' .. path .. '" > /dev/null 2>&1 &')
						if success then Snacks.notify { 'Open new project at:', path } end
					end)
				end
				picker:close()
			end
		end,
	},
}
