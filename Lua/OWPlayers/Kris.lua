function main()
    local self
    self = { }
    self.name = "Kris" -- The player name. Used for the bottom bar gui.
    self.folder = "kris" -- The folder the sprites are in
    self.x = 40 -- The position you want the player to start at.
    self.y = 350 -- The position you want the player to start at.
    self.namesprite = "face"
    self.speed = 2
    self.hitboxwidth = 30
    self.hitboxheight = 22
    self.size = {2,2}
    Player.SetMaxHPShift(90,1.7,true,true) -- set kris' max hp to 90
    Player.hp = 90
    self.color = { 0, 1, 1 }
    self.animations = {
        IdleLeft  =  {  { 0          }, 0  ,{19,38} },
        IdleRight =  {  { 0          }, 0  ,{19,38} },
        IdleUp    =  {  { 0          }, 0  ,{19,38} }, 
        IdleDown  =  {  { 0          }, 0  ,{19,38} },
        WalkLeft  =  {  { 1, 2, 3, 0 }, 10 ,{19,38} },
        WalkRight =  {  { 1, 2, 3, 0 }, 10 ,{19,38} },
        WalkUp    =  {  { 1, 2, 3, 0 }, 10 ,{19,38} },
        WalkDown  =  {  { 1, 2, 3, 0 }, 10 ,{19,38} },
        f         =  {  { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 }, 10 ,{19,38} },
    }
    function self.Update() -- This is a little [hold x to run] thing I made quickly.
        if Input.Cancel > 0 then
            if self.speed < 4 then
                self.speed = self.speed + 0.2
            end
            self.animations["WalkLeft"][2] = 5
            self.animations["WalkRight"][2] = 5
            self.animations["WalkUp"][2] = 5
            self.animations["WalkDown"][2] = 5
        else
            self.speed = 2
            self.animations["WalkLeft"][2] = 10
            self.animations["WalkRight"][2] = 10
            self.animations["WalkUp"][2] = 10
            self.animations["WalkDown"][2] = 10
        end
    end
    return self -- Don't remove this line
end

return main() -- Don't remove this line

