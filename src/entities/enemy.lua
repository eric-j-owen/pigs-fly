enemy_mgr = {
    enemies = {},

    types = {
        chicken = {
            e_type  = 'chicken',
            hp       = 3,
            pts      = 10,
            sprites  = {44,45,46,47},
            h        = 6,
            w        = 5,
            g        = 0.03,
            dy       = 0,
            dx       = 0.5,
            cooldown = 0,      
            fire_r   = 60,
            ani_spd  = .15,
            spwn_y   = 105,
        },

        octopus = {
            e_type = "octopus",
            hp       = 2,
            pts      = 5,
            sprites  = {60,61,62,63},
            h        = 5,
            w        = 4,
            g        = 0,
            dx       = 0.5,
            ani_spd  = .1,
            spwn_y   = 35,
            init     = function(self) 
                self.a = 20                  
                self.b = rnd(.005) + rnd(.01) 
                self.c = 1           
                self.d = self.spwn_y          
            end,
       
        },

        bomber = {
            e_type = "bomber",
            hp       = 8,
            pts      = 20,
            sprites  = {40,42},
            h        = 13,
            w        = 14,
            spr_w   = 2,
            spr_h   = 2,
            g        = 0,
            dx       = 0.25,
            ani_spd  = .08,
            spwn_y   = 20,
            cooldown = 0,      
            fire_r   = 120,
            init     = function(self) 
                self.a = 5                 
                self.b = rnd(.008) + rnd(.01) 
                self.c = 1             
                self.d = self.spwn_y        
            end,
        },
        alien = {
            e_type = "alien",
            hp     = 2,
            pts    = 12,
            sprites= {28,29,30,31},
            h      = 8,
            w      = 8,
            spr_w  = 1,
            spr_h  = 1,
            dx       = 0.5,
            ani_spd  = .1,
            spwn_y   = 80,
            cooldown = 60,      
            fire_r   = 180,
            init     = function(self) 
                self.a = 20                  
                self.b = rnd(.005) + rnd(.01)  
                self.c = rnd(1.5)               
                self.d = self.spwn_y        
            end,
        },
        jeff = {
            e_type = "jeff",
            state  = "init",
            hp     = 20,
            sprites= {8,10},
            pts    = 100,
            h      = 16,
            w      = 16,
            spr_w  = 2,
            spr_h  = 2,
            spwn_y = 64,
            dx = .5,
            ani_spd  = .1,
            cooldown = 60,      
            fire_r   = 180,
            init     = function(self) 
                self.a = 2                  
                self.b = .015
                self.c = 20000            
                self.d = self.spwn_y        
            end,
        },
        
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
        init    = e.init,
        state   = e.state,
        tbl     = self.enemies,
        type    = 'enemy',
        e_type  = e.e_type,
        x       = args.x,
        y       = args.y or e.spwn_y,
        spwn_y  = e.spwn_y,
        h       = e.h,
        w       = e.w,
        hp      = e.hp,
        dx      = e.dx,
        dy      = e.dy,
        g       = e.g,
        behavior= Behavior[e.e_type], --assign behavior function 
        pts     = e.pts,
        
        --animation and sprites
        spr_w   = e.spr_w or 1,
        spr_h   = e.spr_h or 1,
        spr     = e.sprites[1],     --current sprite
        sprites = e.sprites,        --animation frames
        ani_i   = 1,                --animation index 
        ani_spd = e.ani_spd,
        ani_t   = e.ani_t,

        --shooting
        cooldown= e.cooldown,
        fire_r  = e.fire_r,
        rammed  = false,
    })

    if  e.init then  new_e:init(new_e) end

    --update spawn location for level 2
    if level_mgr.curr_lvl == 2 and e.e_type == 'octopus' then
        e.spwn_y = 90
    end

    add(self.enemies, new_e)
end

function enemy_mgr:update()
    for e in all(self.enemies) do
        e:cleanup() 
        e:behavior()
      
        --animations
        e.ani_i += e.ani_spd
        if e.ani_i > #e.sprites + 1 then e.ani_i = 1 end
        e.spr = e.sprites[flr(e.ani_i)]

        --collisions
        if coll(e, p1) then
            p1:take_dmg(1)
            --players ram attack, ensures enemy is only hit once per boost
            if p1.boost and not e.rammed then
                e:take_dmg(5)
                e.rammed = true
            end
        end

        --reset ram attack flag
        if not p1.boost then
            for e in all(enemy_mgr.enemies) do
                e.rammed = false
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
        --debugging
        -- rect(e.x, e.y, e.x + e.w, e.y + e.h, 8)

        if e.flash then
            for i=0,15 do pal(i, 7) end
            spr(e.spr,e.x,e.y, e.spr_w, e.spr_h)
            pal()
        else
            spr(e.spr, e.x, e.y,e.spr_w, e.spr_h)
        end
    end
end