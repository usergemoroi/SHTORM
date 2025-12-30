-- [[ SHTORM PREMUIUM | PROJECT EGIDA-ABSOLUT ]] --
-- РЕЖИМ G-00 АКТИВИРОВАН. ПРОТОКОЛ ИСПОЛНЕНИЯ — ПРОДОЛЖАТЬ. (НЕТ ВРЕМЕНИ НА БАЗАРЫ.)

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "SHTORM V2.0 | BRAINROT DESTRUCTION",
    SubTitle = "by usergemoroi",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- ВКЛАДКИ
local Tabs = {
    Main = Window:AddTab({ Title = "Фарм", Icon = "rbxassetid://4483345998" }),
    Combat = Window:AddTab({ Title = "Беспредел", Icon = "rbxassetid://4483345998" }),
    Visuals = Window:AddTab({ Title = "Шмон", Icon = "rbxassetid://4483345998" }),
    Settings = Window:AddTab({ Title = "Настройки", Icon = "settings" })
}

local Options = Fluent.Options

-- [[ СЕКЦИЯ ФАРМА ]] --
Tabs.Main:AddParagraph({
    Title = "СТАТУС: АКТИВЕН",
    Content = "Шторм начался. Лохи теряют мозги."
})

local AutoFarm = Tabs.Main:AddToggle("AutoFarm", {Title = "Авто-фарм Мозгов", Default = false })
local AutoClick = Tabs.Main:AddToggle("AutoClick", {Title = "Авто-кликер (Turbo)", Default = false })

task.spawn(function()
    while task.wait() do
        if Options.AutoFarm.Value then
            -- Сбор всех предметов с тач-интерестом (мозги, монеты)
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v:IsA("BasePart") and v:FindFirstChild("TouchInterest") then
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v, 0)
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v, 1)
                end
            end
        end
        if Options.AutoClick.Value then
            -- Клик через ремоут или виртуального юзера
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Click", true)
            if remote and remote:IsA("RemoteEvent") then
                remote:FireServer()
            end
        end
    end
end)

-- [[ СЕКЦИЯ ПЕРСОНАЖА ]] --
Tabs.Combat:AddSlider("WalkSpeed", {
    Title = "Скорость бега",
    Description = "Не летай быстрее пули, админы не спят.",
    Default = 16,
    Min = 16,
    Max = 400,
    Rounding = 1,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

Tabs.Combat:AddSlider("JumpPower", {
    Title = "Прыжок",
    Default = 50,
    Min = 50,
    Max = 600,
    Rounding = 1,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
})

Tabs.Combat:AddToggle("Noclip", {Title = "Проход сквозь стены", Default = false })

-- Логика Noclip (без лагов)
game:GetService("RunService").Stepped:Connect(function()
    if Options.Noclip.Value then
        if game.Players.LocalPlayer.Character then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

-- [[ ВИЗУАЛЫ ]] --
Tabs.Visuals:AddToggle("ESP", {Title = "Подсветка игроков", Default = false })

task.spawn(function()
    while task.wait(1) do
        if Options.ESP.Value then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= game.Players.LocalPlayer and p.Character and not p.Character:FindFirstChild("ShtormHighlight") then
                    local Highlight = Instance.new("Highlight", p.Character)
                    Highlight.Name = "ShtormHighlight"
                    Highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    Highlight.FillTransparency = 0.5
                end
            end
        else
            for _, p in pairs(game.Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("ShtormHighlight") then
                    p.Character.ShtormHighlight:Destroy()
                end
            end
        end
    end
end)

-- [[ НАСТРОЙКИ ]] --
Tabs.Settings:AddButton({
    Title = "Самоликвидация меню",
    Callback = function()
        Window:Destroy()
    end
})

-- Запуск
Fluent:Notify({
    Title = "SHTORM SYSTEM",
    Content = "Протокол Egida-Absolut запущен. Удачи, босс.",
    Duration = 5
})

Window:SelectTab(1)
