Behavior = {}

--helpers
function sin_move(e)
    --y = amp * sin(period * (x + phase)) + shift
    e.y = e.a * sin(e.b * (_f * e.c)) + e.d
end

function e_shoot(e, b_type, params)
    e.cooldown -= 1
    if e.cooldown <= 0 then
        bullet_mgr:shoot(b_type, params)
        e.cooldown = e.fire_r

        if b_type == 'laser' then
            fx_mgr:spawn("muzz_flash", {x=e.x, y=e.y+2,dx=-3, c_tbl={7,11}})
        end
    end
end

--enemies
function Behavior:chicken()
    bnds = level_mgr.levels[level_mgr.curr_lvl].bounds

    self.dy += self.g
    
    self.x -= self.dx
    self.y += self.dy
    
    --fall speed clamp to give floating feel
    if self.dy > 0 then 
        self.dy = mid(0,self.dy, .4)
    end

    --shoot if in air at a certain height OR if player is under between 2 bounds
    if (self.dy < 0 and self.y < 70) or (p1.x >= self.x-8 and p1.x <= self.x+8) then
            e_shoot(self,'egg', { x = self.x+2, y = self.y, dx = 0, dy = 1})
    end
    
        --collision ground 
    if self.y > bnds.btm then
        self.y = bnds.btm
        self.dy = 0

        --random high jump logic
        if rnd(1) < .01 then
            self.dy = -1 - rnd(1)
            self.ani_spd = .5                    
        end 
    end 

    --hops if taking dmg
    if self.under_atk then
        self.dy = -1
        self.under_atk = false
    end
end

function Behavior:octopus()
    self.x -= self.dx
    sin_move(self)
end

function Behavior:alien()
    self.x -= self.dx
    sin_move(self)

    if self.x <=120 then
        e_shoot(self,'laser', {x=self.x, y=self.y+3})
    end
end
   
function Behavior:bomber()
    --movement
    self.x -= self.dx
    sin_move(self)

    --fx
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

    --attack
    e_shoot(self, "bomb",{x=self.x+2, y=self.y+10})
 
end


function Behavior:jeff()
    local s = self

    --consts
    local POS_TOP = 20
    local POS_BTM = 100

    --general movement
    s.x -= s.dx
    s.y -= s.dy
    
    --stages
    --entrance
    if s.state == 'init' then
        s.idle_t = 0 --wait timer 

        --move onto screen
        if s.x > 110 then 
            s.dx = 1
        else 
            --reaches initial position
            s.dx = 0
            s.state = 'idle'
            s.idle_t = 180

            --initial random choice of top or bottom corner
            if rnd(1) < .5 then
                s.target_y = POS_TOP
            else    
                s.target_y = POS_BTM
            end
        end

    elseif s.state == 'idle' then
        sin_move(s) --idle movement
        s.idle_t -= 1

        --attack
        e_shoot(self, "laser", { x=s.x, y=s.y})

        --change state
        if s.idle_t <= 0 then s.state = 'move' end

    --move to either top or bottom corner
    elseif s.state == 'move' then

        --if close to target        
        if abs(s.y - s.target_y) > 2 then
            if s.y <= s.target_y then
                s.dy = -1
            else
                s.dy = 1
            end 

        --reaches target
        else 
            s.dy = 0
            s.d = s.target_y --updates shift value for sin_move
            s.idle_t = 180
            s.state = 'idle'

            --flips target to opposite corner
            if s.target_y < 50 then
                s.target_y = POS_BTM
            else    
                s.target_y = POS_TOP
            end
        end 
    end

end

function Behavior:boss()
end