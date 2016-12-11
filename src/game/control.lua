local com = require("component")
local module = require("ut-serv.modules")

local db = module.load("db")
local events = module.load("events")
local config = module.load("config")

local EventEngine = events.engine

local debug = com.debug

local inv = config.get("game", {}, true).get("chests", {})
local coinID = config.get("world", {}, true).get("item", {}, true).get("id2", 0)
local chestID = config.get("game", {}, true).get("chestID", 0)
local chestSpawnInterval = config.get("game", {}, true)
                                 .get("chestSpawnInterval", 10)
local scoreUpdateInterval = config.get("game", {}, true)
                                  .get("scoreUpdateInterval", 3)

local function getBlockData(world, x, y, z)
  local id = world.getBlockId(x, y, z)
  local meta = world.getMetadata(x, y, z)
  local nbt = world.getTileNBT(x, y, z)
  return {id = id, meta = meta, nbt = nbt}
end

local function getCoins(world, x, y, z)
  local data = getBlockData(world, x, y, z)
  local money = 0
  if data.id ~= chestID then
    return false
  end
  for k, item in pairs(data.nbt.value.Items.value) do
    if k ~= "n" then
      if item.value.id.value == coinID then
        money = money + b.value.Count.value
      else
        item.value.id.value = 0
      end
    else
      data.nbt.value.Items.value[k] = nil
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
  for k, item in pairs(data.nbt.value.Items.value) do
    if k ~= "n" then
      item.value.id.value = 0
    else
      data.nbt.value.Items.value[k] = nil
    end
  end
  world.setTileNBT(x, y, z, data.nbt)
end

EventEngine:subscribe("setplayerlist", events.priority.high, function(handler, evt)
  for team, name in pairs(evt.players) do
    db.teams[team].name = name
  end
end)

EventEngine:subscribe("getmoney", events.priority.high, function(handler, evt)
  local world = debug.getWorld()
  for team, coords in pairs(inv) do
    db.teams[team].score = getCoins(world, table.unpack(coords))
  end
end)

EventEngine:subscribe("worldtick", events.priority.high, function(handler, evt)
  db.remaining = db.remaining - 1
  db.scoreUpdate = db.scoreUpdate - 1
  db.sendTime = db.sendTime - 1
  if db.remaining <= 0 then
    EventEngine:push(events.GameStop())
  end
  if db.scoreUpdate <= 0 then
    EventEngine:push(events.GetMoney())
    db.scoreUpdate = scoreUpdateInterval
  end
  if db.sendTime <= 0 then
    EventEngine:push(events.SendMsg {"time", db.remaining, db.time})
    db.sendTime = 10
  end
end)

EventEngine:subscribe("gamestart", events.priority.high, function(handler, evt)
  if not db.started then
    db.started = true
    local world = debug.getWorld()
    for _, coords in pairs(inv) do
      clearInv(world, table.unpack(coords))
    end
    EventEngine:push(events.GetMoney())
    db.remaining = db.time
    db.timers.worldTick = EventEngine:timer(
      1, events.WorldTick, math.huge)
    db.timers.randomChest = EventEngine:timer(
      chestSpawnInterval, events.RandomChest, math.huge)
    EventEngine:push(events.SendMsg {"gamestart"})
  end
end)

EventEngine:subscribe("gamestop", events.priority.high, function(handler, evt)
  db.started = false
  EventEngine:push(events.SendMsg {"gamestop"})
  EventEngine:push(events.GetMoney())
  EventEngine:push(events.DestroyChests())
  db.timers.worldTick:destroy()
  db.timers.randomChest:destroy()
end)
