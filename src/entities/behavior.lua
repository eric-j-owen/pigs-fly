Behavior = {}

function Behavior:chicken()
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

    --hops if taking dmg
    if self.state == E_STATE.UNDER_ATK then
        self.dy = -1
        self.state = E_STATE.DEFAULT
    end
end

function Behavior:octopus()
    self.x -= self.dx
    sin_move(self)
end

function Behavior:bomber()
    self.x -= self.dx
    sin_move(self)

    fx_mgr:spawn('jet_thrust', 
    {
        x=self.x+3, 
        y= self.y+14, 
        c_tbl={7,12,12,5}, 
        r=2,
        dx=-2,
        rnd_mod=8,
        amt=1,    
    })
    fx_mgr:spawn('jet_thrust', 
    {
        x=self.x+11, 
        y= self.y+14,
        dx=-10,

        c_tbl={7,12,12,5}, 
        r=2,
        rnd_mod=8,
        amt=1,    
    })

end


function sin_move(e)
    --y = amp * sin(period * (x + phase)) + shift
    e.y = e.a * sin(e.b * (_f + e.c)) + e.d
end