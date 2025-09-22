Entity = {
    x      = 0,
    y      = 0,
    spr    = nil,  --sprite
    w      = 0,    --width
    h      = 0,    --height
    dx     = 0,    --change in x
    dy     = 0,    --change in y
}

--constructor
function Entity:new(o)
    o = o or {}
    setmetatable(o, { __index = self })
    return o
end