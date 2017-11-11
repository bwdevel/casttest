function debugDraw()
  local text = {
    "FPS: " .. tostring(love.timer.getFPS()),
    "Rays: " .. tostring(#Rays)
  }
  local x = 10
  local y = 10
  local w = 250
  local h = 4 + #text * 16

  love.graphics.setColor(0, 0, 0, 128)
  love.graphics.rectangle('fill', x, y, w, h)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle('line', x, y, w, h)

  love.graphics.setColor(255, 255, 255, 255)
  for i = 1, #text do
    love.graphics.print(text[i], x + 2, y + 2 + (i - 1) * 16)
  end

end
