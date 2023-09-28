local ReplStor = game:GetService('ReplicatedStorage')
local ObjectOrientate = require(ReplStor.Shared.Util.ObjectOrientate)
local RandomInitialisier = require(ReplStor.Shared.Util.RandomInitialisier)
local Janitor = require(ReplStor.Shared.Janitor)
local class = ObjectOrientate()


function class:init(userId: number)
	self.UserId = userId
	self.LoaderJanitor = Janitor.new()
	self.Description = game.Players:GetHumanoidDescriptionFromUserId(userId)

	-- Spawning is initialised on character load, but selected by random upon first init.
	self.SpawnInit = RandomInitialisier{
		--{require(script.Parent.Parent.SpawnAnims.BaseSpawn), {}},
		{require(script.Parent.Parent.SpawnAnims.FallSpawn), {}},
	}

	self.MoveInit = RandomInitialisier{
		{require(script.Parent.Parent.MoveAnims.SpringMove), {}},
		{require(script.Parent.Parent.MoveAnims.TweenMove), {}},
	}

	self.PathfindInit = RandomInitialisier{
		{require(script.Parent.Parent.Pathfind.BasePathfind), {}},
	}
end


function class:load(spawn_location: CFrame): nil
	self:clean()
	self.CharacterModel = game.Players:CreateHumanoidModelFromDescription(
		self.Description,
		Enum.HumanoidRigType.R15,
		Enum.AssetTypeVerification.ClientOnly
	)

	self.MoveObj = self.MoveInit()
	self.SpawnObj = self.SpawnInit()
	self.PathfindObj = self.PathfindInit()
	self.LoaderJanitor:Add(self.MoveObj, 'destroy')
	self.LoaderJanitor:Add(self.SpawnObj, 'destroy')
	self.LoaderJanitor:Add(self.PathfindObj, 'destroy')

	self:__skin()
	self:__spawn(spawn_location)
end


-- Return false until 'to_cf' is close enough to the character's current position.
function class:navigate(to_cf: CFrame): boolean
	local from_cf: CFrame = self.CharacterModel:GetPrimaryPartCFrame()
	local mid_cf: CFrame = self.PathfindObj:perform(from_cf, to_cf)

	local dist = (
		mid_cf.Position -
		from_cf.Position
	).Magnitude

	if dist < 1 then
		return true
	end

	self.MoveObj:perform(self.CharacterModel, mid_cf)
	return false
end


function class:clean(): nil
	self.LoaderJanitor:Cleanup()
end


function class:__skin(): nil
	self.CharacterModel.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
end


function class:__spawn(spawn_location: CFrame): nil
	self.CharacterModel.Parent = game.Workspace
	self.SpawnObj:perform(self.CharacterModel, spawn_location)

	-- Check if killed whilst spawning, else add 'died' event.
	if self.CharacterModel.Humanoid.Health <= 0 then self:clean() return end
	self.CharacterModel.Humanoid.Died:Connect(function() self:clean() end)

	self.LoaderJanitor:Add(self.CharacterModel)
end

return class
