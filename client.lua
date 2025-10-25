local ESX = exports['es_extended']:getSharedObject()

-- 🔹 Command & Keymapping
RegisterCommand("vehiclelock", function()
    AttemptVehicleLockToggle()
end, false)

RegisterKeyMapping("vehiclelock", "Fahrzeug Schlüssel", "keyboard", "")

-- 🔹 Funktion: Fahrzeug auf-/abschließen
function AttemptVehicleLockToggle()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    -- Wenn Spieler nicht im Fahrzeug sitzt, suche in der Nähe
    if vehicle == 0 then
        local coords = GetEntityCoords(playerPed)
        local radius = 5.0
        local vehicles = GetGamePool("CVehicle")

        for _, veh in ipairs(vehicles) do
            if #(coords - GetEntityCoords(veh)) < radius then
                vehicle = veh
                break
            end
        end
    end

    -- Wenn Fahrzeug gefunden → Server-Event triggern
    if vehicle and vehicle ~= 0 then
        local netId = NetworkGetNetworkIdFromEntity(vehicle)
        TriggerServerEvent("vehiclekeys:tryUnlock", netId)
    else
        ESX.ShowNotification("Kein Fahrzeug in der Nähe.")
    end
end

-- 🔹 Event: Fahrzeug auf-/abschließen
RegisterNetEvent("vehiclekeys:unlock")
AddEventHandler("vehiclekeys:unlock", function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    -- Wenn Spieler nicht im Fahrzeug sitzt, suche in der Nähe
    if vehicle == 0 then
        local coords = GetEntityCoords(playerPed)
        local radius = 5.0
        local vehicles = GetGamePool("CVehicle")

        for _, veh in ipairs(vehicles) do
            if #(coords - GetEntityCoords(veh)) < radius then
                vehicle = veh
                break
            end
        end
    end

    -- Fahrzeug gefunden → Lockstatus umschalten
    if vehicle and vehicle ~= 0 then
        local locked = GetVehicleDoorLockStatus(vehicle)

        -- 🔹 Lade Animation (Schlüssel-Fernbedienung)
        RequestAnimDict("anim@mp_player_intmenu@key_fob@")
        while not HasAnimDictLoaded("anim@mp_player_intmenu@key_fob@") do
            Wait(10)
        end

        -- 🔹 Spiele Animation ab
        TaskPlayAnim(playerPed, "anim@mp_player_intmenu@key_fob@", "fob_click_fp", 8.0, -8.0, -1, 48, 0, false, false, false)

        -- 🔹 Lockstatus toggeln
        if locked == 1 or locked == 0 then
            SetVehicleDoorsLocked(vehicle, 2)
            SetVehicleDoorsLockedForAllPlayers(vehicle, true)
            ESX.ShowNotification("Fahrzeug abgeschlossen.")
        else
            SetVehicleDoorsLocked(vehicle, 1)
            SetVehicleDoorsLockedForAllPlayers(vehicle, false)
            ESX.ShowNotification("Fahrzeug aufgeschlossen.")
        end

        -- 🔹 Warte kurz und beende Animation
        Wait(1000)
        ClearPedTasks(playerPed)
    else
        ESX.ShowNotification("Kein Fahrzeug in der Nähe.")
    end
end)

-- 🔹 Event: Modell vom Fahrzeug anfordern
RegisterNetEvent("vehiclekeys:requestModel")
AddEventHandler("vehiclekeys:requestModel", function(netId)
    local vehicle = NetToVeh(netId)
    if DoesEntityExist(vehicle) then
        local modelHash = GetEntityModel(vehicle)
        TriggerServerEvent("vehiclekeys:checkJobVehicle", netId, modelHash)
    end
end)
