-- Takes a string and returns a table of strings between the characters we were searching for
-- Ex: string.split("test:testy", ":") --> { "test", "testy" }
-- Improved by WD200019

function string.split(inputstr, sep, isPattern)
    if sep == nil then
        sep = "%s"
    end
    local t = { }
    if isPattern then
        while string.find(inputstr, sep) ~= nil do
            local matchrange = { string.find(inputstr, sep) }
            local preceding = string.sub(inputstr, 0, matchrange[1] - 1)
            table.insert(t, preceding ~= "" and preceding or nil)
            inputstr = string.sub(inputstr, matchrange[2] + 1)
        end
        table.insert(t, inputstr)
    else
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
        end
    end
    return t
end

function string.startswith(str, start)
    return str:sub(1, #start) == start
end
 
function string.endswith(str, ending)
    return ending == "" or str:sub(-#ending) == ending
end

function distancebetween(t1,t2)
    local distancex
    local distancey
    local csquared
    distancex = t1[1] - t2[1]
    distancey = t1[2] - t2[2]
    csquared = (distancex*distancex) + (distancey*distancey)
    return math.sqrt(csquared)
end

function rect(point1,point2,point3,point4)
    local _rect
    _rect = {}
    _rect.X1 = point1
    _rect.X2 = point2
    _rect.Y1 = point3
    _rect.Y2 = point4
    return _rect
end

function isColliding(r1,r2)
    return ((r1.X1 < r2.X2) and (r1.X2 > r2.X1) and (r1.Y1 < r2.Y2) and (r1.Y2 > r2.Y1))
end

function GetModName()
    local testError = function()
        CreateProjectile("asdbfiosdjfaosdijcfiosdjsdo", 0, 0)
    end

    local _, output = xpcall(testError, debug.traceback)

    -- Find the position of "Sprites/asdbfiosdjfaosdijcfiosdjsdo"
    local SpritesFolderPos = output:find("asdbfiosdjfaosdijcfiosdjsdo") - 10
    output = output:sub(1, SpritesFolderPos)

    local paths = string.split(output, "Attempted to load ", true)
    return paths[#paths]
end