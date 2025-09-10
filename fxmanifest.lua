fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Puffin-Project'
description 'Puffin Job Center - Browse, select, and start jobs or mark locations in FiveM'
version '1.0.0'

shared_scripts {
    'shared/config.lua',
    'shared/translations.lua',
}

client_script {
    'client/functions.lua',
    'client/main.lua',
}

server_script {
    'server/updateChecker.lua',
    'server/main.lua',
}

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/styles/styles.css',
    'ui/script.js',
    'ui/images/*.png',
}