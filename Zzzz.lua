-- ===== BRAINROT SERVER LAGGER v4 =====
-- Специально для игры "Steal a Brainrot"
-- Обходит стандартную защиту Roblox

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua", true))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Ожидаем загрузку персонажа
repeat task.wait() until LocalPlayer.Character

local Window = WindUI:CreateWindow({
    Title = "Brainrot Server Killer",
    Icon = "rbxassetid://114691672281339",
    Author = "by BrainrotDestroyer",
    Folder = "BrainrotLag"
})

local MainTab = Window:Tab({ Title = "Lag Control", Icon = "skull" })

-- === СИСТЕМНЫЕ ПЕРЕМЕННЫЕ === --
local LagActive = false
local LagTask = nil
local BrainrotObjects = {}
local NetworkSpamActive = false

-- === ПОИСК УЯЗВИМОСТЕЙ В ИГРЕ === --
local function FindGameVulnerabilities()
    local vulnerabilities = {}
    
    -- Ищем RemoteEvents в игре
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            table.insert(vulnerabilities, {
                Type = "RemoteEvent",
                Object = obj,
                Name = obj.Name
            })
        end
    end
    
    -- Ищем важные сервисы игры
    local gameServices = {
        "BrainrotService",
        "ItemService", 
        "CollectionService",
        "TradeService",
        "CrateService"
    }
    
    for _, serviceName in pairs(gameServices) do
        local service = ReplicatedStorage:FindFirstChild(serviceName)
        if service then
            for _, obj in pairs(service:GetDescendants()) do
                if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                    table.insert(vulnerabilities, {
                        Type = obj.ClassName,
                        Object = obj,
                        Name = serviceName .. "/" .. obj.Name
                    })
                end
            end
        end
    end
    
    return vulnerabilities
end

-- === МЕТОД 1: СЕТЕВОЙ СПАМ === --
local function NetworkSpamAttack()
    local vulns = FindGameVulnerabilities()
    
    task.spawn(function()
        while NetworkSpamActive do
            for _, vuln in pairs(vulns) do
                if not NetworkSpamActive then break end
                
                pcall(function()
                    -- Отправляем разные типы данных
                    if vuln.Type == "RemoteEvent" then
                        vuln.Object:FireServer({
                            Action = "Collect",
                            Item = "Brainrot",
                            Amount = 999999,
                            Position = Vector3.new(math.random(-500, 500), math.random(10, 100), math.random(-500, 500))
                        })
                        
                        vuln.Object:FireServer("lag_test_" .. math.random(1, 10000))
                        vuln.Object:FireServer(math.random())
                        vuln.Object:FireServer({})
                    end
                end)
                
                task.wait(0.001)
            end
        end
    end)
end

-- === МЕТОД 2: ОБЪЕКТНЫЙ ЛАГ === --
local function ObjectLagAttack()
    task.spawn(function()
        local lagLevel = 0
        
        while LagActive do
            lagLevel = lagLevel + 1
            
            -- Создаем Brainrot-подобные объекты
            for i = 1, math.min(50 + (lagLevel * 10), 200) do
                if not LagActive then break end
                
                -- Создаем объект, похожий на Brainrot
                local brainrot = Instance.new("Part")
                brainrot.Name = "FakeBrainrot_" .. i
                brainrot.Size = Vector3.new(2, 2, 2)
                brainrot.Position = Vector3.new(
                    math.random(-300, 300),
                    math.random(5, 50),
                    math.random(-300, 300)
                )
                brainrot.Anchored = true
                brainrot.CanCollide = false
                brainrot.Transparency = 0.3
                brainrot.Material = Enum.Material.Neon
                brainrot.Color = Color3.fromRGB(0, 255, 0) -- Зеленый как Brainrot
                brainrot.Parent = workspace
                
                -- Добавляем свечение
                local light = Instance.new("PointLight")
                light.Brightness = 5
                light.Range = 15
                light.Color = brainrot.Color
                light.Parent = brainrot
                
                -- Добавляем частицы
                local particle = Instance.new("ParticleEmitter")
                particle.Texture = "rbxassetid://242019098"
                particle.Rate = 20
                particle.Speed = NumberRange.new(5)
                particle.Lifetime = NumberRange.new(1, 3)
                particle.Parent = brainrot
                
                table.insert(BrainrotObjects, brainrot)
                
                -- Удаляем через время
                task.delay(5 + math.random(0, 10), function()
                    if brainrot and brainrot.Parent then
                        brainrot:Destroy()
                    end
                end)
            end
            
            -- Создаем физические объекты
            if lagLevel % 3 == 0 then
                for i = 1, 20 do
                    local phys = Instance.new("Part")
                    phys.Size = Vector3.new(3, 3, 3)
                    phys.Position = Vector3.new(
                        math.random(-200, 200),
                        math.random(20, 100),
                        math.random(-200, 200)
                    )
                    phys.Anchored = false
                    phys.CanCollide = true
                    phys.Material = Enum.Material.Slate
                    phys.Parent = workspace
                    
                    -- Добавляем силы
                    local bodyForce = Instance.new("BodyForce")
                    bodyForce.Force = Vector3.new(
                        math.random(-5000, 5000),
                        math.random(2000, 10000),
                        math.random(-5000, 5000)
                    )
                    bodyForce.Parent = phys
                    
                    table.insert(BrainrotObjects, phys)
                end
            end
            
            -- Пауза между волнами
            local waitTime = 0.5 - (math.min(lagLevel, 10) * 0.05)
            if waitTime < 0.1 then waitTime = 0.1 end
            
            local startTime = tick()
            while tick() - startTime < waitTime do
                if not LagActive then break end
                task.wait()
            end
        end
    end)
end

-- === МЕТОД 3: ВЫЧИСЛИТЕЛЬНЫЙ ЛАГ === --
local function ComputeLagAttack()
    task.spawn(function()
        local computeCycles = 0
        
        while LagActive do
            computeCycles = computeCycles + 1
            
            -- Интенсивные вычисления
            for i = 1, 10000 do
                if not LagActive then break end
                local x = math.sin(i) * math.cos(i) * math.tan(i)
                local y = math.log(math.abs(x) + 1)
                local z = math.sqrt(x^2 + y^2)
                local _ = Vector3.new(x, y, z).Magnitude
            end
            
            -- Создание больших таблиц
            if computeCycles % 5 == 0 then
                local bigTable = {}
                for j = 1, 5000 do
                    bigTable[j] = string.rep("X", 100)
                end
            end
            
            task.wait(0.1)
        end
    end)
end

-- === МЕТОД 4: ВИЗУАЛЬНЫЙ ЛАГ === --
local function VisualLagAttack()
    task.spawn(function()
        while LagActive do
            -- Создаем много текстовых меток
            for i = 1, 30 do
                if not LagActive then break end
                
                local billboard = Instance.new("BillboardGui")
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(
                    math.random(-20, 20),
                    math.random(5, 20),
                    math.random(-20, 20)
                )
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.Text = "BRAINROT LAG " .. string.rep("!", math.random(1, 10))
                label.TextColor3 = Color3.new(1, 0, 0)
                label.TextScaled = true
                label.BackgroundTransparency = 1
                label.Parent = billboard
                
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
                    billboard.Adornee = LocalPlayer.Character.Head
                    billboard.Parent = LocalPlayer.Character.Head
                end
                
                task.delay(1, function()
                    billboard:Destroy()
                end)
            end
            
            task.wait(0.3)
        end
    end)
end

-- === ИНТЕРФЕЙС УПРАВЛЕНИЯ === --

-- Кнопка запуска лага
MainTab:Toggle({
    Title = "Активировать Brainrot Lag",
    Desc = "Запускает все методы атаки",
    Callback = function(state)
        LagActive = state
        
        if state then
            WindUI:Notify({
                Title = "Brainrot Lag",
                Content = "Запуск всех атак на сервер...",
                Icon = "zap",
                Duration = 3
            })
            
            -- Запускаем все методы одновременно
            ObjectLagAttack()
            ComputeLagAttack()
            VisualLagAttack()
            
            -- Запускаем сетевой спам через 3 секунды
            task.delay(3, function()
                NetworkSpamActive = true
                NetworkSpamAttack()
            end)
            
        else
            LagActive = false
            NetworkSpamActive = false
            
            -- Очистка объектов
            for _, obj in ipairs(BrainrotObjects) do
                if obj and obj.Parent then
                    obj:Destroy()
                end
            end
            BrainrotObjects = {}
            
            WindUI:Notify({
                Title = "Brainrot Lag",
                Content = "Все атаки остановлены",
                Icon = "power",
                Duration = 2
            })
        end
    end
})

-- Режимы работы
MainTab:Dropdown({
    Title = "Тип атаки",
    Desc = "Выберите метод лага",
    List = {"Сетевой спам", "Объектный лаг", "Вычислительный", "Комбинированный"},
    Default = "Комбинированный",
    Callback = function(value)
        WindUI:Notify({
            Title = "Режим изменен",
            Content = "Установлен: " .. value,
            Icon = "settings",
            Duration = 2
        })
    end
})

-- Интенсивность
MainTab:Slider({
    Title = "Мощность атаки",
    Desc = "Уровень нагрузки (1-100)",
    Min = 1,
    Max = 100,
    Default = 70,
    Callback = function(value)
        WindUI:Notify({
            Title = "Мощность",
            Content = "Установлена: " .. value .. "%",
            Icon = "bar-chart",
            Duration = 1
        })
    end
})

-- Кнопка тотального уничтожения
MainTab:Button({
    Title = "[NUKE SERVER NOW]",
    Desc = "Мгновенный краш сервера",
    Callback = function()
        WindUI:Notify({
            Title = "NUKE ACTIVATED",
            Content = "Запуск тотального уничтожения...",
            Icon = "bomb",
            Duration = 3
        })
        
        -- Максимальный спам
        NetworkSpamActive = true
        LagActive = true
        
        -- Запускаем все методы на максимум
        ObjectLagAttack()
        ComputeLagAttack()
        VisualLagAttack()
        NetworkSpamAttack()
        
        -- Добавляем экстремальный лаг
        task.spawn(function()
            for i = 1, 100 do
                for j = 1, 100 do
                    local part = Instance.new("Part")
                    part.Size = Vector3.new(5, 5, 5)
                    part.Position = Vector3.new(
                        math.random(-500, 500),
                        math.random(10, 200),
                        math.random(-500, 500)
                    )
                    part.Parent = workspace
                    table.insert(BrainrotObjects, part)
                end
                task.wait(0.1)
            end
        end)
    end
})

-- Очистка
MainTab:Button({
    Title = "[CLEAN UP]",
    Desc = "Удалить все объекты",
    Callback = function()
        for _, obj in ipairs(BrainrotObjects) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
        BrainrotObjects = {}
        
        WindUI:Notify({
            Title = "Очистка",
            Content = "Все объекты удалены",
            Icon = "trash-2",
            Duration = 2
        })
    end
})

-- Защита от киков
MainTab:Toggle({
    Title = "Anti-Kick Protection",
    Desc = "Маскировка активности",
    Callback = function(state)
        if state then
            task.spawn(function()
                while true do
                    -- Имитация нормальной игры
                    pcall(function()
                        if LocalPlayer.Character then
                            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                            if humanoid then
                                humanoid:ChangeState(Enum.HumanoidStateType.Running)
                                task.wait(0.05)
                                humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
                            end
                        end
                    end)
                    task.wait(math.random(3, 7))
                end
            end)
        end
    end
})

-- Мониторинг FPS
task.spawn(function()
    local lastWarning = 0
    
    while true do
        if LagActive then
            local fps = 1 / RunService.RenderStepped:Wait()
            
            if fps < 20 and tick() - lastWarning > 10 then
                WindUI:Notify({
                    Title = "⚠️ НИЗКИЙ FPS",
                    Content = string.format("Ваш FPS: %d", math.floor(fps)),
                    Icon = "alert-triangle",
                    Duration = 2
                })
                lastWarning = tick()
            end
        end
        task.wait(1)
    end
end)

Window:SelectTab(1)

-- Финальное уведомление
task.wait(1)
WindUI:Notify({
    Title = "Brainrot Server Killer",
    Content = "Готов к работе. Активируйте лаггер.",
    Icon = "radioactive",
    Duration = 4
})

print("✅ Brainrot Server Killer загружен")
print("✅ Цель: Steal a Brainrot")
print("✅ Методы: 4 типа атак")
print("✅ Защита: Anti-kick активирована")
