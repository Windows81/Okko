local ReplStor = game:GetService('ReplicatedStorage')
local ObjectOrientate = require(ReplStor.Shared.Util.ObjectOrientate)
local RandomInitialisier = require(ReplStor.Shared.Util.RandomInitialisier)
local Janitor = require(ReplStor.Shared.Janitor)
local class = ObjectOrientate()


function class:init(spawn_location: CFrame, description: HumanoidDescription)
	self.LoaderJanitor = Janitor.new()
	self.Description = description:Clone()
	self.SpawnLocation = spawn_location
	self.LoadFlag = true

	-- Spawning is initialised on character load, but selected by random upon first init.
	self.SpawnInit = RandomInitialisier{
		--{require(script.Parent.Parent.SpawnAnims.BaseSpawn), {}},
		{require(script.Parent.Parent.SpawnAnims.FallSpawn), {}},
	}

	self.MoveInit = RandomInitialisier{
		--{require(script.Parent.Parent.MoveAnims.SpringMove), {}},
		{require(script.Parent.Parent.MoveAnims.TweenMove), {5e-1 + math.random()}},
	}

	self.LocatorInit = RandomInitialisier{
		{require(script.Parent.Parent.LocatorLogic.BaseLocator), {}},
	}

	self.PathfindInit = RandomInitialisier{
		{require(script.Parent.Parent.PathfindLogic.BasePathfind), {4 + 9 * math.random()}},
	}
end


-- Clears previous character and loads a new one in with the parameters specified in 'init'.
function class:load(): nil
	self:clean()
	self.CharacterModel = game.Players:CreateHumanoidModelFromDescription(
		self.Description,
		Enum.HumanoidRigType.R15,
		Enum.AssetTypeVerification.ClientOnly
	)

	-- This is to make sure that the character doesn't keep respawning.
	self.LoadFlag = false

	self.MoveObj = self.MoveInit()
	self.SpawnObj = self.SpawnInit()
	self.LocatorObj = self.LocatorInit()
	self.PathfindObj = self.PathfindInit()
	self.LoaderJanitor:Add(self.MoveObj, 'destroy')
	self.LoaderJanitor:Add(self.SpawnObj, 'destroy')
	self.LoaderJanitor:Add(self.LocatorObj, 'destroy')
	self.LoaderJanitor:Add(self.PathfindObj, 'destroy')

	self:__skin()
	self:__spawn()
end


-- Return false until 'to_cf' is close enough to the character's current position.
function class:navigate_to(to_cf: CFrame): boolean
	local from_cf: CFrame = self.CharacterModel.PrimaryPart.CFrame
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


-- Uses the instance's locator logic to move it to the next appropriate spot.
function class:navigate(): boolean
	local to_cf = self.LocatorObj:perform(self.CharacterModel)
	return self:navigate_to(to_cf)
end


-- Clears all existing objects that are connected to our entity instance.
function class:clean(): nil
	self.LoaderJanitor:Cleanup()
end


function class:die(): nil
	self.LoadFlag = true
end


function class:__skin(): nil
	self.CharacterModel.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
end


function class:__spawn(): nil
	self.CharacterModel.Parent = game.Workspace
	self.LoaderJanitor:Add(self.CharacterModel)
	self.SpawnObj:perform(self.CharacterModel, self.SpawnLocation)

	-- Check if killed whilst spawning.
	if self.CharacterModel.Humanoid.Health <= 0 then self:die() return end

	self.CharacterModel.Humanoid.Died:Connect(function() self:die() end)
	self.CharacterModel.Destroying:Connect(function() self:die() end)

end


function class:loop(...): nil
	while not self.LoadFlag do
		local done = self:navigate()
		-- If the character is already at its destination, leave some delay so as to not strain the game.
		if done then task.wait(self.MoveObj.DoneWait) end
	end

	-- The call to 'clean' is intentionally redundant when we use 'loop_respawn'.
	self:clean()
end


function class:loop_respawn(...): nil
	while true do
		-- Loop until the character dies then respawn it automatically.
		self:loop(...)
		self:load()
	end
end


return class