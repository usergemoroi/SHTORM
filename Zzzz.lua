-- Загрузка интерфейса
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local savedCFrame = nil

-- Создание окна
local Window = WindUI:CreateWindow({
    Title = "Steal Optimizer v2",
    Icon = "rbxassetid://114691672281339",
    Author = "Anti-Kick System",
    Folder = "StableSteal"
})

local MainTab = Window:Tab({ Title = "Кража", Icon = "shopping-cart" })

-- Функция безопасного перемещения
local function safeTeleport(targetCFrame)
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        -- Временный обход проверок
        humanoid:ChangeState(Enum.HumanoidStateType.Physics) 
        task.wait(0.05)
        
        character:PivotTo(targetCFrame)
        
        -- Возвращаем состояние
        task.wait(0.05)
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
end

-- КНОПКА: SET POS
MainTab:Button({
    Title = "1. СОХРАНИТЬ БАЗУ",
    Desc = "Нажми это, стоя у себя дома",
    Callback = function()
        local char = LocalPlayer.Character
        if char and char.PrimaryPart then
            savedCFrame = char.PrimaryPart.CFrame
            WindUI:Notify({
                Title = "Готово!",
                Content = "Твоя база теперь здесь.",
                Icon = "check"
            })
        end
    end
})

-- КНОПКА: TP BASE
MainTab:Button({
    Title = "2. ТЕЛЕПОРТ НА БАЗУ (С ВЕЩЬЮ)",
    Desc = "Вернуться мгновенно с браинротом",
    Callback = function()
        if not savedCFrame then
            WindUI:Notify({
                Title = "Ошибка",
                Content = "Ты не поставил метку на базе!",
                Icon = "alert-circle"
            })
            return
        end
        
        safeTeleport(savedCFrame)
    end
})

-- АНТИ-АФК (чтобы не кикало за бездействие)
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

WindUI:Notify({
    Title = "Скрипт запущен",
    Content = "Защита от кика активна",
    Icon = "shield"
})
