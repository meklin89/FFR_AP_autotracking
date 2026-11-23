--  Load configuration options up front
ScriptHost:LoadScript("scripts/settings.lua")
print("Starting up scipts")

-- Get the variant and set some flags for use later
local variant = Tracker.ActiveVariantUID
IS_ITEMS_ONLY = variant:find("NoMap")
IS_SHARD_HUNT = variant:find("shardHunt")

print("Tracker Variant: ", variant)

-- Add Logic
ScriptHost:LoadScript("scripts/logic.lua")

-- Add Items
Tracker:AddItems("items/items.json")
Tracker:AddItems("items/hosted_items.json")
Tracker:AddItems("items/flags.json")

-- Shard Hunt Variants
if IS_SHARD_HUNT then
	Tracker:AddItems("items/shards.json")
	local shardsRequired = Tracker:FindObjectForCode("shardsRequired")
	shardsRequired.CurrentStage = 8
	ScriptHost:LoadScript("scripts/update_shards_via_orbs.lua")
end

-- Items Only Variants
if not IS_ITEMS_ONLY then
	-- Add Maps
	Tracker:AddMaps("maps/maps.json")
	-- Add Locations
	ScriptHost:LoadScript("scripts/loadLocations.lua")
	ScriptHost:LoadScript("scripts/update_cardia_boxes.lua")
	-- Add Shop Item Locations Clear Script
	ScriptHost:LoadScript("scripts/shop_item_locations_clear.lua")
end

-- Add Layouts
Tracker:AddLayouts("layouts/items.json")
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")


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
local titanIncentive = Tracker:FindObjectForCode("titansTroveIsIncentive")
titanIncentive.Active = true
local earthIncentive = Tracker:FindObjectForCode("earthIsIncentive")
earthIncentive.Active = true
local volcanoIncentive = Tracker:FindObjectForCode("volcanoIsIncentive")
volcanoIncentive.Active = true
local seaIncentive = Tracker:FindObjectForCode("seaIsIncentive")
seaIncentive.Active = true
local skyIncentive = Tracker:FindObjectForCode("skyIsIncentive")
skyIncentive.Active = true
local coneriaLockedIncentive = Tracker:FindObjectForCode("coneriaLockedIsIncentive")
coneriaLockedIncentive.Active = true
local marshLockedIsIncentive = Tracker:FindObjectForCode("marshLockedIsIncentive")
marshLockedIsIncentive.Active = true
local cardiaIsIncentive = Tracker:FindObjectForCode("cardiaIsIncentive")
cardiaIsIncentive.Active = true
local earlyKing = Tracker:FindObjectForCode("earlyKing")
earlyKing.Active = true
local earlySarda = Tracker:FindObjectForCode("earlySarda")
earlySarda.Active = true
local earlySage = Tracker:FindObjectForCode("earlySage")
earlySage.Active = true
local earlyOrdeals = Tracker:FindObjectForCode("earlyOrdeals")
earlyOrdeals.Active = true
local titanTrove = Tracker:FindObjectForCode("titanTrove")
titanTrove.CurrentStage = 2

-- AutoTracking for Poptracker
if PopVersion and PopVersion>="0.18.0" then
	ScriptHost:LoadScript("scripts/autotracking.lua")
end
