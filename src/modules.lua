-- The module manager.
--
-- Loads modules of the server.
-- DON'T USE require TO LOAD SERVER MODULES.
-- Neither use this manager to load system libraries.

local fs = require("filesystem")

local module = {}
module.path = {
  "/usr/lib/ut-serv/?.lua",
  "/usr/lib/ut-serv/?/init.lua",
  "/home/lib/ut-serv/?.lua",
  "/home/lib/ut-serv/?/init.lua"
}
module.cache = {}

function module.load(name)
  checkArg(1, name, "string")
  if not module.cache[name] then
    local relPath = name:gsub(".", "/")
    local path = false
    for _, lpath in pairs(module.path) do
      local candidate = lpath:gsub("?", name, nil, true)
      if fs.exists(candidate) then
        path = candidate
        break
      end
    end
    if not path then
      error("module not found: " .. name)
    end

    -- Now just load the code
    local chunk, reason = loadfile(path)
    if not chunk then
      error("could not load module '" .. name .. "': " .. tostring(reason))
    end
    local result = {xpcall(chunk, debug.traceback)}
    if not result[1] then
      error("could not load module '" .. name .. "': " .. tostring(result[2]))
    end
    module.cache[name] = result
  end
  return table.unpack(module.cache[name], 2)
end

function module.clearCache()
  module.cache = {}
end

return module
