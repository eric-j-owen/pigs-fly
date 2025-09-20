--sprites
local SPR_IDL = 1
local SPR_SIDE = 2
local SPR_DWN = 3
local SPR_UP = 4
local SPR_FALL = 5
local SPR_DWN_TURN = 6


p = Entity:new({
    x      = 64,
    y      = 64,
    spr    = SPR_IDL,
    acc    = 1,
    max_dx = .75,
    max_dy = .75,
    f      = 0.85,
    g      = 0.03,
})

function p:update()
    local s = self
    log(s.dy)

    --directions
    local up = btn(BTN_UP)
    local down = btn(BTN_DOWN)
    local left = btn(BTN_LEFT)
    local right = btn(BTN_RIGHT)

    s.dy += s.g --gravity
    s.dx *= s.f --friction
   
    --input
    if up then 
        s.dy -= p.acc 
        s.spr = SPR_UP
    end

    if down then 
        p.dy += p.acc
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
    
    --turning while flying down
    if s.dy > 0.25 then
        if left or right then
            s.spr = SPR_DWN_TURN
        else
            s.spr = SPR_DWN --reset
        end
    end

    -- falling sprite
    if s.dy > 0 and not down then
        s.spr = SPR_FALL
    end

    --clamp movement speed
    s.dx = mid(-s.max_dx, s.dx, s.max_dx)
    if btn(BTN_DOWN) then
        s.dy = mid(-s.max_dy, s.dy, s.max_dy)
    else
        s.dy = mid(-s.max_dy, s.dy, s.max_dy - 0.5) --adjusts the falling speed
    end
    

    --apply movement to coordinates
    s.x += s.dx
    s.y += s.dy


    --screen collisions
    if s.y > 120 then 
        s.y = 120 
        s.dy = 0 
        s.spr = SPR_IDL 
    end
    if s.y < 0 then s.y = 0 end
    if s.x > 122 then s.x = 122 end
    if s.x < 0  then s.x = 0 end
end

function p:draw()
    --flip x sprite for left and right directions 
    local flip = self.dx < 0

    spr(self.spr, self.x, self.y, 1, 1, flip)
end