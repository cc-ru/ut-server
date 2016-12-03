local component = require("component")

local module = require("ut-serv.modules")
local events = module.load("events")
local config = module.load("config")

local EventEngine = events.engine

local modem = component.modem

if not modem.isWireless() then
  error("How on earth are you going to connect tablets to me? You picked the wrong modem.")
end
modem.setStrength(config.get("network", {}, true)
                        .get("modem", {}, true)
                        .get("strength", 400))

local port = config.get("network", {}, true)
                   .get("modem", {}, true)
                   .get("port", 12345)
modem.open(port)

EventEngine:subscribe("sendmsg", events.priority.low, function(handler, evt)
  if evt.addressee then
    modem.send(evt.addressee, port, table.unpack(evt:get()))
  else
    modem.broadcast(port, table.unpack(evt:get()))
  end
end)
