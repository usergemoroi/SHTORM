-- Инициализация WindUI (как в твоих файлах)
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Переменная для хранения позиции
local savedCFrame = nil

-- Создание окна
local Window = WindUI:CreateWindow({
    Title = "Brainrot Stealer",
    Icon = "rbxassetid://114691672281339", -- Иконка из GnomHub
    Author = "Steal Script",
    Folder = "StealerConfig"
})

local MainTab = Window:Tab({ Title = "Главная", Icon = "home" })

-- Кнопка: Установить позицию (Set Pos)
MainTab:Button({
    Title = "SET POS (На базе)",
    Desc = "Сохраняет координаты твоей базы",
    Callback = function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            savedCFrame = char.HumanoidRootPart.CFrame
            WindUI:Notify({
                Title = "Успех!",
                Content = "Позиция базы сохранена",
                Icon = "check"
            })
        end
    end
})

-- Кнопка: Телепорт на базу (TP Base)
MainTab:Button({
    Title = "TP BASE (С ворованным)",
    Desc = "Телепортирует тебя и предмет в руках на базу",
    Callback = function()
        local char = LocalPlayer.Character
        if not savedCFrame then
            WindUI:Notify({
                Title = "Ошибка",
                Content = "Сначала нажми SET POS на базе!",
                Icon = "alert-triangle"
            })
            return
        end

        if char and char:FindFirstChild("HumanoidRootPart") then
            -- Телепортация персонажа
            char.HumanoidRootPart.CFrame = savedCFrame
            
            WindUI:Notify({
                Title = "Телепортация",
                Content = "Ты вернулся на базу с добычей!",
                Icon = "map-pin"
            })
        end
    end
})

-- Дополнительная полезная функция: Скорость (из файла tweensteal)
MainTab:Slider({
    Title = "Скорость бега",
    Step = 1,
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(value)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value
        end
    end
})
