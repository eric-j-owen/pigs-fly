levels = {
    --map data
    --enemy data
    --win condition
    --transition
}

levels[1] = {
    map_x = 0,
    max_spd = 1,

    inc_x = function(self)
        self.map_x -= self.max_spd
        if self.map_x < -127 then self.map_x = 0 end
    end,

    draw = function(self) 
        cls(13)
        circfill(24,82,8,9)

        --map scrolling logic
        map(0,0,self.map_x,0,16,16)
        map(0,0,128+self.map_x,0,16,16)
    end

    --spawn enemies
    --how to win
    --transition to next level

}

levels[2] = {}
levels[3] = {}
