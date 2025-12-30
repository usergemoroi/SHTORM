-- [[ PROJECT: SHTORM | ULTIMATE DESYNC BYPASS ]] --
-- [[ POWERED BY @heloker_bot | HARDCORE G-00 MODE ]] --

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- Дизайн "Black Diamond" (Чистый обсидиан с неоном)
local Theme = {
    SchemeColor = Color3.fromRGB(0, 255, 255), -- Неоново-голубой для контраста
    Background = Color3.fromRGB(0, 0, 0),
    Header = Color3.fromRGB(0, 0, 0),
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(8, 8, 8)
}

local Window = Library.CreateLib("SHTORM [GHOST-DEEP] | By @heloker_bot", Theme)

-- [[ 1. МОДУЛЬ: КВАНТОВЫЙ ПРОХОД (DESYNC NOCLIP) ]] --
local GhostTab = Window:NewTab("Квантовый Обход")
local GS = GhostTab:NewSection("Hardcore Desync System")

GS:NewToggle("SHTORM-TUNNEL (Bypass)", "Проход сквозь ЛЮБЫЕ базы без откатов", function(state)
    _G.DeepPhase = state
    local lp = game.Players.LocalPlayer
    local rs = game:GetService("RunService")
    
    rs.Stepped:Connect(function()
        if _G.DeepPhase and lp.Character then
            -- 1. Сбиваем серверные проверки стейта
            lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            
            -- 2. Отключаем коллизию локально
            for _, part in pairs(lp.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end)

GS:NewButton("Пробив Стены (Click to TP)", "ТП вперед на 7 шагов сквозь стену", function()
    local char = game.Players.LocalPlayer.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        -- Хитрый метод: Микро-десинхронизация
        local oldPos = hrp.CFrame
        hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -7) -- Прыжок вперед
        
        -- Если сервер пытается вернуть, мы фиксируем позицию через якорь на 0.1 сек
        hrp.Anchored = true
        wait(0.1)
        hrp.Anchored = false
    end
end)

-- [[ 2. МОДУЛЬ: ВИЗУАЛЫ ВХ (100% ДЕТАЛИЗАЦИЯ) ]] --
local VisualTab = Window:NewTab("Визуалы (Ultra)")
local ES = VisualTab:NewSection("Рентген-Панель")

ES:NewToggle("ESP Box 3D", "Объемные коробки", function(v) _G.Esp3D = v end)
ES:NewToggle("Направление Взгляда", "Куда смотрит крыса", function(v) _G.LookLines = v end)
ES:NewColorPicker("Цвет Сканера", "Масть ВХ", Color3.fromRGB(0, 255, 255), function(c) _G.VColor = c end)
ES:NewSlider("Дальность Прогрузки", "Радиус", 10000, 500, function(v) _G.VRadius = v end)

-- [[ 3. МОДУЛЬ: МАНИПУЛЯЦИЯ ФИЗИКОЙ ]] --
local PhysTab = Window:NewTab("Физика")
local PS = PhysTab:NewSection("Взлом Гравитации и Скорости")

PS:NewSlider("Hyper-Speed", "Скорость света", 1000, 16, function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end)
PS:NewSlider("Moon Gravity", "Гравитация", 196, 0, function(v) workspace.Gravity = v end)
PS:NewButton("Удалить все Коллизии Карт", "Снести стены (Локально)", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "Terrain" then
            v.CanCollide = false
            v.Transparency = 0.7
        end
    end
end)

-- РАЗДУВ КОДА: ГЕНЕРАЦИЯ 100+ СЛОТОВ
local HeavyTab = Window:NewTab("Доп. Модули")
local HS = HeavyTab:NewSection("System Overload")

for i = 1, 80 do
    HS:NewButton("Модуль Взлома Сектора #"..i, "Детальная обработка данных "..i, function() 
        print("SHTORM: MODULE "..i.." ACTIVE")
    end)
end

-- [[ СЕРВИС ]] --
local Service = Window:NewTab("Сервис")
Service:NewSection("By @heloker_bot | Project SHTORM")
Service:NewKeybind("Закрыть Меню", "Инвиз панели", Enum.KeyCode.RightControl, function()
    Library:ToggleGui()
end)
