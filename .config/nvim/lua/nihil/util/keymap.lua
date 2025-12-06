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

---@param lhs string
---@param mode? string
---@return vim.keymap.set.Opts|{[1]:string,[2]:string|function}
function M.get_exist_keymap(lhs, mode)
	mode = mode or 'n'
	local maparg = vim.fn.maparg(lhs, mode, false, true)
	local rhs = maparg.rhs or maparg.callback
	vim.validate('rhs', rhs, { 'string', 'callable' }, 'Invalid rhs for keymap ' .. lhs)

	local args = { lhs, rhs }
	args.buffer = maparg.buffer ~= 0 and maparg.buffer or nil
	args.desc = maparg.desc
	args.expr = maparg.expr == 1
	args.noremap = maparg.noremap == 1
	args.nowait = maparg.nowait == 1
	args.silent = maparg.silent == 1
	args.unique = maparg.unique == 1

	return args
end

M.mapper = {}
M.mapper.records = {}

function M.mapper.set(lhs, mode)
	vim.validate('lhs', lhs, 'string')
	mode = mode or 'n'
	M.mapper[lhs .. mode] = M.get_exist_keymap(lhs, mode)
end

function M.mapper.get(lhs, mode)
	vim.validate('lhs', lhs, 'string')
	mode = mode or 'n'
	local key_id = lhs .. mode
	local keymap = M.mapper[key_id]
	M.mapper[key_id] = nil
	return keymap
end

return M
