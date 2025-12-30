-- [[ PROJECT: SHTORM | PERFECT NOCLIP EDITION | BY @heloker_bot ]] --
-- [[ METHOD: CFRAME INTERPOLATION & RAYCAST BYPASS ]] --

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Theme = {
    SchemeColor = Color3.fromRGB(255, 255, 255), 
    Background = Color3.fromRGB(0, 0, 0),
    Header = Color3.fromRGB(0, 0, 0),
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(10, 10, 10)
}

local Window = Library.CreateLib("SHTORM | PERFECT NOCLIP", Theme)
local Main = Window:NewTab("Master")
local Section = Main:NewSection("Система Прорыва V7")

Section:NewToggle("Идеальный Ноклип", "Полная десинхронизация с миром", function(state)
    _G.PerfectNoclip = state
    local lp = game.Players.LocalPlayer
    local rs = game:GetService("RunService")
    
    rs.Stepped:Connect(function()
        if _G.PerfectNoclip and lp.Character then
            local char = lp.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            
            if hrp and hum then
                -- 1. Полное отключение коллизии модели
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
                
                -- 2. Обход гравитационного торможения
                hum:ChangeState(11) -- Состояние "Полет" (без трения)
                
                -- 3. Квантовое смещение (Движение без участия физики)
                if hum.MoveDirection.Magnitude > 0 then
                    -- Мы вычисляем позицию заранее и переносим тело
                    local speed = _G.NoclipSpeed or 1
                    hrp.CFrame = hrp.CFrame + (hum.MoveDirection * speed)
                end
                
                -- 4. Зануление сил (Защита от Rubberband)
                hrp.Velocity = Vector3.new(0, 0, 0)
                hrp.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end)
end)

Section:NewSlider("Скорость Прохода", "Регулируй под античит игры", 3, 0.1, function(v)
    _G.NoclipSpeed = v
end)

Section:NewButton("Удалить Преграды (Map Wipe)", "Удаляет все коллизии вокруг навсегда", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide and v.Name ~= "BasePlate" and v.Name ~= "Terrain" then
            v.CanCollide = false
            -- Делаем стены прозрачными, чтобы видеть куда идти
            if v.Transparency < 0.5 then v.Transparency = 0.5 end
        end
    end
end)

Section:NewKeybind("Скрыть меню", "R-CTRL", Enum.KeyCode.RightControl, function()
    Library:ToggleGui()
end)
