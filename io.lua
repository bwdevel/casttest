function love.keypressed(key)
  if key == 'a' or key == 'left' then player.move.left = true end
  if key == 'd' or key == 'right' then player.move.right = true end
  if key == 'w' or key == 'up' then player.move.up = true end
  if key == 's' or key == 'down' then player.move.down = true end
  if key == 'q' then player.move.sleft = true end
  if key == 'e' then player.move.sright = true end
end

function love.keyreleased(key)
  if key == 'escape' then love.event.quit() end
  if key == 'p' then
    if debug then debug = false else debug = true end
  end

  if key == 'a' or key == 'left' then player.move.left = false end
  if key == 'd' or key == 'right' then player.move.right = false end
  if key == 'w' or key == 'up' then player.move.up = false end
  if key == 's' or key == 'down' then player.move.down = false end
  if key == 'q' then player.move.sleft = false end
  if key == 'e' then player.move.sright = false end
end
