local M = {}

---@generic TK:string|integer
---@param tbl table<TK, unknown>
---@return {[1]:TK, [2]:unknown}[]
function M.entries(tbl)
	local result = {}
	for key, value in pairs(tbl) do
		table.insert(result, { [1] = key, [2] = value })
	end
	return result
end

---@generic TK:string|integer
---@param tbl {[1]:TK, [2]:unknown}[]
---@return table<string, unknown>
function M.from_entries(tbl)
	local result = {}
	for _, value in ipairs(tbl) do
		result[value[1]] = value[2]
	end
	return result
end

--- Custom table map that have both key and value in the callback function
---@generic TK:string|integer
---@param t table
---@param fn fun(k:TK, v:unknown): unknown
function M.map(t, fn)
	vim.validate('t', t, 'table')
	vim.validate('fn', fn, 'callable')

	local rettab = {}
	for k, v in pairs(t) do
		rettab[k] = fn(k, v)
	end
	return rettab
end

---@generic T : table
---@param tbl T Best to be a dict
---@return T
function M.readonly(tbl)
	vim.validate('tbl', tbl, 'table')
	return setmetatable(vim.deepcopy(tbl, true), { __newindex = function() end })
end

---@generic T : table
---@param tbl T underlying storage table
---@param getters table<string, function>? map: key -> function(backing) returning value
---@param opts { strict?: boolean, silent?: boolean }?
---@return T
function M.complex_readonly(tbl, getters, opts)
	vim.validate('backing', tbl, 'table')
	vim.validate('getters', getters, 'table', true)
	vim.validate('opts', opts, 'table', true)

	getters = getters or {}
	opts = opts or {}

	-- Precompute readonly set for O(1) checks
	local readonly = {}
	for k, _ in pairs(getters) do
		readonly[k] = true
	end

	-- Localize upvalues
	local t = tbl
	local g = getters
	local strict = opts.strict ~= false
	local silent = opts.silent == true

	return setmetatable({}, {
		__index = function(_, key)
			local gf = rawget(g, key)
			return type(gf) == 'function' and gf(t) or rawget(t, key)
		end,
		__newindex = function(_, key, value)
			if strict then
				if not silent then error(("Attempt to modify read-only property '%s'"):format(tostring(key)), 2) end
				return
			end

			if not readonly[key] then rawset(t, key, value) end
		end,
	})
end

--- Get index of given value in a table
---@generic I
---@param tbl I[]
---@return number?
function M.index_of(tbl, value)
	local pred = type(value) == 'function' and value or function(v) return v == value end
	for i, v in ipairs(tbl) do
		if pred(v) then return i end
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
