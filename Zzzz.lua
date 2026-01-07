local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua", true))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Ждем загрузку персонажа
repeat task.wait() until LocalPlayer.Character
local Character = LocalPlayer.Character

local Window = WindUI:CreateWindow({
    Title = "GnomHub Anti-Revert",
    Icon = "rbxassetid://114691672281339",
    Author = "by GothbreachHelper",
    Folder = "GnomHub_Fixed"
})

local MainTab = Window:Tab({ Title = "Main", Icon = "shield" })

-- === СИСТЕМА ОБХОДА АНТИЧИТА === --
local LastValidPosition = Character:FindFirstChild("HumanoidRootPart").Position
local PositionBackup = {}
local AntiRevertActive = false
local PositionManager

-- Функция сохранения позиции
local function SavePosition()
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        LastValidPosition = Character.HumanoidRootPart.Position
        table.insert(PositionBackup, LastValidPosition)
        if #PositionBackup > 10 then
            table.remove(PositionBackup, 1)
        end
    end
end

-- Анти-реверт система
task.spawn(function()
    while true do
        if AntiRevertActive and Character and Character:FindFirstChild("HumanoidRootPart") then
            local currentPos = Character.HumanoidRootPart.Position
            local distance = (currentPos - LastValidPosition).Magnitude
            
            -- Если нас телепортировали назад
            if distance > 50 then
                task.wait(0.1)
                Character.HumanoidRootPart.CFrame = CFrame.new(LastValidPosition)
            else
                LastValidPosition = currentPos
            end
        end
        task.wait(0.05)
    end
end)

-- 1. УМНЫЙ TELEPORT (Через Velocity, а не CFrame)
MainTab:Button({
    Title = "Умный телепорт v4",
    Desc = "Телепорт через скорость (обход античита)",
    Callback = function()
        if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
        
        SavePosition()
        
        local root = Character.HumanoidRootPart
        local camera = workspace.CurrentCamera
        local direction = camera.CFrame.LookVector * 25
        
        -- Метод 1: Используем BodyVelocity
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = direction * 2
        bv.MaxForce = Vector3.new(10000, 0, 10000)
        bv.P = 1000
        bv.Parent = root
        
        WindUI:Notify({
            Title = "Телепорт",
            Content = "Используется скорость...",
            Icon = "zap",
            Duration = 1
        })
        
        -- Плавное ускорение
        for i = 1, 10 do
            bv.Velocity = direction * (i / 5)
            task.wait(0.05)
        end
        
        task.wait(0.2)
        bv:Destroy()
        
        -- Метод 2: Постепенное смещение
        local steps = 15
        for i = 1, steps do
            root.CFrame = root.CFrame + direction * 0.1
            task.wait(0.02)
        end
        
        SavePosition()
        
        WindUI:Notify({
            Title = "Телепорт",
            Content = "Успешно (скоростной метод)",
            Icon = "check",
            Duration = 2
        })
    end
})

-- 2. ПЛАВНЫЙ NOCLIP С ЗАХВАТОМ ПОЗИЦИИ
local noclipActive = false
local noclipConnection
local noclipVelocity

MainTab:Toggle({
    Title = "Noclip v4 (Anti-Revert)",
    Desc = "Плавный ноклип с защитой от возврата",
    Callback = function(state)
        noclipActive = state
        if state then
            if not Character or not Character:FindFirstChild("HumanoidRootPart") then
                WindUI:Notify({
                    Title = "Ошибка",
                    Content = "Персонаж не найден",
                    Icon = "alert"
                })
                return
            end
            
            SavePosition()
            AntiRevertActive = true
            
            local root = Character.HumanoidRootPart
            
            -- Сохраняем коллизии
            local originalCollisions = {}
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    originalCollisions[part] = part.CanCollide
                end
            end
            
            -- Создаем BodyVelocity для плавности
            noclipVelocity = Instance.new("BodyVelocity")
            noclipVelocity.Name = "NoclipAntiRevert"
            noclipVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
            noclipVelocity.Velocity = Vector3.new(0, 0, 0)
            noclipVelocity.Parent = root
            
            noclipConnection = RunService.Heartbeat:Connect(function(delta)
                if not noclipActive or not Character then return end
                
                -- Постоянно обновляем позицию
                SavePosition()
                
                -- Отключаем коллизии
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                
                -- Плавное движение
                local moveVector = Vector3.new(0, 0, 0)
                local UIS = game:GetService("UserInputService")
                local camera = workspace.CurrentCamera
                
                if UIS:IsKeyDown(Enum.KeyCode.W) then
                    moveVector = moveVector + camera.CFrame.LookVector * 16
                end
                if UIS:IsKeyDown(Enum.KeyCode.S) then
                    moveVector = moveVector - camera.CFrame.LookVector * 16
                end
                if UIS:IsKeyDown(Enum.KeyCode.A) then
                    moveVector = moveVector - camera.CFrame.RightVector * 16
                end
                if UIS:IsKeyDown(Enum.KeyCode.D) then
                    moveVector = moveVector + camera.CFrame.RightVector * 16
                end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then
                    moveVector = moveVector + Vector3.new(0, 16, 0)
                end
                if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveVector = moveVector + Vector3.new(0, -16, 0)
                end
                
                noclipVelocity.Velocity = moveVector
                
                -- Микро-коррекция против возврата
                root.CFrame = root.CFrame + Vector3.new(
                    (math.random() - 0.5) * 0.01,
                    (math.random() - 0.5) * 0.01,
                    (math.random() - 0.5) * 0.01
                )
            end)
            
            WindUI:Notify({
                Title = "Noclip",
                Content = "Активирован (WASD + Space/Shift)",
                Icon = "eye-off",
                Duration = 3
            })
        else
            noclipActive = false
            AntiRevertActive = false
            
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            
            if noclipVelocity then
                noclipVelocity:Destroy()
                noclipVelocity = nil
            end
            
            -- Восстанавливаем коллизии через 1 секунду
            task.delay(1, function()
                if Character then
                    for _, part in pairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end)
            
            SavePosition()
            
            WindUI:Notify({
                Title = "Noclip",
                Content = "Деактивирован",
                Icon = "eye"
            })
        end
    end
})

-- 3. БЕЗОПАСНЫЙ LAG (Без киков)
local lagActive = false
local lagTask

MainTab:Toggle({
    Title = "Safe Lag v5",
    Desc = "Создает лаг без перезагрузки",
    Callback = function(state)
        lagActive = state
        if state then
            WindUI:Notify({
                Title = "Lag System",
                Content = "Активирован (безопасный режим)",
                Icon = "zap",
                Duration = 2
            })
            
            lagTask = task.spawn(function()
                local lagCounter = 0
                
                while lagActive do
                    lagCounter += 1
                    
                    -- Метод 1: Клиентские вычисления (безопасно)
                    for i = 1, 5000 do
                        if not lagActive then break end
                        local x = math.random()
                        local y = math.random()
                        local z = x * y * math.random()
                        local _ = Vector3.new(x, y, z).Magnitude
                    end
                    
                    -- Метод 2: Создание/удаление невидимых объектов
                    if lagCounter % 5 == 0 then
                        for j = 1, 20 do
                            if not lagActive then break end
                            
                            local part = Instance.new("Part")
                            part.Size = Vector3.new(0.1, 0.1, 0.1)
                            part.Transparency = 1
                            part.Anchored = true
                            part.CanCollide = false
                            part.Position = Vector3.new(
                                math.random(-100, 100),
                                math.random(10, 50),
                                math.random(-100, 100)
                            )
                            part.Parent = workspace.CurrentCamera
                            
                            task.defer(function()
                                part:Destroy()
                            end)
                        end
                    end
                    
                    -- Метод 3: Изменение свойств персонажа (незаметно)
                    if Character and lagCounter % 3 == 0 then
                        pcall(function()
                            local humanoid = Character:FindFirstChild("Humanoid")
                            if humanoid then
                                -- Легкое изменение состояния
                                humanoid.JumpPower = math.random(45, 55)
                                task.wait(0.01)
                                humanoid.JumpPower = 50
                            end
                        end)
                    end
                    
                    -- Случайные паузы для маскировки
                    local waitTime = math.random(5, 15) / 100
                    local start = tick()
                    while tick() - start < waitTime do
                        if not lagActive then break end
                        task.wait()
                    end
                end
            end)
        else
            lagActive = false
            if lagTask then
                task.cancel(lagTask)
                lagTask = nil
            end
            WindUI:Notify({
                Title = "Lag System",
                Content = "Деактивирован",
                Icon = "power"
            })
        end
    end
})

-- 4. ПОЗИЦИОННЫЙ ANCHOR (Защита от телепорта назад)
local anchorActive = false
local anchorBodyPosition

MainTab:Toggle({
    Title = "Position Anchor",
    Desc = "Фиксирует позицию (защита от возврата)",
    Callback = function(state)
        anchorActive = state
        if state then
            if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
            
            SavePosition()
            
            local root = Character.HumanoidRootPart
            
            -- Создаем BodyPosition для фиксации
            anchorBodyPosition = Instance.new("BodyPosition")
            anchorBodyPosition.Name = "PositionAnchor"
            anchorBodyPosition.MaxForce = Vector3.new(40000, 40000, 40000)
            anchorBodyPosition.Position = root.Position
            anchorBodyPosition.P = 10000
            anchorBodyPosition.D = 500
            anchorBodyPosition.Parent = root
            
            -- Периодическое обновление позиции
            task.spawn(function()
                while anchorActive do
                    if anchorBodyPosition and anchorBodyPosition.Parent then
                        anchorBodyPosition.Position = root.Position
                    end
                    task.wait(0.1)
                end
            end)
            
            WindUI:Notify({
                Title = "Anchor",
                Content = "Позиция зафиксирована",
                Icon = "anchor",
                Duration = 2
            })
        else
            anchorActive = false
            if anchorBodyPosition then
                anchorBodyPosition:Destroy()
                anchorBodyPosition = nil
            end
            
            SavePosition()
            
            WindUI:Notify({
                Title = "Anchor",
                Content = "Фиксация снята",
                Icon = "unlock"
            })
        end
    end
})

-- 5. ЭКСТРЕННОЕ ВОССТАНОВЛЕНИЕ
MainTab:Button({
    Title = "Восстановить позицию",
    Desc = "Вернуться к последней сохраненной позиции",
    Callback = function()
        if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
        
        if #PositionBackup > 0 then
            Character.HumanoidRootPart.CFrame = CFrame.new(PositionBackup[#PositionBackup])
            WindUI:Notify({
                Title = "Восстановление",
                Content = "Позиция восстановлена",
                Icon = "rotate-ccw",
                Duration = 2
            })
        else
            WindUI:Notify({
                Title = "Ошибка",
                Content = "Нет сохраненных позиций",
                Icon = "alert"
            })
        end
    end
})

-- 6. ВОССТАНОВЛЕНИЕ ПРИ СМЕРТИ
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    task.wait(1)
    
    -- Автоматически восстанавливаем позицию
    if #PositionBackup > 0 then
        task.wait(2)
        local root = Character:WaitForChild("HumanoidRootPart", 5)
        if root then
            root.CFrame = CFrame.new(PositionBackup[#PositionBackup])
        end
    end
end)

-- Авто-сохранение позиции каждые 5 секунд
task.spawn(function()
    while true do
        SavePosition()
        task.wait(5)
    end
end)

Window:SelectTab(1)

-- Уведомление о загрузке
task.wait(1)
WindUI:Notify({
    Title = "GnomHub Anti-Revert",
    Content = "Загружено. Используйте Anchor для защиты.",
    Icon = "shield",
    Duration = 4
})

print("✅ GnomHub Anti-Revert загружен")
print("✅ Система защиты от возврата активирована")
