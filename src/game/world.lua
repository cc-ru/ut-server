-- The world interaction module.
--
-- Sets and unsets chests with coins.

local com = require("component")
local module = require("ut-serv.modules")

local db = module.load("db")
local events = module.load("events")
local config = module.load("config")

local debug = com.debug

local EventEngine = events.engine

local chest = config.get("world", {}, true).get("chest", {})
local coin = config.get("world", {}, true).get("item", {})
local field = config.get("world", {}, true).get("field", {})
local chestLifeTime = config.get("game", {}, true)
                            .get("chestLifeTime", 10)

local function getBlockData(world, x, y, z)
  local id = world.getBlockId(x, y, z)
  local meta = world.getMetadata(x, y, z)
  local nbt = world.getTileNBT(x, y, z)
  return {id = id, meta = meta, nbt = nbt}
end

local function clearInv(world, x, y, z)
  local data = getBlockData(world, x, y, z)
  for k, item in pairs(data.nbt.value.Items.value) do
    if k ~= "n" then
      item.value.id.value = 0
    end
  end
  world.setTileNBT(x, y, z, data.nbt)
end

local function setBlock(world, x, y, z, id, meta, nbt)
  local success, reason = world.setBlock(x, y, z, id, meta)
  if not success then
    return success, reason
  end
  if nbt then
    return world.setTileNBT(x, y, z, nbt)
  end
  return success, reason
end

local function setChest(world, x, y, z)
  local prevBlock = getBlockData(world, x, y, z)

  local success, reason = setBlock(world, x, y, z,
                                   chest.get("id", "minecraft:chest"),
                                   chest.get("meta", 0))
  if not success then
    setBlock(world, x, y, z, prevBlock.id, prevBlock.meta, prevBlock.nbt)
    return success, reason
  end

  local success, reason = world.insertItem(
    coin.get("id", "minecraft:stone"),
    math.random(table.unpack(coin.get("count", {1, 1}))),
    coin.get("meta", 0),
    coin.get("nbt", ""),
    x,
    y,
    z,
    chest.get("side", 0)
  )
  return success, reason
end

EventEngine:subscribe("setchest", events.priority.high, function(handler, evt)
  local prevBlock = getBlockData(debug.getWorld(), evt.x, evt.y, evt.z)
  local result = setChest(debug.getWorld(), evt.x, evt.y, evt.z)
  if not result then
    evt:cancel()
  end
  table.insert(db.blocks, {x = evt.x, y = evt.y, z = evt.z, data = prevBlock,
                           time = evt.time})
end)

EventEngine:subscribe("unsetchest", events.priority.high, function(handler, evt)
  local block, index = {}
  for blkIdx, b in pairs(db.blocks) do
    if b.x == evt.x and b.y == evt.y and b.z == evt.z then
      block = b
      index = blkIdx
    end
  end
  if not block then
    evt:cancel()
  end
  clearInv(debug.getWorld(),evt.x,evt.y,evt.z)
  local result = setBlock(debug.getWorld(), evt.x, evt.y, evt.z,
                          block.data.id, block.data.meta, block.data.nbt)
  if not result then
    evt:cancel()
  end
  table.remove(db.blocks, index)
end)

EventEngine:subscribe("worldtick", events.priority.high, function(handler, evt)
  -- reverse order
  for i = #db.blocks, 1, -1 do
    local block = db.blocks[i]
    block.time = block.time - 1
    if block.time <= 0 then
      EventEngine:push(events.UnsetChest {x = block.x,
                                          y = block.y,
                                          z = block.z})
      EventEngine:push(events.SendMsg {"unsetcoin", x, y, z})
    end
  end
end)

EventEngine:subscribe("destroychests", events.priority.high, function(handler, evt)
  -- reverse order
  for i = #db.blocks, 1, -1 do
    local block = db.blocks[i]
    EventEngine:push(events.UnsetChest {x = block.x,
                                        y = block.y,
                                        z = block.z})
  end
end)

EventEngine:subscribe("randomchest", events.priority.high, function(handler, evt)
  local x, y, z = false, false, false
  while not x do
    local tx, ty, tz = math.random(field.x, field.x + field.w - 1),
                       math.random(field.y, field.y + field.h - 1),
                       math.random(field.z, field.z + field.l - 1)
    local suitable = true
    for _, b in pairs(db.blocks) do
      if b.x == tx and b.y == ty and b.z == tz then
        suitable = false
        break
      end
    end
    if suitable then
      x, y, z = tx, ty, tz
    end
  end
  EventEngine:push(events.SetChest {x = x, y = y, z = z, time = chestLifeTime})
  EventEngine:push(events.SendMsg {"setcoin", x, y, z})
  print("[" .. db.remaining .. "] Set a coin at " .. x .. ", " .. y .. ", " .. z)
end)
