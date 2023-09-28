local ReplStor = game:GetService('ReplicatedStorage')
local HumanoidMonster = require(script.Parent.HumanoidMonster)
local ObjectOrientate = require(ReplStor.Shared.Util.ObjectOrientate)
local class = ObjectOrientate(HumanoidMonster)


function class:init(userId: number, colour: Color3, reflectance: number, transparency: number)
	HumanoidMonster.init(self, userId)
	self.Colour = colour
	self.Description.HeadColor = colour
	self.Description.RightLegColor = colour
	self.Description.RightArmColor = colour
	self.Description.LeftLegColor = colour
	self.Description.LeftArmColor = colour
	self.Description.TorsoColor = colour
	self.Reflectance = reflectance or 1
	self.Transparency = transparency or 0
end


function class:__skin(): nil
	HumanoidMonster.__skin(self)
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
		part.Transparency = self.Transparency
		part.Reflectance = self.Reflectance
		part.Color = self.Colour
	end
end

return class