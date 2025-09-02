local util = require 'lspconfig.util'

---@type LazyPluginSpec[]
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
				biome = {},

				mdx_analyzer = {},
				markdown_oxide = {},

				emmet_language_server = {
					filetypes = { 'html', 'javascriptreact', 'typescriptreact', 'htmlangular', 'vue' },
				},

				tailwindcss = {},

				css_variables = {},
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
						DENO_DIR = vim.env.XDG_CACHE_HOME .. '/deno',
						DENO_INSTALL_ROOT = vim.env.XDG_CACHE_HOME .. '/deno',
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
				--tsserver = function(_, opts); require('typescript').setup({ server = opts }); return true; end,
				-- Specify * to use this function as a fallback for any server
				--['*'] = function(server, opts) end,

				---- note: IDK why this is needed, but it is for my tailwindcss config to work
				--tailwindcss = function(_, opts) require('lspconfig').tailwindcss.setup(opts) end,
			},
		},
	},

	{
		'neovim/nvim-lspconfig',
		opts = function()
			local doc_size = vim.g.lsp_doc_max_size or 50

			vim.list_extend(require('lazyvim.plugins.lsp.keymaps').get(), {
				{ 'gd', function() Snacks.picker.lsp_definitions() end, has = 'definition', desc = 'Definition' },
				{ 'gD', function() Snacks.picker.lsp_declarations() end, desc = 'Declaration' },
				{ 'gr', function() Snacks.picker.lsp_references() end, nowait = true, desc = 'References' },
				{ 'gI', function() Snacks.picker.lsp_implementations() end, desc = 'Implementation' },
				{ 'gy', function() Snacks.picker.lsp_type_definitions() end, desc = 'T[y]pe Definition' },
				{ 'K', function() vim.lsp.buf.hover { max_width = doc_size, max_height = doc_size } end, has = 'hover', desc = 'Hover' },
				{ '<c-u>', function() require('noice.lsp').scroll(-4) end, has = 'hover', desc = 'Scroll Up LSP Docs' },
				{ '<c-d>', function() require('noice.lsp').scroll(4) end, has = 'hover', desc = 'Scroll Down LSP Docs' },
				{ '<c-k>', false, mode = 'i', has = 'signatureHelp' },
				{ 'gK', function() vim.lsp.buf.signature_help { max_width = doc_size, max_height = doc_size } end, has = 'signatureHelp', desc = 'Signature Help' },
				{ '<c-s-k>', function() vim.lsp.buf.signature_help { max_width = doc_size, max_height = doc_size } end, mode = { 'i', 'n' }, has = 'signatureHelp', desc = 'Signature Help' },
				{ '<leader>cR', function() Snacks.rename.rename_file() end, desc = 'Rename File', has = { 'workspace/didRenameFiles', 'workspace/willRenameFiles' } },
				{ '<leader>cr', function() require('live-rename').rename { insert = true } end, has = 'rename', desc = 'Rename Symbol' },
				{ '<a-r>', function() require('live-rename').rename { insert = true } end, has = 'rename', desc = 'Rename Symbol' },
				{ '<a-s-o>', LazyVim.lsp.action['source.organizeImports'], has = 'organizeImports', desc = 'Organize Imports' },
				{ '🔥', vim.lsp.buf.code_action, mode = { 'n', 'v', 'i' }, has = 'codeAction', desc = 'Code actions' },
				{ '<c-.>', vim.lsp.buf.code_action, mode = { 'n', 'v', 'i' }, has = 'codeAction', desc = 'Code actions' },
			})
		end,
	},
}
