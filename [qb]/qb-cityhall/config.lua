QBCore = exports['qb-core']:GetCoreObject()

Config = {}

-- Ped spawner
Config.ped = {
    enabled = true,
    model = "a_m_m_indian_01",
    coords = vector4(-266.88833618164, -961.62231445313, 30.227128982544, 210.22946166992),
    label = "Open cityhall"
}

Config.blip = {
    enabled = true,
    Name = "Cityhall",
    SpriteId = 487,
    Color = 4,
    Scale = 0.65,
    ShortRange = true,
    Alpha = 255,
    Coords = vector3(-266.88833618164, -961.62231445313, 31.227128982544)
}

-- Jobs for hire
Config.jobs = {
    {
        job = "trucker",
        label = "Trucker",
        salary = 50
    },
    {
        job = "taxi",
        label = "Taxi",
        salary = 50
    },
    {
        job = "tow",
        label = "Tow Truck",
        salary = 50
    },
    {
        job = "reporter",
        label = "News Reporter",
        salary = 50
    },
}

-- Items for purchase
Config.items = { {
        item = "id_card",
        meta = 'id',
        label = "ID Kaart",
        price = 100
    }, {
        item = "driver_license",
        label = "Rijbewijs Klasse C",
        meta = 'driver',
        price = 100
    }, {
        item = "boat_license",
        label = "Vaarbewijs",
        meta = 'boat',
        price = 100
    }, {
        item = "pilot_license",
        label = "Vliegbrevet",
        meta = 'pilot',
        price = 100
    }, {
        item = "motor_license",
        label = "Motorrijbewijs",
        meta = 'motor',
        price = 100
    }, {
        item = "truck_license",
        label = "Vrachtwagenrijbewijs",
        meta = 'truck',
        price = 100
    }, {
        item = "weaponlicense",
        label = "Wapenvergunning",
        meta = 'weapon',
        price = 100
    } 
}

-- Items shown in the information tab
Config.licenseItems = { {
        item = 'id_card',
        label = 'ID Kaart'
    }, {
        item = 'driver_license',
        label = 'Rijbewijs Klasse C'
    }, {
        item = 'boat_license',
        label = 'Vaarbewijs'
    }, {
        item = 'pilot_license',
        label = 'Vliegbrevet'
    }, {
        item = 'motor_license',
        label = 'Motorrijbewijs'
    }, {
        item = 'truck_license',
        label = 'Vrachtwagenrijbewijs'
    }, {
        item = 'weaponlicense',
        label = 'Wapenvergunning'
    } 
}

