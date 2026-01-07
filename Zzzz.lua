-- GnomHub: Steal a Brainrot Edition | Deep Space Optimized
-- Terminal: Delta / Zero-Point Environment

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Сетевые интерфейсы
local Net = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"))
local CastRemote = Net:RemoteEvent("FishingRod.Cast")
local ClickRemote = Net:RemoteEvent("FishingRod.MinigameClick")
local SellRemote = Net:RemoteEvent("PlotService/Sell")

local Window = WindUI:CreateWindow({
    Title = "GnomHub | Steal a Brainrot",
    Icon = "rbxassetid://114691672281339",
    Author = "GnomHub Team",
    Folder = "GnomHubConfig"
})

local Tabs = {
    Main = Window:Tab({ Title = "Главная", Icon = "home" }),
    Farm = Window:Tab({ Title = "Авто-Фарм", Icon = "zap" }),
    Visuals = Window:Tab({ Title = "ESP / ВХ", Icon = "eye" }),
    Misc = Window:Tab({ Title = "Разное / Лаггер", Icon = "settings" })
}

--- [ ОБНОВЛЕННЫЙ АВТО-ФАРМ ] ---
local farmActive = false
Tabs.Farm:Toggle({
    Title = "Авто-Рыбалка (Full Auto)",
    Callback = function(state)
        farmActive = state
        task.spawn(function()
            while farmActive do
                CastRemote:FireServer(Vector3.new(0,0,0))
                task.wait(0.3)
                for i = 1, 15 do
                    if not farmActive then break end
                    ClickRemote:FireServer()
                    task.wait(0.05)
                end
            end
        end)
    end
})

--- [ ИСПРАВЛЕННЫЙ NO CLIP ] ---
local noclipActive = false
RunService.Stepped:Connect(function()
    if noclipActive and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

Tabs.Misc:Toggle({
    Title = "Удалить границы (No Clip)",
    Callback = function(state)
        noclipActive = state
    end
})

--- [ УЛУЧШЕННЫЙ ЛАГГЕР (SERVER OVERLOAD) ] ---
-- Этот модуль спамит запросы на сервер, забивая очередь обработки для других игроков
local serverLagActive = false
Tabs.Misc:Toggle({
    Title = "Ultimate Server Lagger",
    Desc = "Создает критическую задержку для всех игроков в сессии",
    Callback = function(state)
        serverLagActive = state
        if state then
            task.spawn(function()
                while serverLagActive do
                    -- Генерация сетевого шума через удаленные события
                    for i = 1, 200 do
                        -- Отправка некорректных координат для перегрузки физического движка сервера
                        CastRemote:FireServer(Vector3.new(math.huge, math.huge, math.huge))
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

--- [ ESP / ВХ ] ---
local function createESP(player)
    if player ~= LocalPlayer and player.Character then
        local highlight = player.Character:FindFirstChild("GnomESP") or Instance.new("Highlight")
        highlight.Name = "GnomESP"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.Parent = player.Character
    end
end

Tabs.Visuals:Toggle({
    Title = "Включить Player ESP",
    Callback = function(state)
        if state then
            for _, p in pairs(Players:GetPlayers()) do createESP(p) end
        else
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("GnomESP") then
                    p.Character.GnomESP:Destroy()
                end
            end
        end
    end
})

Window:SelectTab(1)
