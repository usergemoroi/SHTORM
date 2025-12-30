-- [[ PROJECT: SHTORM | STEALTH-PHASE V9 | BY @heloker_bot ]] --
-- [[ МЕТОД: MOVING PLATFORM & SMOOTH LERP (АНТИ-ОТКАТ) ]] --

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Theme = {
    SchemeColor = Color3.fromRGB(255, 255, 255), 
    Background = Color3.fromRGB(0, 0, 0),
    Header = Color3.fromRGB(0, 0, 0),
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(10, 10, 10)
}

local Window = Library.CreateLib("SHTORM | STEALTH V9", Theme)
local Main = Window:NewTab("Master")
local Section = Main:NewSection("Система Stealth-Drive")

Section:NewToggle("Активировать Stealth-Noclip", "Плавный проход без падения и тепов", function(state)
    _G.StealthActive = state
    local lp = game.Players.LocalPlayer
    local rs = game:GetService("RunService")
    
    -- Создаем невидимую опору
    local platform = Instance.new("Part")
    platform.Size = Vector3.new(5, 1, 5)
    platform.Transparency = 1
    platform.Anchored = true
    platform.Parent = workspace

    rs.RenderStepped:Connect(function()
        if _G.StealthActive and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local char = lp.Character
            local hrp = char.HumanoidRootPart
            local hum = char.Humanoid
            
            -- 1. ДЕРЖИМСЯ НА ПЛАТФОРМЕ (Чтобы не тонуть)
            platform.CFrame = hrp.CFrame * CFrame.new(0, -3.5, 0)
            
            -- 2. ОТКЛЮЧАЕМ СТЕНЫ ВОКРУГ
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end

            -- 3. ПЛАВНОЕ ДВИЖЕНИЕ (Lerp)
            if hum.MoveDirection.Magnitude > 0 then
                local step = _G.StealthSpeed or 0.3 -- Очень маленькие шаги для обхода
                hrp.CFrame = hrp.CFrame:Lerp(hrp.CFrame + (hum.MoveDirection * step), 0.5)
            end
            
            -- Зануляем физику, чтобы не тепало по инерции
            hrp.Velocity = Vector3.new(0, 0, 0)
            hum:ChangeState(11)
        else
            platform.CFrame = CFrame.new(0, -1000, 0) -- Убираем платформу в ад
        end
    end)
end)

Section:NewSlider("Точность (Скорость)", "Ставь 0.2 - 0.5 для беспалевности", 20, 1, function(v)
    _G.StealthSpeed = v / 10 -- Делим на 10 для микро-настройки
end)

Section:NewButton("Удалить Коллизию Карты", "Если всё равно тепает (Финал)", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "BasePlate" then
            v.CanCollide = false
            v.Transparency = 0.6
        end
    end
end)

Section:NewKeybind("Меню", "R-CTRL", Enum.KeyCode.RightControl, function()
    Library:ToggleGui()
end)
