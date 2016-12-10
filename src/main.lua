-- The main module.
--
-- This is where everything starts.
--
-- Try to keep as many code as possible in other modules.
-- This is only for basic initialization.

local event = require("event")
local comp = require("computer")

local module = require("ut-serv.modules")
module.clearCache()

-- load all modules
local events = module.load("events")
module.load("config")
module.load("network")
module.load("db")
module.load("game.world")
module.load("game.teleport")
module.load("glasses.ui")
module.load("glasses.update")
module.load("glasses.surface")

EventEngine = events.engine

local instance = events.Init()
EventEngine:push(instance)

local running = true

EventEngine:subscribe("quit", events.priority.bottom, function(handler, evt)
  running = false
end)

while running do
  if event.pull(.05, "interrupted") then
    running = false
  end
end

EventEngine:push(events.Stop())

EventEngine:__gc()

module.clearCache()

