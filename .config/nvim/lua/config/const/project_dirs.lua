local M = {}

M.doc_dir = vim.fs.normalize '~/documents'

M.project = vim.env.RH_PROJECT
M.throwaway = vim.env.RH_THROWAWAY
M.work = vim.env.RH_WORK
M.config = vim.env.XDG_CONFIG_HOME
M.script = vim.env.RH_SCRIPT

M.devs = {
	vim.fs.normalize '~/documents',
	M.config,
	M.throwaway,
	M.script,
}

M.works = {
	M.project,
	M.work,
}

M.notes = {
	main = vim.env.RH_NOTE,
	old = M.doc_dir .. '/notes',
}

M.all = {}
vim.list_extend(M.all, M.devs)
vim.list_extend(M.all, M.works)

return M
