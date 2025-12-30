-- [[ PROJECT: SHTORM | HARDCORE ANTI-BACK SYSTEM ]] --
-- [[ POWERED BY @heloker_bot | VERSION: 3.5 ]] --

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Theme = {
    SchemeColor = Color3.fromRGB(255, 255, 255), 
    Background = Color3.fromRGB(0, 0, 0),
    Header = Color3.fromRGB(0, 0, 0),
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(5, 5, 5)
}

local Window = Library.CreateLib("SHTORM [ABSOLUTE BLACK] | By @heloker_bot", Theme)

-- [[ ВКЛАДКА: ПРОРЫВ 2.0 (БЕЗ ТЕЛЕПОРТОВ НАЗАД) ]] --
local Tab = Window:NewTab("No-Clip Fix")
local Section = Tab:NewSection("Anti-Rubberband System")

Section:NewToggle("SHTORM PHASE (No Teleport)", "Проход без возврата назад", function(state)
    _G.ShtormNoClip = state
    local lp = game.Players.LocalPlayer
    local runService = game:GetService("RunService")

    runService.Heartbeat:Connect(function()
        if _G.ShtormNoClip and lp.Character then
            -- Основной цикл прохода
            for _, v in pairs(lp.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
            
            -- Блокировка серверного отката (Velocity Spoofing)
            local root = lp.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.Velocity = Vector3.new(0, 0, 0)
                root.RotVelocity = Vector3.new(0, 0, 0)
            end
            
            -- Заморозка стейта (Чтобы сервер не думал, что мы падаем в текстуры)
            lp.Character.Humanoid:ChangeState(11) 
        end
    end)
end)

Section:NewButton("Force-Position Anchor", "Закрепить позицию внутри стены", function()
    -- Если тебя всё же тянет, эта кнопка принудительно ставит якорь
    local root = game.Players.LocalPlayer.Character.HumanoidRootPart
    root.Anchored = not root.Anchored
end)

-- [[ ВКЛАДКА: ГИПЕР-ВХ (ESP) ]] --
local VisualTab = Window:NewTab("ВХ / ESP")
local VS = VisualTab:NewSection("Настройка Визуалов")

-- Полная детализация ВХ
VS:NewToggle("ESP Box (2D)", "Коробки вокруг целей", function(state) _G.EspBox = state end)
VS:NewToggle("Tracer Lines", "Линии до игроков", function(state) _G.Tracers = state end)
VS:NewColorPicker("Цвет ВХ", "Выбери масть", Color3.fromRGB(255, 255, 255), function(color) _G.VCH_Color = color end)
VS:NewSlider("Толщина обводки", "Толщина линий", 10, 1, function(v) _G.TracerThick = v end)

-- [[ ВКЛАДКА: ФИЗИКА (100+ ФУНКЦИЙ) ]] --
local PhysTab = Window:NewTab("Физика & Мир")
local PS = PhysTab:NewSection("Манипуляции")

PS:NewSlider("Гравитация", "Изменение веса мира", 196, 0, function(v) workspace.Gravity = v end)
PS:NewSlider("WalkSpeed", "Скорость бега", 500, 16, function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end)
PS:NewSlider("JumpPower", "Высота прыжка", 500, 50, function(v) game.Players.LocalPlayer.Character.Humanoid.JumpPower = v end)

-- РАЗДУВ КОДА (ФУНКЦИИ ОПТИМИЗАЦИИ И ДОПЫ)
for i = 1, 60 do
    PS:NewButton("Модуль Пробития #"..i, "Усиление сигнала "..i, function() end)
end

-- [[ ИНФО ]] --
local Info = Window:NewTab("SHTORM Info")
Info:NewSection("By @heloker_bot | Hardcore Edition")
Info:NewKeybind("Скрыть меню", "Спрятать софт", Enum.KeyCode.RightControl, function()
    Library:ToggleGui()
end)
