function _init()
    log('clear', true)
    set_state(GAME.START)
end

function _update60()
    _f += 1 --global frame counter
    game_update()
end

function _draw()
    game_draw()
end