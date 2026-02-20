--[[
    ██╗     ██╗  ██╗██████╗       ████████╗ █████╗ ████████╗████████╗ ██████╗  ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ╚══██╔══╝██╔══██╗╚══██╔══╝╚══██╔══╝██╔═══██╗██╔═══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗   ██║   ███████║   ██║      ██║   ██║   ██║██║   ██║███████╗
    ██║      ██╔██╗ ██╔══██╗╚════╝   ██║   ██╔══██║   ██║      ██║   ██║   ██║██║   ██║╚════██║
    ███████╗██╔╝ ██╗██║  ██║         ██║   ██║  ██║   ██║      ██║   ╚██████╔╝╚██████╔╝███████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝         ╚═╝   ╚═╝  ╚═╝   ╚═╝      ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝
                                                                                               
    🐺 wolves.land - The Land of Wolves
    Developer: iBoss21 / The Lux Empire
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

fx_version "cerulean"
game 'rdr3'
lua54 'yes'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

name 'LXR Tattoos'
description 'Advanced tattoo shop system for RedM with multi-framework support'
author 'iBoss21 / The Lux Empire'
version '1.0.0'

shared_scripts {
    'shared/*.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',         -- MySQL init (oxmysql - standard for lxr-core/rsg-core)
    'server/*.lua'
}

dependencies {
    'oxmysql',
}

escrow_ignore {
    '*',
    'shared/*.lua',
    'client/*.lua',
    'server/*.lua'
}

dependency '/assetpacks'