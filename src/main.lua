function _init()
    log('clear', true)

    
    fire = PartEffect:new({amt=2, spread=4})
end

function _update60()
    game_update()

     fire:update()

    if btn(BTN.DOWN) then 
        for i=1,fire.amt do
            fire:add_p({
                x      = p1.x + rnd(fire.spread) - fire.spread / 2,
                y      = p1.y + rnd(fire.spread) - fire.spread / 2,
                r      = 3,      
                c      = 7,      
                c_tbl  = {12,5,5,5},     
                t      = 0,      
                die    = 40,     
                dx     = 0,      
                dy     = -0.5,      
                grav   = false,  
                grow   = false,  
                shrink = true,  
            })
        end
    end
end

function _draw()
    game_draw()
    fire:draw()
end