local ReplStor = game:GetService('ReplicatedStorage')
local Knit = require(ReplStor.Shared.Knit.Knit)

local LeaderboardService = Knit.CreateService{
	Name = 'LeaderboardService',
    Server = {
        EntityKilledByPlayer = Knit.CreateSignal(),
        EntityKilledPlayer = Knit.CreateSignal(),
    },
}

local STAT_DICTS = {
	Kills = require(script.Kills),
	Deaths = require(script.Deaths),
}

local function leaderboard_setup(player: Player)
	local leaderstats = Instance.new('Folder')
	leaderstats.Name = 'leaderstats'
	leaderstats.Parent = player

	for _, stat in next, STAT_DICTS do
		local value = Instance.new(stat.Type)
		value.Name = stat.StatName
		value.Value = stat.Default
		value.Parent = leaderstats
	end
end

for _, pl in next, game.Players:GetPlayers() do leaderboard_setup(pl) end
game.Players.PlayerAdded:Connect(leaderboard_setup)

local function get_leaderstat(player: Player, key: string): ValueBase?
	local leaderstats = player:FindFirstChild('leaderstats')
	if not leaderstats then return end
	local value = leaderstats:FindFirstChild(key)
	return value
end

local function increment(player: Player, key: string, delta: number?)
	local value = get_leaderstat(player, key)
	if not value then return end
	value.Value += delta or 1
end

local function set(player: Player, key: string, set_to)
	local value = get_leaderstat(player, key)
	if not value then return end
	value.Value = set_to
end

local function get(player: Player, key: string, set_to)
	local value = get_leaderstat(player, key)
	if not value then return end
	return value.Value
end

function LeaderboardService:EntityKilledByPlayer(
	entity,
	player: Player
)
	increment(player, STAT_DICTS.Kills.StatName)
end

function LeaderboardService:EntityKilledPlayer(
	entity,
	player: Player
)
	increment(player, STAT_DICTS.Deaths.StatName)
end

return LeaderboardService