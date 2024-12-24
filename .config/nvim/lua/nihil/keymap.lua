---@diagnostic disable: duplicate-doc-field
local M = {}

local skip = { mode = true, id = true, ft = true, rhs = true, lhs = true }

---@param keys table<string, string|function|table>
local function get_opts(keys)
	---@diagnostic disable-next-line: missing-fields
	local opts = {} ---@type vim.keymap.set.Opts
	for k, v in pairs(keys) do
		---@diagnostic disable-next-line: no-unknown
		if type(k) ~= 'number' and not skip[k] then opts[k] = v end
	end
	return opts
end

---@param args KeymapingFunArgs
function M.map(args)
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
