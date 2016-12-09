-- In-memory DB
-- actually, just a Lua table

local module = require("ut-serv.modules")
local config = module.load("config")

local totalGameTime = config.get("game", {}, true).get("totalGameTime", 300)

return {
  -- stores blocks replaced by chests
  blocks = {},
  -- stores glasses surfaces
  surfaces = {},
  -- whether the game has been started or not
  started = false,
  -- team info (player names and scores)
  teams = {
    blue = {name = "", score = 0},
    green = {name = "", score = 0},
    red = {name = "", score = 0},
    yellow = {name = "", score = 0}
  },
  -- time until the end of game
  remaining = 0,
  -- time until next score update
  scoreUpdate = 0,
  -- time until next sync message
  syncMsg = 0,
  -- the total game time
  time = totalGameTime,
  -- timers
  timers = {}
}
