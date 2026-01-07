-- Минималистичный интерфейс для Delta
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("SHTORM HUB", "DarkScene")

-- Настройки
local Tab = Window:NewTab("Main Functions")
local Section = Tab:NewSection("WallHack & Combat")

local EspEnabled = false
local AimEnabled = false
local SpeedVal = 16

-- Функция создания ВХ (Чамсы)
local function ApplyChams(player)
    if player.Character and not player.Character:FindFirstChild("ShtormHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ShtormHighlight"
        highlight.Parent = player.Character
        highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Красный цвет
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Белая обводка
        highlight.FillTransparency = 0.5
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- ВИДНО СКВОЗЬ СТЕНЫ
    end
end

-- Переключатель ВХ
Section:NewToggle("WallHack (Chams)", "Подсветка врагов сквозь стены", function(state)
    EspEnabled = state
    if state then
        task.spawn(function()
            while EspEnabled do
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer then
                        ApplyChams(player)
                    end
                end
                task.wait(2) -- Обновление раз в 2 секунды для стабильности
            end
        end)
    else
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("ShtormHighlight") then
                player.Character.ShtormHighlight:Destroy()
            end
        end
    end
end)

-- Переключатель Аимбота
Section:NewToggle("Aimbot (Hard Lock)", "Жесткое наведение на голову", function(state)
    AimEnabled = state
end)

-- Скорость бега
Section:NewSlider("WalkSpeed", "Быстрый бег", 100, 16, function(s)
    SpeedVal = s
end)

-- ЛОГИКА АИМБОТА И СКОРОСТИ (Работает в фоне)
game:GetService("RunService").RenderStepped:Connect(function()
    -- Аимбот
    if AimEnabled then
        local shortestDistance = 500
        local closestTarget = nil
        
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
                if onScreen then
                    local mag = (Vector2.new(pos.X, pos.Y) - game:GetService("GuiService"):GetScreenResolution()/2).Magnitude
                    if mag < shortestDistance then
                        shortestDistance = mag
                        closestTarget = v.Character.Head
                    end
                end
            end
        end
        
        if closestTarget then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closestTarget.Position)
        end
    end
    
    -- Скорость
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = SpeedVal
    end
end)
