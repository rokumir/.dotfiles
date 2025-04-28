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

return M
