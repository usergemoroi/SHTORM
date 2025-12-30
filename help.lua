 -- [[ SHTORM VISUAL OVERHAUL | PROJECT EGIDA-ABSOLUT ]] --
-- КОРРЕКЦИЯ СИСТЕМЫ: Фарм удален. Визуальный блок усилен на 200%.
-- Автор: t.me/heloker_bot

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "SHTORM | VISUAL DOMINANCE",
    SubTitle = "by t.me/heloker_bot",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Visuals = Window:AddTab({ Title = "Шмон (ESP)", Icon = "eye" }),
    Physical = Window:AddTab({ Title = "Физика", Icon = "zap" }),
    World = Window:AddTab({ Title = "Мир", Icon = "globe" }),
    Settings = Window:AddTab({ Title = "Конфиг", Icon = "settings" })
}

local Options = Fluent.Options

-- [[ СЕКЦИЯ: ТОТАЛЬНОЕ ВХ ]] --
Tabs.Visuals:AddParagraph({Title = "Настройка Визора", Content = "Здесь ты настраиваешь, как будешь видеть крыс."})

local EspColor = Tabs.Visuals:AddColorpicker("EspColor", {Title = "Цвет ВХ", Default = Color3.fromRGB(255, 0, 0)})
local EspToggle = Tabs.Visuals:AddToggle("EspBox", {Title = "Боксы (Рамки)", Default = false})
local EspNames = Tabs.Visuals:AddToggle("EspNames", {Title = "Имена Игроков", Default = false})
local EspDist = Tabs.Visuals:AddToggle("EspDist", {Title = "Дистанция", Default = false})
local EspLines = Tabs.Visuals:AddToggle("EspLines", {Title = "Линии (Tracer)", Default = false})

task.spawn(function()
    while task.wait(0.1) do
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local char = p.Character
                
                -- 1. HIGHLIGHT (Боксы/Заливка)
                local high = char:FindFirstChild("ShtormHigh")
                if Options.EspBox.Value then
                    if not high then
                        high = Instance.new("Highlight", char)
                        high.Name = "ShtormHigh"
                    end
                    high.FillColor = EspColor.Value
                    high.OutlineColor = Color3.fromRGB(255, 255, 255)
                    high.FillTransparency = 0.5
                elseif high then high:Destroy() end

                -- 2. BILLBOARD (Имена и Дистанция)
                local bill = char:FindFirstChild("ShtormBill")
                if Options.EspNames.Value or Options.EspDist.Value then
                    if not bill then
                        bill = Instance.new("BillboardGui", char.Head)
                        bill.Name = "ShtormBill"
                        bill.Size = UDim2.new(0, 200, 0, 50)
                        bill.AlwaysOnTop = true
                        bill.ExtentsOffset = Vector3.new(0, 3, 0)
                        local lab = Instance.new("TextLabel", bill)
                        lab.BackgroundTransparency = 1
                        lab.Size = UDim2.new(1, 0, 1, 0)
                        lab.Font = Enum.Font.Code
                        lab.TextSize = 14
                        lab.TextColor3 = Color3.fromRGB(255, 255, 255)
                        lab.TextStrokeTransparency = 0
                    end
                    local dist = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude)
                    local text = ""
                    if Options.EspNames.Value then text = text .. p.Name end
                    if Options.EspDist.Value then text = text .. " [" .. dist .. "m]" end
                    bill.TextLabel.Text = text
                    bill.TextLabel.TextColor3 = EspColor.Value
                elseif bill then bill:Destroy() end
            end
        end
    end
end)

-- [[ СЕКЦИЯ: РАБОЧАЯ ФИЗИКА ]] --
Tabs.Physical:AddSlider("WS", {Title = "Скорость (CFrame)", Default = 16, Min = 16, Max = 250, Rounding = 1})
Tabs.Physical:AddSlider("JP", {Title = "Сила Прыжка", Default = 50, Min = 50, Max = 500, Rounding = 1})
Tabs.Physical:AddToggle("Noclip", {Title = "Проход сквозь стены", Default = false})
Tabs.Physical:AddToggle("InfiniteJump", {Title = "Бесконечный прыжок", Default = false})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if Options.InfiniteJump.Value then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

game:GetService("RunService").Stepped:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if char and Options.Noclip.Value then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

task.spawn(function()
    while task.wait() do
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hum = char.Humanoid
            if Options.WS.Value > 16 and hum.MoveDirection.Magnitude > 0 then
                char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (hum.MoveDirection * (Options.WS.Value / 100))
            end
            hum.JumpPower = Options.JP.Value
        end
    end
end)

-- [[ СЕКЦИЯ: МИР И ТРОЛЛИНГ ]] --
Tabs.World:AddButton({Title = "Удалить Текстуры (FPS Boost)", Callback = function()
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end
    end
end})

Tabs.World:AddButton({Title = "FullBright (Убрать темноту)", Callback = function()
    game.Lighting.Brightness = 2
    game.Lighting.ClockTime = 14
    game.Lighting.FogEnd = 100000
    game.Lighting.GlobalShadows = false
end})

Tabs.World:AddToggle("AntiRagdoll", {Title = "Анти-Падение (No Ragdoll)", Default = false})

-- [[ НАСТРОЙКИ ]] --
Tabs.Settings:AddButton({Title = "Destroy Menu", Callback = function() Window:Destroy() end})

Window:SelectTab(1)
Fluent:Notify({Title = "SHTORM V5", Content = "t.me/heloker_bot - Маза тянется!", Duration = 5})
