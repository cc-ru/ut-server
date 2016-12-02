local module = require("ut-serv.modules")
module.clearCache()

local events = module.load("events")

EventEngine = events.engine

EventEngine:push(events.events.Init())

-- TODO: add code

EventEngine:push(events.events.Stop())

EventEngine:__gc()
