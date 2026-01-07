-- ===== PERFECT NOCLIP v6 - FIXED SPEED =====
-- Исправлены все баги скорости, идеальное управление

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua", true))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Ожидаем персонажа
repeat task.wait() until LocalPlayer.Character

local Window = WindUI:CreateWindow({
    Title = "GnomHub Noclip Pro",
    Icon = "rbxassetid://114691672281339",
    Author = "by GnomHub Team",
    Folder = "GnomHub_Noclip_Pro"
})

local MainTab = Window:Tab({ Title = "Noclip", Icon = "eye-off" })

-- === СИСТЕМНЫЕ ПЕРЕМЕННЫЕ === --
local NoclipActive = false
local NoclipConnection = nil
local PositionSaver = nil
local LastValidPosition = nil
local CurrentSpeed = 15  -- Нормальная скорость по умолчанию
local MaxSpeed = 30
local MinSpeed = 1
local MovementEnabled = true
local AntiFallActive = true
local SpeedMultiplier = 1.0

-- === ФУНКЦИЯ НОРМАЛИЗАЦИИ СКОРОСТИ === --
local function GetAdjustedSpeed()
    -- Базовая скорость с учетом множителя
    local baseSpeed = CurrentSpeed * SpeedMultiplier
    
    -- Учет FPS для стабильности
    local fps = 1 / RunService.RenderStepped:Wait()
    local fpsFactor = math.clamp(fps / 60, 0.5, 2.0)
    
    -- Финальная скорость
    return (baseSpeed / 100) * fpsFactor
end

-- === СИСТЕМА ПЛАВНОГО ДВИЖЕНИЯ === --
local function SmoothNoclipMovement()
    if not LocalPlayer.Character then return end
    
    local character = LocalPlayer.Character
    local root = character:WaitForChild("HumanoidRootPart")
    local camera = workspace.CurrentCamera
    
    -- Сохраняем оригинальные коллизии
    local originalCollisions = {}
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            originalCollisions[part] = part.CanCollide
            part.CanCollide = false
        end
    end
    
    -- Переменные для плавности
    local currentVelocity = Vector3.new(0, 0, 0)
    local targetVelocity = Vector3.new(0, 0, 0)
    local smoothFactor = 0.2  -- Коэффициент плавности (0-1)
    
    -- Основной цикл движения
    NoclipConnection = RunService.RenderStepped:Connect(function(deltaTime)
        if not NoclipActive or not character then
            if NoclipConnection then
                NoclipConnection:Disconnect()
            end
            return
        end
        
        -- 1. Получаем ввод пользователя
        local inputVector = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            inputVector = inputVector + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            inputVector = inputVector - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            inputVector = inputVector - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            inputVector = inputVector + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            inputVector = inputVector + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            inputVector = inputVector + Vector3.new(0, -1, 0)
        end
        
        -- 2. Нормализуем и применяем скорость
        if inputVector.Magnitude > 0 then
            inputVector = inputVector.Unit  -- Нормализуем
            local adjustedSpeed = GetAdjustedSpeed()
            targetVelocity = inputVector * adjustedSpeed
        else
            targetVelocity = Vector3.new(0, 0, 0)  -- Останавливаемся
        end
        
        -- 3. Плавная интерполяция скорости
        currentVelocity = currentVelocity:Lerp(targetVelocity, smoothFactor)
        
        -- 4. Применяем движение с учетом дельты времени
        if currentVelocity.Magnitude > 0.01 then  -- Минимальный порог
            -- Движение относительно камеры
            local moveDelta = currentVelocity * deltaTime * 60
            
            -- Плавное перемещение
            local newCFrame = root.CFrame + moveDelta
            
            -- Сохраняем вращение
            root.CFrame = CFrame.new(
                newCFrame.Position,
                newCFrame.Position + camera.CFrame.LookVector
            )
            
            -- Сохраняем безопасную позицию
            if IsPositionSafe(root.Position) then
                LastValidPosition = root.Position
            end
        end
        
        -- 5. Обновляем CanCollide (на всякий случай)
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
    
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
    end
end

-- === ФУНКЦИИ БЕЗОПАСНОСТИ === --
local function IsPositionSafe(position)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local result = workspace:Raycast(
        position + Vector3.new(0, 5, 0),
        Vector3.new(0, -50, 0),
        raycastParams
    )
    
    return result and result.Position.Y > -10
end

local function CreateAntiFallSystem()
    task.spawn(function()
        while NoclipActive do
            if LocalPlayer.Character then
                local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local currentY = root.Position.Y
                    
                    -- Если слишком низко
                    if currentY < -20 then
                        WindUI:Notify({
                            Title = "Anti-Fall",
                            Content = "Обнаружено падение! Восстановление...",
                            Icon = "alert-triangle",
                            Duration = 2
                        })
                        
                        if LastValidPosition then
                            -- Плавный возврат
                            for i = 1, 20 do
                                if root then
                                    root.CFrame = CFrame.new(
                                        root.Position:Lerp(LastValidPosition + Vector3.new(0, 5, 0), i/20),
                                        root.CFrame.LookVector
                                    )
                                end
                                task.wait(0.03)
                            end
                        end
                    end
                    
                    -- Регулярное сохранение позиции
                    if currentY > 5 then
                        LastValidPosition = root.Position
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end

-- === ИНТЕРФЕЙС === --
local restoreFunction = nil

-- Главная кнопка
MainTab:Toggle({
    Title = "🔄 Perfect Noclip",
    Desc = "Включить/выключить идеальный ноклип",
    Callback = function(state)
        NoclipActive = state
        
        if state then
            -- Запуск
            restoreFunction = SmoothNoclipMovement()
            
            -- Защита от падения
            if AntiFallActive then
                CreateAntiFallSystem()
            end
            
            WindUI:Notify({
                Title = "Noclip Activated",
                Content = string.format("Скорость: %d | Управление: WASD + Space/Shift", CurrentSpeed),
                Icon = "eye-off",
                Duration = 4
            })
            
            -- Автосохранение позиции
            task.spawn(function()
                while NoclipActive do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LastValidPosition = LocalPlayer.Character.HumanoidRootPart.Position
                    end
                    task.wait(2)
                end
            end)
            
        else
            -- Остановка
            NoclipActive = false
            
            if restoreFunction then
                restoreFunction()
                restoreFunction = nil
            end
            
            WindUI:Notify({
                Title = "Noclip Deactivated",
                Content = "Движение остановлено",
                Icon = "eye",
                Duration = 2
            })
        end
    end
})

-- Настройка скорости
MainTab:Slider({
    Title = "Скорость движения",
    Desc = "Точная настройка скорости (1-30)",
    Min = MinSpeed,
    Max = MaxSpeed,
    Default = CurrentSpeed,
    Callback = function(value)
        CurrentSpeed = value
        
        WindUI:Notify({
            Title = "Скорость изменена",
            Content = string.format("Новая скорость: %d", value),
            Icon = "zap",
            Duration = 2
        })
    end
})

-- Множитель скорости
MainTab:Slider({
    Title = "Множитель скорости",
    Desc = "Тонкая регулировка (0.1x - 2.0x)",
    Min = 10,
    Max = 200,
    Default = 100,
    Callback = function(value)
        SpeedMultiplier = value / 100
        
        WindUI:Notify({
            Title = "Множитель",
            Content = string.format("Установлен: %.1fx", SpeedMultiplier),
            Icon = "activity",
            Duration = 1
        })
    end
})

-- Anti-Fall Protection
MainTab:Toggle({
    Title = "Anti-Fall Protection",
    Desc = "Защита от падения сквозь пол",
    Default = true,
    Callback = function(state)
        AntiFallActive = state
        
        WindUI:Notify({
            Title = "Anti-Fall",
            Content = state and "Включена" or "Выключена",
            Icon = "shield",
            Duration = 1
        })
    end
})

-- Кнопка сброса позиции
MainTab:Button({
    Title = "Сбросить позицию",
    Desc = "Вернуться к последней безопасной позиции",
    Callback = function()
        if LastValidPosition and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(LastValidPosition + Vector3.new(0, 3, 0))
                
                WindUI:Notify({
                    Title = "Позиция сброшена",
                    Content = "Возврат к безопасной позиции",
                    Icon = "rotate-ccw",
                    Duration = 2
                })
            end
        end
    end
})

-- Кнопка теста скорости
MainTab:Button({
    Title = "Тест скорости",
    Desc = "Проверка текущей скорости движения",
    Callback = function()
        if LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local fps = math.floor(1 / RunService.RenderStepped:Wait())
                local adjustedSpeed = GetAdjustedSpeed() * 100
                
                WindUI:Notify({
                    Title = "Тест скорости",
                    Content = string.format("FPS: %d | Скорость: %.1f", fps, adjustedSpeed),
                    Icon = "gauge",
                    Duration = 3
                })
            end
        end
    end
})

-- Система мониторинга
task.spawn(function()
    local lastPosition = nil
    local lastTime = tick()
    
    while true do
        if NoclipActive and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local currentTime = tick()
                local currentPosition = root.Position
                
                if lastPosition then
                    local distance = (currentPosition - lastPosition).Magnitude
                    local timeDelta = currentTime - lastTime
                    local actualSpeed = distance / timeDelta
                    
                    -- Предупреждение о слишком высокой скорости
                    if actualSpeed > 50 then
                        WindUI:Notify({
                            Title = "⚠️ Внимание!",
                            Content = string.format("Слишком высокая скорость: %.1f", actualSpeed),
                            Icon = "alert-circle",
                            Duration = 2
                        })
                        
                        -- Автокоррекция
                        CurrentSpeed = math.max(MinSpeed, CurrentSpeed * 0.8)
                    end
                end
                
                lastPosition = currentPosition
                lastTime = currentTime
            end
        end
        task.wait(1)
    end
end)

-- Автовосстановление при смерти
LocalPlayer.CharacterAdded:Connect(function()
    if NoclipActive then
        task.wait(1)
        
        NoclipActive = false
        if restoreFunction then
            restoreFunction()
            restoreFunction = nil
        end
        
        task.wait(1)
        
        -- Автоматический перезапуск
        if LocalPlayer.Character then
            task.wait(0.5)
            NoclipActive = true
            restoreFunction = SmoothNoclipMovement()
            
            WindUI:Notify({
                Title = "Auto-Restart",
                Content = "Noclip автоматически восстановлен",
                Icon = "refresh-cw",
                Duration = 3
            })
        end
    end
end)

Window:SelectTab(1)

-- Стартовое сообщение
task.wait(1)
WindUI:Notify({
    Title = "GnomHub Noclip Pro",
    Content = "Загружен. Настройте скорость перед использованием.",
    Icon = "settings",
    Duration = 4
})

print("✅ GnomHub Noclip Pro загружен")
print("✅ Баги скорости исправлены")
print("✅ Точный контроль: " .. CurrentSpeed .. " единиц")
print("✅ Anti-Fall: " .. (AntiFallActive and "Включена" or "Выключена"))
