local snacks_const = require 'config.const.snacks'

local INPUT_TITLE = '{title} {live} {flags}'

---@type snacks.win.Keys
local default_keys = vim.tbl_extend('keep', {
	['k'] = false,
	['j'] = false,
	['<c-k>'] = false,
	['<c-j>'] = false,
	['<c-u>'] = false,
	['<c-d>'] = false,

	['🔥'] = { 'confirm', mode = { 'n', 'i' } },
	['<c-.>'] = { 'confirm', mode = { 'n', 'i' } },
	['<c-l>'] = { 'confirm', mode = { 'n', 'i' } },
	['<esc>'] = { 'close', mode = { 'n', 'i' } },
	['<c-q>'] = { 'close', mode = { 'n', 'i' } },
	['<c-space>'] = { 'select', mode = { 'n', 'i' } },

	['n_list_'] = { 'k', 'list_up' },
	['n_list_'] = { 'j', 'list_down' },
	['i_list_'] = { '<c-k>', 'list_up', mode = 'i' },
	['i_list_'] = { '<c-j>', 'list_down', mode = 'i' },
	['n_list_page_'] = { '<c-k>', 'list_page_up' },
	['n_list_page_'] = { '<c-j>', 'list_page_down' },
	['i_list_page_'] = { '<c-s-k>', 'list_page_up', mode = 'i' },
	['i_list_page_'] = { '<c-s-j>', 'list_page_down', mode = 'i' },

	['<a-K>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
	['<a-J>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
	['<a-H>'] = { 'preview_scroll_left', mode = { 'i', 'n' } },
	['<a-L>'] = { 'preview_scroll_right', mode = { 'i', 'n' } },

	['<a-y>'] = { 'yank', mode = { 'n', 'i' } },
	['<a-l>'] = { 'toggle_live', mode = { 'i', 'n' } },
	['<a-i>'] = { 'toggle_ignored_persist', mode = { 'i', 'n' } },
	['<a-h>'] = { 'toggle_hidden_persist', mode = { 'i', 'n' } },
	['<a-t>'] = { 'trouble_open_selected', mode = { 'i', 'n' } },

	['<c-w>i'] = 'focus_input',
	['<c-w>l'] = 'focus_list',
	['<c-w>p'] = 'focus_preview',
}, snacks_const.disabled_default_keys)

---@type table<string, PickerYankAction>
local picker_yank_actions = {
	highlights = { predicate = { 'hl_group' } },
	notifications = { predicate = { 'item', 'msg' } },
	explorer = {
		predicate = function(i) return Snacks.picker.util.path(i) end,
		callback = function(paths, copy)
			local path_opts = {
				{ key = 'Relative Path', format = ':.' },
				{ key = 'File Name', format = ':t' },
				{ key = 'Full Path', format = ':p' },
				{ key = 'Base Name', format = ':t:r' },
				{ key = 'Extension', format = ':e' },
			}
			local prompt_otps = {
				prompt = 'Choose to copy to clipboard:',
				format_item = function(option) return option.key end,
			}
			Snacks.picker.select(path_opts, prompt_otps, function(choice) ---@param choice {key:string;format:string}?
				if not choice then return end
				local formatted_paths = vim.tbl_map(function(p) return vim.fn.fnamemodify(p, choice.format) end, paths)
				copy(formatted_paths)
			end)
		end,
	},
}

return {
	'folke/snacks.nvim',
	init = function()
		vim.g.snacks_hidden = vim.g.snacks_hidden == true
		vim.g.snacks_ignored = vim.g.snacks_ignored == true
	end,
	---@type snacks.Config
	opts = {
		picker = {
			exclude = snacks_const.excludes,

			matcher = {
				fuzzy = true,
				smartcase = true,
				ignorecase = true,
				sort_empty = false, -- sort results when the search string is empty
				filename_bonus = true, -- give bonus for matching file names (last part of the path)
				file_pos = true, -- e.g.: file:line:col, file:line
				cwd_bonus = false, -- give bonus for matching files in the cwd
				frecency = true, -- frecency bonus
				history_bonus = true, -- give more weight to chronological order
			},

			formatters = {
				file = {
					filename_first = true,
					git_status_hl = true,
					icon_width = 3,
					truncate = 50,
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

			config = function(config)
				config.hidden = vim.g.snacks_hidden
				config.ignored = vim.g.snacks_ignored
			end,

			win = {
				list = { keys = default_keys },
				input = { keys = default_keys },
			},

			actions = {
				trouble_open_selected = function(...) return require('trouble.sources.snacks').actions.trouble_open_selected.action(...) end,
				toggle_hidden_persist = function(picker)
					vim.g.snacks_hidden = not vim.g.snacks_hidden
					picker:action 'toggle_hidden'
				end,
				toggle_ignored_persist = function(picker)
					vim.g.snacks_ignored = not vim.g.snacks_ignored
					picker:action 'toggle_ignored'
				end,

				-- better yank (supports multiple selections)
				yank = function(picker)
					local selected_items = picker:selected { fallback = true }
					picker.list:set_selected()

					---@type PickerYankAction
					local action = vim.tbl_extend('force', {
						predicate = function(item) return item.text end,
						callback = function(items, copy) copy(items) end,
					}, picker_yank_actions[picker.opts.source] or {})

					if type(action.predicate) == 'table' and #action.predicate > 0 then
						---@diagnostic disable-next-line: param-type-mismatch
						local predicate = vim.deepcopy(action.predicate, true) ---@cast predicate table
						action.predicate = function(item) return vim.tbl_get(item, unpack(predicate)) end
					end

					---@diagnostic disable-next-line: param-type-mismatch
					local mapped_items = vim.tbl_map(action.predicate, selected_items)
					action.callback(mapped_items, function(items)
						local content = table.concat(items, '\n')
						vim.fn.setreg('+', content)
						Snacks.notify 'Copied to the system (+) register!'
					end)
				end,

				select = function(picker, item) picker.list:select(item) end,

				list_page_down = function(picker) picker.list:move(5) end,
				list_page_up = function(picker) picker.list:move(-5) end,
			},

			layouts = {
				vscode_focus = {
					hidden = { 'preview' },
					layout = {
						backdrop = { transparent = true },
						row = 1,
						width = 0.4,
						height = 0.6,
						min_width = 80,
						min_height = 10,
						title = INPUT_TITLE,
						box = 'vertical',
						border = 'rounded',
						{ win = 'input', height = 1, border = 'bottom', title_pos = 'center' },
						{ win = 'list', border = 'none' },
						{ win = 'preview', border = 'top', title = '{preview}' },
					},
				},
				vscode_focus_min = {
					layout = {
						backdrop = { transparent = true },
						row = 1,
						width = 0.4,
						height = 0.4,
						min_width = 60,
						min_height = 10,
						title = INPUT_TITLE,
						box = 'vertical',
						border = 'rounded',
						{ win = 'input', height = 1, border = 'bottom', title_pos = 'center' },
						{ win = 'list', border = 'none' },
					},
				},
				vscode_min = {
					layout = {
						backdrop = false,
						row = 1,
						width = 0.4,
						height = 0.4,
						min_width = 60,
						min_height = 10,
						title = INPUT_TITLE,
						box = 'vertical',
						border = 'rounded',
						{ win = 'input', height = 1, border = 'bottom', title_pos = 'center' },
						{ win = 'list', border = 'none' },
					},
				},
				select_min = {
					layout = {
						backdrop = false,
						width = 0.4,
						min_width = 50,
						height = 0.4,
						min_height = 3,
						title = '{title}',
						title_pos = 'center',
						box = 'vertical',
						border = 'rounded',
						{ win = 'input', height = 1, border = 'bottom' },
						{ win = 'list', border = 'none' },
					},
				},
			},

			sources = {
				pickers = { layout = 'vscode_focus' },
				noice = { confirm = { 'yank', 'close' } },
				notifications = { confirm = { 'yank', 'close' } },
				highlights = { confirm = { 'yank', 'close' } },
			},
		},
	},

	keys = {
		{ ';;', function() Snacks.picker.resume() end, desc = 'Resume' },
		{ ';<leader>', function() Snacks.picker.pickers() end, desc = 'All Pickers' },

		-- Top Pickers & Explorer
		{ ';b', function() Snacks.picker.buffers() end, desc = 'Buffers' },
		{ ';/', function() Snacks.picker.grep() end, desc = 'Grep' },
		{ ';:', function() Snacks.picker.command_history() end, desc = 'Command History' },
		{ ';n', function() Snacks.picker.notifications() end, desc = 'Notification History' },

		-- Find
		{ ';f', '', desc = 'find' },
		{ ';fg', function() Snacks.picker.git_files() end, desc = 'Git Files' },
		{ ';fs', function() Snacks.picker.grep() end, desc = 'Grep' },

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
		{ ';sP', function() Snacks.picker() end, desc = 'Search Pickers' },
		{ ';s"', function() Snacks.picker.registers() end, desc = 'Registers' },
		{ ';s/', function() Snacks.picker.search_history() end, desc = 'Search History' },
		{ ';sa', function() Snacks.picker.autocmds() end, desc = 'Autocmds' },
		{ ';sc', function() Snacks.picker.commands() end, desc = 'Commands' },
		{ ';sd', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics' },
		{ ';sD', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics' },
		{ ';sh', function() Snacks.picker.help() end, desc = 'Help Pages' },
		{ ';sH', function() Snacks.picker.highlights() end, desc = 'Highlights' },
		{ ';si', function() Snacks.picker.icons() end, desc = 'Icons' },
		{ ';sj', function() Snacks.picker.jumps() end, desc = 'Jumps' },
		{ ';sk', function() Snacks.picker.keymaps() end, desc = 'Keymaps' },
		{ ';sm', function() Snacks.picker.marks() end, desc = 'Marks' },
		{ ';sM', function() Snacks.picker.man() end, desc = 'Man Pages' },
		{ ';sq', function() Snacks.picker.qflist() end, desc = 'Quickfix List' },
		{ ';sl', function() Snacks.picker.loclist() end, desc = 'Location List' },
		{ ';su', function() Snacks.picker.undo() end, desc = 'Undo History' },
		{ ';sT', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes' },
		-- lsp
		{ ';ss', function() Snacks.picker.lsp_symbols { filter = LazyVim.config.kind_filter } end, desc = 'LSP Symbols' },
		{ ';sS', function() Snacks.picker.lsp_workspace_symbols { filter = LazyVim.config.kind_filter } end, desc = 'LSP Workspace Symbols' },
	},
}

---@class snacks.picker.Config
---@field exclude? string[]
---@field hidden? boolean
---@field ignored? boolean

---@class PickerYankAction
---@field predicate (fun(item: snacks.picker.Item): any) | string[]
---@field callback? fun(items: snacks.picker.Item[]|string[], copy: PickerYankCopyFn)

---@alias PickerYankCopyFn fun(items: string[]): any
