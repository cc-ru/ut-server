-- The world interaction module.
--
-- Sets and unsets chests with coins.

local com = require("component")
local module = require("ut-serv.modules")

local db = module.load("db")
db.blocks = {}
local events = module.load("events")
local config = module.load("config")

local debug = com.debug

local EventEngine = events.engine

local chest = config.get("world", {}, true).get("chest", {}, true)
local coin = config.get("world", {}, true).get("item", {}, true)

local function getBlockData(world, x, y, z)
  local id = world.getBlockId(x, y, z)
  local meta = world.getMetadata(x, y, z)
  return {id = id, meta = meta}
end

local function setBlock(world, x, y, z, id, meta)--, nbt)
  local success, reason = world.setBlock(x, y, z, id, meta)
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
--    coin.get("nbt", {}),
    "",
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
  local block, si = {}, -1
  for i, b in pairs(db.blocks) do
    if b.x == evt.x and b.y == evt.y and b.z == evt.z then
      block = b
      si = i
    end
  end
  if not block then
    evt:cancel()
  end
  if not evt.notDelete then
    table.remove(db.blocks, si)
  end
  local result = setBlock(debug.getWorld(), evt.x, evt.y, evt.z, block.data.id, block.data.meta)
  if not result then
    evt:cancel()
  end
end)

EventEngine:subscribe("onWorldTick", events.priority.high, function(handler, evt)
  local fd = {}
  for i = 1, #db.blocks do
    db.blocks[i].time = db.blocks[i].time - 1
    if db.blocks[i].time <= 0 then
      table.insert(fd, i)
      local ev = EventEngine:event("unsetchest")
      EventEngine:push(ev{x = db.blocks[i].x, y = db.blocks[i].y, z = db.blocks[i].z, notDelete = true})
    end
  end
  for i = #fd, 1, -1 do
    table.remove(db.blocks, fd[i])
  end
end)
