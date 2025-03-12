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

			---@type table<string, lspconfig.Config | {}>
			servers = {
				rust_analyzer = {},
				html = {},
				gopls = {},
				pyright = {},
				markdown_oxide = {},

				biome = {},

				css_variables = {
					filetypes = { 'css', 'scss', 'sass', 'less' },
				},
				emmet_language_server = {
					filetypes = { 'html', 'javascriptreact', 'typescriptreact', 'htmlangular', 'vue' },
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

				eslint = {
					settings = {
						-- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
						workingDirectories = { mode = 'auto' },
					},
				},

				vtsls = {
					enabled = false,
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
				{ 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Goto Definition' },
				{ 'gD', function() Snacks.picker.lsp_declarations() end, desc = 'Goto Declaration' },
				{ 'gr', function() Snacks.picker.lsp_references() end, nowait = true, desc = 'References' },
				{ 'gI', function() Snacks.picker.lsp_implementations() end, desc = 'Goto Implementation' },
				{ 'gy', function() Snacks.picker.lsp_type_definitions() end, desc = 'Goto T[y]pe Definition' },
				{ 'K', require('noice.lsp').hover, desc = 'Hover' },
				{ '<c-u>', function() require('noice.lsp').scroll(-4) end, has = 'documentHighlight', mode = { 'n', 'i' }, desc = 'Scroll Up LSP Docs' },
				{ '<c-d>', function() require('noice.lsp').scroll(4) end, has = 'documentHighlight', mode = { 'n', 'i' }, desc = 'Scroll Down LSP Docs' },
				{ '<c-k>', false, mode = 'i' },
				{ '<c-a-k>', require('noice.lsp').signature, mode = 'i', desc = 'Signature Help', has = 'signatureHelp' },
				{ 'gK', require('noice.lsp').signature, desc = 'Signature Help', has = 'signatureHelp' },
				{ '<leader>cr', function() require('live-rename').rename { insert = true } end, desc = 'Rename', has = 'rename' },
				{
					'<a-s-o>',
					function()
						pcall(LazyVim.lsp.action['source.organizeImports'])
						pcall(vim.cmd.TSToolsOrganizeImports)
					end,
					desc = 'Organize Imports',
					has = 'organizeImports',
				},
				{
					'🔥', -- map unicode to ctrl+period
					vim.lsp.buf.code_action,
					mode = { 'n', 'v', 'i' },
					desc = 'Code actions',
					has = 'codeAction',
				},
			})
		end,
	},

	{
		'pmizio/typescript-tools.nvim',
		opts = {
			handlers = {},
			settings = {
				separate_diagnostic_server = true,
				publish_diagnostic_on = 'insert_leave',
				expose_as_code_action = 'all',

				tsserver_file_preferences = {
					disableSuggestions = false,
					quotePreference = 'single', -- Optional string: "auto", "double", or "single"
					includeCompletionsForModuleExports = true,
					includeCompletionsForImportStatements = true,
					includeCompletionsWithSnippetText = false,
					includeCompletionsWithInsertText = true,
					includeAutomaticOptionalChainCompletions = false,
					includeCompletionsWithClassMemberSnippets = true,
					includeCompletionsWithObjectLiteralMethodSnippets = false,
					useLabelDetailsInCompletionEntries = true,
					allowIncompleteCompletions = false,
					importModuleSpecifierPreference = 'project-relative', -- Optional string: "shortest", "project-relative", "relative", "non-relative"
					importModuleSpecifierEnding = 'auto', -- Optional string: "auto", "minimal", "index", "js"
					allowTextChangesInNewFiles = true,
					lazyConfiguredProjectsFromExternalProject = false,
					providePrefixAndSuffixTextForRename = true,
					provideRefactorNotApplicableReason = false,
					allowRenameOfImportPath = true,
					includePackageJsonAutoImports = 'auto', -- Optional string: "auto", "on", "off"
					jsxAttributeCompletionStyle = 'auto', -- Optional string: "auto", "braces", "none"
					displayPartsForJSDoc = true,
					generateReturnInDocTemplate = false,
					includeInlayParameterNameHints = 'all', -- Optional string: "none", "literals", "all"
					includeInlayParameterNameHintsWhenArgumentMatchesName = true,
					includeInlayFunctionParameterTypeHints = false,
					includeInlayVariableTypeHints = true,
					includeInlayVariableTypeHintsWhenTypeMatchesName = false,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = false,
					includeInlayEnumMemberValueHints = true,

					organizeImportsIgnoreCase = 'auto', -- Optional string or boolean
					organizeImportsCollation = 'ordinal', -- Optional string: "ordinal" or "unicode"
					organizeImportsCollationLocale = 'en', -- Optional string
					organizeImportsNumericCollation = false,
					organizeImportsAccentCollation = true,
					organizeImportsCaseFirst = 'lower', -- Optional string: "upper", "lower", or false
					disableLineTextInReferences = true,
				},

				tsserver_locale = 'en',
				complete_function_calls = true,
				include_completions_with_insert_text = true,
				code_lens = 'off',
				disable_member_code_lens = true,
				jsx_close_tag = { enable = false },
			},

			---@type table<number, KeymapingFunArgs>
			keys = {
				{ '<leader>cM', '<cmd>TSToolsAddMissingImports<cr>', desc = 'Add missing imports' },
				{ '<leader>cD', '<cmd>TSToolsFixAll<cr>', desc = 'Fix all diagnostics' },
				{ '<leader>cR', '<cmd>TSToolsRenameFile<cr>', desc = 'Rename file' },
			},
		},

		config = function(_, opts)
			opts.on_attach = function(client, bufnr)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false

				---@diagnostic disable-next-line: no-unknown
				for _, keymap_args in ipairs(opts.keys) do
					keymap_args.buffer = bufnr
					map_key(keymap_args)
				end
			end

			require('typescript-tools').setup(opts)
		end,
	},
}
