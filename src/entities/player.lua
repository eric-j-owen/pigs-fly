--sprites
local SPR_IDL = 1
local SPR_SIDE = 2
local SPR_DWN = 3
local SPR_UP = 4
local SPR_FALL = 5
local SPR_DWN_TURN = 6


Player = Entity:new()


function Player:init() 
    
   return Player:new({
        type       = 'player',
        x          = 64,
        y          = 64,
        spr        = SPR_IDL,
        h          = 8,
        w          = 8,
        max_dx     = 0.75,
        max_dy     = 0.75,
        g          = 0.03,  --gravity
        f          = 0.85,  --friction
        acc        = 1,     --acceleration
        hp         = 10,     --hit points
        cooldown   = 0,     -- timer 
        fire_r     = 8,    --fire rate, frames between shots
        god_t      = 0,     --invulnerability timer
        flash_t    = 0,      --flash sprite
  
        boost_t    = 0,        --boost timer 
        boost_max  = 60,    --maximum boost
        boost_mult = 2,     -- boost multiplier
    })
end

function Player:update()
    local s = self

    --map boundries
    bnds = level_mgr.levels[level_mgr.curr_lvl].bounds

    --taking dmg
    if s.god_t > 0 then
        s.god_t -= 1
        s.flash_t += 1
    else
        s.flash_t = 0
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
        bullet_mgr:shoot('player', {x=s.x, y=s.y})
        s.cooldown = s.fire_r
    else
        s.cooldown -= 1 
    end

    --input
    if up then 
        s.dy -= s.acc 
        s.spr = SPR_UP
    end

    if down then 
        s.dy += s.acc
        s.spr = SPR_DWN
    end

    if left then 
        s.dx -= s.acc 
        s.spr = SPR_SIDE

    end

    if right then 
        s.dx += s.acc 
        s.spr = SPR_SIDE
    end


    --boosting
    local boost = false
    if btn(BTN.O) and s.boost_t > 0 then
        boost = true
        s.boost_t -= 1
    elseif not btn(BTN.O) and s.boost_t < s.boost_max then
        s.boost_t += .5 
    end

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
        if boost then
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
            s.spr = SPR_DWN_TURN
        else
            s.spr = SPR_DWN --reset
        end
    end

    -- falling sprite
    if isFalling or s.y >= bnds.btm then
        s.spr = SPR_FALL
    end

 
    local max_spd_x = s.max_dx * (boost and s.boost_mult or 1) 
    local max_spd_y = s.max_dy * (boost and s.boost_mult or 1)

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
    if self.god_t > 0 and (self.flash_t % 6 < 3) then
        return --skip drawing sprite
    end
    spr(self.spr, self.x, self.y, 1, 1, invert)
end


function draw_boost_meter(player)

    local meter_x, meter_y = 4,4
    local meter_w = 30
    local meter_h = 2
    local boost_w = player.boost_t / player.boost_max * meter_w

    --background
    rectfill(meter_x, meter_y, meter_x + meter_w, meter_y + meter_h, 1)
    --boost bar
    rectfill(meter_x, meter_y, meter_x + boost_w, meter_y + meter_h, 11)
    --outline
    rect(meter_x, meter_y, meter_x + meter_w, meter_y + meter_h, 7)

end