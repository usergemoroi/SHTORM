local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua", true))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Ждем загрузку персонажа
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

local Window = WindUI:CreateWindow({
    Title = "GnomHub Fixed",
    Icon = "rbxassetid://114691672281339",
    Author = "by GothbreachHelper",
    Folder = "GnomHub_Fixed"
})

local MainTab = Window:Tab({ Title = "Main", Icon = "bomb" })

-- 1. РАБОЧИЙ LAGGER (ИСПРАВЛЕННЫЙ)
local lagActive = false
local lagConnection

MainTab:Toggle({
    Title = "Packet Lag Bomb v2",
    Desc = "Создает лаг у игроков рядом",
    Callback = function(state)
        lagActive = state
        if state then
            -- Проверяем наличие персонажа
            if not LocalPlayer.Character then
                WindUI:Notify({
                    Title = "Ошибка",
                    Content = "Персонаж не найден",
                    Icon = "alert-triangle"
                })
                return
            end
            
            local root = LocalPlayer.Character:WaitForChild("HumanoidRootPart", 5)
            if not root then
                WindUI:Notify({
                    Title = "Ошибка",
                    Content = "HumanoidRootPart не найден",
                    Icon = "alert-triangle"
                })
                return
            end
            
            WindUI:Notify({
                Title = "Lag Bomb",
                Content = "Активирован",
                Icon = "zap"
            })
            
            lagConnection = RunService.Heartbeat:Connect(function()
                if not lagActive or not LocalPlayer.Character then
                    return
                end
                
                -- Используем несколько методов для лага
                pcall(function()
                    -- Метод 1: FireServer с разными RemoteEvents
                    for _, obj in pairs(LocalPlayer.Character:GetDescendants()) do
                        if obj:IsA("RemoteEvent") then
                            for i = 1, 5 do
                                obj:FireServer(string.rep("LAG", 500))
                            end
                        end
                    end
                    
                    -- Метод 2: Изменение свойств
                    if root then
                        local currentCF = root.CFrame
                        root.CFrame = currentCF * CFrame.new(0.001, 0, 0)
                        task.wait(0.001)
                        root.CFrame = currentCF * CFrame.new(-0.001, 0, 0)
                    end
                end)
            end)
        else
            if lagConnection then
                lagConnection:Disconnect()
                lagConnection = nil
            end
            WindUI:Notify({
                Title = "Lag Bomb",
                Content = "Деактивирован",
                Icon = "power"
            })
        end
    end
})

-- 2. УЛУЧШЕННЫЙ BYPASS С ЗАЩИТОЙ
MainTab:Button({
    Title = "Проникнуть на базу (Bypass v2)",
    Desc = "Телепортация вперед через стены",
    Callback = function()
        local char = LocalPlayer.Character
        if not char then
            WindUI:Notify({
                Title = "Ошибка",
                Content = "Персонаж не найден",
                Icon = "alert-triangle"
            })
            return
        end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then
            WindUI:Notify({
                Title = "Ошибка",
                Content = "HumanoidRootPart не найден",
                Icon = "alert-triangle"
            })
            return
        end
        
        -- Включаем временный noclip
        local originalCollisions = {}
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                originalCollisions[part] = part.CanCollide
                part.CanCollide = false
            end
        end
        
        -- Телепортируем
        local currentCF = root.CFrame
        root.CFrame = currentCF * CFrame.new(0, 0, -10)
        
        -- Возвращаем коллизии через 0.5 секунды
        task.delay(0.5, function()
            for part, canCollide in pairs(originalCollisions) do
                if part.Parent then
                    part.CanCollide = canCollide
                end
            end
        end)
        
        WindUI:Notify({
            Title = "GnomHub",
            Content = "Проход выполнен",
            Icon = "check",
            Duration = 2
        })
    end
})

-- 3. УЛУЧШЕННЫЙ FLY
local flying = false
local flyVelocity
local flyConnection

MainTab:Toggle({
    Title = "Fly v2 (Стабильный)",
    Desc = "Плавный полет с управлением",
    Callback = function(state)
        flying = state
        if state then
            local char = LocalPlayer.Character
            if not char then
                WindUI:Notify({
                    Title = "Ошибка",
                    Content = "Персонаж не найден",
                    Icon = "alert-triangle"
                })
                return
            end
            
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then
                WindUI:Notify({
                    Title = "Ошибка",
                    Content = "HumanoidRootPart не найден",
                    Icon = "alert-triangle"
                })
                return
            end
            
            -- Удаляем старые силы
            if flyVelocity then
                flyVelocity:Destroy()
            end
            
            -- Создаем BodyVelocity для полета
            flyVelocity = Instance.new("BodyVelocity")
            flyVelocity.Name = "WindUIFly"
            flyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
            flyVelocity.Velocity = Vector3.new(0, 0, 0)
            flyVelocity.Parent = root
            
            -- Управление
            flyConnection = RunService.Heartbeat:Connect(function()
                if not flying or not flyVelocity or not flyVelocity.Parent then
                    return
                end
                
                local camera = workspace.CurrentCamera
                local moveVector = Vector3.new(0, 0, 0)
                
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                    moveVector = moveVector + camera.CFrame.LookVector * 25
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                    moveVector = moveVector - camera.CFrame.LookVector * 25
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                    moveVector = moveVector - camera.CFrame.RightVector * 25
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                    moveVector = moveVector + camera.CFrame.RightVector * 25
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                    moveVector = moveVector + Vector3.new(0, 25, 0)
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveVector = moveVector + Vector3.new(0, -25, 0)
                end
                
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
            if flyVelocity then
                flyVelocity:Destroy()
                flyVelocity = nil
            end
            
            WindUI:Notify({
                Title = "Fly",
                Content = "Деактивирован",
                Icon = "power"
            })
        end
    end
})

-- 4. NOCLIP (ДОБАВЛЕН НОВЫЙ)
local noclipActive = false
local noclipConnection

MainTab:Toggle({
    Title = "Noclip",
    Desc = "Проходить сквозь стены",
    Callback = function(state)
        noclipActive = state
        if state then
            noclipConnection = RunService.Stepped:Connect(function()
                if noclipActive and LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            WindUI:Notify({
                Title = "Noclip",
                Content = "Активирован",
                Icon = "eye-off"
            })
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            -- Восстанавливаем коллизии
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
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

-- 5. БЫСТРАЯ ТЕЛЕПОРТАЦИЯ
MainTab:Button({
    Title = "Быстрая телепортация",
    Desc = "Телепортирует вперед на 20 метров",
    Callback = function()
        local char = LocalPlayer.Character
        if not char then return end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local camera = workspace.CurrentCamera
        local direction = camera.CFrame.LookVector
        
        root.CFrame = CFrame.new(root.Position + direction * 20)
        
        WindUI:Notify({
            Title = "Телепорт",
            Content = "Успешно",
            Icon = "move-right"
        })
    end
})

-- 6. ЭКСТРЕННАЯ ОСТАНОВКА
MainTab:Button({
    Title = "Экстренная остановка",
    Desc = "Отключает все функции",
    Callback = function()
        -- Отключаем Lag
        lagActive = false
        if lagConnection then
            lagConnection:Disconnect()
            lagConnection = nil
        end
        
        -- Отключаем Fly
        flying = false
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        if flyVelocity then
            flyVelocity:Destroy()
            flyVelocity = nil
        end
        
        -- Отключаем Noclip
        noclipActive = false
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        
        WindUI:Notify({
            Title = "Система",
            Content = "Все функции отключены",
            Icon = "power",
            Duration = 3
        })
    end
})

-- Автоматическое отключение при смерти
LocalPlayer.CharacterAdded:Connect(function()
    lagActive = false
    flying = false
    noclipActive = false
    
    if lagConnection then
        lagConnection:Disconnect()
        lagConnection = nil
    end
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
end)

Window:SelectTab(1)

-- Уведомление о загрузке
WindUI:Notify({
    Title = "GnomHub Fixed",
    Content = "Меню загружено успешно",
    Icon = "check-circle",
    Duration = 3
})

print("✅ GnomHub Fixed загружен")
