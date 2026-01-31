local M = {}

M.lsp = {}
M.lsp.disable_default_keymaps = {
	{ 'K', mode = 'i', false },
	{ '<leader>ss', false },
	{ '<leader>sS', false },
	{ '<leader>cc', false },
	{ '<leader>cC', false },
	{ '<leader>cl', false },
	{ 'gd', false },
	{ 'gr', false },
	{ 'gI', false },
	{ 'gy', false },
	{ 'gD', false },
	{ 'K', false },
	{ 'gK', false },
	{ '<c-k>', false },
	{ '<leader>ca', false },
	{ '<leader>cc', false },
	{ '<leader>cC', false },
	{ '<leader>cR', false },
	{ '<leader>cr', false },
	{ '<leader>cA', false },
	{ ']]', false },
	{ '[[', false },
	{ '<a-n>', false },
	{ '<a-p>', false },
}

return M
