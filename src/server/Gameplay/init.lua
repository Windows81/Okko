local class = require(script.Parent.Monsters.Entities.EvilHumanoidEntity)

task.spawn(function()
	local entity = class.new(CFrame.new(0, 13, 0), 13, 1630228, Color3.new())
	entity:load()
	entity:loop()
end)

return nil