---@alias NihilUtilKeymapFunc fun(mappings: wk.Spec, opts?: wk.Parse)

---@type table | fun(mappings: wk.Spec, opts?: wk.Parse)
local M = setmetatable({}, {
	__call = function(t, ...) return t.map(...) end,
})

---@param mappings wk.Spec
---@param opts? wk.Parse
function M.map(mappings, opts)
	local wk_exist, wk = pcall(require, 'which-key')
	if not wk_exist then error({ '"which-key" plugin is not found!', 'Use `legacy_map` func instead!' }, 4) end
	wk.add(mappings, opts)
end

---@param mappings (string|{[1]:string, mode?: string|string[], nop?:true})[]
function M.unmap(mappings)
	for _, keymap in ipairs(mappings) do
		local is_tbl_km = type(keymap) == 'table'
		local lhs = is_tbl_km and keymap[1] or keymap
		local mode = is_tbl_km and keymap.mode or ''
		if is_tbl_km and keymap.nop == true then
			M.map { lhs, '<nop>', mode = mode }
		else
			pcall(vim.keymap.del, mode, lhs)
		end
	end
end

return M
