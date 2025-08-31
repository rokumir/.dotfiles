local function clear_winbar_bg()
	local function _clear_bg(name)
		local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
		if hl.bg or hl.ctermbg then
			hl.bg = nil
			hl.ctermbg = nil
			vim.api.nvim_set_hl(0, name, hl) ---@diagnostic disable-line: param-type-mismatch
		end
	end

	_clear_bg 'WinBar'
	_clear_bg 'WinBarNC'
	_clear_bg 'StatusLine'
	_clear_bg 'StatusLineNC'
	_clear_bg 'LazyBackdrop'
end

local groupid = vim.api.nvim_create_augroup('Nihil_DropBarHlGroups', { clear = true })

clear_winbar_bg()
vim.api.nvim_create_autocmd('ColorScheme', {
	desc = 'Remove WinBar background color as a workaround.',
	group = groupid,
	callback = clear_winbar_bg,
})
vim.api.nvim_create_autocmd('OptionSet', {
	desc = 'Remove WinBar background color as a workaround.',
	pattern = 'background',
	group = groupid,
	callback = clear_winbar_bg,
})
