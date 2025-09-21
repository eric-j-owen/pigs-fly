function _init()
    testfx = PartFx:new({amt=10})
    testfx:add_p({r=4, y=rnd(100)})

end

function _update60()
    game_update()
    testfx:update() 
end

function _draw()
    game_draw()

    testfx:draw()

end