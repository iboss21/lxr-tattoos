--local VorpInv = exports.vorp_inventory:vorp_inventoryApi()
local VORP = exports.vorp_core:vorpAPI()
local VorpCore = {}
local SCRIPT_STARTED = true


Citizen.CreateThread(function()
    -- AUTO DETECTION
    if string.match(GetCurrentResourceName(), "bt_tattoo") then
        SCRIPT_STARTED = true
        print("BT_TATTOO : Started")
    else
        print("BT_TATTOO [FOOL DETECTED] : Respect my work and don't change the ressource name : bt_tattoo")
        SCRIPT_STARTED = false
    end
end)

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

--- Callback pour obtenir la tenue du personnage
--- @param source: La source de l'événement
--- @param cb: Fonction de rappel pour renvoyer les données
VORP.addNewCallBack("redrp-bt:getOutfit", function(source, cb)
    if not SCRIPT_STARTED then return end
    local _source = source
    local User = VorpCore.getUser(_source)
    local UserCharacter = User.getUsedCharacter
    if UserCharacter.identifier ~= nil then
        cb(json.decode(UserCharacter.comps))
    end
end)

--- Callback pour obtenir la peau (skin) du personnage
--- @param source: La source de l'événement
--- @param cb: Fonction de rappel pour renvoyer les données
VORP.addNewCallBack("redrp-bt:getSkin", function(source, cb)
    if not SCRIPT_STARTED then return end
    local _source = source
    local User = VorpCore.getUser(_source)
    local UserCharacter = User.getUsedCharacter
    if UserCharacter.identifier ~= nil then
        cb(json.decode(UserCharacter.skin))
    end
end)

--- Restaure les tatouages du joueur lors de son apparition ou de tout autre événement pertinent
--- @param source: La source de l'événement
RegisterServerEvent('redrp-bt:restoreTattoo')
AddEventHandler('redrp-bt:restoreTattoo', function()
    local _source = source
    local User = VorpCore.getUser(_source)
    local Character = User.getUsedCharacter
    --print(_source) -- DEBUG
    --SetPlayerCullingRadius(_source, 10.0) -- DEBUG
    exports.ghmattimysql:execute('SELECT * FROM tattoo WHERE identifier = @identifier AND character_id = @character_id', {
        ['@identifier'] = Character.identifier,
        ['@character_id'] = Character.charIdentifier
    }, function(result)
        if result[1] then
            TriggerClientEvent('redrp-bt:setTattooTable', _source, json.decode(result[1].tattoo))
        end
    end)
end)

--- Supprime tous les tatouages du joueur
--- @param source: La source de l'événement
RegisterServerEvent('redrp-bt:deleteTattoo')
AddEventHandler('redrp-bt:deleteTattoo', function()
    if not SCRIPT_STARTED then return end
    local _source = source
    local User = VorpCore.getUser(_source)
    local Character = User.getUsedCharacter
    if Character.identifier then
        -- SUPPRESSION DE L'EXISTANT
        exports.ghmattimysql:execute('DELETE FROM tattoo WHERE identifier = @identifier AND character_id = @character_id', {
            ['@identifier'] = Character.identifier,
            ['@character_id'] = Character.charIdentifier
        }, function(rowsChanged)
            if rowsChanged then
                TriggerClientEvent("vorp:TipRight", _source, "Vos tatouages sont retirés.", 5000)
                TriggerClientEvent('redrp-bt:setTattooTable', _source, {})
            end
        end)
    end
end)

--- Achète un tatouage pour le joueur et le stocke dans la base de données
--- @param tattoo: Tableau contenant les informations sur le tatouage acheté
RegisterServerEvent('redrp-bt:buyTattoo')
AddEventHandler('redrp-bt:buyTattoo', function(tattoo)
    if not SCRIPT_STARTED then return end
    if tattoo and tattoo.sex and tattoo.Name then
        local _source = source
        local User = VorpCore.getUser(_source)
        local Character = User.getUsedCharacter
        if Character.identifier and Config.overlays[tattoo.sex] then
            for k, v in pairs(Config.overlays[tattoo.sex]) do
                if tattoo.Name == k then
                    local tattooPrice = (tattoo.colorName == "Noir" and v.price or v.price + Config.ColorPrice)

                    if Config.DEBUG then tattooPrice = 1 end

                    if Character.money < tattooPrice then
                        TriggerClientEvent("vorp:TipRight", _source, string.format(Config.Txt.Server_NotEnoughMoney, tostring(math.ceil(tattooPrice - Character.money))), 5000)
                        return
                    end

                    -- SUPPRESSION DE L'EXISTANT
                    exports.ghmattimysql:execute('DELETE FROM tattoo WHERE identifier = @identifier AND character_id = @character_id', {
                        ['@identifier'] = Character.identifier,
                        ['@character_id'] = Character.charIdentifier
                    }, function(rowsChanged)
                        if rowsChanged then
                            -- AJOUT DU NOUVEAU TATOUAGE
                            exports.ghmattimysql:execute('INSERT INTO tattoo (identifier, character_id, tattoo) VALUES (@identifier, @character_id, @tattoo)', {
                                ['@identifier'] = Character.identifier,
                                ['@character_id'] = Character.charIdentifier,
                                ['@tattoo'] = json.encode(tattoo)
                            })
                            TriggerClientEvent("vorp:TipRight", _source, string.format(Config.Txt.Server_BuyTattooMoney, tostring(math.ceil(tattooPrice))), 5000)
                            Character.removeCurrency(0, tattooPrice)
                            TriggerClientEvent("redrp-bt:closeTattooShop", _source)
                        end
                    end)

                    TriggerClientEvent('redrp-bt:setTattooTable', _source, tattoo)
                    break
                end
            end
        end
    end
end)