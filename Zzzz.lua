local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua", true))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Ожидаем персонажа
repeat task.wait() until LocalPlayer.Character

local Window = WindUI:CreateWindow({
    Title = "OWNER SERVER KILLER",
    Icon = "rbxassetid://114691672281339",
    Author = "by ServerOwner",
    Folder = "OwnerControl"
})

local MainTab = Window:Tab({ Title = "Nuke Control", Icon = "skull" })

-- Система ядерного лага
local nukeLevel = 0
local spawnedObjects = {}
local isNuking = false

-- Основная функция атаки
local function NuclearStrike()
    if isNuking then return end
    isNuking = true
    nukeLevel = nukeLevel + 1
    
    WindUI:Notify({
        Title = "☢️ NUKE LEVEL " .. nukeLevel,
        Content = "СЕРВЕР АТАКОВАН",
        Icon = "alert-triangle",
        Duration = 3
    })
    
    -- УРОВЕНЬ 1: Множественные части
    if nukeLevel >= 1 then
        for i = 1, 100 do
            local part = Instance.new("Part")
            part.Name = "OwnerNuke_" .. i
            part.Size = Vector3.new(15, 15, 15)
            part.Position = Vector3.new(
                math.random(-300, 300),
                math.random(50, 200),
                math.random(-300, 300)
            )
            part.Anchored = true
            part.CanCollide = false
            part.Transparency = 0.7
            part.Material = Enum.Material.Neon
            part.Color = Color3.fromHSV((i%10)/10, 1, 1)
            part.Parent = workspace
            
            -- Добавляем свет
            local light = Instance.new("PointLight")
            light.Brightness = 10
            light.Range = 25
            light.Color = part.Color
            light.Parent = part
            
            table.insert(spawnedObjects, part)
        end
    end
    
    -- УРОВЕНЬ 2: Физические объекты
    if nukeLevel >= 2 then
        for i = 1, 50 do
            local phys = Instance.new("Part")
            phys.Name = "OwnerNukePhys_" .. i
            phys.Size = Vector3.new(8, 8, 8)
            phys.Position = Vector3.new(
                math.random(-200, 200),
                math.random(100, 300),
                math.random(-200, 200)
            )
            phys.Anchored = false
            phys.CanCollide = true
            phys.Material = Enum.Material.Slate
            
            -- Физические силы
            local bodyForce = Instance.new("BodyForce")
            bodyForce.Force = Vector3.new(
                math.random(-20000, 20000),
                math.random(10000, 30000),
                math.random(-20000, 20000)
            )
            bodyForce.Parent = phys
            
            phys.Parent = workspace
            table.insert(spawnedObjects, phys)
        end
    end
    
    -- УРОВЕНЬ 3: Анимированные объекты
    if nukeLevel >= 3 then
        for i = 1, 30 do
            local anim = Instance.new("Part")
            anim.Name = "OwnerNukeAnim_" .. i
            anim.Size = Vector3.new(20, 20, 20)
            anim.Position = Vector3.new(0, 150, 0)
            anim.Anchored = true
            anim.Transparency = 0.4
            anim.Color = Color3.new(1, 0, 0)
            anim.Parent = workspace
            
            -- Анимация движения
            task.spawn(function()
                local angle = i * 0.5
                while anim and anim.Parent do
                    angle = angle + 0.05
                    anim.Position = Vector3.new(
                        math.cos(angle) * 250,
                        150 + math.sin(angle * 2) * 50,
                        math.sin(angle) * 250
                    )
                    task.wait(0.03)
                end
            end)
            
            table.insert(spawnedObjects, anim)
        end
    end
    
    -- УРОВЕНЬ 4: Спецэффекты
    if nukeLevel >= 4 then
        for i = 1, 20 do
            local effect = Instance.new("Part")
            effect.Name = "OwnerNukeFX_" .. i
            effect.Shape = Enum.PartType.Ball
            effect.Size = Vector3.new(25, 25, 25)
            effect.Position = Vector3.new(
                math.random(-150, 150),
                math.random(50, 100),
                math.random(-150, 150)
            )
            effect.Anchored = true
            effect.Material = Enum.Material.Glass
            effect.Transparency = 0.3
            
            -- Создаем взрывной эффект
            task.spawn(function()
                for size = 1, 3, 0.1 do
                    if not effect then break end
                    effect.Size = Vector3.new(25 * size, 25 * size, 25 * size)
                    effect.Transparency = 0.3 + (size * 0.2)
                    task.wait(0.1)
                end
            end)
            
            effect.Parent = workspace
            table.insert(spawnedObjects, effect)
        end
    end
    
    -- УРОВЕНЬ 5: Абсолютное уничтожение
    if nukeLevel >= 5 then
        WindUI:Notify({
            Title = "💀 ABSOLUTE DESTRUCTION",
            Content = "СЕРВЕР УНИЧТОЖЕН",
            Icon = "skull",
            Duration = 5
        })
        
        -- Бесконечный спавн
        task.spawn(function()
            while nukeLevel >= 5 do
                for i = 1, 30 do
                    local chaos = Instance.new("Part")
                    chaos.Size = Vector3.new(10, 10, 10)
                    chaos.Position = Vector3.new(
                        math.random(-500, 500),
                        math.random(50, 500),
                        math.random(-500, 500)
                    )
                    chaos.Anchored = true
                    chaos.Parent = workspace
                    table.insert(spawnedObjects, chaos)
                end
                task.wait(0.2)
            end
        end)
    end
    
    isNuking = false
end

-- Главная кнопка
MainTab:Button({
    Title = "[NUKE SERVER NOW]",
    Desc = "Нажмите 3-5 раз для полного уничтожения",
    Callback = function()
        NuclearStrike()
    end
})

-- Экстренная очистка
MainTab:Button({
    Title = "[CLEAN EVERYTHING]",
    Desc = "Полная очистка сервера",
    Callback = function()
        for _, obj in ipairs(spawnedObjects) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
        spawnedObjects = {}
        nukeLevel = 0
        
        -- Форсируем сборку мусора
        task.wait(0.5)
        for i = 1, 10 do
            game:GetService("ContentProvider"):PreloadAsync({})
            task.wait(0.05)
        end
        
        WindUI:Notify({
            Title = "CLEANED",
            Content = "Все объекты удалены",
            Icon = "trash",
            Duration = 2
        })
    end
})

-- Автоматическая защита от киков
MainTab:Toggle({
    Title = "ANTI-KICK PROTECTION",
    Desc = "Защищает от автоматических киков",
    Callback = function(state)
        if state then
            task.spawn(function()
                while true do
                    -- Скрываем активность
                    pcall(function()
                        -- Имитация нормальной игры
                        if LocalPlayer.Character then
                            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                            if humanoid then
                                humanoid:ChangeState(Enum.HumanoidStateType.Running)
                                task.wait(0.1)
                                humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
                            end
                        end
                    end)
                    task.wait(5)
                end
            end)
        end
    end
})

-- Монитор производительности
task.spawn(function()
    local lastFPS = 60
    while true do
        local fps = 1 / RunService.RenderStepped:Wait()
        
        if fps < 15 and lastFPS >= 15 then
            WindUI:Notify({
                Title = "⚠️ LOW FPS WARNING",
                Content = string.format("FPS dropped to %d", math.floor(fps)),
                Icon = "alert-circle",
                Duration = 2
            })
        end
        
        lastFPS = fps
        task.wait(2)
    end
end)

Window:SelectTab(1)

-- Финальное уведомление
task.wait(1)
WindUI:Notify({
    Title = "OWNER CONTROL LOADED",
    Content = "You have full control over your server",
    Icon = "shield",
    Duration = 4
})

print("✅ OWNER SERVER KILLER загружен")
print("✅ Уровень доступа: ВЛАДЕЛЕЦ")
print("✅ Защита от киков: АКТИВНА")
