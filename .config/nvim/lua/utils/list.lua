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

--- Filter a table using a predicate function
---
---@generic T
---@param t T[] (table) Table
---@param fn fun(value: T): boolean (function) Function
---@return T[] : Table of filtered values
function M.filter(t, fn)
	vim.validate('fn', fn, 'callable')
	vim.validate('t', t, 'table')
	--- @cast t table<any,any>

	local rettab = {} --- @type table<any,any>
	for _, entry in pairs(t) do
		if fn(entry) then rettab[#rettab + 1] = entry end
	end
	return rettab
end

return M

---
---@alias ListIndexOfOptions { value?: true }
