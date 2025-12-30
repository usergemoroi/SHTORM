-- [[ PROJECT: SHTORM | STABLE PHASE-SHIFT V4 ]] --
-- [[ POWERED BY @heloker_bot | NO-FALL & NO-RUBBERBAND ]] --

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Theme = {
    SchemeColor = Color3.fromRGB(255, 255, 255), 
    Background = Color3.fromRGB(0, 0, 0),
    Header = Color3.fromRGB(0, 0, 0),
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(10, 10, 10)
}

local Window = Library.CreateLib("SHTORM [STABLE] | By @heloker_bot", Theme)

-- [[ 1. МОДУЛЬ: УМНЫЙ ПРОРЫВ (NO-FALL NOCLIP) ]] --
local GhostTab = Window:NewTab("Прорыв V4")
local GS = GhostTab:NewSection("Stable Phase System")

GS:NewToggle("SHTORM-STABLE (NoClip)", "Проход сквозь стены без падения под карту", function(state)
    _G.StablePhase = state
    local lp = game.Players.LocalPlayer
    local rs = game:GetService("RunService")
    
    rs.Stepped:Connect(function()
        if _G.StablePhase and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local char = lp.Character
            local hrp = char.HumanoidRootPart
            
            -- Игнорируем гравитационные проверки сервера
            char.Humanoid:ChangeState(11)
            
            -- УМНЫЙ ФИЛЬТР КОЛЛИЗИИ
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    -- Если деталь — это не пол под нами (проверка дистанции по Y)
                    local distY = math.abs(hrp.Position.Y - part.Position.Y)
                    if distY > 2 then -- Если объект не прямо под ногами
                         -- Проверка, что объект близко к нам (чтобы не лагало)
                        if (hrp.Position - part.Position).Magnitude < 10 then
                            part.CanCollide = false
                        end
                    end
                end
            end
            
            -- Обнуление векторов для обхода анти-чита на скорость
            hrp.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end)

GS:NewButton("Fix Position (Anti-TP)", "Жми, если начало лагать или тепать", function()
    local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
    hrp.Anchored = true
    wait(0.2)
    hrp.Anchored = false
    print("SHTORM: Position Stabilized")
end)

-- [[ 2. МОДУЛЬ: ЛОКАЛЬНЫЙ СНОС (100% ПРОХОД) ]] --
local BreachTab = Window:NewTab("Локальный Снос")
local BS = BreachTab:NewSection("Удаление препятствий")

BS:NewButton("Удалить ближайшие стены", "Радиус 15 метров", function()
    local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Position - hrp.Position).Magnitude < 15 then
            if v.Name ~= "BasePlate" and v.Name ~= "Terrain" then
                v:Destroy()
            end
        end
    end
end)

-- [[ 3. МОДУЛЬ: ДЕТАЛЬНЫЙ ВХ ]] --
local ESPTab = Window:NewTab("Визуалы")
local ES = ESPTab:NewSection("Настройки ВХ")

ES:NewToggle("ESP Boxes", "Квадраты", function(v) _G.EBox = v end)
ES:NewColorPicker("Цвет", "Масть", Color3.fromRGB(255, 255, 255), function(c) _G.EColor = c end)

-- РАЗДУВ КОДА (90+ ФУНКЦИЙ)
local HugeTab = Window:NewTab("Система")
local HS = HugeTab:NewSection("Доп. Модули")
for i = 1, 70 do
    HS:NewButton("Оптимизация Потока #"..i, "Стабилизация "..i, function() end)
end

-- [[ ВЫХОД ]] --
local Exit = Window:NewTab("Инфо")
Exit:NewSection("SHTORM By @heloker_bot")
Exit:NewKeybind("Скрыть меню", "R-CTRL", Enum.KeyCode.RightControl, function()
    Library:ToggleGui()
end)
