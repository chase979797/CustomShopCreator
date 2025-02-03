local QBCore = exports['qb-core']:GetCoreObject()

-- Register usable items
for itemName, itemData in pairs(Config.ClothingItems) do
    QBCore.Functions.CreateUseableItem(itemName, function(source, item)
        TriggerClientEvent('qb-clothing-items:useClothing', source, itemData.type)
    end)
end

-- Save clothing to the database
RegisterNetEvent('qb-clothing-items:saveClothing', function(clothingData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        MySQL.Async.execute('REPLACE INTO player_clothing (citizenid, clothing) VALUES (?, ?)', {
            Player.PlayerData.citizenid,
            json.encode(clothingData)
        })
    end
end)

-- Load clothing when player logs in
QBCore.Functions.CreateCallback('qb-clothing-items:getClothing', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        MySQL.Async.fetchScalar('SELECT clothing FROM player_clothing WHERE citizenid = ?', {
            Player.PlayerData.citizenid
        }, function(result)
            cb(result and json.decode(result) or nil)
        end)
    end
end)

-- Purchase clothing
RegisterNetEvent('qb-clothing-items:buyClothing', function(itemName)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = Config.ClothingItems[itemName]

    if Player and item then
        if Player.Functions.RemoveMoney('cash', item.price) then
            Player.Functions.AddItem(itemName, 1)
            TriggerClientEvent('QBCore:Notify', src, "You bought a " .. item.label, "success")
        else
            TriggerClientEvent('QBCore:Notify', src, "Not enough money!", "error")
        end
    end
end)