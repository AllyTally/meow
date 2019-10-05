function main()
    local self
    self = { }
    self.name = "movingdoor" -- The event name. Possibly unneeded? Leave this in for future things.
    self.speed = 2
    self.hitboxwidth = 0
    self.hitboxheight = 0
    self.sprite = "door"
    self.timer = 0
    function self.OnLoad(map)
        self.sprite.Scale(2,2)
    end
    function self.OnCollide()
        Overworld.GotoRoom(1,500,200,1)
    end
    function self.Update()
        self.timer = self.timer + 1
        self.sprite.y = 200 + (math.sin(self.timer/20) * 50)
        self.y = 200 + (math.sin(self.timer/20) * 50)
    end
    return self -- Don't remove this line
end

return main() -- Don't remove this line

