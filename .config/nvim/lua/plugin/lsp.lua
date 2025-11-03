local util = require 'lspconfig.util'
local DOC_WIN_SIZE = vim.g.lsp_doc_max_size or 50
local function twoslash_queries_attach_fn(...) return require('twoslash-queries').attach(...) end

return {
	'neovim/nvim-lspconfig',
	lazy = false,
	---@class PluginLspOpts
	opts = {
		autoformat = false,
		inlay_hints = { enabled = true },
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

		---@type table<string, lazyvim.lsp.Config|boolean>
		servers = {
			['*'] = {
				capabilities = require('blink.cmp').get_lsp_capabilities {
					workspace = {
						fileOperations = {
							didRename = true,
							willRename = true,
						},
					},
				},

				keys = {
					-- default keybinds
					{ '<leader>ss', false },
					{ '<leader>sS', false },
					{ '<leader>cc', false },
					{ '<leader>cC', false },
					-- { ']]', function() Snacks.words.jump(vim.v.count1) end, has = 'documentHighlight', desc = 'Next Reference' },
					-- { '[[', function() Snacks.words.jump(-vim.v.count1) end, has = 'documentHighlight', desc = 'Prev Reference' },
					-- { '<leader>cr', vim.lsp.buf.rename, desc = 'Rename', has = 'rename' },

					{ 'gd', function() Snacks.picker.lsp_definitions() end, has = 'definition', desc = 'Definition' },
					{ 'gD', function() Snacks.picker.lsp_declarations() end, desc = 'Declaration' },
					{ 'gr', function() Snacks.picker.lsp_references() end, nowait = true, desc = 'References' },
					{ 'gI', function() Snacks.picker.lsp_implementations() end, desc = 'Implementation' },
					{ 'gy', function() Snacks.picker.lsp_type_definitions() end, desc = 'T[y]pe Definition' },

					{ 'K', function() vim.lsp.buf.hover { max_width = DOC_WIN_SIZE, max_height = DOC_WIN_SIZE } end, has = 'hover', desc = 'Hover', mode = { 'n', 'v' } },
					{ 'gK', function() vim.lsp.buf.signature_help { max_width = DOC_WIN_SIZE, max_height = DOC_WIN_SIZE } end, has = 'signatureHelp', desc = 'Signature Help' },

					{ '<a-n>', function() Snacks.words.jump(vim.v.count1, true) end, desc = 'Next Reference', enabled = function() return require('snacks.words').is_enabled() end },
					{ '<a-p>', function() Snacks.words.jump(-vim.v.count1, true) end, desc = 'Prev Reference', enabled = function() return require('snacks.words').is_enabled() end },

					{ '<c-a-k>', function() return vim.lsp.buf.signature_help { max_width = DOC_WIN_SIZE, max_height = DOC_WIN_SIZE } end, mode = 'i', desc = 'Signature Help', has = 'signatureHelp' },
					{ '<a-s-o>', LazyVim.lsp.action['source.organizeImports'], has = 'organizeImports', desc = 'Organize Imports' },

					{ '🔥', vim.lsp.buf.code_action, mode = { 'n', 'v', 'i' }, has = 'codeAction', desc = 'Code actions' },
					{ '<c-.>', vim.lsp.buf.code_action, mode = { 'n', 'v', 'i' }, has = 'codeAction', desc = 'Code actions' },

					{ '<leader>ca', vim.lsp.buf.code_action, desc = 'Code Action', mode = { 'n', 'x' }, has = 'codeAction' },
					{ '<leader>cA', LazyVim.lsp.action.source, desc = 'Source Action', has = 'codeAction' },
					{ '<leader>fr', function() Snacks.rename.rename_file() end, desc = 'Rename File', mode = 'n', has = { 'workspace/didRenameFiles', 'workspace/willRenameFiles' } },
					{ '<leader>cr', function() require('live-rename').rename() end, has = 'rename', desc = 'Rename Symbol' },
					{ '<a-r>', function() require('live-rename').rename() end, mode = { 'n', 'i' }, has = 'rename', desc = 'Rename Symbol' },
					{ '<leader>cc', vim.lsp.codelens.run, desc = 'Run Codelens', mode = { 'n', 'x' }, has = 'codeLens' },
					{ '<leader>cC', vim.lsp.codelens.refresh, desc = 'Refresh & Display Codelens', mode = { 'n' }, has = 'codeLens' },
				},
			},

			html = true,
			biome = true,

			mdx_analyzer = true,

			emmet_language_server = {
				filetypes = { 'html', 'javascriptreact', 'typescriptreact', 'htmlangular', 'vue' },
			},

			tailwindcss = true,

			somesass_ls = true,
			css_variables = true,
			cssls = {
				init_options = { provideFormatter = false },
			},

			tsgo = {
				enabled = true,
				settings = {
					codelens = true,
				},
			},
			vtsls = {
				enabled = false,
				settings = {
					codelens = true,
				},
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
			-- For example: tsserver = function(_, opts) require('typescript').setup({ server = opts }); return true end,
			-- Specify * to use this function as a fallback for any server
			tsgo = function(_, opts) opts.on_attach = twoslash_queries_attach_fn end,
			vtsls = function(_, opts) opts.on_attach = twoslash_queries_attach_fn end,
			denols = function(_, opts) opts.on_attach = twoslash_queries_attach_fn end,
		},
	},
}
