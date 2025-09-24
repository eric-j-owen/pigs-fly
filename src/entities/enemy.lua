enemy_mgr = {
    enemies = {},

    types = {
        chicken = {
            hp       = 1,
            beg_spr  = 44,
            end_spr  = 47,
            g        = 0.03,
            dy       = 0,
            dx       = 0.5,
            cooldown = 0,      
            fire_r   = 15,
            ani_t    = 0,
            ani_spd  = 10,
            update = function(self) 
                self.dy += self.g
                
                self.x -= self.dx
                self.y += self.dy
                
                --fall speed clamp
                if self.dy > 0 then 
                    self.dy = mid(0,self.dy, .4)
                end

                --if in air and player is near enemy, shoot
                if self.dy < 0 and p1.x >= self.x - 4 and p1.x <= self.x + 8 then
                    if self.cooldown <= 0 then
                        bullet_mgr:shoot('basic', { x = self.x, y = self.y, dx = 0, dy = 1})
                        self.cooldown = self.fire_r
                    else
                        self.cooldown -= 1
                    end
                end

                 
                 --collision ground 
                if self.y > 105 then
                    self.y = 105
                    self.dy = 0
                    self.ani_spd = 10

                    --jump logic
                    if self.y - p1.y > 6 and self.x <= p1.x + 30 then
                        self.dy = -2
                        self.ani_spd = 3                       
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

        --animate sprites
        e.ani_t += 1
        if e.ani_t % e.ani_spd == 0 then
            e.spr += 1
            if e.spr > e.end_spr then
                e.spr = e.beg_spr
            end
        end

        if e.x < -10 or e.x > 130 or e.y < -10 or e.y > 130 then
            del(self.enemies, e)
        end
    end
end

function enemy_mgr:draw()
    for e in all(self.enemies) do
        spr(e.spr, e.x, e.y)
    end
end