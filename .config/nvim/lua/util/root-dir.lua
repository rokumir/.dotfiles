---@diagnostic disable: no-unknown
local M = {}

---@param path string
---@param options? { realpath?:boolean }
function M.is_match(path, options)
	path = (path or ''):gsub('^~', vim.env.HOME or '')
	options = options or {}
	options.realpath = options.realpath ~= false

	local success, is_match = pcall(function()
		if options.realpath then path = vim.uv.fs_realpath(path) or error() end
		return path == vim.uv.cwd()
	end)

	return success and is_match
end

---@param patterns string[]
function M.validate_func(patterns)
	vim.validate('patterns', patterns, 'table')
	return function() return M.match_pattern(unpack(patterns)) end
end

---@param ... string
function M.match_pattern(...)
	local root_dir_matcher = require('lspconfig.util').root_pattern(...)
	local is_matched = root_dir_matcher(vim.uv.cwd()) ~= nil
	return is_matched
end

--- Get ignored list from the root dir (.ignore)
---@return string[]
function M.ignored_list()
	local root_dir = vim.fn.getcwd()
	local ignore_filepath = vim.fn.findfile('.ignore', root_dir .. ';')
	if #ignore_filepath == 0 then return {} end

	if type(ignore_filepath) == 'string' then ignore_filepath = { ignore_filepath } end
	---@cast ignore_filepath string[]

	local ignore_list = {}
	for _, file_path in ipairs(ignore_filepath) do
		for _, line in ipairs(vim.fn.readfile(file_path)) do
			local trimmed_line = vim.trim(line)
			if #trimmed_line > 0 and not trimmed_line:match '^#' then table.insert(ignore_list, trimmed_line) end
		end
	end

	return ignore_list
end

return M
