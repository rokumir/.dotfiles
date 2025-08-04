if not vim.g.neovide then return end

vim.opt.linespace = 9
vim.g.neovide_scale_factor = 1

vim.g.neovide_confirm_quit = true

vim.g.neovide_hide_mouse_when_typing = true

vim.g.neovide_underline_stroke_scale = 2

vim.g.neovide_show_border = false

-- Animations
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_cursor_smooth_blink = true

-- Themes
local get_color = require('utils.highlight').get_color
vim.g.neovide_title_text_color = get_color('Identifier', 'fg')
vim.g.neovide_title_background_color = get_color('Normal', 'bg')
