local function getPlayerServerId(entity)
    local player = NetworkGetPlayerIndexFromPed(entity)
    if player == -1 then return nil end
    return GetPlayerServerId(player)
end

RegisterNetEvent('qboxTargets:client:PlayAnim', function()
    local ped = PlayerPedId()
    lib.playAnim(ped, 'amb@code_human_police_crowd_control@idle_a', 'idle_b', 3.0, 3.0, 3000, 49)
end)

-- PLAYER TARGET OPTIONS
exports.ox_target:addGlobalPlayer({

    {
        name = 'cuff_player',
        icon = 'fa-solid fa-user-lock',
        label = 'Cuff',
        distance = Config.Distance,
        canInteract = function(entity)
            return Config.Enable.cuff
        end,
        onSelect = function(data)
            TriggerEvent('police:client:CuffPlayer')
        end
    },

    {
        name = 'rob_player',
        icon = 'fa-solid fa-mask',
        label = 'Rob',
        distance = Config.Distance,
        canInteract = function(entity)
            return Config.Enable.rob
        end,
        onSelect = function(data)
            TriggerEvent('police:client:RobPlayer')
        end
    },

    {
        name = 'escort_player',
        icon = 'fa-solid fa-user-group',
        label = 'Escort',
        distance = Config.Distance,
        canInteract = function(entity)
            return Config.Enable.escort
        end,
        onSelect = function(data)
            TriggerEvent('police:client:EscortPlayer')
        end
    },

    {
        name = 'kidnap_player',
        icon = 'fa-solid fa-user-group',
        label = 'Kidnap',
        distance = Config.Distance,
        canInteract = function(entity)
            return Config.Enable.kidnap
        end,
        onSelect = function(data)
            TriggerEvent('police:client:KidnapPlayer')
        end
    },

    {
        name = 'hostage_player',
        icon = 'fa-solid fa-child',
        label = 'Take Hostage',
        distance = Config.Distance,
        canInteract = function(entity)
            return Config.Enable.hostage
        end,
        onSelect = function(data)
            TriggerEvent('police:client:TakeHostage')
        end
    },

    {
        name = 'check_health_status',
        icon = 'fa-solid fa-heart-pulse',
        label = 'Check Health Status',
        distance = 2.0,

        canInteract = function(entity)
            return true
        end,

        onSelect = function(data)
            TriggerEvent('hospital:client:CheckStatus')
        end
    },

    {
        name = 'revive_player',
        icon = 'fa-solid fa-user-doctor',
        label = 'Revive',
        groups = 'police',
        distance = 2.0,

        canInteract = function(entity)
            return true
        end,

        onSelect = function(data)
            TriggerEvent('hospital:client:RevivePlayer')
        end
    },

    {
        name = 'treat_wounds',
        icon = 'fa-solid fa-bandage',
        label = 'Heal Wounds',
        groups = 'police',
        distance = 2.0,

        canInteract = function(entity)
            return true
        end,

        onSelect = function(data)
            TriggerEvent('hospital:client:TreatWounds')
        end
    }

})

-- Vehicle target options

exports.ox_target:addGlobalVehicle({
    
    {
        name = 'put_player_vehicle',
        icon = 'fa-solid fa-car-side',
        label = 'Seat In Vehicle',
        distance = Config.Distance,
        canInteract = function(entity)
            return Config.Enable.putInVehicle
        end,
        onSelect = function(data)
            TriggerEvent('police:client:PutPlayerInVehicle')
        end
    },

    {
        name = 'remove_player_vehicle',
        icon = 'fa-solid fa-car-side',
        label = 'Unseat From Vehicle',
        distance = Config.Distance,
        canInteract = function(entity)
            return Config.Enable.takeOutVehicle
        end,
        onSelect = function(data)
            TriggerEvent('police:client:SetPlayerOutVehicle')
        end
    },

    {
        name = 'get_in_trunk',
        icon = 'fa-solid fa-car',
        label = 'Get In Trunk',
        distance = 1.5,

        canInteract = function(entity, distance, coords)
            local boneIndex = GetEntityBoneIndexByName(entity, 'boot')
            if boneIndex == -1 then return false end

            local trunkCoords = GetWorldPositionOfEntityBone(entity, boneIndex)

            if #(coords - trunkCoords) < 1.5 then
                return true
            end

            return false
        end,

        onSelect = function(data)
            TriggerEvent('qb-trunk:client:GetIn', data.entity)
        end
    },

    {
        name = 'police_unlock_vehicle',
        icon = 'fa-solid fa-unlock',
        label = 'Unlock Vehicle',
        distance = 2.5,
        groups = 'police',

        canInteract = function(entity)
            if not entity then return false end

            return GetVehicleDoorLockStatus(entity) == 2
        end,

        onSelect = function(data)
            local vehicle = data.entity
            if not vehicle then return end

            lib.playAnim(cache.ped, 'anim@mp_player_intmenu@key_fob@', 'fob_click', 3.0, 3.0, 4000, 49)

            local success = lib.progressBar({
                duration = 4000,
                label = 'Using FOB Decoder...',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    move = true,
                    car = true,
                    combat = true
                }
            })

            ClearPedTasks(cache.ped)

            if not success then return end

            local netId = NetworkGetNetworkIdFromEntity(vehicle)

            -- QBX unlock
            TriggerServerEvent('qb-vehiclekeys:server:setVehLockState', netId, 1)

            -- 💡 Lights
            SetVehicleLights(vehicle, 2)
            Wait(250)
            SetVehicleLights(vehicle, 1)
            Wait(200)
            SetVehicleLights(vehicle, 0)

            exports.qbx_core:Notify('Decode Successful! Vehicle unlocked')
        end
    },

    {
    name = 'checkVehicleStatus',
    icon = 'fas fa-car',
    label = 'Check Vehicle Status',
    distance = 2.5,
        onSelect = function(data)
            local vehicle = data.entity
            if not vehicle or vehicle == 0 then return end

            lib.playAnim(cache.ped, 'cellphone@', 'cellphone_text_read_base', 3.0, 3.0, 3000, 49)
            Wait(500)
            local success = lib.progressBar({
                duration = 3000,
                label = 'Checking Status...',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    move = true,
                    car = true,
                    combat = true
                }
            })

            ClearPedTasks(cache.ped)

            local plate = GetVehicleNumberPlateText(vehicle)
            local status = exports['qbx_mechanicjob']:GetVehicleStatusList(plate)

            if not status then
                lib.notify({
                    title = 'Vehicle Status',
                    description = 'No data found',
                    type = 'error'
                })
                return
            end

            local options = {}

            for part, value in pairs(status) do
                options[#options + 1] = {
                    title = part:gsub("^%l", string.upper), -- capitalize
                    description = ('Condition: %s'):format(value),
                    icon = 'wrench'
                }
            end

            lib.registerContext({
                id = 'vehicle_status_menu',
                title = ('Vehicle Status [%s]'):format(plate),
                options = options
            })

            lib.showContext('vehicle_status_menu')
        end
    },

})