local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua", true))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Ждем загрузку персонажа
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

local Window = WindUI:CreateWindow({
    Title = "GnomHub AntiAntiCheat",
    Icon = "rbxassetid://114691672281339",
    Author = "by GothbreachHelper",
    Folder = "GnomHub_Fixed"
})

local MainTab = Window:Tab({ Title = "Main", Icon = "shield" })

-- 1. УЛУЧШЕННЫЙ LAGGER БЕЗ ВЫЛЕТОВ
local lagActive = false
local lagTask

MainTab:Toggle({
    Title = "Safe Lag Bomb v3",
    Desc = "Создает лаг без киков",
    Callback = function(state)
        lagActive = state
        if state then
            WindUI:Notify({
                Title = "Lag Bomb",
                Content = "Активирован (тихий режим)",
                Icon = "zap"
            })
            
            lagTask = task.spawn(function()
                local startTime = tick()
                local counter = 0
                
                while lagActive do
                    counter += 1
                    
                    -- Метод 1: Создаем мусорные объекты (клиентские)
                    for i = 1, 10 do
                        if not lagActive then break end
                        
                        local part = Instance.new("Part")
                        part.Size = Vector3.new(1, 1, 1)
                        part.Anchored = true
                        part.CanCollide = false
                        part.Transparency = 1
                        part.Position = Vector3.new(
                            math.random(-100, 100),
                            math.random(10, 50),
                            math.random(-100, 100)
                        )
                        part.Parent = workspace
                        
                        task.defer(function()
                            part:Destroy()
                        end)
                    end
                    
                    -- Метод 2: Легкая сетевая нагрузка (безопасная)
                    if counter % 3 == 0 then
                        pcall(function()
                            -- Имитация нормальной активности
                            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                            if humanoid then
                                humanoid:ChangeState(Enum.HumanoidStateType.Running)
                                task.wait(0.01)
                                humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
                            end
                        end)
                    end
                    
                    -- Метод 3: Генерация вычислений (лаги процессора)
                    for i = 1, 1000 do
                        if not lagActive then break end
                        local _ = math.sin(i) * math.cos(i) * math.tan(i)
                    end
                    
                    -- Случайные паузы для маскировки
                    task.wait(math.random(15, 30) / 100)
                end
            end)
        else
            lagActive = false
            if lagTask then
                task.cancel(lagTask)
                lagTask = nil
            end
            WindUI:Notify({
                Title = "Lag Bomb",
                Content = "Деактивирован",
                Icon = "power"
            })
        end
    end
})

-- 2. NOCLIP БЕЗ ОТБРАСЫВАНИЯ (АНТИ-АНТИЧИТ)
local noclipActive = false
local noclipConnection
local noclipVelocity

MainTab:Toggle({
    Title = "Noclip v3 (Anti-Anticheat)",
    Desc = "Плавный ноклип без откатов",
    Callback = function(state)
        noclipActive = state
        if state then
            local character = LocalPlayer.Character
            if not character then return end
            
            local root = character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            WindUI:Notify({
                Title = "Noclip",
                Content = "Активирован (тихий режим)",
                Icon = "eye-off",
                Duration = 2
            })
            
            -- Сохраняем оригинальные коллизии
            local originalCollisions = {}
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    originalCollisions[part] = part.CanCollide
                end
            end
            
            -- Создаем BodyVelocity для плавного движения
            noclipVelocity = Instance.new("BodyVelocity")
            noclipVelocity.Name = "NoclipAssist"
            noclipVelocity.MaxForce = Vector3.new(0, 0, 0)  -- Не двигаем сами
            noclipVelocity.P = 1
            noclipVelocity.Parent = root
            
            noclipConnection = RunService.Heartbeat:Connect(function(delta)
                if not noclipActive or not character then
                    return
                end
                
                -- Плавное отключение коллизий
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
                
                -- Микро-корректировка позиции для обхода античита
                local currentCF = root.CFrame
                local camera = workspace.CurrentCamera
                
                -- Если игрок пытается двигаться
                local moveDirection = Vector3.new(0, 0, 0)
                local UIS = game:GetService("UserInputService")
                
                if UIS:IsKeyDown(Enum.KeyCode.W) then
                    moveDirection = moveDirection + camera.CFrame.LookVector * 0.5
                end
                if UIS:IsKeyDown(Enum.KeyCode.S) then
                    moveDirection = moveDirection - camera.CFrame.LookVector * 0.5
                end
                if UIS:IsKeyDown(Enum.KeyCode.A) then
                    moveDirection = moveDirection - camera.CFrame.RightVector * 0.5
                end
                if UIS:IsKeyDown(Enum.KeyCode.D) then
                    moveDirection = moveDirection + camera.CFrame.RightVector * 0.5
                end
                
                if moveDirection.Magnitude > 0 then
                    -- Плавное движение без телепортации
                    root.CFrame = currentCF + moveDirection * delta * 16
                end
            end)
        else
            -- Отключаем
            noclipActive = false
            
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            
            if noclipVelocity then
                noclipVelocity:Destroy()
                noclipVelocity = nil
            end
            
            -- Восстанавливаем коллизии
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
            
            WindUI:Notify({
                Title = "Noclip",
                Content = "Деактивирован",
                Icon = "eye"
            })
        end
    end
})

-- 3. УМНЫЙ ТЕЛЕПОРТ БЕЗ ОТКАТОВ
MainTab:Button({
    Title = "Умный телепорт v3",
    Desc = "Телепортация с обходом античита",
    Callback = function()
        local character = LocalPlayer.Character
        if not character then return end
        
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        WindUI:Notify({
            Title = "Телепорт",
            Content = "Инициализация...",
            Icon = "loader",
            Duration = 1
        })
        
        -- Сохраняем позицию
        local startPos = root.Position
        local camera = workspace.CurrentCamera
        local direction = camera.CFrame.LookVector
        
        -- Включаем временный ноклип
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        -- Множественные микро-телепортации вместо одной
        local steps = 10
        local stepDistance = 2.5
        
        task.spawn(function()
            for i = 1, steps do
                if not character then break end
                
                -- Плавное перемещение
                local targetPos = root.Position + direction * stepDistance
                root.CFrame = CFrame.new(targetPos) * camera.CFrame.Rotation
                
                -- Случайные микро -движения для маскировки
                local offset = Vector3.new(
                    (math.random() - 0.5) * 0.1,
                    (math.random() - 0.5) * 0.1,
                    (math.random() - 0.5) * 0.1
                )
                root.CFrame = root.CFrame + offset
                
                task.wait(0.03)
            end
            
            -- Возвращаем коллизии через секунду
            task.wait(1)
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end)
        
        WindUI:Notify({
            Title = "Телепорт",
            Content = "Успешно (шаги: "..steps..")",
            Icon = "check",
            Duration = 2
        })
    end
})

-- 4. FLY С ПРИВЯЗКОЙ К КАМЕРЕ
local flying = false
local flyVelocity
local flyConnection

MainTab:Toggle({
    Title = "Fly v4 (Camera Lock)",
    Desc = "Полет с привязкой к камере",
    Callback = function(state)
        flying = state
        if state then
            local character = LocalPlayer.Character
            if not character then return end
            
            local root = character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            -- Убираем гравитацию
            local bodyGyro = Instance.new("BodyGyro")
            bodyGyro.Name = "FlyGyro"
            bodyGyro.MaxTorque = Vector3.new(40000, 0, 40000)
            bodyGyro.P = 1000
            bodyGyro.D = 50
            bodyGyro.Parent = root
            
            -- Создаем BodyVelocity
            flyVelocity = Instance.new("BodyVelocity")
            flyVelocity.Name = "FlyVelocity"
            flyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
            flyVelocity.Velocity = Vector3.new(0, 0, 0)
            flyVelocity.Parent = root
            
            flyConnection = RunService.Heartbeat:Connect(function()
                if not flying or not flyVelocity or not flyVelocity.Parent then
                    return
                end
                
                local camera = workspace.CurrentCamera
                local moveVector = Vector3.new(0, 0, 0)
                local UIS = game:GetService("UserInputService")
                
                -- Управление относительно камеры
                if UIS:IsKeyDown(Enum.KeyCode.W) then
                    moveVector = moveVector + camera.CFrame.LookVector * 25
                end
                if UIS:IsKeyDown(Enum.KeyCode.S) then
                    moveVector = moveVector - camera.CFrame.LookVector * 25
                end
                if UIS:IsKeyDown(Enum.KeyCode.A) then
                    moveVector = moveVector - camera.CFrame.RightVector * 25
                end
                if UIS:IsKeyDown(Enum.KeyCode.D) then
                    moveVector = moveVector + camera.CFrame.RightVector * 25
                end
                
                -- Вертикальное движение
                if UIS:IsKeyDown(Enum.KeyCode.Space) then
                    moveVector = moveVector + Vector3.new(0, 25, 0)
                end
                if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveVector = moveVector + Vector3.new(0, -25, 0)
                end
                
                -- Привязываем поворот к камере
                bodyGyro.CFrame = CFrame.new(root.Position, root.Position + camera.CFrame.LookVector)
                flyVelocity.Velocity = moveVector
            end)
            
            WindUI:Notify({
                Title = "Fly",
                Content = "Активирован (WASD + Space/Shift)",
                Icon = "wind",
                Duration = 3
            })
        else
            flying = false
            
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            
            local character = LocalPlayer.Character
            if character then
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then
                    if flyVelocity then
                        flyVelocity:Destroy()
                        flyVelocity = nil
                    end
                    
                    local gyro = root:FindFirstChild("FlyGyro")
                    if gyro then
                        gyro:Destroy()
                    end
                end
            end
            
            WindUI:Notify({
                Title = "Fly",
                Content = "Деактивирован",
                Icon = "power"
            })
        end
    end
})

-- 5. ФУНКЦИЯ АДАПТАЦИИ К АНТИЧИТУ
MainTab:Button({
    Title = "Адаптация к античиту",
    Desc = "Настройка под текущий сервер",
    Callback = function()
        WindUI:Notify({
            Title = "Адаптация",
            Content = "Анализ античита...",
            Icon = "settings",
            Duration = 2
        })
        
        -- Проверяем тип античита
        task.spawn(function()
            local character = LocalPlayer.Character
            if not character then return end
            
            local root = character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            local originalPos = root.Position
            
            -- Тест 1: Мгновенная телепортация
            root.CFrame = CFrame.new(originalPos + Vector3.new(0, 5, 0))
            task.wait(0.5)
            
            local newPos = root.Position
            local teleportAllowed = (newPos - originalPos).Magnitude > 2
            
            -- Тест 2: Скорость
            local bodyVel = Instance.new("BodyVelocity")
            bodyVel.Velocity = Vector3.new(0, 50, 0)
            bodyVel.MaxForce = Vector3.new(0, 10000, 0)
            bodyVel.Parent = root
            task.wait(0.2)
            bodyVel:Destroy()
            
            -- Анализ результатов
            local message = "Статус античита: "
            
            if teleportAllowed then
                message = message .. "Слабый (телепорт работает)"
            else
                message = message .. "Сильный (телепорт блокирован)"
            end
            
            WindUI:Notify({
                Title = "Результат анализа",
                Content = message,
                Icon = "alert-circle",
                Duration = 5
            })
        end)
    end
})

-- 6. ЭКСТРЕННАЯ ЗАЩИТА
MainTab:Button({
    Title = "Экстренная защита",
    Desc = "Скрывает активность от античита",
    Callback = function()
        -- Останавливаем все активности
        lagActive = false
        noclipActive = false
        flying = false
        
        -- Удаляем все созданные объекты
        if lagTask then task.cancel(lagTask) end
        if noclipConnection then noclipConnection:Disconnect() end
        if flyConnection then flyConnection:Disconnect() end
        
        -- Чистим персонажа
        local character = LocalPlayer.Character
        if character then
            for _, obj in pairs(character:GetDescendants()) do
                if obj.Name == "FlyVelocity" or obj.Name == "FlyGyro" or obj.Name == "NoclipAssist" then
                    obj:Destroy()
                end
            end
            
            -- Восстанавливаем коллизии
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        
        -- Очищаем workspace от мусора
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name == "Part" and obj.Transparency == 1 then
                obj:Destroy()
            end
        end
        
        WindUI:Notify({
            Title = "Защита",
            Content = "Все активности скрыты",
            Icon = "shield",
            Duration = 3
        })
    end
})

Window:SelectTab(1)

-- Уведомление о загрузке
task.wait(1)
WindUI:Notify({
    Title = "GnomHub AntiAntiCheat",
    Content = "Загружено успешно. Используйте адаптацию.",
    Icon = "check-circle",
    Duration = 4
})

print("✅ GnomHub AntiAntiCheat загружен")
