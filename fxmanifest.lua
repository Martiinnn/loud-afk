fx_version 'cerulean'
game 'gta5'
author 'Martin'
description 'Loud Roleplay CL'
version '1.3.7'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua'
}

client_script {
    'client/*.lua'
}

server_scripts {
    'server/*.lua',
    '@oxmysql/lib/MySQL.lua'
}
