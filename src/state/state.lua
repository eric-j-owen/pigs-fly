local function main_init() end

local function main_update()
    level_mgr.levels[level_mgr.curr_lvl]:update()
    bullet_mgr:update()
    p1:update()
    enemy_mgr:update()
    fx_mgr:update()
end

local function main_draw()
    
    level_mgr.levels[level_mgr.curr_lvl]:draw()
    bullet_mgr:draw()
    enemy_mgr:draw()
    fx_mgr:draw()
    p1:draw()
 
    --ui
    rectfill(0,0,127,9,0)
    cprnt('pigs fly', 0)
end

local transition_t = 300
local function transition_update()
    transition_t -= 1

    if transition_t <= 0 then
        set_state(GAME.MAIN)
    end
end

local function transition_draw()
    cprnt("Beginning level "..level_mgr.curr_lvl, 54)
    cprnt(transition_t)
end



function get_state()
    return curr_state
end

function set_state(new_state)
    transition_t = 300
    curr_state = new_state
end

function game_update() 
    if curr_state == GAME.START then
        if btn(BTN.X) then 
            set_state(GAME.TRANSITION) 
        end
    elseif curr_state == GAME.MAIN then
        main_update()
    elseif curr_state == GAME.TRANSITION then
        transition_update()
    elseif curr_state == GAME.OVER then
    
    elseif curr_state == GAME.WIN then
    
    end 
end

function game_draw() 
    cls(0)

    if curr_state == GAME.START then
        cprnt("PIGS FLY", 50)
        cprnt("PRESS x TO START", 70)
    elseif curr_state == GAME.MAIN then
        main_draw()
    elseif curr_state == GAME.TRANSITION then
        transition_draw()
    elseif curr_state == GAME.OVER then
    
    elseif curr_state == GAME.WIN then
    
    end 
end