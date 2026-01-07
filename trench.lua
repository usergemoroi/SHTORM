local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Ultimate Brainrot Power", "DarkTheme")

-- ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ ДЛЯ УПРАВЛЕНИЯ
_G.NoclipActive = false
_G.LaggerActive = false
_G.PlayerESPActive = false
_G.AutoFarmActive = false

-- ВКЛАДКА "МОЩНЫЕ ЭКСПЛОЙТЫ"
local ExploitsTab = Window:NewTab("Мощные Эксплойты")
local NoclipSection = ExploitsTab:NewSection("Noclip (Проход сквозь объекты)")

NoclipSection:NewToggle("Включить Noclip (Анти-Телепорт)", "Проход сквозь стены и лазеры. Могут быть лаги.", function(state)
    _G.NoclipActive = state
    if state then
        -- Используем Stepped для постоянного отключения коллизии
        _G.NoclipConnection = game:GetService("RunService").Stepped:Connect(function()
            if game.Players.LocalPlayer.Character and _G.NoclipActive then
                local HumanoidRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if HumanoidRootPart then
                    for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                    -- Попытка обмануть анти-чит, обнуляя скорость
                    HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end)
    else
        if _G.NoclipConnection then
            _G.NoclipConnection:Disconnect()
            -- При выключении Noclip возвращаем коллизию
            if game.Players.LocalPlayer.Character then
                for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
end)

local LaggerSection = ExploitsTab:NewSection("Серверный Лаггер (Аура)")

LaggerSection:NewToggle("Включить Лаггер-Ауру (Жесткий)", "Создаст адские лаги у всех вокруг, а возможно и на сервере.", function(state)
    _G.LaggerActive = state
    if state then
        _G.LaggerConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if _G.LaggerActive then
                local player = game.Players.LocalPlayer
                local char = player.Character
                if char then
                    local HRP = char:FindFirstChild("HumanoidRootPart")
                    if HRP then
                        -- Создаем фейковые частицы или события в большом количестве
                        local part = Instance.new("Part")
                        part.Size = Vector3.new(0.1, 0.1, 0.1)
                        part.Transparency = 1 -- Скрытая
                        part.CanCollide = false
                        part.Anchored = true
                        part.Position = HRP.Position + Vector3.new(math.random(-5, 5), math.random(-5, 5), math.random(-5, 5))
                        part.Parent = game.Workspace
                        game:GetService("Debris"):AddItem(part, 0.1) -- Удаляем быстро, но сервер должен обработать создание

                        -- Спам очень частыми RemoteEvent-ами (если найдем уязвимый)
                        -- Попробуем стандартный чат-спам
                        local chatService = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
                        if chatService then
                            local sayMessage = chatService:FindFirstChild("SayMessageRequest")
                            if sayMessage then
                                for i = 1, 10 do -- 10 сообщений за heartbeat
                                    sayMessage:FireServer(string.rep("!", 500), "All") -- Длинное сообщение для нагрузки
                                end
                            end
                        end
                    end
                end
            end
        end)
    else
        if _G.LaggerConnection then
            _G.LaggerConnection:Disconnect()
        end
    end
end)

-- ВКЛАДКА "МОЙ ПЕРСОНАЖ"
local CharacterTab = Window:NewTab("Мой Персонаж")
local AppearanceSection = CharacterTab:NewSection("Внешний вид")

AppearanceSection:NewButton("Сделать меня красивее (Светящийся)", "Сделает твоего персонажа светящимся и изменит цвет", function()
    local char = game.Players.LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                -- Изменяем цвет
                part.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
                -- Добавляем свечение (если есть Bloom в Lighting)
                part.Material = Enum.Material.Neon 
            end
        end
        -- Можно изменить цвет кожи
        local bodyColors = char:FindFirstChildOfClass("BodyColors")
        if bodyColors then
            bodyColors.HeadColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
            bodyColors.LeftArmColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
            bodyColors.RightArmColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
            bodyColors.LeftLegColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
            bodyColors.RightLegColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
            bodyColors.TorsoColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        end
    end
end)

AppearanceSection:NewButton("Вернуть стандартный вид", "Убирает свечение и случайный цвет", function()
    local char = game.Players.LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                -- Возвращаем материал по умолчанию
                part.Material = Enum.Material.Plastic 
                -- Цвет будет стандартным для твоего скина Roblox
            end
        end
        -- Возвращаем стандартные цвета тела (предполагая R15)
        local bodyColors = char:FindFirstChildOfClass("BodyColors")
        if bodyColors then
            bodyColors.HeadColor3 = Color3.fromRGB(255, 255, 255) -- Пример белого
            bodyColors.LeftArmColor3 = Color3.fromRGB(255, 255, 255)
            bodyColors.RightArmColor3 = Color3.fromRGB(255, 255, 255)
            bodyColors.LeftLegColor3 = Color3.fromRGB(255, 255, 255)
            bodyColors.RightLegColor3 = Color3.fromRGB(255, 255, 255)
            bodyColors.TorsoColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
end)

-- ВКЛАДКА "ОСНОВНЫЕ ФУНКЦИИ"
local MainTab = Window:NewTab("Основные Функции")
local MainSection = MainTab:NewSection("Игровые возможности")

MainSection:NewSlider("Скорость бега", "Настрой свою скорость (16 - по умолчанию)", 500, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

MainSection:NewToggle("Авто-фарм предметов", "Автоматически подбирает браинрот", function(state)
    _G.AutoFarmActive = state
    spawn(function()
        while _G.AutoFarmActive do
            task.wait(0.05) -- Чаще проверяем
            for _, obj in pairs(game.Workspace:GetDescendants()) do
                if obj:IsA("TouchInterest") and obj.Parent and obj.Parent:IsA("BasePart") then
                    local targetPart = obj.Parent
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, targetPart, 0)
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, targetPart, 1)
                end
            end
        end
    end)
end)

MainSection:NewToggle("Подсветка игроков (ESP)", "Показывает игроков через стены", function(state)
    _G.PlayerESPActive = state
    if state then
        _G.PlayerESPConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if _G.PlayerESPActive then
                for _, p in pairs(game.Players:GetChildren()) do
                    if p ~= game.Players.LocalPlayer and p.Character then
                        local h = p.Character:FindFirstChild("PlayerHigh")
                        if not h then
                            h = Instance.new("Highlight", p.Character)
                            h.Name = "PlayerHigh"
                            h.FillColor = Color3.fromRGB(255, 0, 0)
                            h.OutlineColor = Color3.fromRGB(0, 0, 0)
                            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        end
                    end
                end
            end
        end)
    else
        if _G.PlayerESPConnection then
            _G.PlayerESPConnection:Disconnect()
        end
        for _, p in pairs(game.Players:GetChildren()) do
            if p.Character then
                local h = p.Character:FindFirstChild("PlayerHigh")
                if h then h:Destroy() end
            end
        end
    end
end)

MainSection:NewButton("Подсветить весь Браинрот", "Разово подсветит все предметы, которые можно взять", function()
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("TouchInterest") and obj.Parent and obj.Parent:IsA("BasePart") then
            local target = obj.Parent
            if not target:FindFirstChild("BrainrotHighlight") then
                local high = Instance.new("BoxHandleAdornment", target)
                high.Name = "BrainrotHighlight"
                high.Size = target.Size + Vector3.new(0.2, 0.2, 0.2)
                high.AlwaysOnTop = true
                high.ZIndex = 5
                high.Adornee = target
                high.Color3 = Color3.fromRGB(0, 255, 0)
                high.Transparency = 0.5
            end
        end
    end
end)
