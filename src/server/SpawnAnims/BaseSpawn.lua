local ReplStor = game:GetService('ReplicatedStorage')
local ObjectOrientate = require(ReplStor.Shared.Util.ObjectOrientate)
local Janitor = require(ReplStor.Shared.Janitor)
local class = ObjectOrientate()

function class:init()
	self.Janitor = Janitor.new()
end

function class:destroy()
	self.Janitor:Cleanup()
end

function class:perform(obj: Model, cframe: CFrame): nil
	obj:SetPrimaryPartCFrame(cframe)
end

return class