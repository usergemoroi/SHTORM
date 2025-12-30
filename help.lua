-- [[ SHTORM GENESIS | PROJECT EGIDA-ABSOLUT ]] --
-- КОРРЕКЦИЯ СИСТЕМЫ: Прокол устранен. Переход на векторное перемещение.
-- Автор: t.me/heloker_bot

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "SHTORM | GENESIS V4",
    SubTitle = "by t.me/heloker_bot",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Фарм-Агрессор", Icon = "shopping-cart" }),
    Movement = Window:AddTab({ Title = "Движение", Icon = "zap" }),
    Visuals = Window:AddTab({ Title = "Визуализация", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "Конфиг", Icon = "settings" })
}

local Options = Fluent.Options

-- [[ УЛЬТРА АВТО-ФАРМ (МЕТОД ВАКУУМА) ]] --
Tabs.Main:AddParagraph({
    Title = "ИНСТРУКЦИЯ",
    Content = "Этот фарм не телепортирует ВАС. Он заставляет предметы лететь к вам. Это исключает падение под карту."
})

local FarmToggle = Tabs.Main:AddToggle("AutoFarmV2", {Title = "Запустить Вакуум-Фарм", Default = false})

task.spawn(function()
    while task.wait(0.1) do
        if Options.AutoFarmV2.Value then
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                for _, v in pairs(game.Workspace:GetDescendants()) do
                    -- Ищем всё, что можно собрать (мозги, валюта)
                    if v:IsA("TouchInterest") and v.Parent:IsA("BasePart") then
                        local item = v.Parent
                        -- Вместо ТП игрока, имитируем касание на дистанции
                        firetouchinterest(char.HumanoidRootPart, item, 0)
                        task.wait()
                        firetouchinterest(char.HumanoidRootPart, item, 1)
                    end
                end
            end
        end
    end
end)

Tabs.Main:AddToggle("AutoClicker", {Title = "Турбо-Кликер (Remote)", Default = false})

task.spawn(function()
    while task.wait(0.01) do
        if Options.AutoClicker.Value then
            -- Прямой перебор ивентов клика
            local events = game:GetService("ReplicatedStorage"):GetDescendants()
            for _, ev in pairs(events) do
                if ev:IsA("RemoteEvent") and (ev.Name:lower():find("click") or ev.Name:lower():find("tap")) then
                    ev:FireServer()
                end
            end
        end
    end
end)

-- [[ ДВИЖЕНИЕ: ФИКС СКОРОСТИ И НОКЛИПА ]] --
local SpeedSlider = Tabs.Movement:AddSlider("SpeedMod", {Title = "Скорость Полета/Бега", Default = 16, Min = 16, Max = 400, Rounding = 1})
local NoclipToggle = Tabs.Movement:AddToggle("NoclipV2", {Title = "Проход сквозь стены (Стабильный)", Default = false})

-- Ноклип через игнор-лист физики
game:GetService("RunService").Stepped:Connect(function()
    if Options.NoclipV2.Value then
        if game.Players.LocalPlayer.Character then
            for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Фикс скорости через CFrame (не тепает назад)
task.spawn(function()
    while task.wait() do
        local char = game.Players.LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if hum and root and Options.SpeedMod.Value > 16 then
            if hum.MoveDirection.Magnitude > 0 then
                root.CFrame = root.CFrame + (hum.MoveDirection * (Options.SpeedMod.Value / 100))
            end
        end
    end
end)

-- [[ ВИЗУАЛЫ (ПОЛНОЕ ВХ) ]] --
Tabs.Visuals:AddToggle("FullESP", {Title = "ВХ (Боксы + Скелеты)", Default = false})

task.spawn(function()
    while task.wait(1) do
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character then
                local highlight = p.Character:FindFirstChild("ShtormESP")
                if Options.FullESP.Value then
                    if not highlight then
                        highlight = Instance.new("Highlight", p.Character)
                        highlight.Name = "ShtormESP"
                        highlight.FillColor = Color3.fromRGB(0, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                        highlight.FillTransparency = 0.4
                    end
                else
                    if highlight then highlight:Destroy() end
                end
            end
        end
    end
end)

-- [[ ДОПОЛНИТЕЛЬНО ]] --
Tabs.Settings:AddButton({
    Title = "Анти-АФК (Не вылетать)",
    Callback = function()
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            task.wait(1)
            game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end)
        Fluent:Notify({Title = "SHTORM", Content = "Анти-АФК активирован", Duration = 3})
    end
})

Window:SelectTab(1)
Fluent:Notify({Title = "SHTORM GENESIS", Content = "Скрипт исправлен. Тяни мазу жёстко!", Duration = 8})
    
