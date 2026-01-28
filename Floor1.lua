-- DOORS Rayfield UI Script (FINAL MERGE + ROUND-ROBIN ESP)

--------------------------------------------------
-- SERVICES
--------------------------------------------------
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
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
    Name = "DOORS | Rayfield",
    LoadingTitle = "DOORS",
    LoadingSubtitle = "Helper UI",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "DoorsRayfield",
        FileName = "Config"
    }
})

local MainTab   = Window:CreateTab("🧠 Main", 4483362458)
local VisualTab = Window:CreateTab("👁️ Visuals", 4483362458)
local MiscTab   = Window:CreateTab("🧩 Misc", 4483362458)
local CreditTab = Window:CreateTab("⭐ Credits", 4483362458)

--------------------------------------------------
-- FLAGS
--------------------------------------------------
local EntityNotify = false
local ChatEntityNotify = false

local ESP_Entities = false
local ESP_Players  = false
local ESP_Hiding   = false
local ESP_Books    = false
local ESP_Levers   = false
local ESP_Doors    = false
local ESP_Keys     = false

local Xray = false

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
            Title = "DOORS",
            Text = txt,
            Duration = 4
        })
    end)
end

local function chatNotify(txt)
    local event = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if event then
        event.SayMessageRequest:FireServer("[DOORS] "..txt, "All")
    end
end

local function clearESPTag(tag)
    for i = #ESPBoxes, 1, -1 do
        local v = ESPBoxes[i]
        if v and v.Tag == tag then
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
-- ENTITY NOTIFICATIONS
--------------------------------------------------
Workspace.ChildAdded:Connect(function(obj)
    if obj.Name == "RushMoving" then
        if EntityNotify then notify("Rush is coming!") end
        if ChatEntityNotify then chatNotify("Rush is coming!") end
    elseif obj.Name == "AmbushMoving" then
        if EntityNotify then notify("Ambush is coming!") end
        if ChatEntityNotify then chatNotify("Ambush is coming!") end
    elseif obj.Name == "Eyes" then
        if EntityNotify then notify("Eyes spawned!") end
        if ChatEntityNotify then chatNotify("Eyes spawned!") end
    end
end)

Workspace.DescendantAdded:Connect(function(obj)
    if obj.Name == "Screech" then
        if EntityNotify then notify("Screech nearby 👀") end
        if ChatEntityNotify then chatNotify("Screech nearby") end
    elseif obj.Name == "Figure" or obj.Name == "FigureRagdoll" then
        if EntityNotify then notify("Figure spawned!") end
        if ChatEntityNotify then chatNotify("Figure spawned!") end
    elseif obj.Name == "Seek" or obj.Name == "SeekMoving" then
        if EntityNotify then notify("Seek chase started!") end
        if ChatEntityNotify then chatNotify("Seek chase started!") end
    end
end)

--------------------------------------------------
-- FLASHLIGHT
--------------------------------------------------
local function giveFlashlight()
    if LocalPlayer.Backpack:FindFirstChild("light") then return end

    local tool = Instance.new("Tool")
    tool.Name = "light"
    tool.RequiresHandle = true

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1,1,1)
    handle.Parent = tool

    local light = Instance.new("PointLight")
    light.Brightness = 6
    light.Range = 45
    light.Parent = handle

    tool.Parent = LocalPlayer.Backpack
    notify("Flashlight given 🔦")
end

--------------------------------------------------
-- XRAY
--------------------------------------------------
local function setXray(state)
    for _,v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.LocalTransparencyModifier = state and 0.75 or 0
        end
    end
end

--------------------------------------------------
-- ESP FUNCTIONS
--------------------------------------------------
local ENTITY_NAMES = {
    RushMoving = true,
    AmbushMoving = true,
    Eyes = true,
    Screech = true,
    Figure = true,
    FigureRagdoll = true,
    Seek = true,
    SeekMoving = true
}

local function updateEntityESP()
    clearESPTag("Entity")
    if not ESP_Entities then return end

    for _,v in pairs(Workspace:GetDescendants()) do
        if ENTITY_NAMES[v.Name] then
            local part = v:IsA("Model") and v:FindFirstChildWhichIsA("BasePart") or v
            if part and part:IsA("BasePart") then
                createESP(part, Color3.fromRGB(255,0,0), "Entity")
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

local function updateBookESP()
    clearESPTag("Book")
    if not ESP_Books then return end

    for _,v in pairs(Workspace:GetDescendants()) do
        if v.Name == "Book" then
            local part = v:IsA("Model") and v:FindFirstChildWhichIsA("BasePart") or v
            if part and part:IsA("BasePart") then
                createESP(part, Color3.fromRGB(255,170,0), "Book")
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

local function updateDoorESP()
    clearESPTag("Door")
    if not ESP_Doors then return end

    local rooms = Workspace:FindFirstChild("CurrentRooms")
    if not rooms then return end

    for _,room in pairs(rooms:GetChildren()) do
        for _,v in pairs(room:GetDescendants()) do
            if v:IsA("Model") and v.Name == "Door" then
                local part = v:FindFirstChildWhichIsA("BasePart")
                if part then
                    createESP(part, Color3.fromRGB(0,255,120), "Door")
                end
            end
        end
    end
end

local function updateKeyESP()
    clearESPTag("Key")
    if not ESP_Keys then return end

    for _,v in pairs(Workspace:GetDescendants()) do
        if v.Name == "KeyObtain" or v.Name == "SkeletonKey" then
            local part = v:IsA("Model") and v:FindFirstChildWhichIsA("BasePart") or v
            if part and part:IsA("BasePart") then
                createESP(part, Color3.fromRGB(255,255,0), "Key")
            end
        end
    end
end

--------------------------------------------------
-- 🔁 ROUND-ROBIN ESP REFRESH (NO LAG)
--------------------------------------------------
task.spawn(function()
    local index = 1
    local ESP_ORDER = {
        function() if ESP_Entities then updateEntityESP() end end,
        function() if ESP_Players  then updatePlayerESP()  end end,
        function() if ESP_Hiding   then updateHidingESP()  end end,
        function() if ESP_Books    then updateBookESP()    end end,
        function() if ESP_Levers   then updateLeverESP()   end end,
        function() if ESP_Doors    then updateDoorESP()    end end,
        function() if ESP_Keys     then updateKeyESP()     end end,
    }

    while true do
        ESP_ORDER[index]()
        index = index + 1
        if index > #ESP_ORDER then index = 1 end

        if Xray then setXray(true) end
        task.wait(0.15)
    end
end)

--------------------------------------------------
-- UI
--------------------------------------------------
MainTab:CreateToggle({
    Name = "Entity Notifications (Popup)",
    CurrentValue = false,
    Callback = function(v) EntityNotify = v end
})

MainTab:CreateButton({
    Name = "Give Flashlight",
    Callback = giveFlashlight
})

VisualTab:CreateToggle({
    Name = "Xray (75% Transparent)",
    CurrentValue = false,
    Callback = function(v)
        Xray = v
        setXray(v)
    end
})

VisualTab:CreateToggle({ Name="ESP Entities", CurrentValue=false, Callback=function(v) ESP_Entities=v if not v then clearESPTag("Entity") end end })
VisualTab:CreateToggle({ Name="ESP Players", CurrentValue=false, Callback=function(v) ESP_Players=v if not v then clearESPTag("Player") end end })
VisualTab:CreateToggle({ Name="ESP Hiding Spots", CurrentValue=false, Callback=function(v) ESP_Hiding=v if not v then clearESPTag("Hiding") end end })
VisualTab:CreateToggle({ Name="ESP Figure Books", CurrentValue=false, Callback=function(v) ESP_Books=v if not v then clearESPTag("Book") end end })
VisualTab:CreateToggle({ Name="ESP Levers", CurrentValue=false, Callback=function(v) ESP_Levers=v if not v then clearESPTag("Lever") end end })
VisualTab:CreateToggle({ Name="ESP Doors", CurrentValue=false, Callback=function(v) ESP_Doors=v if not v then clearESPTag("Door") end end })
VisualTab:CreateToggle({ Name="ESP Keys", CurrentValue=false, Callback=function(v) ESP_Keys=v if not v then clearESPTag("Key") end end })
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

CreditTab:CreateButton({
    Name = "Credits",
    Callback = function()
        Rayfield:Notify({
            Title = "Credits",
            Content = "Made by @joyful_pizzapartyl, enjoy!",
            Duration = 5
        })
    end
})

Rayfield:Notify({
    Title = "DOORS",
    Content = "Final merge loaded ✔️ (Smooth ESP)",
    Duration = 4
})
