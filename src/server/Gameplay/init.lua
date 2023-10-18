local EvilHumanoidEntity = require(script.Parent.Monsters.Entities.EvilHumanoidEntity)
local Placement = require(script.Placement)

local description = game.ReplicatedStorage:FindFirstChild('HumanoidDescription')
for _, cf in Placement do
	task.spawn(function()
		local entity = EvilHumanoidEntity.new(cf, 13, description, BrickColor.random().Color)
		entity:loop_respawn()
	end)
end

return nil