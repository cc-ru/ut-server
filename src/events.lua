-- The event module.
--
-- Registers events and listeners.

local aevent = require("aevent")

local module = {}
local events = {}
module.events = events

local EventEngine = aevent()
events.Init = EventEngine:event("init")
events.Stop = EventEngine:event("stop")
events.SendMsg = EventEngine:event("sendmsg")
events.GameStart = EventEngine:event("gamestart")
events.RecvMsg = EventEngine:event("recvmsg")
events.Quit = EventEngine:event("quit")
events.Teleport = EventEngine:event("teleport")

EventEngine:stdEvent("modem_message", events.RecvMsg)

module.engine = EventEngine

module.priority = {
  top = 5,
  high = 10,
  normal = 50,
  low = 75,
  bottom = 100
}

return module
