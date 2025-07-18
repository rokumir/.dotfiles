local M = {}

M.tbl = {}

--- Ensure Table prop not empty.
--- Its main purpose: just a quick and simple syntax.
---@param prop table
---@param initial_value any default: {}
function M.tbl.not_empty(prop, initial_value)
	if prop == nil then return end
	prop = initial_value or {}
end

--- Highlights utils
M.hl = {}

---@alias HlDef { fg?: string, bg?: string, bold?: boolean, italic?: boolean, underline?: boolean, [string]: any }

---Apply a set of highlight overrides.
---@param defs table<string, HlDef> Map from highlight group name to definitions
---@param namespace? integer # default to 0 (global)
function M.hl.def(defs, namespace)
	namespace = namespace or 0
	assert(type(defs) == 'table', 'defs must be a table')

	for group, opts in pairs(defs) do
		assert(type(group) == 'string', 'highlight group name must be string')
		assert(type(opts) == 'table', 'highlight definition must be a table')

		-- Only keep allowed keys to avoid passing nils
		local hl = {}
		for _, key in ipairs { 'fg', 'bg', 'bold', 'italic', 'underline' } do
			if opts[key] ~= nil then hl[key] = opts[key] end
		end

		vim.api.nvim_set_hl(namespace, group, hl)
	end
end

return M
