local module = require("ut-serv.modules")
module.clearCache()

local events = module.load("events")

EventEngine = events.engine

EventEngine:push(events.events.Init())

local running = true

EventEngine:subscribe("quit", events.priorities.bottom, function(handler, evt)
  running = false
end)

while running do
  -- :)
  os.sleep(.05)
end

EventEngine:push(events.events.Stop())

EventEngine:__gc()
