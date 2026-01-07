--[[ 
    GNOMHUB TITAN OVERRIDE 
    CORE: ZERO-POINT ISOLATION 
    STATUS: BYPASS ACTIVE 
]]

-- [ ИНИЦИАЛИЗАЦИЯ ЯДРА ] --
local GnomFramework = {
    Enabled = true,
    Debug = false,
    Version = "Titan-X",
    Config = {
        WalkSpeed = 16, JumpPower = 50, Noclip = false, 
        ServerLag = false, LagIntensity = 10000,
        AutoFarm = false, ESP = false, AntiKick = true,
        AutoSell = false, Fly = false
    }
}

-- Глобальные сервисы
local Services = setmetatable({}, {__index = function(t, k) return game:GetService(k) end})
local RunService, Players, ReplicatedStorage = Services.RunService, Services.Players, Services.ReplicatedStorage
local LocalPlayer = Players.LocalPlayer

-- [ ОБХОД ЗАЩИТЫ (ANTI-KICK & METATABLE HOOKS) ] --
local function InitiateBypass()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    local oldIndex = mt.__index
    setreadonly(mt, false)

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then return nil end
        if method == "ReportAbuse" then return nil end
        return oldNamecall(self, ...)
    end)
    
    setreadonly(mt, true)
end
InitiateBypass()

-- [ ЗАГРУЗКА ИНТЕРФЕЙСА ] --
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "GNOMHUB | ZERO-POINT OVERRIDE",
    Icon = "rbxassetid://114691672281339",
    Author = "GnomHub Deep Space",
    Folder = "GnomHub_Override_Config"
})

local Tabs = {
    Main = Window:Tab({ Title = "Авто-Фарм", Icon = "zap" }),
    Move = Window:Tab({ Title = "Движение", Icon = "move" }),
    Server = Window:Tab({ Title = "Взлом Сервера", Icon = "skull" }),
    Visuals = Window:Tab({ Title = "Визуалы / ESP", Icon = "eye" }),
    Configs = Window:Tab({ Title = "Настройки", Icon = "settings" })
}

-- [ МОДУЛЬ: NOCLIP & PHYSICAL BYPASS ] --
local function HandlePhysics()
    RunService.Stepped:Connect(function()
        if GnomFramework.Config.Noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false -- Принудительное отключение в каждом кадре
                end
            end
        end
        
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = GnomFramework.Config.WalkSpeed
            hum.JumpPower = GnomFramework.Config.JumpPower
        end
    end)
end
task.spawn(HandlePhysics)

-- [ МОДУЛЬ: СЕРВЕРНЫЙ ЛАГГЕР (NETWORK OVERFLOW) ] --
local function StartLag()
    task.spawn(function()
        local Net = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"))
        local Remote = Net:RemoteEvent("PlotService/Sell")
        
        while true do
            if GnomFramework.Config.ServerLag then
                -- Отправка критического объема пакетов без создания объектов
                for i = 1, GnomFramework.Config.LagIntensity do
                    if not GnomFramework.Config.ServerLag then break end
                    Remote:FireServer()
                end
            end
            task.wait(0.01)
        end
    end)
end
StartLag()

-- [ МОДУЛЬ: ПРАВИЛЬНЫЙ АВТО-ФАРМ (БЕЗ БАГОВ) ] --
local function StartFarm()
    task.spawn(function()
        local Net = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"))
        local Cast = Net:RemoteEvent("FishingRod.Cast")
        local Click = Net:RemoteEvent("FishingRod.MinigameClick")
        
        while true do
            if GnomFramework.Config.AutoFarm then
                pcall(function()
                    local root = LocalPlayer.Character.HumanoidRootPart
                    local castPos = root.Position + (root.CFrame.LookVector * 30)
                    
                    Cast:FireServer(castPos)
                    task.wait(0.8)
                    
                    for i = 1, 40 do
                        if not GnomFramework.Config.AutoFarm then break end
                        Click:FireServer()
                        task.wait(0.02)
                    end
                end)
            end
            task.wait(1.5)
        end
    end)
end
StartFarm()

-- [ МОДУЛЬ: PLAYER ESP (ВХ) ] --
local function UpdateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local highlight = p.Character:FindFirstChild("GnomHighlight")
            if GnomFramework.Config.ESP then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "GnomHighlight"
                    highlight.Parent = p.Character
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end

-- [ НАПОЛНЕНИЕ ТАБОВ ] --

-- ФАРМ
Tabs.Main:Toggle({ Title = "Включить Авто-Рыбалку", Callback = function(s) GnomFramework.Config.AutoFarm = s end })
Tabs.Main:Button({ Title = "Продать всё", Callback = function() 
    local Net = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"))
    Net:RemoteEvent("PlotService/Sell"):FireServer()
end})

-- ДВИЖЕНИЕ
Tabs.Move:Toggle({ Title = "Molecular Noclip (Проход сквозь стены)", Callback = function(s) GnomFramework.Config.Noclip = s end })
Tabs.Move:Slider({ Title = "Скорость", Min = 16, Max = 500, Default = 16, Callback = function(v) GnomFramework.Config.WalkSpeed = v end })
Tabs.Move:Slider({ Title = "Прыжок", Min = 50, Max = 1000, Default = 50, Callback = function(v) GnomFramework.Config.JumpPower = v end })

-- СЕРВЕР
Tabs.Server:Toggle({ Title = "АКТИВИРОВАТЬ ЛАГГЕР", Callback = function(s) GnomFramework.Config.ServerLag = s end })
Tabs.Server:Slider({ Title = "Мощность лага", Min = 1000, Max = 100000, Default = 10000, Callback = function(v) GnomFramework.Config.LagIntensity = v end })

-- ВИЗУАЛЫ
Tabs.Visuals:Toggle({ Title = "Player ESP (ВХ)", Callback = function(s) 
    GnomFramework.Config.ESP = s 
    RunService.Heartbeat:Connect(UpdateESP)
end })

Window:SelectTab(1)
