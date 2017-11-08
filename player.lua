function playerInit()
  local out = {}
  out.x = 4
  out.y = 5
  out.rot = 0
  out.moveSpeed = 0.18
  out.rotSpeed = 0.5
  out.move = {}
    out.move.left = false
    out.move.right = false
    out.move.up = false
    out.move.down = false
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
  local x2 = (player.x + math.cos(player.rot) * 2) * minimap.scale + minimap.x
  local y2 = (player.y + math.sin(player.rot) * 2) * minimap.scale + minimap.y
  love.graphics.line(x1 + 2, y1 + 2, x2, y2)
end

function playerUpdate(dt)
  if player.move.right then
    player.rot = player.rot + player.rotSpeed * dt
  end
  if player.move.left then
    player.rot = player.rot - player.rotSpeed * dt
  end
  player.rot = player.rot % (math.pi * 2)
  while player.rot < 0 do player.rot = player.rot + math.pi * 2 end
end
