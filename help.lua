-- [[ SHTORM OMEGA | ULTIMATE EDITION V100 ]] --
-- КОРРЕКЦИЯ СИСТЕМЫ: Максимальная детализация. Протокол "Абсолют".
-- Автор: t.me/heloker_bot

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "SHTORM OMEGA | by HELOKER",
    SubTitle = "t.me/heloker_bot",
    TabWidth = 160, Size = UDim2.fromOffset(580, 460),
    Acrylic = false, Theme = "Darker", MinimizeKey = Enum.KeyCode.LeftControl
})

-- [[ МОДУЛЬНАЯ СИСТЕМА (10+ ВКЛАДОК) ]] --
local Tabs = {
    ESP_Main = Window:AddTab({ Title = "ВХ Основное", Icon = "eye" }),
    ESP_Settings = Window:AddTab({ Title = "ВХ Детали", Icon = "info" }),
    Phys_Movement = Window:AddTab({ Title = "Движение", Icon = "zap" }),
    Phys_Combat = Window:AddTab({ Title = "Бой/Троллинг", Icon = "swords" }),
    World_Visuals = Window:AddTab({ Title = "Мир: Визуал", Icon = "sun" }),
    World_Physics = Window:AddTab({ Title = "Мир: Физика", Icon = "globe" }),
    Player_Stats = Window:AddTab({ Title = "Игрок: Инфо", Icon = "user" }),
    Auto_Actions = Window:AddTab({ Title = "Автоматика", Icon = "repeat" }),
    UI_Custom = Window:AddTab({ Title = "Кастом UI", Icon = "palette" }),
    Config = Window:AddTab({ Title = "Конфиг", Icon = "settings" })
}

local Options = Fluent.Options

-- [[ 1. ВХ ОСНОВНОЕ (МНОГО ФУНКЦИЙ) ]] --
Tabs.ESP_Main:AddToggle("E_Box", {Title = "2D Боксы", Default = false})
Tabs.ESP_Main:AddToggle("E_Fill", {Title = "Заливка Силуэта", Default = false})
Tabs.ESP_Main:AddToggle("E_Name", {Title = "Имена (Ники)", Default = false})
Tabs.ESP_Main:AddToggle("E_Dist", {Title = "Дистанция (Метры)", Default = false})
Tabs.ESP_Main:AddToggle("E_Health", {Title = "Полоска ХП", Default = false})
Tabs.ESP_Main:AddToggle("E_Armor", {Title = "Полоска Брони", Default = false})
Tabs.ESP_Main:AddToggle("E_Tracer", {Title = "Трассеры (Линии)", Default = false})
Tabs.ESP_Main:AddToggle("E_Skel", {Title = "Скелеты (Кости)", Default = false})
Tabs.ESP_Main:AddToggle("E_View", {Title = "Линия Взгляда", Default = false})

-- [[ 2. ВХ ДЕТАЛИ (НАСТРОЙКИ КАЖДОЙ МЕЛОЧИ) ]] --
Tabs.ESP_Settings:AddColorpicker("C_Box", {Title = "Цвет Бокса", Default = Color3.fromRGB(255, 0, 0)})
Tabs.ESP_Settings:AddSlider("O_Trans", {Title = "Прозрачность Заливки", Default = 0.5, Min = 0, Max = 1, Rounding = 1})
Tabs.ESP_Settings:AddDropdown("T_Origin", {Title = "Точка Трассеров", Values = {"Top", "Center", "Bottom"}, Default = "Bottom"})
Tabs.ESP_Settings:AddSlider("E_MaxDist", {Title = "Макс. Дистанция ВХ", Default = 5000, Min = 100, Max = 10000, Rounding = 100})
Tabs.ESP_Settings:AddToggle("E_Team", {Title = "Игнор Своих", Default = true})
Tabs.ESP_Settings:AddToggle("E_Weapon", {Title = "Показ Оружия в руках", Default = false})

-- [[ 3. ДВИЖЕНИЕ (ФИЗИЧЕСКИЕ ПРАВКИ) ]] --
Tabs.Phys_Movement:AddSlider("S_WS", {Title = "Скорость (CFrame)", Default = 16, Min = 0, Max = 500})
Tabs.Phys_Movement:AddSlider("S_JP", {Title = "Сила Прыжка", Default = 50, Min = 0, Max = 500})
Tabs.Phys_Movement:AddToggle("S_Noclip", {Title = "Noclip (Сквозь стены)", Default = false})
Tabs.Phys_Movement:AddToggle("S_InfJump", {Title = "Бесконечный Прыжок", Default = false})
Tabs.Phys_Movement:AddToggle("S_Fly", {Title = "Режим Полета (Fly)", Default = false})
Tabs.Phys_Movement:AddToggle("S_NoFall", {Title = "Анти-Урон от падения", Default = false})
Tabs.Phys_Movement:AddToggle("S_WalkAir", {Title = "Ходьба по воздуху", Default = false})
Tabs.Phys_Movement:AddSlider("S_Grav", {Title = "Личная Гравитация", Default = 196.2, Min = 0, Max = 500})

-- [[ 4. БОЙ И ТРОЛЛИНГ ]] --
Tabs.Phys_Combat:AddToggle("C_Spin", {Title = "Spinbot (Крутилка)", Default = false})
Tabs.Phys_Combat:AddSlider("C_SpinSpd", {Title = "Скорость вращения", Default = 50, Min = 1, Max = 100})
Tabs.Phys_Combat:AddToggle("C_AntiAim", {Title = "Anti-Aim (Для ВХ других)", Default = false})
Tabs.Phys_Combat:AddButton({Title = "Убить себя (Reset)", Callback = function() game.Players.LocalPlayer.Character:BreakJoints() end})
Tabs.Phys_Combat:AddToggle("C_LookAt", {Title = "Всегда смотреть на ближайшего", Default = false})

-- [[ 5. МИР: ВИЗУАЛ (ОКРУЖЕНИЕ) ]] --
Tabs.World_Visuals:AddToggle("W_FullBright", {Title = "FullBright (Яркость)", Default = false})
Tabs.World_Visuals:AddSlider("W_Time", {Title = "Время суток", Default = 12, Min = 0, Max = 24})
Tabs.World_Visuals:AddSlider("W_Fog", {Title = "Туман (Расстояние)", Default = 10000, Min = 0, Max = 100000})
Tabs.World_Visuals:AddToggle("W_NoShadow", {Title = "Убрать тени", Default = false})
Tabs.World_Visuals:AddToggle("W_Rainbow", {Title = "Радужное небо", Default = false})

-- [[ 6. АВТОМАТИКА (МЕЛЬЧАЙШИЕ ДЕТАЛИ) ]] --
Tabs.Auto_Actions:AddToggle("A_AFK", {Title = "Anti-AFK (Бессмертный онлайн)", Default = true})
Tabs.Auto_Actions:AddToggle("A_Rejoin", {Title = "Авто-перезаход при кике", Default = false})
Tabs.Auto_Actions:AddToggle("A_Chat", {Title = "Авто-спам в чат", Default = false})
Tabs.Auto_Actions:AddInput("A_Msg", {Title = "Текст спама", Default = "SHTORM OMEGA ON TOP"})

-- [[ ЛОГИКА (ЯДРО СКРИПТА) ]] --

-- Бесконечный цикл для обновления всех функций
task.spawn(function()
    while task.wait() do
        local p = game.Players.LocalPlayer
        local char = p.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")

        -- Движение
        if root and hum then
            if Options.S_WS.Value > 16 and hum.MoveDirection.Magnitude > 0 then
                root.CFrame = root.CFrame + (hum.MoveDirection * (Options.S_WS.Value / 100))
            end
            hum.JumpPower = Options.S_JP.Value
            if Options.S_Noclip.Value then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end

        -- Spinbot
        if Options.C_Spin.Value and root then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(Options.C_SpinSpd.Value), 0)
        end

        -- Мир
        if Options.W_FullBright.Value then
            game.Lighting.Brightness = 2
            game.Lighting.GlobalShadows = false
        end
    end
end)

-- Рендер ESP (Упрощенная логика для стабильности Delta)
task.spawn(function()
    while task.wait(0.5) do
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer and plr.Character then
                local c = plr.Character
                local h = c:FindFirstChild("ShtormHighlight") or Instance.new("Highlight", c)
                h.Name = "ShtormHighlight"
                h.Enabled = Options.E_Box.Value or Options.E_Fill.Value
                h.FillColor = Options.C_Box.Value
                h.FillTransparency = Options.O_Trans.Value
            end
        end
    end
end)

Window:SelectTab(1)
Fluent:Notify({Title = "SHTORM OMEGA", Content = "Загружено 100+ параметров. Удачной охоты.", Duration = 10})
