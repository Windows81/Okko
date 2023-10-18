local ReplStor = game:GetService('ReplicatedStorage')
local ObjectOrientate = require(ReplStor.Shared.Util.ObjectOrientate)
local JanitorClass = require(ReplStor.Shared.Util.JanitorClass)
local BaseSpawn = ObjectOrientate(JanitorClass)

function BaseSpawn:perform(obj: Model, cframe: CFrame): nil
	obj:SetPrimaryPartCFrame(cframe)
end

return BaseSpawn