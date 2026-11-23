local cardia_boxes = {
	{ "Grass Island", "Entrance" },
	{ "Grass Island", "Duo Room 1" },
	{ "Grass Island", "Duo Room 2" },
	{ "Swamp Island", "Chest 1" },
	{ "Swamp Island", "Chest 2" },
	{ "Swamp Island", "Chest 3" },
	{ "Forest Island", "Entrance 1" },
	{ "Forest Island", "Entrance 2" },
	{ "Forest Island", "Entrance 3" },
	{ "Forest Island", "Incentive 1" },
	{ "Forest Island", "Incentive 2" },
	{ "Forest Island", "Incentive 3" },
	{ "Forest Island", "Incentive Major" }
}

local counterparts = {}

local function find_section(id)
	local section = Tracker:FindObjectForCode("@" .. id)
	if not section or section.FullID ~= id then
		error("Cardia box section not found: " .. id)
	end
	return section
end

for _, box in ipairs(cardia_boxes) do
	local island, name = box[1], box[2]
	local cardia_id = "Cardia Islands/" .. name .. "/Cardia " .. island .. " - " .. name
	local bahamut_id = "Bahamut's Lair/Bahamut's Hoard - " .. name .. "/Bahamut's Hoard " .. island .. " - " .. name
	local cardia = find_section(cardia_id)
	local bahamut = find_section(bahamut_id)

	if cardia.ChestCount ~= bahamut.ChestCount or cardia.ChestCount == 0 then
		error("Cardia box sections have incompatible chest counts: " .. cardia_id .. " and " .. bahamut_id)
	end
	counterparts[cardia_id] = bahamut
	counterparts[bahamut_id] = cardia
end

local function update_cardia_boxes(section)
	local other = counterparts[section.FullID]
	if other and other.AvailableChestCount ~= section.AvailableChestCount then
		other.AvailableChestCount = section.AvailableChestCount
	end
end

ScriptHost:AddOnLocationSectionChangedHandler("update_cardia_boxes", update_cardia_boxes)
