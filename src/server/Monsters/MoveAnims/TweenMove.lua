local ReplStor = game:GetService('ReplicatedStorage')
local ObjectOrientate = require(ReplStor.Shared.Util.ObjectOrientate)
local RemoteTween = require(script.Parent.Parent.Parent.Knit.RemoteTween)
local BaseMove = require(script.Parent.BaseMove)
local class = ObjectOrientate(BaseMove)

function class:init(tween_time: number, ...)
	BaseMove.init(self, tween_time or 1, ...)
	self.TweenTime = tween_time or 1
end

function class:perform(obj: Model, cframe: CFrame): nil
	local root_part = obj.PrimaryPart
	root_part.Anchored = true

	local random_rot = CFrame.fromAxisAngle(
		Vector3.new(
			math.random(),
			math.random(),
			math.random()
		),
		math.pi * math.random()

	)
	local tween_info = TweenInfo.new(
		self.TweenTime,
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.InOut
	)

	RemoteTween:FireAllClients(
		root_part,
		tween_info,
		{
			CFrame = cframe * random_rot
		},
		true
	)
	root_part.Anchored = false
end

return class