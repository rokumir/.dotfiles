local snacks_actions = require 'snacks.explorer.actions'
local snacks_const = require 'config.const.snacks'
local snacks_tree = require 'snacks.explorer.tree'

--- NOTE: Explorer doesn't use the `.ignore` file. So have to manually add it to the explorer exclude
local function get_excludes()
	local root_excludes = require('util.path').root_dir.ignored_list()
	local excludes = vim.list_extend(root_excludes, snacks_const.excludes)
	return vim.g.snacks_ignored and snacks_const.excludes or excludes
end

local function unfold_dir(picker, path)
	snacks_tree:open(path)
	snacks_actions.update(picker, { refresh = false })
end

return {
	'folke/snacks.nvim',
	keys = {
		{ ';fe', function() Snacks.explorer { focus = true } end, desc = 'File Explorer' },
		{ 'zx', function() Snacks.explorer { focus = false } end, desc = 'File Explorer' },
		{ 'zX', function() Snacks.explorer.reveal { focus = true } end, desc = 'File Explorer' },
	},
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
							keys = vim.tbl_extend('force', {}, require('config.const.snacks').disabled_default_keys, {
								['<bs>'] = 'explorer_up',
								['h'] = 'explorer_close', -- close directory
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
							local selected_items = picker:selected { fallback = true }

							---@type string[]
							local paths = vim.tbl_map(function(snacks_item)
								return snacks_item.parent and Snacks.picker.util.path(snacks_item) or error 'Root included!' -- Protect root folder
							end, selected_items)

							local what = #paths == 1 and vim.fn.fnamemodify(paths[1], ':p:~:.') or #paths .. ' files'
							Snacks.picker.util.confirm('Put to the trash ' .. what .. '?', function()
								picker.list:set_selected()
								for _, file in ipairs(paths) do
									require('util.file').delete(file, {
										on_exit = function() picker:action 'explorer_update' end,
										no_prompt = true,
									})
								end
							end)
						end,

						--- Explorer open all (recursive toggle)
						explorer_open_all_sub = function(picker, item)
							local curr_node = snacks_tree:node(item.file)
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
							local selected_node = snacks_tree:node(item.file)
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
