function main()
    local self
    self = { }
    self.name = "Test Map"
    self.tiles = {
    {"black",false}, -- First argument is filename, second is solidity
    {{{0,1,2,3,4,5,6,7,8},4/30,"hopes"},false},
    {"hopes/topcut",true},
    {"hopes/leftcut",true},
    {"hopes/bottomcut",true},
    {"hopes/rightcut",true},
    {"hopes/topleftcut",true},
    {"hopes/bottomleftcut",true},
    {"hopes/toprightcut",true},
    {"hopes/bottomrightcut",true}
    }
    -- Maps should be atleast 16x12
    self.map = {
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,3,3,3,3,3,3,3,3},
        {1,1,1,1,1,1,1,1,1,4,2,2,2,2,2,2,2,2},
        {3,3,3,3,3,3,3,3,3,10,2,2,2,2,2,2,2,2},
        {2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2},
        {2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2},
        {5,5,5,5,5,5,5,5,5,9,2,2,2,2,2,2,2,2},
        {1,1,1,1,1,1,1,1,1,4,2,2,2,2,2,2,2,2},
        {1,1,1,1,1,1,1,1,1,1,5,5,5,5,5,5,5,5},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
    }
    -- Map size should be the amount of tiles horizontally * 40 and vertically * 40, though
    -- this is really just for the camera, so make it whatever.
    -- Uncomment this to set it manually:
    -- self.size = {640,480}
    self.size = {#self.map[1]*40,#self.map*40}
    self.events = {
        {"tree",{116+120-112,364+220-96}},
        {"tree",{90+120-112,120-96}},
        {"tree",{516,394-112+240}},
        {"tree",{556-112,80-96}},
        {"sign",{200,400}},
        {"musictext",{400-217,500-17}}
    }
    self.scenes = {"testscene"}
    self.outline = "mapfade"
    function self.Update()
    end
    return self
end

return main()