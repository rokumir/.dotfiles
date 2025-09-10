-- for 'johmsalas/text-case.nvim' plugin
local M = {}

M.snacks_items = {}

function M:get_items()
	-- stylua: ignore
	if #self.snacks_items == 0 then self.snacks_items = {
		{ text = 'Upper'       , example = 'UPPER CASE'       , action = 'to_upper_case'        },
		{ text = 'Lower'       , example = 'lower case'       , action = 'to_lower_case'        },
		{ text = 'Snake'       , example = 'snake_case'       , action = 'to_snake_case'        },
		{ text = 'Dash'        , example = 'dash-case'        , action = 'to_dash_case'         },
		{ text = 'Title Dash'  , example = 'Title-Dash-Case'  , action = 'to_title_dash_case'   },
		{ text = 'Constant'    , example = 'CONSTANT_CASE'    , action = 'to_constant_case'     },
		{ text = 'Dot'         , example = 'dot.case'         , action = 'to_dot_case'          },
		{ text = 'Comma'       , example = 'comma,case'       , action = 'to_comma_case'        },
		{ text = 'Camel'       , example = 'camelCase'        , action = 'to_camel_case'        },
		{ text = 'Pascal'      , example = 'PascalCase'       , action = 'to_pascal_case'       },
		{ text = 'Title'       , example = 'Title Case'       , action = 'to_title_case'        },
		{ text = 'Path'        , example = 'path/case'        , action = 'to_path_case'         },
		{ text = 'Phrase'      , example = 'Phrase case'      , action = 'to_phrase_case'       },
		{ text = 'Upper Phrase', example = 'UPPER PHRASE CASE', action = 'to_upper_phrase_case' },
		{ text = 'Lower Phrase', example = 'lower phrase case', action = 'to_lower_phrase_case' },
	} end
	return self.snacks_items
end

function M:apply_on_visual(fn)
	local bufnr = vim.api.nvim_get_current_buf()
	local mode = vim.fn.visualmode() -- 'v', 'V' or '\22'
	local s_mark = vim.api.nvim_buf_get_mark(bufnr, '<')
	local e_mark = vim.api.nvim_buf_get_mark(bufnr, '>')

	-- Convert to 0-based indices
	local s_row, s_col = s_mark[1] - 1, s_mark[2]
	local e_row, e_col = e_mark[1] - 1, e_mark[2] + (mode == 'V' and 0 or 1)

	if mode == 'V' then
		-- LINEWISE: grab full lines, transform, and replace
		local lines = vim.api.nvim_buf_get_lines(bufnr, s_row, e_row + 1, false)
		for i, line in ipairs(lines) do
			lines[i] = fn(line)
		end
		vim.api.nvim_buf_set_lines(bufnr, s_row, e_row + 1, false, lines)
	else
		-- CHARWISE or BLOCKWISE: clamp end_col, grab exact text chunk, transform, and replace
		local last_line = vim.api.nvim_buf_get_lines(bufnr, e_row, e_row + 1, false)[1] or ''
		e_col = math.min(e_col, #last_line)

		local chunk = vim.api.nvim_buf_get_text(bufnr, s_row, s_col, e_row, e_col, {})
		local new_chunk = vim.tbl_map(fn, chunk)
		vim.api.nvim_buf_set_text(bufnr, s_row, s_col, e_row, e_col, new_chunk)
	end
end

function M:picker()
	Snacks.picker.pick {
		title = 'Change Text Case',
		layout = 'vscode_min',
		items = self:get_items(),
		format = function(item)
			local a = Snacks.picker.util.align
			local ret = {}
			ret[#ret + 1] = { '  ', 'Keyword' }
			ret[#ret + 1] = { ' ' }
			ret[#ret + 1] = { a(item.text, 20) }
			ret[#ret + 1] = { ' ' }
			ret[#ret + 1] = { a(item.example, 20), 'Comment' }
			return ret
		end,
		confirm = function(picker, item)
			picker:close()
			local mode = vim.api.nvim_get_mode().mode
			local text_case = require 'textcase'
			local action = item.action
			if mode == 'n' then
				text_case.current_word(action)
			else
				local fn = text_case.api[action]
				if fn then self:apply_on_visual(fn) end
			end
		end,
	}
end

return M
