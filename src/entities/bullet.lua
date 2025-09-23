bullet_mgr = {
    -- cooldown = 0,
    bullets = {},
    types = {
        basic = { 
            dmg = 1,
            dx  = 3,
            w   = 1,
            h   = 1,
        }
    }
}

Bullet = Entity:new()

function Bullet:new(o)
    o = o or {}
    setmetatable(o, { __index = self })
    return o
end

function Bullet:update()
    self.x += self.dx
    self.y += self.dy

    if self.x < 0 or self.x > 128 or self.y < 0 or self.y > 128 then
        del(bullet_mgr.bullets, self)
    end
end

function Bullet:draw()
    pset(self.x,self.y,7)
end

function bullet_mgr:shoot(type, args)
    local b = self.types[type]
    --create new bullet 
    local new_b = Bullet:new({
        x   = args.x,
        y   = args.y,
        dx  = args.dx or b.dx,
        dy  = args.dy or b.dy,
        w   = b.w,
        h   = b.h,
        dmg = b.dmg,
    })
    add(self.bullets, new_b)

end

function bullet_mgr:update()
    for b in all(self.bullets) do
        b:update()
    end
end

function bullet_mgr:draw()
    for b in all(self.bullets) do
        b:draw()
    end
end