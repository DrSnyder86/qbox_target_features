fx_version 'cerulean'
game 'gta5'

author 'DrSnyder'
name "qbox_target_features"
description 'Qbox Target Features - Enhanced ox_target interactions for players and vehicles'
version '1.0'
repository 'https://github.com/DrSnyder/qbox_target_features'

lua54 'yes'

client_scripts {
    'client.lua'
}
shared_scripts {
    'config.lua',
    '@ox_lib/init.lua'
}
