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
events.SetChest = EventEngine:event("setchest")
events.UnsetChest = EventEngine:event("unsetchest")
events.GlassesAttach = EventEngine:event("glassesattach")
events.GlassesDetach = EventEngine:event("glassesdetach")
events.RandomChest = EventEngine:event("randomchest")
events.WorldTick = EventEngine:event("worldtick")

EventEngine:stdEvent("modem_message", events.RecvMsg)
EventEngine:stdEvent("glasses_attach", events.GlassesAttach)
EventEngine:stdEvent("glasses_detach", events.GlassesDetach)

module.engine = EventEngine

module.priority = {
  top = 5,
  high = 10,
  normal = 50,
  low = 75,
  bottom = 100
}

return module
