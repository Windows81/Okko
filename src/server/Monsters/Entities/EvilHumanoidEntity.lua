local ReplStor = game:GetService('ReplicatedStorage')
local SolidHumanoidEntity = require(script.Parent.SolidHumanoidEntity)
local ObjectOrientate = require(ReplStor.Shared.Util.ObjectOrientate)
local class = ObjectOrientate(SolidHumanoidEntity)
local Knit = require(ReplStor.Shared.Knit.Knit)

local LeaderboardService = Knit.GetService(
	'LeaderboardService'
)

function class:init(spawn_location: CFrame, damage: number, ...)
	SolidHumanoidEntity.init(self, spawn_location, ...)
	self.Damage = damage
end


-- Adds one leaderstat kill to each player within a 7-stud distance of the dead character.
function class:die(): nil
	SolidHumanoidEntity.die(self)
	local prim_part = self.CharacterModel.PrimaryPart
	if not prim_part then return end
	local obj_pos = prim_part.Position
	for _, player in game.Players:GetPlayers() do
		local char = player.Character
		if not char then continue end
		local char_pos = char.PrimaryPart.Position
		local dist = (char_pos - obj_pos).Magnitude
		if dist > 7 then continue end
		LeaderboardService:EntityKilledByPlayer(self, player)
	end
end


function class:__skin(): nil
	SolidHumanoidEntity.__skin(self)
	for _, part in self.CharacterModel:GetDescendants() do
		local debounce = false
		if not part:IsA'BasePart' then continue end
		part.Touched:Connect(function(hit: BasePart)
			if debounce then return end

			local char = hit:FindFirstAncestorOfClass('Model')
			if not char or char == self.CharacterModel then
				return
			end

			local humanoid = char:FindFirstChildOfClass('Humanoid')
			if not humanoid or humanoid.Health <= 0 then
				return
			end

			-- Ensures that enemies aren't killing each other.
			local player = game.Players:GetPlayerFromCharacter(char)
			if not player then return end

			debounce = true
			humanoid:TakeDamage(self.Damage)
			if humanoid.Health <= 0 then
				LeaderboardService:EntityKilledPlayer(self, player)
			end
			task.wait(1)
			debounce = false
		end)
	end
end


return class