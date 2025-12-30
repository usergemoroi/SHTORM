-- [[ PROJECT: SHTORM | MASTER V10 | BY @heloker_bot ]] --
-- [[ МЕТОД: PHYSICAL VELOCITY ANCHOR (БЕЗ ЭФФЕКТА БОЛОТА) ]] --

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Theme = {
    SchemeColor = Color3.fromRGB(255, 255, 255), 
    Background = Color3.fromRGB(0, 0, 0),
    Header = Color3.fromRGB(0, 0, 0),
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(15, 15, 15)
}

local Window = Library.CreateLib("SHTORM | MASTER V10", Theme)
local Main = Window:NewTab("Master")
local Section = Main:NewSection("Система Master-Phase")

Section:NewToggle("Активировать Master-Noclip", "Идеальный проход без вязкости", function(state)
    _G.MasterActive = state
    local lp = game.Players.LocalPlayer
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    
    -- Создаем силовое поле для удержания высоты
    local bV = Instance.new("BodyVelocity")
    bV.Velocity = Vector3.new(0, 0, 0)
    bV.MaxForce = Vector3.new(0, 0, 0)
    bV.Parent = hrp

    game:GetService("RunService").RenderStepped:Connect(function()
        if _G.MasterActive and char and hrp then
            -- 1. УДЕРЖАНИЕ ВЫСОТЫ (Анти-Болото)
            bV.MaxForce = Vector3.new(0, 9e9, 0) -- Фиксируем Y
            
            -- 2. ПРОХОД СКВОЗЬ СТЕНЫ
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end

            -- 3. УПРАВЛЯЕМОЕ ДВИЖЕНИЕ
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum.MoveDirection.Magnitude > 0 then
                local speed = _G.MasterSpeed or 0.5
                hrp.CFrame = hrp.CFrame + (hum.MoveDirection * speed)
            end
            
            -- Обнуление горизонтальных сил (Анти-откат)
            hrp.Velocity = Vector3.new(0, 0, 0)
            hum:ChangeState(11)
        else
            bV.MaxForce = Vector3.new(0, 0, 0) -- Выключаем при деактивации
        end
    end)
end)

Section:NewSlider("Скорость (Плавность)", "Ставь 0.3-0.7 для стабильности", 10, 1, function(v)
    _G.MasterSpeed = v / 10
end)

Section:NewButton("Fix Floor (Стабилизатор)", "Если начал падать - жми один раз", function()
    local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
    hrp.Velocity = Vector3.new(0, 0, 0)
    hrp.CFrame = hrp.CFrame * CFrame.new(0, 2, 0) -- Принудительно поднять
end)

Section:NewButton("Удалить Коллизии Карт", "Локальный снос", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "BasePlate" then
            v.CanCollide = false
            v.Transparency = 0.5
        end
    end
end)

Section:NewKeybind("Меню", "R-CTRL", Enum.KeyCode.RightControl, function()
    Library:ToggleGui()
end)
