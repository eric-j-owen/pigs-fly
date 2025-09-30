--sprites

local def_spr = {
    IDL = 1,
    SIDE = 2,
    DWN = 3,
    UP = 4,
    FALL = 5,
    DWN_TURN = 6,
}

local alt_spr = {
    SIDE = 50,
    DWN = 51,
    UP = 52,
    FALL = 53,
    DWN_TURN = 54,
}


local function get_spr()
    if level_mgr.curr_lvl == 3 then
        return alt_spr
    else
        return def_spr
    end
end


Player = Entity:new()


function Player:init() 
    
   local p = Player:new({
        type       = 'player',
        x          = 64,
        y          = 64,
        spr        = nil,
        h          = 8,
        w          = 8,
        max_dx     = 0.75,
        max_dy     = 0.75,
        g          = 0.03,  --gravity
        f          = 0.85,  --friction
        acc        = 1,     --acceleration
        max_hp     = 10,    
        cooldown   = 0,     -- timer 
        fire_r     = 7,    --fire rate, frames between shots
        god_t      = 0,     --invulnerability timer
  
        boost_t    = 0,        --boost timer 
        boost_max  = 60,    --maximum boost
        boost_mult = 2,     -- boost multiplier
        boost      = false,
    })

    p.hp = p.max_hp    -- current hit points
    return p
end

function Player:update()
    local s = self

    --map boundries
    local spr = get_spr()

    local lvl = level_mgr.levels[level_mgr.curr_lvl]
    if not lvl then return end
    bnds = lvl.bounds

    --taking dmg
    if s.god_t > 0 then
        s.god_t -= 1
    end

    if self.hp > self.max_hp then
        self.hp = self.max_hp
    end

    --directions
    local up = btn(BTN.UP)
    local down = btn(BTN.DOWN)
    local left = btn(BTN.LEFT)
    local right = btn(BTN.RIGHT)
    
    local isFalling = s.dy > 0 and not down and s.y < bnds.btm

    s.dy += s.g --gravity
    s.dx *= s.f --friction


      --shooting 
    if btn(BTN.X) and self.cooldown <= 0 then
        bullet_mgr:shoot('player', {x=s.x+9, y=s.y+2})
        s.cooldown = s.fire_r
    else
        s.cooldown -= 1 
    end

    --input
    if up then 
        s.dy -= s.acc 
        s.spr = spr.UP
    end

    if down then 
        s.dy += s.acc
        s.spr = spr.DWN
    end

    if left then 
        s.dx -= s.acc 
        s.spr = spr.SIDE

    end

    if right then 
        s.dx += s.acc 
        s.spr = spr.SIDE
    end


    --boosting
    s.boost = false
    if btn(BTN.O) and s.boost_t > 0 then
        s.boost = true
        s.boost_t -= 1
    elseif not btn(BTN.O) and s.boost_t < s.boost_max then
        s.boost_t += .5 
    end
    --fixes ui issue of boost_t getting below 0
    if s.boost_t < 0 then s.boost_t = 0 end

    --spawn jet fx
    if get_state() == GAME.MAIN then

        --offsets for adjusting effect origin based on player direction
        local off_y = s.dy < 0 and 8 or 0
        local off_x = s.dx < 0 and 8 or 0

        -- --flip direction of effect based on player y direction 
        local dir_y = .5
        if s.dy > 0 then dir_y *= -1 end
        
        local fx_a = { x = s.x, y = s.y, dy = dir_y} --fx args

        --boost effect overrides
        if s.boost then
            fx_a.rnd_mod = 10
            fx_a.shrink = false
            fx_a.grow = true
            fx_a.r = 1.5
            fx_a.c_tbl = {7,10,9,8,5}
        end
        
        if isFalling or s.y == bnds.btm then
            fx_a.x += 3
            fx_a.y += 4
            fx_mgr:spawn("jet_idle", fx_a)
        elseif left and not isFalling then
            fx_a.x += off_x
            fx_a.y += off_y
            fx_mgr:spawn("jet_thrust", fx_a)
        elseif right then
            fx_a.y += off_y
            fx_mgr:spawn("jet_thrust", fx_a)
        elseif up then
            fx_a.x += 3.5
            fx_a.y += 10
            fx_mgr:spawn("jet_thrust", fx_a)
        elseif down then
            fx_a.x += 3.5
            fx_a.y -= 4
            fx_mgr:spawn("jet_thrust", fx_a)
        end
    end
    
    --turning while flying down
    if s.dy > 0.25 then
        if left or right then
            s.spr = spr.DWN_TURN
        else
            s.spr = spr.DWN --reset
        end
    end

    -- falling sprite
    if isFalling or s.y >= bnds.btm then
        s.spr = spr.FALL
    end

 
    local max_spd_x = s.max_dx * (s.boost and s.boost_mult or 1) 
    local max_spd_y = s.max_dy * (s.boost and s.boost_mult or 1)

    --clamp movement speed
    s.dx = mid(-max_spd_x, s.dx, max_spd_x)            --general x axis speed clamp
    if s.dy<0 then 
        s.dy = mid(-max_spd_y, s.dy, max_spd_y)        --general y axis speed clamp
    elseif isFalling then 
        s.dy = mid(-max_spd_y, s.dy, max_spd_y - 0.5)  --speed when floating down
    elseif down then                                 --speed when jet pack thrust down
        s.dy = mid(-max_spd_y, s.dy, max_spd_y + .3)
    end

    --apply movement to coordinates
    s.x += s.dx
    s.y += s.dy

    --screen collisions
    if s.y > bnds.btm then s.y = bnds.btm s.dy = 0 end
    if s.y < bnds.top then s.y = bnds.top end
    if s.x > bnds.right then s.x = bnds.right end
    if s.x < bnds.left  then s.x = bnds.left end
end

function Player:draw()
    --flip x sprite for left and right directions 
    local invert = self.dx < 0

    --flash effect
    --every 3 frames skips 3 frames, remainder loops 0 to 6
    if self.god_t > 0 and (_f % 6 < 3) then
        return --skip drawing sprite
    end
    spr(self.spr, self.x, self.y, 1, 1, invert)
end


