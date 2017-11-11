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

  if key == '1' then player.rot = 0 end
  if key == '2' then player.rot = math.pi / 2 end
  if key == '3' then player.rot = math.pi end
  if key == '4' then player.rot = math.pi * 1.5 end

  if key == 'o' then
    if MOVE_TYPE == 'grid' then
      MOVE_TYPE = 'real'
    else
      MOVE_TYPE = 'grid'
      player.x = math.floor(player.x) + 0.5
      player.y = math.floor(player.y) + 0.5
      if player.rot >= 0 and player.rot < math.pi / 4 then
        player.rot = 0
      elseif player.rot >= math.pi / 4 and player.rot < math.pi / 2 + math.pi / 4 then
        player.rot = math.pi / 2
      elseif player.rot >= math.pi / 2 + math.pi / 4 and player.rot < math.pi + math.pi / 4 then
        player.rot = math.pi
      else
        player.rot = math.pi + math.pi / 2
      end
    end
  end
end
