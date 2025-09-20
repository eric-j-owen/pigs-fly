Entity = {
    x = 0,
    y = 0,
    spr = nil, --sprite
    w = 8, --width
    h = 0, --height
    dx = 0, --change in x
    dy = 0, --change in y
    acc = 0 --acceleration
}

--constructor
function Entity:new(o)
    o = o or {}
    setmetatable(o, { __index = self })
    return o
end

function Entity:draw()
    spr(self.spr, self.x, self.y)
end

function Entity:update()
    self.x += self.dx
    self.y += self.dy
end