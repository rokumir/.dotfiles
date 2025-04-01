local M = {}

local lsp_util = require 'lspconfig.util'

---@param ... string
function M.is_root_dir(...)
	local root_dir_matcher = lsp_util.root_pattern(...)
	local is_matched = root_dir_matcher(vim.uv.cwd()) ~= nil
	return is_matched
end

---@param patterns string[]
function M.root_validation(patterns)
	if type(patterns) ~= 'table' then return end
	return function() return M.is_root_dir(unpack(patterns)) end
end

return M
