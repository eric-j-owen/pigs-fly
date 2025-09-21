Particle = {
    x      = 64,
    y      = 64,
    r      = 1,      --radius
    c      = 7,      --color
    c_tbl  = {},     --list of colors
    t      = 0,      --frame counter
    die    = 60,     --life limit in frames
    dx     = 0,      --change in x
    dy     = 0,      --change in y
    grav   = false,  --gravity
    grow   = false,  --particle size grows
    shrink = false,  --particle size shrinks
    fade   = false,  --set opacity based on t/die
}

function Particle:new(o)
    o = o or {}
    setmetatable(o, { __index = self })
    return o
end

function Particle:update()
    local s = self

    --life cycle
    s.t += 1
    
    --color changing
    if     s.t/s.die < 1/#s.c_tbl then s.c = s.c_tbl[1] 
    elseif s.t/s.die < 2/#s.c_tbl then s.c = s.c_tbl[2]
    elseif s.t/s.die < 3/#s.c_tbl then s.c = s.c_tbl[3]
    elseif s.t/s.die < 4/#s.c_tbl then s.c = s.c_tbl[4]
    else   s.c = s.c_tbl[5]
    end

    
    
    --physics
    if s.grav then s.dy += .5 end
    if s.grow then s.r += .1 end
    if s.shrink then s.r -= .06 end

    --move
    s.x += s.dx
    s.y += s.dy
end

function Particle:draw()
    if self.r <= 1 then
        pset(self.x, self.y, self.c)
    else
        circfill(self.x, self.y, self.r, self.c)
    end
end
