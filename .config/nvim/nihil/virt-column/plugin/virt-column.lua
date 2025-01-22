local L = {} --- Locals
local U = {} --- Utils

-- ------------------------------------------------------------------------------
--                     CONFIGS
-- ------------------------------------------------------------------------------
---@package
L.initialized = false

L.config = {
	char = '│',
	virtcolumn = '',
	highlight = 'ColorColumn',
	exclude = {
		filetypes = {
			'lspinfo',
			'packer',
			'checkhealth',
			'help',
			'man',
			'TelescopePrompt',
			'TelescopeResults',
		},
		buftypes = { 'nofile', 'quickfix', 'terminal', 'prompt' },
	},
}

-- ------------------------------------------------------------------------------
--                     UTILS
-- ------------------------------------------------------------------------------
---@param bufnr number
---@return number
U.get_bufnr = function(bufnr)
	if not bufnr or bufnr == 0 then
		return vim.api.nvim_get_current_buf() --[[@as number]]
	end
	return bufnr
end

---@generic T: table
---@vararg T
---@return T
U.tbl_join = function(...)
	---@diagnostic disable-next-line: deprecated
	return vim.iter and vim.iter({ ... }):flatten():totable() or vim.tbl_flatten { ... }
end

---@generic T
---@param list T[]
---@param i number
---@return T
U.tbl_get_index = function(list, i) return list[((i - 1) % #list) + 1] end

---@param bufnr number
U.get_filetypes = function(bufnr)
	local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
	if filetype == '' then return { '' } end
	return vim.split(filetype, '.', { plain = true, trimempty = true })
end

---@param a table
---@param b table
U.tbl_intersect = function(a, b)
	---@diagnostic disable-next-line: no-unknown
	for _, v in ipairs(a) do
		if vim.tbl_contains(b, v) then return true end
	end
	return false
end

-- ------------------------------------------------------------------------------
--                     MAIN
-- ------------------------------------------------------------------------------

L.init = function()
	L.namespace = vim.api.nvim_create_namespace 'nihil-virt-column'

	vim.api.nvim_set_decoration_provider(L.namespace, {
		on_win = function(_, win, bufnr, topline, botline_guess)
			local buftype = vim.api.nvim_get_option_value('buftype', { buf = bufnr })
			local filetypes = U.get_filetypes(bufnr)
			if U.tbl_intersect(L.config.exclude.filetypes, filetypes) or vim.tbl_contains(L.config.exclude.buftypes, buftype) then
				pcall(vim.api.nvim_buf_clear_namespace, bufnr, L.namespace, 0, -1)
				return false
			end

			local textwidth = vim.api.nvim_get_option_value('textwidth', { buf = bufnr })
			local leftcol = vim.api.nvim_win_call(win, vim.fn.winsaveview).leftcol or 0

			---@type number[]
			local colorcolumn = {}
			for _, c in ipairs(U.tbl_join(vim.split(vim.api.nvim_get_option_value('colorcolumn', { win = win }), ','), vim.split(L.config.virtcolumn, ','))) do
				if vim.startswith(c, '+') then
					if textwidth ~= 0 then table.insert(colorcolumn, textwidth + tonumber(c:sub(2))) end
				elseif vim.startswith(c, '-') then
					if textwidth ~= 0 then table.insert(colorcolumn, textwidth - tonumber(c:sub(2))) end
				elseif tonumber(c) then
					table.insert(colorcolumn, tonumber(c))
				end
			end

			table.sort(colorcolumn, function(a, b) return a > b end)

			pcall(vim.api.nvim_buf_clear_namespace, bufnr, L.namespace, topline, botline_guess)

			local highlight = { L.config.highlight }
			local char = { L.config.char }

			local i = topline
			while i <= botline_guess do
				for j, column in ipairs(colorcolumn) do
					local width = vim.api.nvim_win_call(win, function()
						---@diagnostic disable-next-line
						return vim.fn.virtcol { i, '$' } - 1
					end)
					if width < column then
						local column_index = #colorcolumn - j + 1
						pcall(vim.api.nvim_buf_set_extmark, bufnr, L.namespace, i - 1, 0, {
							virt_text = {
								{
									U.tbl_get_index(char, column_index),
									U.tbl_get_index(highlight, column_index),
								},
							},
							virt_text_pos = 'overlay',
							hl_mode = 'combine',
							virt_text_win_col = column - 1 - leftcol,
							priority = 1,
						})
					end
				end
				local fold_end = vim.api.nvim_win_call(win, function()
					---@diagnostic disable-next-line: redundant-return-value
					return vim.fn.foldclosedend(i)
				end)
				if fold_end ~= -1 then -- line is folded
					i = fold_end
				end
				i = i + 1
			end
		end,
	})
end

-- -----------------------------------------------
-- Main
if not L.initialized then
	L.init()
	L.initialized = true
end
