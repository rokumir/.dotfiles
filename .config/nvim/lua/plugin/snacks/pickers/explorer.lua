local ExplorerActions = require 'snacks.explorer.actions'
local Settings = require('nihil.plugin.snacks').settings
local ExplorerTree = require 'snacks.explorer.tree'

--- Get explorer excludes (.ignore file)
---@return string[]
--- NOTE: Explorer doesn't use the `.ignore` file, so it has to be manually
--- added to the explorer exclude list.
local function get_excludes()
	if vim.g.snacks_ignored then return Settings.excludes end
	local root_excludes = Nihil.path.root_dir.ignored_list()
	return vim.list_extend(root_excludes, Settings.excludes)
end

---@param picker snacks.Picker
---@param path string
local function unfold_dir(picker, path)
	ExplorerTree:open(path)
	ExplorerActions.update(picker, { refresh = false })
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
						layout = {
							position = 'right',
							width = 0.26,
							box = 'vertical',
							row = -1,
							border = 'top',
							title = '{title} {live} {flags}',
							title_pos = 'left',
							{ box = 'horizontal', { win = 'list', border = 'none' } },
						},
					},

					exclude = Settings.excludes,
					config = function(config) config.exclude = get_excludes() end,

					win = {
						list = {
							keys = vim.tbl_extend(
								'force',
								{},
								require('nihil.plugin.snacks').settings.disabled_default_keys,
								{
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
									['<c-enter>'] = 'cd',

									['<a-H>'] = false,
									['<a-J>'] = false,
									['<a-K>'] = false,
									['<a-L>'] = false,
								}
							),
						},
					},

					actions = {
						-- Toggle ignored files, and persist the setting globally.
						toggle_ignored_persist = function(picker)
							vim.g.snacks_ignored = not vim.g.snacks_ignored
							picker.opts.exclude = get_excludes()
							picker:action 'toggle_ignored'
						end,

						---Delete selected files or directories.
						explorer_del = function(picker)
							local selected_items = picker:selected { fallback = true }

							---@type string[]
							local paths = vim.tbl_map(function(snacks_item)
								-- Protect root folder from being deleted
								if not snacks_item.parent then error 'Root deletion is not allowed!' end
								return Snacks.picker.util.path(snacks_item)
							end, selected_items)

							if vim.tbl_isempty(paths) then return end

							local message
							if #paths == 1 then
								message = 'Move ' .. vim.fn.fnamemodify(paths[1], ':p:~:.') .. ' to trash?'
							else
								message = 'Move ' .. #paths .. ' files to trash?'
							end

							Snacks.picker.util.confirm(message, function()
								picker.list:set_selected() -- clear selection
								for _, file in ipairs(paths) do
									Nihil.file.delete(file, {
										on_exit = function() picker:action 'explorer_update' end,
										no_prompt = true,
									})
								end
							end)
						end,

						---Recursively open all subdirectories.
						explorer_open_all_sub = function(picker, item)
							local curr_node = ExplorerTree:node(item.file)
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

						---Open a directory or jump to a file.
						---If a directory is already open, do nothing.
						confirm = function(picker, item)
							local selected_node = ExplorerTree:node(item.file)
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
