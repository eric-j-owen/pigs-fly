level_mgr = {
    levels = {},
    curr_lvl = 1,
    
    nxt_lvl = function(self)
        set_state(GAME.TRANSITION)
        self.curr_lvl += 1 
    end,

}

Level = {
    e_types    = {"chicken"},  --array of enemy types
    lvl_tmr    = 60,  --time left in level
    spwn_tmr   = 5,   --timer to next spawn
    spwn_delay = 60,  --added to spwn timer, decreases as level progresses 
    frms       = 0,   --frame counter
    max_e      = 1,   --max enmies on screen, increases as level progresses
    e_x        = 0,   --enemy spawns x , y 
    e_y        = 0,
    update_lvl = function(self)
        local s = self
        s.frms += 1 
        s.spwn_tmr -= 1

        if s.spwn_tmr <= 0 and #enemy_mgr.enemies < s.max_e then
            
            local rnd_i = flr(rnd(#s.e_types)) + 1
            local e = s.e_types[rnd_i]
            enemy_mgr:spawn(e, {x=s.e_x, y=s.e_y})

            local t = s.lvl_tmr / 60
            s.spwn_delay = max(15, 30*t)
            s.spwn_tmr = max(10,flr(rnd(120))) + s.spwn_delay
        end

         --increment max enemies on screen every 5 seconds
        if s.frms % 300 == 0 then
            s.max_e += 1
        end

        --increment timer every second
        if s.frms % 60 == 0 then
            s.lvl_tmr -= 1
        end

        --next level
        if s.lvl_tmr <= 0 then
            level_mgr:nxt_lvl()
        end
    end
}

function Level:new(o)
    o = o or {}
    setmetatable(o, { __index = self })    
    return o
end

--level 1
level_mgr.levels[1] = Level:new({
    frnt_x     = 0,           --front layer x position
    sky_x      = 0,           -- sky layer x posistion
    back_x     = 0,           -- back layer x posistion
    e_types    = {"chicken"},
    e_x        = 130,
    e_y        = 105,

    update = function(self)
        --map
        self.back_x -= .5
        self.sky_x -= .25
        self.frnt_x -= .75

        if self.back_x < -127 then self.back_x = 0 end
        if self.sky_x < -127 then self.sky_x = 0 end
        if self.frnt_x < -127 then self.frnt_x = 0 end

        self:update_lvl()
        
    end,

    draw = function(self) 
        cls(13)
        print("max e " .. self.max_e, 10,15,8)
        print("spwn delay " .. self.spwn_delay, 10,20,9)
        print("lvl timer " .. self.lvl_tmr, 10,30,10)

        circfill(24,82,8,9)

        --map scrolling logic
        --background
        map(16,9,self.back_x,64,16,4)
        map(16,9,128+self.back_x,64,16,4)

        --sky layer
        map(17,0,self.sky_x,0,16,9)
        map(17,0,128+self.sky_x,0,16,9)
        --foreground layer
        map(0,0,self.frnt_x,0,16,16)
        map(0,0,128+self.frnt_x,0,16,16)
    end,
   
    --transition to next level

})



--level 2
level_mgr.levels[2] = Level:new({

    update = function(self)
        self:update_lvl()
    end,

    draw = function(self) 
       cprnt('level 2')
    end,
})