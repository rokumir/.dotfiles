---@diagnostic disable: no-unknown
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

--- Get ignored list from the root dir (.ignore)
function M.ignored_list()
	local root_dir = vim.fn.getcwd()
	local ignore_filepath = vim.fn.findfile('.ignore', root_dir .. ';') ---@type string
	if not ignore_filepath or ignore_filepath == '' then
		return {} -- Return empty table instead of nil
	end

	local ignore_list = {}
	for _, line in ipairs(vim.fn.readfile(ignore_filepath) or {}) do
		local trimmed_line = vim.trim(line)
		if trimmed_line:len() > 0 and not trimmed_line:match '^#' then table.insert(ignore_list, trimmed_line) end
	end

	return ignore_list
end

return M
