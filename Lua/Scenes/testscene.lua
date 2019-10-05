function main()
    local self
    self = { }
    self.name = "testscene" -- The scene name, make sure this is also the filename.
    if hecker == nil then
        hecker = 0
    end
    function self.HandleScene(scene)
        if hecker == 10 then
            if scene == 1 then
                Audio.Stop()
                Audio.PlaySound("hurtsound")
                Misc.ShakeScreen(10,3,true)
                OWUI.CreateTextboxScene({"[noskip]* Okay, you can stop now."},scene,0)
            end
            if scene == 2 then
                Scenes.Stop()
                hecker = 11
            end
        elseif (hecker > 10) and (hecker < 30) then
            if scene == 1 then
                hecker = hecker + 1
                Audio.PlaySound("hurtsound")
                Misc.ShakeScreen(10,hecker-10,true)
                Scenes.Stop()
            end
        elseif hecker == 30 then
            if scene == 1 then
                Audio.PlaySound("hurtsound")
                black = CreateSprite("black","SuperTop")
                OWCamera.Attach(black,320,240)
                Audio.LoadFile("AUDIO_DARKNESS")
                Scenes.Delay(4166,scene)
            end
            if scene == 2 then
                Scenes.Stop()
                hecker = 2000
                Misc.DestroyWindow()
            end
        elseif hecker ~= 2000 then
            if scene == 1 then
                OWUI.CreateTextboxScene({"* (Enemies ahead! You're gonna\n  die!)\n* (SIGNED, LANCER)"},scene,0)
            end
            if scene == 2 then
                hecker = hecker + 1
                Scenes.Stop()
            end
        end
    end
    function self.Update() end
    return self -- Don't remove this line
end
return main() -- Don't remove this line