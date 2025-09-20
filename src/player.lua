--sprites
local SPR_IDL = 1
local SPR_SIDE = 2
local SPR_UP1 = 3
local SPR_UP2 = 4
local SPR_DWN = 5

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
    s.dy += s.g --gravity
    s.dx *= s.f --friction
   
    --input
    

    if btn(BTN_UP) then 
        s.dy -= p.acc 
        s.spr = SPR_UP2
    end

    if btn(BTN_DOWN) then 
        p.dy += p.acc 
        s.spr = SPR_DWN
    end

    if btn(BTN_LEFT) then 
        s.dx -= s.acc 
        s.spr = SPR_SIDE
    end

    if btn(BTN_RIGHT) then 
        s.dx += s.acc 
        s.spr = SPR_SIDE
    end
    
    if s.dy > 0 then
        s.spr = SPR_DWN
    end

    --clamp movement speed
    s.dx = mid(-s.max_dx, s.dx, s.max_dx)
    s.dy = mid(-s.max_dy, s.dy, s.max_dy - 0.35) --.35 adjusts the falling speed
    

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
    local flip = self.dx < 0 and true or false

    spr(self.spr, self.x, self.y, 1, 1, flip)
end