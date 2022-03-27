ESX = nil

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('JRC_lockpick:NiceLockpick')
AddEventHandler('JRC_lockpick:NiceLockpick', function()
    local vehicle, dist = ESX.Game.GetClosestVehicle()

    if dist < 2 and vehicle > 0 then
        ClearPedTasks(PlayerPedId())
        Wait(100)
        local VehicleIsMaybeLocked = GetVehicleDoorLockStatus(vehicle)
        if VehicleIsMaybeLocked == 2 then
            TriggerServerEvent('JRC_lockpick:TryLockpickvehicle', VehToNet(vehicle), GetVehicleDoorLockStatus(vehicle))
        else
            if Config.UseNotify then
                if Config.Notify == 'ox' then
                    TriggerEvent('ox_inventory:notify', {type = 'error', text = Locale('can_not_lockpick_now')})
                elseif Config.Notify == 'mythic' then
                    exports['mythic_notify']:SendAlert('error', Locale('can_not_lockpick_now'))
                elseif Config.Notify == 'esx' then
                    ESX.ShowNotification(Locale('can_not_lockpick_now'))
                elseif Config.Notify == 'drx' then
                    TriggerServerEvent('drx_notify:server', 'Lockpick', Locale('can_not_lockpick_now'), "")
                end
            end
        end
    end
end)

RegisterNetEvent('JRC_lockpick:Lockpickvehicle', function(netId, lockStatus)
    local vehicle = NetToVeh(netId)
    if DoesEntityExist(vehicle) then
        if Config.UseProgressBar then
            if Config.ProgressBar == 'ox' then
                exports.ox_inventory:Progress({
                    duration = Config.progressBarDuration*1000,
                    label = Locale('lockpicking_car'),
                    useWhileDead = false,
                    canCancel = false,
                    disable = {
                        move = true,
                        car = true,
                        combat = true,
                        mouse = false
                    },
                    anim = {
                        dict = 'mini@repair',
                        clip = 'fixing_a_ped',
                        flags = 49,
                    },
                }, function(cancel)
                end)
            elseif Config.ProgressBar == 'progressBars' then
                exports['progressBars']:startUI(Config.progressBarDuration*1000, Locale('lockpicking_car'))
                local playerPed = PlayerPedId()
                RequestAnimDict('mini@repair')
                while not HasAnimDictLoaded('mini@repair') do
                    Citizen.Wait(100)
                end
                TaskPlayAnim(playerPed, 'mini@repair', 'fixing_a_ped', 2.0, 2.0, Config.progressBarDuration*1000, 1, 0, false, false, false)
            elseif Config.ProgressBar == 'mythic' then
                exports['mythic_progbar']:Progress({
                    name = "lockpicking_vehicle",
                    duration = Config.progressBarDuration*1000,
                    label = Locale('lockpicking_car'),
                    useWhileDead = false,
                    canCancel = false,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                    animation = {
                        animDict = "mini@repair",
                        anim = "fixing_a_ped",
                        flags = 49,
                    },
                })
            elseif Config.ProgressBar == 'rprogress' then
                exports.rprogress:Custom(
                    {
                        Async = true,
				        Duration = Config.progressBarDuration*1000,
                        Label = Locale("lockpicking_car"),
				        Easing = "easeLinear",
                        DisableControls = {
                                Mouse = false,
                                Player = true,
                                Vehicle = true
                        }
                    })
                local playerPed = PlayerPedId()
                RequestAnimDict('mini@repair')
                while not HasAnimDictLoaded('mini@repair') do
                    Citizen.Wait(100)
                end
                TaskPlayAnim(playerPed, 'mini@repair', 'fixing_a_ped', 2.0, 2.0, Config.progressBarDuration*1000, 1, 0, false, false, false)
            elseif Config.ProgressBar == 'pogressbar' then
                exports['pogressBar']:drawBar(Config.progressBarDuration*1000, Locale("lockpicking_car"))
                local playerPed = PlayerPedId()
                RequestAnimDict('mini@repair')
                while not HasAnimDictLoaded('mini@repair') do
                    Citizen.Wait(100)
                end
                TaskPlayAnim(playerPed, 'mini@repair', 'fixing_a_ped', 2.0, 2.0, Config.progressBarDuration*1000, 1, 0, false, false, false)
            end
        end
        local ped = PlayerPedId()
        local player = source
        local pedicek = GetPlayerPed(player)
        local playerCoords = GetEntityCoords(ped)
        TriggerEvent('JRC_lockpick:policenotify', playerCoords)


        Wait(Config.progressBarDuration*1000)
        if Config.UseNotify then
            if Config.Notify == 'ox' then
                TriggerEvent('ox_inventory:notify', {type = 'success', text = Locale('succ_unlocked')})
            elseif Config.Notify == 'mythic' then
                exports['mythic_notify']:SendAlert('success', Locale('succ_unlocked'))
            elseif Config.Notify == 'esx' then
                ESX.ShowNotification(Locale('succ_unlocked'))
            elseif Config.Notify == 'drx' then
                TriggerServerEvent('drx_notify:server', 'Lockpick', Locale('succ_unlocked'), "")
            end
        end
        PlayVehicleDoorCloseSound(vehicle, 1)
        SetVehicleDoorsLockedForAllPlayers(vehicle, false)
    end
end)

RegisterNetEvent("JRC_lockpick:policenotify")
AddEventHandler("JRC_lockpick:policenotify", function()
	if Config.EnablePoliceNotify then
    	local player = ESX.GetPlayerData()
		local playerCoords = GetEntityCoords(PlayerPedId())
		local data = {displayCode = '10-16', description = Locale('vehicle_lock_theft_police_notify'), isImportant = 1, recipientList = {'police'}, length = '4000'}
		local dispatchData = {dispatchData = data, caller = 'Local', coords = playerCoords}
		TriggerServerEvent('wf-alerts:svNotify', dispatchData)
	end
end)
