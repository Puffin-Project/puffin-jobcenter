if Config.Framework == 'qb' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'esx' then
    ESX = exports['es_extended']:getSharedObject()
end

RegisterNetEvent('puffin-jobcenter:server:setJob', function(jobName)
    local src = source
    local job = Config.Jobs and Config.Jobs[jobName]
    if not job or not job.setJob then return end
    if Config.Framework == 'qb' then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then
            Player.Functions.SetJob(jobName, 0)
            TriggerClientEvent('QBCore:Notify', src, Lang.job_set:format(jobName), 'success')
        end
    elseif Config.Framework == 'qbx' then
        local Player = exports.qbx_core:GetPlayer(src)
        if Player then
            exports.qbx_core:SetJob(src, jobName, 0)
            exports.qbx_core:Notify(src, Lang.job_set:format(jobName), 'success')
        end
    elseif Config.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            xPlayer.setJob(jobName, 0)
            TriggerClientEvent('esx:showNotification', src, Lang.job_set:format(jobName))
        end
    end
end)