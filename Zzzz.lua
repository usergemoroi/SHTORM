-- [[ GNOMHUB: SOVEREIGN SYSTEM ]] --
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local RbxAnalytics = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Уникальный ID устройства
local HWID = RbxAnalytics:GetClientId()

-- [[ СИСТЕМА КЛЮЧЕЙ: АДМИН-ФОРМАТ ]] --
-- Ключи хранятся локально для теста, или подгружаются извне
-- Формат: ["ключ"] = {days = число, hwid = "id/пусто"}
local KeysData = {
    ["admin_test"] = {days = 999, hwid = ""}, -- Пусто = привяжется к первому зашедшему
    ["superkey_6day"] = {days = 6, hwid = ""},
    ["Gnom_1day"] = {days = 1, hwid = "some-id"}
}

-- [[ ИНИЦИАЛИЗАЦИЯ ИНТЕРФЕЙСА ]] --
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "GNOMHUB SOVEREIGN",
    Icon = "rbxassetid://114691672281339",
    Author = "Zero-Point Core",
    Folder = "GnomSovereign"
})

local Tabs = {
    Auth = Window:Tab({ Title = "Ключ", Icon = "lock" }),
    Main = Window:Tab({ Title = "Добыча", Icon = "zap" }),
    Server = Window:Tab({ Title = "Шторм", Icon = "skull" }),
    Visuals = Window:Tab({ Title = "ВХ", Icon = "eye" })
}

-- [[ МОДУЛЬ АВТОРИЗАЦИИ ]] --
local IsAuthorized = false
Tabs.Auth:Input({
    Title = "Ввод лицензии",
    Placeholder = "названиеключа 6day 1device",
    Callback = function(text)
        _G.CurrentKey = text
    end
})

Tabs.Auth:Button({
    Title = "Активировать протокол",
    Callback = function()
        local key = _G.CurrentKey
        if KeysData[key] then
            local data = KeysData[key]
            if data.hwid == "" or data.hwid == HWID then
                data.hwid = HWID -- Привязка
                IsAuthorized = true
                WindUI:Notify({Title = "Доступ разрешен", Desc = "Ключ на "..data.days.." дн. активен", Type = "success"})
            else
                WindUI:Notify({Title = "Ошибка", Desc = "Ключ привязан к другому HWID", Type = "error"})
            end
        else
            WindUI:Notify({Title = "Ошибка", Desc = "Ключ не найден в базе", Type = "error"})
        end
    end
})

-- [[ МОДУЛЬ: ТИТАН-ЛАГГЕР (БЕЗ ТЕЛЕПОРТАЦИИ) ]] --
local LagActive = false
local LagPower = 5000

local function StartTitanLag()
    local Net = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net"))
    task.spawn(function()
        while LagActive do
            if not IsAuthorized then break end
            
            -- Поток пакетов
            for i = 1, LagPower do
                if not LagActive then break end
                
                -- Рассылка по разным каналам для перегрузки CPU сервера
                Net:RemoteEvent("PlotService/Sell"):FireServer()
                
                -- Каждые 300 пакетов - принудительная синхронизация ТВОЕЙ позиции
                if i % 300 == 0 then
                    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        -- Отправляем микро-пакет движения, чтобы сервер не тепал на спавн
                        root.CFrame = root.CFrame * CFrame.new(0,0,0) 
                    end
                    RunService.Heartbeat:Wait() 
                end
            end
            task.wait(0.01)
        end
    end)
end

-- [[ МОДУЛЬ: АВТО-ФАРМ PRO ]] --
local FarmActive = false
local function StartFarm()
    local Net = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net"))
    task.spawn(function()
        while FarmActive do
            if not IsAuthorized then break end
            pcall(function()
                local char = LocalPlayer.Character
                local root = char.HumanoidRootPart
                local castPos = root.Position + (root.CFrame.LookVector * math.random(20, 35))
                
                Net:RemoteEvent("FishingRod.Cast"):FireServer(castPos)
                task.wait(0.7)
                for i = 1, 40 do
                    if not FarmActive then break end
                    Net:RemoteEvent("FishingRod.MinigameClick"):FireServer()
                    task.wait(0.02)
                end
            end)
            task.wait(1)
        end
    end)
end

-- [[ ИНТЕРФЕЙС УПРАВЛЕНИЯ ]] --

Tabs.Server:Toggle({
    Title = "АКТИВИРОВАТЬ ШТОРМ",
    Callback = function(s) LagActive = s; if s then StartTitanLag() end end
})

Tabs.Server:Slider({
    Title = "Мощность (Пакеты)",
    Min = 500, Max = 200000, Default = 5000,
    Callback = function(v) LagPower = v end
})

Tabs.Main:Toggle({
    Title = "Auto-Farm Supreme",
    Callback = function(s) FarmActive = s; if s then StartFarm() end end
})

Tabs.Visuals:Toggle({
    Title = "Full ESP Box",
    Callback = function(s)
        _G.ESP = s
        while _G.ESP do
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local h = p.Character:FindFirstChild("GnomHighlight") or Instance.new("Highlight", p.Character)
                    h.Name = "GnomHighlight"
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                end
            end
            task.wait(1)
        end
    end
})

-- Ползунки скорости (работают всегда при наличии ключа)
Tabs.Main:Slider({
    Title = "Speed", Min = 16, Max = 400, Default = 16,
    Callback = function(v) if IsAuthorized then LocalPlayer.Character.Humanoid.WalkSpeed = v end end
})

Window:SelectTab(1)
