levels = {
    --map data
    --enemy data
    --win condition
    --transition
}

levels[1] = {
    frnt_x = 0, --front layer x position
    sky_x = 0,  -- sky layer x posistion
    back_x = 0,  -- back layer x posistion

    update = function(self) 
        self.back_x -= .5
        self.sky_x -= .25
        self.frnt_x -= .75

        if self.back_x < -127 then self.back_x = 0 end
        if self.sky_x < -127 then self.sky_x = 0 end
        if self.frnt_x < -127 then self.frnt_x = 0 end
    end,

    draw = function(self) 
        cls(13)
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
    end

    --spawn enemies
    --how to win
    --transition to next level

}

levels[2] = {}
levels[3] = {}
