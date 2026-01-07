--[[
    GnomHub - Premium Brainrot Edition
    Based on analyzed logic: Remote Spam, CFrame Bypass, and FireTouchInterest
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("GnomHub | Private", "Midnight")

-- ГЛАВНАЯ ВКЛАДКА
local Main = Window:NewTab("GnomPower")
local LaggerSection = Main:NewSection("Destruction (Лаггеры)")

-- 1. УЛЬТРА ПАКЕТНЫЙ ЛАГГЕР (Gnom-Lag)
LaggerSection:NewButton("PACKET LAG: FREEZE SERVER", "Жуткие лаги у всех", function()
    -- На основе анализа спама символами
    for i = 1, 3000 do
        spawn(function()
            local chat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
            if chat then
                chat.SayMessageRequest:FireServer(string.rep("█", 250), "All")
            end
            -- Смена состояния для перегрузки физики
            game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.StrafingNoPhysics)
        end)
    end
end)

LaggerSection:NewToggle("Lag Aura", "Постоянные пакеты вокруг тебя", function(state)
    _G.GnomLagAura = state
    while _G.GnomLagAura do
        task.wait(0.05)
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    end
end)

-- ВКЛАДКА ВИЗУАЛА (ESP)
local VisualTab = Window:NewTab("Vision (ВХ)")
local ESPSection = VisualTab:NewSection("Качественное ВХ")

ESPSection:NewToggle("ESP Игроков", "Красная обводка сквозь стены", function(state)
    _G.PlayerESP = state
    game:GetService("RunService").RenderStepped:Connect(function()
        if _G.PlayerESP then
            for _, p in pairs(game.Players:GetChildren()) do
                if p ~= game.Players.LocalPlayer and p.Character and not p.Character:FindFirstChild("GnomHighlight") then
                    local h = Instance.new("Highlight", p.Character)
                    h.Name = "GnomHighlight"
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
            end
        else
            for _, p in pairs(game.Players:GetChildren()) do
                if p.Character and p.Character:FindFirstChild("GnomHighlight") then
                    p.Character.GnomHighlight:Destroy()
                end
            end
        end
    end)
end)

ESPSection:NewButton("Подсветить Дорогой Браинрот", "Зеленое ВХ на предметы", function()
    -- Реальный поиск по TouchInterest
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("TouchInterest") and obj.Parent:IsA("BasePart") then
            local h = Instance.new("Highlight", obj.Parent)
            h.FillColor = Color3.fromRGB(0, 255, 0)
            h.AlwaysOnTop = true
        end
    end
end)

-- ВКЛАДКА ДВИЖЕНИЯ
local MoveTab = Window:NewTab("Movement")
local MoveSection = MoveTab:NewSection("Bypasses")

-- 2. REAL NOCLIP (Улучшенный метод)
MoveSection:NewToggle("Gnom Noclip", "Проход сквозь всё без тепа", function(state)
    _G.GnomNoclip = state
    game:GetService("RunService").Stepped:Connect(function()
        if _G.GnomNoclip and game.Players.LocalPlayer.Character then
            for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            -- Стабилизация для обхода анти-чита
            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0.1, 0)
        end
    end)
end)

-- 3. CFRAME SPEED (Безопасное ускорение)
MoveSection:NewSlider("Gnom Speed", "Телепорт-ускорение", 500, 16, function(s)
    _G.GnomSpeedValue = s
    game:GetService("RunService").Heartbeat:Connect(function()
        if _G.GnomSpeedValue > 16 and game.Players.LocalPlayer.Character then
            local moveDir = game.Players.LocalPlayer.Character.Humanoid.MoveDirection
            if moveDir.Magnitude > 0 then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + (moveDir * (_G.GnomSpeedValue / 150))
            end
        end
    end)
end)

-- ВКЛАДКА КРАСОТЫ
local StyleTab = Window:NewTab("Style")
local StyleSection = StyleTab:NewSection("Gnom Appearance")

StyleSection:NewButton("ForceField + Aura", "Стать красивым", function()
    -- Реальное изменение материала
    local char = game.Players.LocalPlayer.Character
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.ForceField
            v.Color = Color3.fromRGB(150, 0, 255)
        end
    end
end)
