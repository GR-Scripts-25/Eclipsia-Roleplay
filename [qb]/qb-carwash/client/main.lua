local QBCore = exports['qb-core']:GetCoreObject()

local washingVehicle = false
local WaitingForWash = false

local ptfxData = {
    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {0.0,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },

    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {-0.5,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },

    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {-1.0,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },

    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {-1.5,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },

    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {-2.0,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },


    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {0.5,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },

    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {1.0,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },

    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {1.5,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },

    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {2.0,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },

    {
        dict = 'scr_fbi5a',
        name = 'scr_tunnel_vent_bubbles',
        offset = {0.0,0.0,0.0},
        rot = {0.0,180.0,0.0},
        scale = 2.0,
    },

    {
        dict = 'scr_fbi5a',
        name = 'scr_tunnel_vent_bubbles',
        offset = {0.0,-1.0,0.0},
        rot = {0.0,180.0,0.0},
        scale = 1.0,
    },

    {
        dict = 'scr_fbi5a',
        name = 'scr_tunnel_vent_bubbles',
        offset = {0.0,1.0,0.0},
        rot = {0.0,180.0,0.0},
        scale = 1.0,
    },

    {
        dict = 'scr_fbi5a',
        name = 'scr_tunnel_vent_bubbles',
        offset = {0.0,-2.0,0.0},
        rot = {0.0,180.0,0.0},
        scale = 1.0,
    },

    {
        dict = 'scr_fbi5a',
        name = 'scr_tunnel_vent_bubbles',
        offset = {0.0,2.0,0.0},
        rot = {0.0,180.0,0.0},
        scale = 1.0,
    },
}

local function RequestNetworkControlOfEntity(entity)
    NetworkRequestControlOfEntity(entity)

    local timeout = 2000

    while timeout > 0 and not NetworkHasControlOfEntity(entity) do
        Wait(100)
        timeout = timeout - 100
    end

    timeout = 2000

    SetEntityAsMissionEntity(entity, true, true)

    while timeout > 0 and not IsEntityAMissionEntity(entity) do
        Wait(100)
        timeout = timeout - 100
    end
end

local function RequestParticleFX(dict)
    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do Wait(0) end
end

local function LoadPropDict(model)
    if not IsModelInCdimage(model) then
        print('ERROR: The model that is required does not exist, Contact a developer of the server.')
        return
    end
    local time = 30
    while not HasModelLoaded(model) and time > 0 do RequestModel(model) Wait(100) time -= 1 end
    if time <= 0 then print('ERROR: loading required model failed, Contact a server developer.') end
end

local function CreateProp(model, coords)
    if not HasModelLoaded(model) then; LoadPropDict(model); end
    local prop = CreateObjectNoOffset(model, coords.x, coords.y, coords.z, false, false, false)
    SetEntityAsMissionEntity(prop, true, true)
    FreezeEntityPosition(prop, true)
    SetEntityCollision(prop, false, true)
    return prop
end

RegisterNetEvent('qb-carwash:DoVehicleWashParticles')
AddEventHandler('qb-carwash:DoVehicleWashParticles', function(vehNet, washer, use_props)
    if NetworkDoesEntityExistWithNetworkId(vehNet) then
        if washer == GetPlayerServerId(PlayerId()) then
            WaitingForWash = true
            washer = true 
        end

        local vehicle = NetworkGetEntityFromNetworkId(vehNet)
        local ptfxHandles = {}
        local side_props = nil
        local min_offsets, max_offsets = GetModelDimensions(GetEntityModel(vehicle))

        if use_props then
            local _, max_prop_dim = GetModelDimensions(`prop_carwash_roller_vert`)
            local left_offest = GetOffsetFromEntityInWorldCoords(vehicle, min_offsets.x, min_offsets.y, min_offsets.z - 0.5);left_offest = vector3(left_offest.x + max_prop_dim.x, left_offest.y, left_offest.z)
            local right_offset = GetOffsetFromEntityInWorldCoords(vehicle, max_offsets.x, min_offsets.y, min_offsets.z - 0.5);right_offset = vector3(right_offset.x - max_prop_dim.x, right_offset.y, right_offset.z)

            side_props = {
                {prop = CreateProp(`prop_carwash_roller_vert`, left_offest), offset = vector3(min_offsets.x - (max_prop_dim.x - 0.2), min_offsets.y, max_prop_dim.z/2)},
                {prop = CreateProp(`prop_carwash_roller_vert`, right_offset), offset = vector3(max_offsets.x + (max_prop_dim.x - 0.2), min_offsets.y, max_prop_dim.z/2)},
            }

            for i =1, #side_props, 1 do
                Citizen.CreateThread(function()
                    while side_props and side_props[i] and DoesEntityExist(side_props[i].prop) do
                        if i == 1 then
                            SetEntityHeading(side_props[i].prop, ((GetEntityHeading(side_props[i].prop) + 0.75) + 360) %360)
                        elseif i == 2 then
                            SetEntityHeading(side_props[i].prop, ((GetEntityHeading(side_props[i].prop) - 0.75) + 360) %360)
                        end
                        Citizen.Wait(0)
                    end
                end)
            end
        end

        for index, ptfx in pairs(ptfxData) do
            RequestParticleFX(ptfx.dict)
            UseParticleFxAssetNextCall(ptfx.dict)
            local CreatedParticle = StartNetworkedParticleFxLoopedOnEntity(ptfx.name, vehicle, ptfx.offset[1], ptfx.offset[2], ptfx.offset[3], ptfx.rot[1], ptfx.rot[2], ptfx.rot[3], ptfx.scale, false, false, false)
            table.insert(ptfxHandles, CreatedParticle)
        end

        local offset = min_offsets.y
        local prop_offset = min_offsets.y

        while offset < max_offsets.y and DoesEntityExist(vehicle) do
            for i = 1, #ptfxHandles do
                SetParticleFxLoopedOffsets(ptfxHandles[i], ptfxData[i].offset[1], offset, ptfxData[i].offset[3], ptfxData[i].rot[1], ptfxData[i].rot[2], ptfxData[i].rot[3])
            end

            if side_props ~= nil then
                for i = 1, #side_props, 1 do
                    SetEntityCoordsNoOffset(side_props[i].prop, GetOffsetFromEntityInWorldCoords(vehicle, side_props[i].offset.x, prop_offset, side_props[i].offset.z))
                end
                prop_offset += 0.0055
            end

            offset += 0.0055
            Wait(0)
        end

        if Config.double_clean == true then
            while min_offsets.y < offset and DoesEntityExist(vehicle) do
                for i = 1, #ptfxHandles, 1 do
                    SetParticleFxLoopedOffsets(ptfxHandles[i], ptfxData[i].offset[1], offset, ptfxData[i].offset[3], ptfxData[i].rot[1], ptfxData[i].rot[2], ptfxData[i].rot[3])
                end
                if side_props ~= nil then
                    for i = 1, #side_props, 1 do
                        SetEntityCoordsNoOffset(side_props[i].prop, GetOffsetFromEntityInWorldCoords(vehicle, side_props[i].offset.x, prop_offset, side_props[i].offset.z))
                    end
                    prop_offset -= 0.0055
                end
                offset -= 0.0055
                Wait(0)
            end
        end

        for i = 1, #ptfxHandles do StopParticleFxLooped(ptfxHandles[i], false) end

        if side_props ~= nil then
            for i = 1, #side_props, 1 do DeleteEntity(side_props[i].prop) end
            side_props = nil
        end
        
        if washer == true then
            RequestNetworkControlOfEntity(vehicle)
            SetVehicleDirtLevel(vehicle, 0.0)
            WashDecalsFromVehicle(vehicle, 1.0)
            Wait(1000)
            FreezeEntityPosition(vehicle, false)
            Notify('Vehicle Washed', 'success')
            WaitingForWash = false
            washingVehicle = false
        end
    end
end)

-- Progressbar toevoegen aan WashVehicle
local function WashVehicle(vehicle, use_props)
    if washingVehicle then return end
    washingVehicle = true
    QBCore.Functions.Progressbar('carwash', 'Wasprogramma voorbereiden...', 5000, false, true, {
        disableMovement = false,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerCallback("qb-carwash:CanPurchaseCarWash", function(paid)
            if paid then
                FreezeEntityPosition(vehicle, true)
                TriggerServerEvent('qb-carwash:DoVehicleWashParticles', VehToNet(vehicle), use_props)
            else
                washingVehicle = false
            end
        end)
    end, function() -- Cancel
        washingVehicle = false
        QBCore.Functions.Notify('Wasbeurt geannuleerd', 'error')
    end)
end

-- QBCore en qb-target ophalen
local QBCore = exports['qb-core']:GetCoreObject()
local isQbTargetLoaded = GetResourceState and (GetResourceState('qb-target') == 'started')

-- Carwash target zones toevoegen
Citizen.CreateThread(function()
    if not isQbTargetLoaded then
        print('qb-target niet gevonden!')
        return
    end
    for _, carwash in pairs(Config.locations) do
        exports['qb-target']:AddGlobalVehicle({
            options = {
                {
                    icon = 'fas fa-soap',
                    label = ('Voertuig wassen voor $%s'):format(Config.cost),
                    action = function(entity)
                        local ped = PlayerPedId()
                        if IsPedInAnyVehicle(ped, false) then
                            QBCore.Functions.Notify('Je moet uit het voertuig stappen!', 'error')
                            return
                        end
                        -- Check afstand tot carwash locatie
                        local coords = GetEntityCoords(ped)
                        if #(coords - carwash.location) > 3.0 then
                            QBCore.Functions.Notify('Je bent niet bij de carwash.', 'error')
                            return
                        end
                        WashVehicle(entity, carwash.use_props)
                    end,
                    canInteract = function(entity)
                        local ped = PlayerPedId()
                        if IsPedInAnyVehicle(ped, false) then return false end
                        local coords = GetEntityCoords(ped)
                        return #(coords - carwash.location) <= 3.0
                    end
                }
            },
            distance = 3.0
        })
    end
end)

local function ShowHelpNotification(msg, thisFrame, beep, duration)
	AddTextEntry('HelpNotification', msg)

	if thisFrame then
		DisplayHelpTextThisFrame('HelpNotification', false)
	else
		if (beep == nil or beep == false) then beep = false else beep = true end
		BeginTextCommandDisplayHelp('HelpNotification')
		EndTextCommandDisplayHelp(0, false, beep, duration or -1)
	end
end

local function CreateCarwashBlip(coords, name)
    local blip = AddBlipForCoord(coords)

    SetBlipSprite(blip, 100)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 2)
    SetBlipDisplay(blip, 4)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)

    return blip
end

if Config.show_all_blips then
    local blips = {}

    for _, carwash in pairs(Config.locations) do
        if carwash.show_blip == true then
            blips[#blips +1] = CreateCarwashBlip(carwash.location, carwash.name)
        end
    end
else
    Citizen.CreateThread(function()
        local currentCarWashBlip = nil
        local currentCarWashBlipLocation = nil
    
        while true do
            local coords = GetEntityCoords(PlayerPedId())
            local closest = 999999
            local closestCoords, closestName 
    
            for _, carwash in pairs(Config.locations) do
                local dstcheck = #(coords.xy - carwash.location.xy)
    
                if dstcheck < closest and carwash.show_blip == true then
                    closest = dstcheck
                    closestCoords = carwash.location
                    closestName = carwash.name
                end
            end
    
            if currentCarWashBlipLocation ~= closestCoords then
                if DoesBlipExist(currentCarWashBlip) then RemoveBlip(currentCarWashBlip) end
                currentCarWashBlip = CreateCarwashBlip(closestCoords, closestName)
                currentCarWashBlipLocation = closestCoords
            end
    
            Citizen.Wait(10000)
        end
    end)
end