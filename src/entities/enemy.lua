enemy_mgr = {
    enemies = {},

    types = {
        chicken = {
            type     = 'enemy',
            hp       = 3,
            beg_spr  = 44,
            end_spr  = 47,
            h        = 8,
            w        = 8,
            g        = 0.03,
            dy       = 0,
            dx       = 0.5,
            cooldown = 0,      
            fire_r   = 15,
            ani_spd  = .15,
            update = function(self) 
                self.dy += self.g
                
                self.x -= self.dx
                self.y += self.dy
                
                --fall speed clamp
                if self.dy > 0 then 
                    self.dy = mid(0,self.dy, .4)
                end

                --shoot if in air at a certain threshold
                if self.dy < 0 and self.y < 40 then
                    if self.cooldown <= 0 then
                        bullet_mgr:shoot('egg', { x = self.x+2, y = self.y, dx = 0, dy = 1})
                        self.cooldown = 1 --limits 1 shot per enemy
                    end
                end

                 
                 --collision ground 
                if self.y > 105 then
                    self.y = 105
                    self.dy = 0

                    --jump logic, dont jump if player stays at ground level, jump near player
                    if self.y - p1.y > 6 and self.x <= p1.x + 30 then
                        self.dy = -2
                        self.ani_spd = .5                    
                    end 
                end 


            end,
        },
        octopus = {},
        bomber = {},
        alien = {},
        jeff = {},
        boss = {}
    }
}

Enemy = Entity:new()

function Enemy:new(o)
    o = o or {}
    setmetatable(o, { __index = self })
    return o
end


function enemy_mgr:spawn(type, args)
    local e = self.types[type]

    local new_e = Enemy:new({
        x       = args.x,
        y       = args.y,
        h       = e.h,
        w       = e.w,
        hp      = e.hp,
        spr     = e.beg_spr,
        beg_spr = e.beg_spr,
        end_spr = e.end_spr,
        dx      = e.dx,
        dy      = e.dy,
        g       = e.g,
        update  = e.update,
        ani_spd = e.ani_spd,
        ani_t   = e.ani_t,
        cooldown= e.cooldown,
        fire_r  = e.fire_r
    })

    add(self.enemies, new_e)
end

function enemy_mgr:update()
    for e in all(self.enemies) do
        e:update()

      
        --animations
        e.spr += e.ani_spd
        if e.spr >= e.end_spr + 1 then e.spr = e.beg_spr end

        --collisions
        if coll(e, p1) then
            p1:take_dmg(1)
        end

        --cleanup
        if e.x < -10 or e.x > 130 or e.y < -10 or e.y > 130 then
            del(self.enemies, e)
        end

        --death
        if e.hp <= 0 then del(self.enemies, e) end

    end
end

function enemy_mgr:draw()
    for e in all(self.enemies) do

        spr(e.spr, e.x, e.y)
    end
end