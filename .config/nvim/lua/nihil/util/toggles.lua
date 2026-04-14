local M = {}

---@param state? boolean
function M.lualine_statusline(state)
	state = state or not (vim.g.nihil_lualine_show or vim.o.laststatus == 3)
	require('lualine').hide { place = { 'statusline' }, unhide = state }
	vim.o.laststatus = state and 3 or 0
	vim.g.nihil_lualine_show = state
end

return M
