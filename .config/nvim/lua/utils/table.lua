local M = {}

---@param tbl table<string, any>
---@return [string, string][]
function M.entries(tbl)
	local result = {}
	for key, value in pairs(tbl) do
		table.insert(result, { [1] = key, [2] = value })
	end
	return result
end

---@param tbl [string, unknown][]
---@return table<string, unknown>
function M.from_entries(tbl)
	local result = {}
	for _, value in ipairs(tbl) do
		result[value[1]] = value[2]
	end
	return result
end

--- Custom table map that have both key and value in the callback function
---@generic TValue : unknown
---@generic TResult
---@param tbl table<number|string, TValue> | TValue[]
---@param callback fun(key: number|string, value: TValue): TResult
---@return TResult[]
function M.map(tbl, callback)
	local result = {}
	for key, value in pairs(tbl) do
		table.insert(result, callback(key, value))
	end
	return result
end

---@param tbl unknown[]
function M.join_sep(tbl, sep)
	for index, _ in pairs(tbl) do
		if index % 2 == 0 then table.insert(tbl, index, sep) end
	end
	return tbl
end

---@generic T : table
---@param tbl T best to be a dict
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

return M

---@generic TValue : unknown
---@generic TKey : string|number
---@generic TResult
---@alias TableMapperList fun(tbl: TValue[], callback: fun(key: number, value: TValue): any): TResult[]
---@alias TableMapperDict fun(tbl: table<TKey, TValue>, callback: fun(key: TKey, value: TValue): any): TResult[]
