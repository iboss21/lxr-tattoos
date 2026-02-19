Config = {}
Config.DEBUG = true -- All Tattoo price 1$ when you buy it

Config.NPCModel = "mp_u_m_m_traderintroclerk_01"

Config.ShowBlips = true -- true->Show/false->Hide blips
Config.BlipName = "Tatoueur"
Config.BlipSprite = 2017085833
Config.DeleteAllTattooOption = true -- true->Show/false->Hide Delete All Tattoo Option
Config.OnlyOneTattoo = false -- true -> The player can buy only one tattoo for their character, and they are not entitled to a second chance.
Config.UpdateTattooEveryMinute = false -- true -> will update every minute, you can try if you encounter some problem with women textures sync

Config.Shops = { -- PNJ vendeur
    {
        NPC = { x = 2720.2, y = -1290.25, z = 59.29, h = 20.1 },
        STOOL = { x= 2719.0, y = -1288.2, z = 59.34 }
    }
}

Config.ColorPrice = 50

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
    1, -- Red
    100, -- Blue
    150, -- Blood
    220, -- Purple
    110 -- Yellow
}

Config.Txt = {
    AlreadyBoughtTattoo = "You have already bought a tattoo", -- NEW TXT ADDED (18/05)
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
    ConfirmBuyTattoo = "I want to buy %s in %s", -- TatooName, TattoColorName,
    DontBuyTattoo = "I don't want to buy this tattoo",
    Server_NotEnoughMoney = "You don't have enough money, you're missing: %s$", -- Missing money (difference between tattoo price and player wallet)
    Server_BuyTattooMoney = "Tattoo purchase: -%s$" -- Tattoo price
}

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

Config.Textures = { -- DON'T TOUCH
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

Config.PedComponents = {  -- DON'T TOUCH
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

Config.CharHeads = { -- DON'T TOUCH
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
