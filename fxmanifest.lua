fx_version 'adamant'

game 'gta5'

author 'daavee#0101'
description 'dv_doctor'

shared_script 'config.lua'

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/hu.lua',
	'client/main.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/hu.lua',
	'server/main.lua'
}

dependencies {
	'es_extended',
	'esx_ambulancejob',
	'esx_billing',
	'progressBars'
}
