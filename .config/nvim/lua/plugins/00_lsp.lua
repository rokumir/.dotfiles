local map_key = require('utils.keymap').map
local util = require 'lspconfig.util'

---@diagnostic disable: inject-field
---@type table<number, LazyPluginSpec>
return {
	{
		'neovim/nvim-lspconfig',
		lazy = false,
		opts = {
			inlay_hints = { enabled = false },
			codelens = { enabled = false },

			---@type vim.diagnostic.Opts
			diagnostics = {
				float = {
					focusable = true,
					style = 'minimal',
					border = 'rounded',
					source = 'if_many',
				},
			},

			capabilities = {}, -- add any global capabilities here
			autoformat = vim.g.autoformat ~= false, -- format on save

			---@type table<string, lspconfig.Config | {}>
			servers = {
				html = {},
				markdown_oxide = {},
				biome = {},

				emmet_language_server = {
					filetypes = { 'html', 'javascriptreact', 'typescriptreact', 'htmlangular', 'vue' },
				},

				tailwindcss = {
					root_dir = util.root_pattern(
						'tailwind.config.js',
						'tailwind.config.cjs',
						'tailwind.config.mjs',
						'tailwind.config.ts',
						'postcss.config.js',
						'postcss.config.cjs',
						'postcss.config.mjs',
						'postcss.config.ts',
						'package.json',
						'node_modules'
					),
					settings = {
						tailwindCSS = {
							experimental = {
								classRegex = {
									{ 'cva\\(([^)]*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
									{ 'cx\\(([^)]*)\\)', "(?:'|\"|`)([^']*)(?:'|\"|`)" },
									{ 'cn\\(([^)]*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
									{ '([a-zA-Z_]+classNames)\\(([^)]*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
								},
							},
						},
					},
				},

				css_variables = {
					root_dir = util.root_pattern('package.json', 'node_modules'),
				},
				cssls = {
					settings = {
						css = { validate = true, lint = { unknownAtRules = 'ignore' } },
						scss = { validate = true, lint = { unknownAtRules = 'ignore' } },
						less = { validate = true, lint = { unknownAtRules = 'ignore' } },
					},
				},

				vtsls = {
					on_attach = function(client, bufnr) require('twoslash-queries').attach(client, bufnr) end,
				},

				denols = {
					enabled = false,
					root_dir = util.root_pattern('deno.json', 'deno.jsonc', 'deno.lock', 'package.json', 'node_modules'),
					single_file_support = false,
					cmd_env = {
						DENO_DIR = vim.fn.getenv 'XDG_CACHE_HOME' .. '/deno',
						DENO_INSTALL_ROOT = vim.fn.getenv 'XDG_CACHE_HOME' .. '/deno',
					},
					init_options = {
						enable = true,
						lint = true,
						unstable = true,
						importMap = './deno.json',
					},
					settings = {
						deno = {
							enable = true,
							suggest = {
								imports = {
									hosts = {
										['https://deno.land'] = true,
										['https://cdn.nest.land'] = true,
										['https://crux.land'] = true,
									},
								},
							},
						},
					},
				},

				yamlls = {
					-- Have to add this for yamlls to understand that we support line folding
					capabilities = {
						textDocument = {
							foldingRange = {
								dynamicRegistration = false,
								lineFoldingOnly = true,
							},
						},
					},

					settings = {
						redhat = { telemetry = { enabled = false } },
						yaml = {
							keyOrdering = false,
							validate = true,
							-- Must disable built-in schemaStore support to use schemas from SchemaStore.nvim plugin
							-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
							schemaStore = { enable = false, url = '' },
						},
					},
				},
				jsonls = {
					settings = {
						json = {
							format = { enable = true },
							validate = { enable = true },
						},
					},
				},
			},

			---@type table<string, fun(server:string, opts:lspconfig.Config|{}):boolean?>
			setup = {
				-- example to setup with typescript.nvim
				--tsserver = function(_, opts); require("typescript").setup({ server = opts }); return true; end,
				-- Specify * to use this function as a fallback for any server
				--["*"] = function(server, opts) end,

				--NOTE: IDK why this is needed, but it is for my tailwindcss config to work
				tailwindcss = function(_, opts) require('lspconfig').tailwindcss.setup(opts) end,
			},
		},
	},

	{
		'neovim/nvim-lspconfig',
		opts = function()
			---@type LazyKeysLspSpec[]
			local keys = {
				{ 'gd', function() Snacks.picker.lsp_definitions() end, has = 'definition', desc = 'Definition' },
				{ 'gD', function() Snacks.picker.lsp_declarations() end, desc = 'Declaration' },
				{ 'gr', function() Snacks.picker.lsp_references() end, nowait = true, desc = 'References' },
				{ 'gI', function() Snacks.picker.lsp_implementations() end, desc = 'Implementation' },
				{ 'gy', function() Snacks.picker.lsp_type_definitions() end, desc = 'T[y]pe Definition' },
				{ 'K', function() vim.lsp.buf.hover() end, desc = 'Hover' },
				-- { '<c-u>', function() require('noice.lsp').scroll(-4) end, mode = { 'n', 'i' }, desc = 'Scroll Up LSP Docs' },
				-- { '<c-d>', function() require('noice.lsp').scroll(4) end, mode = { 'n', 'i' }, desc = 'Scroll Down LSP Docs' },
				{ '<c-k>', false, mode = 'i', has = 'signatureHelp' },
				{ '<c-a-k>', function() vim.lsp.buf.signature_help() end, mode = 'i', has = 'signatureHelp', desc = 'Signature Help' },
				{ '<c-a-k>', function() vim.lsp.buf.signature_help() end, has = 'signatureHelp', desc = 'Signature Help' },
				{ '<leader>cR', function() Snacks.rename.rename_file() end, desc = 'Rename File', has = { 'workspace/didRenameFiles', 'workspace/willRenameFiles' } },
				{ '<leader>cr', function() require('live-rename').rename { insert = true } end, has = 'rename', desc = 'Rename Symbol' },
				{ '<a-r>', function() require('live-rename').rename { insert = true } end, has = 'rename', desc = 'Rename Symbol' },
				{ '<a-s-o>', LazyVim.lsp.action['source.organizeImports'], has = 'organizeImports', desc = 'Organize Imports' },
				{ '🔥', vim.lsp.buf.code_action, mode = { 'n', 'v', 'i' }, has = 'codeAction', desc = 'Code actions' },
			}

			vim.list_extend(require('lazyvim.plugins.lsp.keymaps').get(), keys)
		end,
	},
}
