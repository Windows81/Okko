local ReplStor = game:GetService('ReplicatedStorage')
local HumanoidEntity = require(script.Parent.HumanoidEntity)
local ObjectOrientate = require(ReplStor.Shared.Util.ObjectOrientate)
local class = ObjectOrientate(HumanoidEntity)


function class:init(
	spawn_location: CFrame,
	description: HumanoidDescription,
	colour: Color3,
	...
)
	HumanoidEntity.init(self, spawn_location, description, ...)
	self.Colour = colour
	self.Description.HeadColor = colour
	self.Description.RightLegColor = colour
	self.Description.RightArmColor = colour
	self.Description.LeftLegColor = colour
	self.Description.LeftArmColor = colour
	self.Description.TorsoColor = colour
end


function class:__skin(): nil
	HumanoidEntity.__skin(self)
	for _, part in self.CharacterModel:GetDescendants() do
		if part:IsA'MeshPart' then
			part.TextureID = ''
		elseif
			part:IsA'Decal' or
			part:IsA'Clothing' or
			part:IsA'BodyColors' or
			part:IsA'SurfaceAppearance' then
			part:Destroy()
			continue
		elseif not part:IsA'BasePart' then
			continue
		end
		part.Reflectance = 1
		part.Color = self.Colour
	end

	local humanoid: Humanoid = self.CharacterModel:FindFirstChild('Humanoid')
	humanoid.HealthChanged:Connect(function(health)
		local reflectance = health / humanoid.MaxHealth
		for _, part in self.CharacterModel:GetDescendants() do
			if not part:IsA'BasePart' then continue end
			part.Reflectance = reflectance
		end
	end)
end


return class