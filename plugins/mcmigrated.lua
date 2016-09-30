local mcmigrated = {}
local HTTPS = require('ssl.https')
local JSON = require('dkjson')
local functions = require('functions')
function mcmigrated:init(configuration)
	mcmigrated.command = 'mcmigrated <username>'
	mcmigrated.triggers = functions.triggers(self.info.username, configuration.command_prefix):t('mcmigrated', true).table
	mcmigrated.documentation = configuration.command_prefix .. 'mcmigrated <username> - Tells you if a Minecraft username has been migrated to a Mojang account.'
end
function mcmigrated:action(msg, configuration)
	local input = functions.input(msg.text)
	if not input then
		functions.send_reply(msg, mcmigrated.documentation)
		return
	end
	local url = configuration.apis.mcmigrated .. input
	local jstr, res = HTTPS.request(url)
	if res ~= 200 then
		functions.send_reply(msg, configuration.errors.connection)
		return
	end
	local jdat = JSON.decode(jstr)
	local output = jdat.migrated:gsub('true', 'This username has been migrated to a Mojang account!'):gsub('false', 'This username has not been migrated to a Mojang account.')
	functions.send_reply(msg, output)
end
return mcmigrated