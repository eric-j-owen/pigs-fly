PartEffect = {
    parts = {},
    amt     = 1,    --particle amount
    spread  = 1,    
    sfx     = nil   --sound fx
}

function PartEffect:new(o)
    local o = o or {}
    setmetatable(o, { __index = self })
    return o
end

function PartEffect:add_p(params)
    local p = Particle:new(params or {})
    
    add(self.parts, p)
end

function PartEffect:update() 
    for p in all(self.parts) do
        p:update()

        if p.t > p.die then del(self.parts, p) end

        --spread particles at end of life cycle
        if p.t > p.die * .25 then 
            p.x += rnd(2)-1
        end
    end
end

function PartEffect:draw() 
    for p in all(self.parts) do
        p:draw()
    end
end
