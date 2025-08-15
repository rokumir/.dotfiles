local snacks_const = require('utils.const').snacks

---@type snacks.win.Keys
local default_keys = vim.tbl_extend('force', {}, snacks_const.disabled_default_action_keys, {
	['l'] = 'confirm',
	['🔥'] = { 'confirm', mode = { 'n', 'i' } },
	['<c-.>'] = { 'confirm', mode = { 'n', 'i' } },
	['<c-l>'] = { 'confirm', mode = { 'n', 'i' } },
	['<esc>'] = { 'close', mode = { 'n', 'i' } },
	['<c-q>'] = { 'close', mode = { 'n', 'i' } },

	['<a-K>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
	['<a-J>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
	['<a-H>'] = { 'preview_scroll_left', mode = { 'i', 'n' } },
	['<a-L>'] = { 'preview_scroll_right', mode = { 'i', 'n' } },

	['<a-y>'] = { 'yank', mode = { 'n', 'i' } },
	['<a-i>'] = { 'toggle_ignored_persist', mode = { 'i', 'n' } },
	['<a-h>'] = { 'toggle_hidden_persist', mode = { 'i', 'n' } },
	['<a-t>'] = { 'trouble_open_selected', mode = { 'i', 'n' } },

	['<c-w>i'] = 'focus_input',
	['<c-w>l'] = 'focus_list',
	['<c-w>p'] = 'focus_preview',
})

---@type YankPickerUtilsMap
local yank_picker_utils_map = {
	highlights = { predicate = function(item) return item.hl_group end },
	explorer = {
		predicate = function(...) return Snacks.picker.util.path(...) end,
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
	notifications = { predicate = function(item) return item.msg end },
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

			config = function(config)
				config.hidden = vim.g.snacks_hidden
				config.ignored = vim.g.snacks_ignored
			end,

			win = {
				list = { keys = default_keys },
				input = { keys = default_keys },
			},

			actions = {
				trouble_open_selected = function(...) return require('trouble.sources.snacks').actions.trouble_open_selected(...) end,
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
					picker.list:set_selected() -- clear selection, update UI on "client-side" (better for UX)
					if #selected_items == 0 then return end

					local utils_map = yank_picker_utils_map
					local yank_utils = utils_map[picker.opts.source]
					local predicate = yank_utils.predicate or function(item) return item.text end
					local processed_items = vim.tbl_map(predicate, selected_items)

					local copy = function(text_to_copy)
						local text = table.concat(text_to_copy, '\n')
						vim.fn.setreg('+', text)
						Snacks.notify 'Copied to the system (+) register!'
					end

					if yank_utils.callback then
						yank_utils.callback(processed_items, copy)
					else
						copy(processed_items)
					end
				end,
			},
		},
	},
}

---@alias YankPickerUtilsMap table<string, YankPickerUtil>

---@class YankPickerUtil
---@field predicate fun(item: snacks.picker.Item): any
---@field callback? fun(items: snacks.picker.Item[]|string[], copy: CopyToClipboardFunc)

---@alias CopyToClipboardFunc fun(items: string[]): any
