-- Загрузка WindUI (используем стабильную версию из твоих файлов)
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local savedCFrame = nil
local isTeleporting = false

-- Создание окна
local Window = WindUI:CreateWindow({
    Title = "SAB EXPLOIT",
    Icon = "rbxassetid://114691672281339", -- Иконка GnomHub
    Author = "VIP VERSION",
    Folder = "SAB_Data"
})

local MainTab = Window:Tab({ Title = "Кража", Icon = "shopping-cart" })

-- Логирование (то, что ты просил - вывод инфы)
local function logInfo(msg)
    print("[SAB LOG]: " .. tostring(msg))
    WindUI:Notify({
        Title = "Система",
        Content = msg,
        Icon = "info"
    })
end

-- Функция безопасного полета на базу (Анти-рестарт)
local function tweenToBase()
    if not savedCFrame then 
        logInfo("Сначала сохрани позицию базы!")
        return 
    end
    
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if root and not isTeleporting then
        isTeleporting = true
        logInfo("Начинаю безопасный возврат...")

        -- Отключаем гравитацию и коллизию (чтобы сервер не кикнул за столкновение)
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(0,0,0)
        bv.Parent = root
        
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end

        -- Рассчитываем время полета (скорость 300 - это предел безопасности)
        local dist = (root.Position - savedCFrame.Position).Magnitude
        local duration = dist / 300 

        local tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = savedCFrame})
        
        tween:Play()
        tween.Completed:Wait()

        -- Возвращаем всё в норму
        bv:Destroy()
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
        
        isTeleporting = false
        logInfo("Доставлено! Браинрот на базе.")
    end
end

-- КНОПКИ
MainTab:Button({
    Title = "ПОСТАВИТЬ ПОЗИЦИЮ (Set Pos)",
    Desc = "Запомнить это место как дом",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            savedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            logInfo("База установлена на координатах: " .. tostring(math.floor(savedCFrame.X)))
        end
    end
})

MainTab:Button({
    Title = "ТП БАЗА (Safe TP)",
    Desc = "Украсть и улететь (Без кика)",
    Callback = function()
        tweenToBase()
    end
})

-- Дополнительно: NoClip для захода на базы
MainTab:Toggle({
    Title = "Проход сквозь стены (NoClip)",
    Callback = function(state)
        _G.NoClip = state
        task.spawn(function()
            while _G.NoClip do
                if LocalPlayer.Character then
                    for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = false end
                    end
                end
                RunService.Stepped:Wait()
            end
        end)
    end
})

logInfo("Скрипт готов к работе. Delta Injector OK.")
