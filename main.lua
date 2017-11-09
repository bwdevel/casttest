require './box2d'
require './map'
require './minimap'
require './player'
require './viewport'
require './io'
require './rays'
require './debug'

function love.load()
  love.graphics.setBackgroundColor(32, 0, 0)
  box2dInt()

  minimap   = minimapInit(#map[1], #map)
  player    = playerInit()
  Ray       = rayInit()
  viewport  = viewportInit()

  createMapFixtures()

  debug = false

end

function love.update(dt)
  World:update(dt)
  playerUpdate(dt)
  rayUpdate(dt)
end

function love.draw()
  minimapDraw()
  playerDraw()
  viewportDraw()
  rayDraw()

  if debug then debugDraw() end
end

-- table.sort(tab, tableCompare)
function tableCompare(a, b)
  return a.fraction < b.fraction
end
