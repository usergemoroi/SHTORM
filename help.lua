-- [[ PROJECT: SHTORM | ZERO-G NOCLIP | BY @heloker_bot ]] --
-- [[ МЕТОД: ANCHORED WARP (АНТИ-ПАДЕНИЕ И АНТИ-ОТКАТ) ]] --

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Theme = {
    SchemeColor = Color3.fromRGB(255, 255, 255), 
    Background = Color3.fromRGB(0, 0, 0),
    Header = Color3.fromRGB(0, 0, 0),
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(15, 15, 15)
}

local Window = Library.CreateLib("SHTORM | ZERO-G NOCLIP", Theme)
local Main = Window:NewTab("Master")
local Section = Main:NewSection("Система ZERO-G (V8)")

Section:NewToggle("Активировать ZERO-G", "Не падает вниз, не тепает назад", function(state)
    _G.ZeroG = state
    local lp = game.Players.LocalPlayer
    local rs = game:GetService("RunService")
    
    rs.RenderStepped:Connect(function()
        if _G.ZeroG and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local char = lp.Character
            local hrp = char.HumanoidRootPart
            local hum = char.Humanoid
            
            -- 1. ОТКЛЮЧАЕМ ГРАВИТАЦИЮ И ФИЗИКУ (Заморозка)
            hrp.Anchored = true 
            
            -- 2. ПРОХОДИМ СКВОЗЬ СТЕНЫ
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end

            -- 3. РУЧНОЕ УПРАВЛЕНИЕ "ЯКОРЕМ"
            if hum.MoveDirection.Magnitude > 0 then
                local speed = _G.GhostSpeed or 0.6
                hrp.CFrame = hrp.CFrame + (hum.MoveDirection * speed)
            end
            
            -- Вертикальное управление (чтобы не падать и летать)
            local uis = game:GetService("UserInputService")
            if uis:IsKeyDown(Enum.KeyCode.Space) then
                hrp.CFrame = hrp.CFrame * CFrame.new(0, 0.5, 0)
            end
            if uis:IsKeyDown(Enum.KeyCode.LeftShift) then
                hrp.CFrame = hrp.CFrame * CFrame.new(0, -0.5, 0)
            end
        else
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                lp.Character.HumanoidRootPart.Anchored = false -- Возвращаем физику при выключении
            end
        end
    end)
end)

Section:NewSlider("Скорость Призрака", "Настройка пробития", 5, 0.1, function(v)
    _G.GhostSpeed = v
end)

Section:NewButton("Удалить Коллизию Карты", "Если всё равно тепает (Локально)", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "BasePlate" then
            v.CanCollide = false
            if v.Transparency < 0.5 then v.Transparency = 0.5 end
        end
    end
end)

Section:NewKeybind("Меню", "R-CTRL", Enum.KeyCode.RightControl, function()
    Library:ToggleGui()
end)
