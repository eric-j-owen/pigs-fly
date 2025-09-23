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
            update = function(self) 
                self.dy += self.g
                
                self.x -= self.dx
                self.y += self.dy

                --collision ground 
                if self.y > 105 then
                    self.y = 105
                    self.dy = 0
                end 
            end,
        },
        bug = {},
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
        x = args.x,
        y = args.y,
        hp = e.hp,
        spr = e.beg_spr,
        dx = e.dx,
        dy = e.dy,
        g = e.g,
        cooldown = e.cooldown,
        update = e.update,
    })

    add(self.enemies, new_e)
end

function enemy_mgr:update()
    for e in all(self.enemies) do
        e:update()
        if e.x < -10 or e.x > 130 or e.y < -10 or e.y > 130 then
            del(self.enemies, e)
        end
    end
end

function enemy_mgr:draw()
    print(#enemy_mgr.enemies, 10, 10, 7)
    for e in all(self.enemies) do
        spr(e.spr, e.x, e.y)
    end
end