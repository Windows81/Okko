-- Takes in a list of 2-lists, where [1] is a class and [2] is a table of constructor args.
-- Returns a function that makes an instance of a randomly-selected class from that which we passed in.
return function(options: {{new: (...any)->({})}}): ()->{}
	local option = options[math.random(#options)]
	return function() return option[1].new(unpack(option[2]))
	end
end