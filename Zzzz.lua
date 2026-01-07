-- GnomHub: Steal a Brainrot Edition
-- Target Executor: Delta

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Ресурсы игры
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

--- [ АВТО-ФАРМ ] ---
local farmActive = false
Tabs.Farm:Toggle({
    Title = "Авто-Рыбалка (Full Auto)",
    Callback = function(state)
        farmActive = state
        task.spawn(function()
            while farmActive do
                CastRemote:FireServer(Vector3.new(0,0,0)) -- Заброс
                task.wait(0.5)
                for i = 1, 10 do
                    if not farmActive then break end
                    ClickRemote:FireServer() -- Клик в мини-игре
                    task.wait(0.1)
                end
                task.wait(1)
            end
        end)
    end
})

Tabs.Farm:Toggle({
    Title = "Авто-Продажа",
    Callback = function(state)
        _G.AutoSell = state
        task.spawn(function()
            while _G.AutoSell do
                SellRemote:FireServer()
                task.wait(5)
            end
        end)
    end
})

--- [ ESP / ВХ ] ---
local function createESP(player)
    if player ~= LocalPlayer then
        local highlight = Instance.new("Highlight")
        highlight.Name = "GnomESP"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.Parent = player.Character
    end
end

Tabs.Visuals:Toggle({
    Title = "Включить Player ESP",
    Callback = function(state)
        if state then
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character then createESP(p) end
            end
        else
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("GnomESP") then
                    p.Character.GnomESP:Destroy()
                end
            end
        end
    end
})

--- [ ЛАГГЕР / MISC ] ---
local lagActive = false
Tabs.Misc:Toggle({
    Title = "Ultimate Screen Lagger",
    Desc = "Полный застой экрана (только для мощных систем)",
    Callback = function(state)
        lagActive = state
        if state then
            task.spawn(function()
                while lagActive do
                    -- Создание тяжелых визуальных эффектов для перегрузки рендера
                    for i = 1, 500 do
                        local p = Instance.new("Part", workspace)
                        p.Size = Vector3.new(10,10,10)
                        p.Transparency = 1
                        p.CanCollide = false
                        task.delay(0.1, function() p:Destroy() end)
                    end
                    RunService.RenderStepped:Wait()
                end
            end)
        end
    end
})

Tabs.Misc:Button({
    Title = "Удалить границы (No Clip)",
    Callback = function()
        LocalPlayer.Character.Humanoid:ChangeState(11)
    end
})

Window:SelectTab(1)
