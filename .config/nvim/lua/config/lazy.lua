_G.Nihil = require 'nihil'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazypath,
	}
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
	spec = {
		{
			'LazyVim/LazyVim',
			version = false,
			import = 'lazyvim.plugins',
			---@type LazyVimConfig
			opts = {
				-- NOTE: the colorschemes in the `lua/plugin/colorscheme` folder need to have `lazy=true`
				-- then activate them with this function. And setting the color via `vim.g.nihil_colorscheme` variable.
				colorscheme = function()
					if not vim.g.nihil_colorscheme then vim.g.nihil_colorscheme = 'rose-pine' end
					if not pcall(require, vim.g.nihil_colorscheme) then
						return Snacks.notify.error {
							'**`vim.g.nihil_colorscheme`** not found!!',
							'Or **[' .. vim.g.nihil_colorscheme .. ']** colorscheme not found!!',
						}
					end
					require('lazy').load { plugins = { vim.g.nihil_colorscheme } }
					vim.cmd.colorscheme(vim.g.nihil_colorscheme)
				end,

				defaults = { keymaps = false, autocmds = false },
				news = { lazyvim = true, neovim = true },
			},
		},

		-- user settings
		{ import = 'plugin' },
	},
	defaults = {
		-- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
		-- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
		lazy = false,
		version = false, -- always use the latest git commit
	},
	ui = { border = 'rounded' },
	rocks = { enabled = false },
	checker = { enabled = false }, -- auto updates
	performance = {
		cache = { enabled = true },
		rtp = { -- disable some rtp plugins
			disabled_plugins = {
				'gzip',
				'netrwPlugin',
				'tarPlugin',
				'tohtml',
				'tutor',
				'zipPlugin',
			},
		},
	},
}
