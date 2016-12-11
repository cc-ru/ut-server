-- The event module.
--
-- Registers events and listeners.

local aevent = require("aevent")

local events = {}

local EventEngine = aevent()
events.Init = EventEngine:event("init")
events.Stop = EventEngine:event("stop")
events.SendMsg = EventEngine:event("sendmsg")
events.GameStart = EventEngine:event("gamestart")
events.GameStop = EventEngine:event("gamestop")
events.RecvMsg = EventEngine:event("recvmsg")
events.Quit = EventEngine:event("quit")
events.Teleport = EventEngine:event("teleport")
events.SetChest = EventEngine:event("setchest")
events.UnsetChest = EventEngine:event("unsetchest")
events.GlassesAttach = EventEngine:event("glassesattach")
events.GlassesDetach = EventEngine:event("glassesdetach")
events.RandomChest = EventEngine:event("randomchest")
events.GetMoney = EventEngine:event("getmoney")
events.SetPlayerList = EventEngine:event("setplayerlist")
events.WorldTick = EventEngine:event("worldtick")
events.DestroyChests = EventEngine:event("destroychests")
events.GlassesSync = EventEngine:event("glassessync")
events.Debug = EventEngine:event("debug")
events.UIUpdate = EventEngine:event("uiupdate")
events.GlassesMouseDown = EventEngine:event("glassesmousedown")
events.GlassesComponentMouseDown = EventEngine:event("glasssescomponentmousedown")
events.GlassesChatCommand = EventEngine:event("glasseschatcommand")

EventEngine:stdEvent("modem_message", events.RecvMsg)
EventEngine:stdEvent("glasses_attach", events.GlassesAttach)
EventEngine:stdEvent("glasses_detach", events.GlassesDetach)
EventEngine:stdEvent("key_down", events.Debug)
EventEngine:stdEvent("glasses_component_mouse_down", events.GlassesComponentMouseDown)
EventEngine:stdEvent("glasses_mouse_down", events.GlassesMouseDown)
EventEngine:stdEvent("glasses_chat_command", events.GlassesChatCommand)

events.engine = EventEngine

events.priority = {
  top = 5,
  high = 10,
  normal = 50,
  low = 75,
  bottom = 100
}

return events
