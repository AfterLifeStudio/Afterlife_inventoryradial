local nuiMessage = function(action, data)
    SendNUIMessage({
        action = action,
        data = data,
    })
end

local state = false

local openradial = function()
    if state then return end
    state = true

    TriggerScreenblurFadeIn(200.0)

    local items = exports.ox_inventory:GetPlayerItems()

    local options = {}



    for i = 1, 8 do
        options[#options + 1] = {
            slot = #options + 1,
        }
    end

    for k,data in pairs(items) do
        if data then
            if data.slot < 9 then
                options[data.slot] = {
                    slot = data.slot,
                    count = data.count,
                    name = data.label,
                    imageurl = 'nui://ox_inventory/web/images/' .. data.name .. '.png'
                }
            end
        end
    end

    PlaySoundFrontend(-1, "TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)

    nuiMessage('setup:radial', {
        visible = true,
        options = options,
    })

    SetCursorLocation(0.5, 0.5)

    CreateThread(function()
        while state do
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

local closeradial = function()
    if not state then return end
    state = false
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
    state = false
    exports.ox_inventory:useSlot(data)
    cb({})
end)



lib.addKeybind({
    name = 'inventoryradial',
    description = 'press F1 to toggle radial',
    defaultKey = 'f2',
    onPressed = openradial,
    onReleased = closeradial
})
