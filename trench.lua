local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Brainrot Menu", "Midnight")
local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("Функции")

-- 1. УСКОРЕНИЕ (ВКЛ/ВЫКЛ)
Section:NewToggle("Ускорение бега", "Включает скорость 100", function(state)
    if state then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- 2. ПРОХОД СКВОЗЬ СТЕНЫ И ЛАЗЕРЫ (ВКЛ/ВЫКЛ)
Section:NewToggle("Проход сквозь стены (Noclip)", "Стены и лазеры не мешают", function(state)
    _G.Noclip = state
    game:GetService("RunService").Stepped:Connect(function()
        if _G.Noclip then
            if game.Players.LocalPlayer.Character then
                for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end)

-- 3. ПОДСВЕТКА ИГРОКОВ (ВКЛ/ВЫКЛ)
Section:NewToggle("Подсветка игроков (ESP)", "Видеть всех", function(state)
    _G.ESP = state
    if state then
        for _, p in pairs(game.Players:GetChildren()) do
            if p ~= game.Players.LocalPlayer and p.Character then
                local highlight = Instance.new("Highlight", p.Character)
                highlight.Name = "ESPHighlight"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
            end
        end
    else
        for _, p in pairs(game.Players:GetChildren()) do
            if p.Character and p.Character:FindFirstChild("ESPHighlight") then
                p.Character.ESPHighlight:Destroy()
            end
        end
    end
end)

-- 4. ПОДСВЕТКА ДОРОГОГО БРАИНРОТА
Section:NewButton("Подсветить дорогой браинрот", "Разово находит лучший предмет", function()
    -- Ищем предмет с TouchInterest (который можно подобрать)
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("TouchInterest") then
            local parent = obj.Parent
            local high = Instance.new("Highlight", parent)
            high.FillColor = Color3.fromRGB(0, 255, 0)
        end
    end
end)

-- 5. ЛАГГЕР (ВКЛ/ВЫКЛ)
Section:NewToggle("Лаггер сервера", "Может лагать сервер", function(state)
    _G.Lag = state
    while _G.Lag do
        task.wait()
        -- Спам запросом на смену состояния (безобидный, но создает пакеты)
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(11)
    end
end)
