_f = 0 --global frame counter
local curr_state = GAME.START

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
end

local function reset_game() 
    _f = 0
    p1 = Player:init()

    enemy_mgr.enemies = {}
    bullet_mgr.bullets = {}
    fx_mgr.effects = {}

end

local function transition_update()
    transition_t -= 1

    if transition_t <= 0 then
        set_state(GAME.MAIN)
    end
end

local function transition_draw()
    cprnt("beginning level "..level_mgr.curr_lvl, 54)
    cprnt(transition_t)
end



function get_state()
    return curr_state
end

function set_state(new_state)
    --reset state transition timer
    transition_t = 120

    --fade music
    music(-1, 1000) 
   
    
    log("changing state from "..curr_state.." to "..new_state)
    curr_state = new_state

    
    local s = get_state()
    if s == GAME.START then 
    elseif s == GAME.MAIN then 
        reset_game()
    elseif s == GAME.TRANSITION then
    elseif s == GAME.OVER then 
        music(0,0,3)
    elseif s == GAME.WIN then
    end 
end

function game_update() 
    local s = get_state()
    if s == GAME.START then
        if btnp(BTN.X) then 
            set_state(GAME.TRANSITION) 
        end
    elseif s == GAME.MAIN then
        main_update()
    elseif s == GAME.TRANSITION then
        transition_update()
    elseif s == GAME.OVER then
        p1:update()
        if btnp(BTN.X) then 
            set_state(GAME.TRANSITION) 
        end
    elseif s == GAME.WIN then
    
    end 
end

function game_draw() 
    cls(0)

    local s = get_state()
    if s == GAME.START then
        cprnt("pigs fly", 50)
        cprnt("PRESS x TO START", 70)
    elseif s == GAME.MAIN then
        main_draw()
    elseif s == GAME.TRANSITION then
        transition_draw()
    elseif s == GAME.OVER then
        cprnt('game over', 50)
        cprnt("PRESS x TO TRY AGAIN", 70)
        p1:draw()
    elseif s == GAME.WIN then
    
    end 
end