--[[
    ██╗     ██╗  ██╗██████╗       ████████╗ █████╗ ████████╗████████╗ ██████╗  ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ╚══██╔══╝██╔══██╗╚══██╔══╝╚══██╔══╝██╔═══██╗██╔═══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗   ██║   ███████║   ██║      ██║   ██║   ██║██║   ██║███████╗
    ██║      ██╔██╗ ██╔══██╗╚════╝   ██║   ██╔══██║   ██║      ██║   ██║   ██║██║   ██║╚════██║
    ███████╗██╔╝ ██╗██║  ██║         ██║   ██║  ██║   ██║      ██║   ╚██████╔╝╚██████╔╝███████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝         ╚═╝   ╚═╝  ╚═╝   ╚═╝      ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝
                                                                                               
    🐺 LXR Tattoos - Server Script
    
    Multi-framework tattoo shop system with database persistence
    
    Developer: iBoss21 / The Lux Empire
    Website: https://www.wolves.land
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- FRAMEWORK DETECTION & INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

local Framework = nil
local FrameworkName = nil
local VORP = nil
local VorpCore = {}

-- Auto-detect framework if configured
if Config.Framework == 'auto' then
    -- Check for LXR-Core first (Priority 1)
    if GetResourceState('lxr-core') == 'started' then
        FrameworkName = 'lxr-core'
        Framework = exports['lxr-core']:GetCoreObject()
        print("^2[LXR-TATTOOS]^7 Framework detected: ^3LXR-Core^7")
    
    -- Check for RSG-Core (Priority 2)
    elseif GetResourceState('rsg-core') == 'started' then
        FrameworkName = 'rsg-core'
        Framework = exports['rsg-core']:GetCoreObject()
        print("^2[LXR-TATTOOS]^7 Framework detected: ^3RSG-Core^7")
    
    -- Check for VORP Core (Priority 3)
    elseif GetResourceState('vorp_core') == 'started' then
        FrameworkName = 'vorp_core'
        VORP = exports.vorp_core:vorpAPI()
        TriggerEvent("getCore", function(core)
            VorpCore = core
        end)
        print("^2[LXR-TATTOOS]^7 Framework detected: ^3VORP Core^7")
    
    -- Check for RedEM:RP (Optional)
    elseif GetResourceState('redem_roleplay') == 'started' then
        FrameworkName = 'redem_roleplay'
        Framework = exports['redem_roleplay']:GetFramework()
        print("^2[LXR-TATTOOS]^7 Framework detected: ^3RedEM:RP^7")
    
    -- Check for QBR-Core (Optional)
    elseif GetResourceState('qbr-core') == 'started' then
        FrameworkName = 'qbr-core'
        Framework = exports['qbr-core']:GetCoreObject()
        print("^2[LXR-TATTOOS]^7 Framework detected: ^3QBR-Core^7")
    
    -- Check for QR-Core (Optional)
    elseif GetResourceState('qr-core') == 'started' then
        FrameworkName = 'qr-core'
        Framework = exports['qr-core']:GetCoreObject()
        print("^2[LXR-TATTOOS]^7 Framework detected: ^3QR-Core^7")
    
    -- Standalone fallback
    else
        FrameworkName = 'standalone'
        print("^3[LXR-TATTOOS]^7 No framework detected, running in ^3standalone^7 mode")
    end
else
    -- Manual framework configuration
    FrameworkName = Config.Framework
    
    if FrameworkName == 'vorp_core' then
        VORP = exports.vorp_core:vorpAPI()
        TriggerEvent("getCore", function(core)
            VorpCore = core
        end)
    elseif FrameworkName ~= 'standalone' then
        local resourceName = Config.FrameworkSettings[FrameworkName].resource
        Framework = exports[resourceName]:GetCoreObject()
    end
    
    print("^2[LXR-TATTOOS]^7 Framework manually set to: ^3" .. FrameworkName .. "^7")
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- FRAMEWORK WRAPPER FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

--- Get player character data
local function GetCharacter(source)
    if FrameworkName == 'vorp_core' then
        local User = VorpCore.getUser(source)
        if User then
            return User.getUsedCharacter
        end
    elseif FrameworkName == 'lxr-core' or FrameworkName == 'rsg-core' then
        local Player = Framework.Functions.GetPlayer(source)
        if Player then
            return {
                identifier = Player.PlayerData.citizenid,
                charIdentifier = Player.PlayerData.citizenid,
                money = Player.Functions.GetMoney('cash')
            }
        end
    elseif FrameworkName == 'qbr-core' or FrameworkName == 'qr-core' then
        local Player = Framework.Functions.GetPlayer(source)
        if Player then
            return {
                identifier = Player.PlayerData.citizenid,
                charIdentifier = Player.PlayerData.citizenid,
                money = Player.Functions.GetMoney('cash')
            }
        end
    elseif FrameworkName == 'redem_roleplay' then
        local Player = Framework.GetPlayer(source)
        if Player then
            return {
                identifier = Player.identifier,
                charIdentifier = Player.identifier,
                money = Player.getMoney()
            }
        end
    end
    
    return nil
end

--- Remove money from player
local function RemoveMoney(source, amount)
    if FrameworkName == 'vorp_core' then
        local User = VorpCore.getUser(source)
        if User then
            local Character = User.getUsedCharacter
            Character.removeCurrency(0, amount)
        end
    elseif FrameworkName == 'lxr-core' or FrameworkName == 'rsg-core' then
        local Player = Framework.Functions.GetPlayer(source)
        if Player then
            Player.Functions.RemoveMoney('cash', amount)
        end
    elseif FrameworkName == 'qbr-core' or FrameworkName == 'qr-core' then
        local Player = Framework.Functions.GetPlayer(source)
        if Player then
            Player.Functions.RemoveMoney('cash', amount)
        end
    elseif FrameworkName == 'redem_roleplay' then
        local Player = Framework.GetPlayer(source)
        if Player then
            Player.removeMoney(amount)
        end
    end
end

--- Send notification to player
local function Notify(source, message, duration)
    if FrameworkName == 'vorp_core' then
        TriggerClientEvent("vorp:TipRight", source, message, duration or 5000)
    elseif FrameworkName == 'lxr-core' or FrameworkName == 'rsg-core' then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Tattoo Shop',
            description = message,
            type = 'inform',
            duration = duration or 5000
        })
    elseif FrameworkName == 'qbr-core' or FrameworkName == 'qr-core' then
        TriggerClientEvent('QBCore:Notify', source, message, 'primary', duration or 5000)
    elseif FrameworkName == 'redem_roleplay' then
        TriggerClientEvent('redem_roleplay:Notify', source, message, duration or 5000)
    else
        -- Fallback to chat message
        TriggerClientEvent('chat:addMessage', source, {args = {"^3[Tattoo Shop]^7", message}})
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- VORP-SPECIFIC CALLBACKS (Backward Compatibility)
-- ═══════════════════════════════════════════════════════════════════════════════

if FrameworkName == 'vorp_core' and VORP then
    --- Callback to get character outfit
    VORP.addNewCallBack("redrp-bt:getOutfit", function(source, cb)
        local Character = GetCharacter(source)
        if Character and Character.identifier ~= nil then
            -- Safely decode comps, handle if property doesn't exist or is invalid JSON
            local comps = {}
            if Character.comps and type(Character.comps) == "string" and Character.comps ~= "" then
                local success, decoded = pcall(json.decode, Character.comps)
                if success then
                    comps = decoded
                end
            end
            cb(comps)
        else
            cb({})
        end
    end)
    
    --- Callback to get character skin
    VORP.addNewCallBack("redrp-bt:getSkin", function(source, cb)
        local Character = GetCharacter(source)
        if Character and Character.identifier ~= nil then
            -- Safely decode skin, handle if property doesn't exist or is invalid JSON
            local skin = {}
            if Character.skin and type(Character.skin) == "string" and Character.skin ~= "" then
                local success, decoded = pcall(json.decode, Character.skin)
                if success then
                    skin = decoded
                end
            end
            cb(skin)
        else
            cb({})
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- TATTOO MANAGEMENT EVENTS
-- ═══════════════════════════════════════════════════════════════════════════════

--- Restore tattoos when player spawns or requests them
RegisterServerEvent('redrp-bt:restoreTattoo')
AddEventHandler('redrp-bt:restoreTattoo', function()
    local _source = source
    local Character = GetCharacter(_source)
    
    if not Character or not Character.identifier then
        return
    end
    
    exports.ghmattimysql:execute('SELECT * FROM tattoo WHERE identifier = @identifier AND character_id = @character_id', {
        ['@identifier'] = Character.identifier,
        ['@character_id'] = Character.charIdentifier
    }, function(result)
        if result[1] then
            TriggerClientEvent('redrp-bt:setTattooTable', _source, json.decode(result[1].tattoo))
        end
    end)
end)

--- Delete all tattoos for a player
RegisterServerEvent('redrp-bt:deleteTattoo')
AddEventHandler('redrp-bt:deleteTattoo', function()
    local _source = source
    local Character = GetCharacter(_source)
    
    if not Character or not Character.identifier then
        return
    end
    
    exports.ghmattimysql:execute('DELETE FROM tattoo WHERE identifier = @identifier AND character_id = @character_id', {
        ['@identifier'] = Character.identifier,
        ['@character_id'] = Character.charIdentifier
    }, function(rowsChanged)
        if rowsChanged then
            Notify(_source, "Your tattoos have been removed.", 5000)
            TriggerClientEvent('redrp-bt:setTattooTable', _source, {})
        end
    end)
end)

--- Purchase a tattoo
RegisterServerEvent('redrp-bt:buyTattoo')
AddEventHandler('redrp-bt:buyTattoo', function(tattoo)
    if not tattoo or not tattoo.sex or not tattoo.Name then
        return
    end
    
    local _source = source
    local Character = GetCharacter(_source)
    
    if not Character or not Character.identifier then
        return
    end
    
    if not Config.overlays[tattoo.sex] then
        return
    end
    
    for k, v in pairs(Config.overlays[tattoo.sex]) do
        if tattoo.Name == k then
            -- Backward compatibility: check for both "Noir" (French) and "Black" (English)
            local isBaseColor = (tattoo.colorName == "Black" or tattoo.colorName == "Noir")
            local tattooPrice = (isBaseColor and v.price or v.price + Config.ColorPrice)
            
            -- Debug mode: all tattoos cost $1
            if Config.DEBUG then
                tattooPrice = 1
            end
            
            -- Check if player has enough money
            if Character.money < tattooPrice then
                Notify(_source, string.format(Config.Txt.Server_NotEnoughMoney, tostring(math.ceil(tattooPrice - Character.money))), 5000)
                return
            end
            
            -- Delete existing tattoo
            exports.ghmattimysql:execute('DELETE FROM tattoo WHERE identifier = @identifier AND character_id = @character_id', {
                ['@identifier'] = Character.identifier,
                ['@character_id'] = Character.charIdentifier
            }, function(rowsChanged)
                if rowsChanged then
                    -- Insert new tattoo
                    exports.ghmattimysql:execute('INSERT INTO tattoo (identifier, character_id, tattoo) VALUES (@identifier, @character_id, @tattoo)', {
                        ['@identifier'] = Character.identifier,
                        ['@character_id'] = Character.charIdentifier,
                        ['@tattoo'] = json.encode(tattoo)
                    })
                    
                    -- Remove money and notify player
                    RemoveMoney(_source, tattooPrice)
                    Notify(_source, string.format(Config.Txt.Server_BuyTattooMoney, tostring(math.ceil(tattooPrice))), 5000)
                    TriggerClientEvent("redrp-bt:closeTattooShop", _source)
                end
            end)
            
            -- Update client tattoo
            TriggerClientEvent('redrp-bt:setTattooTable', _source, tattoo)
            break
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- STARTUP MESSAGE
-- ═══════════════════════════════════════════════════════════════════════════════

print("^2═══════════════════════════════════════════════════════════════^7")
print("^2🐺 LXR-TATTOOS SERVER^7 - ^3Successfully Loaded^7")
print("^2═══════════════════════════════════════════════════════════════^7")
print("^3Framework:^7 " .. (FrameworkName or "Unknown"))
print("^3Version:^7 1.0.0")
print("^2═══════════════════════════════════════════════════════════════^7")
