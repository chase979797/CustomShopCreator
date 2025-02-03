local QBCore = exports['qb-core']:GetCoreObject()

-- Apply clothing when used
RegisterNetEvent('qb-clothing-items:useClothing', function(clothingType)
    local playerPed = PlayerPedId()

    if clothingType == "torso" then
        SetPedComponentVariation(playerPed, 11, 15, 0, 2)
    elseif clothingType == "legs" then
        SetPedComponentVariation(playerPed, 4, 21, 0, 2)
    elseif clothingType == "hat" then
        SetPedPropIndex(playerPed, 0, 5, 0, true)
    elseif clothingType == "jacket" then
        SetPedComponentVariation(playerPed, 9, 2, 0, 2)
    elseif clothingType == "shoes" then
        SetPedComponentVariation(playerPed, 6, 34, 0, 2)
    end

    -- Save clothing to the database
    TriggerServerEvent('qb-clothing-items:saveClothing', {
        torso = GetPedDrawableVariation(playerPed, 11),
        legs = GetPedDrawableVariation(playerPed, 4),
        hat = GetPedPropIndex(playerPed, 0),
        jacket = GetPedDrawableVariation(playerPed, 9),
        shoes = GetPedDrawableVariation(playerPed, 6)
    })

    QBCore.Functions.Notify("You equipped your " .. clothingType, "success")
end)

-- Load clothing when player spawns
AddEventHandler('playerSpawned', function()
    QBCore.Functions.TriggerCallback('qb-clothing-items:getClothing', function(clothing)
        if clothing then
            local ped = PlayerPedId()
            SetPedComponentVariation(ped, 11, clothing.torso or 0, 0, 2)
            SetPedComponentVariation(ped, 4, clothing.legs or 0, 0, 2)
            SetPedPropIndex(ped, 0, clothing.hat or -1, 0, true)
            SetPedComponentVariation(ped, 9, clothing.jacket or 0, 0, 2)
            SetPedComponentVariation(ped, 6, clothing.shoes or 0, 0, 2)
        end
    end)
end)

-- Clothing Shop Marker
CreateThread(function()
    local shop = Config.ClothingShop
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local dist = #(playerCoords - shop.location)

        if dist < 10.0 then
            DrawMarker(shop.marker.type, shop.location.x, shop.location.y, shop.location.z - 1, 0, 0, 0, 0, 0, 0, shop.marker.size, shop.marker.size, 1.0, shop.marker.color.r, shop.marker.color.g, shop.marker.color.b, 100, false, true, 2, nil, nil, false)
            
            if dist < 1.5 then
                QBCore.Functions.DrawText3D(shop.location.x, shop.location.y, shop.location.z, "[E] Open Clothing Shop")

                if IsControlJustReleased(0, 38) then -- E Key
                    OpenClothingShop()
                end
            end
        end
    end
end)

-- Clothing Shop UI
function OpenClothingShop()
    local menu = {}
    for k, v in pairs(Config.ClothingItems) do
        table.insert(menu, {
            header = v.label .. " - $" .. v.price,
            txt = "Purchase this item",
            params = {
                event = "qb-clothing-items:buyClothing",
                args = k
            }
        })
    end
    exports['qb-menu']:openMenu(menu)
end