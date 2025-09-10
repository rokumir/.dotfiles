-------------------------------------------------------------------------------
--- Credits:
---   - Author: folke (LazyVim)
---   - Source: [LazyVim's UI utils](https://github.com/LazyVim/LazyVim/blob/a1c3ec4cd43fe61e3b614237a46ac92771191c81/lua/lazyvim/util/ui.lua#L228)
---
--- This module provides UI utilities.
-------------------------------------------------------------------------------

---@class Neovim.UI
local M = {}

---@param buf number?
---@param failsafe false?
function M.bufremove(buf, failsafe)
	buf = buf or 0
	buf = buf == 0 and vim.api.nvim_get_current_buf() or buf
	failsafe = failsafe ~= false

	if vim.bo.modified then
		local choice = vim.fn.confirm(('Save changes to %q?'):format(vim.fn.bufname()), '&Yes\n&No\n&Cancel')
		if choice == 0 or choice == 3 then -- 0 for <Esc>/<C-c> and 3 for Cancel
			return
		end
		if choice == 1 then -- Yes
			vim.cmd.write()
		end
	end

	if failsafe then
		for _, win in ipairs(vim.fn.win_findbuf(buf)) do
			vim.api.nvim_win_call(win, function()
				if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then return end
				-- Try using alternate buffer
				local alt = vim.fn.bufnr '#'
				if alt ~= buf and vim.fn.buflisted(alt) == 1 then
					vim.api.nvim_win_set_buf(win, alt)
					return
				end

				-- Try using previous buffer
				local has_previous = pcall(vim.cmd.bprevious)
				if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then return end

				-- Create new listed buffer
				local new_buf = vim.api.nvim_create_buf(true, false)
				vim.api.nvim_win_set_buf(win, new_buf)
			end)
		end
	end

	if vim.api.nvim_buf_is_valid(buf) then pcall(vim.api.nvim_buf_delete, buf, { force = true }) end
end

return M
