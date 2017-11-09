require './box2d'
require './map'
require './minimap'
require './player'
require './viewport'
require './io'
require './rays'
require './debug'

function love.load()
  TWO_PI = math.pi * 2

  love.graphics.setBackgroundColor(32, 0, 0)
  box2dInt()

  minimap   = minimapInit(#map[1], #map)
  player    = playerInit()
  viewport  = viewportInit()
  --Ray       = rayInit()
  hitListContainer = {}
  Rays      = raysInit(viewport.numRays)

  createMapFixtures()

  debug = false
end

function love.update(dt)
  World:update(dt)
  playerUpdate(dt)
  raysUpdate(dt)
end

function love.draw()
  minimapDraw()
  viewportDraw()
  raysDraw()
  playerDraw()

  if debug then debugDraw() end
end
