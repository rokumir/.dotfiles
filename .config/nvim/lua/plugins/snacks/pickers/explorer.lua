local Const = require('utils.const').snacks
local Actions = require 'snacks.explorer.actions'
local Tree = require 'snacks.explorer.tree'

--- NOTE: Explorer doesn't use the `.ignore` file. So have to manually add it to the explorer exclude
local function get_excludes()
	local root_excludes = require('utils.root_dir').ignored_list()
	local excludes = vim.list_extend(root_excludes, Const.excludes)
	return vim.g.snacks_ignored and Const.excludes or excludes
end

local function unfold_dir(picker, path)
	Tree:open(path)
	Actions.update(picker, { refresh = false })
end

return {
	'folke/snacks.nvim',
	---@type snacks.Config
	opts = {
		picker = {
			sources = {
				explorer = {
					layout = {
						preset = 'default',
						hidden = { 'input' },
						layout = {
							position = 'right',
							width = 0.26,
							box = 'vertical',
							row = -1,
							border = 'top',
							title = '{title} {live} {flags}',
							title_pos = 'left',
							{ win = 'input', height = 1, border = 'bottom' },
							{
								box = 'horizontal',
								{ win = 'list', border = 'none' },
								{ win = 'preview', title = '{preview}', height = 0.4, border = 'left' },
							},
						},
					},

					config = function(config) config.exclude = get_excludes() end,

					win = {
						list = {
							keys = vim.tbl_extend('force', {}, require('utils.const').snacks.disabled_default_keys, {
								['<bs>'] = 'explorer_up',
								['h'] = 'explorer_close', -- close directory
								['<c-s-u>'] = 'explorer_update',
								['U'] = 'explorer_update',
								['<c-.>'] = 'explorer_focus',

								['zc'] = 'explorer_close',
								['zo'] = 'confirm',
								['zC'] = 'explorer_close_all',
								['zO'] = 'explorer_open_all_sub',
								[']g'] = 'explorer_git_next',
								['[g'] = 'explorer_git_prev',
								[']d'] = 'explorer_diagnostic_next',
								['[d'] = 'explorer_diagnostic_prev',
								[']w'] = 'explorer_warn_next',
								['[w'] = 'explorer_warn_prev',
								[']e'] = 'explorer_error_next',
								['[e'] = 'explorer_error_prev',

								['<a-N>'] = 'explorer_add',
								['<a-R>'] = 'explorer_rename',
								['<a-C>'] = 'explorer_copy',
								['<a-M>'] = 'explorer_move',
								['<a-O>'] = 'explorer_open', -- open with system application
								['<a-P>'] = 'explorer_paste',
								['<a-D>'] = 'explorer_del',
								['<a-L>'] = 'cd',
							}),
						},
					},

					actions = {
						toggle_ignored_persist = function(picker)
							vim.g.snacks_ignored = not vim.g.snacks_ignored
							picker.opts.exclude = get_excludes()
							picker:action 'toggle_ignored'
						end,

						explorer_del = function(picker)
							-- Protect root folder
							local selected_items = picker:selected { fallback = true }
							local has_root = vim.iter(selected_items):any(function(s) return not s.parent end)
							if has_root then
								Snacks.notify.error 'ERROR: Root included!'
								return
							end

							-- Deleting files
							local paths = vim.tbl_map(Snacks.picker.util.path, selected_items)
							local what = #paths == 1 and vim.fn.fnamemodify(paths[1], ':p:~:.') or #paths .. ' files'
							Actions.confirm('Put to the trash ' .. what .. '?', function()
								local after_job = function()
									picker.list:set_selected()
									Actions.update(picker, { refresh = false })
								end

								for _, path in ipairs(paths) do
									local err_data = {}
									local cmd = 'gtrash put ' .. path -- Actual command to run
									local job_id = vim.fn.jobstart(cmd, {
										detach = true,
										on_stderr = function(_, data) err_data[#err_data + 1] = table.concat(data, '\n') end,
										on_exit = function(_, code)
											pcall(function()
												if code == 0 then
													Snacks.bufdelete { file = path, force = true }
												else
													local err_msg = vim.trim(table.concat(err_data, ''))
													Snacks.notify.error('Failed to delete `' .. path .. '`:\n- ' .. err_msg)
												end
												Tree:refresh(vim.fs.dirname(path))
											end)
											after_job()
										end,
									})
									if job_id == 0 then
										after_job()
										Snacks.notify.error('Failed to start the job for: ' .. path)
									end
								end
							end)
						end,

						--- Explorer open all (recursive toggle)
						explorer_open_all_sub = function(picker, item)
							local curr_node = Tree:node(item.file)
							if not (curr_node and curr_node.dir) then return end
							local function unfold(node) ---@param node snacks.picker.explorer.Node
								unfold_dir(picker, node.path)

								vim.schedule(function()
									for _, child in ipairs(vim.tbl_values(node.children)) do
										if child.dir then vim.schedule(function() unfold(child) end) end
									end
								end)
							end
							unfold(curr_node)
						end,

						-- Better confirm action
						confirm = function(picker, item)
							local selected_node = Tree:node(item.file)
							if not selected_node or (selected_node.dir and selected_node.open) then return end

							if selected_node.dir then
								unfold_dir(picker, selected_node.path)
							else
								picker:action 'jump'
							end
						end,
					},
				},
			},
		},
	},
}
