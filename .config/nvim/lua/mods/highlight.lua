--#region Clear highlights
local function clear_winbar_bg()
	local function clear_bg(name)
		local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
		if hl.bg or hl.ctermbg then
			hl.bg = nil
			hl.ctermbg = nil
			vim.api.nvim_set_hl(0, name, hl) ---@diagnostic disable-line: param-type-mismatch
		end
	end
	for _, group in ipairs {
		'WinBar',
		'WinBarNC',
		'StatusLine',
		'StatusLineNC',
		'LazyBackdrop',
	} do
		clear_bg(group)
	end
end

local clear_groupid = vim.api.nvim_create_augroup('nihil_clear_highlights', { clear = true })
clear_winbar_bg()
vim.api.nvim_create_autocmd('ColorScheme', {
	desc = 'Remove WinBar background color as a workaround.',
	group = clear_groupid,
	callback = clear_winbar_bg,
})
vim.api.nvim_create_autocmd('OptionSet', {
	desc = 'Remove WinBar background color as a workaround.',
	pattern = 'background',
	group = clear_groupid,
	callback = clear_winbar_bg,
})
--#endregion
