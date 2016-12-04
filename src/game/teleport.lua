local debug = require("component").debug
local module = require("ut-serv.modules")

local events = module.load("events")
local config = module.load("config")

EventEngine = events.engine

local points = {}
local sides = {"n", "ne", "e", "se", "s", "sw", "w", "nw", "top"}

-- Copy the data to the table points for easier access
for _, side in pairs(sides) do
  points[side] = config.get("teleport", {}, true).get(side, {0, 0, 0})
end


EventEngine:subscribe("teleport", events.priority.low, function(handler, evt)
  debug.runCommand(("tp %s %d %d %d"):format(evt.nick,
                                             table.unpack(points[evt.point])))
end)
