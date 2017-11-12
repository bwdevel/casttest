require './box2d'
require './map'
require './minimap'
require './player'
require './viewport'
require './io'
require './rays'
require './debug'

function love.load()
  MOVE_TYPE = 'grid'
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

  image = love.graphics.newImage( 'assets/wall_01.png' )
  strips = {}
  for x = 0, 63 do
    strips[x] = love.graphics.newQuad(x, 0, 1, 63, image:getDimensions())
  end
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
