---@class NihilUtilMisc
local M = {}

function M.augroup(name) return vim.api.nvim_create_augroup('nihil_' .. name, { clear = true }) end

function M.clear_ui_noises()
	pcall(Snacks.words.clear)
	vim.cmd.nohlsearch()
	vim.cmd.diffupdate()
	vim.cmd.redraw()
	pcall(function() require('noice.view.backend.snacks'):dismiss() end)
end

-- Diagnostics
---@param count number
---@param severity? vim.diagnostic.SeverityName
function M.diag_jump(count, severity)
	local s = vim.diagnostic.severity[severity] or nil
	return function() vim.diagnostic.jump { float = true, count = count, severity = s } end
end

---@param dir 'h'|'j'|'k'|'l'
function M.pane_nav(dir)
	return function()
		return vim.schedule(function() vim.cmd.wincmd(dir) end)
	end
end

return M
