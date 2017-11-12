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
  return { x1 = 0, y1 = 0, x2 = 0, y2 = 0, hitList = {}, closest = {}, angle = 0, distance = 0}
end

function raysUpdate(dt)
	-- local stripIdx = 0
  for i = 1, #Rays do
		local rayScreenPos = (-viewport.numRays / 2 + i) * viewport.stripWidth
		local rayViewDist = math.sqrt(rayScreenPos * rayScreenPos + viewport.viewDist * viewport.viewDist)
		local rayAngle = math.asin(rayScreenPos / rayViewDist)
		Rays[i].angle = rayAngle
		local castAngle = rayAngle + player.rot
		rayUpdate(i, dt, castAngle)
	end
end

function rayUpdate(rInd, dt, rayAngle)
  Rays[rInd].hitList = {}
	hitListContainer = {}

  Rays[rInd].x1 = player.x * minimap.scale + minimap.x
  Rays[rInd].y1 = player.y * minimap.scale + minimap.y
  Rays[rInd].x2 = (player.x + math.cos(rayAngle) * 1000) * minimap.scale + minimap.x
  Rays[rInd].y2 = (player.y + math.sin(rayAngle) * 1000) * minimap.scale + minimap.y
  World:rayCast(Rays[rInd].x1, Rays[rInd].y1, Rays[rInd].x2, Rays[rInd].y2, raycastCallback) -- rayCastLogic
	for i = 1, #hitListContainer do
		table.insert(Rays[rInd].hitList, hitListContainer[i])
	end
  table.sort(Rays[rInd].hitList, hitListSort)

  local this = Rays[rInd].hitList[1]
	Rays[rInd].distance = this.fraction * getDistance(Rays[rInd].x1, Rays[rInd].y1, Rays[rInd].x2, Rays[rInd].y2) * minimap.scale * 2
	Rays[rInd].angle = rayAngle
	-- print normals (x = -1 - +1, y = -1 - +1)
	--if rayAngle == player.rot then 	print(this.xn, this.yn) end
	--if rayAngle == player.rot then 	print(this.x) end
	--if rayAngle == player.rot then 	print(getTexOffset(this.x, this.y, this.xn, this.yn)) end
	--if rayAngle == player.rot then 	print(this.x, this.y, this.xn, this.yn, this.x - viewport.x, this.y - viewport.y) end
  Rays[rInd].closest = {x = this.x, y = this.y, xn = this.xn, yn = this.yn, fraction = this.fraction }
end

function raysDraw()

  for i = 1, #Rays do
		local this = Rays[i]
		rayDraw(i) -- draws rays on minimap
		stripDraw(i)
--[[
		local x = viewport.x + (i - 1) * viewport.stripWidth
		local h = ( 512 / (Rays[i].distance * (math.cos(player.rot - Rays[i].angle )))) * 256
		if h > viewport.h then h = viewport.h end
		local y = viewport.y + viewport.h / 2 - h / 2
		if y < viewport.y then y = viewport.y end
		local w = viewport.stripWidth

		local color = 255 - (128 * (Rays[i].distance / 5000))
		if color > 255 then color = 255 end
		if Rays[i].closest.xn < 0 or Rays[i].closest.yn < 0 then
			color = color * 0.67
		end
		love.graphics.setColor(color, color, color, 255)
		if Rays[i].angle == player.rot then
			love.graphics.setColor(255, 128, 128, 255)
		end

		-- love.graphics.rectangle('fill', x, y, w, h)
		local offset = getTexOffset(Rays[i].closest.x, Rays[i].closest.y, Rays[i].closest.xn, Rays[i].closest.yn)
			--if Rays[i].closest.xn > 0 or Rays[i].closest.yn < 0 then offset = offset - 1 end
			--while offset < 0 do offset = offset + 64 end
		offset = (i + math.floor(offset)) % 64
		--if offset < 1 then offset = 1 end
		--if this.angle == player.rot then print(offset) end
		--if this.angle == player.rot then print(this.closest.x, this.closest.y, this.closest.xn, this.closest.yn) end
		--if this.closest.xn < 0 or this.closest.yn < 0 then offset = offset + 64 end
		--love.graphics.draw(image, strips[offset], x, y + 1, 0, 8	, 8 * (h / 512))
		love.graphics.draw(image, strips[offset], x, y + 1, 0, 8	, 8 * (h / 512))]]
	end
end

-- draws rays o minimap
function rayDraw(rInd)
	love.graphics.setColor(128, 128, 255, 128)
  if debug then
    love.graphics.line(Rays[rInd].x1, Rays[rInd].y1, Rays[rInd].x2, Rays[rInd].y2)
    for i = 1, #Rays[rInd].hitList do
      local this = Rays[rInd].hitList[i]
      if i == 1 then
        love.graphics.setColor(255, 128, 255, 255)
      else
        love.graphics.setColor(128, 255, 128, 255)
      end
      love.graphics.rectangle('fill', Rays[rInd].x - 2, Rays[rInd].y - 2, 4, 4)
    end
    love.graphics.setColor(255, 255, 0, 255)
    love.graphics.circle('line', Rays[rInd].closest.x , Rays[rInd].closest.y, 10)
  else
    love.graphics.line(Rays[rInd].x1, Rays[rInd].y1, Rays[rInd].closest.x, Rays[rInd].closest.y)
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
	love.graphics.setColor(128, 128, 128, 255)
	love.graphics.rectangle('fill', x, y, w, h)
end

function getTexOffset(x, y, xn, yn)
	--local offset = 0
	--local yBase = math.abs( (y % (64 / 4)))
	--local xBase = math.abs( (x % 64) / 4)
	if yn ~= 0 then
		--return xBase
		return x % 64
	else
		--return yBase
		return y % 64
	end
end


function stripDraw(i)

	local x = viewport.x + (i - 1) * viewport.stripWidth
	local h = ( 512 / (Rays[i].distance * (math.cos(player.rot - Rays[i].angle )))) * 256
	if h > viewport.h then h = viewport.h end
	local y = viewport.y + viewport.h / 2 - h / 2
	if y < viewport.y then y = viewport.y end
	local w = viewport.stripWidth

	local color = 255 - (128 * (Rays[i].distance / 5000))
	if color > 255 then color = 255 end
	if Rays[i].closest.xn < 0 or Rays[i].closest.yn < 0 then
		color = color * 0.67
	end
	love.graphics.setColor(color, color, color, 255)
	if Rays[i].angle == player.rot then
		love.graphics.setColor(255, 128, 128, 255)
	end

	-- love.graphics.rectangle('fill', x, y, w, h)
	local offset = getTexOffset(Rays[i].closest.x, Rays[i].closest.y, Rays[i].closest.xn, Rays[i].closest.yn)
		--if Rays[i].closest.xn > 0 or Rays[i].closest.yn < 0 then offset = offset - 1 end
		--while offset < 0 do offset = offset + 64 end
	offset = (i + math.floor(offset)) % 64
	--if offset < 1 then offset = 1 end
	--if this.angle == player.rot then print(offset) end
	--if this.angle == player.rot then print(this.closest.x, this.closest.y, this.closest.xn, this.closest.yn) end
	--if this.closest.xn < 0 or this.closest.yn < 0 then offset = offset + 64 end
	--love.graphics.draw(image, strips[offset], x, y + 1, 0, 8	, 8 * (h / 512))
	love.graphics.draw(image, strips[offset], x, y + 1, 0, 8	, 8 * (h / 512))

end
