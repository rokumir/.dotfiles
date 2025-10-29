local M = {}

M.to_case = {}

function M.to_case.capital(str) return (str:gsub('^%l', string.upper)) end

return M
