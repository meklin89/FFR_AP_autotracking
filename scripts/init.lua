--  Load configuration options up front
ScriptHost:LoadScript("scripts/settings.lua")
print("Starting up scipts")

-- Add Items
Tracker:AddItems("items/items.json")
Tracker:AddItems("items/hosted_items.json")
Tracker:AddItems("items/flags.json")
Tracker:AddItems("items/shards.json")

if Tracker.ActiveVariantUID == "7NOverworld" or Tracker.ActiveVariantUID == "8shardHuntNOverworld" then
  Tracker:AddMaps("maps/NOverworldMaps.json")
else
  Tracker:AddMaps("maps/maps.json")
end

ScriptHost:LoadScript("scripts/logic.lua")

if Tracker.ActiveVariantUID == "7NOverworld" or Tracker.ActiveVariantUID == "8shardHuntNOverworld" then
    Tracker:AddLocations("locations/NOverworld/locations.json")
    Tracker:AddLocations("locations/NOverworld/incentives.json")
else
    Tracker:AddLocations("locations/overworld.json")
    Tracker:AddLocations("locations/incentives.json")
end

Tracker:AddLayouts("layouts/shared.json")
if Tracker.ActiveVariantUID == "6shardHunt" then
  Tracker:AddLayouts("layouts/shardHunt/tracker.json")
  Tracker:AddLayouts("layouts/shardHunt/broadcast.json")
  local shardsRequired = Tracker:FindObjectForCode("shardsRequired")
  shardsRequired.CurrentStage = 8
elseif Tracker.ActiveVariantUID == "2shardHuntNoMap" then
  Tracker:AddLayouts("layouts/shardHuntNoMap/tracker.json")
  Tracker:AddLayouts("layouts/shardHuntNoMap/broadcastNoMap.json")
  local shardsRequired = Tracker:FindObjectForCode("shardsRequired")
  shardsRequired.CurrentStage = 8
elseif Tracker.ActiveVariantUID == "8shardHuntNOverworld" then
  Tracker:AddLayouts("layouts/NOverworld/shardsTracker.json")
  Tracker:AddLayouts("layouts/NOverworld/broadcastShards.json")
  local shardsRequired = Tracker:FindObjectForCode("shardsRequired")
  shardsRequired.CurrentStage = 8
elseif Tracker.ActiveVariantUID == "4shardHuntNOverworldNoMap" then
  Tracker:AddLayouts("layouts/NOverworld/shardsTrackerNoMap.json")
  Tracker:AddLayouts("layouts/NOverworld/broadcastShardsNoMap.json")
  local shardsRequired = Tracker:FindObjectForCode("shardsRequired")
  shardsRequired.CurrentStage = 8
elseif Tracker.ActiveVariantUID == "7NOverworld" then
  Tracker:AddLayouts("layouts/NOverworld/tracker.json")
  Tracker:AddLayouts("layouts/NOverworld/broadcast.json")
elseif Tracker.ActiveVariantUID == "3NOverworldNoMap" then
  Tracker:AddLayouts("layouts/NOverworld/trackerNoMap.json")
  Tracker:AddLayouts("layouts/NOverworld/broadcastNoMap.json")
elseif Tracker.ActiveVariantUID == "1standardNoMap" then
  Tracker:AddLayouts("layouts/standardNoMap/tracker.json")
  Tracker:AddLayouts("layouts/standardNoMap/broadcastNoMap.json")
else
  Tracker:AddLayouts("layouts/standard/tracker.json")
  Tracker:AddLayouts("layouts/standard/standard_broadcast.json")
end

-- Default Flags
local progressionFlag = Tracker:FindObjectForCode("progressionFlag")
progressionFlag.CurrentStage = 1
local npcsIncentive = Tracker:FindObjectForCode("npcsAreIncentive")
npcsIncentive.Active = true
local fetchQuestsIncentive = Tracker:FindObjectForCode("fetchQuestsAreIncentive")
fetchQuestsIncentive.Active = true
local iceIncentive = Tracker:FindObjectForCode("iceCaveIsIncentive")
iceIncentive.Active = true
local ordealsIncentive = Tracker:FindObjectForCode("ordealsIsIncentive")
ordealsIncentive.Active = true
local marshIncentive = Tracker:FindObjectForCode("marshIsIncentive")
marshIncentive.Active = true
local earthIncentive = Tracker:FindObjectForCode("earthIsIncentive")
earthIncentive.Active = true
local seaIncentive = Tracker:FindObjectForCode("seaIsIncentive")
seaIncentive.Active = true
local skyIncentive = Tracker:FindObjectForCode("skyIsIncentive")
skyIncentive.Active = true
local coneriaLockedIncentive = Tracker:FindObjectForCode("coneriaLockedIsIncentive")
coneriaLockedIncentive.Active = true
local earlyKing = Tracker:FindObjectForCode("earlyKing")
earlyKing.Active = true
local earlySarda = Tracker:FindObjectForCode("earlySarda")
earlySarda.Active = true
local earlySage = Tracker:FindObjectForCode("earlySage")
earlySage.Active = true
local earlyOrdeals = Tracker:FindObjectForCode("earlyOrdeals")
earlyOrdeals.Active = true

-- AutoTracking for Poptracker
if PopVersion and PopVersion>="0.18.0" then
  ScriptHost:LoadScript("scripts/autotracking.lua")
end
