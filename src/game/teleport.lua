local com = require("component")
local module = require("ut-serv.modules")

local events = module.load("events")
local config = module.load("config")

local debug = com.debug
local EventEngine = events.engine

local points = {}
local sides = {"n", "ne", "e", "se", "s", "sw", "w", "nw", "top"}

-- Copy the data to the table points for easier access
for _, side in pairs(sides) do
  points[side] = config.get("teleport", {}, true).get(side, {0, 0, 0})
end

EventEngine:subscribe("teleport", events.priority.low, function(handler, evt)
  local pl = debug.getPlayer(evt.nick)
  pl.setPosition(table.unpack(points[evt.point]))
end)
