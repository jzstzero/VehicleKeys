fx_version 'cerulean'
game 'gta5'

author 'JzstZer0'
description 'a simple FiveM vehicle key system'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/imports.lua',
    'config.lua',
    'server.lua'
}

client_scripts {
    'config.lua',
    'client.lua'
}

shared_script 'config.lua'

lua54 'yes'
