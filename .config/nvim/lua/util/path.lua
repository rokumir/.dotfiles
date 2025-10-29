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

return M
