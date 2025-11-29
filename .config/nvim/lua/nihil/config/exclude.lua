---@class NihilConfigExclude
local M = {}

M.buffertype = {
	[''] = true,
	nofile = true,
	terminal = true,
	help = true,
	prompt = true,
}
M.buffertype_list = vim.tbl_keys(M.buffertype) ---@type string[]

M.filetype = {
	notify = true, -- LazyVim notifications
	noice = true, -- Noice UI
	mason = true,
	lazy = true,
	help = true,
	nofile = true,
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
	oil = true,
	snacks_picker_input = true,
	ministarter = true,
	snacks_dashboard = true,
	dropbar_menu = true,
	man = true,
	['blink-cmp-menu'] = true,
	['dropbar_menu_fzf'] = true,
	['cmp_docs'] = true,
	['cmp_menu'] = true,
	prompt = true,
}
M.filetype_list = vim.tbl_keys(M.filetype) ---@type string[]

M.document_filetype = {
	markdown = true,
	gitcommit = true,
	mdx = true,
	vimwiki = true,
	latex = true,
	help = true,
	text = true,
	tex = true,
	norg = true,
	rmd = true,
	org = true,
	codecompanion = true,
	['copilot-chat'] = true,
}
M.document_filetype_list = vim.tbl_keys(M.document_filetype)

return M
