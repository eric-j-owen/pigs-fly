bullet_mgr = {
    -- cooldown = 0,
    bullets = {},
    types = {
        player = {
            spr = 7,
            dmg = 1,
            dx  = 3,
            w   = 8,
            h   = 1,
        },
        egg = {
            dmg = 1,
            dx  = 3,
            w   = 1,
            h   = 1,
            spr = 19,
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

    if self.x < -10 or self.x > 128 or self.y < 0 or self.y > 128 then
        del(bullet_mgr.bullets, self)
    end

    --egg logic 
    if self.spr == 19 and self.y >= 112 then
        self.spr = 20
        self.dy = 0
        self.dx = -.75
        self.active = false
    end
end

function Bullet:draw()
    if not self.spr then
        pset(self.x,self.y,self.clr)
    else 
        spr(self.spr, self.x,self.y)
    end

end

function bullet_mgr:shoot(type, args)
    local b = self.types[type]
    --create new bullet 
    local new_b = Bullet:new({
        tbl = self.bullets,
        x      = args.x,
        y      = args.y,
        dx     = args.dx or b.dx,
        dy     = args.dy or b.dy,
        w      = b.w,
        h      = b.h,
        dmg    = b.dmg,
        clr    = b.clr or 7,
        spr    = b.spr or nil,
        active = b.active or true,
    })
    add(self.bullets, new_b)

    if new_b.spr == 7 then -- player's bullet spr
        fx_mgr:spawn('muzz_flash', {x=p1.x+2,y=p1.y+1}) 
    end

end

function bullet_mgr:update()
    for b in all(self.bullets) do
        b:cleanup()
        b:update()


        --collision
        if b.active then
            if b.spr == 7 then --player bullet sprite
                for e in all(enemy_mgr.enemies) do
                    if coll(b, e) then
                        b:die()
                        e:take_dmg(b.dmg)
                    end
                end
            else --if not player, assume bullet is enemy's   
                if coll(b,p1) then
                    b:die()
                    p1:take_dmg(b.dmg)
                end
            end
        end
    end
end

function bullet_mgr:draw()
    for b in all(self.bullets) do
        b:draw()
    end
end