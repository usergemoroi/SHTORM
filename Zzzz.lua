-- [[ СИСТЕМНОЕ ЯДРО LEVIATHAN ]] --
local GnomHub = {
    Config = {
        WalkSpeed = 16,
        JumpPower = 50,
        LagActive = false,
        LagIntensity = 5000,
        FarmActive = false,
        EspActive = false,
        AutoSell = false
    },
    Data = {
        Net = nil,
        Remotes = {}
    }
}

-- Кэширование сервисов
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Инициализация сети
pcall(function()
    GnomHub.Data.Net = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"))
    GnomHub.Data.Remotes.Sell = GnomHub.Data.Net:RemoteEvent("PlotService/Sell")
    GnomHub.Data.Remotes.Cast = GnomHub.Data.Net:RemoteEvent("FishingRod.Cast")
    GnomHub.Data.Remotes.Click = GnomHub.Data.Net:RemoteEvent("FishingRod.MinigameClick")
end)

-- [ ИНТЕРФЕЙС WINDUI ] --
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "GNOMHUB LEVIATHAN-X",
    Icon = "rbxassetid://114691672281339",
    Author = "GnomHub Core",
    Folder = "LeviathanConfig"
})

local Tabs = {
    Farm = Window:Tab({ Title = "Ферма", Icon = "zap" }),
    Stats = Window:Tab({ Title = "Игрок", Icon = "user" }),
    Server = Window:Tab({ Title = "Деструкция", Icon = "skull" }),
    Visuals = Window:Tab({ Title = "ВХ", Icon = "eye" })
}

-- [[ МОДУЛЬ: ИСПРАВЛЕННЫЕ ПОЛЗУНКИ ]] --
Tabs.Stats:Slider({
    Title = "Скорость движения",
    Min = 16, Max = 500, Default = 16,
    Callback = function(value)
        GnomHub.Config.WalkSpeed = value
    end
})

Tabs.Stats:Slider({
    Title = "Сила прыжка",
    Min = 50, Max = 1000, Default = 50,
    Callback = function(value)
        GnomHub.Config.JumpPower = value
    end
})

-- Применение характеристик без багов
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = GnomHub.Config.WalkSpeed
        LocalPlayer.Character.Humanoid.JumpPower = GnomHub.Config.JumpPower
    end
end)

-- [[ МОДУЛЬ: СЕРВЕРНЫЙ ЛАГГЕР 2.0 (БЕЗ ТЕПОРТОВ) ]] --
-- Мы используем распределенный спам, чтобы сервер не считал это твоим вылетом
Tabs.Server:Toggle({
    Title = "NETWORK FLOOD (LAGGER)",
    Desc = "Лагает сервер, а не ты",
    Callback = function(state)
        GnomHub.Config.LagActive = state
        if state then
            task.spawn(function()
                while GnomHub.Config.LagActive do
                    for i = 1, GnomHub.Config.LagIntensity do
                        if not GnomHub.Config.LagActive then break end
                        -- Посылаем пустые пакеты продажи
                        GnomHub.Data.Remotes.Sell:FireServer()
                    end
                    -- Важный момент: ждем 1 физический такт, чтобы клиент не вис
                    RunService.Stepped:Wait()
                end
            end)
        end
    end
})

Tabs.Server:Slider({
    Title = "Мощность потока",
    Min = 100, Max = 50000, Default = 5000,
    Callback = function(value)
        GnomHub.Config.LagIntensity = value
    end
})

-- [[ МОДУЛЬ: РАБОЧИЙ АВТО-ФАРМ ]] --
Tabs.Farm:Toggle({
    Title = "Extreme Auto-Farm",
    Callback = function(state)
        GnomHub.Config.FarmActive = state
        if state then
            task.spawn(function()
                while GnomHub.Config.FarmActive do
                    pcall(function()
                        local char = LocalPlayer.Character
                        local root = char.HumanoidRootPart
                        -- Заброс в рандомную валидную точку
                        local castPos = root.Position + (root.CFrame.LookVector * 25) + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
                        GnomHub.Data.Remotes.Cast:FireServer(castPos)
                        
                        task.wait(0.5)
                        for i = 1, 30 do
                            if not GnomHub.Config.FarmActive then break end
                            GnomHub.Data.Remotes.Click:FireServer()
                            task.wait(0.05)
                        end
                        GnomHub.Data.Remotes.Sell:FireServer()
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

-- [[ МОДУЛЬ: ESP (ВХ) ]] --
local function createESP(p)
    if p.Character then
        local high = Instance.new("Highlight")
        high.Name = "GnomESP"
        high.FillColor = Color3.fromRGB(255, 0, 0)
        high.OutlineColor = Color3.fromRGB(255, 255, 255)
        high.Parent = p.Character
    end
end

Tabs.Visuals:Toggle({
    Title = "Player ESP",
    Callback = function(state)
        GnomHub.Config.EspActive = state
        if state then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then createESP(p) end
            end
        else
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("GnomESP") then
                    p.Character.GnomESP:Destroy()
                end
            end
        end
    end)
})

-- Фиксация ESP при заходе новых игроков
Players.PlayerAdded:Connect(function(p)
    if GnomHub.Config.EspActive then
        p.CharacterAdded:Wait()
        createESP(p)
    end
end)

Window:SelectTab(1)
