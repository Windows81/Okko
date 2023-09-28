local class = require(script.Parent.Monsters.SolidHumanoidMonster)

task.spawn(function()
	local entity = class.new(1630228, Color3.fromHex('#0078d7'))
	while true do
		entity:load(CFrame.new(0, 13, 0))
		task.wait(13)
	end
end)

return nil