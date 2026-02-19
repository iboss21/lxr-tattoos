fx_version "cerulean"
game 'rdr3'
lua54 'yes'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'


shared_scripts {
    'shared/*.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',     -- MySQL init
    'server/*.lua'
}

escrow_ignore {
    '*',
    'shared/*.lua',
    'client/*.lua',
    'server/*.lua'
}
dependency '/assetpacks'