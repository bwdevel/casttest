function viewportInit()
  local out = {}
  out.w = 512
  out.h = 512
  out.y = love.graphics.getHeight() / 2 - out.h / 2
  out.x = out.y
  return out
end

function viewportDraw()

  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.rectangle('fill', viewport.x, viewport.y, viewport.w, viewport.h)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle('line', viewport.x, viewport.y, viewport.w, viewport.h)
end
