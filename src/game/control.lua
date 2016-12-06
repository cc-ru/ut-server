local com = require("component")
local module = require("ut-serv.modules")

local db = module.load("db")
local events = module.load("events")
local config = module.load("config")

EventEngine = events.engine

local debug = com.debug

local gamestate = false

local inv = config.get("game", {}, true).get("chests", {}, true)
local coinID = config.get("world", {}, true).get("item", {}, true).get("id2", 0, true)
local chestID = config.get("game", {}, true).get("chestID", 0, true)

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
  db.players = evt.players
end)

EventEngine:subscribe("getmoney", events.priority.high, function(handler, evt)
  local world = debug.getWorld()
  db.scoreTable = {}
  for a,b in pairs(inv) do
    db.scoreTable[a] = getCoins(world, table.unpack(b))
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
    --TODO
  end
end)

EventEngine:subscribe("gamestop", events.priority.high, function(handler, evt)
  gamestate = false
  EventEngine:push(events.GetMoney {})
  --TODO
end)
