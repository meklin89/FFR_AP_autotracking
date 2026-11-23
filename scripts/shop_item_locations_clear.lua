-- Script to update shop item locations based on the state of the shop item
function updateAllShopItemLocations()
    local shopItemState = Tracker:FindObjectForCode("shopItem")
    if not shopItemState then
        debugLog("updateAllShopItemLocations: shopItem object not found")
        return
    end

    local isActive = shopItemState.Active
    local shopItemArray = LOCATION_MAPPING[767] or {}
    for _, shopLocation in pairs(shopItemArray) do
        local obj = Tracker:FindObjectForCode(shopLocation)
        if not obj then
            debugLog(string.format("updateAllShopItemLocations: could not find object for code %s", shopLocation))
        elseif shopLocation:sub(1, 1) == "@" then
            if isActive then
                obj.AvailableChestCount = obj.AvailableChestCount - 1
                debugLog(string.format("updateAllShopItemLocations: decremented available chest count for %s", shopLocation))
            else
                obj.AvailableChestCount = obj.ChestCount
                debugLog(string.format("updateAllShopItemLocations: reset chest count for %s", shopLocation))
            end
        else
            obj.Active = isActive
            debugLog(string.format("updateAllShopItemLocations: %s location %s", isActive and "activated" or "deactivated", shopLocation))
        end
    end
end

local shopItemRef = ScriptHost:AddWatchForCode("watch_for_shop_item", "shopItem", updateAllShopItemLocations)