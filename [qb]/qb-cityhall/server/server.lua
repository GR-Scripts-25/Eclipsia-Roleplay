RegisterNetEvent('qb-cityhall:server:ApplyJob', function(id)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end

    local job = Config.jobs[id]
    if not job then return end

    Player.Functions.SetJob(job.job)
    TriggerClientEvent('QBCore:Notify', source, Lang['hired']:format(job.label), 'success')
    TriggerClientEvent("InteractSound_CL:PlayOnOne", source, "cityhall_new_job", 0.1)
end)

RegisterNetEvent('qb-cityhall:server:BuyIdentity', function(id)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local item = Config.items[id]
    if not item then return end

    if not Player.Functions.RemoveMoney('bank', item.price, "Cityhall aankoop") then
        TriggerClientEvent('QBCore:Notify', src, Lang['not_enough_money'], 'error')
        return
    end

    local info = {}
    if item.item == "id_card" then
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.nationality = Player.PlayerData.charinfo.nationality
        Player.Functions.AddItem(item.item, 1, false, info)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.item], 'add')
        TriggerClientEvent('QBCore:Notify', src, Lang['bought']:format(item.label), 'success')
        TriggerClientEvent("InteractSound_CL:PlayOnOne", src, "cityhall_new_idcard", 0.1)
    elseif item.item == "driver_license" then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.type = "Rijbewijs Klasse C"
        Player.Functions.AddItem(item.item, 1, false, info)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.item], 'add')
        TriggerClientEvent('QBCore:Notify', src, Lang['bought']:format(item.label), 'success')
        TriggerClientEvent("InteractSound_CL:PlayOnOne", src, "cityhall_new_license", 0.1)
    elseif item.item == "boat_license" then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.type = "Vaarbewijs"
        Player.Functions.AddItem(item.item, 1, false, info)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.item], 'add')
        TriggerClientEvent('QBCore:Notify', src, Lang['bought']:format(item.label), 'success')
        TriggerClientEvent("InteractSound_CL:PlayOnOne", src, "cityhall_new_license", 0.1)
    elseif item.item == "pilot_license" then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.type = "Vliegbrevet"
        Player.Functions.AddItem(item.item, 1, false, info)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.item], 'add')
        TriggerClientEvent('QBCore:Notify', src, Lang['bought']:format(item.label), 'success')
        TriggerClientEvent("InteractSound_CL:PlayOnOne", src, "heli_ucityhall_new_licensenlock", 0.1)
    elseif item.item == "motor_license" then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.type = "Motorrijbewijs"
        Player.Functions.AddItem(item.item, 1, false, info)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.item], 'add')
        TriggerClientEvent('QBCore:Notify', src, Lang['bought']:format(item.label), 'success')
        TriggerClientEvent("InteractSound_CL:PlayOnOne", src, "cityhall_new_license", 0.1)
    elseif item.item == "truck_license" then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.type = "Vrachtwagenrijbewijs"
        Player.Functions.AddItem(item.item, 1, false, info)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.item], 'add')
        TriggerClientEvent('QBCore:Notify', src, Lang['bought']:format(item.label), 'success')
        TriggerClientEvent("InteractSound_CL:PlayOnOne", src, "cityhall_new_license", 0.1)
    elseif item.item == "weaponlicense" then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        Player.Functions.AddItem(item.item, 1, false, info)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.item], 'add')
        TriggerClientEvent('QBCore:Notify', src, Lang['bought']:format(item.label), 'success')
        TriggerClientEvent("InteractSound_CL:PlayOnOne", src, "pistol_reload", 0.1)
    end
end)
