-- NOTE: Neovide on Windows doesn't work well at the time of this writing
-- Read more on "Some Ctrl + Alt combinations don't work as expected on nordic layout #2899"
-- -> https://github.com/neovide/neovide/issues/2899

if not vim.g.neovide then return end

-- ---------------------------
-- Settings
vim.g.neovide_working_dir = '~'
vim.g.neovide_no_custom_clipboard = false
vim.opt.linespace = 10
vim.g.neovide_scale_factor = 1.2
vim.g.neovide_confirm_quit = true
vim.g.neovide_hide_mouse_when_typing = false
vim.g.neovide_underline_stroke_scale = 2
vim.g.neovide_show_border = false
vim.g.neovide_refresh_rate_idle = 3

-- Animations
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_cursor_smooth_blink = true

-- Themes
local get_color = require('utils.highlight').get
local theme_hl = {
	fg = get_color('Identifier').fg,
	bg = get_color('Normal').bg,
}
vim.g.neovide_opacity = 1
vim.g.neovide_background_color = theme_hl.bg
vim.g.neovide_title_text_color = theme_hl.fg
vim.g.neovide_title_background_color = vim.g.neovide_background_color

-- ---------------------------
-- Keymaps
local map = require('utils.keymap').map

map { '<c-s-n>', function() os.execute 'neovide.exe > /dev/null 2>&1 &' end, desc = 'New Neovide Instance' }

-- ---------------------------
-- Goto working dir
if #vim.v.argv > 0 then
	for i, arg in pairs(vim.v.argv) do
		if not vim.tbl_contains({ '-c', '--cmd' }, arg) or not string.find(vim.v.argv[i + 1], '%f[%a]cd%f[%A]') then
			vim.cmd('cd ' .. (vim.g.neovide_working_dir or '~'))
			break
		end
	end
end
