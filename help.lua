local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("SHTORM | V13 (ANTI-TELEPORT)", {
    SchemeColor = Color3.fromRGB(0, 255, 100), 
    Background = Color3.fromRGB(10, 10, 10),
    Header = Color3.fromRGB(5, 5, 5),
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(20, 20, 20)
})

local Main = Window:NewTab("Safe-Noclip")
local Section = Main:NewSection("Метод изменения физики")

local RunService = game:GetService("RunService")
local LP = game.Players.LocalPlayer
local NoclipLoop

_G.NoclipType = "Physics" -- Тип прохода

Section:NewToggle("Активировать Physics-Noclip", "Самый безопасный от телепортов", function(state)
    if state then
        NoclipLoop = RunService.Stepped:Connect(function()
            local char = LP.Character
            if char then
                -- 1. ОТКЛЮЧАЕМ СТОЛКНОВЕНИЯ
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                
                -- 2. ОБМАН СЕРВЕРА (HipHeight)
                -- Мы немного приподнимаем гуманоида над землей программно
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:ChangeState(11) -- Отключаем падение
                end
            end
        end)
    else
        if NoclipLoop then NoclipLoop:Disconnect() end
        local char = LP.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end)

Section:NewButton("Мгновенный проход (TP-Forward)", "Телепорт на 5 метров вперед", function()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        -- Короткий прыжок сквозь стену (часто античит не успевает среагировать)
        hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -7) 
    end
end)

Section:NewButton("Destroy Anti-Cheat Parts", "Удаляет невидимые стены", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Transparency == 1 or v.CanCollide == true) and v.Name:lower():find("clip") then
            v:Destroy()
        end
    end
end)
