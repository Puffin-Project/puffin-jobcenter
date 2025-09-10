JobCenterBlip = nil

if Config.Framework == 'qb' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'esx' then
    ESX = exports['es_extended']:getSharedObject()
end

function GetPlayerName()
    if Config.Framework == 'qb' then
        local Player = QBCore.Functions.GetPlayerData()
        return Player.charinfo.firstname
    elseif Config.Framework == 'qbx' then
        local Player = exports.qbx_core:GetPlayerData()
        return Player.charinfo.firstname
    elseif Config.Framework == 'esx' then
        return ESX.PlayerData.firstName
    end
    return 'Unknown'
end

function GetCurrentJob()
    if Config.Framework == 'qb' then
        local Player = QBCore.Functions.GetPlayerData()
        return Player.job.name
    elseif Config.Framework == 'qbx' then
        local Player = exports.qbx_core:GetPlayerData()
        return Player.job.name
    elseif Config.Framework == 'esx' then
        return ESX.PlayerData.job.name
    end
    return 'Unemployed'
end

function OpenJobCenter()
    local jobsList = {}
    for name, job in pairs(Config.Jobs or {}) do
        jobsList[name] = {
            setJob = job.setJob,
            title = job.title,
            image = job.image,
            description = job.description,
            color = job.color
        }
    end

    local payload = {
            config = {
                Title = Config.Title,
                Jobs = jobsList
            },
            player = {
                name = GetPlayerName(),
                currentJob = GetCurrentJob()
            }
        }

    SendNUIMessage({ action = 'open', payload = payload })
    SetNuiFocus(true, true)
end

function Notify(msg, type, duration)
    if Config.Framework == 'qb' then
        QBCore.Functions.Notify(msg, type or 'success', duration or 5000)
    elseif Config.Framework == 'qbx' then
        exports.qbx_core:Notify(msg, type or 'success', duration or 5000)
    elseif Config.Framework == 'esx' then
        ESX.ShowNotification(msg, type, duration or 5000, Config.Title, "top-left") 
    end
end

function CreateBlip()
    JobCenterBlip = AddBlipForCoord(Config.PedCoords)
    SetBlipSprite(JobCenterBlip, Config.JobCenterBlip.sprite)
    SetBlipDisplay(JobCenterBlip, 4)
    SetBlipScale(JobCenterBlip, Config.JobCenterBlip.scale)
    SetBlipAsShortRange(JobCenterBlip, true)
    SetBlipColour(JobCenterBlip, Config.JobCenterBlip.color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Title)
    EndTextCommandSetBlipName(JobCenterBlip)
end

exports('OpenJobCenter', OpenJobCenter)