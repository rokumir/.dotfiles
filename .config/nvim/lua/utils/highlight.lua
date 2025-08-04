local M = {}

---Apply a set of highlight overrides.
---@param defs table<string, vim.api.keyset.set_hl_info> Map from highlight group name to definitions
---@param namespace? integer # default to 0 (global)
function M.set(defs, namespace)
	namespace = namespace or 0
	for group, opts in pairs(defs) do
		vim.api.nvim_set_hl(namespace, group, opts)
	end
end

--- Merge highlight
---@param group string
---@param override_opts vim.api.keyset.set_hl_info
function M.merge(group, override_opts)
	local ok, hl = pcall(vim.api.nvim_get_hl, 0, {
		id = vim.api.nvim_get_hl_id_by_name(group),
		create = false,
		link = true,
	})
	if not ok or not hl then return nil end

	vim.api.nvim_set_hl(0, group, vim.tbl_deep_extend('force', hl, override_opts))
end

--- Get highlight color/style from highlight group name
---@param group string
---@param color 'fg'|'bg'|'sp'
function M.get_color(group, color)
	local id_ok, hl_id = pcall(vim.api.nvim_get_hl_id_by_name, group)
	local hl_ok, hl = pcall(vim.api.nvim_get_hl, 0, { id = hl_id, create = false, link = true })
	if not hl_ok or not id_ok then return nil end

	if hl[color] then
		return string.format('#%06x', hl[color])
	elseif hl.link then
		return M.get_color(hl.link, color)
	end

	return error('Couldn\'t find "' .. group .. '"')
end

return M
