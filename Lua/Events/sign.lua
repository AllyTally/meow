function main()
    local self
    self = { }
    self.name = "Sign" -- The event name. Possibly unneeded? Leave this in for future things.
    self.speed = 2
    self.hitboxwidth = 0
    self.hitboxheight = 0
    self.sprite = "sign"
    function self.OnLoad(map) end
    function self.OnInteract(dir)
        if dir == 1 then
            Scenes.Trigger("testscene")
        end
    end
    function self.Update() end
    return self -- Don't remove this line
end
return main() -- Don't remove this line