ui = {}

function ui:draw()
    rectfill(0,0,127,9,0)
    self.draw_boost_meter(p1)
    self.draw_hp(p1)

    --score
    print("score:"..score,40,2,7)

    self.draw_timer()
end


function ui.draw_hp(p)
    local x, y = 2,0
    local w = 30
    local h = 4

    local hp_w = p.hp / p.max_hp * w

    --bar
    rectfill(x,y,x+hp_w,y+h,8)
    --outline
    rect(x,y,x+w,y+h,7)

end


function ui.draw_boost_meter(p)
    local x, y = 2,4
    local w = 30
    local h = 4
    local boost_w = p.boost_t / p.boost_max * w
   
    --bar
    rectfill(x,y,x+boost_w,y+h,11)
    --outline
    rect(x,y,x+w,y+h,7)
end


function ui.draw_timer()
    local total = level_mgr.levels[level_mgr.curr_lvl].lvl_dur
    local curr = level_mgr.levels[level_mgr.curr_lvl].lvl_t
    local time = total - curr

    print('time:'..time, 95, 2, 7)
end