local ReplStor = game:GetService('ReplicatedStorage')
local SolidHumanoidEntity = require(script.Parent.SolidHumanoidEntity)
local ObjectOrientate = require(ReplStor.Shared.Util.ObjectOrientate)
local class = ObjectOrientate(SolidHumanoidEntity)


function class:init(spawn_location: CFrame, damage: number, ...)
	SolidHumanoidEntity.init(self, spawn_location, ...)
	self.Damage = damage
end


function class:__skin(): nil
	SolidHumanoidEntity.__skin(self)
	for _, part in self.CharacterModel:GetDescendants() do
		if not part:IsA'BasePart' then continue end
		part.Touched:Connect(function(hit: BasePart)
			local char = hit:FindFirstAncestorOfClass('Model')
			if not char then return end
			local humanoid = char:FindFirstChildOfClass('Humanoid')
			if not humanoid then return end
			humanoid:TakeDamage(self.Damage)
		end)
	end
end

return class