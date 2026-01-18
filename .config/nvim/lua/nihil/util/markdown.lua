local M = {}

--------------------------------------------------------------
M.obsidian = {}
M.obsidian.util = {}

function M.obsidian.quick_switcher()
	Snacks.picker.files {
		source = 'markdown_notes_quick_switcher',
		title = '󱀂 Notes',
		layout = 'vscode_focus',
		ft = { 'markdown', 'mdx', 'md' },
		transform = M.obsidian.util.snacks_note_transform,
		format = M.obsidian.util.snacks_note_format,
	}
end

function M.obsidian.new_from_template()
	local Util = require 'obsidian.util'
	local Note = require 'obsidian.note'

	local templates_dir = require('obsidian.api').templates_dir()
	if not templates_dir then return Snacks.notify.error 'Templates folder is not defined or does not exist' end

	Snacks.picker.files {
		title = 'Templates',
		layout = 'select_extra_small',
		format = function(item) return { { vim.fn.fnamemodify(item.text, ':t:r') } } end,
		dirs = { tostring(templates_dir) },
		confirm = function(picker, item)
			if not item then return end
			picker:close()

			local template_name = item._path ---@type string

			M.obsidian.util.select_dir(function(choice)
				if not choice then return end
				local success, safe_title = pcall(Util.input, 'Enter title or path (optional): ', {
					completion = 'file',
				})
				if not success or not safe_title then return Snacks.notify.warn 'Aborted' end

				local dir = choice.text
				local id, path = Note._resolve_id_path { dir = dir } ---@diagnostic disable-line: invisible

				local note = Note.new(id, { safe_title }, {}, path)
				note:add_field('title', safe_title)
				note:write { template = template_name }
				note:open { sync = false }
			end)
		end,
	}
end

function M.obsidian.toc()
	local cwd = LazyVim.root.cwd()
	vim.lsp.buf.document_symbol {
		on_list = function(t)
			Snacks.picker.pick {
				items = t.items,
				layout = 'ivy',
				transform = function(item)
					item.file =
						svim.fs.normalize(item.filename, { _fast = true, expand_env = false }):gsub('^' .. cwd .. '/', '')

					local title_text = item.text:gsub('^%[File%]%s*', '')
					local hashes, title = title_text:match '^(#+)%s*(.*)$'
					item.level = #hashes
					item.title = title

					item.pos = { item.end_lnum, 0 }
					item.end_pos = { item.end_lnum, #title_text }
				end,
				format = function(item)
					local a = Snacks.picker.util.align
					local ret = {}
					local hl = 'markdownH' .. item.level
					ret[#ret + 1] = { a('H' .. item.level, 3), hl }
					ret[#ret + 1] = { ' ' }
					ret[#ret + 1] = { item.title, hl }
					ret[#ret + 1] = { ':' .. item.end_pos[1] .. ':' .. item.end_pos[2], 'SnacksPickerComment' }
					return ret
				end,
				confirm = 'jump',
			}
		end,
	}
end

---@param callback fun(choice?:snacks.picker.Item)
function M.obsidian.util.select_dir(callback)
	Snacks.picker {
		title = 'Pick a Directory',
		layout = 'select_extra_small',
		confirm = function(picker, item)
			picker:close()
			callback(item)
		end,
		format = function(item) return { { vim.fs.basename(item.text:gsub('/+$', '')), 'SnacksPickerDirectory' } } end,
		finder = function(_, ctx)
			local opts = ctx:opts {
				cmd = 'fd',
				args = { '--no-hidden', '--follow', '--absolute-path', '--type', 'directory', '--max-depth', '1' },
			}
			return require('snacks.picker.source.proc').proc(opts, ctx)
		end,
	}
end

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

return M
