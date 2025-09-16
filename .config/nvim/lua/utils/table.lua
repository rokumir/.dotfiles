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

---@param tbl table<string, unknown>
---@param callback fun(key: string, value: unknown)
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

return M
