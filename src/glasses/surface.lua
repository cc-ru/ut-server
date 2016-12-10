local com = require("component")

local module = require("ut-serv.modules")
local config = module.load("config")
local db = module.load("db")
local events = module.load("events")
local drawUI = module.load("glasses.ui")

local bridge = com.openperipheral_bridge

local EventEngine = events.engine

EventEngine:timer(
  config.get("glasses", {}, true)
        .get("syncInterval", 0.5),
  events.GlassesSync,
  math.huge)

local function newSurface(user)
  local surface, reason = bridge.getSurfaceByName(user)
  if not surface then
    return surface, reason
  end
  surface.clear()
  return setmetatable({
    surface = surface,
    objects = {},
    user = user
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
        if not self.objects[name] then
          error("tried to access '" .. tostring(name) .. "': doesn't exist!")
        end
        return self.surface.getObjectById(self.objects[name])
      end
    }
  })
end

local function initSurface(surface)
  drawUI(surface)
  EventEngine:push(events.UIUpdate {surface = surface})
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

EventEngine:subscribe("debug", events.priority.normal, function(handler, evt)
  -- XXX: debug
  print("LIST OF SURFACES:")
  for k, v in pairs(db.surfaces) do
    local ids = {}
    for _, id in pairs(v.objects) do
      ids[#ids+1]=id
    end
    print(tostring(k) .. ": " .. table.concat(ids, ", "))
  end
end)
