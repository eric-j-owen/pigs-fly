enemy_mgr = {
    enemies = {},

    types = {
        chicken = {
            e_type  = 'chicken',
            hp       = 3,
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
            sprites  = {60,61,62,63},
            h        = 5,
            w        = 4,
            g        = 0,
            dx       = 0.5,
            ani_spd  = .1,
            spwn_y   = 35,
            init     = function(self) 
                --values for random movement
                self.a = 20                   --amplitutde
                self.b = rnd(.005) + rnd(.01) --period 
                self.c = rnd(1)               --phase shift
                self.d = self.spwn_y          --vertical shift
            end,
       
        },

        bomber = {
            e_type = "bomber",
            hp       = 8,
            sprites  = {40,42},
            h        = 13,
            w        = 14,
            spr_w   = 2,
            spr_h   = 2,
            g        = 0,
            dx       = 0.25,
            ani_spd  = .08,
            spwn_y   = 20,
            fire_r   = 60,
            init     = function(self) 
                --values for random movement
                self.a = 5                  --amplitutde
                self.b = rnd(.008) + rnd(.01) --period 
                self.c = rnd(1)               --phase shift
                self.d = self.spwn_y          --vertical shift
            end,
        },
        alien = {
            e_type = "alien",

        },
        jeff = {
            e_type = "jeff",

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
    })

    if  e.init then  new_e:init(new_e) end
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
            spr(e.spr,e.x,e.y, e.spr_w, e.spr_h)
            pal()
        else
            spr(e.spr, e.x, e.y,e.spr_w, e.spr_h)
        end
    end
end