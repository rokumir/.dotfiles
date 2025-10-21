local M = {}

M.projects_dir = vim.env.RH_PROJECT
M.throwaway_dir = vim.env.RH_THROWAWAY
M.work_dir = vim.env.RH_WORK
M.config_dir = vim.env.XDG_CONFIG_HOME

M.all_working_dirs = {
	vim.fs.normalize '~/documents',
	vim.env.RH_SCRIPT,
	M.projects_dir,
	M.throwaway_dir,
	M.work_dir,
	M.config_dir,
}

return M
