function raycastCallback(fixture, x, y, xn, yn, fraction)
	local hit = {}
	hit.fixture = fixture
	hit.x, hit.y = x, y
	hit.xn, hit.yn = xn, yn
	hit.fraction = fraction

	table.insert(Ray.hitList, hit)

	return 1 -- Continues with ray cast through all shapes.
end


function rayInit()
  return { x1 = 0, y1 = 0, x2 = 0, y2 = 0, hitList = {}, closest = nil}
end

function rayUpdate(dt)
  Ray.hitList = {}
  Ray.x1 = player.x * minimap.scale + minimap.x
  Ray.y1 = player.y * minimap.scale + minimap.y
  Ray.x2 = (player.x + math.cos(player.rot) * 1000) * minimap.scale + minimap.x
  Ray.y2 = (player.y + math.sin(player.rot) * 1000) * minimap.scale + minimap.y

  World:rayCast(Ray.x1, Ray.y1, Ray.x2, Ray.y2, raycastCallback)

  --local closest = {100000, Ray.x2, Ray.y2}
  local closest = {100000, 100000, 1000000}
  local index = {}
  for i = 1, #Ray.hitList do
    local this = Ray.hitList[i]
    local thisDist = getDistance(player.x, player.y, this.x, this.y)
    if thisDist < closest[1] then
      closest = {thisDist, this.x, this.y}
    end
    print(thisDist .. ',' .. this.x .. ',' .. this.y)
  end
  Ray.closest = closest

end

function rayDraw()
  love.graphics.setColor(128, 128, 255, 128)
  love.graphics.line(Ray.x1, Ray.y1, Ray.x2, Ray.y2)

  for i = 1, #Ray.hitList do
    this = Ray.hitList[i]
    if i == 1 then
      love.graphics.setColor(255, 128, 255, 255)
    else
      love.graphics.setColor(128, 255, 128, 255)
    end
    love.graphics.rectangle('fill', this.x - 2, this.y - 2, 4, 4)

  end
  love.graphics.setColor(255, 255, 0, 255)
  love.graphics.circle('line', Ray.closest[2] , Ray.closest[3], 10)

end

function getDistance(ax, ay, bx, by)
  return math.sqrt(ax * ax + bx * by)
end
