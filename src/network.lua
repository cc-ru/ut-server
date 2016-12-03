local component = require("component")

local module = require("ut-serv.modules")
local events = module.load("events")
local config = module.load("config")

local EventEngine = events.engine

local modem = component.modem

if not modem.isWireless() then
  error("How on earth are you going to connect tablets to me? You picked the wrong modem.")
end
modem.setStrength(config.modem.strength)
modem.open(config.modem.port)

EventEngine:subscribe("sendmsg", events.priority.low, function(handler, evt)
  if evt.addressee then
    modem.send(evt.addressee, config.modem.port, table.unpack(evt:get()))
  else
    modem.broadcast(config.modem.port, table.unpack(evt:get()))
  end
end)
