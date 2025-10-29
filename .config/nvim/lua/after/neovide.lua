if not vim.g.neovide then return end

-- Settings
vim.g.neovide_working_dir = '~'
vim.g.neovide_no_custom_clipboard = false
vim.opt.linespace = 8
vim.g.neovide_scale_factor = 1
vim.g.neovide_confirm_quit = false
vim.g.neovide_hide_mouse_when_typing = false
vim.g.neovide_underline_stroke_scale = 2
vim.g.neovide_no_idle = false
vim.g.neovide_refresh_rate_idle = 3
vim.g.neovide_theme = 'auto'
vim.g.neovide_hide_mouse_when_typing = true

-- Animations
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_cursor_smooth_blink = true

-- Themes
local hl_color = require('snacks.util').color
vim.g.neovide_opacity = 1
vim.g.neovide_background_color = hl_color('Normal', 'bg')
vim.g.neovide_title_text_color = hl_color('Identifier', 'fg')
vim.g.neovide_title_background_color = vim.g.neovide_background_color

-- Keymaps  BUG: Ctrl+Alt doesn't work on Windows -> https://github.com/neovide/neovide/issues/2899
require('util.keymap').map {
	{
		'<c-s-n>',
		vim.schedule_wrap(function()
			vim.fn.jobstart 'neovide.exe ~ > /dev/null 2>&1 &'
			Snacks.notify 'Opening a new Neovide instance...'
		end),
		desc = 'New Neovide Instance',
	},
}

vim.api.nvim_create_autocmd('VimEnter', {
	group = vim.api.nvim_create_augroup('nihil_neovide_init_cd', { clear = true }),
	callback = function()
		local cmd_flag_index = require('util.list').index_of(vim.v.argv or {}, function(v) return v == '-c' or v == '--cmd' end)
		if not cmd_flag_index or not string.find(vim.v.argv[cmd_flag_index + 1] or '', '%f[%a]cd%f[%A]') then
			local cd_home = 'cd ' .. (vim.g.neovide_working_dir or '~')
			vim.cmd(cd_home)
		end
	end,
})
