function _init()
    log('init')
end

function _update60()
    p:update()
end

function _draw()
    cls(0)
    cprnt('pigs fly', 0)
    p:draw()
end