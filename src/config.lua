-- The config module.
--
-- Loads the configuration file.

local fs = require("filesystem")

local path = "/etc/ut-serv.conf"

local function existsDir(path)
  return fs.exists(path) and fs.isDirectory(path)
end

local function existsFile(path)
  return fs.exists(path) and not fs.isDirectory(path)
end

local DEFAULT_CONFIG = [==[
-- < Settings related to network >----------------------------------------------
network = {
  modem = {}
}

-- Modem strength
network.modem.strength = 400

-- Port to listen on and send to.
network.modem.port = 12345


-- < Settings related to teleportation >----------------------------------------
teleport = {}

-- North point
teleport.n = {0, 0, 0}

-- North-East point
teleport.ne = {0, 0, 0}

-- East point
teleport.e = {0, 0, 0}

-- South-East point
teleport.se = {0, 0, 0}

-- South point
teleport.s = {0, 0, 0}

-- South-West point
teleport.sw = {0, 0, 0}

-- West point
teleport.w = {0, 0, 0}

-- North-West point
teleport.nw = {0, 0, 0}

-- Top point
teleport.top = {0, 0, 0}


-- < World interaction settings > ----------------------------------------------
world = {
  chest = {},
  item = {},
}

-- Chest block id
world.chest.id = "minecraft:chest"

-- Chest block metadata
world.chest.meta = 0

-- Chest NBT
world.chest.nbt = {}

-- Side to use when inserting a coin
world.chest.side = 0

-- Coin id
world.item.id = "minecraft:stone"
-- Coin number id
world.item.id2 = 1
-- Coin meta
world.item.meta = 0

-- Coin count (chosen randomly of values of the interval)
world.item.count = {1, 1}

-- Coin NBT
world.item.nbt = ""

world.field = {}

-- The chest spawn area
world.field.x = -220
world.field.y = 70
world.field.z = 290
world.field.w = 10
world.field.h = 1
world.field.l = 10

-- < Game settings > -----------------------------------------------------------
game = {
  chests = {}
}

-- Chest lifetime
game.chestLifeTime = 10

-- Chest spawn interval
game.chestSpawnInterval = 10

-- Score update interval
game.scoreUpdateInterval = 3

-- Sync message interval
game.syncMsgInterval = 10

-- Coordinates of team chests
game.chests.blue = {0, 0, 0}
game.chests.green = {0, 0, 0}
game.chests.red = {0, 0, 0}
game.chests.yellow = {0, 0, 0}

-- The numeric ID of chest
game.chestID = 54

-- The default game time
game.totalGameTime = 300

-- People who can control the server
game.admins = {"Fingercomp", "Totoro"}

-- < Glasses related settings > ------------------------------------------------
glasses = {}

-- Sync interval
glasses.syncInterval = 0.5
]==]

if not existsFile(path) then
  local dirPath = fs.path(path)
  if not existsDir(dirPath) then
    local result, reason = fs.makeDirectory(dirPath)
    if not result then
      error("failed to create '" .. tostring(dirPath) .. "' directory for the config file: " .. tostring(reason))
    end
  end
  local file, reason = io.open(path, "w")
  if file then
    file:write(DEFAULT_CONFIG)
    file:close()
  else
    error("failed to open config file for writing: " .. tostring(reason))
  end
end
local file, reason = io.open(path, "r")
if not file then
  error("failed to open config file for reading: " .. tostring(reason))
end
local content = file:read("*all")
file:close()
local globals = {}
load(content, "config", "t", globals)()

local function newUndecl(base)
  base = base or {}
  return setmetatable(base, {
    __index = {
      get = function(k, v, createNewUndecl)
        if type(base[k]) ~= "nil" then
          if type(base[k]) == "table" then
            return newUndecl(base[k])
          end
          return base[k]
        end
        io.stderr:write("Attempt to access undeclared config field '" .. tostring(k) .. "'!")
        if not createNewUndecl then
          return v
        else
          return newUndecl(v)
        end
      end
    }
  })
end

local config = newUndecl(globals)
return config
