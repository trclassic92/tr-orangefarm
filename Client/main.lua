local PedCoords = Config.Blips.Processing.coords
local PedCoords1 = Config.Blips.Seller.coords
local PedModel = Config.PedModel
local busy = false

-- Blip
if Config.UseBlips then
    CreateThread(function()
        for _, v in pairs(Config.Blips) do
            local Blips = AddBlipForCoord(v.coords)
            SetBlipSprite(Blips, v.sprite)
            SetBlipDisplay(Blips, v.display)
            SetBlipColour(Blips, v.colour)
            SetBlipScale(Blips, v.scale)
            SetBlipAsShortRange(Blips, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(v.label)
            EndTextCommandSetBlipName(Blips)
        end
    end)
end

local function LoadESXVersion()
    ESX = exports["es_extended"]:getSharedObject()
    -- Peds
    CreateThread(function()
        RequestModel(PedModel)
        while (not HasModelLoaded(PedModel)) do
            Wait(1)
        end
        OrangeFarmer1 = CreatePed(1, PedModel, PedCoords, false, true)
        OrangeFarmer2 = CreatePed(1, PedModel, PedCoords1, false, true)
        SetEntityInvincible(OrangeFarmer1, true)
        SetBlockingOfNonTemporaryEvents(OrangeFarmer1, true)
        FreezeEntityPosition(OrangeFarmer1, true)
        SetEntityInvincible(OrangeFarmer2, true)
        SetBlockingOfNonTemporaryEvents(OrangeFarmer2, true)
        FreezeEntityPosition(OrangeFarmer2, true)
    end)

    CreateThread(function()
        for _, v in pairs(OrangeTrees) do
            exports.ox_target:addBoxZone({
                coords = vec3(v.coords.x, v.coords.y, v.coords.z),
                size = v.size,
                rotation = v.heading,
                debug = false,
                options = {
                    {
                        name = v.name,
                        event = 'tr-orangefarm:PickingOranges',
                        icon = 'fa-solid fa-hand',
                        label = Config.Text["PickOrange"],
                    }
                }
            })
        end
    end)

    exports.ox_target:addBoxZone({
        coords = Config.OXTarget.processingCoords,
        size = vec3(1, 1, 4),
        rotation = Config.OXTarget.processingHeading,
        debug = false,
        options = {
            {
                name = 'ProcessingOrange',
                event = 'tr-orangefarm:ProcessOrange',
                icon = 'fa-solid fa-filter',
                label = Config.Text["ProcessingLabel"],
            },
            {
                name = 'SellingRawOranges',
                event = 'tr-orangefarm:SellRawOrange',
                icon = 'fa-solid fa-hand-holding-dollar',
                label = Config.Text["SellOrangesLabel"],
            }
        }
    })

    exports.ox_target:addBoxZone({
        coords = Config.OXTarget.sellingCoords,
        size = vec3(1, 1, 4),
        rotation = Config.OXTarget.sellingHeading,
        debug = false,
        options = {
            {
                name = 'selljuices',
                event = 'tr-orangefarm:SellingJuice',
                icon = 'fa-solid fa-bottle-water',
                label = Config.Text["SellJuice"],
            }
        }
    })

    --Orange Picking Event
    RegisterNetEvent('tr-orangefarm:PickingOranges', function()
        if busy then return end
        busy = true
        local Ped = PlayerPedId()
        local time = math.random(Config.Picking.CirlceMinigame.minSeconds, Config.Picking.CirlceMinigame.maxSeconds)
        local circles = math.random(Config.Picking.CirlceMinigame.minCircles, Config.Picking.CirlceMinigame.maxCircles)
        local success = exports['CircleMinigame']:StartLockPickCircle(circles, time, success)
        if success then
            lib.progressCircle({
                FreezeEntityPosition(Ped, true),
                duration = 2500,
                position = 'bottom',
                useWhileDead = false,
                canCancel = false,
                disable = {
                    car = true,
                },
                anim = {
                    dict = 'missmechanic',
                    clip = 'work_base'
                },
                prop = {
                    model = `ng_proc_food_ornge1a`,
                    pos = vec3(0.03, 0.03, 0.03),
                    rot = vec3(0.0, 0.0, -1.5)
                },
            })
            TriggerServerEvent('tr-orangefarm:GratherOrange')
        else
            ESX.ShowNotification(Config.Text["FailedPickingOranges"], "error")
        end
        FreezeEntityPosition(Ped, false)
        busy = false
    end)

    --Processing Event
    RegisterNetEvent('tr-orangefarm:ProcessOrange', function()
        if busy then return end
        local Ped = PlayerPedId()
        FreezeEntityPosition(Ped, true)
        busy = true
        if lib.progressCircle({
            duration = Config.Processing.pressingConfig.timer,
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
            },
            anim = {
                dict = 'missfam4',
                clip = 'base'
            },
            prop = {
                model = `p_amb_clipboard_01`,
                pos = vec3(0.00, 0.00, 0.00),
                rot = vec3(0.0, 0.0, -1.5)
            },
        })
        then
            TriggerServerEvent("tr-orangefarm:TradingToOrangeJuice")
        else
            ESX.ShowNotification(Config.Text["CancelledProcessing"], "error")
        end
        FreezeEntityPosition(Ped, false)
        busy = false
    end)

    RegisterNetEvent('tr-orangefarm:SellRawOrange', function()
        if busy then return end
        local Ped = PlayerPedId()
        FreezeEntityPosition(Ped, true)
        busy = true
        if lib.progressCircle({
            duration = 4000,
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
            },
            anim = {
                dict = 'missfam4',
                clip = 'base'
            },
            prop = {
                model = `p_amb_clipboard_01`,
                pos = vec3(0.00, 0.00, 0.00),
                rot = vec3(0.0, 0.0, -1.5)
            },
        })
        then
            TriggerServerEvent("tr-orangefarm:SellingRawOrange")
        else
            ESX.ShowNotification(Config.Text["CancelledProcessing"], "error")
        end
        FreezeEntityPosition(Ped, false)
        busy = false
    end)

    RegisterNetEvent('tr-orangefarm:SellingJuice', function()
        if busy then return end
        busy = true
        local Ped = PlayerPedId()
        FreezeEntityPosition(Ped, true)
        if lib.progressCircle({
            duration = 4000,
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
            },
            anim = {
                dict = 'missfam4',
                clip = 'base'
            },
            prop = {
                model = `p_amb_clipboard_01`,
                pos = vec3(0.00, 0.00, 0.00),
                rot = vec3(0.0, 0.0, -1.5)
            },
        })
        then
            TriggerServerEvent("tr-orangefarm:SellingJuices")
        else
            ESX.ShowNotification(Config.Text["CancelledProcessing"], "error")
        end
        FreezeEntityPosition(Ped, false)
        busy = false
    end)
end

local function LoadQBVersion()
    local QBCore = exports['qb-core']:GetCoreObject()
    -- Peds
    CreateThread(function()
        RequestModel(PedModel)
        while (not HasModelLoaded(PedModel)) do
            Wait(1)
        end
        OrangeFarmer1 = CreatePed(1, PedModel, PedCoords, false, true)
        OrangeFarmer2 = CreatePed(1, PedModel, PedCoords1, false, true)
        SetEntityInvincible(OrangeFarmer1, true)
        SetBlockingOfNonTemporaryEvents(OrangeFarmer1, true)
        FreezeEntityPosition(OrangeFarmer1, true)
        SetEntityInvincible(OrangeFarmer2, true)
        SetBlockingOfNonTemporaryEvents(OrangeFarmer2, true)
        FreezeEntityPosition(OrangeFarmer2, true)
    end)

    if Config.Target == "OX" then
        CreateThread(function()
            for _, v in pairs(OrangeTrees) do
                exports.ox_target:addBoxZone({
                    coords = vec3(v.coords.x, v.coords.y, v.coords.z),
                    size = v.size,
                    rotation = v.heading,
                    debug = false,
                    options = {
                        {
                            name = v.name,
                            event = 'tr-orangefarm:PickingOranges',
                            icon = 'fa-solid fa-hand',
                            label = Config.Text["PickOrange"],
                        }
                    }
                })
            end
        end)

        exports.ox_target:addBoxZone({
            coords = Config.OXTarget.processingCoords,
            size = vec3(1, 1, 4),
            rotation = Config.OXTarget.processingHeading,
            debug = false,
            options = {
                {
                    name = 'ProcessingOrange',
                    event = 'tr-orangefarm:ProcessOrange',
                    icon = 'fa-solid fa-filter',
                    label = Config.Text["ProcessingLabel"],
                },
                {
                    name = 'SellingRawOranges',
                    event = 'tr-orangefarm:SellRawOrange',
                    icon = 'fa-solid fa-hand-holding-dollar',
                    label = Config.Text["SellOrangesLabel"],
                }
            }
        })

        exports.ox_target:addBoxZone({
            coords = Config.OXTarget.sellingCoords,
            size = vec3(1, 1, 4),
            rotation = Config.OXTarget.sellingHeading,
            debug = false,
            options = {
                {
                    name = 'selljuices',
                    event = 'tr-orangefarm:SellingJuice',
                    icon = 'fa-solid fa-bottle-water',
                    label = Config.Text["SellJuice"],
                }
            }
        })
    elseif Config.Target == "QB" then
        CreateThread(function()
            for _, v in pairs(OrangeTrees) do
                exports['qb-target']:AddBoxZone("Trees" .. v.name, vector3(v.coords.x, v.coords.y, v.coords.z), v.size.x, v.size.y, {
                    name = "tree".. v.name,
                    heading = v.heading,
                    debugPoly = false,
                    minZ = v.coords.z - 2,
                    maxZ = v.coords.z + 2,
                  },{
                    options = {
                      {
                        type = "client",
                        name = v.name,
                        event = 'tr-orangefarm:PickingOranges',
                        icon = 'fa-solid fa-hand',
                        label = Config.Text["PickOrange"],
                      },
                    },
                  distance = v.distance,
                })
            end
        end)
        exports['qb-target']:AddBoxZone("Processor", vector3(Config.OXTarget.processingCoords.x, Config.OXTarget.processingCoords.y, Config.OXTarget.processingCoords.z), 1, 1, {
            name = "Processed",
            heading = Config.OXTarget.processingHeading,
            debugPoly = false,
            minZ = Config.OXTarget.processingCoords.z - 2,
            maxZ = Config.OXTarget.processingCoords.z + 2,
            },{
            options = {
                {
                type = "client",
                name = 'ProcessingOrange',
                event = 'tr-orangefarm:ProcessOrange',
                icon = 'fa-solid fa-filter',
                label = Config.Text["ProcessingLabel"],
                },
                {
                type = "client",
                name = 'SellingRawOranges',
                event = 'tr-orangefarm:SellRawOrange',
                icon = 'fa-solid fa-hand-holding-dollar',
                label = Config.Text["SellOrangesLabel"],
                }
            },
            distance = 1.5,
        })
        exports['qb-target']:AddBoxZone("Seller", vector3(Config.OXTarget.sellingCoords.x, Config.OXTarget.sellingCoords.y, Config.OXTarget.sellingCoords.z), 1, 1, {
            name = "Seller",
            heading = Config.OXTarget.sellingHeading,
            debugPoly = false,
            minZ = Config.OXTarget.sellingCoords.z - 2,
            maxZ = Config.OXTarget.sellingCoords.z + 2,
          },{
            options = {
              {
                type = "client",
                name = 'selljuices',
                event = 'tr-orangefarm:SellingJuice',
                icon = 'fa-solid fa-bottle-water',
                label = Config.Text["SellJuice"],
              },
            },
          distance = 1.5,
        })
    end

    --Orange Picking Event
    RegisterNetEvent('tr-orangefarm:PickingOranges', function()
        if busy then return end
        busy = true
        local Ped = PlayerPedId()
        local time = math.random(Config.Picking.CirlceMinigame.minSeconds, Config.Picking.CirlceMinigame.maxSeconds)
        local circles = math.random(Config.Picking.CirlceMinigame.minCircles, Config.Picking.CirlceMinigame.maxCircles)
        local success = exports['CircleMinigame']:StartLockPickCircle(circles, time, success)
        if success then
            lib.progressCircle({
                FreezeEntityPosition(Ped, true),
                duration = 2500,
                position = 'bottom',
                useWhileDead = false,
                canCancel = false,
                disable = {
                    car = true,
                },
                anim = {
                    dict = 'missmechanic',
                    clip = 'work_base'
                },
                prop = {
                    model = `ng_proc_food_ornge1a`,
                    pos = vec3(0.03, 0.03, 0.03),
                    rot = vec3(0.0, 0.0, -1.5)
                },
            })
            TriggerServerEvent('tr-orangefarm:GratherOrange')
        else
            TriggerEvent("QBCore:Notify", Config.Text["FailedPickingOranges"], "error")
        end
        FreezeEntityPosition(Ped, false)
        busy = false
    end)

    --Processing Event
    RegisterNetEvent('tr-orangefarm:ProcessOrange', function()
        if busy then return end
        busy = true
        local Ped = PlayerPedId()
        FreezeEntityPosition(Ped, true)
        if lib.progressCircle({
            duration = Config.Processing.pressingConfig.timer,
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
            },
            anim = {
                dict = 'missfam4',
                clip = 'base'
            },
            prop = {
                model = `p_amb_clipboard_01`,
                pos = vec3(0.00, 0.00, 0.00),
                rot = vec3(0.0, 0.0, -1.5)
            },
        })
        then
            TriggerServerEvent("tr-orangefarm:TradingToOrangeJuice")
        else
            TriggerEvent("QBCore:Notify", Config.Text["CancelledProcessing"], "error")
        end
        FreezeEntityPosition(Ped, false)
        busy = false
    end)

    RegisterNetEvent('tr-orangefarm:SellRawOrange', function()
        if busy then return end
        busy = true
        local Ped = PlayerPedId()
        FreezeEntityPosition(Ped, true)
        if lib.progressCircle({
            duration = 4000,
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
            },
            anim = {
                dict = 'missfam4',
                clip = 'base'
            },
            prop = {
                model = `p_amb_clipboard_01`,
                pos = vec3(0.00, 0.00, 0.00),
                rot = vec3(0.0, 0.0, -1.5)
            },
        })
        then
            TriggerServerEvent("tr-orangefarm:SellingRawOrange")
        else
            TriggerEvent("QBCore:Notify", Config.Text["CancelledProcessing"], "error")
        end
        FreezeEntityPosition(Ped, false)
        busy = false
    end)

    RegisterNetEvent('tr-orangefarm:SellingJuice', function()
        if busy then return end
        busy = true
        local Ped = PlayerPedId()
        FreezeEntityPosition(Ped, true)
        if lib.progressCircle({
            duration = 4000,
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
            },
            anim = {
                dict = 'missfam4',
                clip = 'base'
            },
            prop = {
                model = `p_amb_clipboard_01`,
                pos = vec3(0.00, 0.00, 0.00),
                rot = vec3(0.0, 0.0, -1.5)
            },
        })
        then
            TriggerServerEvent("tr-orangefarm:SellingJuices")
        else
            TriggerEvent("QBCore:Notify", Config.Text["CancelledProcessing"], "error")
        end
        FreezeEntityPosition(Ped, false)
        busy = false
    end)
end

if Config.Framework == "ESX" then
    LoadESXVersion()
elseif Config.Framework == "QB" then
    LoadQBVersion()
end
