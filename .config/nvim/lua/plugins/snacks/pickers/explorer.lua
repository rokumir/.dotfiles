local snacks_const = require('utils.const').snacks

--- NOTE: Explorer doesn't use the `.ignore` file. So have to manually add it to the explorer exclude
local function get_excludes()
	local root_excludes = require('utils.root_dir').ignored_list()
	local excludes = vim.list_extend(root_excludes, snacks_const.excludes)
	return vim.g.snacks_ignored and snacks_const.excludes or excludes
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
								['zO'] = 'explorer_open_all',
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
								['<a-L>'] = 'cd',
								['<a-D>'] = 'explorer_safe_del',
							}),
						},
					},

					actions = { -- Override "builtin" ignored toggle
						toggle_ignored_persist = function(picker)
							vim.g.snacks_ignored = not vim.g.snacks_ignored
							picker.opts.exclude = get_excludes()
							picker:action 'toggle_ignored'
						end,

						--- Explorer safe delete
						explorer_safe_del = function(picker)
							local selected = picker:selected { fallback = true }
							local has_root = vim.iter(selected):any(function(s) return not s.parent end)
							if has_root then return LazyVim.error 'ERROR: Root included!' end
							picker:action 'explorer_del'
						end,

						--- Explorer open all (recursive toggle)
						explorer_open_all = function(picker, item)
							local Actions = require 'snacks.explorer.actions'
							local Tree = require 'snacks.explorer.tree'

							-- stop if it's not a dir
							local curr_node = Tree:node(item.file)
							if not (curr_node and curr_node.dir) then return end

							local get_children = function(node) ---@param node snacks.picker.explorer.Node
								local children = {} ---@type snacks.picker.explorer.Node[]
								for _, child in pairs(node.children) do
									table.insert(children, child)
								end
								return children
							end
							local function toggle_recursive(node) ---@param node snacks.picker.explorer.Node
								Tree:open(node.path)
								Actions.update(picker, { refresh = false })

								vim.schedule(function()
									for _, child in ipairs(get_children(node)) do
										if child.dir then vim.schedule(function() toggle_recursive(child) end) end
									end
								end)
							end

							toggle_recursive(curr_node)
						end,

						-- Better confirm action
						confirm = function(picker, item)
							local Tree = require 'snacks.explorer.tree'
							local Actions = require 'snacks.explorer.actions'

							local selected_node = Tree:node(item.file)
							if not selected_node or (selected_node.dir and selected_node.open) then return end

							if selected_node.dir then
								Tree:open(selected_node.path)
								Actions.update(picker, { refresh = false })
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
