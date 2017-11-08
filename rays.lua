function rayInit()
  return { x1 = 0, y1 = 0, x2 = 0, y2 = 0 }
end

function rayUpdate(dt)
  Ray.hitList = {}
  Ray.x1 = player.x * minimap.scale + minimap.x
  Ray.y1 = player.y * minimap.scale + minimap.y
  Ray.x2 = (player.x + math.cos(player.rot) * 1000) * minimap.scale + minimap.x
  Ray.y2 = (player.y + math.sin(player.rot) * 1000) * minimap.scale + minimap.y
end
