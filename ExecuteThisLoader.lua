-- DOORS | AUTO FLOOR LOADER (HOTEL / MINES)

--------------------------------------------------
-- SERVICES
--------------------------------------------------
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--------------------------------------------------
-- SCRIPT LINKS
--------------------------------------------------
local FLOOR1_SCRIPT = "https://raw.githubusercontent.com/joyfulpizza/DoorsFloor2Mines/refs/heads/main/Floor1.lua"
local FLOOR2_SCRIPT = "https://raw.githubusercontent.com/joyfulpizza/DoorsFloor2Mines/refs/heads/main/Floor2.lua"

--------------------------------------------------
-- FLOOR DETECTION
--------------------------------------------------
local function isMines()
    for _,v in pairs(Workspace:GetDescendants()) do
        local n = v.Name
        if n == "Grumble"
        or n == "Giggle"
        or n == "Snare"
        or n == "SeekMoving"
        or n:lower():find("mine")
        or n:lower():find("fuse")
        or n:lower():find("battery") then
            return true
        end
    end
    return false
end

--------------------------------------------------
-- WAIT FOR GAME
--------------------------------------------------
repeat task.wait() until LocalPlayer.Character
task.wait(1)

--------------------------------------------------
-- LOAD CORRECT FLOOR
--------------------------------------------------
if isMines() then
    warn("[DOORS] Floor 2 detected (The Mines)")
    loadstring(game:HttpGet(FLOOR2_SCRIPT))()
else
    warn("[DOORS] Floor 1 detected (Hotel)")
    loadstring(game:HttpGet(FLOOR1_SCRIPT))()
end
