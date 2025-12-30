local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("SHTORM | MASTER V12 (Bypass)", {
    SchemeColor = Color3.fromRGB(255, 0, 0), 
    Background = Color3.fromRGB(15, 15, 15),
    Header = Color3.fromRGB(10, 10, 10),
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(25, 25, 25)
})

local Main = Window:NewTab("Bypass")
local Section = Main:NewSection("Anti-Cheat Bypass Noclip")

local RunService = game:GetService("RunService")
local LP = game.Players.LocalPlayer
local Connection

_G.NoclipState = false
_G.NoclipSpeed = 1.5

Section:NewToggle("Smart Noclip (No Death)", "Безопасный проход сквозь стены", function(state)
    _G.NoclipState = state
    
    if state then
        Connection = RunService.Stepped:Connect(function()
            if not _G.NoclipState then return end
            
            local char = LP.Character
            if char then
                -- 1. ОТКЛЮЧЕНИЕ КОЛЛИЗИИ (Более мягкое)
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
                
                -- 2. СИМУЛЯЦИЯ СКОРОСТИ (Обман сервера)
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChild("Humanoid")
                
                if hrp and hum then
                    if hum.MoveDirection.Magnitude > 0 then
                        -- Вместо телепортации задаем импульсную скорость
                        local vel = hum.MoveDirection * (_G.NoclipSpeed * 20)
                        hrp.Velocity = Vector3.new(vel.X, 0, vel.Z) -- Сообщаем серверу, что мы "идем"
                        
                        -- Небольшое смещение CFrame для плавности
                        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (_G.NoclipSpeed / 3))
                    else
                        hrp.Velocity = Vector3.new(0, 0, 0)
                    end
                    
                    -- Анти-гравитация (чтобы не убило при падении)
                    if hrp.Velocity.Y < -50 then
                        hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
                    end
                end
            end
        end)
    else
        if Connection then Connection:Disconnect() end
        -- Возвращаем коллизию
        local char = LP.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = true end
            end
        end
    end
end)

Section:NewSlider("Скорость", "Не ставь больше 2.5 во избежание кика", 50, 5, function(v)
    _G.NoclipSpeed = v / 10
end)

Section:NewButton("Убрать Kill-Zones (Experimental)", "Удаляет зоны смерти (скрипты)", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("TouchTransmitter") then
            v:Destroy() -- Удаляет сенсоры касания, которые могут убивать
        end
    end
end)
