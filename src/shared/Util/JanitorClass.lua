local ObjectOrientate = require(script.Parent.ObjectOrientate)
local Janitor = require(script.Parent.Parent.Janitor)
local class = ObjectOrientate()

function class:init()
	self.Janitor = Janitor.new()
end

function class:destroy()
	self.Janitor:Cleanup()
end

return class