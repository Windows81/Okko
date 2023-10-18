local ReplStor = game:GetService('ReplicatedStorage')
local ObjectOrientate = require(ReplStor.Shared.Util.ObjectOrientate)
local EasyClientTween = require(ReplStor.Shared.EasyClientTween)
local BaseSpawn = require(script.Parent.BaseSpawn)
local FallSpawn = ObjectOrientate(BaseSpawn)

function FallSpawn:perform(char: Model, cframe: CFrame): nil
	local root_part = char:FindFirstChild('HumanoidRootPart')
	root_part.Anchored = true

	local angle = 2 * math.random() * math.pi
	local x, z = math.sin(angle), math.cos(angle)
	char:SetPrimaryPartCFrame(
		cframe *
		CFrame.Angles(0, math.pi, 0) +
		1e2 * Vector3.new(x, 1, z)
	)

	local duration = math.random(7, 13)
	local tween_handler = EasyClientTween.new(false, nil, nil, nil)
	tween_handler:TweenAllClients(
		root_part,
		{
			duration,
		},
		{
			CFrame = cframe,
		}
	)

	self.Janitor:Add(tween_handler)
	task.wait(duration)
	root_part.Anchored = false
end

return FallSpawn