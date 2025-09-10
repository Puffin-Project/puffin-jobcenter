local ped

RegisterNUICallback('puffin:jobcenter:selectJob', function(data, cb)
    local jobName = data.job
    local job = Config.Jobs[jobName]

    if not job then
        Notify(Lang.job_error, 'error')
        return
    end

    if job.setJob then
        TriggerServerEvent('puffin-jobcenter:server:setJob', jobName)
    end

    if job.coords then
        SetNewWaypoint(job.coords.x, job.coords.y)
        Notify(Lang.coords_set:format(job.title))
    else
        Notify(Lang.coords_error, 'error')
    end

    cb({ ok = true })
end)

RegisterNUICallback('puffin:jobcenter:close', function(_, cb)
    SetNuiFocus(false, false)
    cb({ ok = true })
end)

RegisterNetEvent('puffin-jobcenter:client:open', function()
    OpenJobCenter()
end)

if Config.OpenMethod == 'command' then
    RegisterCommand(Config.Command, function()
        OpenJobCenter()
    end, false)
    TriggerEvent('chat:addSuggestion', '/' .. Config.Command, Lang.cmd_suggestion)
elseif Config.OpenMethod == 'npc' then
    CreateThread(function()
        local model = GetHashKey(Config.PedModel)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(50)
        end
        ped = CreatePed(0, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z, Config.PedCoords.w, false, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskStartScenarioInPlace(ped, Config.PedScenario, 0, true)
        FreezeEntityPosition(ped, true)

        if Config.Target == 'qb-target' then
            exports['qb-target']:AddTargetEntity(ped, {
                options = {
                    {
                        type = 'client',
                        event = 'puffin-jobcenter:client:open',
                        icon = 'fas fa-briefcase',
                        label = Lang.target_label,
                    },
                },
                distance = 2.5,
            })
        elseif Config.Target == 'ox_target' then
            exports.ox_target:addLocalEntity(ped, {
                {
                    name = 'jobcenter_npc',
                    icon = 'fas fa-briefcase',
                    label = Lang.target_label,
                    onSelect = OpenJobCenter,
                }
            })
        elseif Config.Target == 'esx-interact' then
            CreateThread(function() 
                while true do
                    local playerPed = PlayerPedId()
                    local playerCoords = GetEntityCoords(playerPed)
                    local pedCoords = vector3(Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z + 1.0)

                    if #(playerCoords - pedCoords) < 3.0 then
                        ESX.ShowFloatingHelpNotification(Lang.target_label .. ' [E]', pedCoords) 

                        if IsControlJustReleased(0, 38) then -- E
                            OpenJobCenter()
                        end

                        Wait(0)
                    else
                        Wait(1000)
                    end
                end
            end)
        end

        if Config.JobCenterBlip.enable then
            CreateBlip()
        end

    end) 
end   

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
        if Config.OpenMethod == 'npc' then
            if Config.Target == 'qb-target' then
                exports['qb-target']:RemoveTargetEntity(ped)
            elseif Config.Target == 'ox_target' then
                exports.ox_target:removeLocalEntity(ped, 'jobcenter_npc')
            end
        end
        if DoesBlipExist(JobCenterBlip) then
            RemoveBlip(JobCenterBlip)
        end
    end
end)