-- DOORS | ROOMS (A-000) UI

--------------------------------------------------
-- SERVICES
--------------------------------------------------
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

--------------------------------------------------
-- RAYFIELD
--------------------------------------------------
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

--------------------------------------------------
-- WINDOW
--------------------------------------------------
local Window = Rayfield:CreateWindow({
    Name = "DOORS | ROOMS",
    LoadingTitle = "DOORS – ROOMS",
    LoadingSubtitle = "A-000 Helper",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "DoorsRayfield",
        FileName = "RoomsConfig"
    }
})

local MainTab   = Window:CreateTab("🧠 Main", 4483362458)
local VisualTab = Window:CreateTab("👁️ Visuals", 4483362458)

--------------------------------------------------
-- FLAGS
--------------------------------------------------
local ESP_Entities = false
local ESP_Players  = false
local ESP_Lockers  = false
local ESP_Doors    = false
local EntityNotify = false

--------------------------------------------------
-- ESP STORAGE
--------------------------------------------------
local ESPBoxes = {}

--------------------------------------------------
-- UTILS
--------------------------------------------------
local function notify(txt)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "DOORS – ROOMS",
            Text = txt,
            Duration = 4
        })
    end)
end

local function clearESP(tag)
    for i = #ESPBoxes, 1, -1 do
        local v = ESPBoxes[i]
        if v.Tag == tag then
            if v.Box then v.Box:Destroy() end
            table.remove(ESPBoxes, i)
        end
    end
end

local function createESP(part, color, tag)
    if not part or not part:IsA("BasePart") then return end

    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = part
    box.Size = part.Size
    box.Color3 = color
    box.Transparency = 0.5
    box.AlwaysOnTop = true
    box.Parent = part

    table.insert(ESPBoxes, {Box = box, Tag = tag})
end

--------------------------------------------------
-- ENTITY NAMES (ROOMS)
--------------------------------------------------
local ROOM_ENTITIES = {
    A60 = true,
    A90 = true,
    A120 = true
}

--------------------------------------------------
-- ENTITY NOTIFICATIONS
--------------------------------------------------
Workspace.DescendantAdded:Connect(function(obj)
    if ROOM_ENTITIES[obj.Name] and EntityNotify then
        notify(obj.Name .. " spawned!")
    end
end)

--------------------------------------------------
-- ESP FUNCTIONS
--------------------------------------------------
local function updateEntityESP()
    clearESP("Entity")
    if not ESP_Entities then return end

    for _,v in pairs(Workspace:GetDescendants()) do
        if ROOM_ENTITIES[v.Name] then
            local part = v:IsA("Model") and v:FindFirstChildWhichIsA("BasePart") or v
            if part then
                createESP(part, Color3.fromRGB(255,0,0), "Entity")
            end
        end
    end
end

local function updatePlayerESP()
    clearESP("Player")
    if not ESP_Players then return end

    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                createESP(hrp, Color3.fromRGB(0,255,0), "Player")
            end
        end
    end
end

local function updateLockerESP()
    clearESP("Locker")
    if not ESP_Lockers then return end

    for _,v in pairs(Workspace:GetDescendants()) do
        if v.Name:lower():find("locker") then
            local part = v:IsA("Model") and v:FindFirstChildWhichIsA("BasePart") or v
            if part then
                createESP(part, Color3.fromRGB(0,170,255), "Locker")
            end
        end
    end
end

local function updateDoorESP()
    clearESP("Door")
    if not ESP_Doors then return end

    for _,v in pairs(Workspace:GetDescendants()) do
        if v.Name:match("^A%-%d+") then
            local part = v:IsA("Model") and v:FindFirstChildWhichIsA("BasePart")
            if part then
                createESP(part, Color3.fromRGB(255,255,0), "Door")
            end
        end
    end
end

--------------------------------------------------
-- ROUND-ROBIN ESP (NO LAG)
--------------------------------------------------
task.spawn(function()
    local i = 1
    local order = {
        function() if ESP_Entities then updateEntityESP() end end,
        function() if ESP_Players  then updatePlayerESP()  end end,
        function() if ESP_Lockers  then updateLockerESP()  end end,
        function() if ESP_Doors    then updateDoorESP()    end end,
    }

    while true do
        order[i]()
        i += 1
        if i > #order then i = 1 end
        task.wait(0.15)
    end
end)

--------------------------------------------------
-- UI
--------------------------------------------------
MainTab:CreateToggle({
    Name = "Entity Notifications",
    CurrentValue = false,
    Callback = function(v) EntityNotify = v end
})

VisualTab:CreateToggle({ Name="ESP Entities (A-60 / A-90 / A-120)", CurrentValue=false, Callback=function(v) ESP_Entities=v if not v then clearESP("Entity") end end })
VisualTab:CreateToggle({ Name="ESP Players", CurrentValue=false, Callback=function(v) ESP_Players=v if not v then clearESP("Player") end end })
VisualTab:CreateToggle({ Name="ESP Lockers", CurrentValue=false, Callback=function(v) ESP_Lockers=v if not v then clearESP("Locker") end end })
VisualTab:CreateToggle({ Name="ESP Exit Doors", CurrentValue=false, Callback=function(v) ESP_Doors=v if not v then clearESP("Door") end end })
VisualTab:CreateButton({
    Name = "🌕 FullBright",
    Callback = function()
        if getgenv().DoorsFullbright then
            getgenv().DoorsFullbright()
        end
    end
})

Rayfield:Notify({
    Title = "DOORS – ROOMS",
    Content = "Rooms UI loaded ✔️",
    Duration = 4
})
