local curr_state = nil
local lvl_data = nil
local curr_lvl = nil



local function main_init()
end

local function main_update() 
    p1:update()
    fx_sys:update()
end

local function main_draw() 
    cls(0)
    fx_sys:draw()
    p1:draw()
    
    rectfill(0,0,127,9,0)
    cprnt('pigs fly', 0)
end



function get_state()
    return curr_state
end

function set_state(new_state)
    curr_state = new_state
    if new_state == GAME.MAIN then main_init() end
end

function game_update() 
    if curr_state == GAME.MAIN then main_update() end
end

function game_draw() 
    if curr_state == GAME.MAIN then main_draw() end
end