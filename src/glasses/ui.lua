local function drawUI(surface)
  -- SCORE
  surface:addObject("score.blue.box", "addBox", 5, 5, 50, 50, 0x20afff, .33)
  local score1 = surface:addObject("score.blue.text", "addText", 13, 20, "00", 0xffffff)
  score1.setScale(3)

  surface:addObject("score.green.box", "addBox", 55, 5, 50, 50, 0x20ff20, .33)
  local score2 = surface:addObject("score.green.text", "addText", 63, 20, "09", 0xffffff)
  score2.setScale(3)

  surface:addObject("score.red.box", "addBox", 105, 5, 50, 50, 0xff2020, .33)
  local score3 = surface:addObject("score.red.text", "addText", 113, 20, "18", 0xffffff)
  score3.setScale(3)

  surface:addObject("score.yellow.box", "addBox", 155, 5, 50, 50, 0xffff20, .33)
  local score4 = surface:addObject("score.yellow.text", "addText", 163, 20, "27", 0xffffff)
  score4.setScale(3)

  -- SCORE PRBAR
  surface:addObject("score.yellow.bar", "addBox", 5, 57, 200, 1, 0xffff20)
  surface:addObject("score.red.bar", "addBox", 5, 57, 150, 1, 0xff2020)
  surface:addObject("score.green.bar", "addBox", 5, 57, 100, 1, 0x20ff20)
  surface:addObject("score.blue.bar", "addBox", 5, 57, 50, 1, 0x20afff)

  -- TIME BOX
  surface:addObject("time.box", "addBox", 5, 60, 200, 50, 0xffffff, .5)

  surface:addObject("time.separator", "addLine", {x=105, y=63}, {x=105, y=107}, 0x606060)

  local passed = surface:addObject("time.passed.time", "addText", 18, 75, "01:23", 0x000000)
  passed.setScale(3)
  surface:addObject("time.passed.label", "addText", 18, 65, "Time passed", 0x000000)

  local total = surface:addObject("time.total.time", "addText", 118, 70, "05:00", 0x000000)
  total.setScale(1.75)
  local totalLabel = surface:addObject("time.total.label", "addText", 118, 63, "Total", 0x000000)
  totalLabel.setScale(0.8)

  local remaining = surface:addObject("time.remaining.time", "addText", 118, 95, "03:37", 0x000000)
  remaining.setScale(1.75)
  local remainingLabel = surface:addObject("time.remaining.label", "addText", 118, 88, "Remaining", 0x000000)
  remainingLabel.setScale(0.8)

  -- TIME PRBAR
  surface:addObject("time.bar.total", "addBox", 5, 112, 200, 1, 0xffffff)
  surface:addObject("time.bar.passed", "addBox", 5, 112, 55, 1, 0x20afff)

  -- NICKS
  surface:addObject("nicks.blue.box.small", "addBox", 210, 5, 5, 11, 0x20afff)
  surface:addObject("nicks.blue.box", "addBox", 215, 5, 200, 11, 0x20afff, .5)
  surface:addObject("nicks.blue.text", "addText", 217, 7, "Fingercomp", 0xffffff)

  surface:addObject("nicks.green.box.small", "addBox", 210, 18, 5, 11, 0x20ff20)
  surface:addObject("nicks.green.box", "addBox", 215, 18, 200, 11, 0x20ff20, .5)
  surface:addObject("nicks.green.text", "addText", 217, 20, "Fingercomp", 0xffffff)

  surface:addObject("nicks.red.box.small", "addBox", 210, 31, 5, 11, 0xff2020)
  surface:addObject("nicks.red.box", "addBox", 215, 31, 200, 11, 0xff2020, .5)
  surface:addObject("nicks.red.text", "addText", 217, 33, "Fingercomp", 0xffffff)

  surface:addObject("nicks.yellow.box.small", "addBox", 210, 44, 5, 11, 0xffff20)
  surface:addObject("nicks.yellow.box", "addBox", 215, 44, 200, 11, 0xffff20, .5)
  surface:addObject("nicks.yellow.text", "addText", 217, 46, "Fingercomp", 0xffffff)

  -- TELEPORTATION
  local scale = 10
  local px = -20
  local py = 31

  local tpBox = surface:addObject("tp.box", "addBox", -135, 16, 130, 130, 0xffffff, .3)
  tpBox.setScreenAnchor("RIGHT", "TOP")

  local tpLabelBox = surface:addObject("tp.label.box", "addBox", -135, 5, 130, 11, 0xffffff, 1)
  tpLabelBox.setScreenAnchor("RIGHT", "TOP")
  local tpLabel = surface:addObject("tp.label.text", "addText", -133, 7, "TELEPORTATION", 0x000000)
  tpLabel.setScreenAnchor("RIGHT", "TOP")

  local tpHelpBox = surface:addObject("tp.help.box", "addBox", -135, 146, 130, 11, 0xffffff, .75)
  tpHelpBox.setScreenAnchor("RIGHT", "TOP")
  local tpHelpText = surface:addObject("tp.help.text", "addText", -133, 148, "Click on a point to TP", 0x000000)
  tpHelpText.setScreenAnchor("RIGHT", "TOP")

  -- - green / north
  local g1 = surface:addObject("tp.map.green.outer", "addPolygon", 0x20ff20, .75,
    {x = -5 * scale + px, y = 0 * scale + py},
    {x = -4 * scale + px, y = 1 * scale + py},
    {x = -4 * scale + px, y = 2 * scale + py},
    {x = -6 * scale + px, y = 2 * scale + py},
    {x = -6 * scale + px, y = 1 * scale + py})
  local g2 = surface:addObject("tp.map.green.inner", "addPolygon", 0x20ff20, .75,
    {x = -4 * scale + px, y = 2 * scale + py},
    {x = -3 * scale + px, y = 3 * scale + py},
    {x = -5 * scale + px, y = 5 * scale + py},
    {x = -7 * scale + px, y = 3 * scale + py},
    {x = -6 * scale + px, y = 2 * scale + py})

  -- red / east
  local r1 = surface:addObject("tp.map.red.outer", "addPolygon", 0xff2020, .75,
    {x =  0 * scale + px, y = 5 * scale + py},
    {x = -1 * scale + px, y = 6 * scale + py},
    {x = -2 * scale + px, y = 6 * scale + py},
    {x = -2 * scale + px, y = 4 * scale + py},
    {x = -1 * scale + px, y = 4 * scale + py})
  local r2 = surface:addObject("tp.map.red.inner", "addPolygon", 0xff2020, .75,
    {x = -2 * scale + px, y = 6 * scale + py},
    {x = -3 * scale + px, y = 7 * scale + py},
    {x = -5 * scale + px, y = 5 * scale + py},
    {x = -3 * scale + px, y = 3 * scale + py},
    {x = -2 * scale + px, y = 4 * scale + py})

  -- yellow / south
  local y1 = surface:addObject("tp.map.yellow.outer", "addPolygon", 0xffff20, .75,
    {x = -5 * scale + px, y = 10 * scale + py},
    {x = -6 * scale + px, y = 9 * scale + py},
    {x = -6 * scale + px, y = 8 * scale + py},
    {x = -4 * scale + px, y = 8 * scale + py},
    {x = -4 * scale + px, y = 9 * scale + py})
  local y2 = surface:addObject("tp.map.yellow.inner", "addPolygon", 0xffff20, .75,
    {x = -6 * scale + px, y = 8 * scale + py},
    {x = -7 * scale + px, y = 7 * scale + py},
    {x = -5 * scale + px, y = 5 * scale + py},
    {x = -3 * scale + px, y = 7 * scale + py},
    {x = -4 * scale + px, y = 8 * scale + py})

  -- blue / west
  local b1 = surface:addObject("tp.map.blue.outer", "addPolygon", 0x20afff, .75,
    {x = -10 * scale + px, y = 5 * scale + py},
    {x = -9 * scale + px, y = 4 * scale + py},
    {x = -8 * scale + px, y = 4 * scale + py},
    {x = -8 * scale + px, y = 6 * scale + py},
    {x = -9 * scale + px, y = 6 * scale + py})
  local b2 = surface:addObject("tp.map.blue.inner", "addPolygon", 0x20afff, .75,
    {x = -8 * scale + px, y = 4 * scale + py},
    {x = -7 * scale + px, y = 3 * scale + py},
    {x = -5 * scale + px, y = 5 * scale + py},
    {x = -7 * scale + px, y = 7 * scale + py},
    {x = -8 * scale + px, y = 6 * scale + py})

  g1.setScreenAnchor("RIGHT", "TOP")
  g2.setScreenAnchor("RIGHT", "TOP")
  r1.setScreenAnchor("RIGHT", "TOP")
  r2.setScreenAnchor("RIGHT", "TOP")
  y1.setScreenAnchor("RIGHT", "TOP")
  y2.setScreenAnchor("RIGHT", "TOP")
  b1.setScreenAnchor("RIGHT", "TOP")
  b2.setScreenAnchor("RIGHT", "TOP")

  local function addTPPoint(x, y, borderColor, name)
    local width = 4
    local height = 4
    local gap = 1
    local b = surface:addObject(name .. ".back", "addBox", x - width / 2 - gap, y - height / 2 - gap, width + 2 * gap, height + 2 * gap, 0xffffff, .5)
    local p = surface:addObject(name .. ".point", "addBox", x - width / 2, y - height / 2, width, height, color, 1)
    b.setScreenAnchor("RIGHT", "TOP")
    p.setScreenAnchor("RIGHT", "TOP")
  end

  addTPPoint(-11 * scale + px, 5 * scale + py, 0xffffff, "tp.map.point.w")
  addTPPoint(-8 * scale + px, 2 * scale + py, 0xffffff, "tp.map.point.nw")
  addTPPoint(-5 * scale + px, -1 * scale + py, 0xffffff, "tp.map.point.n")
  addTPPoint(-2 * scale + px, 2 * scale + py, 0xffffff, "tp.map.point.ne")
  addTPPoint(1 * scale + px, 5 * scale + py, 0xffffff, "tp.map.point.e")
  addTPPoint(-2 * scale + px, 8 * scale + py, 0xffffff, "tp.map.point.se")
  addTPPoint(-5 * scale + px, 11 * scale + py, 0xffffff, "tp.map.point.s")
  addTPPoint(-8 * scale + px, 8 * scale + py, 0xffffff, "tp.map.point.sw")
  addTPPoint(-5 * scale + px, 5 * scale + py, 0xffffff, "tp.map.point.top")

  -- ADMIN
  local btnStartStop = surface:addObject("admin.startstop.box", "addBox", -135, -30, 130, 25, 0x20afff, .5)
  btnStartStop.setScreenAnchor("RIGHT", "BOTTOM")

  local btnStartStopLabel = surface:addObject("admin.startstop.text", "addText", -125, -25, "Start", 0xffffff)
  btnStartStopLabel.setScreenAnchor("RIGHT", "BOTTOM")
  btnStartStopLabel.setScale(2)

  -- LOGO
  local rs = 5
  local rx = 20
  local ry = -22.5
  local robotTop1 = surface:addObject("logo.robot.top.1", "addPolygon", 0x000000, .5,
    {x = 0 * rs + rx, y = -5 * rs + ry},
    {x = 2 * rs + rx, y = -6 * rs + ry},
    {x = 2 * rs + rx, y = -5 * rs + ry})
  local robotTop2 = surface:addObject("logo.robot.top.2", "addPolygon", 0x000000, .5,
    {x = 3 * rs + rx, y = -9 * rs + ry},
    {x = 3.5 * rs + rx, y = -7 * rs + ry},
    {x = 3 * rs + rx, y = -6 * rs + ry},
    {x = 2 * rs + rx, y = -5 * rs + ry},
    {x = 2 * rs + rx, y = -6 * rs + ry})
  local robotTop3 = surface:addObject("logo.robot.top.3", "addPolygon", 0x000000, .5,
    {x = 2 * rs + rx, y = -5 * rs + ry},
    {x = 3 * rs + rx, y = -6 * rs + ry},
    {x = 5 * rs + rx, y = -6 * rs + ry},
    {x = 6 * rs + rx, y = -5 * rs + ry})
  local robotTop4 = surface:addObject("logo.robot.top.4", "addPolygon", 0x000000, .5,
    {x = 5 * rs + rx, y = -9 * rs + ry},
    {x = 4.5 * rs + rx, y = -7 * rs + ry},
    {x = 5 * rs + rx, y = -6 * rs + ry},
    {x = 6 * rs + rx, y = -5 * rs + ry},
    {x = 6 * rs + rx, y = -6 * rs + ry})
  local robotTop5 = surface:addObject("logo.robot.top.5", "addPolygon", 0x000000, .5,
    {x = 8 * rs + rx, y = -5 * rs + ry},
    {x = 6 * rs + rx, y = -6 * rs + ry},
    {x = 6 * rs + rx, y = -5 * rs + ry})

  robotTop1.setScreenAnchor("LEFT", "BOTTOM")
  robotTop2.setScreenAnchor("LEFT", "BOTTOM")
  robotTop3.setScreenAnchor("LEFT", "BOTTOM")
  robotTop4.setScreenAnchor("LEFT", "BOTTOM")
  robotTop5.setScreenAnchor("LEFT", "BOTTOM")

  local robotBot1 = surface:addObject("logo.robot.bottom.1", "addPolygon", 0x000000, .5,
    {x = 0 * rs + rx, y = -4 * rs + ry},
    {x = 2 * rs + rx, y = -2 * rs + ry},
    {x = 2 * rs + rx, y = -3.5 * rs + ry},
    {x = 1.5 * rs + rx, y = -4 * rs + ry})
  local robotBot2 = surface:addObject("logo.robot.bottom.2", "addPolygon", 0x000000, .5,
    {x = 2 * rs + rx, y = -2 * rs + ry},
    {x = 2 * rs + rx, y = -3.5 * rs + ry},
    {x = 2.5 * rs + rx, y = -4 * rs + ry},
    {x = 5.5 * rs + rx, y = -4 * rs + ry},
    {x = 6 * rs + rx, y = -3.5 * rs + ry},
    {x = 6 * rs + rx, y = -2 * rs + ry},
    {x = 4 * rs + rx, y = 0 * rs + ry})
  local robotBot3 = surface:addObject("logo.robot.bottom.3", "addPolygon", 0x000000, .5,
    {x = 8 * rs + rx, y = -4 * rs + ry},
    {x = 6 * rs + rx, y = -2 * rs + ry},
    {x = 6 * rs + rx, y = -3.5 * rs + ry},
    {x = 6.5 * rs + rx, y = -4 * rs + ry})

  robotBot1.setScreenAnchor("LEFT", "BOTTOM")
  robotBot2.setScreenAnchor("LEFT", "BOTTOM")
  robotBot3.setScreenAnchor("LEFT", "BOTTOM")

  local robotMid1 = surface:addObject("logo.robot.middle.1", "addPolygon", 0xffffff, .5,
    {x = 1.5 * rs + rx, y = -5 * rs + ry},
    {x = 1.5 * rs + rx, y = -4 * rs + ry},
    {x = 2 * rs + rx, y = -3.5 * rs + ry},
    {x = 2.5 * rs + rx, y = -4 * rs + ry},
    {x = 2.5 * rs + rx, y = -5 * rs + ry})
  local robotMid2 = surface:addObject("logo.robot.middle.2", "addPolygon", 0xff2020, .5,
    {x = 2.5 * rs + rx, y = -5 * rs + ry},
    {x = 2.5 * rs + rx, y = -4 * rs + ry},
    {x = 5.5 * rs + rx, y = -4 * rs + ry},
    {x = 5.5 * rs + rx, y = -5 * rs + ry})
  local robotMid3 = surface:addObject("logo.robot.middle.3", "addPolygon", 0xffffff, .5,
    {x = 5.5 * rs + rx, y = -5 * rs + ry},
    {x = 5.5 * rs + rx, y = -4 * rs + ry},
    {x = 6 * rs + rx, y = -3.5 * rs + ry},
    {x = 6.5 * rs + rx, y = -4 * rs + ry},
    {x = 6.5 * rs + rx, y = -5 * rs + ry})

  robotMid1.setScreenAnchor("LEFT", "BOTTOM")
  robotMid2.setScreenAnchor("LEFT", "BOTTOM")
  robotMid3.setScreenAnchor("LEFT", "BOTTOM")

  local logoRed1 = surface:addObject("logo.logo.red.1", "addPolygon", 0xff2020, .5,
    {x = 3 * rs + rx, y = -9 * rs + ry},
    {x = 3 * rs + rx, y = -12.5 * rs + ry},
    {x = 5 * rs + rx, y = -12.5 * rs + ry},
    {x = 5 * rs + rx, y = -9 * rs + ry},
    {x = 4.5 * rs + rx, y = -7 * rs + ry},
    {x = 3.5 * rs + rx, y = -7 * rs + ry})
  local logoRed2 = surface:addObject("logo.logo.red.2", "addPolygon", 0xff2020, .5,
    {x = 2.5 * rs + rx, y = -7.5 * rs + ry},
    {x = 2.5 * rs + rx, y = -12.5 * rs + ry},
    {x = 3 * rs + rx, y = -12.5 * rs + ry},
    {x = 3 * rs + rx, y = -9 * rs + ry})
  local logoRed3 = surface:addObject("logo.logo.red.3", "addPolygon", 0xff2020, .5,
    {x = 5.5 * rs + rx, y = -7.5 * rs + ry},
    {x = 5.5 * rs + rx, y = -12.5 * rs + ry},
    {x = 5 * rs + rx, y = -12.5 * rs + ry},
    {x = 5 * rs + rx, y = -9 * rs + ry})
  local logoRed4 = surface:addObject("logo.logo.red.4", "addPolygon", 0xff2020, .5,
    {x = 6.5 * rs + rx, y = -12 * rs + ry},
    {x = 6.5 * rs + rx, y = -5.75 * rs + ry},
    {x = 8 * rs + rx, y = -5 * rs + ry},
    {x = 11 * rs + rx, y = -5 * rs + ry},
    {x = 11 * rs + rx, y = -12 * rs + ry})
  local logoRed5 = surface:addObject("logo.logo.red.5", "addPolygon", 0xff2020, .5,
    {x = 6.5 * rs + rx, y = -4 * rs + ry},
    {x = 6.5 * rs + rx, y = -5 * rs + ry},
    {x = 11 * rs + rx, y = -5 * rs + ry},
    {x = 11 * rs + rx, y = -4 * rs + ry})
  local logoRed6 = surface:addObject("logo.logo.red.6", "addPolygon", 0xff2020, .5,
    {x = 6.5 * rs + rx, y = 3 * rs + ry},
    {x = 6.5 * rs + rx, y = -2.5 * rs + ry},
    {x = 8 * rs + rx, y = -4 * rs + ry},
    {x = 11 * rs + rx, y = -4 * rs + ry},
    {x = 11 * rs + rx, y = 3 * rs + ry})
  local logoRed7 = surface:addObject("logo.logo.red.7", "addPolygon", 0xff2020, .5,
    {x = 4 * rs + rx, y = 3.5 * rs + ry},
    {x = 4 * rs + rx, y = 0 * rs + ry},
    {x = 5.5 * rs + rx, y = -1.5 * rs + ry},
    {x = 5.5 * rs + rx, y = 3.5 * rs + ry})
  local logoRed8 = surface:addObject("logo.logo.red.8", "addPolygon", 0xff2020, .5,
    {x = 4 * rs + rx, y = 3.5 * rs + ry},
    {x = 4 * rs + rx, y = 0 * rs + ry},
    {x = 2.5 * rs + rx, y = -1.5 * rs + ry},
    {x = 2.5 * rs + rx, y = 3.5 * rs + ry})
  local logoRed9 = surface:addObject("logo.logo.red.9", "addPolygon", 0xff2020, .5,
    {x = 1.5 * rs + rx, y = 3 * rs + ry},
    {x = 1.5 * rs + rx, y = -2.5 * rs + ry},
    {x = 0 * rs + rx, y = -4 * rs + ry},
    {x = -3 * rs + rx, y = -4 * rs + ry},
    {x = -3 * rs + rx, y = 3 * rs + ry})
  local logoRed10 = surface:addObject("logo.logo.red.10", "addPolygon", 0xff2020, .5,
    {x = 1.5 * rs + rx, y = -4 * rs + ry},
    {x = 1.5 * rs + rx, y = -5 * rs + ry},
    {x = -3 * rs + rx, y = -5 * rs + ry},
    {x = -3 * rs + rx, y = -4 * rs + ry})
  local logoRed11 = surface:addObject("logo.logo.red.11", "addPolygon", 0xff2020, .5,
    {x = 1.5 * rs + rx, y = -12 * rs + ry},
    {x = 1.5 * rs + rx, y = -5.75 * rs + ry},
    {x = 0 * rs + rx, y = -5 * rs + ry},
    {x = -3 * rs + rx, y = -5 * rs + ry},
    {x = -3 * rs + rx, y = -12 * rs + ry})
  local logoRed12 = surface:addObject("logo.logo.red.12", "addPolygon", 0xff2020, .5,
    {x = 3 * rs + rx, y = -6 * rs + ry},
    {x = 3.5 * rs + rx, y = -7 * rs + ry},
    {x = 4.5 * rs + rx, y = -7 * rs + ry},
    {x = 5 * rs + rx, y = -6 * rs + ry})

  logoRed1.setScreenAnchor("LEFT", "BOTTOM")
  logoRed2.setScreenAnchor("LEFT", "BOTTOM")
  logoRed3.setScreenAnchor("LEFT", "BOTTOM")
  logoRed4.setScreenAnchor("LEFT", "BOTTOM")
  logoRed5.setScreenAnchor("LEFT", "BOTTOM")
  logoRed6.setScreenAnchor("LEFT", "BOTTOM")
  logoRed7.setScreenAnchor("LEFT", "BOTTOM")
  logoRed8.setScreenAnchor("LEFT", "BOTTOM")
  logoRed9.setScreenAnchor("LEFT", "BOTTOM")
  logoRed10.setScreenAnchor("LEFT", "BOTTOM")
  logoRed11.setScreenAnchor("LEFT", "BOTTOM")
  logoRed12.setScreenAnchor("LEFT", "BOTTOM")
end

return drawUI
