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

local chest = config.get("world", {}, true).get("chest", {}, true)
local coin = config.get("world", {}, true).get("item", {}, true)

local function getBlockData(world, x, y, z)
  local id = world.getBlockId(x, y, z)
  local meta = world.getMetadata(x, y, z)
  local nbt = world.getTileNBT(x, y, z)
  return {id = id, meta = meta, nbt = nbt}
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
  local block = {}
  for _, b in pairs(db.blocks) do
    if b.x == evt.x and b.y == evt.y and b.z == evt.z then
      block = b
    end
  end
  if not block then
    evt:cancel()
  end
  local result = setBlock(debug.getWorld(), evt.x, evt.y, evt.z,
                          block.data.id, block.data.meta, block.data.nbt)
  if not result then
    evt:cancel()
  end
end)

EventEngine:subscribe("worldtick", events.priority.high, function(handler, evt)
  for _, block in pairs(db.blocks) do
    block.time = block.time - 1
    if block.time <= 0 then
      EventEngine:push(events.UnsetChest {x = block.x,
                                          y = block.y,
                                          z = block.z})
    end
  end
end)
