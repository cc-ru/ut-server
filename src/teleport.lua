local debug=require("component").debug
local module = require("ut-serv.modules")

local events = module.load("events")
local config=module.load("config")
EventEngine = events.engine

points={}
local sides={"nw","ne","sw","se","top"}

for i=1,5 do
  points[sides[i]]=config.get("teleport", {}, true).get(sides[i], {0, 0, 0}) --return cord of point
end

EventEngine:subscribe("teleport",0,function(handler,evt)
--print(evt.nick,evt.point)
debug.runCommand("tp "..evt.nick.." "..points[evt.point].x.." "..points[evt.point].y.." "..points[evt.point].z)
end)

------------request--------------------------
--local ev=EventEngine:event("teleport")
--EventEngine:push(ev{nick="@p",point="ne"})
---------------------------------------------

EventEngine:__gc()
