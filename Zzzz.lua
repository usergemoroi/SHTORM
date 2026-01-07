-- [[ СИСТЕМНОЕ ЯДРО: ИНИЦИАЛИЗАЦИЯ ]] --
local GnomHub = {
    Active = true,
    Debug = false,
    Version = "2.0.0-Titan",
    Config = {
        Noclip = false,
        Lagger = false,
        LagPower = 50000,
        Speed = 16,
        Jump = 50,
        Fly = false,
        AutoFarm = false,
        CastDistance = 20
    }
}

-- Кэширование сервисов для производительности
local Services = setmetatable({}, {
    __index = function(t, k)
        return game:GetService(k)
    end
})

local RunService = Services.RunService
local Players = Services.Players
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = Services.ReplicatedStorage
local StarterGui = Services.StarterGui

-- [[ МОДУЛЬ ПРЕДОТВРАЩЕНИЯ БАГОВ (ERROR HANDLING) ]] --
local function SafeExecute(name, func)
    local success, err = pcall(func)
    if not success and GnomHub.Debug then
        warn("[GnomHub Error in " .. name .. "]: " .. tostring(err))
    end
end

-- [[ МОДУЛЬ ОБХОДА ПРОВЕРОК (HOOKING) ]] --
local function InitiateBypass()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        -- Блокировка репортов анти-чита и киков
        if method == "Kick" or method == "kick" or method == "ReportAbuse" then
            return nil
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end
SafeExecute("Bypass", InitiateBypass)

-- [[ ИНТЕРФЕЙС (WINDUI CORE) ]] --
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "GNOMHUB TITAN | DEEP SPACE OVERRIDE",
    Icon = "rbxassetid://114691672281339",
    Author = "GnomHub Team",
    Folder = "GnomHubTitanConfig"
})

local Tabs = {
    Main = Window:Tab({ Title = "Фарм / Main", Icon = "zap" }),
    Movement = Window:Tab({ Title = "Физика / Move", Icon = "move" }),
    Server = Window:Tab({ Title = "Деструкция / Lag", Icon = "skull" }),
    Visuals = Window:Tab({ Title = "Сенсоры / ESP", Icon = "eye" }),
    Settings = Window:Tab({ Title = "Конфиг", Icon = "settings" })
}

-- [[ МОДУЛЬ: БЕЗОШИБОЧНЫЙ NOCLIP ]] --
-- Использует принудительную деактивацию коллизий в каждом кадре
RunService.Stepped:Connect(function()
    if GnomHub.Config.Noclip and LocalPlayer.Character then
        for _, obj in pairs(LocalPlayer.Character:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.CanCollide = false
            end
        end
    end
    
    -- Синхронизация характеристик персонажа
    local Hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if Hum then
        Hum.WalkSpeed = GnomHub.Config.Speed
        Hum.JumpPower = GnomHub.Config.Jump
    end
end)

-- [[ МОДУЛЬ: ГИПЕР-ЛАГГЕР (SERVER STALL) ]] --
-- Реализован через многопоточный спам пакетами
local function StartServerLag()
    task.spawn(function()
        local Net = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"))
        local Sell = Net:RemoteEvent("PlotService/Sell")
        
        while GnomHub.Config.Lagger do
            -- Пакетная отправка 50,000+ запросов
            for i = 1, GnomHub.Config.LagPower do
                if not GnomHub.Config.Lagger then break end
                Sell:FireServer()
                -- Каждые 1000 пакетов даем микро-паузу, чтобы не вылетел исполнитель
                if i % 1000 == 0 then RunService.Heartbeat:Wait() end
            end
            task.wait(0.1)
        end
    end)
end

-- [[ МОДУЛЬ: АВТО-ФАРМ (ВЕРСИЯ 2.0) ]] --
local function StartAutoFarm()
    task.spawn(function()
        local Net = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"))
        local Cast = Net:RemoteEvent("FishingRod.Cast")
        local Click = Net:RemoteEvent("FishingRod.MinigameClick")
        
        while GnomHub.Config.AutoFarm do
            SafeExecute("FarmLoop", function()
                local Root = LocalPlayer.Character.HumanoidRootPart
                local LookPos = Root.Position + (Root.CFrame.LookVector * GnomHub.Config.CastDistance)
                
                Cast:FireServer(LookPos)
                task.wait(0.7)
                
                -- Серия сверхбыстрых кликов
                for i = 1, 35 do
                    if not GnomHub.Config.AutoFarm then break end
                    Click:FireServer()
                    task.wait(0.01)
                end
            end)
            task.wait(1)
        end
    end)
end

-- [[ ЗАПОЛНЕНИЕ МЕНЮ ФУНКЦИЯМИ ]] --

-- Вкладка Движения
Tabs.Movement:Toggle({ Title = "Noclip Override", Callback = function(s) GnomHub.Config.Noclip = s end })
Tabs.Movement:Slider({ Title = "Speed Hack", Min = 16, Max = 500, Default = 16, Callback = function(v) GnomHub.Config.Speed = v end })
Tabs.Movement:Slider({ Title = "Jump Boost", Min = 50, Max = 1000, Default = 50, Callback = function(v) GnomHub.Config.Jump = v end })

-- Вкладка Сервера (Лаггер)
Tabs.Server:Toggle({ 
    Title = "ULTRA LAGGER", 
    Desc = "Замораживает сервер для всех игроков", 
    Callback = function(s) 
        GnomHub.Config.Lagger = s 
        if s then StartServerLag() end
    end 
})
Tabs.Server:Slider({ Title = "Lag Power", Min = 1000, Max = 200000, Default = 50000, Callback = function(v) GnomHub.Config.LagPower = v end })

-- Вкладка Фарма
Tabs.Main:Toggle({ 
    Title = "Auto-Fishing Pro", 
    Callback = function(s) 
        GnomHub.Config.AutoFarm = s 
        if s then StartAutoFarm() end
    end 
})
Tabs.Main:Button({ Title = "Instant Sell", Callback = function() 
    local Net = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"))
    Net:RemoteEvent("PlotService/Sell"):FireServer()
end })

-- Дополнительные настройки
Tabs.Settings:Button({ Title = "Unload Script", Callback = function() GnomHub.Active = false; Window:Destroy() end })
Tabs.Settings:Toggle({ Title = "Debug Mode", Callback = function(s) GnomHub.Debug = s end })

Window:SelectTab(1)
print("GNOMHUB TITAN: Operational. All systems green.")
