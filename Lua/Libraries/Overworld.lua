return (function()
    local self
    self = { }

    if not enemies then
        enemies = { }
    end

    -- Initializes the library
    local _EncounterStarting = EncounterStarting
    function EncounterStarting()
        State("NONE")

        -- Create the layers used in this module
        CreateLayer("OWBackground", "Top")
        CreateLayer("Tiles", "OWBackground")
        CreateLayer("Events", "Tiles")
        CreateLayer("BulletDark", "Events")
        CreateLayer("AboveBulletDark", "BulletDark")
        CreateLayer("Bullet", "AboveBulletDark")
        CreateLayer("UnderSuperTop", "Bullet")
        CreateLayer("SuperTop", "UnderSuperTop")

        -- Table including all bullets on the screen
        bullettable = { }

        -- Replace CreateProjectile and CreateProjectileAbs
        local _CreateProjectile
        _CreateProjectile = CreateProjectile
        function CreateProjectile(sprite, x, y)
            a = _CreateProjectile(sprite, x, y)
            table.insert(bullettable, a)
            return a
        end
        local _CreateProjectileAbs
        _CreateProjectileAbs = CreateProjectileAbs
        function CreateProjectileAbs(sprite, x, y)
            a = _CreateProjectileAbs(sprite, x, y)
            table.insert(bullettable, a)
            return a
        end

        -- Hides CYF
        self.backcover = CreateSprite("black", "OWBackground")
        OWCamera.Attach(self.backcover, 320, 240)

        -- Is the room transitioning?
        self.transtoroom = false
        self.transtoroomdata = false

        -- Are we going to a battle?
        self.transtobattle = false
        self.transtobattletimer = 0
        self.transtobattletype = 0
        self.transfaders = {}

        -- Outline of the map, displayed when the Player is close to a bullet
        self.mapOutline = CreateSprite("px", "AboveBulletDark")
        self.mapOutline.MoveTo(-200,-200)

        self.mapOutline.alpha = 0

        -- Loads the overworld map
        self.currentmap = false
        self.loadmap(startmap)
        self.loadevents(self.currentmap)

        -- Sprite fading out hiding everything but the players and bullets when the Player is close to a bullet
        self.darkenedlayer = CreateSprite("black", "BulletDark")
        self.darkenedlayer.alpha = 0
        self.darkenedlayer.Scale(2, 2)
        self.darkenedlayer.MoveTo(320, 240)
        OWCamera.Attach(self.darkenedlayer, 320, 240)

        self.roomcoverlayer = CreateSprite("black", "SuperTop")
        self.roomcoverlayer.alpha = 0
        self.roomcoverlayer.Scale(2, 2)
        self.roomcoverlayer.MoveTo(320, 240)
        OWCamera.Attach(self.roomcoverlayer, 320, 240)

        self.usingpurple = true

        self.deltarune = true

        self.transfadingin = false

        self.transoverride = true

        self.transdirection = 0

        self.purple = false

        -- Animation timer
        self.ticker = 0

        -- Animation/walking variables, for when the player is walking due to a cutscene
        self.movingplayer = false
        self.walktimer = 0
        self.walkdir = 0
        self.walkscene = 0

        -- pre cy[f/k] variables
        self.precamera = {0,0}

        self.player = { }

        -- If the camera is attached to the player or not
        self.attachedtoplayer = true

        -- Should the engine handle the players animations?
        self.handleanims = true

        -- Call the OverworldStarting function if it exists
        if OverworldStarting then
            OverworldStarting()
        end

        self.SetupFirstPlayer()
        if self.deltarune then
            self.CreateOWPlayerUI()
        end
        if _EncounterStarting then
            _EncounterStarting()
        end
    end

    -- This function handles everything related to the creation of the UI in the overworld
    -- TODO: Add more UI elements for each team member. Possibly use a loop?
    function self.CreateOWPlayerUI()
        -- UI that appears when a bullet is near
        self.bottombar = CreateSprite("bottombar", "AboveBulletDark")

        -- HP bar of the first Player
        self.hpbar = CreateSprite("hpsliver", "AboveBulletDark")
        self.hpbar.SetAnchor(0, 0)
        self.hpbar.SetPivot(0, 0)
        self.hpbar.color = self.player.color

        -- HP text of the first Player
        self.hptext = CreateText("", { 0, 0 }, 999, "AboveBulletDark")
        self.hptext.progressmode = "none"
        self.hptext.HideBubble()

        -- Max HP text of the first Player
        self.maxhptext = CreateText("", { 0, 0 }, 999, "AboveBulletDark")
        self.maxhptext.progressmode = "none"
        self.maxhptext.HideBubble()

        if self.deltarune then
            self.faceui = CreateSprite(self.player.folder .. "/" .. self.player.namesprite, "AboveBulletDark")
        end

        self.uinametext = CreateText("", { 0, 0 }, 999, "AboveBulletDark")
        self.uinametext.progressmode = "none"
        self.uinametext.HideBubble()

        -- This is the starting offset for the bottom health bar
        self.GUIVertOffset = -63

        -- Set this variable to true when you want to make the bottom health bar move
        self.movinggui = false

        self.movingguidown = false
    end

    -- This function loads the first Player and creates some useful variables
    function self.SetupFirstPlayer()
        -- Loads the first Player's entity file
        self.player = dofile(GetModName() .. "/Lua/OWPlayers/" .. players[1] .. ".lua")
        self.player.loaded = true

        -- Creates the first Player's sprite and moves it where it belongs
        self.player.sprite = CreateSprite("/" .. self.player.folder .. "/IdleDown/" .. self.player.animations.IdleDown[1][1], "AboveBulletDark")
        self.player.sprite.x = self.player.x + self.player.animations.IdleDown[3][1]
        self.player.sprite.y = self.player.y + self.player.animations.IdleDown[3][2]
        self.player.sprite.xscale = self.player.size[1]
        self.player.sprite.yscale = self.player.size[2]

        -- Creates the first Player's red sprite that appears when a bullet is near and moves it where it belongs
        if self.usingpurple then
            self.playerred = CreateSprite("/" .. self.player.folder .. "/IdleDownRed/" .. self.player.animations.IdleDown[1][1],"AboveBulletDark")
            self.playerred.x = self.player.x + self.player.animations.IdleDown[3][1]
            self.playerred.y = self.player.y + self.player.animations.IdleDown[3][2]
            self.playerred.xscale = self.player.size[1]
            self.playerred.yscale = self.player.size[2]
            self.playerred.alpha = 0
        end

        -- Creates the first Player's soul that appears when a bullet is near and moves it where it belongs
        self.fakesoul = CreateSprite("outlinedsoul", "AboveBulletDark")
        self.fakesoul.alpha = 0
        self.fakesoul.color = { 1, 0, 0 }

        -- Animation related variables

        -- The current frame of animation in the animation
        self.player.animindex = 1
        -- What animation is currently being played
        self.anim = "IdleDown"
        -- The last animation ran, used for Idle animations
        self.lastanim = 1
        -- If the player is in a battle
        self.inbattle = false
    end

    -- This function handles everything related to the UI's movement
    function self.UpdateUI()
        -- If the UI displaying the Players' HP is moving, move it up
        if self.movinggui then
            if math.floor(self.GUIVertOffset) < 1 then
                self.GUIVertOffset = self.GUIVertOffset + -(self.GUIVertOffset)/6
            else
                self.GUIVertOffset = 0
                self.movinggui = false
            end
        end
        -- If the UI displaying the Players' HP is moving, move it down
        if self.movingguidown then
            self.movinggui = false
            if self.GUIVertOffset > -63 then
                self.GUIVertOffset = self.GUIVertOffset + (self.GUIVertOffset-63)/6
            else
                self.GUIVertOffset = -63
                self.movingguidown = false
            end
        end

        -- Updates the UI's elements
        self.bottombar.y = math.floor(OWCamera.y) + 30 + math.floor(self.GUIVertOffset)
        self.bottombar.x = math.floor(OWCamera.x) + 320
        self.hpbar.y = math.floor(OWCamera.y) + 30 + math.floor(self.GUIVertOffset)
        self.hpbar.x = math.floor(OWCamera.x) + 341
        self.hpbar.xscale = math.floor(((Player.hp/Player.maxhp) * 100) * 0.76)
        self.hptext.x = math.floor(OWCamera.x) + 357
        self.hptext.y = math.floor(OWCamera.y) + 42 + math.floor(self.GUIVertOffset)
        self.maxhptext.x = math.floor(OWCamera.x) + 402
        self.maxhptext.y = math.floor(OWCamera.y) + 42 + math.floor(self.GUIVertOffset)
        self.hptext.SetText("[instant][font:HPFont]" .. Player.hp)
        self.maxhptext.SetText("[instant][font:HPFont]" .. Player.maxhp)
        self.faceui.y = math.floor(OWCamera.y + 39 + self.GUIVertOffset) + 0.1
        self.faceui.x = math.floor(OWCamera.x) + 239
        self.uinametext.SetText("[instant][font:PlayerNameFont][charspacing:2]" .. string.upper(self.player.name))
        self.uinametext.x = math.floor(OWCamera.x) + 264
        self.uinametext.y = math.floor(OWCamera.y) + 32 + math.floor(self.GUIVertOffset)
    end


    function self.PurpleFadeOverride(bool)
        self.transoverride = bool
    end

    function self.ShowPurple()
        self.transdirection = 1
    end

    function self.HidePurple()
        self.transdirection = 0
    end

    function self.UpdateHPChangeTexts()
        for i = #HPChangeTexts, 1, -1 do
            local HPChangeText = HPChangeTexts[i]
            local frame = HPChangeText.frame
            -- Scale the sprites at the beginning of the animation
            if frame <= 8 then
                local xScale = 3 - frame * 0.25
                local yScale = 1 / xScale
                for j = 1, #HPChangeText do
                    HPChangeText[j].x = 20 * (#HPChangeText - j) * xScale
                    HPChangeText[j].Scale(xScale, yScale)
                end
            end

            -- X movement at the beginning of the animation
            if frame < 28 then
                HPChangeText.parent.x = HPChangeText.parent.x + (frame < 12 and 4 or frame < 16 and 2 or frame < 28 and 1)
            end
            -- Y movement at the beginning of the animation
            if frame < 32 then
                HPChangeText.parent.y = HPChangeText.parent.y + (frame < 12 and 1 or frame < 28 and -1 or frame < 32 and -3)

            -- Bounce time
            elseif frame <= 120 and (HPChangeText.yBounce ~= -16 or HPChangeText.yAccel ~= 0) then
                HPChangeText.yBounce = HPChangeText.yBounce + HPChangeText.yAccel
                HPChangeText.yAccel = HPChangeText.yAccel - 0.25
                -- Can't go under 16 pixels below the animation's original position
                if HPChangeText.yBounce < -16 then
                    HPChangeText.yBounce = -16
                    HPChangeText.yAccel = -HPChangeText.yAccel * 1/2
                    -- If the speed is lower than 1, stop the bounce
                    if HPChangeText.yAccel < 1 then
                        HPChangeText.yAccel = 0
                    end
                end
                HPChangeText.parent.absy = HPChangeText.y + HPChangeText.yBounce
            end

            -- Moves the numbers up and fades them
            if frame > 120 then
                HPChangeText.parent.y = HPChangeText.parent.y + 2
                for j = 1, #HPChangeText do
                    HPChangeText[j].yscale = HPChangeText[j].yscale + 1 / 30
                    HPChangeText[j].alpha = 1 - (frame - 120) / 30
                end
            end

            -- The animation has ended, you can remove all the sprites and destroy it
            if frame == 150 then
                for j = 1, #HPChangeText do
                    HPChangeText[j].Remove()
                end
                HPChangeText.parent.Remove()
                table.remove(HPChangeTexts, i)
            end
            HPChangeText.frame = HPChangeText.frame + 1
        end
    end

    function self.UpdateBulletDetection()
        if not self.transoverride then
            for x = 1, #bullettable do
                local cbullet
                local distance
                cbullet = bullettable[x]
                distance = distancebetween({self.player.x,self.player.y},{cbullet.absx,cbullet.absy})
                if distance < 100 then
                    self.transdirection = 1
                else
                    self.transdirection = 0
                end
            end
        end
    end
    -- This function handles everything related to the detection of the mode when the Player is close to a bullet
    function self.UpdateBulletMode()
        -- TODO: Use a bullet zone system instead of checking if the Player is near a bullet
        self.fakesoul.MoveToAbs(Player.absx,Player.absy)
        if self.transdirection == 1 then
            self.purple = true
            if self.darkenedlayer.alpha < 0.6 then
                self.darkenedlayer.alpha = self.darkenedlayer.alpha + 0.02
            end
            if self.usingpurple then
                if self.playerred.alpha < 0.8 then
                    self.playerred.alpha = self.playerred.alpha + 0.04
                end
            end
            if self.fakesoul.alpha < 1 then
                self.fakesoul.alpha = self.fakesoul.alpha + 0.05
                self.mapOutline.alpha = self.mapOutline.alpha + 0.05
            end
        else
            self.purple = false
            if self.darkenedlayer.alpha > 0 then
                self.darkenedlayer.alpha = self.darkenedlayer.alpha - 0.02
            end
            if self.usingpurple then
                if self.playerred.alpha > 0 then
                    self.playerred.alpha = self.playerred.alpha - 0.04
                end
            end
            if self.fakesoul.alpha > 0 then
                self.fakesoul.alpha = self.fakesoul.alpha - 0.05
                self.mapOutline.alpha = self.mapOutline.alpha - 0.05
            end
        end
    end

    -- Updates all of the map's events
    function self.UpdateMapEvents()
        local a, b, x, ev, dir

        dir = string.endswith(self.anim, "Up")   and 1 or
              string.endswith(self.anim, "Down") and 2 or
              string.endswith(self.anim, "Left") and 3 or 4

        a = rect(self.player.x - (dir == 3 and 4 or 0), self.player.x + self.player.sprite.width  + (dir == 4 and 4 or 0),
                 self.player.y - (dir == 2 and 4 or 0), self.player.y + self.player.sprite.height + (dir == 1 and 4 or 0))

        for x = 1, #self.currentmap.events do
            ev = self.currentmap.events[x]
            b = rect(ev.x, ev.x + ev.sprite.width, ev.y, ev.y + ev.sprite.height)
            if isColliding(a, b) then
                if ev.OnCollide then
                    ev.OnCollide(dir)
                end
            end
        end
        for x = 1, #self.currentmap.events do
            self.currentmap.events[x].Update()
        end
    end

    -- Set a custom player animation! Those are always fun, what could go wrong
    function self.SetPlayerAnimation(animindex)
        if not self.handleanims then
            self.anim = animindex
        else
            error("Overworld.OverrideAnimations() was never set before attempting to run a custom animation!")
        end
    end
    -- how do i comment this
    function self.OverrideAnimations(override)
        self.handleanims = not override
    end

    -- Detach the camera from the player
    function self.DetachCamera()
        self.attachedtoplayer = false
    end

    -- Attach the camera to the player
    function self.AttachCamera()
        self.attachedtoplayer = true
    end

    -- Updates the position of the camera
    function self.UpdateCameraMovement()
        local OWCameraX = self.player.x - 320 < 0 and 0 or self.player.x - 320 > self.currentmap.size[1] - 640 and self.currentmap.size[1] - 640 or self.player.x - 320
        local OWCameraY = self.player.y - 240 < 0 and 0 or self.player.y - 240 > self.currentmap.size[2] - 480 and self.currentmap.size[2] - 480 or self.player.y - 240
        OWCamera.MoveTo(OWCameraX, OWCameraY)
    end

    -- Executes the Update() function of the map
    function self.UpdateCurrentMap()
        if not inbattle then
            self.currentmap.Update()
        end
    end

    -- If the Player pressed the Confirm button, this function tries to find the events in front of the Player and interact with them
    function self.ConfirmEventInteraction()
        local a, b, x, ev, dir

        dir = string.endswith(self.anim, "Up")   and 1 or
              string.endswith(self.anim, "Down") and 2 or
              string.endswith(self.anim, "Left") and 3 or 4

        a = rect(self.player.x - (dir == 3 and 4 or 0), self.player.x + self.player.sprite.width  + (dir == 4 and 4 or 0),
                 self.player.y - (dir == 2 and 4 or 0), self.player.y + self.player.sprite.height + (dir == 1 and 4 or 0))

        for x = 1, #self.currentmap.events do
            ev = self.currentmap.events[x]
            b = rect(ev.x, ev.x + ev.sprite.width, ev.y, ev.y + ev.sprite.height)
            if isColliding(a, b) then
                if ev.OnInteract then
                    ev.OnInteract(dir)
                end
            end
        end
    end

    -- Moves the Player around if any directional key is pressed
    function self.InputPlayerMovement()
        if self.player.loaded then
            self.player.Update()
            local xMovement = (Input.Left > 0 and Input.Right > 0) and 0 or Input.Left > 0 and -1 or Input.Right > 0 and 1 or 0
            local yMovement = (Input.Down > 0 and Input.Up    > 0) and 0 or Input.Down > 0 and -1 or Input.Up    > 0 and 1 or 0
            self.MovePlayer(xMovement * self.player.speed, yMovement * self.player.speed)
        end
    end

    -- Updates the Player's movement while the function Overworld.WalkPlayer()'s effect is still active
    function self.UpdateWalkPlayerFunctionMovement()
        if self.player.loaded then
            --self.player.Update()
            if self.movingplayer then
                self.MovePlayer(self.player.speed * (self.walkdir == 3 and -1 or self.walkdir == 4 and 1 or 0),
                                self.player.speed * (self.walkdir == 2 and -1 or self.walkdir == 1 and 1 or 0))
            end
        end
    end

    -- Updates the Player
    function self.UpdatePlayer()
        -- Starts the Player's Idle animation if he isn't moving
        local xMovement = (Input.Left > 0 and Input.Right > 0) and 0 or Input.Left > 0 and -1 or Input.Right > 0 and 1 or 0
        local yMovement = (Input.Down > 0 and Input.Up    > 0) and 0 or Input.Down > 0 and -1 or Input.Up    > 0 and 1 or 0
        if (xMovement == 0 and yMovement == 0) and not self.movingplayer then
            --self.player.animindex = 1
            if self.handleanims then
                local tab = {"IdleUp","IdleDown","IdleLeft","IdleRight"}
                self.anim = tab[self.lastanim+1]
            end
        end

        -- Updates the Player's animation
        self.ticker = self.ticker + 1
        if self.ticker > self.player.animations[self.anim][2] then
            self.ticker = 0
            self.player.animindex = (self.player.animindex % #self.player.animations[self.anim][1]) + 1
        end
        -- Updates the Player's sprites
        self.player.sprite.Set(self.player.folder .. "/" .. self.anim .. "/" .. self.player.animations[self.anim][1][self.player.animindex])
        if self.usingpurple then
            self.playerred.Set(self.player.folder .. "/" .. self.anim .. "Red/" .. self.player.animations[self.anim][1][self.player.animindex])
            self.playerred.x = self.player.sprite.x + 1
            self.playerred.y = self.player.sprite.y + 1
        end
        Player.MoveToAbs(self.player.sprite.x + 1, self.player.sprite.y - 7, true)
    end

    -- Main update function of the module
    function self.Update()
		if self.transfrombattle then
			if not self.transdir then
				self.backcover.alpha = self.backcover.alpha + 0.05
				if self.backcover.alpha >= 1 then
					self.backcover.alpha = 1
					self.roomcoverlayer.alpha = 1
					self.transdir = true
					self.inbattle = false
					self.transtobattle = false
					OWCamera.MoveTo(self.precamera[1], self.precamera[2])
					self.showmap()
					self.player.sprite.alpha = 1
					self.player.loaded = true
					self.player.sprite.layer = "AboveBulletDark"
                    Audio.LoadFile(music)
				end
			else
				if (self.roomcoverlayer.alpha > 0) then
					self.roomcoverlayer.alpha = self.roomcoverlayer.alpha - 0.05
				else
					self.transfrombattle = false
				end
			end
		end
        if self.transtobattle then
            if self.transtobattletype == 0 then
                self.UpdateCYFTransition()
            else
                self.UpdateCYKTransition()
            end
            self.transtobattletimer = self.transtobattletimer + 1
        end
        for i=#self.transfaders, 1, -1 do
            self.transfaders[i].alpha = self.transfaders[i].alpha - 0.02
            if self.transfaders[i].alpha <= 0 then
                self.transfaders[i].Remove()
                table.remove(self.transfaders,i)
            end
        end
        if (not self.inbattle) and (not self.transtobattle) then
            if self.attachedtoplayer then
                self.UpdateCameraMovement()
            end
            if self.deltarune then
                self.UpdateUI()
                self.UpdateHPChangeTexts()
                self.UpdateBulletDetection()
                self.UpdateBulletMode()
            end
            self.UpdateMapEvents()
            self.UpdateCurrentMap()
            self.UpdateRoomTransition()
            if (not Scenes.current) and (not self.transtoroom) then
                if Input.Confirm == 1 then
                    self.ConfirmEventInteraction()
                end
                self.InputPlayerMovement()
            else
                self.UpdateWalkPlayerFunctionMovement()
            end

            -- Updates the timer of the function Overworld.WalkPlayer()
            if self.movingplayer then
                self.walktimer = self.walktimer - 1
                if self.walktimer <= 0 then
                    self.movingplayer = false
                    Scenes.Retrigger(self.walkscene+1)
                end
            end

            self.UpdatePlayer()
        end
    end

    function self.UpdateCYKTransition()
        if self.movetotimer > 0 then
            self.transstartonce = false --transtoenemysprite

            self.monstertransstartX = self.monstertransstartX + (1 / self.movetotimer * (self.transtoenemydata[4] + OWCamera.x - self.monstertransstartX))
            self.monstertransstartY = self.monstertransstartY + (1 / self.movetotimer * (self.transtoenemydata[5] + OWCamera.y - self.monstertransstartY))
            self.transtoenemysprite.MoveTo(self.monstertransstartX,self.monstertransstartY)


            self.transstartX = self.transstartX + (1 / self.movetotimer * (self.transtopos[1] + OWCamera.x - self.transstartX))
            self.transstartY = self.transstartY + (1 / self.movetotimer * (self.transtopos[2] + OWCamera.y - self.transstartY))
            self.player.sprite.MoveTo(self.transstartX,self.transstartY)
            self.movetotimer=self.movetotimer-1
            self.player.sprite.Set(self.player.folder .. "/IdleRight/" .. self.player.animations["IdleRight"][1][1])
            if self.movetotimer%2 == 0 then
                local fadesprite = CreateSprite(self.player.folder .. "/IdleRight/" .. self.player.animations["IdleRight"][1][1], "UnderSuperTop")
                fadesprite.Scale(2,2)
                fadesprite.MoveTo(self.transstartX,self.transstartY)
                OWCamera.Attach(fadesprite, self.transstartX-OWCamera.x, self.transstartY-OWCamera.y)
                table.insert(self.transfaders,fadesprite)
            end
            for y = 1, #self.currentmap.map[1] do
                for x = 1, #self.currentmap.map do
                    self.tilemap[x][y].alpha = self.tilemap[x][y].alpha - 0.05
                end
            end
            self.backcover.alpha = 0
            for x = 1, #self.currentmap.events do
                self.currentmap.events[x].sprite.alpha = self.currentmap.events[x].sprite.alpha - 0.05
            end
        else
            if self.transstartonce == false then
                self.transstartonce = true
                self.hidemap()
                self.unloadplayer(self.player)
                players[1].sprite.alpha = 1
                enemies[1].sprite.alpha = 1
                self.transtoenemysprite.Remove()
                CYK.Background[1]["startX"] = 320
                CYK.Background[1]["startY"] = self.oldcykbgy
                CYK.Background[2]["startX"] = 320
                CYK.Background[2]["startY"] = self.oldcykbgy2
                CYK.Background[1].absx = CYK.Background[1].absx - OWCamera.x
                CYK.Background[1].absy = CYK.Background[1].absy - OWCamera.y
                CYK.Background[2].absx = CYK.Background[2].absx - OWCamera.x
                CYK.Background[2].absy = CYK.Background[2].absy - OWCamera.y
                OWCamera.MoveTo(0,0)
                State("INTRO")
                --State("ACTIONSELECT")
            end
            if self.transtobattletimer > 80 then
                Audio.Stop()
                Audio.LoadFile(music)
                self.transtobattle = false
            end
        end
    end
    function self.UpdateCYFTransition()
        if self.transtobattletimer == 0 or self.transtobattletimer == 8 or self.transtobattletimer == 16 then
            Audio.PlaySound("BeginBattle2", 0.65)
            self.fakesoul.alpha = 1
        end
        if self.transtobattletimer == 4 or self.transtobattletimer == 12 then
            self.fakesoul.alpha = 0
        end
        if self.transtobattletimer == 20 then
            self.player.sprite.alpha = 0
            Audio.PlaySound("BeginBattle3", 0.65)
            self.transdistance = math.sqrt(math.pow(self.fakesoul.x-48,2) + math.pow(self.fakesoul.y-25,2))
            self.transstartX = self.fakesoul.x
            self.transstartY = self.fakesoul.y
            self.movetotimer = 20
        end
        if (self.transtobattletimer > 20) and (self.transtobattletimer < 2000) then
            if self.movetotimer > 0 then
                self.transstartX = self.transstartX + (1 / self.movetotimer * (48 - self.transstartX))
                self.transstartY = self.transstartY + (1 / self.movetotimer * (25 - self.transstartY))
                self.fakesoul.MoveTo(self.transstartX,self.transstartY)
                self.movetotimer=self.movetotimer-1
            else
                if self.fakesoul.alpha > 0 then
                    self.fakesoul.alpha = self.fakesoul.alpha - 0.1
                else
                    self.transtobattletimer = 2000
                    self.startEncounter(self.aftertransen)
                    State("ACTIONSELECT")
                end
            end
        end
        if self.transtobattletimer >= 2000 then
            if self.roomcoverlayer.alpha > 0 then
                self.roomcoverlayer.alpha = self.roomcoverlayer.alpha - 0.1
            end
        end
    end
    function self.UpdateRoomTransition()
        if self.transtoroom then
            if not self.transfadingin then
                if self.roomcoverlayer.alpha < 1 then
                    self.roomcoverlayer.alpha = self.roomcoverlayer.alpha + 0.05
                else
                    self.SwitchMap(self.transtoroomdata[1])
                    self.player.x = self.transtoroomdata[2]
                    self.player.y = self.transtoroomdata[3]
                    self.lastanim = self.transtoroomdata[4]
                    local tab = {"IdleUp","IdleDown","IdleLeft","IdleRight"}
                    self.anim = tab[self.lastanim+1]
                    self.ticker = 0
                    self.player.sprite.Set(self.player.folder .. "/" .. self.anim .. "/" .. self.player.animations[self.anim][1][1])
                    if self.usingpurple then
                        self.playerred.Set(self.player.folder .. "/" .. self.anim .. "Red/" .. self.player.animations[self.anim][1][1])
                        self.playerred.x = self.player.sprite.x + 1
                        self.playerred.y = self.player.sprite.y + 1
                    end
                    Player.MoveToAbs(self.player.sprite.x + 1, self.player.sprite.y - 7, true)
                    self.player.sprite.x = self.player.x + self.player.animations[self.anim][3][1]
                    self.player.sprite.y = self.player.y + self.player.animations[self.anim][3][2]
                    self.GUIVertOffset = -63
                    self.movinggui = false
                    self.movingguidown = false
                    self.transfadingin = true
                end
            else
                if self.roomcoverlayer.alpha > 0 then
                    self.roomcoverlayer.alpha = self.roomcoverlayer.alpha - 0.05
                else
                    self.transtoroom = false
                    self.transfadingin = false
                end
            end
        end
    end
    -- Function Overworld.WalkPlayer()
    function self.WalkPlayer(dir, time, scene)
        self.movingplayer = true
        self.walkdir = dir
        self.walktimer = time
        self.walkscene = scene
    end

    -- Tests if the Player can move on the map, and if he can, moves the Player
    function self.MovePlayer(x, y)
        local movedX = x ~= 0
        local movedY = y ~= 0

        -- If the 4 corners of the Player's sprite moved horizontally are not on a solid tile, move the Player horizontally
        if movedX then
            local playerPlusX = self.player.x + x
            local leftX = math.floor(playerPlusX / 40) + 1
            local rightX = math.floor((playerPlusX + self.player.hitboxwidth) / 40) + 1
            local downX = math.floor(self.player.y / 40) + 1
            local upX = math.floor((self.player.y + self.player.hitboxheight) / 40) + 1
            movedX = not self.issolid(leftX, downX) and not self.issolid(leftX, upX) and not self.issolid(rightX, downX) and not self.issolid(rightX, upX)
            if movedX then
                self.player.x = playerPlusX
            end
        end

        -- If the 4 corners of the Player's sprite moved vertically are not on a solid tile, move the Player vertically
        if movedY then
            local playerPlusY = self.player.y + y
            local leftY = math.floor(self.player.x / 40) + 1
            local rightY = math.floor((self.player.x + self.player.hitboxwidth) / 40) + 1
            local downY = math.floor(playerPlusY / 40) + 1
            local upY = math.floor((playerPlusY + self.player.hitboxheight) / 40) + 1
            movedY = not self.issolid(leftY, downY) and not self.issolid(leftY, upY) and not self.issolid(rightY, downY) and not self.issolid(rightY, upY)
            if movedY then
                self.player.y = playerPlusY
            end
        end
        -- Update the Player's position and animation values if the Player's position has changed
        if ((Input.Left > 0) or (Input.Right > 0) or (Input.Up > 0) or (Input.Down > 0)) or self.movingplayer then
            self.player.sprite.x = self.player.x + self.player.animations[self.anim][3][1]
            self.player.sprite.y = self.player.y + self.player.animations[self.anim][3][2]
            self.lastanim =         (x > 0 and 3       or x < 0 and 2       or  y > 0 and 0    or y < 0 and 1) or self.lastanim
            if self.handleanims then
                self.anim = "Walk" .. ((x > 0 and "Right" or x < 0 and "Left") or (y > 0 and "Up" or "Down"))
            end
        end
    end

    local _OnHit = OnHit
    function OnHit(bullet)
        if (not self.inbattle) and (not self.transtobattle) then
            if not Player.isHurting then
                self.movinggui = true
            end
            _OnHit(bullet)
        end
    end

    -- Wraps the Player's Hurt function
    function self.Hurt(hp)
        Misc.ShakeScreen(10,3,true)
        self.CreateHPChangeText(hp, Player,{ 1, 1, 1 })
        if Player.hp-hp <= 0 then
            Player.MoveToAbs(Player.absx-OWCamera.x,Player.absy-OWCamera.y,true)
        end
        Player.Hurt(hp)
    end

    HPChangeTexts = { }
    -- Shameless copy of CYK's damage textspawn function
    function self.CreateHPChangeText(value, entity, color)
        -- Setup the data of the HP text
        local container = { }
        container.x = Player.absx + 30
        container.y = Player.absy
        container.entity = entity
        container.yBounce = -12
        container.yAccel = 2

        -- Parent sprite of the HP text
        local parent = CreateSprite("empty", "AboveBulletDark")
        parent.SetPivot(0, 0)
        parent.absx = container.x
        parent.absy = container.y
        container.parent = parent

        -- Add the numbers of the HP text in its data
        if value < 0 then
            value = -value
        end
        while value > 0 do
            local val = value % 10
            table.insert(container, val)
            value = math.floor(value / 10)
        end

        -- Create each number of the HP text
        for i = 1, #container do
            local HPNumber = CreateSprite("HPChange/" .. tostring(container[i]))
            HPNumber.SetParent(parent)
            HPNumber.SetPivot(1, 0)
            HPNumber.absx = container.x + 20 * (i - 1)
            HPNumber.absy = container.y
            HPNumber.color = color
            container[i] = HPNumber
        end
        container.frame = 0

        -- Insert the HP text's data in the table of active HP texts
        table.insert(HPChangeTexts, container)
    end

    -- Checks if a given time can be walked through by the Player
    function self.issolid(x, tempy)
        local y = #self.currentmap.map + 1 - tempy
        --y = y + (12 - #self.currentmap.map)
        if (x < 1) or (x > #self.currentmap.map[1]) or (y < 1) or (y > #self.currentmap.map) then return true end
        return self.currentmap.tiles[self.currentmap.map[y][x]][2]
    end

    -- Switches the map which is currently loaded
    function self.SwitchMap(id)
        self.unloadevents()
        self.unloadmap()
        self.loadmap(id)
        self.loadevents(self.currentmap)
    end

    function self.GotoRoom(id,x,y,dir)
        if not self.transtoroom then
            self.transtoroom = true
            self.transtoroomdata = {id,x,y,dir}
            local tab = {"IdleUp","IdleDown","IdleLeft","IdleRight"}
            self.anim = tab[self.lastanim+1]
        end
    end

    -- Loads a map
    function self.loadmap(id)
        -- Loads the map's data
        self.currentmap = dofile(GetModName() .. "/Lua/Maps/" .. maps[id] .. ".lua")
        self.mapOutline.MoveTo((#self.currentmap.map[1] * 40) / 2, (#self.currentmap.map * 40) / 2)
        self.mapOutline.set(self.currentmap.outline)
        -- Loads the tilemap and display it
        self.tilemap = { }
        local tiles = self.currentmap.tiles
        for y = 1, #self.currentmap.map do
            self.tilemap[y] = { }
            for x = 1, #self.currentmap.map[1] do

                local index = self.currentmap.map[y][x]
                if type(tiles[index][1]) == "string" then
                    tile = CreateSprite("tiles/" .. tiles[index][1], "Tiles")
                elseif type(tiles[index][1]) == "table" then
                    -- The table is copied here so the next lines won't modify the original table
                    a = { table.unpack(tiles[index][1]) }
                    a[3] = "tiles/" .. a[3]
                    tile = CreateSprite(a[3] .. "/" .. tiles[index][1][1][1], "Tiles")
                    tile.SetAnimation(unpack(a))
                else
                    error("tile sprite must either be string or table")
                end

                -- Moves the tiles in a grid
                tile.x = ((x - 1) * 40) + 20
                tile.y = 460 - ((y - 1) * 40) + (#self.currentmap.map - 12) * 40
                -- tile.y = ((y - 1) * 40) + 20
                tile.xscale = 2
                tile.yscale = 2
                self.tilemap[y][x] = tile
            end
        end
    end

    -- Hides the map
    function self.hidemap()
        for y = 1, #self.currentmap.map[1] do
            for x = 1, #self.currentmap.map do
                self.tilemap[x][y].alpha = 0
            end
        end
        self.backcover.alpha = 0
        for x = 1, #self.currentmap.events do
            self.currentmap.events[x].sprite.alpha = 0
        end
    end
	
	-- Take a guess
    function self.showmap()
        for y = 1, #self.currentmap.map[1] do
            for x = 1, #self.currentmap.map do
                self.tilemap[x][y].alpha = 1
            end
        end
        self.backcover.alpha = 1
        for x = 1, #self.currentmap.events do
            self.currentmap.events[x].sprite.alpha = 1
        end
    end

    -- Unloads the current map
    function self.unloadmap()
        for y = 1, #self.currentmap.map[1] do
            for x = 1, #self.currentmap.map do
                self.tilemap[x][y].Remove()
            end
        end
        self.currentmap = false
    end

    -- Loads the map's events
    function self.loadevents(map)
        local event
        for x = 1, #map.events do
            event = dofile(GetModName() .. "/Lua/Events/" .. map.events[x][1] .. ".lua")
            event.x = map.events[x][2][1]
            event.y = map.events[x][2][2]
            event.player = players[1]
            event.sprite = CreateSprite(event.sprite, "Events")
            event.sprite.setAnchor(0, 0)
            event.sprite.setPivot(0, 0)
            event.sprite.MoveToAbs(event.x, event.y)
            event.OnLoad(map)
            map.events[x] = event
        end
    end

    -- Unloads all active events
    function self.unloadevents()
        for x = 1, #self.currentmap.events do
            self.currentmap.events[x].sprite.Remove()
        end
        self.currentmap.events = {}
    end

    function self.StartInstant(en)
        Audio.Stop()
        self.startEncounter(en,false)
    end
    function self.StartCYK(en,pos,enemydata)
        self.startEncounter(en,true)
        State("NONE")
        players[1].sprite.alpha = 0
        enemies[1].sprite.alpha = 0
        self.transtobattle = true
        self.transtobattletimer = 0
        self.transtobattletype = 1
        self.roomcoverlayer.alpha = 0
        self.player.sprite.layer = "SuperTop"
        self.transstartX = self.player.sprite.x
        self.transstartY = self.player.sprite.y
        self.transtopos = {pos[1]+40,pos[2]+40}
        self.transtoenemydata = {enemydata[1],enemydata[2],enemydata[3],enemydata[4]+32,enemydata[5]-44+OWCamera.y}
        self.monstertransstartX = enemydata[2] + OWCamera.x
        self.monstertransstartY = enemydata[3] + OWCamera.y
        self.transtoenemysprite = CreateSprite(enemydata[1],"SuperTop")
        self.transtoenemysprite.MoveTo(enemydata[2]+OWCamera.x,enemydata[3]+OWCamera.y)
        self.movetotimer = 20
		self.precamera = {OWCamera.x,OWCamera.y}

        self.oldcykbgy = CYK.Background[1]["startY"]
        self.oldcykbgy2 = CYK.Background[2]["startY"]

        CYK.Background[1]["startX"] = CYK.Background[1]["startX"] + OWCamera.x
        CYK.Background[1]["startY"] = CYK.Background[1]["startY"] + OWCamera.y
        CYK.Background[2]["startX"] = CYK.Background[2]["startX"] + OWCamera.x
        CYK.Background[2]["startY"] = CYK.Background[2]["startY"] + OWCamera.y

        Audio.Stop()
    end
    function self.StartCYF(en)
        self.transtobattle = true
        self.transtobattletimer = 0
        self.transtobattletype = 0
        self.roomcoverlayer.alpha = 1
        self.player.sprite.layer = "SuperTop"
        self.fakesoul.layer = "SuperTop"
        self.fakesoul.MoveToAbs(Player.absx,Player.absy)
        self.fakesoul.alpha = 1
		self.precamera = {OWCamera.x,OWCamera.y}
        Player.MoveToAbs(Player.absx-OWCamera.x,Player.absy-OWCamera.y,true)
        self.fakesoul.MoveTo(self.fakesoul.x-OWCamera.x,self.fakesoul.y-OWCamera.y)
        self.player.sprite.x = self.player.sprite.x-OWCamera.x
        self.player.sprite.y = self.player.sprite.y-OWCamera.y
        OWCamera.MoveTo(0,0)
        self.aftertransen = en
        Audio.Stop()
    end
    -- Starts an encounter
    function self.startEncounter(encounter,m)
        if not m then
            m = false
        end
        local a = Audio["hurtsound"]
        Audio["hurtsound"] = "empty"
        Player.SetMaxHPShift(Player.maxhp-Player.maxhpshift,1.7,true,true)
        Audio["hurtsound"] = a
        Player.sprite.alpha = 1
        Player.Hurt(0, 0)
        dofile(GetModName() .. "/Lua/" .. encounter .. ".lua")
        local _Update = Update
        function Update()
            _Update()
        end
        Audio.Stop()
        Audio.LoadFile(music)
        if self.deltarune then
            self.GUIVertOffset = -63
            self.bottombar.y = -33
            self.movinggui = false
            self.movingguidown = false
            self.darkenedlayer.alpha = 0
            if self.usingpurple then
                self.playerred.alpha = 0
            end
            self.mapOutline.alpha = 0
            self.fakesoul.alpha = 0
            self.hpbar.alpha = 0
            self.hptext.alpha = 0
            self.maxhptext.alpha = 0
            self.faceui.alpha = 0
            self.uinametext.alpha = 0
            for i = #HPChangeTexts, 1, -1 do
                local HPChangeText = HPChangeTexts[i]
                for j = 1, #HPChangeText do
                    HPChangeText[j].alpha = 0
                end
            end
        end
        if not m then
            OWCamera.MoveTo(0,0)
            self.backcover.alpha = 0
            self.hidemap()
            self.unloadplayer(self.player)
            State("ACTIONSELECT")
        end
        EncounterStarting()
        unescape = false
        self.inbattle = true
    end
	
	function callback()
		self.backcover.alpha = 0
		self.transfrombattle = true
		self.transdir = false
	end

    -- Unloads the Player
    function self.unloadplayer(player)
        player.sprite.alpha = 0
        player.loaded = false
    end

    return self 
end)()