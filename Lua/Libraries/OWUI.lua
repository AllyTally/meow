return (function()
    local self
    self = { }
    CreateLayer("textb", "Top")
    CreateLayer("text", "textb")
    self.textb = CreateSprite("textbox","textb")
    self.textb.x = 320
    self.textb.y = 85
    OWCamera.Attach(self.textb,320,85)
    self.textb.alpha = 0
    self.watchingscene = false
    self.scenetowatch = 0
    function self.Update()
        if self.to then
            if self.intext then
                if self.to.isactive then
                    self.to.x = Misc.cameraX + 58
                    self.to.y = Misc.cameraY + 114
                else
                    self.intext=false
                    self.textb.alpha = 0
                    if self.watchingscene then
                        self.scenetowatch = self.scenetowatch + 1
                        Scenes.Retrigger(self.scenetowatch)
                        self.scenetowatch = 0
                        self.watchingscene = false
                    end
                    --facesprite.alpha = 0
                end
            end
        end
    end
    function self.CreateTextbox(text,pos)
        if not pos then
            pos = 0
        end
        self.to = CreateText(text,{58,114},999,"text",-1)
        self.to.HideBubble()
        self.to.progressmode = "manual"
        self.to.color = {1,1,1}
        self.to.SetFont("uidialog2")
        OWCamera.Attach(self.to,58,114)
        self.textb.alpha = 1
        self.intext=true
    end
    function self.CreateTextboxScene(text,scene,pos)
        if not pos then
            pos = 0
        end
        self.CreateTextbox(text,pos)
        self.watchingscene = true
        self.scenetowatch = scene
    end
    return self 
end)()