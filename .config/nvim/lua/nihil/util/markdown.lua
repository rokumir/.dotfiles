local M = {}

--------------------------------------------------------------
M.obsidian = {}
M.obsidian.util = {}

---@param item snacks.picker.finder.Item
function M.obsidian.util.snacks_note_transform(item)
	vim.defer_fn(function()
		local note = require('obsidian.note').from_file(item.file, {
			collect_anchor_links = false,
			collect_blocks = false,
			load_contents = false,
			max_lines = 100,
		})
		if not note.has_frontmatter then return end

		item.has_frontmatter = note.has_frontmatter
		item.icon = note.metadata.icon or nil
		item.title = type(note.metadata.title) == 'string' and note.metadata.title or note.aliases[1] or nil
		item.aliases = #note.aliases > 0 and table.concat(note.aliases, '|') or nil
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
	if not Obsidian or not Snacks then error '**[Obsidian.nvim]** plugin not found!' end
	Snacks.picker.files {
		source = 'markdown_notes_quick_switcher',
		title = '󱀂 Notes',
		layout = 'vscode_focus',
		ft = { 'markdown', 'mdx', 'md' },
		transform = M.obsidian.util.snacks_note_transform,
		format = M.obsidian.util.snacks_note_format,
	}
end

function M.obsidian.better_new_from_template()
	local Util = require 'obsidian.util'
	local Note = require 'obsidian.note'

	local templates_dir = require('obsidian.api').templates_dir()
	if not templates_dir then return Snacks.notify.error 'Templates folder is not defined or does not exist' end

	Obsidian.picker.find_files {
		prompt_title = 'Templates',
		dir = templates_dir,
		no_default_mappings = true,
		callback = function(template_name)
			Snacks.picker.select({
				{ text = 'Alas', desc = 'Knowledge' },
				{ text = 'Opus', desc = 'Projects' },
				{ text = 'Journal', desc = 'Daily insights' },
				{ text = '[root]', desc = 'Root' },
			}, {
				prompt = 'Pick a Directory for Note',
				snacks = {
					layout = {
						layout = {
							backdrop = false,
							width = 0.15,
							min_width = 35,
							height = 0.3,
							min_height = 3,
							title = '{title}',
							title_pos = 'center',
							box = 'vertical',
							border = 'rounded',
							{ win = 'input', height = 1, border = 'bottom' },
							{ win = 'list', border = 'none' },
						},
					},
					format = function(_item)
						local item = _item.item
						local ret = {}
						ret[#ret + 1] = { Snacks.picker.util.align(item.text, 12) }
						ret[#ret + 1] = { ' ' }
						ret[#ret + 1] = { item.desc, 'Comment' }
						return ret
					end,
				},
			}, function(choice)
				local dir = choice.text
				if not dir then return Snacks.notify.warn 'Aborted' end
				if dir == '[root]' then dir = nil end

				local success, safe_title = pcall(Util.input, 'Enter title or path (optional): ', { completion = 'file' })
				if not success or not safe_title then return Snacks.notify.warn 'Aborted' end
				if template_name == nil or template_name == '' then return Snacks.notify.warn 'Aborted' end

				Note.create({
					template = template_name,
					should_write = true,
					dir = dir,
				}):open {
					sync = false,
					callback = function(buf)
						if safe_title == '' then return end
						local note = Note.from_buffer(buf)
						note:add_field('title', safe_title)
						note:update_frontmatter(buf)
					end,
				}
			end)
		end,
	}
end

return M
