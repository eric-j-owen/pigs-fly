enemy_mgr = {
    enemies = {},

    types = {
        chicken = {
            e_type  = 'chicken',
            hp       = 3,
            beg_spr  = 44,
            end_spr  = 47,
            h        = 7,
            w        = 7,
            g        = 0.03,
            dy       = 0,
            dx       = 0.5,
            cooldown = 0,      
            fire_r   = 60,
            ani_spd  = .15,
            spwn_y   = 105,
            update = function(self)
                bnds = level_mgr.levels[level_mgr.curr_lvl].bounds


                self.dy += self.g
                
                self.x -= self.dx
                self.y += self.dy
                
                --fall speed clamp to give floating feel
                if self.dy > 0 then 
                    self.dy = mid(0,self.dy, .4)
                end

                self.cooldown -= 1
                --shoot if in air at a certain height OR if player is under between 2 bounds
                if (self.dy < 0 and self.y < 70) or (p1.x >= self.x-8 and p1.x <= self.x+8) then
                    if self.cooldown <= 0 then
                        bullet_mgr:shoot('egg', { x = self.x+2, y = self.y, dx = 0, dy = 1})
                        self.cooldown = self.fire_r
                    end
                end
                

                 
                 --collision ground 
                if self.y > bnds.btm then
                    self.y = bnds.btm
                    self.dy = 0

                    if rnd(1) < .01 then
                        self.dy = -1 - rnd(1)
                        self.ani_spd = .5                    
                    end 
                end 


            end,
        },

        octopus = {
            e_type = "octopus",
            hp       = 2,
            beg_spr  = 60,
            end_spr  = 63,
            h        = 7,
            w        = 7,
            g        = 0,
            dx       = 0.5,
            ani_spd  = .1,
            spwn_y   = 35,
            init     = function(self) 
                self.a = 20                   --amplitutde
                self.b = rnd(.005) + rnd(.01) --period 
                self.c = rnd(1)               --phase shift
                self.d = self.spwn_y          --vertical shift
            end,
            update = function(self) 
                self.x -= self.dx

                --y = amp * sin(period * (x + phase)) + shift
                self.y = self.a * sin(self.b * (_f + self.c)) + self.d
            end,
        },
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
        tbl = self.enemies,
        type = 'enemy',
        e_type = e.e_type,
        x       = args.x,
        y       = args.y or e.spwn_y,
        spwn_y  = e.spwn_y,
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
        init    = e.init,
        ani_spd = e.ani_spd,
        ani_t   = e.ani_t,
        cooldown= e.cooldown,
        fire_r  = e.fire_r
    })

    if  e.init then  new_e:init(new_e) end
    add(self.enemies, new_e)
end

function enemy_mgr:update()
    for e in all(self.enemies) do
        e:cleanup() 
        e:update()
      
        --animations
        e.spr += e.ani_spd
        if e.spr >= e.end_spr + 1 then e.spr = e.beg_spr end

        --collisions
        if coll(e, p1) then
            p1:take_dmg(1)

            if p1.boost then
                e:take_dmg(3)
            end
        end

       
        --death
        if e.hp <= 0 then 
            e:die()
        end

        --flashing when taking dmg
        if e.flash then
            e.flash -= 1
            if e.flash < 0 then
                e.flash = nil
            end
        end

    end
end

function enemy_mgr:draw()
    for e in all(self.enemies) do
        if e.flash then
            for i=0,15 do pal(i, 7) end
            spr(e.spr,e.x,e.y)
            pal()
        else
            spr(e.spr, e.x, e.y)
        end
    end
end