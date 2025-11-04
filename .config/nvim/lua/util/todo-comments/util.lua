---@diagnostic disable: missing-fields
local M = {}

local cmp_items = {} ---@type blink.cmp.CompletionItem[]
function M.get_todo_comments_cmp_items()
	if #cmp_items == 0 then
		local ok, tc = pcall(require, 'todo-comments.config')
		if not ok then return {} end

		for type, config in pairs(tc.options.keywords or {}) do
			local variants = vim.list_extend({ type }, config.alt or {})
			for _, variant in ipairs(variants) do
				---@type blink.cmp.CompletionItem
				local item = {
					label = variant,
					insertText = variant .. ': ',
					source_id = 'todo_comments',
					source_name = 'todo_comments',
					labelDetails = { description = ' ' .. type .. ' [todo]' },
					kind = vim.lsp.protocol.CompletionItemKind.Snippet,
					kind_hl = 'TodoFg' .. type,
					kind_icon = config.icon or '',
					kind_name = 'TodoComment' .. type,
					filterText = 'todo_' .. variant,
					sortText = 'todo_' .. type,
					insertTextMode = 2,
				}
				table.insert(cmp_items, item)
			end
		end
	end

	return cmp_items
end

local ts_reject_nodes = {
	comment = true,
	line_comment = true,
	block_comment = true,
	comment_content = true,
	doc = true,
	doc_comment = true,
}
--- Check if the treesitter context is not a comment (if detectable)
---@return boolean
function M.should_show_items()
	local row, column = unpack(vim.api.nvim_win_get_cursor(0))
	local node = vim.treesitter.get_node {
		bufnr = 0,
		pos = { row - 1, math.max(0, column - 1) }, -- seems to be necessary...
	}
	return node ~= nil and ts_reject_nodes[node:type()]
end

return M
