local com = require("component")

local module = require("ut-serv.modules")
local config = module.load("config")
local db = module.load("db")
local events = module.load("events")
local drawUI = module.load("glasses.ui")

local bridge = com.openperipheral_bridge

local EventEngine = events.engine

local admins = config.get("game", {}, true).get("admins", {"Fingercomp"})

EventEngine:timer(
  config.get("glasses", {}, true)
        .get("syncInterval", 0.5),
  events.GlassesSync,
  math.huge)

local function checkAdmin(nick)
  for _, admin in pairs(admins) do
    if nick == admin then
      return true
    end
  end
  return false
end

local function newSurface(user)
  local surface, reason = bridge.getSurfaceByName(user)
  if not surface then
    return surface, reason
  end
  surface.clear()
  return setmetatable({
    surface = surface,
    objects = {},
    user = user,
    lastClick = false
  }, {
    __index = {
      addObject = function(self, name, func, ...)
        if self.objects[name] then
          error("tried to create '" .. tostring(name) .. "': already exists!")
        end
        local object, reason = self.surface[func](...)
        if reason then
          error("non-nil reason: " .. tostring(reason))
        end
        object.setUserdata({name = name})
        self.objects[name] = object.getId()
        return object
      end,
      destroy = function(self)
        self.surface.clear()
        self.objects = {}
      end,
      get = function(self, name)
        if type(name) == "string" then
          if not self.objects[name] then
            error("tried to access '" .. tostring(name) .. "': doesn't exist!")
          end
          return self.surface.getObjectById(self.objects[name])
        elseif type(name) == "number" then
          for k, v in pairs(self.objects) do
            if v == name then
              return k
            end
          end
        end
        error("bad argument #1")
      end
    }
  })
end

local function initSurface(surface)
  drawUI(surface)
  EventEngine:push(events.UIUpdate {surface = surface})
  if not checkAdmin(surface.user) then
    local box = surface:get("admin.startstop.box")
    local text = surface:get("admin.startstop.text")
    box.setVisible(false)
    box.setClickable(false)
    text.setVisible(false)
    text.setClickable(false)
  end
  bridge.sync()
end


EventEngine:subscribe("init", events.priority.normal, function(handler, evt)
  for _, user in pairs(bridge.getUsers()) do
    local user = user.name
    db.surfaces[user] = newSurface(user)
    initSurface(db.surfaces[user])
  end
end)

EventEngine:subscribe("glassesattach", events.priority.normal, function(handler, evt)
  local user = evt[2]
  db.surfaces[user] = newSurface(user)
  initSurface(db.surfaces[user])
end)

EventEngine:subscribe("glassesdetach", events.priority.normal, function(handler, evt)
  local user = evt[2]
  if not db.surfaces[user] then
    error("tried to destroy surface of unexisting user!")
  end
  db.surfaces[user]:destroy()
  db.surfaces[user] = nil
end)

EventEngine:subscribe("stop", events.priority.normal, function(handler, evt)
  for _, surface in pairs(db.surfaces) do
    surface:destroy()
  end
  bridge.sync()
end)

EventEngine:subscribe("glassessync", events.priority.normal, function(handler, evt)
  for _, surface in pairs(db.surfaces) do
    EventEngine:push(events.UIUpdate {surface = surface})
  end
  bridge.sync()
end)

EventEngine:subscribe("glasssescomponentmousedown", events.priority.normal, function(handler, evt)
  local surface = db.surfaces[evt[2]]
  local object = surface:get(evt[4])
  if object == "admin.startstop.box" or
     object == "admin.startstop.text" then
    if checkAdmin(evt[2]) then
      if db.started then
        EventEngine:push(events.GameStop())
      else
        EventEngine:push(events.GameStart())
      end
    end
  elseif object == "tp.map.point.w.point" or
         object == "tp.map.point.nw.point" or
         object == "tp.map.point.n.point" or
         object == "tp.map.point.ne.point" or
         object == "tp.map.point.e.point" or
         object == "tp.map.point.se.point" or
         object == "tp.map.point.s.point" or
         object == "tp.map.point.sw.point" or
         object == "tp.map.point.top.point" then
    local point = object:match(".+%.(.-)%.point$")
    EventEngine:push(events.Teleport {nick = evt[2], point = point})
  elseif object == "nicks.blue.box.small" or
         object == "nicks.green.box.small" or
         object == "nicks.red.box.small" or
         object == "nicks.yellow.box.small" then
    local team = object:match("^nicks%.(.-)%..+$")
    local box = surface:get("nicks." .. team .. ".box")
    local text = surface:get("nicks." .. team .. ".text")

    box.setClickable(not box.getClickable())
    box.setVisible(not box.getVisible())
    text.setClickable(not text.getClickable())
    text.setVisible(not text.getVisible())
  elseif object == "nicks.blue.box" or
         object == "nicks.blue.text" or
         object == "nicks.green.box" or
         object == "nicks.green.text" or
         object == "nicks.red.box" or
         object == "nicks.red.text" or
         object == "nicks.yellow.box" or
         object == "nicks.yellow.text" then
    if checkAdmin(evt[2]) then
      local team = object:match("^nicks%.(.-)%..+$")
      surface.lastClick = "nicks." .. team
    end
  elseif object == "time.total.time" then
    if checkAdmin(evt[2]) then
      surface.lastClick = "time.total"
    end
  else
    surface.lastClick = false
  end
end)

EventEngine:subscribe("glassesmousedown", events.priority.normal, function(handler, evt)
  local surface = db.surfaces[evt[2]]
  surface.lastClick = false
end)

EventEngine:subscribe("glasseschatcommand", events.priority.normal, function(handler, evt)
  local surface = db.surfaces[evt[2]]
  if surface.lastClick then
    if surface.lastClick:match("^nicks.[^.]+$") then
      if checkAdmin(evt[2]) then
        local team = surface.lastClick:match("^nicks.([^.]+)$")
        db.teams[team].name = evt[4]
      end
    elseif surface.lastClick == "time.total" then
      if not db.started then
        if evt[4]:match("%d%d:%d%d") then
          if checkAdmin(evt[2]) then
            local min, sec = evt[4]:match("(%d%d):(%d%d)")
            min, sec = tonumber(min), tonumber(sec)
            db.time = min * 60 + sec
          end
        end
      end
    end
  end
end)
