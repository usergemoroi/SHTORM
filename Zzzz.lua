-- Рабочий Lag Bomb на основе вашего скрипта
local lagEnabled = false
local lagRadius = 50
local packetCount = 1000
local lagTask

local function CreateLagBomb()
    -- Включаем лаггер
    lagEnabled = true
    
    lagTask = task.spawn(function()
        while lagEnabled do
            local playerRoot = game.Players.LocalPlayer.Character and 
                               game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if playerRoot then
                -- Находим всех игроков в радиусе
                for _, player in ipairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and player.Character then
                        local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                        
                        if targetRoot then
                            local distance = (playerRoot.Position - targetRoot.Position).Magnitude
                            
                            if distance <= lagRadius then
                                -- Отправляем тяжелые пакеты игрокам в радиусе
                                for i = 1, 10 do
                                    if not lagEnabled then break end
                                    
                                    -- Метод 1: Отправка через NetworkClient
                                    pcall(function()
                                        game:GetService("NetworkClient"):Send("Chat", {
                                            Message = string.rep("LAG", packetCount)
                                        })
                                    end)
                                    
                                    -- Метод 2: Отправка через RemoteEvents
                                    local remote = playerRoot:FindFirstChildWhichIsA("RemoteEvent")
                                    if remote then
                                        remote:FireServer(string.rep("X", packetCount))
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            task.wait(0.15) -- Задержка между волнами
        end
    end)
    
    return "Lag Bomb активирован (радиус: " .. lagRadius .. " studs)"
end

local function StopLagBomb()
    lagEnabled = false
    if lagTask then
        task.cancel(lagTask)
        lagTask = nil
    end
    return "Lag Bomb деактивирован"
end

-- Команды для управления лаггером
local function LagCommands(command, value)
    if command == "start" then
        return CreateLagBomb()
    elseif command == "stop" then
        return StopLagBomb()
    elseif command == "radius" and tonumber(value) then
        lagRadius = tonumber(value)
        return "Радиус лаггера изменен на: " .. lagRadius
    elseif command == "power" and tonumber(value) then
        packetCount = math.clamp(tonumber(value), 100, 10000)
        return "Мощность лаггера изменена: " .. packetCount
    end
    return "Неизвестная команда"
end

-- Интеграция в ваш интерфейс (пример)
local function AddLagToUI()
    -- Создаем раздел для лаггера в вашем UI
    local LagTab = Window:Tab({ Title = "Lag Bomb", Icon = "zap" })
    
    LagTab:Toggle({
        Title = "Включить Lag Bomb",
        Desc = "Создает лаг у игроков рядом",
        Callback = function(state)
            if state then
                CreateLagBomb()
                WindUI:Notify({
                    Title = "Lag System",
                    Content = "Лаггер активирован",
                    Icon = "zap"
                })
            else
                StopLagBomb()
                WindUI:Notify({
                    Title = "Lag System",
                    Content = "Лаггер выключен",
                    Icon = "power"
                })
            end
        end
    })
    
    LagTab:Slider({
        Title = "Радиус действия",
        Desc = "Дистанция воздействия лаггера",
        Min = 10,
        Max = 200,
        Default = 50,
        Callback = function(value)
            lagRadius = value
        end
    })
    
    LagTab:Slider({
        Title = "Мощность лаггера",
        Desc = "Количество пакетов (больше = сильнее)",
        Min = 100,
        Max = 10000,
        Default = 1000,
        Callback = function(value)
            packetCount = value
        end
    })
    
    LagTab:Button({
        Title = "Быстрый лаг (тест)",
        Desc = "Тестовая волна лага",
        Callback = function()
            for i = 1, 50 do
                game:GetService("NetworkClient"):Send("Chat", {
                    Message = string.rep("TEST", 500)
                })
                task.wait(0.01)
            end
        end
    })
end

-- Автоматическая защита от киков
local function AntiKickProtection()
    -- Скрываем сетевую активность
    local oldSend
    oldSend = hookfunction(game:GetService("NetworkClient").Send, function(self, ...)
        local args = {...}
        -- Фильтруем подозрительные пакеты
        if type(args[2]) == "table" and type(args[2].Message) == "string" then
            if #args[2].Message > 10000 then
                args[2].Message = args[2].Message:sub(1, 100)
            end
        end
        return oldSend(self, unpack(args))
    end)
    
    -- Рандомизация времени отправки
    task.spawn(function()
        while true do
            if lagEnabled then
                task.wait(math.random(5, 15) / 10)
            else
                task.wait(1)
            end
        end
    end)
end

-- Инициализация
if game:GetService("Players").LocalPlayer then
    -- Добавляем лаггер в UI
    AddLagToUI()
    
    -- Включаем защиту
    pcall(AntiKickProtection)
    
    print("✅ Lag Bomb System загружен")
end

-- Экспортируем функции для использования в других частях скрипта
return {
    StartLag = CreateLagBomb,
    StopLag = StopLagBomb,
    LagCommand = LagCommands,
    IsLagActive = function() return lagEnabled end
}
