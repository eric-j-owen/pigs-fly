pickup_mgr = {
    pickups = {}
}

Pickup = Entity:new({
    w=8,
    h=8
})


function Pickup:update()
    --collision
    if coll(self, p1) then
        del(pickup_mgr.pickups, self)
        fx_mgr:spawn('ripple', {x=self.x, y=self.y})
        if p1.hp < p1.max_hp then
            p1.hp += 1
        else
            score += 5
        end
    end
            
    --movement
    self.dx = .5
    self.x -= self.dx
    self.y = self.y + (.3 * sin(_f + self.x/25))

    --spawn effects
    if _f % 10 == 0 then
        fx_mgr:spawn('sparkle',{x=self.x+3,y=self.y+1})
    end
end

function Pickup:draw()
    spr(16,self.x,self.y)
end


function pickup_mgr:update() 
    for p in all(self.pickups) do
        p:update()
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