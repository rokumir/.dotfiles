local M = {}

---@return [string, string][]
function M.to_entries(tbl)
	local result = {}
	for text, type in pairs(tbl) do
		table.insert(result, { [1] = text, [2] = type })
	end
	return result
end

function M.map(tbl, callback)
	local result = {}
	for key, value in pairs(tbl) do
		table.insert(result, callback(key, value))
	end
	return result
end

return M
