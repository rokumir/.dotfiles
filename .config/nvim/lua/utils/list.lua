local M = {}

--- Get index of given value in a table
---@generic I
---@param tbl I[]
---@param value I
---@param opts ListIndexOfOptions?
---@return number?, I?
function M.index_of(tbl, value, opts)
	opts = opts or {}
	local pred = type(value) == 'function' and value or function(v) return v == value end
	for i, v in ipairs(tbl) do
		if pred(v) then
			if opts.value then
				return i, v
			else
				return i
			end
		end
	end
end

return M

---
---@alias ListIndexOfOptions { value?: true }
