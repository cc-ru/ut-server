local com = require("component")
local module = require("ut-serv.modules")

local db = module.load("db")
module.load("world")
local events = module.load("events")
local config = module.load("config")

EventEngine = events.engine

local debug = com.debug

local gamestate = false
local timer, timer2, timer3
local timeToEnd = 0
local chestCheck = 0

local inv = config.get("game", {}, true).get("chests", {}, true)
local coinID = config.get("world", {}, true).get("item", {}, true).get("id2", 0, true)
local chestID = config.get("game", {}, true).get("chestID", 0, true)
local chestSpawnInterval = config.get("game", {}, true).get("chestSpawnInterval", 30, true)

local function getBlockData(world, x, y, z)
  local id = world.getBlockId(x, y, z)
  local meta = world.getMetadata(x, y, z)
  local nbt = world.getTileNBT(x, y, z)
  return {id = id, meta = meta, nbt = nbt}
end

local function getCoins(world, x, y, z) -- get money in slot, in case of found another item kill them
  local data = getBlockData(world, x, y, z)
  local money = 0
  if data.id ~= chestID then
    return false
  end
  for i = 1, #data.nbt.value.Items.value do
    b = data.nbt.value.Items.value[i]
    if b.value.id.value == coinID then
      money = money + b.value.Count.value
    else
      b.value.id.value = 0
    end
  end
  world.setTileNBT(x, y, z, data.nbt)
  return money
end

local function clearInv(world, x, y, z)
  local data = getBlockData(world, x, y, z)
  if data.id ~= chestID then
    return false
  end
  for i = 1, #data.nbt.value.Items.value do
    b = data.nbt.value.Items.value[i]
    b.value.id.value = 0
  end
  world.setTileNBT(x, y, z, data.nbt)
end

EventEngine:subscribe("setplayerlist", events.priority.high, function(handler, evt)
  if type(evt.players) ~= "table" then
    error("isn't table")
  end
  if type(db.players) ~= "table" then
    db.players = {}
  end
  for a,b in pairs(evt.players) do
    db.players[a] = {name = b, score = 0, chestID = a}
  end
end)

EventEngine:subscribe("getmoney", events.priority.high, function(handler, evt)
  local world = debug.getWorld()
  for a,b in pairs(inv) do
    db.players[a].score = getCoins(world, table.unpack(b))
  end
end)

EventEngine:subscribe("gametime", events.priority.high, function(handler, evt)
  timeToEnd = timeToEnd - 1
  chestCheck = chestCheck - 1
  if timeToEnd <= 0 then
    EventEngine:push(events.GameStop {})
  end
  if chestCheck <= 0 then
    EventEngine:push(events.GetMoney {})
    chestCheck = 3
  end
end)

EventEngine:subscribe("gamestart", events.priority.high, function(handler, evt)
  if not gamestate then
    gamestate = true
    local world = debug.getWorld()
    for _, b in pairs(inv) do
      clearInv(world, table.unpack(b))
    end
    EventEngine:push(events.GetMoney {})
    timeToEnd = db.time or 300
    timer = EventEngine:timer(1, EventEngine:event("worldtick"), math.huge)
    timer2 = EventEngine:timer(chestSpawnInterval, EventEngine:event("randomchest"), math.huge)
    timer3 = EventEngine:timer(1, EventEngine:event("gametime"), math.huge)
  end
end)

EventEngine:subscribe("gamestop", events.priority.high, function(handler, evt)
  gamestate = false
  EventEngine:push(events.GetMoney {})
  EventEngine:push(events.DestroyChests {})
  timer:destroy()
  timer2:destroy()
  timer3:destroy()
end)
