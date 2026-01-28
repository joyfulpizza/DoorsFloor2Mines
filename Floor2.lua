-- DOORS | FLOOR 2 (THE MINES) - RAYFIELD UI

--------------------------------------------------
-- SERVICES
--------------------------------------------------
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

--------------------------------------------------
-- RAYFIELD
--------------------------------------------------
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

--------------------------------------------------
-- WINDOW / TABS
--------------------------------------------------
local Window = Rayfield:CreateWindow({
    Name = "DOORS | Floor 2 (The Mines)",
    LoadingTitle = "DOORS – The Mines",
    LoadingSubtitle = "Helper UI",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "DoorsRayfield",
        FileName = "MinesConfig"
    }
})

local MainTab   = Window:CreateTab("🧠 Main", 4483362458)
local VisualTab = Window:CreateTab("👁️ Visuals", 4483362458)
local MiscTab   = Window:CreateTab("🧩 Misc", 4483362458)

--------------------------------------------------
-- FLAGS
--------------------------------------------------
local EntityNotify = false
local ChatEntityNotify = false

local ESP_Entities = false
local ESP_Players  = false
local ESP_Hiding   = false
local ESP_Doors    = false
local ESP_Keys     = false
local ESP_Levers   = false

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
            Title = "DOORS – Mines",
            Text = txt,
            Duration = 4
        })
    end)
end

local function chatNotify(txt)
    local ev = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if ev then
        ev.SayMessageRequest:FireServer("[MINES] "..txt, "All")
    end
end

local function clearESPTag(tag)
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
    box.ZIndex = 10
    box.Parent = part

    table.insert(ESPBoxes, {Box = box, Tag = tag})
end

--------------------------------------------------
-- ENTITY NAMES (MINES)
--------------------------------------------------
local ENTITY_NAMES = {
    Grumble = true,
    Giggle = true,
    Snare = true,
    Screech = true,
    RushMoving = true,
    AmbushMoving = true,
    Seek = true,
    SeekMoving = true
}

--------------------------------------------------
-- ENTITY NOTIFICATIONS
--------------------------------------------------
Workspace.DescendantAdded:Connect(function(obj)
    if ENTITY_NAMES[obj.Name] then
        if EntityNotify then
            notify(obj.Name .. " detected!")
        end
        if ChatEntityNotify then
            chatNotify(obj.Name .. " detected!")
        end
    end
end)

--------------------------------------------------
-- ESP FUNCTIONS
--------------------------------------------------
local function updateEntityESP()
    clearESPTag("Entity")
    if not ESP_Entities then return end

    for _,v in pairs(Workspace:GetDescendants()) do
        if ENTITY_NAMES[v.Name] then
            local part = v:IsA("Model") and v:FindFirstChildWhichIsA("BasePart") or v
            if part and part:IsA("BasePart") then
                createESP(part, Color3.fromRGB(255, 60, 60), "Entity")
            end
        end
    end
end

local function updatePlayerESP()
    clearESPTag("Player")
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

local function updateHidingESP()
    clearESPTag("Hiding")
    if not ESP_Hiding then return end

    for _,p in pairs(Workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") and p.Name == "HidePrompt" then
            local part = p.Parent:FindFirstChildWhichIsA("BasePart")
            if part then
                createESP(part, Color3.fromRGB(0,170,255), "Hiding")
            end
        end
    end
end

local function updateDoorESP()
    clearESPTag("Door")
    if not ESP_Doors then return end

    for _,v in pairs(Workspace:GetDescendants()) do
        if v.Name == "Door" and v:IsA("Model") then
            local part = v:FindFirstChildWhichIsA("BasePart")
            if part then
                createESP(part, Color3.fromRGB(0,255,150), "Door")
            end
        end
    end
end

local function updateKeyESP()
    clearESPTag("Key")
    if not ESP_Keys then return end

    for _,v in pairs(Workspace:GetDescendants()) do
        if v.Name:lower():find("key")
        or v.Name:lower():find("fuse")
        or v.Name:lower():find("battery") then
            local part = v:IsA("Model") and v:FindFirstChildWhichIsA("BasePart") or v
            if part and part:IsA("BasePart") then
                createESP(part, Color3.fromRGB(255,255,0), "Key")
            end
        end
    end
end

local function updateLeverESP()
    clearESPTag("Lever")
    if not ESP_Levers then return end

    for _,p in pairs(Workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") and p.Name == "ActivatePrompt" then
            local part = p.Parent:FindFirstChildWhichIsA("BasePart")
            if part then
                createESP(part, Color3.fromRGB(180,0,255), "Lever")
            end
        end
    end
end

--------------------------------------------------
-- 🔁 ROUND-ROBIN ESP (NO LAG)
--------------------------------------------------
task.spawn(function()
    local i = 1
    local ORDER = {
        function() if ESP_Entities then updateEntityESP() end end,
        function() if ESP_Players  then updatePlayerESP()  end end,
        function() if ESP_Hiding   then updateHidingESP()  end end,
        function() if ESP_Doors    then updateDoorESP()    end end,
        function() if ESP_Keys     then updateKeyESP()     end end,
        function() if ESP_Levers   then updateLeverESP()   end end,
    }

    while true do
        ORDER[i]()
        i += 1
        if i > #ORDER then i = 1 end
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

VisualTab:CreateToggle({ Name="ESP Entities", CurrentValue=false, Callback=function(v) ESP_Entities=v if not v then clearESPTag("Entity") end end })
VisualTab:CreateToggle({ Name="ESP Players", CurrentValue=false, Callback=function(v) ESP_Players=v if not v then clearESPTag("Player") end end })
VisualTab:CreateToggle({ Name="ESP Hiding Spots", CurrentValue=false, Callback=function(v) ESP_Hiding=v if not v then clearESPTag("Hiding") end end })
VisualTab:CreateToggle({ Name="ESP Doors", CurrentValue=false, Callback=function(v) ESP_Doors=v if not v then clearESPTag("Door") end end })
VisualTab:CreateToggle({ Name="ESP Keys / Fuses / Batteries", CurrentValue=false, Callback=function(v) ESP_Keys=v if not v then clearESPTag("Key") end end })
VisualTab:CreateToggle({ Name="ESP Levers", CurrentValue=false, Callback=function(v) ESP_Levers=v if not v then clearESPTag("Lever") end end })
VisualTab:CreateButton({
    Name = "🌕 FullBright",
    Callback = function()
        if getgenv().DoorsFullbright then
            getgenv().DoorsFullbright()
        end
    end
})

MiscTab:CreateToggle({
    Name = "Chat Entity Notifications",
    CurrentValue = false,
    Callback = function(v) ChatEntityNotify = v end
})

Rayfield:Notify({
    Title = "DOORS – The Mines",
    Content = "Floor 2 UI loaded ✔️",
    Duration = 4
})
