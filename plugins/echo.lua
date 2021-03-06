--[[
    Copyright 2017 wrxck <matthew@matthewhesketh.com>
    This code is licensed under the MIT. See LICENSE for details.
]]

local echo = {}

local mattata = require('mattata')

function echo:init()
    echo.commands = mattata.commands(
        self.info.username
    ):command('echo').table
    echo.help = '/echo <text> - Repeats the given string of text.'
end

function echo:on_message(message, configuration)
    local input = mattata.input(message.text)
    if not input then
        return mattata.send_reply(
            message,
            echo.help
        )
    end
    return mattata.send_message(
        message.chat.id,
        input
    )
end

return echo