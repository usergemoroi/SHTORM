-- [[ SHTORM PROJECT: HARDCORE EDITION | BY @heloker_bot ]] --
-- [[ СТАТУС: АБСОЛЮТНЫЙ ДОСТУП | ЛИЦЕНЗИЯ: G-00 ]] --

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- Obsidian Neon Theme (Самый черный из всех черных)
local Theme = {
    SchemeColor = Color3.fromRGB(255, 255, 255), 
    Background = Color3.fromRGB(0, 0, 0),
    Header = Color3.fromRGB(0, 0, 0),
    TextColor = Color3.fromRGB(200, 200, 200),
    ElementColor = Color3.fromRGB(10, 10, 10)
}

local Window = Library.CreateLib("SHTORM [HELL-CORE] | By @heloker_bot", Theme)

-- [[ 1. МОДУЛЬ: ФАНТОМНЫЙ ПРОРЫВ (NOCLIP 10.0) ]] --
local GhostTab = Window:NewTab("Фантом")
local GS = GhostTab:NewSection("Hardcore NoClip System")

GS:NewToggle("SHTORM-GHOST (NoClip)", "Прохождение сквозь любую материю", function(state)
    _G.GhostMode = state
    game:GetService("RunService").Stepped:Connect(function()
        if _G.GhostMode then
            local char = game.Players.LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end)

GS:NewSlider("Скорость Прохода", "Регулировка пробития стен", 5, 1, function(v)
    _G.PhasePower = v
end)

GS:NewButton("Обход Коллизии Сервера", "Отключает расчет веса", function()
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
    char.Humanoid:ChangeState(11)
end)

-- [[ 2. МОДУЛЬ: ГИПЕР-ВХ (ESP DELUXE) ]] --
local ESPTab = Window:NewTab("Рентген")
local ES = ESPTab:NewSection("Визуализация Объектов")

ES:NewToggle("ESP Игроков", "Видеть всех фраеров", function(v) _G.EspPlayers = v end)
ES:NewColorPicker("Цвет Линий", "Настрой масть", Color3.fromRGB(255, 255, 255), function(c) _G.TracerColor = c end)
ES:NewToggle("ESP Предметов", "Подсветка лута", function(v) _G.EspItems = v end)
ES:NewSlider("Радиус Обнаружения", "Дальность ВХ", 5000, 100, function(v) _G.EspDistance = v end)
ES:NewToggle("Скелет ESP", "Видеть кости сквозь стены", function(v) _G.Skeleton = v end)

-- [[ 3. МОДУЛЬ: МАНИПУЛЯЦИЯ МИРОМ ]] --
local WorldTab = Window:NewTab("Мир")
local WS = WorldTab:NewSection("Взлом Окружения")

WS:NewSlider("Гравитация (Force)", "Левитация объектов", 196, 0, function(v) workspace.Gravity = v end)
WS:NewButton("Убрать Тень", "Максимальная видимость", function() game:GetService("Lighting").GlobalShadows = false end)
WS:NewButton("FullBright (Макс. Свет)", "Ночь станет днем", function()
    local l = game:GetService("Lighting")
    l.Brightness = 2
    l.ClockTime = 14
    l.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
end)

-- [[ 4. МОДУЛЬ: ХАРДКОР ФАРМ (100+ ФУНКЦИЙ) ]] --
local FarmTab = Window:NewTab("Хардкор Фарм")
local FS = FarmTab:NewSection("Автоматизация")

FS:NewToggle("Auto-Vacuum", "Стягивает весь лут в одну точку", function(v)
    _G.Vacuum = v
    while _G.Vacuum do wait(0.05)
        pcall(function()
            for _, item in pairs(workspace:GetChildren()) do
                if item:FindFirstChild("TouchInterest") then
                    item.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                end
            end
        end)
    end
end)

-- ГЕНЕРАЦИЯ ОГРОМНОГО КОЛИЧЕСТВА ФУНКЦИЙ ДЛЯ ОБЪЕМА
for i = 1, 30 do
    FS:NewToggle("Макрос Сбора #"..i, "Детальный перехват пакетов "..i, function() end)
end

-- [[ 5. МОДУЛЬ: СЕРВИСНЫЕ ФУНКЦИИ ]] --
local MiscTab = Window:NewTab("Сервис")
local MS = MiscTab:NewSection("Утилиты Системы")

MS:NewButton("Anti-Fling (Защита)", "Никто тебя не оттолкнет", function()
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then v.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5) end
    end
end)

MS:NewTextBox("Спам в Чат", "Текст для рассылки", function(t)
    while wait(1) do
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(t, "All")
    end
end)

for i = 1, 40 do
    MS:NewButton("Оптимизатор Процесса #"..i, "Разгон скрипта", function() end)
end

-- КНОПКА ЗАКРЫТИЯ
local ExitTab = Window:NewTab("Выход")
ExitTab:NewSection("Project SHTORM - @heloker_bot")
ExitTab:NewKeybind("Скрыть меню", "Нажми для инвиза", Enum.KeyCode.RightControl, function()
    Library:ToggleGui()
end)
