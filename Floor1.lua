-- Hotel.lua
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({ Name = "DOORS | Hotel" })
local MainTab = Window:CreateTab("🧠 Main")
local VisualTab = Window:CreateTab("👁️ Visuals")

local ESP_Entities = false
local EntityNotify = false
local ESPBoxes = {}

local function notify(txt)
    pcall(function() StarterGui:SetCore("SendNotification",{Title="DOORS",Text=txt,Duration=4}) end)
end

local function clearESP(tag)
    for i=#ESPBoxes,1,-1 do
        local v=ESPBoxes[i]
        if v.Tag==tag then if v.Box then v.Box:Destroy() end table.remove(ESPBoxes,i) end
    end
end

local function createESP(model,color,tag)
    if model and model:FindFirstChild("HumanoidRootPart") then
        local hrp = model.HumanoidRootPart
        local box = Instance.new("BoxHandleAdornment")
        box.Adornee = hrp
        box.Size = hrp.Size
        box.Color3 = color
        box.Transparency = 0.5
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Parent = hrp
        table.insert(ESPBoxes,{Box=box,Tag=tag})
    end
end

-- Entity Notifications
Workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") and obj ~= LocalPlayer.Character and EntityNotify then
        notify(obj.Name.." spawned!")
    end
end)

-- Incremental ESP
task.spawn(function()
    while task.wait(0.15) do
        if ESP_Entities then
            clearESP("Entity")
            for _,v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v ~= LocalPlayer.Character then
                    createESP(v,Color3.fromRGB(255,0,0),"Entity")
                    task.wait()
                end
            end
        end
    end
end)

-- Toggles
MainTab:CreateToggle({Name="Entity Notifications",CurrentValue=false,Callback=function(v) EntityNotify=v end})
VisualTab:CreateToggle({Name="ESP Entities",CurrentValue=false,Callback=function(v) ESP_Entities=v if not v then clearESP("Entity") end end})

-- Credits
local CreditTab = Window:CreateTab("⭐ Credits")
CreditTab:CreateButton({Name="Credits",Callback=function()
    Rayfield:Notify({Title="Credits",Content="Made by @joyful_pizzapartyl",Duration=5})
end})
