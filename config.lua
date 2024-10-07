Config = {}

Config.Framework = 'ESX'

Config.Zones = {
    {
        blip = {
            sprite = 439,
            scale = 1.0,
            color = 2,
            name = "Komenda LSPD"
        },
        allowedjob = {'police'}, 
        box = {
            type = 'sphere',
            coords = vector3(442.5363, -1017.666, 28.65637),
            radius = 50, 
            debug = true,
        }
    },
    {
        blip = {
            sprite = 439,
            scale = 1.0,
            color = 3,
            name = "Komenda EMS"
        },
        allowedjob = {'ambulance', 'mechanic'},
        box = {
            type = 'box',
            coords = vector3(325.5898, -211.2397, 54.0801),
            size = vec3(50, 50, 50), 
            rotation = 45,
            debug = true,
        }
    }
}