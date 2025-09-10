Config = {}

-- Options: 'qb', 'qbx', 'esx'
Config.Framework = 'qb'

-- Options: 'command', 'npc'
Config.OpenMethod = 'npc'

-- Only if OpenMethod is 'command'
Config.Command = 'jobcenter'

-- Options: 'qb-target', 'ox_target', 'esx-interact'
Config.Target = 'qb-target'

-- Ped settings (only if OpenMethod is 'npc')
Config.PedModel = 'a_m_y_business_03'
Config.PedCoords = vector4(-254.0360, -970.3759, 30.2200, 161.4314)
Config.PedScenario = 'WORLD_HUMAN_CLIPBOARD'

-- UI Title
Config.Title = 'Job Center'

-- Configure jobs here
Config.Jobs = {
    ['taxi'] = {
        setJob = true, -- If false, it won't set the job, just mark the location
        title = 'Taxi Driver',
        image = 'images/taxi.png',
        description = 'Drive around the city and pick up passengers to earn money.',
        color = 'FF5D0D',
        coords = vector3(895.32, -179.23, 74.70),
    },
    ['garbage'] = {
        setJob = false,
        title = 'Garbage Collector',
        image = 'images/garbage.png',
        description = 'Keep the city clean. Collect trash around neighborhoods and get paid per route.',
        color = '00D084',
        coords = vector3(-350.0, -1568.0, 25.2),
    },
    ['delivery'] = {
        setJob = true,
        title = 'Delivery Driver',
        image = 'images/delivery.png',
        description = 'Deliver packages to various locations around the city and earn money.',
        color = 'FF5733',
        coords = vector3(123.45, -456.78, 34.56),
    },
    ['fisherman'] = {
        setJob = false,
        title = 'Fisherman',
        image = 'images/fisherman.png',
        description = 'Catch fish and sell them at the market to make a living.',
        color = '3498DB',
        coords = vector3(-1600.0, 5200.0, 3.0),
    },
    ['farmer'] = {
        setJob = false,
        title = 'Farmer',
        image = 'images/farmer.png',
        description = 'Cultivate crops and raise livestock to supply food to the city.',
        color = '228B22',
        coords = vector3(2500.0, 4000.0, 35.0),
    },
}

-- Configure blip for job center
-- https://docs.fivem.net/docs/game-references/blips/
Config.JobCenterBlip = {
    enable = true,
    sprite = 351,
    color = 81,
    scale = 0.8,
}

-- Enable or disable update checker
Config.UpdateChecker = true