client_scripts {
	'client/cl_main.lua',
	'config.lua'
}

server_scripts {
	'server/sv_main.lua',
	'config.lua',
	'@mysql-async/lib/MySQL.lua'
}

games { 'rdr3', 'gta5' }

fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'