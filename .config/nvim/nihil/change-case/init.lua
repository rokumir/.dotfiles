-- TODO: implement this

local M = {}

local recognized_separators = {
	[' '] = true,
	['-'] = true,
	['_'] = true,
	['.'] = true,
	['/'] = true,
}

--- Checks if a string uses only unicase characters.
--- A unicase character is a character that is neither upper nor lower case,
--- e.g., punctuation or Japanese kanji.
---@param str string The string to check
M.is_unicase = function(str) return vim.fn.toupper(str) == vim.fn.tolower(str) end

--- Checks if a char is in upper case.
---@param char string The char to check.
M.is_upper = function(char) return not M.is_unicase(char) and vim.fn.toupper(char) == char end

--- Checks if a char is in lower case.
---@param char string The char to check.
M.is_lower = function(char) return not M.is_unicase(char) and not M.is_upper(char) end

--- Splits a string into a list of Unicode graphemes.
--- Includes combining characters into a single grapheme.
---@param str string The string to split.
M.str2graphemelist = function(str)
	local charlist = {} ---@type table<string>
	local stridx = 0
	while stridx < string.len(str) do
		local current_charidx = vim.fn.charidx(str, stridx)
		local charend = 1
		while stridx + charend < string.len(str) do
			local next_charidx = vim.fn.charidx(str, stridx + charend)
			if current_charidx ~= next_charidx then break end
			charend = charend + 1
		end
		table.insert(charlist, string.sub(str, stridx + 1, stridx + charend))
		stridx = stridx + charend
	end
	return charlist
end

--- Splits a word into its parts.
--- Using ”keyword” instead of “word”, because in this context, things like like
--- “kebab-case” are not words.
---@param str string The word to split.
M.split_keyword = function(str)
	local grapheme_list = M.str2graphemelist(str)
	if #grapheme_list <= 2 then return { str } end

	local found_separator = nil ---@type string|nil

	local words = {}

	for i = 1, #grapheme_list, 1 do
		if recognized_separators[grapheme_list[i]] then
			found_separator = grapheme_list[i] ---@type string|nil
			break
		end
	end

	if found_separator then
		local word = ''
		for i = 1, #grapheme_list, 1 do
			if grapheme_list[i] == found_separator then
				table.insert(words, word)
				word = ''
			else
				word = word .. grapheme_list[i] ---@type string
			end
		end
		if word ~= '' then table.insert(words, word) end
	else
		-- No separator found. Separate by upper case.
		local word = ''
		for i = 1, #grapheme_list, 1 do
			if M.is_upper(grapheme_list[i]) then
				if word ~= '' then table.insert(words, word) end
				word = grapheme_list[i] ---@type string|nil
			else
				word = word .. grapheme_list[i] ---@type string
			end
		end
		if word ~= '' then table.insert(words, word) end
	end

	words = vim.tbl_map(vim.fn.tolower, words)

	return words
end

local function cs_split(str)
	local parts = vim.split(str, '%s+')
	return table.concat(parts, ' ')
end

local function cs_get_current_word() return vim.fn.expand '<cword>' end

local function cs_get_selected_str()
	local vstart = vim.fn.getpos "'<"
	local vend = vim.fn.getpos "'>"

	local line_start = vstart[2]
	local line_end = vend[2]

	-- or use api.nvim_buf_get_lines
	return vim.fn.getline(line_start, line_end)
end

return M
