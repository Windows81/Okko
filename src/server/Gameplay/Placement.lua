local DISTANCE = 32
local EXTENTS = 128

local spawn_locations = {}
for x = -EXTENTS, EXTENTS, DISTANCE do
	for z = -EXTENTS, EXTENTS, DISTANCE do
		table.insert(spawn_locations, CFrame.new(x, 4, z))
	end
end

return spawn_locations