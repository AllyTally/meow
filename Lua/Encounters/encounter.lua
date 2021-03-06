-- A basic overworld script skeleton you can copy and modify for your own creations.

music = "field_of_hopes" -- The music you want to load!

enemies = { "poseur" } -- Populate this with enemies your encounters need!
-- Note that encounters do require a bit of changing, since the enemies table is never read more than
-- once. You can get around this by filling in the enemies table above, and calling SetActive in your
-- enemy encounter!

function OverworldStarting()
    -- Do something here! This is called after the Overworld module is initialized.
    Overworld.usingpurple = false
    Overworld.deltarune   = false
end

function Update()
    --  The Update() function! This gets ran every frame.
	if Input.GetKey("G") == 1 then
		Overworld.StartCYF("Encounters/Encounter Skeleton")
	end
    OWCamera.Update()
    OWUI.Update()
    Scenes.Update()
    Overworld.Update()
end

maps = {"Test"} -- The maps to load! Leave out the .lua extension.

startmap = 1 -- This is the map that gets loaded first. Use Overworld.gotoroom() to switch to a
             -- different one!

players = {"Frisk"} -- The party. Currently only the first one is used. Party support soon, maybe?

function OnHit(bullet) -- Since we can't replace Player.Hurt(), we have to use a different function.
    if not Player.isHurting then
        Overworld.Hurt(10)
    end
end


Pre          = require("Libraries/PreOverworld" )  -- Required for the overworld library
OWCamera     = require("Libraries/OWCamera"     )  -- Required for the overworld library
OWUI         = require("Libraries/OWUI"         )  -- Required for the overworld library
Scenes       = require("Libraries/Scenes"       )  -- Required for the overworld library
OverrideDone = require("Libraries/OverrideDone" )  -- Required for the overworld library
Overworld    = require("Libraries/Overworld"    )  -- The overworld library