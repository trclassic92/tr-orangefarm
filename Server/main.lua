local function checkDistance()
    local src = source
    local ped = GetPlayerPed(src)
    local check = GetEntityCoords(ped)
    local distanceCheck = Config.MinDistance
        for _,v in pairs(OrangeTrees) do
            if #(check - v.coords) < distanceCheck then
                return true
            end
        return false
    end
end

local function LoadESXVersion()
    ESX = exports["es_extended"]:getSharedObject()

    RegisterNetEvent('tr-orangefarm:GratherOrange', function()
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local orange = math.random(Config.Picking.ReceiveItem.minAmount, Config.Picking.ReceiveItem.maxAmount)
        if checkDistance then
            xPlayer.addInventoryItem('orange', orange)
            TriggerClientEvent('esx:showNotification', src, Config.Text["PickedOranges"], "success")
        else
            return false
        end
    end)

    RegisterNetEvent('tr-orangefarm:TradingToOrangeJuice', function()
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local orange = xPlayer.getInventoryItem('orange')
        local processingAmount = Config.Processing.pressingConfig.amount
        local receivingItem = Config.Processing.pressingConfig.receiving
        if orange.count < 1 then
            TriggerClientEvent('esx:showNotification', src, Config.Text["ErrorProcessingAmount"], "error")
        end
        local amount = orange.count
        if amount >= 1 then
            amount = processingAmount
        else
            return false
        end
        if orange.count >= amount then
            xPlayer.removeInventoryItem(orange, processingAmount)
            TriggerClientEvent('esx:showNotification', src, Config.Text["OrangesProcessed"] .. processingAmount .. Config.Text["OrangesProcessed1"], "success")
            Wait(50)
            xPlayer.addInventoryItem('orange_juice', receivingItem)
        else
            TriggerClientEvent('esx:showNotification', src, Config.Text["ErrorProcessingAmount"], "error")
            return false
        end
    end)

    SellOranges = {
        orange = math.random(Config.SellPrice.Raworanges.min, Config.SellPrice.Raworanges.max)
    }

    RegisterNetEvent('tr-orangefarm:SellingRawOrange', function()
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local price = 0
        for k, v in pairs(SellOranges) do
            local orange = xPlayer.getInventoryItem(k)
            if orange and orange.count >= 1 then
                price = price + (v * orange.count)
                xPlayer.removeInventoryItem(k, orange.count)
            end
        end
        if price > 0 then
            xPlayer.addMoney(price)
            TriggerClientEvent('esx:showNotification', src, Config.Text["successfully_sold"], "success")
        else
            TriggerClientEvent('esx:showNotification', src, Config.Text["NoItem"], "error")
        end
    end)

    SellJuice = {
        orange_juice = math.random(Config.SellPrice.Juice.min, Config.SellPrice.Juice.max)
    }

    RegisterNetEvent('tr-orangefarm:SellingJuices', function()
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local price = 0
        for k, v in pairs(SellJuice) do
            local orangejuice = xPlayer.getInventoryItem(k)
            if orangejuice and orangejuice.count >= 1 then
                price = price + (v * orangejuice.count)
                xPlayer.removeInventoryItem(k, orangejuice.count)
            end
        end
        if price > 0 then
            xPlayer.addMoney(price)
            TriggerClientEvent('esx:showNotification', src, Config.Text["successfully_sold1"], "success")
        else
            TriggerClientEvent('esx:showNotification', src, Config.Text["NoItem"], "error")
        end
    end)
end

local function LoadQBVersion()
    local QBCore = exports['qb-core']:GetCoreObject()
    RegisterNetEvent('tr-orangefarm:GratherOrange', function()
        local src = source
        local Player = QBCore.Functions.GetPlayer(tonumber(source))
        local orange = math.random(Config.Picking.ReceiveItem.minAmount, Config.Picking.ReceiveItem.maxAmount)
        if checkDistance then
                Player.Functions.AddItem('orange', orange)
                TriggerClientEvent('QBCore:Notify', src, Config.Text["PickedOranges"], "success")
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['orange'], "add")
        else
            return false
        end
    end)

    RegisterServerEvent('tr-orangefarm:TradingToOrangeJuice', function()
        local src = source
        local Player = QBCore.Functions.GetPlayer(tonumber(source))
        local orange = Player.Functions.GetItemByName('orange')
        local processingAmount = Config.Processing.pressingConfig.amount
        local receivingItem = Config.Processing.pressingConfig.receiving
        if not orange then
            TriggerClientEvent('QBCore:Notify', src, Config.Text['NoItem'], "error")
            return false
        end

        local amount = orange.amount
        if amount >= 1 then
            amount = processingAmount
        else
          return false
        end

        if not Player.Functions.RemoveItem('orange', amount) then
            TriggerClientEvent('QBCore:Notify', src, Config.Text['NoItem'], "error")
            return false
        end

        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['orange'], "remove")
        TriggerClientEvent('QBCore:Notify', src, Config.Text["OrangesProcessed"] .. processingAmount .. Config.Text["OrangesProcessed1"], "success")
        Wait(750)
        Player.Functions.AddItem('orange_juice', receivingItem)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['orange_juice'], "add")
    end)

    SellOranges = {
        ["orange"] = {
            ["price"] = math.random(Config.SellPrice.Raworanges.min, Config.SellPrice.Raworanges.max)
        }
    }

    RegisterNetEvent('tr-orangefarm:SellingRawOrange', function()
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        local price = 0
        local orange = Player.Functions.GetItemByName('orange')
        if not orange then
            TriggerClientEvent('QBCore:Notify', src, Config.Text["NoItem"], "error")
        elseif orange.amount >= 1 then
            if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then
                for k, v in pairs(Player.PlayerData.items) do
                    if Player.PlayerData.items[k] ~= nil then
                        if SellOranges[Player.PlayerData.items[k].name] ~= nil then
                            price = price + (SellOranges[Player.PlayerData.items[k].name].price * Player.PlayerData.items[k].amount)
                            Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Player.PlayerData.items[k].name], "remove")
                        end
                    end
                end
                Player.Functions.AddMoney("cash", price)
                TriggerClientEvent('QBCore:Notify', src, Config.Text["successfully_sold"], "success")
            end
        end
    end)

    SellJuice = {
        ["orange_juice"] = {
            ["price"] = math.random(Config.SellPrice.Juice.min, Config.SellPrice.Juice.max)
        }
    }

    RegisterNetEvent('tr-orangefarm:SellingJuices', function()
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        local price = 0
        local orangejuice = Player.Functions.GetItemByName('orange_juice')
        if not orangejuice then
            TriggerClientEvent('QBCore:Notify', src, Config.Text["NoItem"], "error")
        elseif orangejuice.amount >= 1 then
            if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then
                for k in pairs(Player.PlayerData.items) do
                    if Player.PlayerData.items[k] ~= nil then
                        if SellJuice[Player.PlayerData.items[k].name] ~= nil then
                            price = price + (SellJuice[Player.PlayerData.items[k].name].price * Player.PlayerData.items[k].amount)
                            Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Player.PlayerData.items[k].name], "remove")
                        end
                    end
                end
                Player.Functions.AddMoney("cash", price)
                TriggerClientEvent('QBCore:Notify', src, Config.Text["successfully_sold1"], "success")
            end
        end
    end)

    QBCore.Functions.CreateUseableItem("orange", function(source, item)
        local Player = QBCore.Functions.GetPlayer(source)
          if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent("consumables:client:Eat", source, item.name)
        end
    end)

    QBCore.Functions.CreateUseableItem("orange_juice", function(source, item)
        local Player = QBCore.Functions.GetPlayer(source)
          if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent("consumables:client:Drink", source, item.name)
        end
    end)

end

if Config.Framework == "ESX" then
    LoadESXVersion()
elseif Config.Framework == "QB" then
    LoadQBVersion()
end
