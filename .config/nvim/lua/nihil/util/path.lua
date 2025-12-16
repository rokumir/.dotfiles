local M = {}

--- Shortens a file path in the style of the Fish shell's prompt.
--- e.g., "/home/user/project/file.lua" becomes "~/p/file.lua"
---@param path string The absolute or relative path to shorten.
---@param opts? { keep_last?: number } Options table. `keep_last` is the number of path elements to keep from the end, defaults to 3.
function M.shorten(path, opts)
	opts = opts or {}
	opts.keep_last = opts.keep_last or 3

	if path == nil or path == '' then return '' end
	if path == '/' then return '/' end

	local display_path = vim.fn.fnamemodify(path, ':~')
	local components = vim.split(display_path, '/')

	if #components <= opts.keep_last then return display_path end

	for i = 1, #components - opts.keep_last do
		local part = components[i]
		-- Only shorten non-empty parts and don't shorten the "~" symbol.
		if part ~= '' and part ~= '~' then components[i] = part:sub(1, 1) end
	end

	return table.concat(components, '/')
end

---@param path string
---@param opts {cwd?:string}?
function M.relative(path, opts)
	opts = opts or {}
	local cwd = opts.cwd or vim.fn.getcwd()
	return path:gsub('^' .. cwd .. '/', '')
end

---@param paths string|string[]
---@param opts? {exact?: boolean, realpath?:boolean, winnr?:number, tabnr?:number}
---@return boolean
function M.is_current_matches(paths, opts)
	opts = opts or {}
	paths = type(paths) == 'string' and { paths } or paths ---@cast paths string[]
	opts.exact = opts.exact ~= false
	opts.realpath = opts.realpath ~= false
	opts.winnr = opts.winnr or 0
	opts.tabnr = opts.tabnr or vim.api.nvim_get_current_tabpage()
	local pwd = vim.fn.getcwd(opts.winnr, opts.tabnr)
	for _, path in ipairs(paths) do
		path = vim.fn.expand(path)
		if opts.realpath then path = vim.uv.fs_realpath(path) or error('Invalid path ' .. path) end
		local is_matched = opts.exact and path == pwd or pwd:match('^' .. path)
		if is_matched then return true end
	end
	return false
end

M.root_dir = {}

---@param pattern string[]
function M.root_dir.match_pattern(pattern)
	local root_dir_matcher = require('lspconfig.util').root_pattern(unpack(pattern))
	local is_matched = root_dir_matcher(vim.uv.cwd()) ~= nil
	return is_matched
end

--- Get ignored list from the root dir (.ignore)
---@return string[]
function M.root_dir.ignored_list()
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
