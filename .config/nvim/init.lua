require 'config.lazy'
require 'nihil.lazy'

local function foo(num) return 'foo' .. num, 'bar' .. num, 'nyom' .. num end

_G.nihil = {
	foo(1),
	foo(2),
	foo(3),
}
