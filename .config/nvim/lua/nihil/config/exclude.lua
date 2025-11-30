---@class NihilConfigExclude
local M = {}

M.buffertypes_map = {
	[''] = true,
	nofile = true,
	terminal = true,
	help = true,
	prompt = true,
}
M.buffertypes = vim.tbl_keys(M.buffertypes_map) ---@type string[]

M.filetypes_map = {
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
M.filetypes = vim.tbl_keys(M.filetypes_map) ---@type string[]

M.document_filetypes_map = {
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
M.document_filetypes = vim.tbl_keys(M.document_filetypes_map) ---@type string[]

return M
