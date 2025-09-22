bullet_mgr = {
    cooldown = 0,
    bullets = {},
    types = {
        basic = { 
            dmg = 1,
            dx  = 3,
            w   = 1,
            h   = 1,
            f_r  = 15, --fire rate- frames between shots

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
    local t = self.types[type]
    if not t then return end

    if self.cooldown > 0 then return end

    --create new bullet
    local b = Bullet:new({
        x = args.x,
        y = args.y,
        dx = args.dx or t.dx,
        dy = args.dy or t.dy,
        w = t.w,
        h = t.h,
        dmg = t.dmg
    })
    add(self.bullets, b)

    --reset cooldown
    self.cooldown = t.f_r
end

function bullet_mgr:update()
    if self.cooldown > 0 then self.cooldown -= 1 end
    for b in all(self.bullets) do
        b:update()
    end
end


function bullet_mgr:draw()
    for b in all(self.bullets) do
        b:draw()
    end
end