-- Script to update shard count based on the state of orbs collected

function updateShardCount(orbType)
	local earthOrbState = Tracker:FindObjectForCode("earthorb")
	local fireOrbState = Tracker:FindObjectForCode("fireorb")
	local waterOrbState = Tracker:FindObjectForCode("waterorb")
	local airOrbState = Tracker:FindObjectForCode("airorb")

	-- Add for earth and fire orbs by 2
	if (orbType == "earth" and (earthOrbState and earthOrbState.CurrentStage > 0)) or orbType == "fire" and (fireOrbState and fireOrbState.CurrentStage > 0) then
		for _ = 1, 2 do
			local obj = Tracker:FindObjectForCode("shards")
			if obj then
				obj.CurrentStage = obj.CurrentStage + 1
			end
		end
		debugLog(string.format("updateShardCount: incremented shard count for earth or fire orb by 2"))

	-- Add for water and air orbs by 4
	elseif (orbType == "water" and (waterOrbState and waterOrbState.CurrentStage > 0)) or (orbType == "air" and (airOrbState and airOrbState.CurrentStage > 0)) then
		for _ = 1, 4 do
			local obj = Tracker:FindObjectForCode("shards")
			if obj then
				obj.CurrentStage = obj.CurrentStage + 1
			end
		end
		debugLog(string.format("updateShardCount: incremented shard count for water or air orb by 4"))
	
	-- Subtract for earth and fire orbs by 2
	elseif (orbType == "earth" and not (earthOrbState and earthOrbState.CurrentStage > 0)) or (orbType == "fire" and not (fireOrbState and fireOrbState.CurrentStage > 0)) then
		for _ = 1, 2 do
			local obj = Tracker:FindObjectForCode("shards")
			if obj then
				obj.CurrentStage = obj.CurrentStage -1
			end
		end
		debugLog(string.format("updateShardCount: decremented shard count for earth or fire orb by 2"))
	
	-- Subtract for water and air orbs by 4
	elseif (orbType == "water" and not (waterOrbState and waterOrbState.CurrentStage > 0)) or (orbType == "air" and not (airOrbState and airOrbState.CurrentStage > 0)) then
		for _ = 1, 4 do
			local obj = Tracker:FindObjectForCode("shards")
			if obj then
				obj.CurrentStage = obj.CurrentStage -1
			end
		debugLog(string.format("updateShardCount: decremented shard count for water or air orb by 4"))
		end
	end
end

local earthOrbRef = ScriptHost:AddWatchForCode("watch_for_earth_orb", "earthorb", function() updateShardCount("earth") end)
local fireOrbRef = ScriptHost:AddWatchForCode("watch_for_fire_orb", "fireorb", function() updateShardCount("fire") end)
local waterOrbRef = ScriptHost:AddWatchForCode("watch_for_water_orb", "waterorb", function() updateShardCount("water") end)
local airOrbRef = ScriptHost:AddWatchForCode("watch_for_air_orb", "airorb", function() updateShardCount("air") end)