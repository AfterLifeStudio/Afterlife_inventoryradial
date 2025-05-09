local InventoryBridge = {}
InventoryBridge.__index = InventoryBridge


function InventoryBridge:new()
    local inventory, type = nil, nil

    if GetResourceState("LGF_Inventory"):find("start") then
        inventory = exports.LGF_Inventory
        type = "LGF"
    elseif GetResourceState("ox_inventory"):find("start") then
        inventory = exports.ox_inventory
        type = "OX"
    else
        error("Setup your Inventory in client.invBridge.lua")
    end

    local self = setmetatable({
        inv = inventory,
        type = type
    }, InventoryBridge)

    return self
end

function InventoryBridge:getItems()
    if self.type == "OX" then
        return self.inv:GetPlayerItems() or {}
    elseif self.type == "LGF" then
        return self.inv:getPlayerItems() or {}
    end
end

function InventoryBridge:useItem(slot)
    print(slot)
    if self.type == "OX" then
        self.inv:useSlot(slot)
    elseif self.type == "LGF" then
        self.inv:useItem(slot)
    elseif self.type == "custom" then
    end
end

function InventoryBridge:getImage(item)
    if self.type == "OX" then
        return ('nui://ox_inventory/web/images/%s.png'):format(item.name)
    elseif self.type == "LGF" then
        return ('nui://LGF_Inventory/web/images/%s.png'):format(item.itemName)
    elseif self.type == "custom" then
        return ""
    end
end

function InventoryBridge:isInvOpened()
    if self.type == "OX" then
        return LocalPlayer.state.invOpen
    elseif self.type == "LGF" then
        return exports.LGF_Inventory:isInventoryOpen()
    elseif self.type == "custom" then
        return ""
    end
end

return InventoryBridge
