function main()
    local self
    self = { }
    self.name = "MusicText" -- The event name. Possibly unneeded? Leave this in for future things.
    self.speed = 2
    self.hitboxwidth = 0
    self.hitboxheight = 0
    self.sprite = "musictext"
    self.xspeed = 4
    self.alpha = 0
    self.state = 0
    self.siner = 0
    self.offx = 0
    self.timer = 0
    function self.OnLoad(map)
    end
    function self.Update()
        self.timer = self.timer + 1
        if self.timer%2 == 0 then
            self.siner = self.siner + 1
            if (self.siner <= 30) then
                self.offx = (self.offx + (2 - (self.siner / 15)))
                self.sprite.x = 400-self.offx-217
                if (self.alpha < 1) then
                    self.alpha = (self.alpha + 0.05)
                end
            end
            if (self.siner >= 120) then
                self.offx = (self.offx + (-8 + (self.siner / 15)))
                self.sprite.x = 400-self.offx-217
                self.alpha = (self.alpha - 0.0333333333333333)
                if (self.alpha <= 0) then
                    --self.Destroy()
                end
            end
        end
        self.sprite.alpha = self.alpha
    end
    return self -- Don't remove this line
end

return main() -- Don't remove this line

