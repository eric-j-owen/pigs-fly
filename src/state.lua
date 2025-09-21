local curr = GAME.MAIN

function get_state()
    return curr
end

function set_state(new)
    curr = new
end


local function update_main() 
    p1:update()

end

local function draw_main() 
    cls(0)
    cprnt('pigs fly', 0)

    p1:draw()
end

function game_update() 
    if curr == GAME.MAIN then update_main() end
end

function game_draw() 
    if curr == GAME.MAIN then draw_main() end
end