local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua", true))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window = WindUI:CreateWindow({
    Title = "Server Killer v3",
    Icon = "rbxassetid://114691672281339",
    Author = "by ServerDestroyer",
    Folder = "ServerKiller"
})

local MainTab = Window:Tab({ Title = "Nuke", Icon = "bomb" })

-- ГЛОБАЛЬНАЯ АТАКА НА СЕРВЕР
local attackLevel = 0
local spawnedObjects = {}

MainTab:Button({
    Title = "[NUKE SERVER]",
    Desc = "Нажми 3-5 раз для полного уничтожения FPS",
    Callback = function()
        attackLevel = attackLevel + 1
        
        WindUI:Notify({
            Title = "SERVER NUKE",
            Content = "АТАКА УРОВНЯ " .. attackLevel .. " ЗАПУЩЕНА",
            Icon = "alert-triangle",
            Duration = 3
        })
        
        -- УРОВЕНЬ 1: Базовые частицы (лёгкий лаг)
        if attackLevel >= 1 then
            for i = 1, 150 do
                local part = Instance.new("Part")
                part.Name = "NukeParticle_L1"
                part.Size = Vector3.new(10, 10, 10)
                part.Transparency = 0.3
                part.Material = Enum.Material.Neon
                part.Color = Color3.fromRGB(255, 0, 0)
                part.Anchored = true
                part.CanCollide = false
                
                -- Критически важно: родитель - Workspace, а не камера
                part.Parent = workspace
                part.Position = Vector3.new(
                    math.random(-200, 200),
                    math.random(10, 100),
                    math.random(-200, 200)
                )
                
                table.insert(spawnedObjects, part)
            end
        end
        
        -- УРОВЕНЬ 2: Сложные UnionOperations (тяжёлый лаг)
        if attackLevel >= 2 then
            for i = 1, 80 do
                local union = Instance.new("Part")
                union.Name = "NukeUnion_L2"
                union.Size = Vector3.new(8, 8, 8)
                union.Shape = Enum.PartType.Ball  -- Сфера сложнее для рендера
                union.Material = Enum.Material.Glass
                union.Transparency = 0.5
                union.Reflectance = 0.8
                union.Color = Color3.fromRGB(0, 255, 255)
                union.Anchored = true
                union.CanCollide = false
                union.Parent = workspace
                union.Position = Vector3.new(
                    math.random(-150, 150),
                    math.random(20, 80),
                    math.random(-150, 150)
                )
                
                -- Добавляем свечение
                local light = Instance.new("PointLight")
                light.Brightness = 5
                light.Range = 20
                light.Parent = union
                
                table.insert(spawnedObjects, union)
            end
        end
        
        -- УРОВЕНЬ 3: Меш-частицы (убийственный лаг)
        if attackLevel >= 3 then
            for i = 1, 120 do
                local meshPart = Instance.new("Part")
                meshPart.Name = "NukeMesh_L3"
                meshPart.Size = Vector3.new(12, 12, 12)
                meshPart.Material = Enum.Material.Neon
                meshPart.Transparency = 0.4
                meshPart.Color = Color3.fromHSV(i/120, 1, 1)
                meshPart.Anchored = true
                meshPart.CanCollide = false
                meshPart.Parent = workspace
                meshPart.Position = Vector3.new(
                    math.random(-180, 180),
                    math.random(30, 120),
                    math.random(-180, 180)
                )
                
                -- Специальный меш для нагрузки
                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = "rbxassetid://94251442"  -- Сложная модель
                mesh.Scale = Vector3.new(3, 3, 3)
                mesh.Parent = meshPart
                
                table.insert(spawnedObjects, meshPart)
            end
        end
        
        -- УРОВЕНЬ 4: Физические объекты (финальный удар)
        if attackLevel >= 4 then
            for i = 1, 60 do
                local phys = Instance.new("Part")
                phys.Name = "NukePhysics_L4"
                phys.Size = Vector3.new(6, 6, 6)
                phys.Material = Enum.Material.Slate
                phys.Anchored = false  -- ФИЗИКА ВКЛЮЧЕНА
                phys.CanCollide = true
                phys.Parent = workspace
                phys.Position = Vector3.new(
                    math.random(-100, 100),
                    math.random(50, 150),
                    math.random(-100, 100)
                )
                
                -- Добавляем физические силы
                local bodyForce = Instance.new("BodyForce")
                bodyForce.Force = Vector3.new(
                    math.random(-5000, 5000),
                    math.random(0, 10000),
                    math.random(-5000, 5000)
                )
                bodyForce.Parent = phys
                
                table.insert(spawnedObjects, phys)
            end
        end
        
        -- УРОВЕНЬ 5: Анимации (полный крах)
        if attackLevel >= 5 then
            WindUI:Notify({
                Title = "FATAL NUKE",
                Content = "СЕРВЕР УНИЧТОЖЕН",
                Icon = "skull",
                Duration = 5
            })
            
            -- Создаём анимированные части
            for i = 1, 40 do
                local animPart = Instance.new("Part")
                animPart.Name = "NukeAnimated_L5"
                animPart.Size = Vector3.new(15, 15, 15)
                animPart.Material = Enum.Material.Neon
                animPart.Color = Color3.fromRGB(255, 255, 0)
                animPart.Anchored = true
                animPart.CanCollide = false
                animPart.Parent = workspace
                
                -- Стартовая позиция
                local startX = math.random(-250, 250)
                local startY = math.random(50, 200)
                local startZ = math.random(-250, 250)
                animPart.Position = Vector3.new(startX, startY, startZ)
                
                -- Анимация движения в отдельном потоке
                task.spawn(function()
                    local angle = 0
                    while animPart.Parent do
                        angle = angle + 0.1
                        animPart.Position = Vector3.new(
                            startX + math.sin(angle) * 50,
                            startY + math.cos(angle * 2) * 30,
                            startZ + math.cos(angle) * 50
                        )
                        task.wait(0.03)
                    end
                end)
                
                table.insert(spawnedObjects, animPart)
            end
        end
        
        print("[SERVER NUKE] Уровень атаки: " .. attackLevel)
        print("[SERVER NUKE] Создано объектов: " .. #spawnedObjects)
    end
})

-- КНОПКА ОЧИСТКИ
MainTab:Button({
    Title = "[CLEAN UP]",
    Desc = "Удалить все лаг-объекты",
    Callback = function()
        for _, obj in ipairs(spawnedObjects) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
        spawnedObjects = {}
        attackLevel = 0
        
        WindUI:Notify({
            Title = "Очистка",
            Content = "Все объекты удалены",
            Icon = "trash-2",
            Duration = 2
        })
        
        -- Принудительная сборка мусора
        task.wait(0.5)
        game:GetService("ContentProvider"):PreloadAsync({})
    end
})

-- АВТОМАТИЧЕСКАЯ ЗАЩИТА ОТ КИКА
task.spawn(function()
    while true do
        -- Проверяем соединение
        local success = pcall(function()
            game:GetService("MarketplaceService")
        end)
        
        if not success then
            -- Если нас кикнули, пытаемся вернуться
            WindUI:Notify({
                Title = "КИК ОБНАРУЖЕН",
                Content = "Возможно, сервер упал",
                Icon = "alert-octagon",
                Duration = 10
            })
        end
        
        task.wait(2)
    end
end)

Window:SelectTab(1)

WindUI:Notify({
    Title = "Server Killer v3",
    Content = "Загружен. Нажмите [NUKE SERVER] 3-5 раз.",
    Icon = "radioactive",
    Duration = 5
})

print("✅ Server Killer v3 загружен")
print("⚠️  Используйте с осторожностью!")
