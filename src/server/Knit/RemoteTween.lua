local ReplStor = game:GetService('ReplicatedStorage')
local TweenService = game:GetService('TweenService')
local Janitor = require(ReplStor.Shared.Janitor)
local Knit = require(ReplStor.Shared.Knit.Knit)

local RemoteTweenService = Knit.CreateService{
	Name = 'RemoteTweenService',
    Client = {
        TweenInitiated = Knit.CreateSignal(),
        PartDeleted = Knit.CreateSignal(),
    },
}

function RemoteTweenService:FireAllClients(
	instance: Instance,
	tween_info: TweenInfo,
	props: {[string]: any},
	wait_to_complete: boolean
)
	local tween_janitor = Janitor.new()
	tween_janitor:Add(
		instance.Destroying:Connect(function()
			RemoteTweenService.Client.PartDeleted:FireAllClients(instance)
			tween_janitor:Cleanup()
		end)
	)

	local tween_table = {
		Time = tween_info.Time,
		EasingStyle = tween_info.EasingStyle,
		EasingDirection = tween_info.EasingDirection,
		RepeatCount = tween_info.RepeatCount,
		Reverses = tween_info.Reverses,
		DelayTime = tween_info.DelayTime,
	}

	for _, pl in game.Players:GetPlayers() do
		self.Client.TweenInitiated:Fire(pl, instance, tween_table, props)
	end

	local tween = TweenService:Create(instance, tween_info, props)
	tween_janitor:Add(tween)
	tween:Play()

	if wait_to_complete then
		task.wait(
			tween_info.DelayTime +
			tween_info.Time * (tween_info.Reverses and 2 or 1) *
			(1 + tween_info.RepeatCount)
		)
	end
	tween_janitor:Cleanup()
end

return RemoteTweenService