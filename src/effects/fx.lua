Fx = {
    jet_thrust = nil,
    jet_idle   = nil
}

function Fx:init()
    self.jet_thrust = PartEffect:new({ amt = 10, spread = 3})
    self.jet_idle   = PartEffect:new({ amt = 1, spread = 4})
end

function Fx:update()
    if self.jet_thrust then
        self.jet_thrust:update()
    end
end

function Fx:draw()
    if self.jet_thrust then
        self.jet_thrust:draw()
    end
end

function Fx:spawn_parts(eff,x,y,r, c_tbl, die, dx,dy,grav,grow,shrink)
    local s = self
    for i=1,eff.amt do
        eff:add_p({
            x      = x + rnd(eff.spread) - eff.spread / 2,
            y      = y + rnd(eff.spread) - eff.spread / 2,
            r      = r or 0,      
            c_tbl  = c_tbl or {},     
            t      = 0,      
            die    = die or 0,     
            dx     = dx or 0,      
            dy     = dy or 0,      
            grav   = grav or false,  
            grow   = grow or false,  
            shrink = shrink or false,  
        })
    end
end

