function minimapInit(mapWidth, mapHeight)
  globalvar = 123
  local out = {}
  out.scale = 16
  out.w = mapWidth * out.scale
  out.h = mapHeight * out.scale
  out.x = (love.graphics.getWidth() / 4) * 3 - out.w / 2
  out.y = love.graphics.getHeight() / 2 - out.h / 2
  return out
end

function minimapDraw()
  for y = 1, #map do
    for x = 1, #map[y] do
      if map[y][x] == 1 then
        love.graphics.setColor(255, 255, 255, 255)
      else
        love.graphics.setColor(0, 0, 0, 255)
      end
      local xx = minimap.x + (x -1) * minimap.scale
      local yy = minimap.y + (y -1) * minimap.scale
      local ww = minimap.scale
      local hh = minimap.scale
      love.graphics.rectangle('fill', xx, yy, ww, hh )
    end
  end
  love.graphics.setColor(128, 255, 128, 255)
  for i, v in ipairs(Terrain.Stuff) do
    love.graphics.polygon('line', Terrain.Body:getWorldPoints(v.Shape:getPoints()))
  end
end
