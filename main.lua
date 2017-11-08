require './box2d'
require './map'
require './minimap'
require './player'
require './viewport'
require './io'
require './rays'

function love.load()
  love.graphics.setBackgroundColor(32, 0, 0)
  box2dInt()

  minimap   = minimapInit(#map[1], #map)
  player    = playerInit()
  Ray       = rayInit()
  viewport  = viewportInit()

  createMapFixtures()

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
  love.graphics.setColor(128, 128, 255, 128)
  love.graphics.line(Ray.x1, Ray.y1, Ray.x2, Ray.y2)
end
