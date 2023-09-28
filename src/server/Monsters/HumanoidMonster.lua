local ReplStor = game:GetService('ReplicatedStorage')
local ObjectOrientate = require(ReplStor.Shared.Util.ObjectOrientate)
local RandomInitialisier = require(ReplStor.Shared.Util.RandomInitialisier)
local Janitor = require(ReplStor.Shared.Janitor)
local class = ObjectOrientate()


function class:init(userId: number)
	self.UserId = userId
	self.LoaderJanitor = Janitor.new()
	self.Description = game.Players:GetHumanoidDescriptionFromUserId(userId)
end


function class:load(spawn_location: CFrame): nil
	self:clean()
	self:spawn(spawn_location)
end


function class:clean(): nil
	self.LoaderJanitor:Cleanup()
end


function class:skin(): nil
	self.CharacterModel.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
end


function class:spawn(spawn_location: CFrame): nil
	self.CharacterModel = game.Players:CreateHumanoidModelFromDescription(
		self.Description,
		Enum.HumanoidRigType.R15,
		Enum.AssetTypeVerification.ClientOnly
	)

	self.CharacterModel.Parent = game.Workspace
	self:skin()

	-- The spawn animation is selected at random.
	local spawn_tween = RandomInitialisier{
		--{require(script.Parent.Parent.SpawnAnims.BaseSpawn), {}},
		{require(script.Parent.Parent.SpawnAnims.FallSpawn), {}},
	}

	self.LoaderJanitor:Add(spawn_tween, 'destroy')
	spawn_tween:perform(self.CharacterModel, spawn_location)

	-- Check if killed whilst spawning, else add 'died' event.
	if self.CharacterModel.Humanoid.Health <= 0 then self:clean() return end
	self.CharacterModel.Humanoid.Died:Connect(function() self:clean() end)

	self.LoaderJanitor:Add(self.CharacterModel)
end

return class
