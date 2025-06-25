---@diagnostic disable: inject-field
---@module 'snacks'
---@module 'lazy'

---@type LazyPluginSpec[]
return {
	{
		'folke/snacks.nvim',
		cond = vim.g.vscode ~= 1,
		keys = {
			{ '\\\\', function() Snacks.picker.resume() end, desc = 'Resume' },

			-- Top Pickers & Explorer
			{ '<c-e>', function() Snacks.picker.files() end, desc = 'Find Files' },
			{ ';e', function() Snacks.picker.recent { filter = { cwd = true } } end, desc = 'Recent' },
			{ ';b', function() Snacks.picker.buffers() end, desc = 'Buffers' },
			{ ';/', function() Snacks.picker.grep() end, desc = 'Grep' },
			{ ';:', function() Snacks.picker.command_history() end, desc = 'Command History' },
			{ ';n', function() Snacks.picker.notifications() end, desc = 'Notification History' },
			{ 'sf', function() Snacks.explorer.open { focus = true } end, desc = 'File Explorer' },
			{ 'ss', function() Snacks.explorer.open { focus = false } end, desc = 'File Explorer' },

			-- Find
			{ ';f', '', desc = 'find' },
			-- { ';fb', function() Snacks.picker.buffers() end, desc = 'Buffers' },
			{ ';ff', function() Snacks.picker.files() end, desc = 'Find Files' },
			{ ';fg', function() Snacks.picker.git_files() end, desc = 'Find Git Files' },
			{ ';fp', function() Snacks.picker.projects() end, desc = 'Projects' },
			-- { ';fr', function() Snacks.picker.recent() end, desc = 'Recent' },
			{ ';fc', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = 'Find Config File' },

			-- Git
			{ ';g', '', desc = 'git' },
			{ ';gb', function() Snacks.picker.git_branches() end, desc = 'Git Branches' },
			{ ';gl', function() Snacks.picker.git_log() end, desc = 'Git Log' },
			{ ';gL', function() Snacks.picker.git_log_line() end, desc = 'Git Log Line' },
			{ ';gs', function() Snacks.picker.git_status() end, desc = 'Git Status' },
			{ ';gS', function() Snacks.picker.git_stash() end, desc = 'Git Stash' },
			{ ';gd', function() Snacks.picker.git_diff() end, desc = 'Git Diff (Hunks)' },
			{ ';gf', function() Snacks.picker.git_log_file() end, desc = 'Git Log File' },

			-- Search
			{ ';s', '', desc = 'search' },
			-- grep
			{ '<a-/>', function() Snacks.picker.lines() end, desc = 'Buffer Lines' },
			{ ';sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines' },
			-- { ';sg', function() Snacks.picker.grep() end, desc = 'Grep' },
			{ ';sB', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers' },
			{ ';sw', function() Snacks.picker.grep_word() end, desc = 'Visual selection or word', mode = { 'n', 'x' } },
			-- others
			{ ';s"', function() Snacks.picker.registers() end, desc = 'Registers' },
			{ ';s/', function() Snacks.picker.search_history() end, desc = 'Search History' },
			{ ';sa', function() Snacks.picker.autocmds() end, desc = 'Autocmds' },
			-- { ';sc', function() Snacks.picker.command_history() end, desc = 'Command History' },
			{ ';sc', function() Snacks.picker.commands() end, desc = 'Commands' },
			{ ';sd', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics' },
			{ ';sD', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics' },
			{ ';sh', function() Snacks.picker.help() end, desc = 'Help Pages' },
			{ ';sH', function() Snacks.picker.highlights() end, desc = 'Highlights' },
			{ ';si', function() Snacks.picker.icons() end, desc = 'Icons' },
			{ ';sj', function() Snacks.picker.jumps() end, desc = 'Jumps' },
			{ ';sk', function() Snacks.picker.keymaps() end, desc = 'Keymaps' },
			{ ';sl', function() Snacks.picker.loclist() end, desc = 'Location List' },
			{ ';sm', function() Snacks.picker.marks() end, desc = 'Marks' },
			{ ';sM', function() Snacks.picker.man() end, desc = 'Man Pages' },
			{ ';sp', function() Snacks.picker.lazy() end, desc = 'Search for Plugin Spec' },
			{ ';sq', function() Snacks.picker.qflist() end, desc = 'Quickfix List' },
			{ ';su', function() Snacks.picker.undo() end, desc = 'Undo History' },
			{ ';st', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes' },
			-- lsp
			{ ';ss', function() Snacks.picker.lsp_symbols() end, desc = 'LSP Symbols' },
			{ ';sS', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'LSP Workspace Symbols' },
		},

		---@type snacks.Config
		opts = {
			scroll = { enabled = false },
			dashboard = { enabled = false },
			terminal = { enabled = false },
			image = { enabled = false },
			input = { enabled = true },
			scope = { enabled = true },

			indent = {
				priority = 200,
				indent = { enabled = true, hl = 'IndentChar' },
				animate = { enabled = true, style = 'out' },
				scope = { enabled = false },
				chunk = {
					enabled = true,
					hl = 'IndentCharActive',
					char = {
						corner_top = '╭',
						corner_bottom = '╰',
						horizontal = '─',
						vertical = '│',
						arrow = '',
					},
				},
			},

			---@type snacks.notifier.Config|{}
			notifier = {
				---@type snacks.notifier.style
				style = 'compact',
				top_down = false,
			},

			zen = {
				-- You can add any `Snacks.toggle` id here.
				-- Toggle state is restored when the window is closed.
				-- Toggle config options are NOT merged.
				---@type table<string, boolean>
				toggles = {
					dim = true,
					git_signs = false,
					mini_diff_signs = false,
					diagnostics = true,
					inlay_hints = false,
				},
				show = {
					statusline = false,
					tabline = false,
				},
			},

			explorer = {
				replace_netrw = true,
			},

			picker = {
				exclude = {
					'**/.git/*',
					'**/node_modules/*',
				},

				matcher = {
					fuzzy = true, -- use fuzzy matching
					smartcase = true, -- use smartcase
					ignorecase = true, -- use ignorecase
					sort_empty = false, -- sort results when the search string is empty
					filename_bonus = true, -- give bonus for matching file names (last part of the path)
					file_pos = true, -- e.g.: file:line:col, file:line
					cwd_bonus = false, -- give bonus for matching files in the cwd
					frecency = true, -- frecency bonus
					history_bonus = true, -- give more weight to chronological order
				},

				sources = {
					explorer = {
						layout = {
							preset = 'default',
							hidden = { 'input' },
							layout = { -- variant of 'ivy'
								position = 'right',
								width = 0.26,
								box = 'vertical',
								row = -1,
								border = 'top',
								title = '{title} {live} {flags}',
								title_pos = 'left',
								{ win = 'input', height = 1, border = 'bottom' },
								{
									box = 'horizontal',
									{ win = 'list', border = 'none' },
									{ win = 'preview', title = '{preview}', width = 0.6, border = 'left' },
								},
							},
						},

						win = {
							list = {
								keys = {
									['<bs>'] = 'explorer_up',
									['h'] = 'explorer_close', -- close directory
									['<a-n>'] = 'explorer_add',
									['<a-r>'] = 'explorer_rename',
									['<a-c>'] = 'explorer_copy',
									['<a-m>'] = 'explorer_move',
									['<a-o>'] = 'explorer_open', -- open with system application
									-- ['<a-y>'] = { 'explorer_yank', mode = { 'n', 'x' } },
									['<a-p>'] = 'explorer_paste',
									['<a-u>'] = 'explorer_update',
									['<a-.>'] = 'explorer_focus',

									['<c-p>'] = 'toggle_preview',
									['<c-c>'] = 'tcd',
									['<c-f>'] = 'picker_grep',

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
								},
							},
						},
					},

					files = {
						cmd = 'rg',
						args = { '--sortr', 'modified' },

						filter = { cwd = true },
						transform = 'unique_file',

						layout = {
							preset = 'vscode',
						},
					},

					smart = {
						multi = { 'recent', 'files' },
						format = 'file', -- use `file` format for all sources

						sort = {
							fields = { 'recent', 'sort', 'score:desc', 'idx' },
						},
						filter = { cwd = true },

						matcher = {
							fuzzy = true,
							filename_bonus = true,
							history_bonus = true,
							ignorecas = true,
							smartcase = true,
							cwd_bonus = true, -- boost cwd matches
							frecency = false, -- use frecency boosting
							sort_empty = true, -- sort even when the filter is empty
						},
						transform = 'unique_file',
					},
				},

				formatters = {
					file = {
						filename_first = true,
						git_status_hl = true,
						icon_width = 3,
						truncate = 30,
					},
					selected = {
						show_always = false,
						unselected = true,
					},
					severity = {
						icons = true,
						level = false,
						pos = 'left',
					},
					text = {},
				},
			},
		},
	},

	{
		'folke/snacks.nvim',
		cond = vim.g.vscode ~= 1,
		init = function()
			vim.g.snacks_hidden = vim.g.snacks_hidden == true
			vim.g.snacks_ignored = vim.g.snacks_ignored == true
		end,
		---@param opts snacks.Config
		opts = function(_, opts)
			-- NOTE: Explorer doesn't use the `.ignore` file.
			-- So have to manually add it to the explorer exclude
			local function get_exclude()
				local root_exclude = require('utils.root_dir').ignored_list()
				local exclude = vim.list_extend(root_exclude, opts.picker.exclude or {})
				return vim.g.snacks_ignored and opts.picker.exclude or exclude
			end

			--#region Global
			opts.picker.config = function(config)
				-- persistences
				config.hidden = vim.g.snacks_hidden
				config.ignored = vim.g.snacks_ignored
				if config.source == 'explorer' then config.sources.explorer.exclude = get_exclude() end
			end

			-- keymaps
			local default_keymaps = { -- default keymaps
				['l'] = 'confirm',
				['🔥'] = { 'confirm', mode = { 'n', 'i' } },
				['<c-l>'] = { 'confirm', mode = { 'n', 'i' } },
				['<esc>'] = { 'close', mode = { 'n', 'i' } },
				['<c-q>'] = { 'close', mode = { 'n', 'i' } },
				['<c-a-l>'] = { { 'pick_win', 'jump' }, mode = { 'i', 'n' } },
				['<c-u>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
				['<c-d>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
				['<c-f>'] = { 'preview_scroll_left', mode = { 'i', 'n' } },
				['<c-b>'] = { 'preview_scroll_right', mode = { 'i', 'n' } },
				['<q-q>'] = { 'qflist', mode = { 'i', 'n' } },
				['<a-t>'] = { 'trouble_open_selected', mode = { 'i', 'n' } },
				['<a-i>'] = { 'toggle_ignored_persist', mode = { 'i', 'n' } },
				['<a-h>'] = { 'toggle_hidden_persist', mode = { 'i', 'n' } },
			}
			opts.picker.win = {
				list = { keys = default_keymaps },
				preview = { keys = default_keymaps },
				input = { keys = default_keymaps },
			}

			-- actions
			local trouble_actions = require('trouble.sources.snacks').actions
			opts.picker.actions = {
				trouble_open_selected = trouble_actions.trouble_open_selected,
				toggle_hidden_persist = function(picker)
					vim.g.snacks_hidden = not vim.g.snacks_hidden
					picker:action 'toggle_hidden'
				end,
				toggle_ignored_persist = function(picker)
					vim.g.snacks_ignored = not vim.g.snacks_ignored
					picker:action 'toggle_ignored'
				end,
			}
			--#endregion

			--#region Explorer
			local explorer_keys = opts.picker.sources.explorer.win.list.keys
			explorer_keys['<a-y>'] = { 'explorer_yank_selector', mode = { 'n', 'x' } }
			explorer_keys['y'] = { 'explorer_yank_selector', mode = { 'n', 'x' } }
			explorer_keys['<a-d>'] = 'explorer_safe_del'
			explorer_keys['d'] = 'explorer_safe_del'

			opts.picker.sources.explorer.actions = {
				-- Override "builtin" ignored toggle
				toggle_ignored_persist = function(picker)
					vim.g.snacks_ignored = not vim.g.snacks_ignored
					picker.opts.exclude = get_exclude()
					picker:action 'toggle_ignored'
				end,

				--- Explorer safe delete
				explorer_safe_del = function(picker)
					local selected = picker:selected { fallback = true }
					local has_root = vim.iter(selected):any(function(s) return not s.parent end)
					if has_root then return LazyVim.error 'ERROR: Root included!' end
					picker:action 'explorer_del'
				end,

				--- Explorer yank selector
				explorer_yank_selector = function(picker)
					local selected_paths = vim.tbl_map(Snacks.picker.util.path, picker:selected { fallback = true })
					if #selected_paths == 0 then return end

					local path_copy_options_map = {
						['Relative paths'] = ':.',
						['Fullpaths'] = '',
						['Filenames'] = ':t',
						['Filenames (no ext.)'] = ':t:r',
						['Extensions'] = ':e',
					}
					local path_copy_options = vim.tbl_keys(path_copy_options_map)

					Snacks.picker.select(path_copy_options, { prompt = 'Choose to copy to clipboard:' }, function(choice)
						if not choice then return end

						local template = path_copy_options_map[choice]
						local formatted_paths ---@type string[]
						if template ~= '' then
							local format_path = function(path) return vim.fn.fnamemodify(path, template) end
							formatted_paths = vim.tbl_map(format_path, selected_paths)
						else
							formatted_paths = selected_paths
						end

						-- Add to the clipboards
						local text = table.concat(formatted_paths, '\n')
						vim.fn.setreg('+', text)

						-- clear selection
						picker.list:set_selected()
					end)
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
			}
			--#endregion
		end,
	},
}

-----------------------------
-- Overriding snacks types
--
---@class snacks.picker.Config
---@field exclude? string[]
