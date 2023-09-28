-- VisualPlugin made this snippet, as lightweight as it is, specifically for the evaluation place for Suit Up Games.

-- Variable-argument length for the method-resolution order of parent classes.
return function(...)
	local class = {}
	local parents = {...}
	for i = #parents, 1, -1 do
		for key, method in parents[i] do
			class[key] = method
		end
	end

	class.init = class.init or function(...) end
	class.__index = class

	-- Each class we make has an implicit 'new' method which then calls its respective 'init' method.
	class.new = function(...)
		local self = {}
		setmetatable(self, class)
		self:init(...)
		return self
	end

	return class :: typeof(class)
end