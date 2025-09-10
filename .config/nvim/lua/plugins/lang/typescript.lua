local key_set = require('utils.keymap').map

---@module 'lazy'
---@type LazyPluginSpec[]
return {
	{ -- better ts error ui
		'OlegGulevskyy/better-ts-errors.nvim',
		priority = 1000,
		ft = { 'typescript', 'typescriptreact' },
		opts = {
			keymaps = {
				toggle = '<leader>cT',
				go_to_definition = '<leader>ct',
			},
		},
	},

	{ -- Typescript type debug
		'marilari88/twoslash-queries.nvim',
		priority = 1000,
		ft = { 'typescript', 'typescriptreact' },
		opts = {
			multi_line = true,
			is_enabled = true,
			highlight = 'Comment',
		},
	},

	{ -- lsp
		'pmizio/typescript-tools.nvim',
		cond = false,
		ft = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
		opts = {
			handlers = {},

			settings = {
				separate_diagnostic_server = true,
				publish_diagnostic_on = 'insert_leave',
				expose_as_code_action = 'all',

				tsserver_file_preferences = {
					disableSuggestions = not require('utils.root-dir').validate_func {
						'package.json',
						'node_modules',
						'*.lock',
					}(),
					quotePreference = 'single', --= auto, double, or single
					includeCompletionsForModuleExports = true,
					includeCompletionsForImportStatements = true,
					includeCompletionsWithSnippetText = false,
					includeCompletionsWithInsertText = true,
					includeAutomaticOptionalChainCompletions = false,
					includeCompletionsWithClassMemberSnippets = true,
					includeCompletionsWithObjectLiteralMethodSnippets = false,
					useLabelDetailsInCompletionEntries = true,
					allowIncompleteCompletions = false,
					importModuleSpecifierPreference = 'project-relative', --= shortest, project-relative, relative, non-relative
					importModuleSpecifierEnding = 'auto', --= auto, minimal, index, js
					allowTextChangesInNewFiles = true,
					lazyConfiguredProjectsFromExternalProject = false,
					providePrefixAndSuffixTextForRename = true,
					provideRefactorNotApplicableReason = false,
					allowRenameOfImportPath = true,
					includePackageJsonAutoImports = 'auto', --= auto, on, off
					jsxAttributeCompletionStyle = 'auto', --= auto, braces, none
					displayPartsForJSDoc = true,
					generateReturnInDocTemplate = false,
					includeInlayParameterNameHints = 'all', --= none, literals, all
					includeInlayParameterNameHintsWhenArgumentMatchesName = true,
					includeInlayFunctionParameterTypeHints = false,
					includeInlayVariableTypeHints = true,
					includeInlayVariableTypeHintsWhenTypeMatchesName = false,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = false,
					includeInlayEnumMemberValueHints = true,

					organizeImportsIgnoreCase = 'auto', -- {string} or {boolean}
					organizeImportsCollation = 'ordinal', --= ordinal or unicode
					organizeImportsCollationLocale = 'en',
					organizeImportsNumericCollation = false,
					organizeImportsAccentCollation = true,
					organizeImportsCaseFirst = 'lower', -- upper, "lower", or false
					disableLineTextInReferences = true,
				},

				tsserver_locale = 'en',
				complete_function_calls = true,
				include_completions_with_insert_text = true,
				code_lens = 'off',
				disable_member_code_lens = true,
				jsx_close_tag = { enable = false },
			},

			on_attach = function(client, bufnr)
				---@type table<number, KeymapingFunArgs>
				local keymaps = {
					{ '<leader>cM', '<cmd>TSToolsAddMissingImports<cr>', desc = 'TSTools: Add missing imports' },
					{ '<leader>cD', '<cmd>TSToolsFixAll<cr>', desc = 'TSTools: Fix all diagnostics' },
					{ '<leader>cR', '<cmd>TSToolsRenameFile<cr>', desc = 'TSTools: Rename file' },
				}
				for _, keymap_args in ipairs(keymaps) do
					keymap_args.buffer = bufnr
					key_set(keymap_args)
				end

				-- plugins
				require('twoslash-queries').attach(client, bufnr)

				-- extra settings
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end,
		},
	},
}
