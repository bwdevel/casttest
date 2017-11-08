function box2dInt()
  love.physics.setMeter(1)
  World = love.physics.newWorld()
  Terrain = {}
  Terrain.Body = love.physics.newBody(World, 0, 0, "static")
  Terrain.Stuff = {}
end

function createMapFixtures()
  -- clear out old Stuff
  for i = #Terrain.Stuff, 1, -1 do
    Terrain.Stuff[i].Fixture:destroy()
    table.remove(Terrain.Stuff, i)
  end

  for y = 1, #map do
    for x = 1, #map[y] do
      local p = {}
      if map[y][x] ~= 0 then
        p.x = (x - 1) * minimap.scale + minimap.x + minimap.scale / 2
        p.y = (y - 1) * minimap.scale + minimap.y + minimap.scale / 2
        p.Shape = love.physics.newRectangleShape(p.x, p.y, minimap.scale, minimap.scale)
        p.Fixture = love.physics.newFixture(Terrain.Body, p.Shape)
        table.insert(Terrain.Stuff, p)
      end
    end
  end
end
