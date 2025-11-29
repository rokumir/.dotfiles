-- plugin: johmsalas/text-case.nvim
local M = {}

---@param change_text_fn fun(s:string):string?
function M:apply_on_visual(change_text_fn)
	local buf = vim.api.nvim_get_current_buf()
	local mode = vim.fn.visualmode() -- 'v', 'V' or '\22'
	local head_mark = vim.api.nvim_buf_get_mark(buf, '<')
	local tail_mark = vim.api.nvim_buf_get_mark(buf, '>')

	-- Convert to 0-based indices
	local head_row, head_col = head_mark[1] - 1, head_mark[2]
	local tail_row, tail_col = tail_mark[1] - 1, tail_mark[2] + (mode == 'V' and 0 or 1)

	if mode == 'V' then
		-- LINEWISE: grab full lines, transform, and replace
		local chunks = vim.api.nvim_buf_get_lines(buf, head_row, tail_row + 1, false)
		local new_chunks = vim.tbl_map(change_text_fn, chunks)
		vim.api.nvim_buf_set_lines(buf, head_row, tail_row + 1, false, new_chunks)
	else
		-- CHARWISE or BLOCKWISE: clamp end_col, grab exact text chunk, transform, and replace
		local last_line = vim.api.nvim_buf_get_lines(buf, tail_row, tail_row + 1, false)[1] or ''
		tail_col = math.min(tail_col, #last_line)

		local chunks = vim.api.nvim_buf_get_text(buf, head_row, head_col, tail_row, tail_col, {})
		local new_chunks = vim.tbl_map(change_text_fn, chunks)
		vim.api.nvim_buf_set_text(buf, head_row, head_col, tail_row, tail_col, new_chunks)
	end
end

function M:picker()
	-- stylua: ignore
	local items = {
		{ text = 'Upper',        desc = 'UPPER CASE',        action = 'to_upper_case'        },
		{ text = 'Lower',        desc = 'lower case',        action = 'to_lower_case'        },
		{ text = 'Snake',        desc = 'snake_case',        action = 'to_snake_case'        },
		{ text = 'Dash',         desc = 'dash-case',         action = 'to_dash_case'         },
		{ text = 'Title Dash',   desc = 'Title-Dash-Case',   action = 'to_title_dash_case'   },
		{ text = 'Constant',     desc = 'CONSTANT_CASE',     action = 'to_constant_case'     },
		{ text = 'Dot',          desc = 'dot.case',          action = 'to_dot_case'          },
		{ text = 'Comma',        desc = 'comma,case',        action = 'to_comma_case'        },
		{ text = 'Camel',        desc = 'camelCase',         action = 'to_camel_case'        },
		{ text = 'Pascal',       desc = 'PascalCase',        action = 'to_pascal_case'       },
		{ text = 'Title',        desc = 'Title Case',        action = 'to_title_case'        },
		{ text = 'Path',         desc = 'path/case',         action = 'to_path_case'         },
		{ text = 'Phrase',       desc = 'Phrase case',       action = 'to_phrase_case'       },
		{ text = 'Upper Phrase', desc = 'UPPER PHRASE CASE', action = 'to_upper_phrase_case' },
		{ text = 'Lower Phrase', desc = 'lower phrase case', action = 'to_lower_phrase_case' },
	}

	local function handle_format(_item)
		local item = _item.item ---@type snacks.picker.Item
		local a = Snacks.picker.util.align
		local ret = {}
		ret[#ret + 1] = { a(item.text, 20), 'Character' }
		ret[#ret + 1] = { ' ' }
		ret[#ret + 1] = { a(item.desc, 20), 'Comment' }
		ret[#ret + 1] = { ' ' }
		ret[#ret + 1] = { a(item.action, 20), 'Comment' }
		return ret
	end

	local function handle_on_pick(choice)
		if not choice then return end
		local mode = vim.api.nvim_get_mode().mode
		local text_case = require 'textcase'
		local action = choice.action
		if mode == 'n' then
			text_case.current_word(action)
		else
			local fn = text_case.api[action]
			vim.validate('fn', fn, 'callable')
			self:apply_on_visual(fn)
		end
	end

	Snacks.picker.select(items, {
		prompt = 'Change text to case:',
		snacks = { layout = 'select_min_long', format = handle_format },
	}, handle_on_pick)
end

return M
