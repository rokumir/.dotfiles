local M = {}

M.filetype = {}

M.filetype.ignored_map = {
	[''] = true,
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
	ministarter = true,
	snacks_dashboard = true,
}
M.filetype.ignored_list = vim.tbl_keys(M.filetype.ignored_map) ---@type string[]

M.filetype.document_map = {
	markdown = true,
	mdx = true,
	vimwiki = true,
	latex = true,
	help = true,
	text = true,
	tex = true,
}
M.filetype.document_list = vim.tbl_keys(M.filetype.document_map)

M.buftype = {}

M.buftype.ignored_map = {
	[''] = true,
	nofile = true,
	terminal = true,
	help = true,
	prompt = true,
}
M.buftype.ignored_list = vim.tbl_keys(M.buftype.ignored_map) ---@type string[]

M.snacks = {}

M.snacks.disabled_default_action_keys = {
	a = false,
	d = false,
	r = false,
	c = false,
	m = false,
	o = false,
	P = false,
	y = false,
	p = false,
	u = false,
	I = false,
	H = false,
	Z = false,
}

M.snacks.excludes = {
	'**/.git/*',
	'**/node_modules/*',
}

return M
