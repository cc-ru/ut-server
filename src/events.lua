local events = {}

local function register(engine)
  events.Init = engine:event("init")
  events.Stop = engine:event("stop")
end

return {
  events = events,
  register
}
