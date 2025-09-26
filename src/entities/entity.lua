Entity = {
    container = nil,
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
        
        --reset god timer
        self.god_t = 120

        --die
        if self.hp <= 0 then set_state(GAME.OVER) self.god_t = 0 return end

    else 
        self.flash = 4 --enemy flashing when taking dmg
    end

    --hops if taking dmg
    if self.e_type == 'chicken' then
        self.dy = -1
    end


    self.hp -= dmg
    fx_mgr:spawn('hit_mark',{x=self.x,y=self.y})
end

function Entity:die()
    if self.type == 'enemy' then
        fx_mgr:spawn("explode", {x=self.x, y=self.y})
    end
    del(self.tbl, self)
end

function Entity:cleanup()
    if self.x < -10 or self.x > 150 or self.y < -10 or self.y > 130 then
        del(self.tbl, self)
    end

end