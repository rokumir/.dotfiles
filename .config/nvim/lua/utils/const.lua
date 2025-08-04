local M = {}

M.ignored_filetype_map = {
	notify = true, -- LazyVim notifications
	noice = true, -- Noice UI
	mason = true,
	lazy = true,
	help = true,
	nofile = true,
	TelescopePrompt = true,
	NvimTree = true,
	dashboard = true,
	alpha = true,
	about = true,
	DressingInput = true,
	DressingSelect = true,
	qf = true, -- Quickfix
	PlenaryTestPopup = true,
	checkhealth = true,
	dbout = true,
	lspinfo = true,
	spectre_panel = true,
	startuptime = true,
	tsplayground = true,
	['gitsigns-blame'] = true,
	['grug-far'] = true,
	['neo-tree'] = true,
	['neotest-output'] = true,
	['neotest-output-panel'] = true,
	['neotest-summary'] = true,
	['copilot-chat'] = true,
	undotree = true,
	undotreeDiff = true,
	netrw = true,
	tutor = true,
	Undotree = true,
	UndotreeDiff = true,
	codecompanion = true,
	oil = true,
	snacks_picker_input = true,
}
M.ignored_filetypes = vim.tbl_keys(M.ignored_filetype_map) ---@type string[]

M.ignored_buftype_map = {
	[''] = true,
	nofile = true,
	terminal = true,
	help = true,
	prompt = true,
}
M.ignored_buftypes = vim.tbl_keys(M.ignored_buftype_map) ---@type string[]

M.document_filetype_map = {
	markdown = true,
	vimwiki = true,
	latex = true,
	help = true,
	text = true,
	tex = true,
}

return M
