-- Takes in a list of 2-lists, where [1] is a class and [2] is a table of constructor args.
-- Returns a randomly-selected instance of one of the classes we passed in that is constructed using the args we also provided.
return function(options: {{new: (...any)->({})}}): {}
	local option = options[math.random(#options)]
	return option[1].new(unpack(option[2]))
end