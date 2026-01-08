local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local savedCFrame = nil
local isMoving = false

local Window = WindUI:CreateWindow({
    Title = "SAB BYPASS v4",
    Icon = "rbxassetid://114691672281339",
    Author = "Steal Expert",
    Folder = "AntiKickData"
})

local MainTab = Window:Tab({ Title = "Главная", Icon = "shield" })

-- Улучшенная функция перемещения шагами
local function bypassMove(targetCF)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    
    if root and not isMoving then
        isMoving = true
        
        -- Скрываем состояние падения, чтобы античит не сработал
        local stateConn = hum.StateChanged:Connect(function(_, newState)
            if newState == Enum.HumanoidStateType.FallingDown or newState == Enum.HumanoidStateType.Ragdoll then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)

        -- Отключаем коллизию (NoClip) на время пути
        local noclipping = RunService.Stepped:Connect(function()
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end)

        -- Движение маленькими шагами (3.5 единицы за шаг)
        local stepDistance = 3.5
        while (root.Position - targetCF.Position).Magnitude > stepDistance do
            local direction = (targetCF.Position - root.Position).Unit
            root.CFrame = root.CFrame + (direction * stepDistance)
            task.wait(0.01) -- Микро-пауза для сервера
        end

        -- Финальное позиционирование
        root.CFrame = targetCF
        
        -- Чистим за собой
        stateConn:Disconnect()
        noclipping:Disconnect()
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
        
        isMoving = false
        WindUI:Notify({Title = "Система", Content = "Успешный возврат!", Icon = "check"})
    end
end

MainTab:Button({
    Title = "1. SET POS (На базе)",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            savedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            WindUI:Notify({Title = "Успех", Content = "База сохранена", Icon = "home"})
        end
    end
})

MainTab:Button({
    Title = "2. BYPASS TP (Домой)",
    Desc = "Медленный, но безопасный возврат без кика",
    Callback = function()
        if savedCFrame then
            bypassMove(savedCFrame)
        else
            WindUI:Notify({Title = "Ошибка", Content = "Поставь метку!", Icon = "alert-circle"})
        end
    end
})

-- Авто-Продажа (если есть зона продажи на твоей базе)
MainTab:Toggle({
    Title = "Авто-продажа по прилету",
    Default = true,
    Callback = function(t) _G.AutoSellOnTP = t end
})
