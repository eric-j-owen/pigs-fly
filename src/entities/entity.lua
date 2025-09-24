Entity = {
    x      = 0,
    y      = 0,
    spr    = nil,  --sprite
    w      = 0,    --width
    h      = 0,    --height
    dx     = 0,    --change in x
    dy     = 0,    --change in y

    --animation
    beg_spr  = 0,
    end_spr  = 0,
    ani_t    = 0,  --animation timer
    ani_spd  = 1,  
}

--constructor
function Entity:new(o)
    o = o or {}
    setmetatable(o, { __index = self })
    return o
end


function Entity:take_dmg(dmg)
    if self.type == 'player' then
        if self.god_t > 0 then return end
        self.god_t = 120
    end
    self.hp -= dmg
end