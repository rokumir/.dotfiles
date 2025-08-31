---@diagnostic disable: assign-type-mismatch, param-type-mismatch
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
function M.set_group(group, override_opts)
	local ok, hl = pcall(vim.api.nvim_get_hl, 0, {
		id = vim.api.nvim_get_hl_id_by_name(group),
		create = false,
		link = true,
	})
	if not ok or not hl then return nil end

	vim.api.nvim_set_hl(0, group, vim.tbl_deep_extend('force', hl, override_opts))
end

--- Get highlight color/style object from highlight group name
---@param group string
---@return vim.api.keyset.highlight?
function M.get(group)
	local hl_ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, create = false, link = true })
	if not hl_ok then return end
	if hl.link then return M.get(hl.link) end
	if hl.bg then hl.bg = string.format('#%06x', hl.bg) end
	if hl.fg then hl.fg = string.format('#%06x', hl.fg) end
	if hl.sp then hl.sp = string.format('#%06x', hl.sp) end
	---@diagnostic disable-next-line: return-type-mismatch
	return hl
end

return M
