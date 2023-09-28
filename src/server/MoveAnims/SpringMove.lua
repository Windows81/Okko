local ReplStor = game:GetService('ReplicatedStorage')
local ObjectOrientate = require(ReplStor.Shared.Util.ObjectOrientate)
local Janitor = require(ReplStor.Shared.Janitor)
local class = ObjectOrientate()

function class:init()
end

function class:perform(obj: Model, cframe: CFrame): typeof(Janitor.new())
	obj:SetPrimaryPartCFrame(cframe)
	return Janitor.new()
end

return class