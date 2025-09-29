level_mgr = {
    levels = {},
    curr_lvl = 1,
    curr_stg = 1,
    nxt_lvl = function(self)
        set_state(GAME.TRANSITION)
        self.curr_stg += 1
        if self.curr_stg > 2 then
            self.curr_stg = 1
            self.curr_lvl += 1
        end
    end,

}

Level = {
    bounds       = {top=0,right=127,btm=127,left=0},--level boundries
    e_types      = {},     --array of enemy types
    lvl_dur      = 0,      --level total duration
    lvl_t        = 0,      --level timer
    spwn_tmr     = 5,      --timer to next spawn
    max_e        = 1,      --max enmies for level
    curr_max_e   = 1,
    reset_lvl  = function(self)
        self.lvl_t = 0
        self.curr_max_e = 1
        
        enemy_mgr.enemies = {}
        bullet_mgr.bullets = {}
        fx_mgr.effects = {}
    end,

    update_lvl = function(self)
        local s = self

        s.spwn_tmr -= 1

        if s.spwn_tmr <= 0 and #enemy_mgr.enemies < s.curr_max_e then
            
            --select random enemy
            local rnd_i = flr(rnd(#s.e_types)) + 1
            local e_type = s.e_types[rnd_i]   --string of enemy name

            --spawn faster as level progresses
            enemy_mgr:spawn(e_type, {x=140})
            s.spwn_tmr = rnd(60)
        end

         --increment current max enemies on screen every 5 seconds
        if _f % 300 == 0 and s.curr_max_e < s.max_e then
            s.curr_max_e += 1
        end

        --increment level timer every second
        if _f % 60 == 0 then
            s.lvl_t += 1
        end

        --next level reset
        if s.lvl_t >= s.lvl_dur then
            s:reset_lvl()
            level_mgr:nxt_lvl()
        end
    end,

}

function Level:new(o)
    o = o or {}
    setmetatable(o, { __index = self })    
    return o
end

--level 1
level_mgr.levels[1] = Level:new({
    bounds     = {top=10, right=120, btm=105, left=0},
    e_types    = {"chicken"},
    lvl_dur    = 5,
    max_e      = 10,  
    --map
    frnt_x     = 0,--front layer x position
    sky_x      = 0,-- sky layer x posistion
    back_x     = 0,-- back layer x posistion
    
    update = function(self)
        if level_mgr.curr_stg == 2 then
            self.e_types = { "chicken","octopus"}
        end
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
        if level_mgr.curr_stg == 1 then
            cls(12)
            circfill(19,50,8,10) --sun
        else
            cls(13)
            circfill(24,82,8,9) --sun
        end
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
})


--level 2
level_mgr.levels[2] = Level:new({
    lvl_dur = 5,
    update = function(self)
        self:update_lvl()
    end,

    draw = function(self) 
       cprnt('level 2')
    end,
})

--boss
level_mgr.levels[3] = Level:new({
    update = function(self)
        self:update_lvl()
    end,

    draw = function(self) 
       cprnt('boss approaching')
    end,
})