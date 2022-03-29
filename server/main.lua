ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('JRC_lockpick:TryLockpickvehicle', function(netId, lockstatus)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if GetVehicleDoorLockStatus(vehicle, true) then
        SetVehicleDoorsLocked(vehicle, 0)
        TriggerClientEvent('JRC_lockpick:Lockpickvehicle', xPlayer.source, netId, lockstatus ~= 2)
        xPlayer.removeInventoryItem(Config.LockPickItem, 1)
    end
end)

ESX.RegisterUsableItem('lockpick', function (source)

    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerClientEvent('JRC_lockpick:NiceLockpick', source)
end)

print('^5Made By JRC scripts^7: ^1'..GetCurrentResourceName()..'^7 started ^2successfully^7...')
