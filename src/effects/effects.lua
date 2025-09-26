fx_mgr = {
    parts = {},
    fx = {
        jet_thrust = {
            amt     = 5, 
            sprd    = 1,
            c_tbl   = {7,12,12,12,5},
            dy      = .5,
            shrink    = true,
            rate   = .2,
            r=2.5,
            init = function(p)
                p.dx = rnd(.5)-.25
                p.die = rnd(10)
            end,
        },

        jet_idle = {
            amt     = 1, 
            sprd    = 1,
            c_tbl   = {5,5,5},
            dy      = -.35,
            r       = 2,
            shrink  = true,

            init = function(p)
                p.dx = (rnd(4)-2) * .05
                p.dy = (rnd(4)-2) * .05
                p.die = rnd(10) + 10
            end
        },

        explode = {
            amt   = 20,
            sprd  = 8,
            r     =10,
            c_tbl = {7,10,9,8,2,5},
            shrink  = true,
            rate  = .5,
            grav  = true,
            init = function(p)
                p.dx = rnd(2) -1
                p.dy = rnd(2) - 2
                p.die = rnd(50) + 15
            end
        },
        hit_mark = {
            amt = 1,
            sprd = 1,
            c_tbl = {6},
            grav = true,
            die = 60,
            init = function(p)
                p.dx = rnd(2) -1
                p.dy = -1
            end
        },
        muzz_flash = {},
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
            c_tbl  = a.c_tbl or {},  --list of colors
            t      = 0,              --frame counter
            die    = a.die or 30,     --life span of particle 
            dx     = a.dx or 0,      
            dy     = a.dy or 0,      
            grav   = a.grav or false,  
            grow   = a.grow or false,  
            shrink = a.shrink or false, 
            rate = a.rate or .1, 
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
