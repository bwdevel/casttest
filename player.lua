function playerInit()
  local out = {}
  out.x = 4.5
  out.y = 5.5
  out.rot = 0
  out.moveSpeed = 0.06
  out.rotSpeed = 3
  out.move = {}
    out.move.left = false
    out.move.right = false
    out.move.up = false
    out.move.down = false
    out.move.sleft = false
    out.move.sright = false
  return out
end


function playerDraw()
  local x1 = player.x * minimap.scale + minimap.x - 2
  local y1 = player.y * minimap.scale + minimap.y - 2
  local w = 4
  local h = 4
  -- draw character
  love.graphics.setColor(255, 128, 128, 255)
  love.graphics.rectangle('fill', x1, y1, w, h)
  -- draw direction
  local x2 = (player.x + math.cos(player.rot)) * minimap.scale + minimap.x
  local y2 = (player.y + math.sin(player.rot)) * minimap.scale + minimap.y
  love.graphics.line(x1 + 2, y1 + 2, x2, y2)
end

function playerUpdate(dt)

  local newX = player.x
  local newY = player.y

  if MOVE_TYPE == 'real' then
    local moveRate = player.moveSpeed
    if player.move.right then
      player.rot = player.rot + player.rotSpeed * dt
    end
    if player.move.left then
      player.rot = player.rot - player.rotSpeed * dt
    end
    player.rot = player.rot % (math.pi * 2)
    while player.rot < 0 do player.rot = player.rot + math.pi * 2 end

    if player.move.up then
      newX = player.x + math.cos(player.rot) * moveRate
      newY = player.y + math.sin(player.rot) * moveRate
    elseif player.move.down then
      newX = player.x + math.cos(player.rot) * moveRate * -1
      newY = player.y + math.sin(player.rot) * moveRate * -1
    end
    if player.move.sleft then
      newX = player.x + math.cos(player.rot - math.pi / 2) * moveRate
      newY = player.y + math.sin(player.rot - math.pi / 2) * moveRate
    elseif player.move.sright then
      newX = player.x + math.cos(player.rot - math.pi / 2) * moveRate * -1
      newY = player.y + math.sin(player.rot - math.pi / 2) * moveRate * -1
    end
  elseif MOVE_TYPE == 'grid' then
    if player.move.up then
      newX = player.x + math.cos(player.rot)
      newY = player.y + math.sin(player.rot)
      player.move.up = false
    elseif player.move.down then
      newX = player.x + math.cos(player.rot) * -1
      newY = player.y + math.sin(player.rot) * -1
      player.move.down = false
    elseif player.move.left then
      player.rot = (player.rot - math.pi / 2) % (math.pi * 2)
      player.move.left = false
    elseif player.move.right then
      player.rot = (player.rot + math.pi / 2) % (math.pi * 2)
      player.move.right = false
    elseif player.move.sleft then
      newX = player.x + math.cos(player.rot - math.pi / 2)
      newY = player.y + math.sin(player.rot - math.pi / 2)
      player.move.sleft = false
    elseif player.move.sright then
      newX = player.x + math.cos(player.rot - math.pi / 2) * -1
      newY = player.y + math.sin(player.rot - math.pi / 2) * -1
      player.move.sright = false
    end
  end

  if not playerIsBlocked(newX, newY) then
    player.x = newX
    player.y = newY
  end
end

function playerIsBlocked(x, y)
  if y < 1 or y > #map or x < 1 or x > #map[1] then
    return true
  else
    return (map[math.ceil(y)][math.ceil(x)] ~= 0)
  end
end
