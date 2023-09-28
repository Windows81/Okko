local ReplStor = game:GetService('ReplicatedStorage')
local TweenService = game:GetService('TweenService')
local Janitor = require(ReplStor.Shared.Janitor)
local Knit = require(ReplStor.Shared.Knit.Knit)

local RemoteTweenService = Knit.GetService(
	'RemoteTweenService'
)

-- Keeps track of each tween that takes place in the event any parts get deleted.
local part_janitor_dict = {}

RemoteTweenService.TweenInitiated:Connect(function(
	instance: Instance,
	tween_table: {[string]:any},
	props: {[string]: any}
)
	local tween_info = TweenInfo.new(
		tween_table.Time,
		tween_table.EasingStyle,
		tween_table.EasingDirection,
		tween_table.RepeatCount,
		tween_table.Reverses,
		tween_table.DelayTime
	)

	local tween = TweenService:Create(instance, tween_info, props)
	part_janitor_dict[instance] = part_janitor_dict[instance] or Janitor.new()
	part_janitor_dict[instance]:Add(tween)
	tween:Play()
end)

RemoteTweenService.PartDeleted:Connect(function(instance: Instance)
	part_janitor_dict[instance]:Cleanup()
	part_janitor_dict[instance] = nil
end)

return RemoteTweenService