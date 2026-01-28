-- DOORS | UNIVERSAL AUTO LOADER (HOTEL / MINES / DETOUR / ROOMS)

--------------------------------------------------
-- SERVICES
--------------------------------------------------
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")

--------------------------------------------------
-- NOTIFY
--------------------------------------------------
local function notify(txt)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "DOORS | Loader",
            Text = txt,
            Duration = 4
        })
    end)
end

--------------------------------------------------
-- GLOBAL FULLBRIGHT (SHARED)
--------------------------------------------------
getgenv().DoorsFullbright = function()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 1e9
    Lighting.GlobalShadows = false
end

--------------------------------------------------
-- FLOOR DETECTION
--------------------------------------------------
local function detectArea()
    -- 🟥 ROOMS (A-000 → A-1000)
    for _,v in ipairs(Workspace:GetDescendants()) do
        if v.Name == "A60" or v.Name == "A90" or v.Name == "A120" then
            return "Rooms"
        end
    end

    -- 🟪 DETOUR / BACKDOOR
    if Workspace:FindFirstChild("Backdoor")
    or Workspace:FindFirstChild("Haste")
    or Workspace:FindFirstChild("TimerLever") then
        return "Detour"
    end

    -- ⛏️ FLOOR 2 – MINES
    if Workspace:FindFirstChild("Mines")
    or Workspace:FindFirstChild("Minecart")
    or Workspace:FindFirstChild("AnchorRoom") then
        return "Mines"
    end

    -- 🏨 FLOOR 1 – HOTEL
    return "Hotel"
end

--------------------------------------------------
-- LOAD CORRECT SCRIPT
--------------------------------------------------
local Area = detectArea()
notify("Detected: "..Area)

if Area == "Hotel" then
    loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/joyfulpizza/DoorsFloor2Mines/refs/heads/main/Floor1.lua"
    ))()

elseif Area == "Mines" then
    loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/joyfulpizza/DoorsFloor2Mines/refs/heads/main/Floor2.lua"
    ))()

elseif Area == "Detour" then
    loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/joyfulpizza/DoorsFloor2Mines/refs/heads/main/The%20backdoors(detour)"
    ))()

elseif Area == "Rooms" then
    loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/joyfulpizza/DoorsFloor2Mines/refs/heads/main/A-000%20%7E%20A-1000.lua"
    ))()
end

--------------------------------------------------
-- FULLBRIGHT NOTICE
--------------------------------------------------
notify("Use FullBright button in Visuals 🌕")
