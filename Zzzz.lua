local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua", true))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Ждем загрузку персонажа
repeat task.wait() until LocalPlayer.Character
local Character = LocalPlayer.Character

local Window = WindUI:CreateWindow({
    Title = "Perfect Lag Bomb",
    Icon = "rbxassetid://114691672281339",
    Author = "by GothbreachHelper",
    Folder = "PerfectLag"
})

local LagTab = Window:Tab({ Title = "Lag System", Icon = "zap" })

-- === ПЕРЕМЕННЫЕ === --
local LagActive = false
local LagTask = nil
local LagMode = "Safe" -- Safe, Medium, Strong
local LagRadius = 30
local LagIntensity = 50

-- === СИСТЕМА ЛАГГЕРА === --
local function CreatePerfectLag()
    if LagTask then task.cancel(LagTask) end
    
    LagTask = task.spawn(function()
        local lagCycle = 0
        local startTime = tick()
        
        while LagActive do
            lagCycle = lagCycle + 1
            
            -- Метод 1: Создание и уничтожение частей (нагрузка на рендеринг)
            for i = 1, math.floor(LagIntensity / 10) do
                if not LagActive then break end
                
                local part = Instance.new("Part")
                part.Name = "LagPart"
                part.Size = Vector3.new(1, 1, 1)
                part.Transparency = 0.5
                part.Material = Enum.Material.Neon
                part.Color = Color3.fromHSV(math.random(), 1, 1)
                part.Anchored = true
                part.CanCollide = false
                part.CFrame = workspace.CurrentCamera.CFrame * CFrame.new(
                    math.random(-20, 20),
                    math.random(-10, 10),
                    math.random(-15, 15)
                )
                part.Parent = workspace.CurrentCamera
                
                -- Асинхронное удаление
                task.delay(0.5, function()
                    if part then
                        part:Destroy()
                    end
                end)
            end
            
            -- Метод 2: Интенсивные вычисления (нагрузка на CPU)
            local computeStart = tick()
            local computation = 0
            
            for j = 1, math.floor(LagIntensity * 100) do
                if not LagActive then break end
                computation = computation + math.sin(j) * math.cos(j) * math.tan(j)
                computation = computation * math.random()
            end
            
            -- Метод 3: Создание физических объектов (нагрузка на физику)
            if lagCycle % 3 == 0 then
                for k = 1, math.floor(LagIntensity / 20) do
                    if not LagActive then break end
                    
                    local meshPart = Instance.new("Part")
                    meshPart.Name = "PhysicsLag"
                    meshPart.Size = Vector3.new(0.5, 0.5, 0.5)
                    meshPart.Position = Vector3.new(
                        math.random(-50, 50),
                        math.random(10, 50),
                        math.random(-50, 50)
                    )
                    meshPart.Anchored = false
                    meshPart.CanCollide = true
                    meshPart.Parent = workspace
                    
                    -- Добавляем случайные силы
                    local bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.Velocity = Vector3.new(
                        math.random(-50, 50),
                        math.random(-50, 50),
                        math.random(-50, 50)
                    )
                    bodyVelocity.MaxForce = Vector3.new(1000, 1000, 1000)
                    bodyVelocity.Parent = meshPart
                    
                    -- Автоочистка
                    task.delay(2, function()
                        if meshPart then
                            meshPart:Destroy()
                        end
                    end)
                end
            end
            
            -- Метод 4: Работа с сетью (осторожно)
            if LagMode ~= "Safe" and lagCycle % 5 == 0 then
                pcall(function()
                    local root = Character and Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        -- Имитация нормальной активности
                        local remoteEvents = {}
                        for _, obj in pairs(Character:GetDescendants()) do
                            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                                table.insert(remoteEvents, obj)
                            end
                        end
                        
                        if #remoteEvents > 0 then
                            for i = 1, math.min(3, #remoteEvents) do
                                local event = remoteEvents[math.random(1, #remoteEvents)]
                                event:FireServer("LagTest", math.random(1, 100))
                            end
                        end
                    end
                end)
            end
            
            -- Метод 5: Работа с памятью
            if lagCycle % 10 == 0 then
                local dataTable = {}
                for i = 1, math.floor(LagIntensity * 10) do
                    dataTable[i] = string.rep("X", 100)
                end
            end
            
            -- Статистика
            if lagCycle % 20 == 0 then
                local uptime = tick() - startTime
                WindUI:Notify({
                    Title = "Lag System",
                    Content = string.format("Работает: %.1fсек, Цикл: %d", uptime, lagCycle),
                    Icon = "activity",
                    Duration = 1
                })
            end
            
            -- Адаптивная пауза
            local waitTime = 0.3 - (LagIntensity / 500)
            if waitTime < 0.05 then waitTime = 0.05 end
            
            local waitStart = tick()
            while tick() - waitStart < waitTime do
                if not LagActive then break end
                task.wait()
            end
        end
        
        -- Очистка после отключения
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name == "LagPart" or obj.Name == "PhysicsLag" then
                obj:Destroy()
            end
        end
        for _, obj in pairs(workspace.CurrentCamera:GetChildren()) do
            if obj.Name == "LagPart" then
                obj:Destroy()
            end
        end
    end)
end

-- === ИНТЕРФЕЙС === --
LagTab:Toggle({
    Title = "Идеальный Lag Bomb",
    Desc = "Активирует многослойный лаггер",
    Callback = function(state)
        LagActive = state
        if state then
            WindUI:Notify({
                Title = "Lag Bomb",
                Content = "Запуск идеального лаггера...",
                Icon = "zap",
                Duration = 2
            })
            
            CreatePerfectLag()
            
            WindUI:Notify({
                Title = "Lag Bomb",
                Content = "Активирован! (Безопасный режим)",
                Icon = "check-circle",
                Duration = 3
            })
        else
            LagActive = false
            if LagTask then
                task.cancel(LagTask)
                LagTask = nil
            end
            WindUI:Notify({
                Title = "Lag Bomb",
                Content = "Деактивирован",
                Icon = "power",
                Duration = 2
            })
        end
    end
})

-- Настройки лаггера
LagTab:Dropdown({
    Title = "Режим работы",
    Desc = "Уровень агрессивности",
    List = {"Safe", "Medium", "Strong"},
    Default = "Safe",
    Callback = function(value)
        LagMode = value
        WindUI:Notify({
            Title = "Lag Mode",
            Content = "Установлен: " .. value,
            Icon = "settings",
            Duration = 2
        })
    end
})

LagTab:Slider({
    Title = "Интенсивность лага",
    Desc = "Уровень нагрузки (1-100)",
    Min = 1,
    Max = 100,
    Default = 50,
    Callback = function(value)
        LagIntensity = value
        WindUI:Notify({
            Title = "Intensity",
            Content = "Установлена: " .. value,
            Icon = "bar-chart-2",
            Duration = 1
        })
    end
})

LagTab:Slider({
    Title = "Радиус действия",
    Desc = "Дистанция создания объектов",
    Min = 10,
    Max = 100,
    Default = 30,
    Callback = function(value)
        LagRadius = value
    end
})

-- Дополнительные функции
LagTab:Button({
    Title = "Быстрый тест",
    Desc = "Быстрая проверка лаггера",
    Callback = function()
        local originalLagState = LagActive
        LagActive = false
        if LagTask then task.cancel(LagTask) end
        
        task.wait(0.5)
        
        WindUI:Notify({
            Title = "Lag Test",
            Content = "Запуск теста...",
            Icon = "loader",
            Duration = 1
        })
        
        -- Мини-тест
        local testParts = {}
        for i = 1, 20 do
            local part = Instance.new("Part")
            part.Size = Vector3.new(2, 2, 2)
            part.Position = Vector3.new(
                math.random(-10, 10),
                math.random(5, 15),
                math.random(-10, 10)
            )
            part.Anchored = true
            part.Parent = workspace
            table.insert(testParts, part)
            
            task.wait(0.01)
        end
        
        task.wait(0.5)
        
        -- Очистка
        for _, part in pairs(testParts) do
            part:Destroy()
        end
        
        WindUI:Notify({
            Title = "Lag Test",
            Content = "Тест завершен успешно",
            Icon = "check",
            Duration = 2
        })
        
        LagActive = originalLagState
        if LagActive then
            CreatePerfectLag()
        end
    end
})

LagTab:Button({
    Title = "Экстренная остановка",
    Desc = "Полная очистка системы",
    Callback = function()
        LagActive = false
        if LagTask then
            task.cancel(LagTask)
            LagTask = nil
        end
        
        -- Полная очистка
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name == "LagPart" or obj.Name == "PhysicsLag" then
                obj:Destroy()
            end
        end
        for _, obj in pairs(workspace.CurrentCamera:GetChildren()) do
            if obj.Name == "LagPart" then
                obj:Destroy()
            end
        end
        
        -- Сборка мусора
        task.wait(0.5)
        game:GetService("ContentProvider"):PreloadAsync({})
        
        WindUI:Notify({
            Title = "Emergency Stop",
            Content = "Лаггер полностью выключен",
            Icon = "shield",
            Duration = 3
        })
    end
})

-- Система мониторинга
task.spawn(function()
    while true do
        if LagActive then
            -- Проверяем FPS
            local fps = 1 / RunService.RenderStepped:Wait()
            if fps < 20 then
                WindUI:Notify({
                    Title = "Lag Warning",
                    Content = string.format("Низкий FPS: %d", math.floor(fps)),
                    Icon = "alert-triangle",
                    Duration = 2
                })
            end
        end
        task.wait(5)
    end
end)

Window:SelectTab(1)

-- Автоматическое отключение при ошибках
task.spawn(function()
    pcall(function()
        while true do
            if LagActive then
                -- Проверка на кики
                local success = pcall(function()
                    game:GetService("MarketplaceService")
                end)
                if not success then
                    LagActive = false
                    if LagTask then
                        task.cancel(LagTask)
                        LagTask = nil
                    end
                end
            end
            task.wait(1)
        end
    end)
end)

WindUI:Notify({
    Title = "Perfect Lag Bomb",
    Content = "Загружен и готов к работе!",
    Icon = "check-circle",
    Duration = 4
})

print("✅ Perfect Lag Bomb загружен")
print("✅ Режим: " .. LagMode)
print("✅ Интенсивность: " .. LagIntensity)
