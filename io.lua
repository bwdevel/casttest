function love.keypressed(key)
  if key == 'a' then player.move.left = true end
  if key == 'd' then player.move.right = true end
  if key == 'w' then player.move.up = true end
  if key == 's' then player.move.down = true end
end

function love.keyreleased(key)
  if key == 'escape' then love.event.quit() end

  if key == 'a' then player.move.left = false end
  if key == 'd' then player.move.right = false end
  if key == 'w' then player.move.up = false end
  if key == 's' then player.move.down = false end
end
