function raycastCallback(fixture, x, y, xn, yn, fraction)
	local hit = {}
	hit.fixture = fixture
	hit.x, hit.y = x, y
	hit.xn, hit.yn = xn, yn
	hit.fraction = fraction

	table.insert(hitListContainer, hit)

	return 1 -- Continues with ray cast through all shapes.
end

function raysInit(count)
	local out = {}
	for i = 1, count do
		table.insert(out, rayInit())
	end
	return out
end

function rayInit()
  return { x1 = 0, y1 = 0, x2 = 0, y2 = 0, hitList = {}, closest = nil}
end

function raysUpdate(dt)
	local stripIdx = 0
  for i = 1, #Rays do
		local rayScreenPos = (-viewport.numRays / 2 + i) * viewport.stripWidth
		local rayViewDist = math.sqrt(rayScreenPos * rayScreenPos + viewport.viewDist * viewport.viewDist)
		local rayAngle = math.asin(rayScreenPos / rayViewDist)
		local castAngle = rayAngle + player.rot
		rayUpdate(Rays[i], dt, castAngle)
	end
end

function rayUpdate(ray, dt, rayAngle)
  ray.hitList = {}
	hitListContainer = {}

  ray.x1 = player.x * minimap.scale + minimap.x
  ray.y1 = player.y * minimap.scale + minimap.y
  ray.x2 = (player.x + math.cos(rayAngle) * 1000) * minimap.scale + minimap.x
  ray.y2 = (player.y + math.sin(rayAngle) * 1000) * minimap.scale + minimap.y
  World:rayCast(ray.x1, ray.y1, ray.x2, ray.y2, raycastCallback) -- rayCastLogic
	for i = 1, #hitListContainer do
		table.insert(ray.hitList, hitListContainer[i])
	end
  table.sort(ray.hitList, hitListSort)

  local this = ray.hitList[1]
  ray.closest = {x = this.x, y = this.y }
end

function raysDraw()
  --rayDraw(Ray)
  for i = 1, #Rays do rayDraw(Rays[i]) end
end

function rayDraw(ray)
  love.graphics.setColor(128, 128, 255, 128)
  if debug then
    love.graphics.line(ray.x1, ray.y1, ray.x2, ray.y2)
    for i = 1, #ray.hitList do
      local this = ray.hitList[i]
      if i == 1 then
        love.graphics.setColor(255, 128, 255, 255)
      else
        love.graphics.setColor(128, 255, 128, 255)
      end
      love.graphics.rectangle('fill', this.x - 2, this.y - 2, 4, 4)
    end
    love.graphics.setColor(255, 255, 0, 255)
    love.graphics.circle('line', ray.closest.x , ray.closest.y, 10)
  else
    love.graphics.line(ray.x1, ray.y1, ray.closest.x, ray.closest.y)
  end
end

function getDistance(ax, ay, bx, by)
  local a = math.abs(ax - bx)
  local b = math.abs(ay - by)
  return math.sqrt(a * a + b * b)
end

function hitListSort(a, b)
  return a.fraction < b.fraction
end
