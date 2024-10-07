local GreenZone = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
    for i = 1, #Config.Zones do
        local zone = Config.Zones[i]
        local data = zone.box
        local allowedJobs = zone.allowedjob
        local coords = data.coords

        local function isPlayerAllowedInZone()
            if ESX.PlayerData.job then
                for _, job in pairs(allowedJobs) do
                    if ESX.PlayerData.job.name == job then
                        return true
                    end
                end
            end
            return false
        end

        local function onEnterZone()
            if not isPlayerAllowedInZone() then
                GreenZone = true
                SetCanAttackFriendly(PlayerPedId(), false, false)
                NetworkSetFriendlyFireOption(false)
            end
            GreenZone = true
        end

        local function onExitZone()
            EnableControlAction(0, 24, true)
            EnableControlAction(0, 257, true)
            EnableControlAction(0, 25, true) 
            EnableControlAction(0, 263, true) 
            DisablePlayerFiring(PlayerId(), false) 
            SetCanAttackFriendly(PlayerPedId(), true, false)
            NetworkSetFriendlyFireOption(true)
            GreenZone = false
        end

        local function insideZone()
            if GreenZone and not isPlayerAllowedInZone() then
                DisableControlAction(0, 24, true) 
                DisableControlAction(0, 257, true)
                DisableControlAction(0, 25, true)
                DisableControlAction(0, 263, true) 
                DisablePlayerFiring(PlayerId(), true)
            end
        end

        if data.type == 'box' then
            lib.zones.box({
                coords = coords,
                size = data.size,
                rotation = 45,
                debug = data.debug,
                inside = function()
                    if not GreenZone and not isPlayerAllowedInZone() then
                        GreenZone = true
                        ESX.ShowNotification('Wkroczyłeś do Zielonej Strefy.')
                    end
                    insideZone()
                end,
                onEnter = function()
                    if not GreenZone then
                        ESX.ShowNotification('Wkroczyłeś do Zielonej Strefy.')
                        onEnterZone()
                    end
                end,
                onExit = function()
                    if GreenZone then
                        ESX.ShowNotification('Opuściłeś Zieloną Strefę.')
                        onExitZone() 
                    end
                end
            })
        elseif data.type == 'sphere' then
            lib.zones.sphere({
                coords = coords,
                radius = data.radius,
                debug = data.debug,
                inside = function()
                    if not GreenZone and not isPlayerAllowedInZone() then
                        GreenZone = true
                        ESX.ShowNotification('Wkroczyłeś do Zielonej Strefy.')
                    end
                    insideZone()
                end,
                onEnter = function()
                    if not GreenZone then
                        ESX.ShowNotification('Wkroczyłeś do Zielonej Strefy.')
                        onEnterZone()
                    end
                end,
                onExit = function()
                    if GreenZone then
                        ESX.ShowNotification('Opuściłeś Zieloną Strefę.')
                        onExitZone()
                    end
                end
            })
        end

        local blipData = zone.blip
        if blipData then
            if data.type == 'sphere' then
                local radiusBlip = AddBlipForRadius(coords.x, coords.y, coords.z, data.radius * 1.0) 
                SetBlipColour(radiusBlip, blipData.color or 1)
                SetBlipAlpha(radiusBlip, 128)

                local blipMarker = AddBlipForCoord(coords.x, coords.y, coords.z)
                SetBlipSprite(blipMarker, blipData.sprite or 1)
                SetBlipDisplay(blipMarker, 4)
                SetBlipScale(blipMarker, blipData.scale or 1.0)
                SetBlipColour(blipMarker, blipData.color or 1)
                SetBlipAsShortRange(blipMarker, true)

                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(blipData.name or "Zielona Strefa")
                EndTextCommandSetBlipName(blipMarker)


            elseif data.type == 'box' then
                local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                SetBlipSprite(blip, blipData.sprite or 1)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, blipData.scale or 1.0)
                SetBlipColour(blip, blipData.color or 1)
                SetBlipAsShortRange(blip, true)

                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(blipData.name or "Zielona Strefa")
                EndTextCommandSetBlipName(blip)
            end
        end
    end
end)