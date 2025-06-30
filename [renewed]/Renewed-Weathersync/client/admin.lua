-- Weather Admin Management --
local weatherTypes = {
    {
        label = 'Sneeuwstorm',
        value = 'BLIZZARD'
    },
    {
        label = 'Helder',
        value = 'CLEAR'
    },
    {
        label = 'Opklarend',
        value = 'CLEARING'
    },
    {
        label = 'Wolken',
        value = 'CLOUDS'
    },
    {
        label = 'Zonnig',
        value = 'EXTRASUNNY'
    },
    {
        label = 'Mistig',
        value = 'FOGGY'
    },
    {
        label = 'Neutraal',
        value = 'NEUTRAL'
    },
    {
        label = 'Bewolkt',
        value = 'OVERCAST'
    },
    {
        label = 'Regen',
        value = 'RAIN'
    },
    {
        label = 'Smog',
        value = 'SMOG'
    },
    {
        label = 'Sneeuw',
        value = 'SNOW'
    },
    {
        label = 'Lichte sneeuw',
        value = 'SNOWLIGHT'
    },
    {
        label = 'Onweer',
        value = 'THUNDER'
    },
    {
        label = 'Kerst',
        value = 'XMAS'
    },
}

local function viewWeatherEvent(index, weatherEvent, isQueued)
    local metadata = isQueued and {
        ('Weer %s'):format(weatherEvent.weather),
        ('Duurt nog %s minuten'):format(weatherEvent.time)
    } or {
        ('Weer %s'):format(weatherEvent.weather),
        ('%s minuten resterend'):format(weatherEvent.time)
    }
    lib.registerContext({
        id = 'Renewed-Weathersync:client:changeWeather',
        title = 'Verander Weer',
        menu = 'Renewed-Weathersync:client:manageWeather',
        options = {
            {
                title = 'Info',
                icon = 'fa-solid fa-circle-info',
                readOnly = true,
                metadata = metadata
            },
            {
                title = 'Verander Weer',
                icon = 'fa-solid fa-cloud',
                arrow = true,
                onSelect = function()
                    local input = lib.inputDialog('Verander Weertype', {
                        {
                            label = 'Selecteer Weer',
                            type = 'select',
                            required = true,
                            default = weatherEvent.weather,
                            options = weatherTypes
                        },
                    })

                    if input and input[1] then
                        local weather = lib.callback.await('Renewed-Weathersync:server:setWeatherType', false, index, input[1])

                        if weather then
                            weatherEvent.weather = weather
                        end
                    end

                    viewWeatherEvent(index, weatherEvent)
                end
            },
            {
                title = 'Verander Duur',
                arrow = true,
                icon = 'fa-solid fa-hourglass-half',
                onSelect = function()
                    local input = lib.inputDialog('Verander Duur', {
                        {
                            label = 'Duur in minuten',
                            type = 'slider',
                            required = true,
                            min = 1,
                            max = 120,
                            default = weatherEvent.time,
                        },
                    })

                    if input and input[1] then
                        local time = lib.callback.await('Renewed-Weathersync:server:setEventTime', false, index, input[1])

                        if time then
                            weatherEvent.time = time
                        end
                    end

                    viewWeatherEvent(index, weatherEvent)
                end
            },
            {
                title = 'Verwijder Weerevent',
                arrow = true,
                icon = 'fa-solid fa-circle-xmark',
                onSelect = function()
                    TriggerServerEvent('Renewed-Weather:server:removeWeatherEvent', index)
                end
            }
        }
    })

    lib.showContext('Renewed-Weathersync:client:changeWeather')
end

RegisterNetEvent('Renewed-Weather:client:viewWeatherInfo', function(weatherTable)
    local options = {}
    local amt = 0

    local startingIn = 0

    for i = 1, #weatherTable do
        local currentWeather = weatherTable[i]
        amt += 1

        local isQueued = i > 1

        local meatadata = isQueued and {
            ('Start over %s minuten'):format(startingIn),
            ('Duurt nog %s minuten'):format(currentWeather.time)
        } or {
            ('%s minuten resterend'):format(currentWeather.time)
        }

        options[amt] = {
            title = isQueued and ('Aankomend Weer: %s'):format(currentWeather.weather) or ('Huidig Weer: %s'):format(currentWeather.weather),
            description = isQueued and ('Start over %s minuten'):format(startingIn),
            arrow = true,
            icon = isQueued and 'fa-solid fa-cloud-arrow-up' or 'fa-solid fa-cloud',
            metadata = meatadata,
            onSelect = function()
                viewWeatherEvent(i, currentWeather, isQueued)
            end
        }

        startingIn += currentWeather.time
    end


    lib.registerContext({
        id = 'Renewed-Weathersync:client:manageWeather',
        title = 'Weerbeheer',
        options = options
    })

    lib.showContext('Renewed-Weathersync:client:manageWeather')
end)