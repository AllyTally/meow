return (function()
    local self
    self = { }
    self.attached = {}
    self.x = 0
    self.y = 0
    function self.Update()
        self.UpdateCamera()
    end
    function self.MoveTo(x,y)
        self.x = x
        self.y = y
        self.UpdateCamera()
    end
    function self.MoveXTo(x)
        self.x = x
        self.UpdateCamera()
    end
    function self.MoveYTo(y)
        self.y = y
        self.UpdateCamera()
    end
    function self.UpdateCamera()
        Misc.MoveCameraTo(self.x,self.y)
        for i = 1, #self.attached do
            if self.attached[i] ~= nil then
                if (self.attached[i][1].isactive) then
                    self.attached[i][1].MoveToAbs(self.x+self.attached[i][2],self.y+self.attached[i][3])
                else
                    self.Detach(self.attached[i][1])
                end
            end
        end
    end
    function self.Attach(sprite,x,y)
        table.insert(self.attached,{sprite,x,y})
    end
    function self.MoveAttachedTo(sprite,x,y)
        for i,v in pairs(self.attached) do
            if v[1] == sprite then
                self.attached[i][2] = x
                self.attached[i][3] = y
            end
        end
    end
    function self.MoveAttached(sprite,x,y)
        for i,v in pairs(self.attached) do
            if v[1] == sprite then
                self.attached[i][2] = self.attached[i][2]+x
                self.attached[i][3] = self.attached[i][3]+y
            end
        end
    end
    function self.Detach(sprite)
        for i,v in pairs(self.attached) do
            if v[1] == sprite then
                table.remove(self.attached,i)
            end
        end
    end
    return self 
end)()