local ReplStor = game:GetService('ReplicatedStorage')
local ObjectOrientate = require(ReplStor.Shared.Util.ObjectOrientate)
local RemoteTween = require(script.Parent.Parent.Knit.RemoteTween)
local BaseSpawn = require(script.Parent.BaseSpawn)
local class = ObjectOrientate(BaseSpawn)

function class:perform(char: Model, cframe: CFrame): nil
	local root_part = char:FindFirstChild('HumanoidRootPart')
	root_part.Anchored = true
	local angle = 2 * math.random() * math.pi
	local x, z = math.sin(angle), math.cos(angle)
	char:SetPrimaryPartCFrame(
		cframe *
		CFrame.Angles(0, math.pi, 0) +
		1e2 * Vector3.new(x, 1, z)
	)
	RemoteTween:FireAllClients(
		root_part,
		TweenInfo.new(7),
		{
			CFrame = cframe,
		},
		true
	)
	task.wait()
	root_part.Anchored = false
end

return class