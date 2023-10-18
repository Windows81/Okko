local ObjectOrientate = require(script.Parent.ObjectOrientate)
local Janitor = require(script.Parent.Parent.Janitor)
local JanitorClass = ObjectOrientate()

function JanitorClass:init()
	self.Janitor = Janitor.new()
end

function JanitorClass:destroy()
	self.Janitor:Cleanup()
end

return JanitorClass