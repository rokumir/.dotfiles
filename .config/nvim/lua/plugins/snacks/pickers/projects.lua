return {
	'folke/snacks.nvim',
	---@type snacks.Config
	opts = {
		picker = {
			sources = {
				projects = {
					dev = {
						vim.fs.normalize '~/documents',
						vim.env.RH_THROWAWAY,
						vim.env.RH_PROJECT,
						vim.env.RH_WORK,
						vim.env.RH_SCRIPT,
						vim.env.XDG_CONFIG_HOME,
					},

					win = {
						input = {
							keys = {
								['<c-.>'] = { 'tcd', mode = { 'n', 'i' } },
								['<c-w>'] = { '<cmd>normal! diw<cr><right>', mode = 'i', expr = true, desc = 'delete word' },
								['<a-X>'] = { 'delete_projects', mode = { 'i', 'n' } },
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
							local selections = picker:selected { fallback = true }

							-- Build a set of absolute paths to remove
							local to_remove = {}
							for _, item in ipairs(selections) do
								local abs = vim.fn.fnamemodify(item.file, ':p')
								to_remove[abs] = true
							end

							vim.defer_fn(function()
								-- Remove uppercase file-marks ('A'..'Z') pointing at those paths
								for code = 65, 90 do -- ASCII 'A' to 'Z'
									local mark = string.char(code)
									local bufnr = vim.fn.getpos("'" .. mark)[1] -- bufnr, lnum, col, off
									if bufnr > 0 then
										local path = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ':p')
										if to_remove[path] then vim.cmd('delmarks ' .. mark) end
									end
								end

								-- Filter out matching entries from v:oldfiles
								vim.v.oldfiles = vim.tbl_filter(function(path) return not to_remove[vim.fn.fnamemodify(path, ':p')] end, vim.v.oldfiles)

								vim.cmd 'wshada! | rshada!' -- Persist the cleaned state and reload ShaDa
								Snacks.picker.projects()
							end, 100)
						end,
					},
				},
			},
		},
	},
}
