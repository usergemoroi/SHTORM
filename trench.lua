local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Brainrot Menu V2", "Midnight")
local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("Улучшенные функции")

-- 1. УСКОРЕНИЕ
Section:NewSlider("Скорость бега", "Настрой под себя (рекомендую 50-100)", 500, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

-- 2. ИСПРАВЛЕННЫЙ NOCLIP
Section:NewToggle("Проход сквозь стены (Исправлено)", "Если тепает, снизь скорость бега", function(state)
    _G.Noclip = state
    game:GetService("RunService").Stepped:Connect(function()
        if _G.Noclip and game.Players.LocalPlayer.Character then
            for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            -- Обнуляем вертикальную скорость, чтобы анти-чит меньше ругался
            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity.X, 0, game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity.Z)
        end
    end)
end)

-- 3. МОЩНЫЙ ЛАГГЕР (У ВСЕХ)
Section:NewToggle("Ультра Лаггер Сервера", "ОСТОРОЖНО: Будет лагать у всех!", function(state)
    _G.LagServer = state
    spawn(function()
        while _G.LagServer do
            -- Спам событиями, которые сервер обязан обработать
            for i = 1, 100 do
                game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer("", "All")
                task.wait()
            end
        end
    end)
end)

-- 4. ПОДСВЕТКА ВСЕГО БРАИНРОТА
Section:NewButton("Подсветить весь Браинрот", "Зеленым подсветит всё, что можно взять", function()
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        -- Ищем по ключевым словам или по наличию TouchInterest
        if obj:IsA("TouchInterest") then
            local target = obj.Parent
            if target:IsA("BasePart") and not target:FindFirstChild("BoxHighlight") then
                local high = Instance.new("BoxHandleAdornment", target)
                high.Name = "BoxHighlight"
                high.Size = target.Size + Vector3.new(0.1, 0.1, 0.1)
                high.AlwaysOnTop = true
                high.ZIndex = 5
                high.Adornee = target
                high.Color3 = Color3.fromRGB(0, 255, 0)
                high.Transparency = 0.5
            end
        end
    end
end)

-- 5. ПОДСВЕТКА ИГРОКОВ
Section:NewToggle("Подсветка игроков", "Красный силуэт", function(state)
    _G.PlayerESP = state
    if state then
        for _, p in pairs(game.Players:GetChildren()) do
            if p ~= game.Players.LocalPlayer and p.Character then
                local h = Instance.new("Highlight", p.Character)
                h.Name = "PlayerHigh"
                h.FillColor = Color3.fromRGB(255, 0, 0)
            end
        end
    else
        for _, p in pairs(game.Players:GetChildren()) do
            if p.Character and p.Character:FindFirstChild("PlayerHigh") then
                p.Character.PlayerHigh:Destroy()
            end
        end
    end
end)
