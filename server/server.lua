ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('buyWater')
AddEventHandler('buyWater', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = Config.PriceWater
    xPlayer.removeMoney(price)
    xPlayer.addInventoryItem('water', 50)
end)

RegisterNetEvent('buyLevure')
AddEventHandler('buyLevure', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = Config.PriceLevure
    xPlayer.removeMoney(price)
    xPlayer.addInventoryItem('levure', 50)
end)

RegisterNetEvent('buyBarquette')
AddEventHandler('buyBarquette', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = Config.PriceBarquette
    xPlayer.removeMoney(price)
    xPlayer.addInventoryItem('barquette_vide', 100)
end)

