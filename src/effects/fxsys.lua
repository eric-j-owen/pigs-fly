fx_sys = {
    parts = {},
    fx = {
        jet_thrust = {
            amt     =10, 
            sprd    =3,
            c       = 7,
            c_tbl   = {7,10,9,8,5},
            dy      = .5,
            grow    = true,
        },

        jet_idle = {
            amt     = 1, 
            sprd    = 1,
            c       = 7,
            c_tbl   = {7,6,5,5},
            dy      = -.35,
        },
    }
}


function fx_sys.spawn(name,args)
    local eff = fx_sys.fx[name]
    if not eff then return end

    --include any args passed into object
    local a = {}
    for k,v in pairs(eff) do a[k] = v end
    for k,v in pairs(args) do a[k] = v end
    
    --create particles
    for i=1,a.amt do
        if name == "jet_thrust" then
            a.dx = rnd(.5)-.25
            a.die = 5+rnd(20)
        end

        if name == "jet_idle" then
            a.dx = (rnd(4)-2) * .08
            a.die = rnd(30) + 10
        end
        

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
        
        add(fx_sys.parts, p )
    end
end


function fx_sys.update()
    for p in all(fx_sys.parts) do
        p:update()
        if p.t > p.die then
            del(fx_sys.parts, p)
        end
    end
end

function fx_sys.draw()
   for p in all(fx_sys.parts) do
        p:draw()
   end
end
