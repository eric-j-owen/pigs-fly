level_mgr = {
    levels = {},
    curr_lvl = 2,
    curr_stg = 2,
    nxt_lvl = function(self)
        self.curr_stg += 1
        if self.curr_stg > 2 then
            self.curr_stg = 1
            self.curr_lvl += 1
        end
        
        if self.curr_lvl > 3 then
            set_state(GAME.WIN)
        else
            set_state(GAME.TRANSITION)
        end
    end,

}

Level = {
    bounds       = {top=10,right=120,btm=120,left=0},--level boundries
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
        fx_mgr.parts = {}
        pickup_mgr.pickups = {}

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
    lvl_dur    = 60,
    --map
    frnt_x     = 0,--front layer x position
    sky_x      = 0,-- sky layer x posistion
    back_x     = 0,-- back layer x posistion
    
    update = function(self)
        --stage presets
        if level_mgr.curr_stg == 1 then
            self.e_types = { "chicken"}
            self.max_e = 5
        else 
            self.e_types = { "chicken","octopus"}
            self.max_e = 10
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


        cprnt(#enemy_mgr.enemies)

    end,
})


--level 2
level_mgr.levels[2] = Level:new({
    lvl_dur = 60,
    e_types    = {"octopus"},
     --map
    frnt_x     = 0,
    mid_x      = 0,
    back_x     = 0,
   
    
    update = function(self)
        self:update_lvl()

        self.back_x -= .25
        self.mid_x -= .5
        self.frnt_x -= .75

        if self.back_x < -127 then self.back_x = 0 end
        if self.mid_x < -127 then self.mid_x = 0 end
        if self.frnt_x < -127 then self.frnt_x = 0 end
       
    end,

    draw = function(self) 
        if level_mgr.curr_stg == 1 then
            cls(13)
            circfill(19,50,8,6) --moon
        else
            cls(1)
           
            circfill(24,40,8,7) --moon

            map(0,24,0,10,15,15) --stars
        end


        --map scrolling logic
        --background
        map(0,16,self.back_x,24,15,8)
        map(0,16,128+self.back_x,24,15,8)

        --mid layer
        map(14,16,self.mid_x,32,10,8)
        map(14,16,128+self.mid_x,32,10,8)

        
    
    end,

    draw_front = function(self)
            --foreground layer
        map(27,16,self.frnt_x,40,15,24)
        map(27,16,128+self.frnt_x,40,15,24)
    end,
})

--boss
level_mgr.levels[3] = Level:new({
    lvl_dur = 60,
    e_types    = {"octopus"},

    update = function(self)
        self:update_lvl()

        --starfield
        if _f % 30 == 0 then fx_mgr:spawn('stars_far') end
        if _f % 40 == 0 then fx_mgr:spawn('stars_mid') end
        if _f % 50 == 0 then fx_mgr:spawn('stars_close') end
    end,

    draw = function(self) 
    end,
})