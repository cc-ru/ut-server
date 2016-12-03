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
