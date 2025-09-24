--sprites
local SPR_IDL = 1
local SPR_SIDE = 2
local SPR_DWN = 3
local SPR_UP = 4
local SPR_FALL = 5
local SPR_DWN_TURN = 6


p1 = Entity:new({
    type     = 'player',
    x        = 64,
    y        = 64,
    spr      = nil,
    h        = 8,
    w        = 8,
    max_dx   = 0.75,
    max_dy   = 0.75,
    g        = 0.03,  --gravity
    f        = 0.85,  --friction
    acc      = 1,     --acceleration
    hp       = 6,     --hit points
    cooldown = 0,     -- timer 
    fire_r   = 15,    --fire rate, frames between shots
    god_t    = 0,     --invulnerability timer
    flash_t  =0,      --flash sprite
})

function p1:update()
    local s = self

    --map boundries
    bounds = level_mgr.levels[level_mgr.curr_lvl].bounds

    --shooting 
    if btn(BTN.X) and self.cooldown <= 0 then
        bullet_mgr:shoot('player', {x=s.x, y=s.y})
        s.cooldown = s.fire_r
    else
        s.cooldown -= 1 
    end

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
    
    local isFalling = s.dy > 0 and not down and s.y < bounds.btm

    s.dy += s.g --gravity
    s.dx *= s.f --friction
   
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

    --spawn jet fx
    if get_state() == GAME.MAIN then
        --offsets for adjusting effect origin based on player direction
        local off_y = s.dy < 0 and 8 or 0
        local off_x = s.dx < 0 and 8 or 0

        -- --flip direction of effect based on player y direction 
        local dir_y = .5
        if s.dy > 0 then dir_y *= -1 end
        
        if isFalling or s.y == bounds.btm then
            fx_mgr:spawn("jet_idle", {x = s.x+3, y = s.y+4})
        elseif left and not isFalling then
            fx_mgr:spawn("jet_thrust", {x = s.x + off_x, y = s.y + off_y, dy = dir_y})
        elseif right then
            fx_mgr:spawn("jet_thrust", {x = s.x, y = s.y + off_y, dy = dir_y})
        elseif up then
            fx_mgr:spawn("jet_thrust", {x = s.x + 3.5, y = s.y + 10, dy = dir_y})
        elseif down then
            fx_mgr:spawn("jet_thrust", {x = s.x + 3.5, y = s.y - 4, dy = dir_y})
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
    if isFalling or s.y >= bounds.btm then
        s.spr = SPR_FALL
    end

    --clamp movement speed
    s.dx = mid(-s.max_dx, s.dx, s.max_dx)            --general x axis speed clamp
    if p1.dy<0 then 
        s.dy = mid(-s.max_dy, s.dy, s.max_dy)        --general y axis speed clamp
    elseif isFalling then 
        s.dy = mid(-s.max_dy, s.dy, s.max_dy - 0.5)  --speed when floating down
    elseif down then                                 --speed when jet pack thrust down
         s.dy = mid(-s.max_dy, s.dy, s.max_dy + .3)
    end
   
    --apply movement to coordinates
    s.x += s.dx
    s.y += s.dy

    --screen collisions
    if s.y > bounds.btm then s.y = bounds.btm s.dy = 0 end
    if s.y < bounds.top then s.y = bounds.top end
    if s.x > bounds.right then s.x = bounds.right end
    if s.x < bounds.left  then s.x = bounds.left end
end

function p1:draw()
    --flip x sprite for left and right directions 
    local invert = self.dx < 0

    --flash effect
    --every 3 frames skips 3 frames, remainder loops 0 to 6
    if self.god_t > 0 and (self.flash_t % 6 < 3) then
        return --skip drawing sprite
    end
    spr(self.spr, self.x, self.y, 1, 1, invert)
end

