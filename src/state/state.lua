


local function main_init()
    curr_lvl = level_mgr.curr_lvl
end

local function main_update() 
    level_mgr.levels[curr_lvl]:update()
    bullet_mgr:update()
    fx_mgr:update()
    p1:update()
end

local function main_draw() 
    cls(0)

    level_mgr.levels[curr_lvl]:draw()
    bullet_mgr:draw()
    fx_mgr:draw()
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