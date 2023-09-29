local ReplStor = game:GetService('ReplicatedStorage')
local ObjectOrientate = require(ReplStor.Shared.Util.ObjectOrientate)
local JanitorClass = require(ReplStor.Shared.Util.JanitorClass)
local class = ObjectOrientate(JanitorClass)

-- Locates the closest player to 'obj'.
function class:perform(obj: Model): CFrame?
	local prim_part = obj.PrimaryPart
	if not prim_part then return end

	local obj_pos = prim_part.Position
	local closest_dist, closest_cf = math.huge, nil

	for _, plr in game.Players:GetPlayers() do
		if not plr.Character then continue end
		local prim_part = plr.Character.PrimaryPart
		if not prim_part then continue end
		local plr_cf = prim_part.CFrame
		local dist = (plr_cf.Position - obj_pos).Magnitude
		if closest_dist > dist then
			closest_cf = plr_cf
			closest_dist = dist
		end
	end
	return closest_cf
end

return class