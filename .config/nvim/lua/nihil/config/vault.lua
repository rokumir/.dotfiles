---@class NihilConfigVault
local M = {}

---@return string?
local function env(env_name) return vim.env[env_name] end

local DOC_DIR = vim.fs.normalize '~/documents'

M.project = env 'RH_PROJECT'
M.throwaway = env 'RH_THROWAWAY'
M.work = env 'RH_WORK'
M.config = env 'XDG_CONFIG_HOME'
M.script = env 'RH_SCRIPT'
M.note = env 'RH_NOTE'
M.second_brain = vim.uv.fs_realpath(env 'RH_BRAIN' or '')

M.devs = {
	DOC_DIR,
	M.throwaway,
	M.config,
	M.script,
	M.note,
}

M.works = {
	M.project,
	M.work,
}

M.all = {}
vim.list_extend(M.all, M.devs)
vim.list_extend(M.all, M.works)

return M
