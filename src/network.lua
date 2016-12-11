-- The network module.
--
-- Initializes the networking.
-- Sends modem messages on event.

local component = require("component")
local sere = require("serialization")

local module = require("ut-serv.modules")
local events = module.load("events")
local config = module.load("config")
local db = module.load("db")

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

EventEngine:subscribe("getmsg", events.priority.low, function(handler, evt)
  mes = table.unpack(evt:get())
-- mes[2] - sender ; mes[5] - first mes
  if mes[5] == "getInfo" then
    EventEngine:push(events.SendMsg {addressee = mes[2], db.remaining, db.time, sere.serialize(db.teams), sere.serialize(db.blocks)})
  end
end)
