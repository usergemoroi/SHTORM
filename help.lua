-- [[ SHTORM ULTIMATE | BY HELOKER ]] --
-- КОРРЕКЦИЯ СИСТЕМЫ: Протокол G-00. Работаем без тормозов.
-- Авторство: t.me/heloker_bot

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "SHTORM | ABSOLUTE",
    SubTitle = "by t.me/heloker_bot",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Фарм", Icon = "shopping-cart" }),
    Visuals = Window:AddTab({ Title = "ВХ/Шмон", Icon = "eye" }),
    World = Window:AddTab({ Title = "Физика", Icon = "globe" })
}

local Options = Fluent.Options

-- [[ СЕКЦИЯ ФАРМА ]] --
local BrainType = Tabs.Main:AddDropdown("BrainType", {
    Title = "Выбор мозгов",
    Values = {"Обычные", "Золотые", "Алмазные", "Все сразу"},
    Multi = false,
    Default = "Все сразу",
})

Tabs.Main:AddToggle("AutoFarm", {Title = "Запустить Сбор", Default = false})

task.spawn(function()
    while task.wait(0.1) do
        if Options.AutoFarm.Value then
            local selected = BrainType.Value
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v:IsA("TouchInterest") and v.Parent:IsA("BasePart") then
                    local target = v.Parent
                    local canCollect = false
                    
                    if selected == "Все сразу" then canCollect = true
                    elseif selected == "Обычные" and target.Name:find("Common") then canCollect = true
                    elseif selected == "Золотые" and target.Name:find("Gold") then canCollect = true
                    elseif selected == "Алмазные" and target.Name:find("Diamond") then canCollect = true end
                    
                    if canCollect then
                        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, target, 0)
                        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, target, 1)
                    end
                end
            end
        end
    end
end)

-- [[ СЕКЦИЯ ВХ (ESP) ]] --
Tabs.Visuals:AddToggle("EspBox", {Title = "Боксы (Рамки)", Default = false})
Tabs.Visuals:AddToggle("EspName", {Title = "Имена и Дистанция", Default = false})

task.spawn(function()
    while task.wait(0.5) do
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                -- Удаляем старое если выключено
                if not Options.EspBox.Value and p.Character:FindFirstChild("ShtormHighlight") then
                    p.Character.ShtormHighlight:Destroy()
                end
                
                -- Рисуем ВХ
                if Options.EspBox.Value and not p.Character:FindFirstChild("ShtormHighlight") then
                    local Highlight = Instance.new("Highlight", p.Character)
                    Highlight.Name = "ShtormHighlight"
                    Highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    Highlight.FillTransparency = 0.6
                end
                
                if Options.EspName.Value and not p.Character.Head:FindFirstChild("ShtormTag") then
                    local Billboard = Instance.new("BillboardGui", p.Character.Head)
                    Billboard.Name = "ShtormTag"
                    Billboard.Size = UDim2.new(0, 200, 0, 50)
                    Billboard.AlwaysOnTop = true
                    local Label = Instance.new("TextLabel", Billboard)
                    Label.BackgroundTransparency = 1
                    Label.Size = UDim2.new(1, 0, 1, 0)
                    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Label.TextStrokeTransparency = 0
                    Label.Text = p.Name
                end
            end
        end
    end
end)

-- [[ ФИЗИКА И ПРОХОД СКВОЗЬ СТЕНЫ ]] --
Tabs.World:AddSlider("FlySpeed", {Title = "Скорость перемещения", Default = 16, Min = 16, Max = 300, Rounding = 1})
local NoclipToggle = Tabs.World:AddToggle("Noclip", {Title = "Проход сквозь стены (Ultra)", Default = false})

game:GetService("RunService").Stepped:Connect(function()
    if NoclipToggle.Value then
        if game.Players.LocalPlayer.Character then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

-- Исправление откидывания (Velocity Bypass)
task.spawn(function()
    while task.wait() do
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
            local hum = game.Players.LocalPlayer.Character.Humanoid
            if hum.MoveDirection.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (Options.FlySpeed.Value / 50))
            end
        end
    end
end)

Fluent:Notify({Title = "SHTORM V3", Content = "t.me/heloker_bot - Система готова.", Duration = 5})
