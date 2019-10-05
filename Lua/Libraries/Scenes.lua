return (function()
    local self
    self = { }
    self.name = "Scenes"
    self.current = false
    self.timer = 0
    self.timergoal = 0
    self.timerscene = false
    self.startedtimer = false
    function self.Delay(delay,scene)
        self.timergoal = delay
        self.timer = 0
        self.timerscene = scene
        self.startedtimer = true
    end
    function self.Trigger(scene,index)
        if index == nil then
            index = 1
        end
        self.loadscene(scene)
        self.current.HandleScene(index)
    end
    function self.Retrigger(index)
        if index == nil then
            index = 1
        end
        self.current.HandleScene(index)
    end
    function self.loadscene(scene)
        self.current = dofile(GetModName() .. "/Lua/Scenes/" .. scene .. ".lua")
    end
    function self.Stop()
        self.current = false
    end
    function self.Update()
        if self.startedtimer then
            if self.timer >= self.timergoal then
                self.Retrigger(self.timerscene+1)
                self.startedtimer = false
                self.timer = 0
                self.timergoal = 0
            else
                self.timer = self.timer + 1
            end
        end
    end
    return self 
end)()