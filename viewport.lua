function viewportInit()
  local out = {}
  out.w = 512
  out.h = 512
  out.y = love.graphics.getHeight() / 2 - out.h / 2
  out.x = out.y
  out.stripWidth = 8
  out.fov = 75 * math.pi / 180
  out.fovHalf = out.fov / 2
  out.numRays = math.ceil(out.w / out.stripWidth)
  out.viewDist = (out.w / 2) / math.tan(out.fov / 2)
  return out
end

function viewportDraw()

  love.graphics.setColor(32, 32, 32, 255)
  love.graphics.rectangle('fill', viewport.x, viewport.y, viewport.w, viewport.h / 2)
  love.graphics.setColor(16, 16, 16, 255)
  love.graphics.rectangle('fill', viewport.x, viewport.y + viewport.h / 2, viewport.w, viewport.h / 2)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle('line', viewport.x, viewport.y, viewport.w, viewport.h)
end
