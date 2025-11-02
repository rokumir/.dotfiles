---@module 'which-key'

local M = {}

local wk_exist, wk = pcall(require, 'which-key')

local takes = {
	callback = true,
	buffer = true,
	desc = true,
	expr = true,
	noremap = true,
	nowait = true,
	remap = true,
	replace_keycodes = true,
	script = true,
	silent = true,
	unique = true,
}
local function get_opts(keys)
	vim.validate('keys', keys, 'table')
	local opts = {} ---@type vim.keymap.set.Opts
	for k, v in pairs(keys) do
		if type(k) == 'string' and takes[k] then opts[k] = v end
	end
	return opts
end

function M.legacy_map(args)
	vim.validate('args', args, 'table')
	if args.disabled then return end
	local opts = get_opts(args)
	opts.silent = opts.silent ~= false
	opts.noremap = opts.noremap ~= false
	vim.keymap.set(args.mode or 'n', args[1], args[2], opts)
end

---@param mappings wk.Spec
---@param opts wk.Parse?
function M.map(mappings, opts)
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
