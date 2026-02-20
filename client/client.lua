--[[
    ██╗     ██╗  ██╗██████╗       ████████╗ █████╗ ████████╗████████╗ ██████╗  ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ╚══██╔══╝██╔══██╗╚══██╔══╝╚══██╔══╝██╔═══██╗██╔═══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗   ██║   ███████║   ██║      ██║   ██║   ██║██║   ██║███████╗
    ██║      ██╔██╗ ██╔══██╗╚════╝   ██║   ██╔══██║   ██║      ██║   ██║   ██║██║   ██║╚════██║
    ███████╗██╔╝ ██╗██║  ██║         ██║   ██║  ██║   ██║      ██║   ╚██████╔╝╚██████╔╝███████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝         ╚═╝   ╚═╝  ╚═╝   ╚═╝      ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝
                                                                                               
    🐺 LXR Tattoos - Client Script
    
    Handles tattoo shop interactions, menus, and texture application
    
    Developer: iBoss21 / The Lux Empire
    Website: https://www.wolves.land
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

local TattooPrompt, ToplessPrompt -- Déclare deux variables locales pour les prompts de tatouage et de retrait du haut
local TattooPrompts = GetRandomIntInRange(0, 0xffffff) -- Génère un groupe de prompts aléatoire
local currentItemIndex, selectedItemIndex = {}, {} -- Initialise deux tableaux vides pour les index des éléments actuellement sélectionnés et des éléments sélectionnés
local tattooSelected = {} -- Initialise une table vide pour les tatouages sélectionnés
local toggleFemaleShirt = false -- Initialise un indicateur pour le haut des femmes à false
local MY_TATTOO = {} -- Initialise une table pour stocker les tatouages du joueur
local currentScenario -- Defini le scénario actuel
local currentPed -- Défini le ped tatouteur actuel
local currentTextureId

-- ═══════════════════════════════════════════════════════════════════════════════
-- FRAMEWORK-AGNOSTIC SKIN REQUEST SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════

local skinRequestCallbacks = {}
local skinRequestId = 0

--- Requests character skin data, then calls callback(skinData).
--- Uses VORP's built-in callback for VORP servers; falls back to a custom
--- TriggerServerEvent/TriggerClientEvent round-trip for lxr-core / rsg-core.
local function GetSkin(callback)
    if ClientFramework == 'vorp_core' then
        TriggerEvent("vorp:ExecuteServerCallBack", "redrp-bt:getSkin", callback)
    else
        skinRequestId = skinRequestId + 1
        local id = skinRequestId
        skinRequestCallbacks[id] = callback
        TriggerServerEvent('lxr-tattoos:requestSkin', id)
    end
end

RegisterNetEvent('lxr-tattoos:skinResponse')
AddEventHandler('lxr-tattoos:skinResponse', function(requestId, skinData)
    if skinRequestCallbacks[requestId] then
        skinRequestCallbacks[requestId](skinData)
        skinRequestCallbacks[requestId] = nil
    end
end)

--- Picks the correct Config.Textures entry for pedSex based on skin albedo.
--- Falls back to the first entry when albedo is unknown (lxr-core / rsg-core).
local function ResolveTexture(back, pedSex)
    if back and back.albedo then
        local configbase = Config.CharHeads[pedSex]
        for i = 1, #configbase do
            if joaat(configbase[i]) == back.albedo then
                local chaine = configbase[i]
                local debut, fin = string.find(chaine, "_sc(%d+)_")
                local sc = string.sub(chaine, debut + 3, fin - 1)
                for _, textures in pairs(Config.Textures[pedSex]) do
                    if string.find(textures.baseAlbedo, tostring("0" .. sc)) then
                        return textures
                    end
                end
                break
            end
        end
    end
    -- Fallback: use first available texture (covers lxr-core / rsg-core with no albedo)
    return Config.Textures[pedSex][1]
end

--- Framework-aware client-side notification.
local function ClientNotify(message, duration)
    if ClientFramework == 'lxr-core' or ClientFramework == 'rsg-core' then
        TriggerEvent('ox_lib:notify', {
            title = 'Tattoo Shop',
            description = message,
            type = 'inform',
            duration = duration or 5000
        })
    elseif ClientFramework == 'vorp_core' then
        TriggerEvent("vorp:TipRight", message, duration or 5000)
    else
        TriggerEvent('chat:addMessage', {args = {"^3[Tattoo Shop]^7", message}})
    end
end

--- Définit les prompts pour acheter un tatouage et retirer le haut
--- @param none
function SetTattooPrompt()
    -- Prompt pour acheter un tatouage
    local str = Config.Txt.TattooPrompt
    TattooPrompt = PromptRegisterBegin()
    PromptSetControlAction(TattooPrompt, 0x760A9C6F) -- Touche G
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(TattooPrompt, str)
    PromptSetEnabled(TattooPrompt, 1)
    PromptSetVisible(TattooPrompt, 1)
    PromptSetHoldMode(TattooPrompt, 1000)
    PromptSetGroup(TattooPrompt, TattooPrompts)
    PromptRegisterEnd(TattooPrompt)

    -- Prompt pour retirer le haut
    str = Config.Txt.ToplessPrompt
    ToplessPrompt = PromptRegisterBegin()
    PromptSetControlAction(ToplessPrompt, 0x8FFC75D6) -- Touche SHIFT GAUCHE
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(ToplessPrompt, str)
    PromptSetEnabled(ToplessPrompt, 1)
    PromptSetVisible(ToplessPrompt, 0)
    PromptSetHoldMode(ToplessPrompt, 1000)
    PromptSetGroup(ToplessPrompt, TattooPrompts)
    PromptRegisterEnd(ToplessPrompt)
end

--- Initialise le script de tatouage
--- @param none
function InitTattooScript()
    -- Déclenche un événement serveur pour restaurer les tatouages du joueur
    TriggerServerEvent("redrp-bt:restoreTattoo")

    -- Capture the session id so this particular loop can detect when it should stop
    local mySession = currentSession

    -- Boucle pour restaurer les tatouages (Si le joueur a son skin rechargé, si le personnage spawn, si la texture change, etc...)
    Citizen.CreateThread(function()
        while mySession == currentSession do
            Citizen.Wait(2500)
            while WarMenu.IsAnyMenuOpened() or not Citizen.InvokeNative(0xA0BC8FAED8CFEB3C, PlayerPedId()) do -- Vérifie si le personnage est prêt à être rendu
                Citizen.Wait(1000)
            end
            if isPedComponentChanged() or isPlayersCountChanged() then
                -- Applique les tatouages du joueur s'ils sont définis
                if MY_TATTOO.textures and MY_TATTOO.tattoo and MY_TATTOO.colorId then
                    ApplyTexture(PlayerPedId(), MY_TATTOO.tattoo, MY_TATTOO.textures, MY_TATTOO.colorId, 1.0)
                    if not IsPedMale(PlayerPedId()) then
                        if MY_TATTOO.textures and MY_TATTOO.tattoo and MY_TATTOO.colorId then
                            ApplyTexture(PlayerPedId(), MY_TATTOO.tattoo, MY_TATTOO.textures, MY_TATTOO.colorId, 1.0)
                            if IsPedMale(PlayerPedId()) then
                                Citizen.Wait(250)
                                ApplyTexture(PlayerPedId(), MY_TATTOO.tattoo, MY_TATTOO.textures, MY_TATTOO.colorId, 1.0)
                            end
                        end
                    end
                end
            end
        end
    end)
    --
    Citizen.CreateThread(function()
        while Config.UpdateTattooEveryMinute and mySession == currentSession do
            Citizen.Wait(60000)
            while WarMenu.IsAnyMenuOpened() or not Citizen.InvokeNative(0xA0BC8FAED8CFEB3C, PlayerPedId()) do -- Vérifie si le personnage est prêt à être rendu
                Citizen.Wait(1000)
            end
            if not IsPedMale(PlayerPedId()) then
                if MY_TATTOO.textures and MY_TATTOO.tattoo and MY_TATTOO.colorId then
                    ApplyTexture(PlayerPedId(), MY_TATTOO.tattoo, MY_TATTOO.textures, MY_TATTOO.colorId, 1.0)
                    Citizen.Wait(250)
                    ApplyTexture(PlayerPedId(), MY_TATTOO.tattoo, MY_TATTOO.textures, MY_TATTOO.colorId, 1.0)
                end
            end
        end
    end)
    --

    Citizen.CreateThread(function()

    end)

    -- Définit les prompts pour acheter un tatouage et retirer le haut
    SetTattooPrompt()

    -- Ajoute les blips pour les boutiques de tatouage
    if Config.ShowBlips then
        removeBlips()
        addBlips()
    end

    -- Les NPC peuvent bouger
    setNPCRandomPosition()

    -- Boucle principale du script
    while mySession == currentSession do
        Citizen.Wait(0)
        -- Vérifie si le joueur est en jeu et aucun menu n'est ouvert
        if IsPlayerPlaying(PlayerId()) and not WarMenu.IsAnyMenuOpened() then
            -- Boucle à travers les boutiques de tatouage pour lesquelles le joueur est à proximité
            for _, v in pairs(Config.Shops) do
                -- Vérifie si le joueur est à proximité d'une boutique de tatouage
                if #(GetEntityCoords(PlayerPedId()) - vector3(v.NPC.x, v.NPC.y, v.NPC.z)) < 10.0 then
                    PromptSetVisible(ToplessPrompt, 0)
                    PromptSetVisible(TattooPrompt, 1)
                    -- Création du NPC
                    if not v.NPCPed or not DoesEntityExist(v.NPCPed) then
                        v.NPCPed = addNPC(v.NPC.x, v.NPC.y, v.NPC.z, v.NPC.h)
                    else
                        -- Vérifie si le joueur est suffisamment proche pour interagir avec la boutique
                        if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(v.NPCPed)) < 2.0 then
                            NPCCanMove = false
                            PromptSetActiveGroupThisFrame(TattooPrompts, CreateVarString(10, 'LITERAL_STRING', Config.Txt.NPCName))
                            -- Vérifie si le joueur a terminé l'action de maintien sur le prompt pour ouvrir le menu principal
                            if PromptHasHoldModeCompleted(TattooPrompt) then
                                if Config.OnlyOneTattoo and currentTextureId then
                                    PlayAmbiantSpeechFromEntity(v.NPCPed, "0315_U_M_M_NbxDoctor_01", "WELCOME_BACK", "Speech_Params_Beat_Shouted_Clear_AllowPlayAfterDeath", 0)
                                    ClientNotify(Config.Txt.AlreadyBoughtTattoo, 5000)
                                    Citizen.Wait(500)
                                    break
                                end
                                ClearPedTasks(v.NPCPed)
                                --Citizen.Wait(3000)
                                -- Je recrée le tabouret et le NPC pour éviter les anomalies
                                if v.StoolObj and DoesEntityExist(v.StoolObj) then DeleteEntity(v.StoolObj) end
                                v.StoolObj = addStool(v.STOOL.x, v.STOOL.y, v.STOOL.z)
                                --
                                --v.NPCPed = addNPC(v.NPC.x, v.NPC.y, v.NPC.z, v.NPC.h)
                                --
                                PlayAmbiantSpeechFromEntity(v.NPCPed, "0315_U_M_M_NbxDoctor_01", "ACCEPT_CATALOG_WARY", "Speech_Params_Beat_Shouted_Clear_AllowPlayAfterDeath", 0)
                                currentScenario = nil
                                currentPed = nil
                                -- Recherche le scenario le plus proche
                                local DataStruct = DataView.ArrayBuffer(256 * 4)
                                Citizen.InvokeNative(0x345EC3B7EBDE1CB5, vector3(v.STOOL.x, v.STOOL.y, v.STOOL.z), 1.0, DataStruct:Buffer(), 10)
                                for i = 1, 10, 1 do
                                    local scenario = DataStruct:GetInt32(8 * i)
                                    if scenario ~= 0 then
                                        ClearPedTasksImmediately(PlayerPedId(), true, true)
                                        Citizen.InvokeNative(0xFCCC886EDE3C63EC, PlayerPedId(), false, true)
                                        currentScenario = TaskUseScenarioPoint(PlayerPedId(), scenario, "", -1.0, true, false, 0, false, -1082130432, true)
                                        break
                                    end
                                end
                                if not currentScenario then
                                    currentScenario = Citizen.InvokeNative(0x322BFDEA666E2B0E, PlayerPedId(), v.STOOL.x, v.STOOL.y, v.STOOL.z, 1.0, -1082130432, true, true, true, true)
                                end
                                --
                                if v.StoolObj and v.NPCPed then
                                    -- Bloque les commandes du joueur
                                    BlockPlayerCommands(6000)
                                    -- Place le joueur dans une instance (VORP only)
                                    if ClientFramework == 'vorp_core' then
                                        TriggerServerEvent('vorp_core:instanceplayers', tonumber(GetPlayerServerId(PlayerId())) + 45557)
                                    end
                                    --
                                    currentPed = v.NPCPed
                                    Citizen.Wait(2500)
                                    MainMenu(v.StoolObj, v.NPC.x, v.NPC.y, v.NPC.z, v.NPC.h)
                                    break
                                end
                            end
                        end
                    end
                end
            end
        else
            Citizen.Wait(5000)
        end
    end
end

--- Menu principal pour interagir avec le tatoueur
--- @param stoolObj Entity objet Tabouret.
--- @param x Float X du lieu où se trouve le PNJ.
--- @param y Float Y du lieu où se trouve le PNJ.
--- @param z Float Z du lieu où se trouve le PNJ.
--- @param h Float H Orientation du PNJ.
function MainMenu(stoolObj, x, y, z, h)
    local pedId = PlayerPedId() -- ID du personnage du joueur
    local pedSex = IsPedMale(pedId) and "Male" or "Female" -- Détermine le sexe du personnage

    -- MUSIC
    Citizen.InvokeNative(0x1E5185B72EF5158A, "MP_CHARACTER_CREATION_START")  -- PREPARE_MUSIC_EVENT
    Citizen.InvokeNative(0x706D57B0F50DA710, "MP_CHARACTER_CREATION_START") -- TRIGGER_MUSIC_EVENT
    tattooSelected = {} -- Réinitialise la table des tatouages sélectionnés
    toggleFemaleShirt = false -- Réinitialise l'indicateur pour le haut des femmes

    -- Initialise les index des éléments actuellement sélectionnés et des éléments sélectionnés pour chaque type de tatouage
    for k, _ in pairs(Config.overlays[pedSex]) do
        if not currentItemIndex[k] then
            currentItemIndex[k] = 1
            selectedItemIndex[k] = 1
        end
    end

    Undress(false) -- Déshabille le personnage

    ShowTopNotification(Config.Txt.NotificationTitle, (pedSex == "Female" and Config.Txt.NotificationSubTxtFemale or Config.Txt.NotificationSubTxtMale), 5000) -- Affiche une notification informative
    -- Déplace le PNJ derrière le tabouret
    if DoesEntityExist(stoolObj) and DoesEntityExist(currentPed) then
        SetEntityHeading(stoolObj, GetEntityHeading(pedId))
        Citizen.Wait(2000)
        --FreezeEntityPosition(currentPed, false)
        local forward = GetEntityForwardVector(stoolObj)
        local Gx, Gy, Gz = table.unpack(GetEntityCoords(stoolObj) - forward * - 1.0)
        TaskGoToCoordAnyMeans(currentPed, Gx, Gy, Gz, 1.0, 0, 0, 0, 0.5)
        local to = 10000
        while to > 0 and GetScriptTaskStatus(currentPed, 0x93399E79, 1) ~= 8 do
            to = to - 250
            Wait(250)
        end
        SetPedDesiredHeading(currentPed, GetEntityHeading(pedId))
        to = 6000
        while to > 0 and (math.ceil(GetEntityHeading(currentPed)) ~= math.ceil(GetEntityHeading(pedId))) do
            to = to - 250
            Wait(250)
        end
        --FreezeEntityPosition(currentPed, true)
        TaskStartScenarioInPlace(currentPed, GetHashKey('WORLD_HUMAN_INSPECT'), -1, true, false, false, false)
    end

    -- Crée 4 lampes invisibles, 1 de chaque côté
    createLamps(stoolObj)
    --

    -- Crée le menu principal pour interagir avec le tatoueur
    WarMenu.CreateMenu('generalTattooMenu', Config.Txt.GeneralMenuTitle)
    WarMenu.SetSubTitle('generalTattooMenu', Config.Txt.GeneralMenuSubtitle)
    WarMenu.SetMenuMaxOptionCountOnScreen('generalTattooMenu', 10)
    WarMenu.SetMenuWidth('generalTattooMenu', 0.24)

    -- Crée le sous-menu pour supprimer les tatouages
    WarMenu.CreateSubMenu('deleteTattoo', 'generalTattooMenu', Config.Txt.DeleteMenuTitle)
    WarMenu.SetMenuWidth('deleteTattoo', 0.25)

    -- Crée le sous-menu pour acheter les tatouages
    WarMenu.CreateSubMenu('buyTattoo', 'generalTattooMenu', Config.Txt.BuyMenuTitle)
    WarMenu.SetMenuWidth('buyTattoo', 0.28)

    -- Ouvre le menu principal
    WarMenu.OpenMenu("generalTattooMenu")

    -- Boucle principale d'affichage du menu
    while WarMenu.IsAnyMenuOpened() do
        --
        WarMenu.Display()
        Citizen.Wait(0)
        -- règle le jour
        --Citizen.InvokeNative(0x669E223E64B1903C, 23, 0, 0, 0, 0) -- _NETWORK_CLOCK_TIME_OVERRIDE
        --
        -- Vérifie si le joueur est encore en vie et à proximité du tatoueur, sinon ferme le menu
        if not IsPlayerPlaying(PlayerId()) or (#(GetEntityCoords(pedId) - vector3(x, y, z)) > 5.0) then
            WarMenu.CloseMenu()
        end

        -- Gestion des actions selon le menu ouvert
        if WarMenu.IsMenuOpened('generalTattooMenu') then -- MENU GENERAL
            -- Gère l'affichage et la sélection des tatouages à acheter
            for k, tattoo in pairs(Config.overlays[pedSex]) do
                if WarMenu.ComboBox(string.format(Config.Txt.TattooMenuName, k, tattoo.price), Config.TattooColors, currentItemIndex[k], selectedItemIndex[k], function(currentIndex, selectedIndex)
                    currentItemIndex[k] = currentIndex
                    selectedItemIndex[k] = selectedIndex
                end) then
                    GetSkin(function(back)
                        if back then
                            local textureToUse = ResolveTexture(back, pedSex)
                            if textureToUse then
                                if math.random(50) > 48 then
                                    PlayAmbiantSpeechFromEntity(currentPed, "0315_U_M_M_NbxDoctor_01", "PUSH_SALE", "Speech_Params_Beat_Shouted_Clear_AllowPlayAfterDeath", 0)
                                end
                                tattooSelected.tattoo = tattoo
                                tattooSelected.sex = pedSex
                                tattooSelected.colorName = Config.TattooColors[selectedItemIndex[k]]
                                tattooSelected.Name = k
                                tattooSelected.textures = textureToUse
                                ApplyTexture(pedId, tattoo, textureToUse, selectedItemIndex[k], 1.0)
                            end
                        else
                            WarMenu.CloseMenu()
                        end
                    end)
                end
            end
            if tattooSelected.tattoo then
                if pedSex == "Female" then
                    PromptSetVisible(TattooPrompt, 0)
                    PromptSetVisible(ToplessPrompt, 1)
                    PromptSetText(ToplessPrompt, CreateVarString(10, 'LITERAL_STRING', toggleFemaleShirt and Config.Txt.ToplessOff or Config.Txt.ToplessOn))
                    if PromptHasHoldModeCompleted(ToplessPrompt) then
                       ToggleToplessMode()
                        ApplyTexture(pedId, tattooSelected.tattoo, tattooSelected.textures, tattooSelected.colorId, 1.0)
                    end
                end
                PromptSetActiveGroupThisFrame(TattooPrompts, CreateVarString(10, 'LITERAL_STRING', Config.Txt.GeneralMenuTitle))
            end
            if tattooSelected.Name then
                local isBase = (tattooSelected.colorName == "Noir" or tattooSelected.colorName == "Black")
                local displayPrice = isBase and tattooSelected.tattoo.price or tattooSelected.tattoo.price + Config.ColorPrice
                local buyLabel = string.format(Config.Txt.BuySelectedTattoo, tattooSelected.Name, tattooSelected.colorName, displayPrice)
                if WarMenu.MenuButton(buyLabel, "buyTattoo") then
                    PlayAmbiantSpeechFromEntity(currentPed, "0315_U_M_M_NbxDoctor_01", "PRICE_DISCOUNT", "Speech_Params_Beat_Shouted_Clear_AllowPlayAfterDeath", 0)
                end
            end
            if Config.DeleteAllTattooOption and MY_TATTOO.textures and WarMenu.MenuButton(Config.Txt.DeleteAllTattoo, "deleteTattoo") then
                PlayAmbiantSpeechFromEntity(currentPed, "0315_U_M_M_NbxDoctor_01", "GENERIC_BUY_RESPONSE", "Speech_Params_Beat_Shouted_Clear_AllowPlayAfterDeath", 0)
            elseif WarMenu.Button(Config.Txt.CloseMenu) then
                WarMenu.CloseMenu()
            end
        elseif WarMenu.IsMenuOpened('buyTattoo') then -- ACHAT TATOO
            -- Gère l'achat du tatouage sélectionné
            if WarMenu.Button(string.format(Config.Txt.ConfirmBuyTattoo, tattooSelected.Name, tattooSelected.colorName)) then
                BuyTattoo(tattooSelected)
                Citizen.Wait(2500)
                --WarMenu.OpenMenu("generalTattooMenu") -- Retour au menu général
            elseif WarMenu.MenuButton(Config.Txt.DontBuyTattoo, "generalTattooMenu") then
                DeleteTattoo(pedId, pedSex)
                PlayAmbiantSpeechFromEntity(currentPed, "0315_U_M_M_NbxDoctor_01", "HAVE_A_LOOK_WARY", "Speech_Params_Beat_Shouted_Clear_AllowPlayAfterDeath", 0)
            end
        elseif WarMenu.IsMenuOpened('deleteTattoo') then -- SUPPRESSION TATOO
            -- Gère la suppression des tatouages
            if WarMenu.Button(Config.Txt.ConfirmDeleteTattoo) then
                TriggerServerEvent("redrp-bt:deleteTattoo")
                DeleteTattoo(pedId, pedSex) -- Pour supprimer un tatouage il faut en appliquer un nouveau avec l'opacité à 0.0
                Citizen.Wait(2500)
                WarMenu.OpenMenu("generalTattooMenu") -- Retour au menu général
            elseif WarMenu.MenuButton(Config.Txt.DontWantDeleteTattoo, "generalTattooMenu") then end
        end
    end
    -- Bloque les commandes du joueur
    BlockPlayerCommands(3000)
    -- Supprime les lampes
    removeLamps()
    ClearPedTasks(pedId)
    DeleteTattoo(pedId, pedSex) -- Supprime les tatouages du personnage (uniquement visuel, pas BDD)
    Citizen.Wait(500)
    if pedSex == "Female" then -- La texture change quand les habits changent, donc il faut retirer 2x pour les femmes pour ne pas qu'elle garde le tatouage topless + en sous vêtement
        ToggleToplessMode()
        Citizen.Wait(500)
        DeleteTattoo(pedId, pedSex) -- Supprime les tatouages du personnage (uniquement visuel, pas BDD)
    end
    Citizen.Wait(500) -- ralentissement des requêtes, surtout quand ça concerne le chargement de textures
    Dress() -- Habille le personnage
    -- Supprime le tabouret
    DeleteEntity(stoolObj)
    -- Le PNJ dit aurevoir
    PlayAmbiantSpeechFromEntity(currentPed, "0315_U_M_M_NbxDoctor_01", "FAREWELL", "Speech_Params_Beat_Shouted_Clear_AllowPlayAfterDeath", 0)
    -- MUSIC STOP
    Citizen.InvokeNative(0x1E5185B72EF5158A, "MP_CHARACTER_CREATION_STOP")  -- PREPARE_MUSIC_EVENT
    Citizen.InvokeNative(0x706D57B0F50DA710, "MP_CHARACTER_CREATION_STOP") -- TRIGGER_MUSIC_EVENT
    -- Salue le PNJ
    Citizen.InvokeNative(0xB31A277C1AC7B7FF,pedId,1,2,GetHashKey("KIT_EMOTE_GREET_HAT_TIP_1"),0,0,0,0,0) -- TASK_PLAY_EMOTE_WITH_HASH
    -- remet le joueur visible aux yeux des autres (VORP only)
    if ClientFramework == 'vorp_core' then
        TriggerServerEvent('vorp_core:instanceplayers', 0)
    end
    --
    -- Déplace le PNJ à sa position initiale
    if DoesEntityExist(currentPed) then
        FreezeEntityPosition(currentPed, false)
        TaskGoToCoordAnyMeans(currentPed, x, y, z, 1.0, 0, 0, 0, 0.5)
        local to = 6000
        while to > 0 or GetScriptTaskStatus(currentPed, 0x93399E79, 1) ~= 8 do
            to = to - 250
            Wait(250)
        end
        SetPedDesiredHeading(currentPed, h)
        to = 6000
        while to > 0 and (math.ceil(GetEntityHeading(currentPed)) ~= math.ceil(h)) do
            to = to - 250
            Wait(250)
        end
        Citizen.InvokeNative(0x322BFDEA666E2B0E, currentPed, x, y, z, 2.0, -1082130432, true, true, true, true)
        Citizen.Wait(5000)
        --FreezeEntityPosition(currentPed, true)
    end
    NPCCanMove = true
    --
end

--- Active/Désactive le mode topless pour les femmes
--- @param none
function ToggleToplessMode()
    toggleFemaleShirt = not toggleFemaleShirt
    Undress(toggleFemaleShirt)
    if toggleFemaleShirt and math.random(10) > 9 then -- petit EASTER EGG
        PlayAmbiantSpeechFromEntity(currentPed, "0315_U_M_M_NbxDoctor_01", "GIDDY_UP", "Speech_Params_Beat_Shouted_Clear_AllowPlayAfterDeath", 0)
    end
end

--- Achète un tatouage spécifique
--- @param tattoo Tableau contenant les informations sur le tatouage à acheter
function BuyTattoo(tattoo)
   TriggerServerEvent("redrp-bt:buyTattoo", tattoo)
end

--- Supprime un tatouage du personnage
--- @param pedId Integer ID du personnage
--- @param pedSex String Sexe du personnage ("Male" ou "Female")
function DeleteTattoo(pedId, pedSex)
    tattooSelected = {}
    GetSkin(function(back)
        if back then
            local textureToUse = ResolveTexture(back, pedSex)
            if textureToUse then
                for _, tattoo in pairs(Config.overlays[pedSex]) do
                    ApplyTexture(pedId, tattoo, textureToUse, nil, 0.0)
                end
            end
        end
    end)
end

--- Applique une texture de tatouage au personnage
--- @param pedId Integer ID du personnage
--- @param tattoo Tableau Informations sur le tatouage à appliquer
--- @param textures Tableau Informations sur les textures du tatouage
--- @param colorIndex Integer index de la couleur du tatouage
--- @param opacity Float Opacité du tatouage
function ApplyTexture(pedId, tattoo, textures, colorIndex, opacity)
    if currentTextureId then
        Citizen.InvokeNative(0xB63B9178D0F58D82, currentTextureId) -- reset texture
        Citizen.InvokeNative(0x6BEFAA907B076859, currentTextureId) -- remove texture
    end
    local textureID = Citizen.InvokeNative(0xC5E7204F322E49EB, joaat(textures.baseAlbedo), joaat(textures.baseNormal), joaat(textures.baseMaterial))
    currentTextureId = textureID
    local overlayIndex = Citizen.InvokeNative(0x86BB5FF45F193A02, textureID, joaat(tattoo.textureDict), 0, joaat(textures.baseMaterial), 0, 1.0, 0) -- _ADD_TEXTURE_LAYER
    Citizen.InvokeNative(0x1ED8588524AC9BE1, textureID, overlayIndex, joaat(tattoo.palette)) -- _SET_TEXTURE_LAYER_PALLETE
    Citizen.InvokeNative(0x2DF59FFE6FFD6044, textureID, overlayIndex, colorIndex and Config.TattooColorsValue[colorIndex] or 0, 0, 0) -- _SET_TEXTURE_LAYER_TINT
    Citizen.InvokeNative(0x3329AAE2882FC8E4, textureID, overlayIndex, 2) -- _SET_TEXTURE_LAYER_SHEET_GRID_INDEX
    Citizen.InvokeNative(0x6C76BC24F8BB709A, textureID, overlayIndex, opacity) -- _SET_TEXTURE_LAYER_ALPHA
    local timer = GetGameTimer()+5000
    while not Citizen.InvokeNative(0x31DC8D3F216D8509, textureID) do
        Wait(50)
        if timer < GetGameTimer() then
            break
        end
    end
    if Citizen.InvokeNative(0x31DC8D3F216D8509, textureID) then -- _IS_TEXTURE_VALID
        Citizen.InvokeNative(0x0B46E25761519058, pedId, joaat('bodies_upper'), textureID) -- _APPLY_TEXTURE_ON_PED
        Citizen.InvokeNative(0x92DAABA2C1C10B0E, textureID) -- _UPDATE_PED_TEXTURE
        --Citizen.InvokeNative(0xD3A7B003ED343FD9, pedId, joaat('tattoo.shopItem'), true, true, false) --> CETTE LIGNE MODIFIE LE VISAGE, ELLE EST INUTILE
        --Citizen.Wait(500)
        Citizen.InvokeNative(0xAAB86462966168CE, pedId, true)
        Citizen.InvokeNative(0xCC8CA3E88256E58F, pedId, false, true, true, true, false)
        tattooSelected.colorId = colorIndex or 0
    end
end


--- Déclenche un événement réseau pour définir la table de tatouages du joueur
--- @param tattooTable Tableau contenant les informations sur les tatouages du joueur
RegisterNetEvent('redrp-bt:setTattooTable')
AddEventHandler('redrp-bt:setTattooTable', function(tattooTable)
    if tattooTable and type(tattooTable) == "table" then
        MY_TATTOO = tattooTable
        if MY_TATTOO.textures and MY_TATTOO.tattoo and MY_TATTOO.colorId then
            if currentPed then
                PlayAmbiantSpeechFromEntity(currentPed, "0315_U_M_M_NbxDoctor_01", "BUY_UNIQUE_ITEM", "Speech_Params_Beat_Shouted_Clear_AllowPlayAfterDeath", 0)
            end
            ApplyTexture(PlayerPedId(), MY_TATTOO.tattoo, MY_TATTOO.textures, MY_TATTOO.colorId, 1.0)
        end
    end
end)

--- Déclenche un événement réseau pour fermer le tatoueur si le joueur à le droit à un seul tattoo
--- @param none
RegisterNetEvent('redrp-bt:closeTattooShop')
AddEventHandler('redrp-bt:closeTattooShop', function()
    WarMenu.CloseMenu()
end)