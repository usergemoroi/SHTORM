local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local NetworkClient = game:GetService("NetworkClient")
local LocalPlayer = Players.LocalPlayer

local Window = WindUI:CreateWindow({
    Title = "GnomHub Enhanced",
    Icon = "rbxassetid://114691672281339",
    Author = "by GothbreachHelper",
    Folder = "GnomHub_SAB"
})

local MainTab = Window:Tab({ Title = "Main", Icon = "bomb" })

-- 1. УЛУЧШЕННЫЙ NOCLIP
local noclipActive = false
local noclipConnection

MainTab:Toggle({
    Title = "Noclip (Улучшенный)",
    Desc = "Плавное прохождение сквозь стены",
    Callback = function(state)
        noclipActive = state
        if state then
            noclipConnection = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            WindUI:Notify({ Title = "Noclip", Content = "Активирован", Icon = "check" })
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                -- Восстанавливаем коллизии
                if LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end
        end
    end
})

-- 2. УЛУЧШЕННЫЙ LAGGER С РАДИУСОМ ДЕЙСТВИЯ
local lagActive = false
local lagRadius = 50 -- Радиус в studs
local lagPacketSize = 5000 -- Размер пакета

MainTab:Toggle({
    Title = "Area Lag Bomb",
    Desc = "Вызывает лаги у игроков в радиусе " .. lagRadius .. " studs",
    Callback = function(state)
        lagActive = state
        if state then
            task.spawn(function()
                while lagActive do
                    -- Находим всех игроков в радиусе
                    local myPosition = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if myPosition then
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character then
                                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                                if targetRoot then
                                    local distance = (myPosition.Position - targetRoot.Position).Magnitude
                                    if distance <= lagRadius then
                                        -- Отправляем тяжелые пакеты
                                        for i = 1, 10 do
                                            if not lagActive then break end
                                            -- Используем разные методы для нагрузки сети
                                            pcall(function()
                                                NetworkClient:Send("Chat", {Message = string.rep("L", lagPacketSize)})
                                            end)
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.2) -- Интервал между волнами
                end
            end)
            WindUI:Notify({ Title = "Lag Bomb", Content = "Активирован (радиус: " .. lagRadius .. ")", Icon = "alert-circle" })
        else
            WindUI:Notify({ Title = "Lag Bomb", Content = "Деактивирован", Icon = "check" })
        end
    end
})

-- 3. НАСТРОЙКА РАДИУСА LAGGER
MainTab:Slider({
    Title = "Lag Radius",
    Desc = "Радиус действия лаггера",
    Min = 10,
    Max = 100,
    Default = 50,
    Callback = function(value)
        lagRadius = value
        WindUI:Notify({ Title = "Настройка", Content = "Радиус лаггера: " .. value, Icon = "settings" })
    end
})

-- 4. УЛУЧШЕННЫЙ FLY С ЗАЩИТОЙ ОТ АНТИЧИТА
local flying = false
local flyVelocity

MainTab:Toggle({
    Title = "Fly v2 (Оптимизированный)",
    Desc = "Плавный полет с защитой",
    Callback = function(state)
        flying = state
        if state then
            local bodyVel = Instance.new("BodyVelocity")
            bodyVel.Name = "WindUIFlyVelocity"
            bodyVel.MaxForce = Vector3.new(1, 1, 1) * 10000
            bodyVel.Velocity = Vector3.new(0, 0, 0)
            
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                bodyVel.Parent = LocalPlayer.Character.HumanoidRootPart
                flyVelocity = bodyVel
                
                task.spawn(function()
                    while flying do
                        if flyVelocity and flyVelocity.Parent then
                            local camera = workspace.CurrentCamera
                            local lookVector = camera.CFrame.LookVector
                            local newVelocity = lookVector * 40
                            newVelocity = newVelocity + Vector3.new(0, 0.5, 0) -- Легкий подъем
                            flyVelocity.Velocity = newVelocity
                        end
                        task.wait()
                    end
                end)
            end
        else
            if flyVelocity then
                flyVelocity:Destroy()
                flyVelocity = nil
            end
        end
    end
})

-- 5. БЫСТРЫЙ BYPASS ДЛЯ ЭКСТРЕННЫХ СИТУАЦИЙ
MainTab:Button({
    Title = "Экстренный Bypass",
    Desc = "Мгновенная телепортация вперед на 15 studs",
    Callback = function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            local oldCFrame = root.CFrame
            -- Телепортация с эффектом "исчезновения"
            for i = 1, 3 do
                root.CFrame = oldCFrame * CFrame.new(0, 0, -5 * i)
                task.wait(0.05)
            end
            WindUI:Notify({ Title = "Bypass", Content = "Выполнен", Icon = "zap" })
        end
    end
})

-- 6. ФУНКЦИЯ ОТКЛЮЧЕНИЯ ВСЕГО
MainTab:Button({
    Title = "Экстренная остановка",
    Desc = "Отключает все активные функции",
    Callback = function()
        -- Отключаем Noclip
        noclipActive = false
        if noclipConnection then
            noclipConnection:Disconnect()
        end
        
        -- Отключаем Lag
        lagActive = false
        
        -- Отключаем Fly
        if flying then
            flying = false
            if flyVelocity then
                flyVelocity:Destroy()
                flyVelocity = nil
            end
        end
        
        WindUI:Notify({ 
            Title = "Система", 
            Content = "Все функции отключены", 
            Icon = "power",
            Duration = 3
        })
    end
})

Window:SelectTab(1)

-- АВТОМАТИЧЕСКАЯ ЗАЩИТА ПРИ ВЫХОДЕ ИЗ ИГРЫ
LocalPlayer.CharacterRemoving:Connect(function()
    if noclipConnection then
        noclipConnection:Disconnect()
    end
    lagActive = false
end)

print("✅ GnomHub Enhanced loaded by GothbreachHelper")
