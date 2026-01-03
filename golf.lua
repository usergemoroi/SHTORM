--[[
    GnomHub: Zero-Point Edition
    Authorized for Delta Engineer
    Theme: Blue / Deep Sea
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("GnomHub | Zero-Point", Cyanine)

-- ПЕРЕМЕННЫЕ СОСТОЯНИЯ
_G.AutoFarm = false
_G.AutoCollect = false
_G.Noclip = false
_G.Fly = false

-- ВКЛАДКА: ПЕРСОНАЖ
local PlayerTab = Window:NewTab("Character")
local PlayerSection = PlayerTab:NewSection("Physical Mods")

PlayerSection:NewSlider("Speed", "Увеличение скорости", 500, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

PlayerSection:NewSlider("Jump Power", "Сила прыжка", 500, 50, function(s)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = s
end)

PlayerSection:NewToggle("Noclip", "Сквозь стены", function(state)
    _G.Noclip = state
    game:GetService("RunService").Stepped:Connect(function()
        if _G.Noclip then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

PlayerSection:NewToggle("Fly", "Полёт", function(state)
    _G.Fly = state
    local lp = game.Players.LocalPlayer
    if _G.Fly then
        local bg = Instance.new("BodyGyro", lp.Character.HumanoidRootPart)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = lp.Character.HumanoidRootPart.CFrame
        local bv = Instance.new("BodyVelocity", lp.Character.HumanoidRootPart)
        bv.velocity = Vector3.new(0,0.1,0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        task.spawn(function()
            while _G.Fly do
                bv.velocity = workspace.CurrentCamera.CFrame.LookVector * 100
                bg.cframe = workspace.CurrentCamera.CFrame
                task.wait()
            end
            bg:Destroy()
            bv:Destroy()
        end)
    end
end)

-- ВКЛАДКА: АВТОМАТИЗАЦИЯ И ФАРМИНГ
local FarmTab = Window:NewTab("Automation")
local FarmSection = FarmTab:NewSection("Farming Bots")

FarmSection:NewToggle("Auto Hide Body", "Авто-сокрытие тела", function(state)
    _G.AutoFarm = state
    task.spawn(function()
        while _G.AutoFarm do
            pcall(function()
                local body = workspace:FindFirstChild("Body") -- Проверьте точное имя объекта в игре
                local shelter = workspace:FindFirstChild("Shelter") or workspace:FindFirstChild("HidingSpot")
                if body and shelter then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = body.HumanoidRootPart.CFrame
                    task.wait(0.2)
                    fireproximityprompt(body:FindFirstChildOfClass("ProximityPrompt"))
                    task.wait(0.2)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = shelter.CFrame
                end
            end)
            task.wait(1)
        end
    end)
end)

FarmSection:NewToggle("Full Auto-Collect", "Умный сбор предметов", function(state)
    _G.AutoCollect = state
    task.spawn(function()
        while _G.AutoCollect do
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") or v:IsA("TouchTransmitter") then
                    local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.CFrame = v.Parent.CFrame
                        if v:IsA("ProximityPrompt") then fireproximityprompt(v) end
                        task.wait(0.1)
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end)

FarmSection:NewButton("Fast Restart", "Мгновенная смерть/рестарт", function()
    game.Players.LocalPlayer.Character.Humanoid.Health = 0
end)

FarmSection:NewButton("TP to Shelter", "Телепорт в укрытие", function()
    local target = workspace:FindFirstChild("Shelter")
    if target then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.CFrame end
end)

-- ВКЛАДКА: ВИЗУАЛЫ (ESP)
local VisualTab = Window:NewTab("Visuals")
local VisualSection = VisualTab:NewSection("ESP & HUD")

VisualSection:NewButton("Enable All ESP", "Подсветка игроков, имен, HP", function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character then
            -- Highlight (Chams)
            local h = Instance.new("Highlight", p.Character)
            h.FillColor = Color3.fromRGB(0, 100, 255)
            h.OutlineColor = Color3.new(1, 1, 1)
            
            -- Billboard (Name/Dist/HP)
            local bb = Instance.new("BillboardGui", p.Character.Head)
            bb.Size = UDim2.new(0, 100, 0, 50)
            bb.AlwaysOnTop = true
            bb.ExtentsOffset = Vector3.new(0, 3, 0)
            
            local tl = Instance.new("TextLabel", bb)
            tl.Size = UDim2.new(1, 0, 1, 0)
            tl.BackgroundTransparency = 1
            tl.TextColor3 = Color3.new(1, 1, 1)
            tl.TextStrokeTransparency = 0
            
            task.spawn(function()
                while p.Character do
                    local dist = math.floor((p.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                    tl.Text = string.format("%s\nHP: %d | Dist: %d", p.Name, p.Character.Humanoid.Health, dist)
                    task.wait(0.5)
                end
            end)
        end
    end
end)

VisualSection:NewButton("Body ESP", "Подсветка тел (Красный)", function()
    for _, v in pairs(workspace:GetChildren()) do
        if v.Name == "Body" then
            local h = Instance.new("Highlight", v)
            h.FillColor = Color3.new(1, 0, 0)
        end
    end
end)

-- УТИЛИТЫ СИСТЕМЫ
local UtilTab = Window:NewTab("System")
local UtilSection = UtilTab:NewSection("Server Controls")

UtilSection:NewButton("Anti-AFK", "Защита от вылета", function()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end)
