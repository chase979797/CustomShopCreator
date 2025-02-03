fx_version 'cerulean'
game 'gta5'

author 'Chase'
description 'Usable Clothing Items & Shop for QBCore'
version '1.1.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

lua54 'yes'