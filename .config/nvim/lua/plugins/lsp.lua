return { -- lsp servers
	'neovim/nvim-lspconfig',
	opts = function(_, opts)
		opts = vim.tbl_deep_extend('force', {}, opts, {
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

			capabilities = {}, -- add any global capabilities here

			---@type lspconfig.options
			servers = {
				rust_analyzer = {},
				emmet_ls = {},
				html = {},
				gopls = {},
				pyright = {},
				prismals = {},
				tailwindcss = {},
				astro = {},

				markdown_oxide = {
					workspace = {
						didChangeWatchedFiles = {
							dynamicRegistration = true,
						},
					},
				},

				-- TODO: add eslint (https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/linting/eslint.lua)
				eslint = {
					settings = {
						-- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
						workingDirectories = { mode = 'auto' },
					},
				},

				tsserver = {
					single_file_support = false,
					root_dir = function(...) return require('lspconfig.util').root_pattern('tsconfig.json', 'jsconfig.json', 'package.json', '.git')(...) end,
					init_options = {
						preferences = {
							importModuleSpecifierPreference = 'non-relative',
						},
					},

					on_attach = function(client, bufnr) require('twoslash-queries').attach(client, bufnr) end,

					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = 'literal',
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = false,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
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
									['ambiguity'] = 'Opened',
									['await'] = 'Opened',
									['codestyle'] = 'None',
									['duplicate'] = 'Opened',
									['global'] = 'Opened',
									['luadoc'] = 'Opened',
									['redefined'] = 'Opened',
									['strict'] = 'Opened',
									['strong'] = 'Opened',
									['type-check'] = 'Opened',
									['unbalanced'] = 'Opened',
									['unused'] = 'Opened',
								},
								unusedLocalExclude = { '_*' },
								globals = { 'vim', 'it', 'describe', 'before_each', 'after_each' },
							},
						},
					},
				},
			},

			keymaps = {
				{
					'🔥', -- use unicode to map unique keymap
					function() require('fzf-lua').lsp_code_actions { winopts = { height = 0.4, width = 0.6 } } end,
					mode = { 'n', 'v', 'i' },
					desc = 'Code actions',
					has = 'codeAction',
				},
			},
		})

		local lsp_maps = require('lazyvim.plugins.lsp.keymaps').get()
		for _, keymap in ipairs(opts.keymaps) do
			lsp_maps[#lsp_maps + 1] = keymap
		end

		return opts
	end,
}
