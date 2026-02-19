local Blips = {}
local Lamps = {}
local pedComponents = {}
local playerCount = 0
local playerUdpated = {}

NPCCanMove = true
-- RESTART/START/STOP/SPAWN
--- Supprime toutes les icônes ajoutées sur la carte par la fonction `addBlips()` et les PNJ ajoutés par `addNPC()` et les tabourets ajoutés par 'addStool()'
--- lors de l'arrêt de la ressource.
--- @param resourceName Nom de la ressource (chaîne de caractères)
AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        removeBlips()
        removeNPC()
        removeStool()
    end
end)

--- Initialise le script des tatouages au démarrage de la ressource.
--- @param resourceName Nom de la ressource (chaîne de caractères)
AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        InitTattooScript()
    end
end)

--- Initialise le script des tatouages lorsque le personnage est sélectionné.
--- @param none
RegisterNetEvent('vorp:SelectedCharacter', function()
    InitTattooScript()
end)
--

--- Ajoute des icônes sur la carte pour marquer les emplacements des boutiques.
--- @param none
function addBlips()
    for _, v in pairs(Config.Shops) do
        local newBlip = N_0x554d9d53f696d002(1664425300, v.NPC.x, v.NPC.y, v.NPC.z)
        SetBlipSprite(newBlip, Config.BlipSprite, 1)
        SetBlipScale(newBlip, 0.2)
        Citizen.InvokeNative(0x9CB1A1623062F402, newBlip, Config.BlipName)
        table.insert(Blips, newBlip)
    end
end

--- Supprime toutes les icônes ajoutées sur la carte par la fonction `addBlips()`.
--- @param none
function removeBlips()
    for i=1, #Blips do
        RemoveBlip(Blips[i])
    end
end

--- Ajoute un PNJ à une position spécifiée avec une orientation donnée.
--- @param x Le coordonnée X de la position du PNJ (nombre)
--- @param y Le coordonnée Y de la position du PNJ (nombre)
--- @param z Le coordonnée Z de la position du PNJ (nombre)
--- @param h L'orientation du PNJ (nombre)
--- @return Le PNJ créé
function addNPC(x,y,z,h)
    local NPCModel = joaat(Config.NPCModel)
    RequestModel(NPCModel)
    while not HasModelLoaded(NPCModel) do
        Wait(100)
    end
    local NPC = CreatePed(NPCModel, x, y, z, h, false, false)
    local to = 5000
    while not DoesEntityExist(NPC) do
        Wait(100)
        to = to - 100
        if to < 0 then
            return nil
        end
    end
    SetRandomOutfitVariation(NPC,true)
    SetBlockingOfNonTemporaryEvents(NPC, true)
    SetPedCanBeTargetted(NPC, false)
    SetEntityInvincible(NPC, true)
    --FreezeEntityPosition(NPC, true)
    SetEntityHeading(NPC, h)
    SetModelAsNoLongerNeeded(NPCModel)
    return NPC
end

--- Bloque les commandes du joueurs pendant x millisecondes
--- @param time Integer temps en millisecondes
function BlockPlayerCommands(time)
    -- Blocage des commandes pour quelques secondes
    Citizen.CreateThread(function()
        local to = time
        while to > 0 do
            DisableAllControlActions(0)
            EnableControlAction(0, `INPUT_GAME_MENU_CANCEL`, true)
            EnableControlAction(0, `INPUT_FRONTEND_PAUSE_ALTERNATE`, true)
            EnableControlAction(0, `INPUT_FRONTEND_RRIGHT`, true)
            EnableControlAction(0, `INPUT_QUIT`, true)
            EnableControlAction(0, `INPUT_MINIGAME_QUIT`, true)
            to = to - 10
            Citizen.Wait(0)
        end
    end)
    --
end

--- Déplace les PNJ Tatoueur de façon aléatoire et leur fait utiliser un scénario proche, autour d'eux ou tu tabouret.
--- @param none
function setNPCRandomPosition()
    Citizen.CreateThread(function()
        while true do
            if NPCCanMove then
                for _, v in pairs(Config.Shops) do
                    if v.NPCPed and DoesEntityExist(v.NPCPed) then
                        local DataStruct = DataView.ArrayBuffer(256 * 4)
                        Citizen.InvokeNative(0x345EC3B7EBDE1CB5, math.random(50) > 30 and vector3(v.NPC.x, v.NPC.y, v.NPC.z) or vector3(v.STOOL.x, v.STOOL.y, v.STOOL.z), 1.5, DataStruct:Buffer(), 10)
                        for i = 1, 10, 1 do
                            local scenario = DataStruct:GetInt32(8 * i)
                            if scenario ~= 0 then
                                if math.random(50) > 30 and NPCCanMove then
                                    TaskUseScenarioPoint(v.NPCPed, scenario, "", -1.0, true, false, 0, false, -1082130432, true)
                                end
                            end
                        end
                    end
                end
            end
            Citizen.Wait(60000)
        end
    end)
end

--- Supprime tous les PNJ ajoutés sur la carte.
--- @param none
function removeNPC()
    for _, v in pairs(Config.Shops) do
        if v.NPCPed and DoesEntityExist(v.NPCPed) then
            SetEntityAsNoLongerNeeded(v.NPCPed)
            DeleteEntity(v.NPCPed)
        end
    end
end

--- Ajoute un tabouret à une position spécifiée.
--- @param x Le coordonnée X de la position du Tabouret (nombre)
--- @param y Le coordonnée Y de la position du Tabouret (nombre)
--- @param z Le coordonnée Z de la position du Tabouret (nombre)
--- @return Le Tabouret créé
function addStool(x, y, z)
    local ObjectModel = joaat("p_stool06x")
    RequestModel(ObjectModel)
    while not HasModelLoaded(ObjectModel) do
        Wait(100)
    end
    local Object = CreateObject(ObjectModel, x, y, z, false, false, false, false, false)
    SetModelAsNoLongerNeeded(ObjectModel)
    return Object
end

--- Supprime tous les tabourets ajoutés sur la carte.
--- @param none
function removeStool()
    for _, v in pairs(Config.Shops) do
        if v.StoolObj and DoesEntityExist(v.StoolObj) then
            --SetEntityAsNoLongerNeeded(v.StoolObj)
            DeleteEntity(v.StoolObj)
        end
    end
end

--- Créer 4 lampes invisibles qutour du tabouret
--- @param Entity stoolObj L'entité tabouret
function createLamps(stoolObj)
    if DoesEntityExist(stoolObj) then
        local ObjectModel = joaat("p_lamp20x")
        RequestModel(ObjectModel)
        while not HasModelLoaded(ObjectModel) do
            Wait(100)
        end

        local forward = GetEntityForwardVector(stoolObj)
        local Gx, Gy, Gz = table.unpack(GetEntityCoords(stoolObj) - forward * 1.5)
        local lampsDevant = CreateObject(ObjectModel, Gx, Gy, Gz, false, false, false, false, false)
        PlaceObjectOnGroundProperly(lampsDevant)
        SetEntityAlpha(lampsDevant, 0)
        table.insert(Lamps, lampsDevant)

        Gx, Gy, Gz = table.unpack(GetEntityCoords(stoolObj) - forward * - 0.5)
        local lampsDerriere = CreateObject(ObjectModel, Gx, Gy, Gz, false, false, false, false, false)
        PlaceObjectOnGroundProperly(lampsDerriere)
        SetEntityAlpha(lampsDerriere, 0)
        table.insert(Lamps, lampsDerriere)

        Gx, Gy, Gz = table.unpack(GetEntityCoords(stoolObj))
        local lampsDroite = CreateObject(ObjectModel, Gx, Gy+1.5, Gz, false, false, false, false, false)
        PlaceObjectOnGroundProperly(lampsDroite)
        SetEntityAlpha(lampsDroite, 0)
        table.insert(Lamps, lampsDroite)

        Gx, Gy, Gz = table.unpack(GetEntityCoords(stoolObj))
        local lampsGauche = CreateObject(ObjectModel, Gx, Gy-1.5, Gz, false, false, false, false, false)
        PlaceObjectOnGroundProperly(lampsGauche)
        SetEntityAlpha(lampsGauche, 0)
        table.insert(Lamps, lampsGauche)

        SetModelAsNoLongerNeeded(ObjectModel)
    end
end

--- Supprime tous les tabourets ajoutées sur la carte par la fonction `createLamps()`.
--- @param none
function removeLamps()
    for i=1, #Lamps do
        DeleteEntity(Lamps[i])
    end
end

--- Affiche une notification en haut de l'écran pendant une durée spécifiée.
--- @param title Le titre de la notification (chaîne de caractères)
--- @param subtext Le texte de la notification (chaîne de caractères)
--- @param duration La durée d'affichage de la notification en millisecondes (nombre)
function ShowTopNotification(title, subtext, duration)
    local struct1 = DataView.ArrayBuffer(8 * 7)
    struct1:SetInt32(8 * 0, duration)
    -- struct1:SetInt64(8*1,bigInt(sound_dict))
    -- struct1:SetInt64(8*2,bigInt(sound))
    local string1 = CreateVarString(10, "LITERAL_STRING", title)
    local string2 = CreateVarString(10, "LITERAL_STRING", subtext)
    local struct2 = DataView.ArrayBuffer(8 * 7)
    struct2:SetInt64(8 * 1, bigInt(string1))
    struct2:SetInt64(8 * 2, bigInt(string2))
    Citizen.InvokeNative(0xA6F4216AB10EB08E, struct1:Buffer(), struct2:Buffer(), 1, 1)
end

--- Affiche un objectif à l'écran pendant une durée spécifiée.
--- @param text Le texte de l'objectif (chaîne de caractères)
--- @param duration La durée d'affichage de l'objectif en millisecondes (nombre)
function ShowObjective(text, duration)
    Citizen.InvokeNative("0xDD1232B332CBB9E7", 3, 1, 0)
    local string1 = CreateVarString(10, "LITERAL_STRING", text)
    local struct1 = DataView.ArrayBuffer(8*7)
    local struct2 = DataView.ArrayBuffer(8*3)
    struct1:SetInt32(8*0,duration)
    --struct1:SetInt64(8*1,bigInt(sound_dict))
    --struct1:SetInt64(8*2,bigInt(sound))
    struct2:SetInt64(8*1,bigInt(string1))

    Citizen.InvokeNative(0xCEDBF17EFCC0E4A4,struct1:Buffer(),struct2:Buffer(),1)
end

--- Joue un speech ambiant
function PlayAmbiantSpeechFromEntity(entity_id, sound_ref_string, sound_name_string, speech_params_string, speech_line)
    local struct = DataView.ArrayBuffer(128)
    local sound_name = Citizen.InvokeNative(0xFA925AC00EB830B9, 10,
            "LITERAL_STRING", sound_name_string,
            Citizen.ResultAsLong())
    local sound_ref = Citizen.InvokeNative(0xFA925AC00EB830B9, 10,
            "LITERAL_STRING", sound_ref_string,
            Citizen.ResultAsLong())
    local speech_params = GetHashKey(speech_params_string)
    local sound_name_BigInt = DataView.ArrayBuffer(16)
    sound_name_BigInt:SetInt64(0, sound_name)
    local sound_ref_BigInt = DataView.ArrayBuffer(16)
    sound_ref_BigInt:SetInt64(0, sound_ref)
    local speech_params_BigInt = DataView.ArrayBuffer(16)
    speech_params_BigInt:SetInt64(0, speech_params)
    struct:SetInt64(0, sound_name_BigInt:GetInt64(0))
    struct:SetInt64(8, sound_ref_BigInt:GetInt64(0))
    struct:SetInt32(16, speech_line)
    struct:SetInt64(24, speech_params_BigInt:GetInt64(0))
    struct:SetInt32(32, 0)
    struct:SetInt32(40, 1)
    struct:SetInt32(48, 1)
    struct:SetInt32(56, 1)
    Citizen.InvokeNative(0x8E04FEDD28D42462, entity_id, struct:Buffer());
end

--- Récupère le décompte de joueurs autour / vérifie si le server ID est contrôlé
function isPlayersCountChanged()
    -- SOLUTION 1
    local count = 0
    local lastCount = playerCount

    for i = 0, 256 do
        if NetworkIsPlayerActive(i) then
            count = count + 1
        end
    end

    playerCount = count
    return lastCount ~= count

    -- SOLUTION 2
--[[    local needUpdate = false
    for i = 0, 256 do
        if NetworkIsPlayerActive(i) then
            if not isPlayerServerIdUpdated(GetPlayerServerId(i)) then
                needUpdate = true
            end
        end
    end
    return needUpdate]]
end

--- Regarde si le server ID a deja été contrôlé
function isPlayerServerIdUpdated(serverId)
    for i=1, #playerUdpated do
        if playerUdpated[i] == serverId then
            return true
        end
    end

    table.insert(playerUdpated, serverId)
    return false
end

--- Vérifie si le joueur a équipé/déséquipé un vêtement
function isPedComponentChanged()
    local pedId = PlayerPedId()
    local changed = false
    for i=1, #Config.PedComponents do
        local component = Config.PedComponents[i]
        if pedComponents[component] == nil or (Citizen.InvokeNative(0xFB4891BD7578CDC1, pedId, component) ~= pedComponents[component]) then
            pedComponents[component] = Citizen.InvokeNative(0xFB4891BD7578CDC1, pedId, component)
            changed = true
        end
    end
    return changed
end
--- Retire les vêtements du joueur.
--- @param topless Indique si le joueur doit être déshabillé jusqu'à la taille ou non (booléen)
function Undress(topless)
    local pedId = PlayerPedId()


    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x9925C067, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x5E47CA6, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x5FC29285, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x7A96FACA, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x2026C46D, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x877A2CF7, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x485EE834, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0xE06D30CE, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0xAF14310B, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x3C1A74CD, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0xEABE0032, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x7A6BBD0B, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0xF16A1D23, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x7BC10759, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x9B2C8B89, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0xA6D134C6, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0xFAE9107F, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x91CE9B20, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x83887E88, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x79D7DF96, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x94504D26, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0xF1542D11, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x94504D26, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x9B2C8B89, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0xFAE9107F, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0xB6B6122D, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x1D4C528A, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0xA0E3AB7F, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x3107499B, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x777EC6EF, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x18729F39, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0xF1542D11, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x514ADCEA, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x91CE9B20, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x83887E88, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x79D7DF96, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, pedId, 0x94504D26, 0)
    Citizen.Wait(200)
    Citizen.InvokeNative(0xCC8CA3E88256E58F, pedId, 0, 1, 1, 1, 0)

    if not IsPedMale(pedId) then
        if not topless then
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, 0xF5BBD48, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, 0xF5BBD48, true, true, false)
        end
        Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, 1025891469, true, false, false)
        Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, 1025891469, true, true, false)
        Citizen.Wait(200)
        Citizen.InvokeNative(0xCC8CA3E88256E58F, pedId, 0, 1, 1, 1, 0)
    end
end

--- Habille le joueur avec les vêtements définis.
--- @param none
function Dress()
    TriggerEvent("vorp:ExecuteServerCallBack", "redrp-bt:getOutfit", function(back)
        if back then
            local pedId = PlayerPedId()

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Mask, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Mask, true, true, false)

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Hat, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Hat, true, true, false)

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.EyeWear, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.EyeWear, true, true, false)

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.NeckWear, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.NeckWear, true, true, false)

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.NeckTies, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.NeckTies, true, true, false)

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Shirt, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Shirt, true, true, false)

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Suspender, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Suspender, true, true, false)

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Vest, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Vest, true, true, false)

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Coat, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Coat, true, true, false)

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Poncho, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Poncho, true, true, false)

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Cloak, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Cloak, true, true, false)

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Glove, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Glove, true, true, false)

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.RingRh, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.RingRh, true, true, false)

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.RingLh, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.RingLh, true, true, false)

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Bracelet, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Bracelet, true, true, false)

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Gunbelt, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Gunbelt, true, true, false)

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Belt, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Belt, true, true, false)

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Buckle, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Buckle, true, true, false)

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Holster, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Holster, true, true, false)

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Pant, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Pant, true, true, false)

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Skirt, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Skirt, true, true, false)

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Chap, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Chap, true, true, false)

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Boots, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Boots, true, true, false)

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Spurs, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.Spurs, true, true, false)

            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.GunbeltAccs, true, false, false)
            Citizen.InvokeNative(0xD3A7B003ED343FD9,pedId, back.GunbeltAccs, true, true, false)
            Citizen.Wait(250)
            Citizen.InvokeNative(0xCC8CA3E88256E58F,pedId, 0, 1, 1, 1, 0)
        end
    end)
end