---@diagnostic disable: no-unknown
local M = {}

local lsp_util = require 'lspconfig.util'

---@param path string
---@param options? { realpath?:boolean }
function M.is_match(path, options)
	path = path or ''
	options = options or {}

	local fullpath = (options.realpath or true) and vim.uv.fs_realpath(path) or path
	if not fullpath then return false end

	local current_path = vim.uv.cwd()
	return current_path == fullpath
end

---@param patterns string[]
function M.validate_func(patterns)
	if type(patterns) ~= 'table' then return end
	return function() return M.match_pattern(unpack(patterns)) end
end

---@param ... string
function M.match_pattern(...)
	local root_dir_matcher = lsp_util.root_pattern(...)
	local is_matched = root_dir_matcher(vim.uv.cwd()) ~= nil
	return is_matched
end

--- Get ignored list from the root dir (.ignore)
---@return string[]
function M.ignored_list()
	local root_dir = vim.fn.getcwd()
	local ignore_filepath = vim.fn.findfile('.ignore', root_dir .. ';')
	if not ignore_filepath or ignore_filepath == '' or #ignore_filepath == 0 then return {} end

	if type(ignore_filepath) == 'table' then
		LazyVim.error { '[DEBUG]:', 'Weird type', '(type:', type(ignore_filepath) .. ')!' }
		return {}
	end

	local ignore_list = {}
	for _, line in ipairs(vim.fn.readfile(ignore_filepath) or {}) do
		local trimmed_line = vim.trim(line)
		if #trimmed_line > 0 and not trimmed_line:match '^#' then table.insert(ignore_list, trimmed_line) end
	end

	return ignore_list
end

return M
