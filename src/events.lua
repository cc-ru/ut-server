local aevent = require("aevent")

local module = {}
local events = {}
module.events = events

local EventEngine = aevent()
events.Init = EventEngine:event("init")
events.Stop = EventEngine:event("stop")
events.NetMsg = EventEngine:event("netmsg")

EventEngine:stdEvent("modem_message")

module.engine = EventEngine

module.priority = {
  top = 5,
  high = 10,
  normal = 50,
  low = 75,
  bottom = 100
}

return module
