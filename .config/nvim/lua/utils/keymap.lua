---@diagnostic disable: duplicate-doc-field
local M = {}

---@generic K: string
---@type table<K, true>
local takes = {
	callback = true,
	buffer = true,
	desc = true,
	expr = true,
	noremap = true,
	nowait = true,
	remap = true,
	replace_keycodes = true,
	script = true,
	silent = true,
	unique = true,
}

---@param keys table<string, unknown>
local function get_opts(keys)
	vim.validate('keys', keys, 'table', true)
	local opts = {} ---@type vim.keymap.set.Opts
	for k, v in pairs(keys) do
		if type(k) == 'string' and takes[k] then opts[k] = v end
	end
	return opts
end

---@param args KeymapingFunArgs
function M.map(args)
	vim.validate('args', args, 'table', true)
	if args.disabled then return end
	local opts = get_opts(args)
	opts.silent = opts.silent ~= false
	opts.noremap = opts.noremap ~= false
	vim.keymap.set(args.mode or 'n', args[1], args[2], opts)
end

return M

---@class KeymapingFunArgs
---@field [1] string
---@field [2] function|string
---@field mode? table|string
---@field buffer? boolean|integer
---@field callback? function
---@field desc? string
---@field expr? boolean
---@field noremap? boolean
---@field nowait? boolean
---@field remap? boolean
---@field replace_keycodes? boolean
---@field script? boolean
---@field silent? boolean
---@field unique? boolean
---@field disabled? boolean
