---@module 'lazy'
---@type LazyPluginSpec[]
local M = {
	{
		'LazyVim',
		optional = true,
		opts = {
			icons = {
				git = {
					added = '󱅃 ',
					modified = '󱅅 ',
					removed = '󱅂 ',
				},
				misc = {
					modified = '✨',
					readonly = '🔒',
				},
			},
		},
	},

	{ -- npm package management
		'mason.nvim',
		optional = true,
		keys = function() return {} end,
		opts = {
			ui = { border = 'rounded' },
			ensure_installed = {
				'lua-language-server',
				'stylua',
				'vtsls',
				'biome',
				'prettier',
				'js-debug-adapter',
				'html-lsp',
				'css-lsp',
				'css-variables-language-server',
				'some-sass-language-server',
				'tailwindcss-language-server',
				'emmet-language-server',
				'mdx-analyzer',
				'ruff',
				'bash-language-server',
				'shellcheck',
				'shfmt',
				'tree-sitter-cli',
				'json-lsp',
				'taplo', -- TOML
				'yaml-language-server',
				'qmlls', -- Qt Modeling Language
				'tsgo', -- Typescript beta
			},
		},
	},

	{ -- keymaps helper
		'which-key.nvim',
		lazy = false,
		optional = true,
		priority = 1000,
		opts = {
			win = { border = 'rounded' },
			layout = { spacing = 4 },
			keys = {
				scroll_down = '<a-J>',
				scroll_up = '<a-K>',
			},
		},
	},

	{ -- sessions manager
		'persistence.nvim',
		optional = true,
		opts = {
			options = { 'globals' },
		},
		keys = {
			{ '<leader>qQ', function() require('persistence').save() end, desc = 'Save Session' },
		},
	},
}

-- stylua: ignore
-- Disable LazyVim's default plugs
for _, plug in ipairs {
	'catppuccin',
	'tokyonight.nvim',
	'nvim-lint',
	'nvim-navic',
	'noice.nvim',
	'nui.nvim',
	'mini.pairs',
} do table.insert(M, { plug, optional = true, enabled = false }) end

return M
