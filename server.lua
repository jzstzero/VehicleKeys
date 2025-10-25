local vehicleOwners = {}

--  Server-Event: vehicle lock check
RegisterServerEvent("vehiclekeys:tryUnlock")
AddEventHandler("vehiclekeys:tryUnlock", function(netId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not netId or not xPlayer then return end

    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if not vehicle or vehicle == 0 then
        TriggerClientEvent("esx:showNotification", src, "Kein gültiges Fahrzeug gefunden.")
        return
    end

    local plate = GetVehicleNumberPlateText(vehicle)
    if not plate or plate == "" then
        TriggerClientEvent("esx:showNotification", src, "Fahrzeug hat kein Kennzeichen.")
        return
    end

    --  Check if vehicle is a private vehicle
    MySQL.Async.fetchScalar('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function(owner)
        if owner and owner == xPlayer.identifier then
            TriggerClientEvent("vehiclekeys:unlock", src)
            return
        end

        --  if not private vehicle, check if job vehicle
        local jobName = xPlayer.job.name
        local allowedModels = Config.JobVehicles[jobName]
        if not allowedModels then
            TriggerClientEvent("esx:showNotification", src, "Du hast keinen Schlüssel für dieses Fahrzeug!")
            return
        end

        TriggerClientEvent("vehiclekeys:requestModel", src, netId)
    end)
end)

--  Server-Event: check job vehicle and model hash
RegisterServerEvent("vehiclekeys:checkJobVehicle")
AddEventHandler("vehiclekeys:checkJobVehicle", function(netId, modelHash)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local jobName = xPlayer.job.name
    local allowedModels = Config.JobVehicles[jobName]
    if not allowedModels then
        TriggerClientEvent("esx:showNotification", src, "Du hast keinen Schlüssel für dieses Fahrzeug!")
        return
    end

    for spawnName, data in pairs(allowedModels) do
        local expectedHash = GetHashKey(spawnName)
        if tonumber(modelHash) == tonumber(expectedHash) then
            TriggerClientEvent("vehiclekeys:unlock", src)
            return
        end
    end

    TriggerClientEvent("esx:showNotification", src, "Du hast keinen Schlüssel für dieses Fahrzeug!")
end)