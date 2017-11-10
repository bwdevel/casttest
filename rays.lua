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
  return { x1 = 0, y1 = 0, x2 = 0, y2 = 0, hitList = {}, closest = nil, angle = 0, distance = 0}
end

function raysUpdate(dt)
	-- local stripIdx = 0
  for i = 1, #Rays do
		local rayScreenPos = (-viewport.numRays / 2 + i) * viewport.stripWidth
		local rayViewDist = math.sqrt(rayScreenPos * rayScreenPos + viewport.viewDist * viewport.viewDist)
		local rayAngle = math.asin(rayScreenPos / rayViewDist)
		Rays[i].angle = rayAngle
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
	ray.distance = this.fraction * getDistance(ray.x1, ray.y1, ray.x2, ray.y2) * minimap.scale * 2
	ray.angle = rayAngle
  ray.closest = {x = this.x, y = this.y }
end

function raysDraw()

  for i = 1, #Rays do
		local this = Rays[i]
		rayDraw(this)


		local x = viewport.x + (i - 1) * viewport.stripWidth
		local h = ( 512 / (this.distance * (math.cos(player.rot - this.angle )))) * 256
		local hh = h
		if h > viewport.h then h = viewport.h end
		local y = viewport.y + viewport.h / 2 - h / 2
		if y < viewport.y then y = viewport.y end
		local w = viewport.stripWidth
		local color = 128 - (128 * (this.distance / 5000))
		if color > 255 then color = 255 end
		love.graphics.setColor(color, color, color, 255)
		love.graphics.rectangle('fill', x, y, w, h)

		--love.graphics.draw(image, strips[i - 1], x, y, 0, 8, 8 * (h / 512))
	end
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

function drawSlice(dist, x, y, w, h)
	local h = ( 512 / dist) * 256
	local w = 4
	local x = viewport.x + viewport.w / 2 - 2
	local y = viewport.y + viewport.h / 2 - h / 2
	if y < viewport.y then y = viewport.y end
	if h > viewport.h then h = viewport.h end
	print(y)
	love.graphics.setColor(128, 128, 128, 255)
	love.graphics.rectangle('fill', x, y, w, h)
	--print(dist .. ' -> ' .. h)
end
