local ReplStor = game:GetService('ReplicatedStorage')
local ObjectOrientate = require(ReplStor.Shared.Util.ObjectOrientate)
local JanitorClass = require(ReplStor.Shared.Util.JanitorClass)
local class = ObjectOrientate(JanitorClass)

function class:perform(obj: Model, cframe: CFrame): nil
	obj:SetPrimaryPartCFrame(cframe)
	task.wait(1)
end

return class