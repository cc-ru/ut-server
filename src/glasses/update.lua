local module = require("ut-serv.modules")
local db = module.load("db")
local events = module.load("events")

local EventEngine = events.engine

EventEngine:subscribe("uiupdate", events.priority.normal, function(handler, evt)
  local surface = evt.surface

  -- 1. Update score

  do
    -- calculate advantages
    local scoreB = db.teams.blue.score
    local scoreG = db.teams.green.score
    local scoreR = db.teams.red.score
    local scoreY = db.teams.yellow.score
    local scoreSum = scoreB + scoreG + scoreR + scoreY

    local adB = scoreB / scoreSum
    local adG = scoreG / scoreSum
    local adR = scoreR / scoreSum
    local adY = scoreY / scoreSum

    if scoreSum == 0 then
      adB = 0.25
      adG = 0.25
      adR = 0.25
      adY = 0.25
    end

    -- set score labels
    surface:get("score.blue.text").setText(("%02d"):format(scoreB))
    surface:get("score.green.text").setText(("%02d"):format(scoreG))
    surface:get("score.red.text").setText(("%02d"):format(scoreR))
    surface:get("score.yellow.text").setText(("%02d"):format(scoreY))

    -- set opacity
    local oB = 0.8 * adB + 0.2
    local oG = 0.8 * adG + 0.2
    local oR = 0.8 * adR + 0.2
    local oY = 0.8 * adY + 0.2

    surface:get("score.blue.box").setOpacity(oB)
    surface:get("score.green.box").setOpacity(oG)
    surface:get("score.red.box").setOpacity(oR)
    surface:get("score.yellow.box").setOpacity(oY)

    -- update progress bars
    surface:get("score.red.bar").setWidth((1 - adY) * 200)
    surface:get("score.green.bar").setWidth((1 - adY - adR) * 200)
    surface:get("score.blue.bar").setWidth(adB * 200)
  end


  -- 2. Update time
  do
    local passed = db.time - db.remaining
    local pMin = math.floor(passed / 60)
    local pSec = passed - pMin * 60
    pMin = ("%02d"):format(pMin)
    pSec = ("%02d"):format(pSec)
    surface:get("time.passed.time").setText(pMin .. ":" .. pSec)

    local total = db.time
    local tMin = math.floor(total / 60)
    local tSec = total - tMin * 60
    tMin = ("%02d"):format(tMin)
    tSec = ("%02d"):format(tSec)
    surface:get("time.total.time").setText(tMin .. ":" .. tSec)

    local remain = db.remaining
    local rMin = math.floor(remain / 60)
    local rSec = remain - rMin * 60
    rMin = ("%02d"):format(rMin)
    rSec = ("%02d"):format(rSec)
    surface:get("time.remaining.time").setText(rMin .. ":" .. rSec)

    surface:get("time.bar.passed").setWidth(passed / total * 200)
  end

  -- 3. Update nicks
  do
    surface:get("nicks.blue.text").setText(db.teams.blue.name)
    surface:get("nicks.green.text").setText(db.teams.green.name)
    surface:get("nicks.red.text").setText(db.teams.red.name)
    surface:get("nicks.yellow.text").setText(db.teams.yellow.name)
  end

  -- 4. Update admin-panel
  do
    if db.started then
      surface:get("admin.startstop.box").setColor(0xff2020)
      surface:get("admin.startstop.text").setText("Stop")
    else
      surface:get("admin.startstop.box").setColor(0x20afff)
      surface:get("admin.startstop.text").setText("Start")
    end
  end
end)
