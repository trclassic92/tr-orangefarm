fx_version 'cerulean'
game 'gta5'

author 'ProjextX - TRClassic'
description 'Resource made by ProjextX - Reason (Tried of seeing bullshit paid resources)'
version '1.0.0'
discord 'https://discord.gg/ezU9f2nWAs'

shared_script {
--    '@es_extended/imports.lua',   -- Remove if using QBCore
    '@ox_lib/init.lua',
    'config.lua'
}

client_script 'Client/*.lua'

server_script 'Server/*.lua'

lua54 'yes'
