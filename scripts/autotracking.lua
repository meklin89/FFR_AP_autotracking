-- Configuration --------------------------------------
AUTOTRACKER_ENABLE_DEBUG_LOGGING = true
AUTOTRACKER_ENABLE_ITEM_TRACKING = true
AUTOTRACKER_ENABLE_LOCATION_TRACKING = true
AUTOTRACKER_ENABLE_MAP_TAB_SWITCHING = true
-------------------------------------------------------

print("")
print("Active Auto-Tracker Configuration")
print("---------------------------------------------------------------------")
print("Enable Debug Logging:    ", AUTOTRACKER_ENABLE_DEBUG_LOGGING)
print("Enable Item Tracking:    ", AUTOTRACKER_ENABLE_ITEM_TRACKING)
print("Enable Location Tracking:  ", AUTOTRACKER_ENABLE_LOCATION_TRACKING)
print("Enable Map Tab Switching:  ", AUTOTRACKER_ENABLE_MAP_TAB_SWITCHING)
print("---------------------------------------------------------------------")
print("")

CUR_INDEX = -1
current_map_key = nil
local goal_status_key = nil

ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/tab_mapping.lua")

function debugLog(message)
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
		print(string.format("[DEBUG] %s", message))
	end
end

function onClear()
	debugLog(string.format("called onClear"))
	CUR_INDEX = -1

	for _, v in pairs(ITEM_MAPPING) do
		if v[1] then
			debugLog(string.format("onClear: clearing item %s of type %s", v[1], v[2]))
			local obj = Tracker:FindObjectForCode(v[1])
			if obj then
				if v[2] == "toggle" then
					obj.Active = false
					debugLog(string.format("onClear: toggled object %s", v[1]))
				elseif v[2] == "progressive" then
					if obj.Active then
						obj.CurrentStage = 0
						debugLog(string.format("onClear: reset progressive object %s to stage %d", v[1], obj.CurrentStage))
					end
				elseif v[2] == "consumable" then
					obj.AcquiredCount = 0
					debugLog(string.format("onClear: reset consumable object %s to count %d", v[1], obj.AcquiredCount))
				else
					debugLog(string.format("onClear: unknown item type %s for code %s", v[2], v[1]))
				end
			else
				debugLog(string.format("onClear: could not find object for code %s", v[1]))
			end
		end
	end

	for _, location_array in pairs(LOCATION_MAPPING) do
		for _, location in pairs(location_array) do
			debugLog(string.format("onClear: clearing location %s", location))
			if location then
				local obj = Tracker:FindObjectForCode(location)
				if obj then
					if location:sub(1, 1) == "@" then
						obj.AvailableChestCount = obj.ChestCount
						debugLog(string.format("onClear: reset chest count for location %s", location))
					else
						obj.Active = false
						debugLog(string.format("onClear: deactivated location %s", location))
					end
				else
					debugLog(string.format("onClear: could not find object for code %s", location))
				end
			end
		end
	end

	local chaos = Tracker:FindObjectForCode("chaos")
	if chaos then
		chaos.Active = false
	else
		print("onClear: could not find Chaos item")
	end

	goal_status_key = nil
	local team = Archipelago.TeamNumber
	local player = Archipelago.PlayerNumber
	if team and team >= 0 and player and player >= 0 then
		goal_status_key = string.format("_read_client_status_%d_%d", team, player)
		if not Archipelago:SetNotify({goal_status_key}) then
			print("onClear: failed to subscribe to Archipelago goal status")
		end
		if not Archipelago:Get({goal_status_key}) then
			print("onClear: failed to retrieve Archipelago goal status")
		end
	else
		print("onClear: cannot track goal status without an Archipelago team and player")
	end

	current_map_key = nil
	if AUTOTRACKER_ENABLE_MAP_TAB_SWITCHING then
		if team and team >= 0 and player and player >= 0 then
			current_map_key = string.format("ff1_current_map_%d_%d", team, player)
			if not Archipelago:SetNotify({current_map_key}) then
				debugLog(string.format("onClear: failed to subscribe to current map updates"))
			end
			if not Archipelago:Get({current_map_key}) then
				debugLog(string.format("onClear: failed to retrieve current map"))
			end
		else
			debugLog("onClear: cannot subscribe to current map without an Archipelago team and player")
		end
	end
end



function onItem(index, item_id, item_name)
	debugLog(string.format("called onItem: %s, %s, %s, %s", index, item_id, item_name, CUR_INDEX))
	if index <= CUR_INDEX then return end
	CUR_INDEX = index;
	local v = ITEM_MAPPING[item_id]
	if not v then
		debugLog(string.format("onItem: could not find item mapping for id %s", item_id))
		return
	end
	debugLog(string.format("onItem: code: %s, type %s", v[1], v[2]))
	debugLog(string.format("onItem: processing item %s", item_id))
	if not v[1] then
		return
	end
	local obj = Tracker:FindObjectForCode(v[1])
	if obj then
		debugLog(string.format("onItem: Found object %s", obj))
		if v[2] == "toggle" then
			obj.Active = true
			debugLog(string.format("onItem: toggled object %s", v[1]))
		elseif v[2] == "progressive" then
			if obj.Active then
				obj.CurrentStage = obj.CurrentStage + 1
				debugLog(string.format("onItem: progressed object %s to stage %d", v[1], obj.CurrentStage))
			else
				obj.Active = true
				debugLog(string.format("onItem: activated object %s", v[1]))
			end
		elseif v[2] == "consumable" then
			obj.AcquiredCount = obj.AcquiredCount + obj.Increment
		else
			debugLog(string.format("onItem: unknown item type %s for code %s", v[2], v[1]))
		end
	else
		debugLog(string.format("onItem: could not find object for code %s", v[1]))
	end
end

function onLocation(location_id, location_name)
	debugLog(string.format("called onLocation: %s, %s", location_id, location_name))
	local location_array = LOCATION_MAPPING[location_id]
	if not location_array then
		debugLog(string.format("onLocation: could not find location mapping for id %s", location_id))
	end
	if not location_array or not location_array[1] then
		debugLog(string.format("onLocation: could not find location mapping for id %s", location_id))
		return
	end

	for _, location in pairs(location_array) do
		debugLog(string.format("onLocation: processing location %s", location))
		local obj = Tracker:FindObjectForCode(location)
		if obj then
			if location:sub(1,1) == "@" then
				obj.AvailableChestCount = obj.AvailableChestCount - 1
				debugLog(string.format("onLocation: decremented available chest count for %s", location))
			else
				if obj.Active then
					obj.CurrentStage = obj.CurrentStage + 1
					debugLog(string.format("onLocation: progressed location %s to stage %d", location, obj.CurrentStage))
				else
					obj.Active = true
					debugLog(string.format("onLocation: activated location %s", location))
				end
			end
		else
			debugLog(string.format("onLocation: could not find object for code %s", location))
		end
	end
end



function updateGoalStatus(key, value)
	if not goal_status_key or key ~= goal_status_key or value ~= Archipelago.ClientStatus.GOAL then
		return
	end

	local chaos = Tracker:FindObjectForCode("chaos")
	if chaos then
		chaos.Active = true
		debugLog("updateGoalStatus: cleared Chaos")
	else
		print("updateGoalStatus: could not find Chaos item")
	end
end

function onNotify(key, value)
	debugLog(string.format("called onNotify: %s, %s", key, tostring(value)))
	updateGoalStatus(key, value)
	if not current_map_key or key ~= current_map_key or value == nil then
		return
	end
	debugLog(string.format("onNotify: updating map with key %s, value %s", key, tostring(value)))
	updateMap(key, value)
end

function onNotifyLaunch(key, value)
	debugLog(string.format("called onNotifyLaunch: %s, %s", key, tostring(value)))
	updateGoalStatus(key, value)
	if not current_map_key or key ~= current_map_key or value == nil then
		return
	end
	debugLog(string.format("onNotify: updating map with key %s, value %s", key, tostring(value)))
	updateMap(key, value)
end

function updateMap(key, value)
	debugLog(string.format("updateMap: called with key %s, value %s", key, tostring(value)))
	if not current_map_key or key ~= current_map_key or value == nil then
		return
	end
	local tabs = TAB_MAPPING[value]
	if not tabs then
		debugLog(string.format("updateMap: unknown map value %s", tostring(value)))
		return
	end
	for _, tab in ipairs(tabs) do
		Tracker:UiHint("ActivateTab", tab)
		debugLog(string.format("updateMap: activating tab %s", tab))
	end
end

Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
Archipelago:AddSetReplyHandler("notify handler", onNotify)
Archipelago:AddRetrievedHandler("notify launch handler", onNotifyLaunch)