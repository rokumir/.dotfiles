local map = require('nihil.keymap').map
local function perform(cmd) ---@param cmd string
	local args = { command = 'typescript.' .. cmd, arguments = { vim.api.nvim_buf_get_name(0) }, title = '' }
	return function() vim.lsp.buf.execute_command(args) end
end

return {
	{
		'neovim/nvim-lspconfig',
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

				vtsls = {
					init_options = {
						preferences = {
							importModuleSpecifierPreference = 'non-relative',
						},
					},

					on_attach = function(client, bufnr)
						map { '<a-s-o>', ':VtsOrganizeImports <cr>', buffer = bufnr, desc = 'VTS Organize Imports' }
						require('twoslash-queries').attach(client, bufnr)
					end,

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

					commands = {
						VtsOrganizeImports = { perform 'organizeImports', description = 'Organize Imports' },
						VtsRestartServer = { perform 'restartTsServer', description = 'Restart TS Server' },
						VtsReloadProjects = { perform 'reloadProjects', description = 'Reload Projects' },
						VtsSelectTypeScriptVersion = { perform 'selectTypeScriptVersion', description = 'Select TypeScript Version' },
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

			---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
			setup = {
				-- example to setup with typescript.nvim
				-- tsserver = function(_, opts)
				--   require("typescript").setup({ server = opts })
				--   return true
				-- end,
				-- Specify * to use this function as a fallback for any server
				-- ["*"] = function(server, opts) end,
			},
		},
	},

	{
		'neovim/nvim-lspconfig',
		opts = function()
			vim.list_extend(require('lazyvim.plugins.lsp.keymaps').get(), {
				{
					'🔥', -- use unicode to map unique keymap
					function() require('fzf-lua').lsp_code_actions { winopts = { height = 0.4, width = 0.6 } } end,
					mode = { 'n', 'v', 'i' },
					desc = 'Code actions',
					has = 'codeAction',
				},
			})
		end,
	},
}
