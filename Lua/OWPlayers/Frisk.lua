function main()
    local self
    self = { }
    self.name = "Frisk" -- The player name. Used for the bottom bar gui.
    self.folder = "frisk" -- The folder the sprites are in
    self.x = 40 -- The position you want the player to start at.
    self.y = 350 -- The position you want the player to start at.
    self.size = {1, 1} -- The player's size.
    self.speed = 2
    self.hitboxwidth = 22
    self.hitboxheight = 22
    self.color = { 1, 0, 0 }
    self.animations = {
        IdleLeft  =  {  { 0          }, 0  ,{12,29} },
        IdleRight =  {  { 0          }, 0  ,{12,29} },
        IdleUp    =  {  { 0          }, 0  ,{12,29} }, 
        IdleDown  =  {  { 0          }, 0  ,{12,29} },
        WalkLeft  =  {  { 0, 1, 2, 1 }, 10 ,{12,29} },
        WalkRight =  {  { 0, 1, 2, 1 }, 10 ,{12,29} },
        WalkUp    =  {  { 0, 1, 2, 1 }, 10 ,{12,29} },
        WalkDown  =  {  { 0, 1, 2, 1 }, 10 ,{12,29} },
    }
    function self.Update() -- This is a little [hold x to run] thing I made quickly.
    end
    return self -- Don't remove this line
end

return main() -- Don't remove this line

