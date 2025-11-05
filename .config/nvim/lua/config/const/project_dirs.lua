local M = {}

local function no_falties(tbl) ---@return string[]
	return vim.tbl_filter(function(item) return item ~= nil end, tbl)
end
local function val_dir(dir) ---@return string?
	if not dir or vim.fn.isdirectory(dir) == 0 then return end
	return dir
end
local function get_env_fn(name)
	local path
	return function() ---@return string?
		if path == nil then path = val_dir(vim.env[name]) end
		return path
	end
end

M.DOC_DIR = vim.fs.normalize '~/documents'

M.project = get_env_fn 'RH_PROJECT'
M.throwaway = get_env_fn 'RH_THROWAWAY'
M.work = get_env_fn 'RH_WORK'
M.config = get_env_fn 'XDG_CONFIG_HOME'
M.script = get_env_fn 'RH_SCRIPT'

local devs = {}
function M.devs()
	if #devs == 0 then devs = no_falties {
		M.DOC_DIR,
		M.config(),
		M.throwaway(),
		M.script(),
	} end
	return devs
end

local works = {}
function M.works()
	if #works == 0 then works = no_falties {
		M.project(),
		M.work(),
	} end
	return works
end

M.notes = {
	main = val_dir(vim.env.RH_NOTE),
	old = val_dir(M.DOC_DIR .. '/notes'),
}

local all = {}
function M.all()
	if #all == 0 then
		vim.list_extend(all, M.devs())
		vim.list_extend(all, M.works())
	end
	return all
end

return M
