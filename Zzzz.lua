local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua", true))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Ожидание загрузки персонажа
repeat task.wait() until LocalPlayer.Character
local Character = LocalPlayer.Character

local Window = WindUI:CreateWindow({
    Title = "Silent Lag Generator",
    Icon = "rbxassetid://114691672281339",
    Author = "by SilentTech",
    Folder = "SilentLag"
})

local LagTab = Window:Tab({ Title = "Lag Controls", Icon = "zap" })

-- === НАСТРОЙКИ === --
local LagActive = false
local LagTask = nil
local LagMode = "Safe"
local LagIntensity = 30

-- === ОСНОВНАЯ ФУНКЦИЯ ЛАГГЕРА === --
local function StartSilentLag()
    if LagTask then task.cancel(LagTask) end
    
    LagTask = task.spawn(function()
        local cycle = 0
        
        while LagActive do
            cycle = cycle + 1
            
            -- 1. ВИЗУАЛЬНЫЕ ОБЪЕКТЫ (Безопасно)
            for i = 1, math.floor(LagIntensity / 15) do
                if not LagActive then break end
                
                local part = Instance.new("Part")
                part.Name = "VisualLag"
                part.Size = Vector3.new(0.5, 0.5, 0.5)
                part.Transparency = 0.7
                part.Material = Enum.Material.Neon
                part.Color = Color3.fromHSV(math.random(), 1, 1)
                part.Anchored = true
                part.CanCollide = false
                part.CFrame = workspace.CurrentCamera.CFrame * CFrame.new(
                    math.random(-15, 15),
                    math.random(-8, 8),
                    math.random(-10, 10)
                )
                part.Parent = workspace.CurrentCamera
                
                task.delay(1, function()
                    if part then part:Destroy() end
                end)
            end
            
            -- 2. ФИЗИЧЕСКИЕ ОБЪЕКТЫ (Только в Medium/Strong)
            if LagMode ~= "Safe" and cycle % 3 == 0 then
                for i = 1, math.floor(LagIntensity / 25) do
                    if not LagActive then break end
                    
                    local physPart = Instance.new("Part")
                    physPart.Name = "PhysLag"
                    physPart.Size = Vector3.new(1, 1, 1)
                    physPart.Position = Vector3.new(
                        math.random(-20, 20),
                        math.random(5, 20),
                        math.random(-20, 20)
                    )
                    physPart.Anchored = false
                    physPart.CanCollide = true
                    physPart.Parent = workspace
                    
                    task.delay(3, function()
                        if physPart then physPart:Destroy() end
                    end)
                end
            end
            
            -- 3. ВЫЧИСЛИТЕЛЬНАЯ НАГРУЗКА (Только в Strong)
            if LagMode == "Strong" then
                local computations = 0
                for j = 1, math.floor(LagIntensity * 50) do
                    if not LagActive then break end
                    computations = computations + math.sin(j) * math.cos(j)
                end
            end
            
            -- Пауза между циклами
            local waitTime = 0.4 - (LagIntensity / 250)
            if waitTime < 0.1 then waitTime = 0.1 end
            
            local waitStart = tick()
            while tick() - waitStart < waitTime do
                if not LagActive then break end
                task.wait()
            end
        end
        
        -- Очистка при остановке
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name == "VisualLag" or obj.Name == "PhysLag" then
                obj:Destroy()
            end
        end
        for _, obj in pairs(workspace.CurrentCamera:GetChildren()) do
            if obj.Name == "VisualLag" then
                obj:Destroy()
            end
        end
    end)
end

-- === ЭЛЕМЕНТЫ ИНТЕРФЕЙСА === --
LagTab:Toggle({
    Title = "Активировать Silent Lag",
    Desc = "Включить/выключить систему",
    Callback = function(state)
        LagActive = state
        if state then
            WindUI:Notify({
                Title = "Silent Lag",
                Content = "Активирован в режиме: " .. LagMode,
                Icon = "zap",
                Duration = 3
            })
            StartSilentLag()
        else
            LagActive = false
            if LagTask then
                task.cancel(LagTask)
                LagTask = nil
            end
            WindUI:Notify({
                Title = "Silent Lag",
                Content = "Полностью отключен",
                Icon = "power",
                Duration = 2
            })
        end
    end
})

LagTab:Dropdown({
    Title = "Режим работы",
    Desc = "Уровень воздействия и риска",
    List = {"Safe", "Medium", "Strong"},
    Default = "Safe",
    Callback = function(value)
        LagMode = value
        WindUI:Notify({
            Title = "Режим изменен",
            Content = "Установлен: " .. value,
            Icon = "settings",
            Duration = 2
        })
    end
})

LagTab:Slider({
    Title = "Уровень интенсивности",
    Desc = "Сила воздействия (1-100)",
    Min = 1,
    Max = 100,
    Default = 30,
    Callback = function(value)
        LagIntensity = value
    end
})

LagTab:Button({
    Title = "Экстренная остановка",
    Desc = "Мгновенная очистка системы",
    Callback = function()
        LagActive = false
        if LagTask then
            task.cancel(LagTask)
            LagTask = nil
        end
        
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name == "VisualLag" or obj.Name == "PhysLag" then
                obj:Destroy()
            end
        end
        
        WindUI:Notify({
            Title = "Экстренная остановка",
            Content = "Все процессы прерваны",
            Icon = "shield",
            Duration = 3
        })
    end
})

Window:SelectTab(1)

-- Мониторинг производительности
task.spawn(function()
    while true do
        if LagActive then
            local fps = 1 / RunService.RenderStepped:Wait()
            if fps < 25 then
                WindUI:Notify({
                    Title = "Внимание: низкий FPS",
                    Content = string.format("Текущий FPS: %d", math.floor(fps)),
                    Icon = "alert-triangle",
                    Duration = 2
                })
            end
        end
        task.wait(3)
    end
end)

WindUI:Notify({
    Title = "Silent Lag Generator",
    Content = "Система готова к работе",
    Icon = "check-circle",
    Duration = 4
})

print("✅ Silent Lag Generator загружен")
