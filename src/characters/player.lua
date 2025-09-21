--sprites
local SPR_IDL = 1
local SPR_SIDE = 2
local SPR_DWN = 3
local SPR_UP = 4
local SPR_FALL = 5
local SPR_DWN_TURN = 6


p1 = Entity:new({
    x      = 64,
    y      = 64,
    spr    = SPR_IDL,
    acc    = 1,
    max_dx = .75,
    max_dy = .75,
    f      = 0.85,
    g      = 0.03,
})

function p1:update()
    local s = self

    --directions
    local up = btn(BTN.UP)
    local down = btn(BTN.DOWN)
    local left = btn(BTN.LEFT)
    local right = btn(BTN.RIGHT)
    local isFalling = s.dy > 0 and not down

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
    local clrs = {7,10,9,8,5}
    local die = 15+rnd(7)
    local off_y = s.dy < 0 and 8 or 0
    local off_x = s.dx < 0 and 8 or 0
    -- spawn_parts(eff,x,y,r, c_tbl, die, dx,dy,grav,grow,shrink)
    if isFalling then
        Fx:spawn_parts(Fx.jet_idle, p1.x+4,p1.y,.5, {5},5+rnd(20), rnd(.5)-.25,-.5)
    elseif left then
        Fx:spawn_parts(Fx.jet_thrust, p1.x+off_x,p1.y+off_y,1.5,clrs,die, rnd(.5)-.25,-.5)
    elseif right then
        Fx:spawn_parts(Fx.jet_thrust, p1.x+off_x,p1.y+off_y,1.5,clrs,die, rnd(.5)-.25,-.5)
    elseif up then
        Fx:spawn_parts(Fx.jet_thrust, p1.x+3,p1.y+10,1.5,clrs,die, rnd(.5)-.25,.5)
    elseif down then
        Fx:spawn_parts(Fx.jet_thrust, p1.x+3,p1.y-4,1.5,clrs,die, rnd(.5)-.25,-.5)

    else
        Fx:spawn_parts(Fx.jet_idle, p1.x+4,p1.y+4,.5, {5},5+rnd(20), rnd(1)-.5,.2)
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
    if isFalling then
        s.spr = SPR_FALL
    end

    --clamp movement speed
    s.dx = mid(-s.max_dx, s.dx, s.max_dx)
    if down then
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

function p1:draw()
    --flip x sprite for left and right directions 
    local invert = self.dx < 0

    spr(self.spr, self.x, self.y, 1, 1, invert)
end