local M = {}

M.ignored_map = {
	[''] = true,
	nofile = true,
	terminal = true,
	help = true,
	prompt = true,
}

M.ignored_list = vim.tbl_keys(M.ignored_map) ---@type string[]

return M
