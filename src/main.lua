function _init()
    log('clear', true)
    set_state(GAME.MAIN)
    -- music(0,0,3)
end

function _update60()
    game_update()

end

function _draw()
    game_draw()
end