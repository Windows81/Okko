-- VisualPlugin made this snippet, as lightweight as it is, specifically for the evaluation place for Suit Up Games.

-- Variable-argument length for the method-resolution order of parent classes.
return function(...)
	local new_class = {}
	local parents = {...}
	for i = #parents, 1, -1 do
		for key, method in parents[i] do
			new_class[key] = method
		end
	end

	new_class.init = new_class.init or function(...) end
	new_class.__index = new_class

	-- Each class we make has an implicit 'new' method which then calls its respective 'init' method.
	new_class.new = function(...)
		local self = {}
		setmetatable(self, new_class)
		self:init(...)
		return self
	end

	return new_class :: typeof(new_class)
end