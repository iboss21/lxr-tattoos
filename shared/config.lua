--[[
    ██╗     ██╗  ██╗██████╗       ████████╗ █████╗ ████████╗████████╗ ██████╗  ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ╚══██╔══╝██╔══██╗╚══██╔══╝╚══██╔══╝██╔═══██╗██╔═══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗   ██║   ███████║   ██║      ██║   ██║   ██║██║   ██║███████╗
    ██║      ██╔██╗ ██╔══██╗╚════╝   ██║   ██╔══██║   ██║      ██║   ██║   ██║██║   ██║╚════██║
    ███████╗██╔╝ ██╗██║  ██║         ██║   ██║  ██║   ██║      ██║   ╚██████╔╝╚██████╔╝███████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝         ╚═╝   ╚═╝  ╚═╝   ╚═╝      ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝
                                                                                               
    🐺 LXR Core - Tattoo Shop System
    
    This configuration file controls the tattoo shop system for RedM.
    Players can visit tattoo shops to purchase and apply custom tattoos to their characters.
    Each tattoo has configurable prices, colors, and textures.
    
    ═══════════════════════════════════════════════════════════════════════════════
    SERVER INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════
    
    Server:      The Land of Wolves 🐺
    Tagline:     Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!
    Description: ისტორია ცოცხლდება აქ! (History Lives Here!)
    Type:        Serious Hardcore Roleplay
    Access:      Discord & Whitelisted
    
    Developer:   iBoss21 / The Lux Empire
    Website:     https://www.wolves.land
    Discord:     https://discord.gg/CrKcWdfd3A
    GitHub:      https://github.com/iBoss21
    Store:       https://theluxempire.tebex.io
    Server:      https://servers.redm.net/servers/detail/8gj7eb
    
    ═══════════════════════════════════════════════════════════════════════════════
    
    Version: 1.0.0
    Performance Target: Optimized for minimal server overhead and client FPS impact
    
    Tags: RedM, Georgian, SeriousRP, Whitelist, Tattoos, Customization, Roleplay
    
    Framework Support:
    - LXR Core (Primary)
    - RSG Core (Compatible)
    - VORP Core (Compatible)
    - RedEM:RP (Compatible)
    - QBR Core (Compatible)
    - QR Core (Compatible)
    - Standalone (Compatible)
    
    ═══════════════════════════════════════════════════════════════════════════════
    CREDITS
    ═══════════════════════════════════════════════════════════════════════════════
    
    Script Author: iBoss21 / The Lux Empire for The Land of Wolves
    Original Concept: Community-driven tattoo system
    Inspired by: Character customization and roleplay immersion
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 RESOURCE NAME PROTECTION - RUNTIME CHECK
-- ═══════════════════════════════════════════════════════════════════════════════

local REQUIRED_RESOURCE_NAME = "lxr-tattoos"
local currentResourceName = GetCurrentResourceName()

if currentResourceName ~= REQUIRED_RESOURCE_NAME then
    error(string.format([[
        
        ═══════════════════════════════════════════════════════════════════════════════
        ❌ CRITICAL ERROR: RESOURCE NAME MISMATCH ❌
        ═══════════════════════════════════════════════════════════════════════════════
        
        Expected: %s
        Got: %s
        
        This resource is branded and must maintain the correct name.
        Rename the folder to "%s" to continue.
        
        🐺 wolves.land - The Land of Wolves
        
        ═══════════════════════════════════════════════════════════════════════════════
        
    ]], REQUIRED_RESOURCE_NAME, currentResourceName, REQUIRED_RESOURCE_NAME))
end

Config = {}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SERVER BRANDING & INFO ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.ServerInfo = {
    name = 'The Land of Wolves 🐺',
    tagline = 'Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!',
    description = 'ისტორია ცოცხლდება აქ!', -- History Lives Here!
    type = 'Serious Hardcore Roleplay',
    access = 'Discord & Whitelisted',
    
    -- Contact & Links
    website = 'https://www.wolves.land',
    discord = 'https://discord.gg/CrKcWdfd3A',
    github = 'https://github.com/iBoss21',
    store = 'https://theluxempire.tebex.io',
    serverListing = 'https://servers.redm.net/servers/detail/8gj7eb',
    
    -- Developer Info
    developer = 'iBoss21 / The Lux Empire',
    
    -- Tags
    tags = {'RedM', 'Georgian', 'SeriousRP', 'Whitelist', 'Tattoos', 'Customization', 'Roleplay'}
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ FRAMEWORK CONFIGURATION ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    Framework Priority (in order):
    1. LXR-Core (Primary)
    2. RSG-Core (Primary)
    3. VORP Core (Supported)
    4. RedEM:RP (Optional - if detected)
    5. QBR-Core (Optional - if detected)
    6. QR-Core (Optional - if detected)
    7. Standalone (Fallback)
]]

Config.Framework = 'auto' -- 'auto' or manual: 'lxr-core', 'rsg-core', 'vorp_core', 'redem_roleplay', 'qbr-core', 'qr-core', 'standalone'

-- Framework-specific settings
Config.FrameworkSettings = {
    ['lxr-core'] = {
        resource = 'lxr-core',
        notifications = 'ox_lib', -- notification system to use
        inventory = 'lxr-inventory',
        target = 'ox_target',
        -- Event naming convention
        events = {
            server = 'lxr-core:server:%s',
            client = 'lxr-core:client:%s',
            callback = 'lxr-core:callback:%s'
        }
    },
    ['rsg-core'] = {
        resource = 'rsg-core',
        notifications = 'ox_lib',
        inventory = 'rsg-inventory',
        target = 'ox_target',
        events = {
            server = 'RSGCore:Server:%s',
            client = 'RSGCore:Client:%s',
            callback = 'RSGCore:Callback:%s'
        }
    },
    ['vorp_core'] = {
        resource = 'vorp_core',
        notifications = 'vorp',
        inventory = 'vorp_inventory',
        target = 'vorp_core',
        events = {
            server = 'vorp:server:%s',
            client = 'vorp:client:%s'
        }
    },
    ['redem_roleplay'] = {
        resource = 'redem_roleplay',
        notifications = 'redem',
        inventory = 'redem_inventory',
        target = 'redem_target',
        events = {
            server = 'redem:%s:server',
            client = 'redem:%s:client'
        }
    },
    ['qbr-core'] = {
        resource = 'qbr-core',
        notifications = 'ox_lib',
        inventory = 'qbr-inventory',
        target = 'ox_target',
        events = {
            server = 'QBR:Server:%s',
            client = 'QBR:Client:%s'
        }
    },
    ['qr-core'] = {
        resource = 'qr-core',
        notifications = 'ox_lib',
        inventory = 'qr-inventory',
        target = 'ox_target',
        events = {
            server = 'QR:Server:%s',
            client = 'QR:Client:%s'
        }
    },
    ['standalone'] = {
        -- Minimal functionality without framework
        notifications = 'print',
        inventory = 'none',
        target = 'none'
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ GENERAL SETTINGS ██████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.DEBUG = false -- Debug mode: All tattoos cost $1 when true
Config.UpdateTattooEveryMinute = false -- Update tattoos every minute (for texture sync issues)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ NPC & SHOP CONFIGURATION ██████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.NPCModel = "mp_u_m_m_traderintroclerk_01" -- NPC model for tattoo artist

Config.ShowBlips = true -- Show tattoo shop blips on map
Config.BlipName = "Tattoo Artist"
Config.BlipSprite = 2017085833

Config.Shops = {
    {
        NPC = { x = 2720.2, y = -1290.25, z = 59.29, h = 20.1 },
        STOOL = { x = 2719.0, y = -1288.2, z = 59.34 }
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ TATTOO OPTIONS ████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.DeleteAllTattooOption = true -- Show option to remove all tattoos
Config.OnlyOneTattoo = false -- Allow only one tattoo per character

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ COLOR CONFIGURATION ███████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.ColorPrice = 50 -- Price to change tattoo color

Config.TattooColors = {
    "Black",
    "Red",
    "Blue",
    "Blood",
    "Purple",
    "Yellow"
}

Config.TattooColorsValue = {
    120, -- Black
    1,   -- Red
    100, -- Blue
    150, -- Blood
    220, -- Purple
    110  -- Yellow
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ LANGUAGE CONFIGURATION ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Txt = {
    AlreadyBoughtTattoo = "You have already bought a tattoo",
    TattooPrompt = "Buy a tattoo",
    ToplessPrompt = "Remove the top",
    NPCName = "Tattoo Artist",
    NotificationTitle = "Tattoo Artist Information",
    NotificationSubTxtMale = "You are invisible to others.",
    NotificationSubTxtFemale = "You can remove the top after selecting a tattoo. \n You are invisible to others.",
    GeneralMenuTitle = "Tattoo Artist",
    GeneralMenuSubtitle = "Color +" .. Config.ColorPrice .."$",
    DeleteMenuTitle = "REMOVE TATTOOS",
    BuyMenuTitle = "Buy Tattoo",
    TattooMenuName = "%s: %d$", -- Name: Price $
    ToplessOff = "Put the top back on",
    ToplessOn = "REMOVE (topless) the top",
    BuySelectedTattoo = "Buy %s in %s for %d$", -- TattooName, TattooColor, TattooPrice
    DeleteAllTattoo = ">[Remove all my tattoos]<",
    ConfirmDeleteTattoo = "I confirm that I want to remove my tattoos",
    DontWantDeleteTattoo = "I don't want to remove my tattoos",
    CloseMenu = "Close",
    ConfirmBuyTattoo = "I want to buy %s in %s", -- TatooName, TattoColorName
    DontBuyTattoo = "I don't want to buy this tattoo",
    Server_NotEnoughMoney = "You don't have enough money, you're missing: %s$",
    Server_BuyTattooMoney = "Tattoo purchase: -%s$"
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ TATTOO OVERLAYS CONFIGURATION █████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.overlays = {
    Male = {
        ["Tatouage Torse 1"] = {
            textureDict = 'custom_tattoo_one',
            material = 'overlay_ma',
            palette = 'metaped_tint_makeup',
            price = 400,
        },
        ["Tatouage 1"] = {
            textureDict = 'overlay_hand_eaglemom',
            material = 'overlay_hand_eaglemom_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 2"] = {
            textureDict = 'overlay_hand_sailor',
            material = 'overlay_hand_sailor_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 3"] = {
            textureDict = 'overlay_hand_chester',
            material = 'overlay_hand_chester_ma',
            palette = 'metaped_tint_makeup',
            price = 200,
        },
        ["Tatouage 4"] = {
            textureDict = 'overlay_hand_western',
            material = 'overlay_hand_western_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 5"] = {
            textureDict = 'overlay_hand_madame',
            material = 'overlay_hand_madame_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 6"] = {
            textureDict = 'overlay_hand_madame2',
            material = 'overlay_hand_madame2_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 7"] = {
            textureDict = 'overlay_hand_madame3',
            material = 'overlay_hand_madame3_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 8"] = {
            textureDict = 'overlay_hand_madame4',
            material = 'overlay_hand_madame4_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 9"] = {
            textureDict = 'overlay_hand_maori',
            material = 'overlay_hand_maori_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 10"] = {
            textureDict = 'overlay_hand_multi1',
            material = 'overlay_hand_multi1_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 11"] = {
            textureDict = 'overlay_hand_multi2',
            material = 'overlay_hand_multi2_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 12"] = {
            textureDict = 'overlay_hand_cards1',
            material = 'overlay_hand_cards1_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 13"] = {
            textureDict = 'overlay_hand_ranch',
            material = 'overlay_hand_ranch_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 14"] = {
            textureDict = 'overlay_hand_full',
            material = 'overlay_hand_full_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 15"] = {
            textureDict = 'overlay_hand_full2',
            material = 'overlay_hand_full2_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 16"] = {
            textureDict = 'custom_tattoo_two',
            material = 'overlay_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
    },
    Female = {
        ["Tatouage Torse 1"] = {
            textureDict = 'custom_tattoo_one',
            material = 'overlay_ma',
            palette = 'metaped_tint_makeup',
            price = 400
        },
        ["Tatouage 1"] = {
            textureDict = 'overlay_hand_full2',
            material = 'overlay_hand_full2_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 2"] = {
            textureDict = 'overlay_hand_full',
            material = 'overlay_hand_full_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 3"] = {
            textureDict = 'overlay_hand_fem',
            material = 'overlay_hand_fem_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 4"] = {
            textureDict = 'overlay_hand_chester',
            material = 'overlay_hand_chester_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 5"] = {
            textureDict = 'overlay_hand_fem2',
            material = 'overlay_hand_fem2_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 6"] = {
            textureDict = 'overlay_hand_madame3',
            material = 'overlay_hand_madame3_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 7"] = {
            textureDict = 'overlay_hand_madame2',
            material = 'overlay_hand_madame2_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 8"] = {
            textureDict = 'overlay_hand_fem3',
            material = 'overlay_hand_fem3_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 9"] = {
            textureDict = 'overlay_hand_fem4',
            material = 'overlay_hand_fem4_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 10"] = {
            textureDict = 'overlay_hand_fem5',
            material = 'overlay_hand_fem5_ma',
            palette = 'metaped_tint_makeup',
            price = 200,
        },
        ["Tatouage 11"] = {
            textureDict = 'overlay_hand_fem6',
            material = 'overlay_hand_fem6_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 12"] = {
            textureDict = 'overlay_hand_fem7',
            material = 'overlay_hand_fem7_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 13"] = {
            textureDict = 'overlay_hand_fem8',
            material = 'overlay_hand_fem8_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 14"] = {
            textureDict = 'overlay_hand_fem9',
            material = 'overlay_hand_fem9_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 15"] = {
            textureDict = 'custom_tattoo_two',
            material = 'overlay_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        },
        ["Tatouage 16"] = {
            textureDict = 'custom_tattoo_music',
            material = 'overlay_ma',
            palette = 'metaped_tint_makeup',
            price = 200
        }
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ TEXTURE CONFIGURATION █████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Textures = {
    Male = {
        {
            baseAlbedo = 'mp_hand_mr1_000_c0_001_ab',
            baseNormal = 'mp_hand_mr1_000_c0_001_nm',
            baseMaterial = 'mp_hand_mr1_000_c0_000_m'
        },
        {
            baseAlbedo = 'mp_hand_mr1_000_c0_002_ab',
            baseNormal = 'mp_hand_mr1_000_c0_002_nm',
            baseMaterial = 'mp_hand_mr1_000_c0_000_m'
        },
        {
            baseAlbedo = 'mp_hand_mr1_000_c0_003_ab',
            baseNormal = 'mp_hand_mr1_000_c0_003_nm',
            baseMaterial = 'mp_hand_mr1_000_c0_000_m'
        },
        {
            baseAlbedo = 'mp_hand_mr1_000_c0_004_ab',
            baseNormal = 'mp_hand_mr1_000_c0_004_nm',
            baseMaterial = 'mp_hand_mr1_000_c0_000_m'
        },
        {
            baseAlbedo = 'mp_hand_mr1_000_c0_005_ab',
            baseNormal = 'mp_hand_mr1_000_c0_005_nm',
            baseMaterial = 'mp_hand_mr1_000_c0_000_m'
        },
        {
            baseAlbedo = 'mp_hand_mr1_000_c0_005_ab',
            baseNormal = 'mp_hand_mr1_000_c0_005_nm',
            baseMaterial = 'mp_hand_mr1_000_c0_000_m'
        },
        {
            baseAlbedo = 'mp_hand_mr1_000_c0_008_ab',
            baseNormal = 'mp_hand_mr1_000_c0_000_nm',
            baseMaterial = 'mp_hand_mr1_000_c0_000_m'
        }
    },
    Female = {
        {
            baseAlbedo = 'mp_hand_fr1_000_c0_001_ab',
            baseNormal = 'mp_hand_fr1_000_c0_001_nm',
            baseMaterial = 'mp_hand_fr1_000_c0_000_m'
        },
        {
            baseAlbedo = 'mp_hand_fr1_000_c0_002_ab',
            baseNormal = 'mp_hand_fr1_000_c0_002_nm',
            baseMaterial = 'mp_hand_fr1_000_c0_000_m'
        },
        {
            baseAlbedo = 'mp_hand_fr1_000_c0_003_ab',
            baseNormal = 'mp_hand_fr1_000_c0_003_nm',
            baseMaterial = 'mp_hand_fr1_000_c0_000_m'
        },
        {
            baseAlbedo = 'mp_hand_fr1_000_c0_004_ab',
            baseNormal = 'mp_hand_fr1_000_c0_004_nm',
            baseMaterial = 'mp_hand_mr1_000_c0_000_m'
        },
        {
            baseAlbedo = 'mp_hand_fr1_000_c0_005_ab',
            baseNormal = 'mp_hand_fr1_000_c0_005_nm',
            baseMaterial = 'mp_hand_fr1_000_c0_000_m'
        },
        {
            baseAlbedo = 'mp_hand_fr1_000_c0_008_ab',
            baseNormal = 'mp_hand_fr1_000_c0_008_nm',
            baseMaterial = 'mp_hand_fr1_000_c0_000_m'
        }
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ PED COMPONENTS (DO NOT MODIFY) ████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.PedComponents = {
    0x9925C067,
    0x5E47CA6,
    0x5FC29285,
    0x7A96FACA,
    0x2026C46D,
    0x877A2CF7,
    0x485EE834,
    0xE06D30CE,
    0xAF14310B,
    0x3C1A74CD,
    0xEABE0032,
    0x7A6BBD0B,
    0xF16A1D23,
    0x7BC10759,
    0x9B2C8B89,
    0xA6D134C6,
    0xFAE9107F,
    0x91CE9B20,
    0x83887E88,
    0x79D7DF96,
    0x94504D26,
    0xF1542D11,
    0x94504D26,
    0x9B2C8B89,
    0xFAE9107F,
    0xB6B6122D,
    0x1D4C528A,
    0xA0E3AB7F,
    0x3107499B,
    0x777EC6EF,
    0x18729F39,
    0xF1542D11,
    0x514ADCEA,
    0x91CE9B20,
    0x83887E88,
    0x79D7DF96,
    0x94504D26
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ CHARACTER HEADS (DO NOT MODIFY) ███████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.CharHeads = {
    Male = {
        "mp_head_mr1_sc08_c0_000_ab",
        "mp_head_mr1_sc02_c0_000_ab",
        "mp_head_mr1_sc03_c0_000_ab",
        "MP_head_fr1_sc01_c0_000_ab",
        "mp_head_mr1_sc04_c0_000_ab",
        "mp_head_fr1_sc05_c0_000_ab"
    },
    Female = {
        "mp_head_fr1_sc08_c0_000_ab",
        "mp_head_fr1_sc02_c0_000_ab",
        "mp_head_fr1_sc03_c0_000_ab",
        "mp_head_fr1_sc05_c0_000_ab",
        "mp_head_fr1_sc01_c0_000_ab",
        "mp_head_fr1_sc04_c0_000_ab"
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ END OF CONFIGURATION ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Startup banner
CreateThread(function()
    Wait(1000)
    print([[
        
        ═══════════════════════════════════════════════════════════════════════════════
        
            ██╗     ██╗  ██╗██████╗       ████████╗ █████╗ ████████╗████████╗ ██████╗  ██████╗ ███████╗
            ██║     ╚██╗██╔╝██╔══██╗      ╚══██╔══╝██╔══██╗╚══██╔══╝╚══██╔══╝██╔═══██╗██╔═══██╗██╔════╝
            ██║      ╚███╔╝ ██████╔╝█████╗   ██║   ███████║   ██║      ██║   ██║   ██║██║   ██║███████╗
            ██║      ██╔██╗ ██╔══██╗╚════╝   ██║   ██╔══██║   ██║      ██║   ██║   ██║██║   ██║╚════██║
            ███████╗██╔╝ ██╗██║  ██║         ██║   ██║  ██║   ██║      ██║   ╚██████╔╝╚██████╔╝███████║
            ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝         ╚═╝   ╚═╝  ╚═╝   ╚═╝      ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝
        
        ═══════════════════════════════════════════════════════════════════════════════
        🐺 TATTOO SHOP SYSTEM - SUCCESSFULLY LOADED
        ═══════════════════════════════════════════════════════════════════════════════
        
        Version:     1.0.0
        Server:      ]] .. Config.ServerInfo.name .. [[
        
        Framework:   Auto-detect enabled
        Shops:       ]] .. #Config.Shops .. [[ tattoo shop location(s)
        Male:        ]] .. (function() local count = 0 for _ in pairs(Config.overlays.Male) do count = count + 1 end return count end)() .. [[ tattoo designs
        Female:      ]] .. (function() local count = 0 for _ in pairs(Config.overlays.Female) do count = count + 1 end return count end)() .. [[ tattoo designs
        Colors:      ]] .. #Config.TattooColors .. [[ color options
        
        Debug:       ]] .. (Config.DEBUG and 'ENABLED' or 'DISABLED') .. [[
        
        ═══════════════════════════════════════════════════════════════════════════════
        
        Developer:   iBoss21 / The Lux Empire
        Website:     https://www.wolves.land
        Discord:     https://discord.gg/CrKcWdfd3A
        
        ═══════════════════════════════════════════════════════════════════════════════
        
    ]])
end)
