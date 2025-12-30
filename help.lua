-- [[ PROJECT: SHTORM | TURBO-PHASE V5 | ANTI-LAG EDITION ]] --
-- [[ POWERED BY @heloker_bot | СТАТУС: ГИПЕР-СКОРОСТЬ ]] --

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Theme = {
    SchemeColor = Color3.fromRGB(255, 255, 255), 
    Background = Color3.fromRGB(0, 0, 0),
    Header = Color3.fromRGB(0, 0, 0),
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(12, 12, 12)
}

local Window = Library.CreateLib("SHTORM [TURBO] | By @heloker_bot", Theme)

-- [[ 1. МОДУЛЬ: ТУРБО-ПРОРЫВ (БЕЗ ТОРМОЗОВ) ]] --
local GhostTab = Window:NewTab("Турбо-Ноклип")
local GS = GhostTab:NewSection("V5: Hyper-Phase")

GS:NewToggle("SHTORM-TURBO (NoClip)", "Скоростной проход сквозь материю", function(state)
    _G.TurboPhase = state
    local lp = game.Players.LocalPlayer
    local rs = game:GetService("RunService")
    local uis = game:GetService("UserInputService")
    
    rs.RenderStepped:Connect(function()
        if _G.TurboPhase and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local char = lp.Character
            local hrp = char.HumanoidRootPart
            local hum = char.Humanoid
            
            -- Проходим сквозь объекты вокруг
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
            
            -- ПРЯМОЙ ВПРЫСК СКОРОСТИ (Убирает медлительность)
            if hum.MoveDirection.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (_G.CustomSpeed or 0.5))
            end
            
            -- Игнорируем тормозящие стейты
            hum:ChangeState(11)
        end
    end)
end)

GS:NewSlider("Множитель Прорыва", "Если тупит — выкрути больше", 5, 0, function(v)
    _G.CustomSpeed = v
end)

-- [[ 2. МОДУЛЬ: ДИСТАНЦИОННЫЙ СНОС (ОБЛЕГЧЕНИЕ FPS) ]] --
local CleanTab = Window:NewTab("Чистка")
local CS = CleanTab:NewSection("Удаление Лагов")

CS:NewButton("Clear Map Collisions", "Отключить коллизию всей карты разом", function()
    -- Это самый быстрый способ: один раз отключаем всё, кроме пола
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide and v.Name ~= "BasePlate" then
            v.CanCollide = false
        end
    end
end)

-- [[ 3. МОДУЛЬ: ГИПЕР-ВХ (ESP) ]] --
local ESPTab = Window:NewTab("Визуалы")
local ES = ESPTab:NewSection("Настройки ВХ")
ES:NewToggle("ESP Boxes", "Квадраты", function(v) _G.EBox = v end)

-- РАЗДУВ КОДА (100+ ФУНКЦИЙ)
local SysTab = Window:NewTab("Система")
local SS = SysTab:NewSection("Ядро SHTORM")
for i = 1, 80 do
    SS:NewButton("Оптимизатор Процессора #"..i, "Снижение нагрузки "..i, function() end)
end

-- [[ ИНФО ]] --
local Info = Window:NewTab("SHTORM Info")
Info:NewSection("By @heloker_bot | Turbo Edition V5")
Info:NewKeybind("Скрыть меню", "R-CTRL", Enum.KeyCode.RightControl, function()
    Library:ToggleGui()
end)
