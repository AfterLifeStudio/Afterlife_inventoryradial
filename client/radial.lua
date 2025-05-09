local Inventory = require "client.invBridge":new()

LocalPlayer.state.radialBusy = false

local function nuiMessage(action, data)
    SendNUIMessage({ action = action, data = data })
end

local function openradial()
    if LocalPlayer.state.radialBusy then return end
    local isInvOpened = Inventory:isInvOpened()
    if isInvOpened then return end

    LocalPlayer.state.radialBusy = true

    TriggerScreenblurFadeIn(200.0)

    local items = Inventory:getItems()
    local options = {}

    for i = 1, 8 do
        options[i] = { slot = i }
    end

    for _, item in ipairs(items) do
        local slot = item.slot or item.slotId
        if slot and slot < 9 then
            options[slot] = {
                slot = slot,
                count = item.count or item.quantity,
                name = item.label or item.itemLabel,
                imageurl = Inventory:getImage(item)
            }
        end
    end

    table.sort(options, function(a, b)
        return a.slot < b.slot
    end)

    PlaySoundFrontend(-1, "TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)

    nuiMessage('setup:radial', {
        visible = true,
        options = options,
    })

    SetCursorLocation(0.5, 0.5)

    CreateThread(function()
        while LocalPlayer.state.radialBusy do
            DisablePlayerFiring(cache.playerId, true)
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(2, 199, true)
            DisableControlAction(2, 200, true)
            Wait(0)
        end
    end)
end

local function closeradial()
    if not LocalPlayer.state.radialBusy then return end
    LocalPlayer.state.radialBusy = false
    PlaySoundFrontend(-1, "TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
    TriggerScreenblurFadeOut(200.0)
    SetNuiFocus(false, false)
    nuiMessage('setup:radial', {
        visible = false,
        options = false,
    })
end

RegisterNUICallback('useitem', function(data, cb)
    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
    TriggerScreenblurFadeOut(0)
    SetNuiFocus(false, false)
    LocalPlayer.state.radialBusy = true

    Inventory:useItem(data)
    cb({ success = true })
end)

lib.addKeybind({
    name = 'inventoryradial',
    description = 'Press F3 to toggle radial',
    defaultKey = 'f3',
    onPressed = openradial,
    onReleased = closeradial
})


exports("toggleRadial", openradial)
