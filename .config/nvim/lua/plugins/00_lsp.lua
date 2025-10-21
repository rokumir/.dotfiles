local util = require 'lspconfig.util'

pcall(vim.lsp.inline_completion.enable, true)

---@type LazyPluginSpec[]
return {
	{
		'neovim/nvim-lspconfig',
		lazy = false,
		---@class PluginLspOpts
		opts = {
			inlay_hints = { enabled = false },
			codelens = { enabled = false },
			inline_completion = { enabled = true },

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

				zk = {
					name = 'zk',
					cmd = { 'zk', 'lsp' },
					filetypes = { 'markdown' },
					root_dir = vim.env.RH_NOTE or require('lspconfig.util').root_pattern('.git', '.obsidian', '.moxide.toml'),
					on_attach = function()
						require('utils.keymap').map {
							{ '<leader>z', group = 'ZK' },
							{ '<leader>zn', [[<cmd>ZkNew { title = vim.fn.input('Title: ') } <cr>]], desc = 'ZK New Note' },
							{ '<leader>znt', [[<cmd>'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') } <cr>]], mode = 'v', desc = 'ZK New Note in Current Directory' },
							{
								'<leader>znc',
								[[<cmd>'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') } <cr>]],
								mode = 'v',
								desc = 'ZK New Note from Content Selection in Current Directory',
							},

							{ '<leader>zb', '<cmd>ZkBacklinks <cr>', desc = 'ZK Backlinks' },
							{ '<leader>zl', '<cmd>ZkLinks <cr>', desc = 'ZK Links (Notes linked by the current buffer)' },
							{ '<leader>zo', [[<cmd>ZkNotes { sort = { 'modified' } }<cr>]], desc = 'Open notes.' },
							{ '<leader>zt', '<cmd>ZkTags <cr>', desc = 'Open notes associated with the selected tags.' },
							{ '<leader>zf', [[<cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } } <cr>]], desc = 'Search for the notes matching a given query.' },
							{ '<leader>zf', [[<cmd>'<,'>ZkMatch <cr>]], mode = 'v', desc = 'Search for the notes matching the current visual selection.' },
						}
					end,
				},
				mdx_analyzer = {},
				marksman = { enabled = false },
				markdown_oxide = {
					enabled = false,
					cmd = { 'markdown-oxide' },
					filetypes = {},
					root_markers = { '.git', '.obsidian', '.moxide.toml' },
					root_dir = util.root_pattern('.git', '.obsidian', '.moxide.toml'),
				},

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

				tsgo = {},
				vtsls = {},
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
				['*'] = function(_, opts) opts.capabilities = require('blink.cmp').get_lsp_capabilities(opts.capabilities) end,
			},
		},
	},
	{
		'neovim/nvim-lspconfig',
		---@param opts PluginLspOpts
		opts = function(_, opts)
			local doc_win_size = vim.g.lsp_doc_max_size or 50
			vim.list_extend(require('lazyvim.plugins.lsp.keymaps').get(), {
				{ '<leader>ss', false },
				{ '<leader>sS', false },
				{ 'gd', function() Snacks.picker.lsp_definitions() end, has = 'definition', desc = 'Definition' },
				{ 'gD', function() Snacks.picker.lsp_declarations() end, desc = 'Declaration' },
				{ 'gr', function() Snacks.picker.lsp_references() end, nowait = true, desc = 'References' },
				{ 'gI', function() Snacks.picker.lsp_implementations() end, desc = 'Implementation' },
				{ 'gy', function() Snacks.picker.lsp_type_definitions() end, desc = 'T[y]pe Definition' },
				{ 'K', function() vim.lsp.buf.hover { max_width = doc_win_size, max_height = doc_win_size } end, has = 'hover', desc = 'Hover', mode = { 'n', 'v' } },
				{ '<c-k>', false, mode = 'i', has = 'signatureHelp' },
				{ 'gK', function() vim.lsp.buf.signature_help { max_width = doc_win_size, max_height = doc_win_size } end, has = 'signatureHelp', desc = 'Signature Help' },
				{ '<a-r>', function() require('live-rename').rename() end, mode = { 'n', 'i' }, has = 'rename', desc = 'Rename Symbol' },
				{ '<leader>cr', function() require('live-rename').rename() end, has = 'rename', desc = 'Rename Symbol' },
				{ '<a-s-o>', LazyVim.lsp.action['source.organizeImports'], has = 'organizeImports', desc = 'Organize Imports' },
				{ '🔥', vim.lsp.buf.code_action, mode = { 'n', 'v', 'i' }, has = 'codeAction', desc = 'Code actions' },
				{ '<c-.>', vim.lsp.buf.code_action, mode = { 'n', 'v', 'i' }, has = 'codeAction', desc = 'Code actions' },
				{ '<c-s-y>', function() vim.lsp.inline_completion.get() end, mode = 'i', desc = 'Accept Inline Suggestion' },
			})

			-- Attach Twoslash Querries plugin to Typescript LSP servers
			for _, server in ipairs { 'tsgo', 'vtsls', 'denols' } do
				opts.servers[server].on_attach = function(client, bufnr) require('twoslash-queries').attach(client, bufnr) end
			end
		end,
	},
}
