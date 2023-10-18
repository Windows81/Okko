local ReplStor = game:GetService('ReplicatedStorage')
local ObjectOrientate = require(ReplStor.Shared.Util.ObjectOrientate)
local EasyClientTween = require(ReplStor.Shared.EasyClientTween)
local BaseMove = require(script.Parent.BaseMove)
local TweenMove = ObjectOrientate(BaseMove)

function TweenMove:init(tween_time: number, ...)
	BaseMove.init(self, tween_time or 1, ...)
	self.TweenTime = tween_time or 1
end

function TweenMove:perform(obj: Model, cframe: CFrame): nil
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
	local tween_info = {
		self.TweenTime,
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.InOut,
	}

	local tween_handler = EasyClientTween.new(true, nil, nil, nil)
	tween_handler:TweenAllClients(
		root_part,
		tween_info,
		{
			CFrame = cframe * random_rot
		}
	)
	self.Janitor:Add(tween_handler)
	task.wait(self.TweenTime)
	root_part.Anchored = false
end

return TweenMove