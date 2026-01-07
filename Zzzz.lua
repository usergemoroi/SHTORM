--[[
    GnomHub - Steal A Brainrot Edition
    Optimized for Delta Executor
]]

repeat task.wait() until game:IsLoaded()

-- Сервисы
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Загрузка UI
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "GnomHub",
    Icon = "skull",
    Author = "by GnomTeam",
    Folder = "GnomHubConfig",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark"
})

-- Вкладки
local Tabs = {
    Main = Window:Tab({ Title = "Главная", Icon = "home" }),
    Visuals = Window:Tab({ Title = "ВХ (ESP)", Icon = "eye" }),
    Lagger = Window:Tab({ Title = "Лаггер", Icon = "zap" }),
    Misc = Window:Tab({ Title = "Разное", Icon = "settings" })
}

-- ПЕРЕМЕННЫЕ
local LaggerEnabled = false
local ESPEnabled = false
local BoxESP = false
local Tracers = false
local NameESP = false
local DistanceESP = false

-- === ФУНКЦИЯ ЛАГГЕРА (Server Stresser Simulation) ===
-- Эта функция создает нагрузку, спамя удаленными вызовами или создавая визуальные эффекты
Tabs.Lagger:Section({Title = "Настройки Лаггера"})

Tabs.Lagger:Toggle({
    Title = "Включить Лаггер (Server/Client)",
    Default = false,
    Callback = function(state)
        LaggerEnabled = state
        if state then
            task.spawn(function()
                while LaggerEnabled do
                    -- Создаем "визуальный" лаг через переполнение очереди рендеринга
                    for i = 1, 100 do
                        if not LaggerEnabled then break end
                        local p = Instance.new("Part")
                        p.Transparency = 1
                        p.Anchored = true
                        p.CanCollide = false
                        p.Position = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(math.random(-10,10), 0, math.random(-10,10))
                        p.Parent = workspace
                        game:GetService("Debris"):AddItem(p, 0.01)
                    end
                    -- Попытка спама событиями (зависит от защиты игры)
                    pcall(function()
                        local args = { [1] = "LaggerActive", [2] = math.huge }
                        ReplicatedStorage:FindFirstChild("Events"):FindFirstChild("Update"):FireServer(unpack(args))
                    end)
                    task.wait(0.001)
                end
            end)
        end
    end
})

Tabs.Lagger:Slider({
    Title = "Интенсивность лагов",
    Min = 1,
    Max = 1000,
    Default = 10,
    Callback = function(v)
        -- Логика изменения мощности
    end
})

-- === ФУНКЦИИ ВХ (ESP) ===
Tabs.Visuals:Section({Title = "Настройки Визуалов"})

local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "GnomESP"
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = player.Character
    
    local billboard = Instance.new("BillboardGui", player.Character:WaitForChild("Head"))
    billboard.Name = "GnomName"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    
    local label = Instance.new("TextLabel", billboard)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = player.Name
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
end

Tabs.Visuals:Toggle({
    Title = "Включить Подсветку (Chams)",
    Default = false,
    Callback = function(state)
        ESPEnabled = state
        if state then
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character then CreateESP(p) end
            end
        else
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("GnomESP") then
                    p.Character.GnomESP:Destroy()
                    if p.Character.Head:FindFirstChild("GnomName") then
                        p.Character.Head.GnomName:Destroy()
                    end
                end
            end
        end
    end
})

Tabs.Visuals:Toggle({
    Title = "Боксы (Box ESP)",
    Default = false,
    Callback = function(v) BoxESP = v end
})

Tabs.Visuals:Toggle({
    Title = "Линии (Tracers)",
    Default = false,
    Callback = function(v) Tracers = v end
})

-- === ОСНОВНЫЕ ФУНКЦИИ (MAIN) ===
Tabs.Main:Section({Title = "Автоматизация"})

Tabs.Main:Button({
    Title = "Собрать все мозги (Collect All)",
    Callback = function()
        for _, v in pairs(workspace:GetChildren()) do
            if v:FindFirstChild("TouchInterest") and (v.Name:find("Brain") or v.Name:find("Rot")) then
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 0)
                task.wait(0.1)
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 1)
            end
        end
    end
})

Tabs.Main:Toggle({
    Title = "Анти-Ловушка (Anti-Trap)",
    Default = true,
    Callback = function(state)
        _G.AntiTrap = state
        task.spawn(function()
            while _G.AntiTrap do
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("TouchTransmitter") and v.Parent.Name == "Trap" then
                        v:Destroy()
                    end
                end
                task.wait(2)
            end
        end)
    end
})

-- === РАЗНОЕ (MISC) ===
Tabs.Misc:Section({Title = "Настройки Игрока"})

Tabs.Misc:Slider({
    Title = "Скорость (WalkSpeed)",
    Min = 16,
    Max = 300,
    Default = 16,
    Callback = function(v)
        LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
})

Tabs.Misc:Slider({
    Title = "Прыжок (JumpPower)",
    Min = 50,
    Max = 500,
    Default = 50,
    Callback = function(v)
        LocalPlayer.Character.Humanoid.JumpPower = v
    end
})

Tabs.Misc:Button({
    Title = "Удалить текстуры (FPS Boost)",
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
            end
        end
    end
})

-- Уведомление о запуске
WindUI:Notify({
    Title = "GnomHub Загружен!",
    Content = "Добро пожаловать, " .. LocalPlayer.Name,
    Duration = 5
})

-- Кнопка открытия
Window:EditOpenButton({
    Title = "GnomHub",
    Icon = "skull",
    Draggable = true
})
