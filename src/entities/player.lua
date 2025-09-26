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
        type     = 'player',
        x        = 64,
        y        = 64,
        spr      = SPR_IDL,
        h        = 8,
        w        = 8,
        max_dx   = 0.75,
        max_dy   = 0.75,
        g        = 0.03,  --gravity
        f        = 0.85,  --friction
        acc      = 1,     --acceleration
        hp       = 10,     --hit points
        cooldown = 0,     -- timer 
        fire_r   = 8,    --fire rate, frames between shots
        god_t    = 0,     --invulnerability timer
        flash_t  =0,      --flash sprite
    })
end

function Player:update()
    local s = self

    --map boundries
    bnds = level_mgr.levels[level_mgr.curr_lvl].bounds



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
    
    local isFalling = s.dy > 0 and not down and s.y < bnds.btm

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
        
        if isFalling or s.y == bnds.btm then
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
    if isFalling or s.y >= bnds.btm then
        s.spr = SPR_FALL
    end

    --clamp movement speed
    s.dx = mid(-s.max_dx, s.dx, s.max_dx)            --general x axis speed clamp
    if s.dy<0 then 
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

