pickup_mgr = {
    pickups = {}
}

Pickup = Entity:new({
    w=8,
    h=8,
    tbl = pickup_mgr.pickups
})


function Pickup:update()
    --collision
    if coll(self, p1) then
        if not self.eaten then 
            fx_mgr:spawn('ripple', {x=self.x, y=self.y})
            if p1.hp < p1.max_hp then
                p1.hp += 1
            else
                score += 5
            end
            self.dy = .5
            self.eaten = true
        end
    end
            
    --movement
    if not self.eaten then
        self.dx = .5
        self.x -= self.dx
        self.y = self.y + (.3 * sin(_f + self.x/25))
    
        --spawn effects
        if _f % 3 == 0 then
            fx_mgr:spawn('sparkle',{x=self.x+3,y=self.y+2})
        end
    end

    self.y += self.dy
end

function Pickup:draw()
    if self.eaten then
        spr(17,self.x,self.y)
    else
        spr(16,self.x,self.y)
    end
end


function pickup_mgr:update() 
    for p in all(self.pickups) do
        p:update()
        p:cleanup()

    end
end

function pickup_mgr:draw()
    for p in all(self.pickups) do
        p:draw()
    end
end

function pickup_mgr:spawn(x,y)
    add(self.pickups, Pickup:new({x = x, y = y}))
end