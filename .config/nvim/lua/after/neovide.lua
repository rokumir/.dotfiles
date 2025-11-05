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
-- vim.g.neovide_background_image = '/mnt/r/images/wallpapers/xianyu-hao-YKVLhmbz81w-unsplash.jpg'
-- vim.g.neovide_background_image_transparency = 0.5

vim.api.nvim_create_user_command('OpenNewNeovide', function(opts)
	vim.schedule(function()
		local expanded_args = vim.fn.expand(opts.args)
		local path = vim.fn.isdirectory(expanded_args) ~= 0 and expanded_args or nil
		local cmd = 'neovide.exe'
		local msg = { '**[Opening Neovide at dir:]**' }
		if path then
			cmd = cmd .. ' -- -c "cd ' .. path .. '"'
			msg[#msg + 1] = '**[' .. path:gsub('^' .. vim.env.HOME, '~') .. ']**'
		end

		vim.fn.jobstart(cmd, { cwd = vim.env.HOME, detach = true })
		Snacks.notify(msg)
	end)
end, {
	desc = 'Open New Neovide Instance',
	nargs = '?', -- ⬅️ allow zero or one argument
	complete = 'dir', -- ⬅️ optional: enables directory completion
})

-- Keymaps  BUG: Ctrl+Alt doesn't work on Windows -> https://github.com/neovide/neovide/issues/2899
require('util.keymap').map {
	{ '<f2>N', '<cmd>OpenNewNeovide<cr>', desc = 'New Neovide Instance' },
}

vim.api.nvim_create_autocmd('VimEnter', {
	group = require('util.autocmd').augroup 'neovide_init_cd',
	callback = function()
		local cmd_flag_index = require('util.list').index_of(vim.v.argv or {}, function(v) return v == '-c' or v == '--cmd' end)
		if not cmd_flag_index or not string.find(vim.v.argv[cmd_flag_index + 1] or '', '%f[%a]cd%f[%A]') then
			local pwd = (vim.g.neovide_working_dir or '~')
			vim.cmd('cd ' .. pwd)
		end
	end,
})
