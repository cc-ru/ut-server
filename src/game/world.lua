-- The world interaction module.
--
-- Sets and unsets chests with coins.

local com = require("component")
local module = require("ut-serv.module")

local events = module.load("events")

local debug = com.debug

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
  local success, reason = world.setTileNBT(nbt)
  return success, reason
end

local function setChest(world, x, y, z)
  local prevBlock = getBlockData(x, y, z)

  local success, reason = setBlock(world, x, y, z,
                                   chest.get("id", "minecraft:chest"),
                                   chest.get("meta", 0),
                                   chest.get("nbt", {}))
  if not success then
    setBlock(world, x, y, z, prevBlock.id, prevBlock.meta, prevBlock.nbt)
    return success, reason
  end

  local success, reason = world.insertItem(
    coin.get("id", "minecraft:stone"),
    math.random(table.unpack(coin.get("count", {1, 1}))),
    coin.get("meta", 0),
    coin.get("nbt", {}),
    x,
    y,
    z,
    chest.get("side", 0)
  )
  return success, reason
end

return {
  setChest = setChest,
  setBlock = setBlock,
  getBlockData = getBlockData
}
