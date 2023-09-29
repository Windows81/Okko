local ReplStor = game:GetService('ReplicatedStorage')
local ObjectOrientate = require(ReplStor.Shared.Util.ObjectOrientate)
local JanitorClass = require(ReplStor.Shared.Util.JanitorClass)
local class = ObjectOrientate(JanitorClass)

function class:init(step_dist: number)
	JanitorClass.init(self)
	self.StepDistance = step_dist or 4
end

function class:perform(from_cf: CFrame, to_cf: CFrame): CFrame
	local dist = (
		to_cf.Position -
		from_cf.Position
	).Magnitude

	if dist == 0 then
		return to_cf
	end

	local alpha = math.min(2, self.StepDistance / dist)
	return CFrame.new(from_cf.Position:Lerp(to_cf.Position, alpha), to_cf.Position)
end

return class