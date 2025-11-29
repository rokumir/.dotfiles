local M = {}

M.obsidian = {}
M.obsidian.util = {}

---@param obsidian_note_util obsidian.Note
---@param item snacks.picker.finder.Item
function M.obsidian.util.snacks_note_transform(obsidian_note_util, item)
	vim.defer_fn(function()
		local note = obsidian_note_util.from_file(item.file, { collect_anchor_links = false, collect_blocks = false, load_contents = false, max_lines = 100 })
		if not note.has_frontmatter then return end

		item.has_frontmatter = note.has_frontmatter
		item.icon = note.metadata.icon or nil
		item.title = type(note.metadata.title) == 'string' and note.metadata.title or note.aliases[1] or nil
		item.aliases = #note.aliases > 0 and table.concat(note.aliases, '') or nil
		item.tags = #note.tags > 0 and table.concat(note.tags, '') or nil
		item.text = Snacks.picker.util.text(item, { 'title', 'tags', 'aliases' })
	end, 0)
end

---@param picker snacks.Picker
---@param item snacks.picker.Item
function M.obsidian.util.snacks_note_format(item, picker)
	if not item.has_frontmatter then return require('snacks.picker.format').filename(item, picker) end

	local ret = {}
	local sep = { ' ' }

	local ft_icon = Snacks.picker.util.align(item.icon or '󰍔', 3)
	table.insert(ret, { ft_icon, 'SnacksPickerIcon', virtual = true })

	if item.title then
		vim.list_extend(ret, {
			{ item.title, 'SnacksPickerFile', field = 'file' },
			sep,
			{ item.file, 'SnacksPickerDir', field = 'file' },
		})
	else
		local base_filename = vim.fn.fnamemodify(item.file, ':t')
		vim.list_extend(ret, {
			{ base_filename, 'SnacksPickerFile', field = 'file' },
			sep,
			{ item.file:gsub('/' .. base_filename, ''), 'SnacksPickerDir', field = 'file' },
		})
	end

	-- if item.tags then vim.list_extend(ret, { sep, { item.tags, 'SnacksPickerDir', field = 'tags' }, }) end
	-- if item.aliases then vim.list_extend(ret, { sep, { item.aliases, 'SnacksPickerDir', field = 'aliases' }, }) end

	return ret
end

function M.obsidian.quick_switcher()
	local obsidian_exist, obsidian_note_util = pcall(require, 'obsidian.note')
	if not obsidian_exist then error '**[Obsidian.nvim]** plugin not found!' end

	Snacks.picker.files {
		source = 'markdown_notes_quick_switcher',
		title = '󱀂 Notes',
		layout = 'vscode_focus',
		ft = { 'markdown', 'mdx', 'md' },
		transform = function(item) return M.obsidian.util.snacks_note_transform(obsidian_note_util, item) end,
		format = M.obsidian.util.snacks_note_format,
	}
end

return M
