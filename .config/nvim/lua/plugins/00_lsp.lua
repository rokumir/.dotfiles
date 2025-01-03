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

			---@type table<string, lspconfig.Config | {}>
			servers = {
				rust_analyzer = {},
				emmet_ls = {},
				html = {},
				gopls = {},
				pyright = {},

				denols = {
					enabled = false,
					root_dir = require('lspconfig').util.root_pattern('deno.json', 'deno.jsonc', 'deno.lock'),
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

				tailwindcss = {
					settings = {
						tailwindCSS = {
							-- classAttributes = { 'class', 'classess', 'className', 'class:list', 'classList', 'ngClass' },
							experimental = {
								classRegex = {
									{ 'cva\\(([^)]*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
									{ 'cx\\(([^)]*)\\)', "(?:'|\"|`)([^']*)(?:'|\"|`)" },
									{ 'cn\\(([^)]*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
								},
							},
						},
					},
				},

				markdown_oxide = {
					workspace = {
						didChangeWatchedFiles = {
							dynamicRegistration = true,
						},
					},
				},

				eslint = {
					settings = {
						-- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
						workingDirectories = { mode = 'auto' },
					},
				},

				vtsls = {
					init_options = {
						preferences = {
							importModuleSpecifierPreference = 'non-relative',
						},
					},

					on_attach = function(client, bufnr) require('twoslash-queries').attach(client, bufnr) end,

					settings = {
						typescript = {
							inlayHints = {
								parameterNames = { enabled = 'literal' },
								propertyDeclarationTypes = { enabled = true },
								functionLikeReturnTypes = { enabled = false },
								enumMemberValues = { enabled = true },
							},
						},
					},
				},

				cssls = {
					settings = {
						css = { validate = true, lint = { unknownAtRules = 'ignore' } },
						scss = { validate = true, lint = { unknownAtRules = 'ignore' } },
						less = { validate = true, lint = { unknownAtRules = 'ignore' } },
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

					-- lazy-load schemastore when needed
					on_new_config = function(new_config)
						---@diagnostic disable-next-line: no-unknown
						new_config.settings.yaml.schemas =
							vim.tbl_deep_extend('force', new_config.settings.yaml.schemas or {}, require('schemastore').yaml.schemas())
					end,
					settings = {
						redhat = { telemetry = { enabled = false } },
						yaml = {
							keyOrdering = false,
							validate = true,
							schemaStore = {
								enable = false, -- Must disable built-in schemaStore support to use schemas from SchemaStore.nvim plugin
								url = '', -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
							},
						},
					},
				},
				jsonls = {
					-- lazy-load schemastore when needed
					on_new_config = function(new_config)
						new_config.settings.json.schemas = new_config.settings.json.schemas or {}
						vim.list_extend(new_config.settings.json.schemas, require('schemastore').json.schemas())
					end,
					settings = {
						json = {
							format = { enable = true },
							validate = { enable = true },
						},
					},
				},

				lua_ls = {
					single_file_support = true,
					settings = {
						Lua = {
							runtime = { version = 'Lua 5.4' },
							workspace = { checkThirdParty = false },
							doc = { privateName = { '^_' } },
							type = { castNumberToInteger = true },
							completion = {
								workspaceWord = true,
								callSnippet = 'Both',
							},
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = 'Disable',
								semicolon = 'Disable',
								arrayIndex = 'Disable',
							},
							diagnostics = {
								disable = { 'incomplete-signature-doc', 'trailing-space' },
								-- enable = false,
								groupSeverity = {
									strong = 'Warning',
									strict = 'Warning',
								},
								groupFileStatus = {
									ambiguity = 'Opened',
									await = 'Opened',
									codestyle = 'None',
									duplicate = 'Opened',
									global = 'Opened',
									luadoc = 'Opened',
									redefined = 'Opened',
									strict = 'Opened',
									strong = 'Opened',
									unbalanced = 'Opened',
									unused = 'Opened',
									['type-check'] = 'Opened',
								},
								unusedLocalExclude = { '_*' },
								globals = { 'vim', 'it', 'describe', 'before_each', 'after_each' },
							},
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
			vim.list_extend(require('lazyvim.plugins.lsp.keymaps').get(), {
				{ 'K', require('noice.lsp').hover, desc = 'Hover' },
				{ '<c-u>', function() require('noice.lsp').scroll(-4) end, has = 'documentHighlight', mode = { 'n', 'i' }, desc = 'Scroll Up LSP Docs' },
				{ '<c-d>', function() require('noice.lsp').scroll(4) end, has = 'documentHighlight', mode = { 'n', 'i' }, desc = 'Scroll Down LSP Docs' },
				{ '<c-k>', false, mode = 'i' },
				{ '<c-a-k>', require('noice.lsp').signature, mode = 'i', desc = 'Signature Help', has = 'signatureHelp' },
				{ 'gK', require('noice.lsp').signature, desc = 'Signature Help', has = 'signatureHelp' },
				{ '<a-s-o>', LazyVim.lsp.action['source.organizeImports'], desc = 'Organize Imports', has = 'organizeImports' },
				{
					'🔥', -- map unicode to ctrl+period
					function() require('fzf-lua').lsp_code_actions { winopts = { height = 0.4, width = 0.6 } } end,
					mode = { 'n', 'v', 'i' },
					desc = 'Code actions',
					has = 'codeAction',
				},
				{ '<leader>cr', function() require('live-rename').rename { insert = true } end, desc = 'Rename', has = 'rename' },
			})
		end,
	},
}
