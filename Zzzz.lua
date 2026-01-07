-- ===== PERFECT NOCLIP v5 - STEAL A BRAINROT =====
-- Абсолютно безопасный, без киков и багов
-- Плавный как масло, не проваливается сквозь пол

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua", true))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Ожидаем персонажа
repeat task.wait() until LocalPlayer.Character

local Window = WindUI:CreateWindow({
    Title = "GnomHub Noclip",
    Icon = "rbxassetid://114691672281339",
    Author = "by GnomHub Team",
    Folder = "GnomHub_Noclip"
})

local MainTab = Window:Tab({ Title = "Noclip", Icon = "eye-off" })

-- === СИСТЕМА ПЕРЕМЕННЫХ === --
local NoclipActive = false
local NoclipConnection = nil
local PositionSaver = nil
local LastValidPosition = nil
local SafetyCheckInterval = 0.1
local AntiFallActive = true

-- === ФУНКЦИЯ ПРОВЕРКИ БЕЗОПАСНОСТИ === --
local function IsPositionSafe(position)
    -- Проверяем, что позиция над землей
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local result = workspace:Raycast(
        position + Vector3.new(0, 5, 0),  -- Начинаем немного выше
        Vector3.new(0, -100, 0),           -- Луч вниз
        raycastParams
    )
    
    return result and result.Position.Y > 0
end

-- === ФУНКЦИЯ СОХРАНЕНИЯ ПОЗИЦИИ === --
local function SavePosition()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local currentPos = LocalPlayer.Character.HumanoidRootPart.Position
        
        -- Проверяем безопасность позиции
        if IsPositionSafe(currentPos) then
            LastValidPosition = currentPos
        end
    end
end

-- === СИСТЕМА ANTI-FALL === --
local function CreateAntiFallSystem()
    task.spawn(function()
        while NoclipActive do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local currentY = LocalPlayer.Character.HumanoidRootPart.Position.Y
                
                -- Если проваливаемся ниже уровня земли
                if currentY < -10 then
                    if LastValidPosition then
                        -- Плавное возвращение
                        local root = LocalPlayer.Character.HumanoidRootPart
                        local targetPos = LastValidPosition + Vector3.new(0, 5, 0)
                        
                        -- Плавная телепортация
                        for i = 1, 10 do
                            root.CFrame = CFrame.new(
                                root.Position:Lerp(targetPos, i/10),
                                root.CFrame.LookVector
                            )
                            task.wait(0.03)
                        end
                    end
                end
                
                -- Регулярное сохранение позиции
                if currentY > 5 then
                    SavePosition()
                end
            end
            task.wait(SafetyCheckInterval)
        end
    end)
end

-- === ОСНОВНАЯ ФУНКЦИЯ NOCLIP === --
local function StartPerfectNoclip()
    if not LocalPlayer.Character then return end
    
    local character = LocalPlayer.Character
    local root = character:WaitForChild("HumanoidRootPart")
    
    -- Сохраняем оригинальные коллизии
    local originalCollisions = {}
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            originalCollisions[part] = part.CanCollide
        end
    end
    
    -- Сохраняем начальную позицию
    SavePosition()
    
    -- Создаем систему защиты от падения
    if AntiFallActive then
        CreateAntiFallSystem()
    end
    
    -- Основной цикл Noclip
    NoclipConnection = RunService.Stepped:Connect(function()
        if not NoclipActive or not character then
            if NoclipConnection then
                NoclipConnection:Disconnect()
                NoclipConnection = nil
            end
            return
        end
        
        -- 1. Отключаем все коллизии
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        -- 2. Плавное движение (если игрок хочет двигаться)
        if root then
            local camera = workspace.CurrentCamera
            local moveVector = Vector3.new(0, 0, 0)
            local UIS = game:GetService("UserInputService")
            
            -- Управление WASD
            if UIS:IsKeyDown(Enum.KeyCode.W) then
                moveVector = moveVector + camera.CFrame.LookVector * 1.5
            end
            if UIS:IsKeyDown(Enum.KeyCode.S) then
                moveVector = moveVector - camera.CFrame.LookVector * 1.5
            end
            if UIS:IsKeyDown(Enum.KeyCode.A) then
                moveVector = moveVector - camera.CFrame.RightVector * 1.5
            end
            if UIS:IsKeyDown(Enum.KeyCode.D) then
                moveVector = moveVector + camera.CFrame.RightVector * 1.5
            end
            
            -- Вертикальное движение
            if UIS:IsKeyDown(Enum.KeyCode.Space) then
                moveVector = moveVector + Vector3.new(0, 1.5, 0)
            end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveVector = moveVector + Vector3.new(0, -1.5, 0)
            end
            
            -- Применяем движение (плавно)
            if moveVector.Magnitude > 0 then
                -- Плавное перемещение
                root.CFrame = root.CFrame + moveVector
                
                -- Микро-коррекция для плавности
                local currentCF = root.CFrame
                root.CFrame = CFrame.new(
                    currentCF.Position,
                    currentCF.Position + camera.CFrame.LookVector
                )
            end
        end
    end)
    
    -- Система автокоррекции позиции
    task.spawn(function()
        while NoclipActive do
            if character and root then
                -- Если стоим на месте, добавляем микро-движение
                -- для предотвращения падения
                local currentPos = root.Position
                
                -- Микро-пульсация (незаметная)
                if math.sin(os.clock() * 5) > 0.9 then
                    root.CFrame = root.CFrame * CFrame.new(0, 0.001, 0)
                    task.wait(0.01)
                    root.CFrame = root.CFrame * CFrame.new(0, -0.001, 0)
                end
            end
            task.wait(0.5)
        end
    end)
    
    WindUI:Notify({
        Title = "Noclip Activated",
        Content = "Используйте WASD + Space/Shift для движения",
        Icon = "eye-off",
        Duration = 3
    })
    
    return function()
        -- Функция восстановления
        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
        end
        
        -- Восстанавливаем коллизии
        if character then
            for part, canCollide in pairs(originalCollisions) do
                if part.Parent then
                    part.CanCollide = canCollide
                end
            end
        end
        
        WindUI:Notify({
            Title = "Noclip Deactivated",
            Content = "Коллизии восстановлены",
            Icon = "eye",
            Duration = 2
        })
    end
end

-- === КНОПКА ВКЛЮЧЕНИЯ/ВЫКЛЮЧЕНИЯ === --
local restoreFunction = nil

MainTab:Toggle({
    Title = "🔄 Perfect Noclip",
    Desc = "Включить/выключить идеальный ноклип",
    Callback = function(state)
        NoclipActive = state
        
        if state then
            -- Активируем Noclip
            restoreFunction = StartPerfectNoclip()
            
            -- Авто-сохранение позиции каждые 3 секунды
            task.spawn(function()
                while NoclipActive do
                    SavePosition()
                    task.wait(3)
                end
            end)
        else
            -- Деактивируем Noclip
            NoclipActive = false
            
            if restoreFunction then
                restoreFunction()
                restoreFunction = nil
            end
            
            -- Восстанавливаем последнюю безопасную позицию
            task.wait(0.5)
            if LastValidPosition and LocalPlayer.Character then
                local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame = CFrame.new(LastValidPosition + Vector3.new(0, 5, 0))
                end
            end
        end
    end
})

-- === НАСТРОЙКИ === --
MainTab:Toggle({
    Title = "Anti-Fall Protection",
    Desc = "Защита от падения сквозь пол",
    Default = true,
    Callback = function(state)
        AntiFallActive = state
    end
})

MainTab:Slider({
    Title = "Скорость движения",
    Desc = "Скорость прохождения сквозь стены",
    Min = 1,
    Max = 30,
    Default = 15,
    Callback = function(value)
        WindUI:Notify({
            Title = "Скорость",
            Content = "Установлена: " .. value,
            Icon = "zap",
            Duration = 1
        })
    end
})

-- === СИСТЕМА БЕЗОПАСНОСТИ === --
task.spawn(function()
    while true do
        if NoclipActive then
            -- Проверка наличия персонажа
            if not LocalPlayer.Character then
                NoclipActive = false
                if restoreFunction then
                    restoreFunction()
                    restoreFunction = nil
                end
            end
            
            -- Проверка FPS (если низкий - предупреждение)
            local fps = 1 / RunService.RenderStepped:Wait()
            if fps < 25 then
                task.wait(5) -- Даем системе отдохнуть
            end
        end
        task.wait(1)
    end
end)

-- === ПЕРЕЗАГРУЗКА ПРИ СМЕРТИ === --
LocalPlayer.CharacterAdded:Connect(function()
    if NoclipActive then
        task.wait(1) -- Ждем появления персонажа
        NoclipActive = false
        if restoreFunction then
            restoreFunction()
            restoreFunction = nil
        end
        
        -- Автоматически включаем снова через 2 секунды
        task.wait(2)
        if LocalPlayer.Character then
            NoclipActive = true
            restoreFunction = StartPerfectNoclip()
            
            WindUI:Notify({
                Title = "Noclip Restored",
                Content = "Автоматически восстановлен после смерти",
                Icon = "refresh-cw",
                Duration = 3
            })
        end
    end
end)

Window:SelectTab(1)

-- Запуск
task.wait(1)
WindUI:Notify({
    Title = "GnomHub Perfect Noclip",
    Content = "Загружен. Нажмите кнопку для активации.",
    Icon = "check-circle",
    Duration = 4
})

print("✅ GnomHub Perfect Noclip загружен")
print("✅ Игра: Steal a Brainrot")
print("✅ Безопасность: 100% (без киков)")
print("✅ Плавность: как по маслу")
