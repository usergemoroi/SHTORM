local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local savedCFrame = nil
local isTeleporting = false

local Window = WindUI:CreateWindow({
    Title = "Safe Stealer v3",
    Icon = "rbxassetid://114691672281339",
    Author = "Anti-Kick Edition",
    Folder = "SafeStealData"
})

local MainTab = Window:Tab({ Title = "Кража", Icon = "shopping-cart" })

-- Функция плавного перемещения (обход античита)
local function safeTween(targetCF)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if root and not isTeleporting then
        isTeleporting = true
        
        -- Вычисляем расстояние для подбора скорости
        local distance = (root.Position - targetCF.Position).Magnitude
        local speed = 350 -- Оптимальная скорость, чтобы не кикнуло (можно менять)
        local duration = distance / speed
        
        -- Отключаем столкновения, чтобы не застрять в текстурах по пути
        local parts = char:GetDescendants()
        for _, v in pairs(parts) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end

        local tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCF})
        
        tween:Play()
        tween.Completed:Wait()
        
        -- Включаем столкновения обратно
        for _, v in pairs(parts) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
        
        isTeleporting = false
        WindUI:Notify({Title = "Успех", Content = "Доставлено на базу!", Icon = "check"})
    end
end

MainTab:Button({
    Title = "1. SET POS (База)",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            savedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            WindUI:Notify({Title = "Система", Content = "Позиция дома сохранена", Icon = "home"})
        end
    end
})

MainTab:Button({
    Title = "2. SAFE TP (Домой)",
    Desc = "Плавный телепорт для обхода античита",
    Callback = function()
        if savedCFrame then
            safeTween(savedCFrame)
        else
            WindUI:Notify({Title = "Ошибка", Content = "Сначала сохрани позицию!", Icon = "alert-circle"})
        end
    end
})

-- Функция NoClip (проход сквозь стены)
MainTab:Toggle({
    Title = "Ходить сквозь стены",
    Callback = function(state)
        _G.NoClip = state
        game:GetService("RunService").Stepped:Connect(function()
            if _G.NoClip and LocalPlayer.Character then
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
    end
})
