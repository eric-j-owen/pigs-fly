Particle = {
    x     = 0,
    y     = 0,
    r     = 1,  --radius
    c     = 7   --color
  
}

--constructor
function Particle:new(o)
    o = o or {}
    setmetatable(o, { __index = self })
    return o
end

function Particle:update()

end

function Particle:draw()
    circfill(self.x, self.y, self.r, self.c)
end