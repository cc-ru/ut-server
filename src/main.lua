local aevent = require("aevent")
local event = require("event")

local events = require("ut-serv.events")


local EventEngine = aevent()

events.register(EventEngine)

EventEngine:push(events.events.Init())

-- TODO: add code

EventEngine:push(events.events.Stop())

EventEngine:__gc()
