Entity = {
    container = nil,
    x      = 0,
    y      = 0,
    spr    = nil,  --sprite
    w      = 0,    --pixel width
    h      = 0,    --pixel height
    spr_w  = 1,    --sprite width 1 = 1 tile
    spr_h  = 1,    --sprite height 1 = 1 tile 
    dx     = 0,    --change in x
    dy     = 0,    --change in y
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
        self.state = E_STATE.UNDER_ATK
    end

    self.hp -= dmg
    fx_mgr:spawn('hit_mark',{x=self.x,y=self.y})
end

function Entity:die()
    if self.type == 'enemy' then
        fx_mgr:spawn("explode", {x=self.x + (self.w / 2), y=self.y + (self.h /2)})
        score += self.pts

        --spawn pickups 10% of the time 
        if rnd(1) < .2 then
            pickup_mgr:spawn(self.x,self.y)
        end
    end
    del(self.tbl, self)
end

function Entity:cleanup()
    if self.x < -10 or self.x > 150 or self.y < -10 or self.y > 130 then
        del(self.tbl, self)
    end
end