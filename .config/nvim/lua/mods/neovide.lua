-- NOTE: Neovide on Windows doesn't work well at the time of this writing
-- Read more on "Some Ctrl + Alt combinations don't work as expected on nordic layout #2899"
-- -> https://github.com/neovide/neovide/issues/2899

if not vim.g.neovide then return end

-- ---------------------------
-- Settings
vim.g.neovide_working_dir = '~'
vim.g.neovide_no_custom_clipboard = true
vim.opt.linespace = 9
vim.g.neovide_scale_factor = 1
vim.g.neovide_confirm_quit = false
vim.g.neovide_hide_mouse_when_typing = false
vim.g.neovide_underline_stroke_scale = 2
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

map {
	'<c-s-n>',
	function()
		vim.schedule(function() os.execute 'neovide.exe > /dev/null 2>&1 &' end)
	end,
	desc = 'New Neovide Instance',
}

-- ---------------------------
-- Goto working dir
if #vim.v.argv > 0 then
	local cmd_flag_index = require('utils.list').index_of(vim.v.argv, function(v) return v == '-c' or v == '--cmd' end)
	if not (cmd_flag_index and string.find(vim.v.argv[cmd_flag_index + 1] or '', '%f[%a]cd%f[%A]')) then
		local cd_home = 'cd ' .. (vim.g.neovide_working_dir or '~')
		vim.cmd(cd_home)
	end
end
