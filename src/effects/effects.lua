fx_mgr = {
    parts = {},
    fx = {
        jet_thrust = {
            amt     = 5, 
            sprd    = 2,
            c       = 7,
            c_tbl   = {7,10,9,8,5},
            dy      = .5,
            grow    = true,
            init = function(p)
                p.dx = rnd(.5)-.25
                p.die = 10+rnd(15)
            end,
        },

        jet_idle = {
            amt     = 1, 
            sprd    = 1,
            c       = 5,
            c_tbl   = {5,5,5},
            dy      = -.35,
            r       = 2,
            shrink  = true,

            init = function(p)
                p.dx = (rnd(4)-2) * .05
                p.dy = (rnd(4)-2) * .05
                p.die = rnd(30) + 30
            end
        },
    }
}


function fx_mgr:spawn(type,args)
    local t = self.fx[type]
    if not t then return end
    
    --include any args passed into spawn function
    local a = {}
    for k,v in pairs(t) do
        if k ~= "init" then a[k] = v end
    end
    for k,v in pairs(args) do a[k] = v end
    
    --create particles
    for i=1,a.amt do
        local p = Particle:new({
            x      = a.x + rnd(a.sprd) - a.sprd / 2,
            y      = a.y + rnd(a.sprd) - a.sprd / 2,
            r      = a.r or 1,       --radius
            c      = a.c or 7,       --color
            c_tbl  = a.c_tbl or {},  --list of colors
            t      = 0,              --frame counter
            die    = a.die or 0,
            dx     = a.dx or 0,      
            dy     = a.dy or 0,      
            grav   = a.grav or false,  
            grow   = a.grow or false,  
            shrink = a.shrink or false,  
        })
        
        --calls init for dynamic variables that need to be reinitialized every iteration
        if t.init then t.init(p) end
        
        add(fx_mgr.parts, p )
    end
end


function fx_mgr:update()
    for p in all(self.parts) do
        p:update()
        if p.t > p.die then
            del(self.parts, p)
        end
    end
end

function fx_mgr:draw()
   for p in all(self.parts) do
        p:draw()
   end
end
