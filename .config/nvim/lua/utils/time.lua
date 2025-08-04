---@diagnostic disable: cast-local-type
local M = {}

--- Get ordinal suffix for a day (1 → "1st", 2 → "2nd", etc.)
---@param n number
local function ordinal(n)
	local rem100 = n % 100
	if rem100 >= 11 and rem100 <= 13 then return tostring(n) .. 'th' end
	local rem10 = n % 10
	if rem10 == 1 then
		return tostring(n) .. 'st'
	elseif rem10 == 2 then
		return tostring(n) .. 'nd'
	elseif rem10 == 3 then
		return tostring(n) .. 'rd'
	else
		return tostring(n) .. 'th'
	end
end

--- Return something like "Mon, Aug 4th"
function M.pretty_date(t)
	local t = os.date '*t'
	local weekday = os.date('%a', os.time(t))
	local month = os.date('%b', os.time(t))
	return string.format('%s, %s %s', weekday, ordinal(t.day), month)
end

--- Return something like "5:07pm"
function M.pretty_time(t)
	local t = os.date '*t'
	local ampm = t.hour < 12 and 'am' or 'pm'
	return string.format('%d:%02d%s', t.hour, t.min, ampm)
end

return M
