local PathUtil = require 'nihil.util.path'
local TableUtil = require 'nihil.util.table'

local M = {}
M.highlights = {}

--- Set background transparent
---@param highlights bufferline.Highlights
function M.highlights.set_bg_transparent(highlights)
	highlights = highlights or {}
	for _, hl in pairs {
		'fill',
		'tab',
		'buffer',
		'numbers',
		'modified',
		'tab_close',
		'separator',
		'background',
		'diagnostic',
		'close_button',
		'hint_visible',
		'info_visible',
		'trunc_marker',
		'error_visible',
		'tab_separator',
		'buffer_visible',
		'group_separator',
		'numbers_visible',
		'warning_visible',
		'modified_visible',
		'offset_separator',
		'indicator_visible',
		'separator_visible',
		'diagnostic_visible',
		'close_button_visible',
		'hint_diagnostic_visible',
		'info_diagnostic_visible',
		'error_diagnostic_visible',
		'warning_diagnostic_visible',
		'hint',
		'info',
		'error',
		'warning',
		'hint_diagnostic',
		'info_diagnostic',
		'error_diagnostic',
		'warning_diagnostic',
		'duplicate',
		'duplicate_visible',
		'tab_selected',
		'modified_selected',
		'pick',
		'indicator_selected',
		'separator_selected',
		'close_button_selected',
		'tab_separator_selected',
		'pick_visible',
		'duplicate_selected',
		'hint_selected',
		'info_selected',
		'pick_selected',
		'error_selected',
		'buffer_selected',
		'numbers_selected',
		'warning_selected',
		'diagnostic_selected',
		'hint_diagnostic_selected',
		'info_diagnostic_selected',
		'error_diagnostic_selected',
		'warning_diagnostic_selected',
	} do
		highlights[hl] = highlights[hl] or {}
		highlights[hl].bg = 'none'
	end
end

--- Modify the highlight settings
---@param highlights bufferline.Highlights
function M.highlights.style_underline(highlights)
	highlights = highlights or {}

	local indicator_color = (({
		['rose-pine'] = function() return require('rose-pine.palette').love end,
		['vesper'] = function() return require('vesper.colors').red end,
	})[vim.g.colors_name] or function() return '#31d0a5' end)()

	for _, hl in ipairs {
		'tab_selected',
		'modified_selected',
		'indicator_selected',
		'separator_selected',
		'close_button_selected',
		'tab_separator_selected',
		'duplicate_selected',
		'hint_selected',
		'info_selected',
		'pick_selected',
		'error_selected',
		'buffer_selected',
		'numbers_selected',
		'warning_selected',
		'diagnostic_selected',
		'hint_diagnostic_selected',
		'info_diagnostic_selected',
		'error_diagnostic_selected',
		'warning_diagnostic_selected',
	} do
		highlights[hl] = highlights[hl] or {}
		highlights[hl].sp = indicator_color
	end
end

-------------------------------------------------------------------
M.picker = {}

function M.picker.sort_actions()
	-- stylua: ignore
	local sort_actions = {
		{ icon = '󰥨 ', text = 'Directory'         , cmd = 'BufferLineSortByDirectory'        , hl = 'DiagnosticInfo' },
		{ icon = '󰥨 ', text = 'Relative Directory', cmd = 'BufferLineSortByRelativeDirectory', hl = '@namespace'     },
		{ icon = ' ', text = 'Extension'         , cmd = 'BufferLineSortByExtension'        , hl = 'Error'     },
		{ icon = '󱎅 ', text = 'Tabs'              , cmd = 'BufferLineSortByTabs'             , hl = 'DiagnosticHint' },
	}

	---@type snacks.picker.ui_select.Opts
	local opts = {
		prompt = 'Sort tabs by:',
		snacks = {
			layout = 'select_min_short',
			format = function(_item)
				local item = _item.item
				return {
					{ item.icon, item.hl },
					{ ' ' .. item.text .. ' ', item.hl },
					{ item.cmd, 'Comment' },
				}
			end,
		},
	}
	local handle_choice = function(choice)
		if not choice then return end
		vim.cmd[choice.cmd]()
		Snacks.notify('Bufferline sort by ' .. choice.text)
	end

	Snacks.picker.select(sort_actions, opts, handle_choice)
end

function M.picker.tabpages()
	local raw_tabpages_info = require('bufferline.tabpages').get()
	local tabpages = TableUtil.map(raw_tabpages_info, function(idx, tabinfo)
		local tabid = tabinfo.id
		local cwd = vim.fn.getcwd(0, tabid)
		local tabname = (tabinfo.component[2] or {}).text or tabid
		local pretty_cwd = PathUtil.shorten(cwd, { keep_last = 5 })
		return {
			idx = idx,
			cwd = cwd,
			id = tabid,
			name = tabname or tabid,
			pretty_cwd = pretty_cwd,
			text = table.concat({ tabid, tabname, pretty_cwd }, ' '),
		}
	end)

	---@type snacks.picker.ui_select.Opts
	local opts = {
		prompt = 'Tabs',
		title = 'Tabs',
		snacks = {
			layout = 'select_min_short',
			format = function(item)
				local a = Snacks.picker.util.align
				return {
					{ a(tostring(item.id), 3), 'Character' },
					{ ' ' },
					{ a(item.name, 20), 'Todo' },
					{ ' ' },
					{ item.pretty_cwd, 'Comment' },
				}
			end,
			win = { input = { keys = { ['<c-x>'] = 'close_tab' } } },
			actions = {
				close_tab = function(picker, item)
					vim.cmd(('tabclose %d'):format(item.id))
					picker:update()
				end,
			},
		},
	}

	local handle_choice = function(choice)
		if not choice then return end
		vim.cmd('tabnext ' .. choice.id)
	end

	Snacks.picker.select(tabpages, opts, handle_choice)
end

return M
