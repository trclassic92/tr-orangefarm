Config = {}

Config.Framework = "QB"      -- ESX = ESX Framework  | QB for QBRemastered and QBCore
Config.Target = "OX"         -- OX - OX Target | QB - QB Target (Only works for QB)

Config.UseBlips = true -- True turns blips on | false turns blips off

Config.MinDistance = 2.5 -- Minimal distance from the tree to collect (Exploiter Check)

Config.Blips = {
    Field = {
        label = "Orange Field", -- Blip label
        coords = vector3(2328.89, 5006.94, 42.32), -- Coords  for blips
        sprite = 1, -- Blip Spirte
        colour = 44, -- Blip color
        scale = 0.85, -- Blip Scale
        display = 6, -- Blip Display
    },
    Processing = {
        label = "Orange Processing",
        coords = vector4(2588.99, 3168.56, 50.94 - 1, 323.14),
        sprite = 280,
        colour = 44,
        scale = 0.85,
        display = 6,
    },
    Seller = {
        label = "Orange Seller",
        coords = vector4(-379.55, 275.34, 84.76 - 1, 36.14),
        sprite = 605,
        colour = 44,
        scale = 0.85,
        display = 6,
    }
}

Config.PedModel = "a_m_m_farmer_01" -- Ped model

Config.Picking = {
    CirlceMinigame = {
        minSeconds = 7, -- Min Seconds for mini game
        maxSeconds = 15, -- Max Seconds for mini game
        minCircles = 2, -- Min CircleMinigame
        maxCircles = 4, -- Max CircleMinigame
    },
    ReceiveItem = {
        minAmount = 2, -- Min Amount you can pick
        maxAmount = 5, -- Max Amount you can pick
    }
}

Config.Processing = {
    pressingConfig = {
        timer = 5000,
        amount = 5, -- Amount needed to press into orange juice
        receiving = 1, -- Amount to receive ( 1 Orange Juice)
    }
}

Config.SellPrice = {
    Raworanges = {
        min = 25,
        max = 45
    },
    Juice = {
        min = 50,
        max = 65,
    }
}

Config.OXTarget = {
    processingCoords = vec3(2588.99, 3168.56, 50.94 - 1), -- Ox Target Placement
    processingHeading = 323.14,
    sellingCoords = vector3(-379.55, 275.34, 84.76 - 1),
    sellingHeading = 36.14,
}

Config.Text = { -- Text / langs
    -- Target label
    PickOrange = "Pick Fresh Oranges",
    SellOrangesLabel = "Sell Oranges",
    ProcessingLabel = "Process Orange's",
    SellJuice = "Sell Juice",

    -- Other Text
    PickedOranges = "You have picked ",
    ProcessingNotification = "Pressing Oranges",
    OrangesProcessed = "Amount of oranges pressed ",
    OrangesProcessed1 = " into orange juice",
    successfully_sold = "You have sold raw oranges",
    successfully_sold1 = "You have sold bottles of fresh juice",

    -- Error
    FailedPickingOranges = "Failed to pick oranges",
    CancelledProcessing = "Cancelled",
    ErrorProcessingAmount = "Don't have enough oranges",
    NoItem = "You don't have any oranges"
}
