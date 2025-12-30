-- [[ PROJECT: SHTORM | EXCLUSIVE FOR DELTA ]] --

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- Кастомный чёрный стиль для пацанов
local colors = {
    SchemeColor = Color3.fromRGB(0, 0, 0),
    Background = Color3.fromRGB(10, 10, 10),
    Header = Color3.fromRGB(0, 0, 0),
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(20, 20, 20)
}

local Window = Library.CreateLib("SHTORM", colors)

-- ВКЛАДКА: ГЛАВНАЯ
local Tab1 = Window:NewTab("Фарм")
local Section1 = Tab1:NewSection("Автоматика")

Section1:NewToggle("Авто-сбор Брэйнрота", "Собирает всё дерьмо на карте", function(state)
    _G.AutoFarm = state
    while _G.AutoFarm do
        wait(0.1)
        pcall(function()
            for _, item in pairs(workspace:GetChildren()) do
                if item:IsA("Part") and (item.Name:find("Brainrot") or item:FindFirstChild("TouchInterest")) then
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, item, 0)
                end
            end
        end)
    end
end)

-- ВКЛАДКА: ИГРОК
local Tab2 = Window:NewTab("Персонаж")
local Section2 = Tab2:NewSection("Улучшения")

Section2:NewSlider("Скорость бега", "Стань пулей", 250, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

Section2:NewButton("Бесконечная стамина", "Бегай без одышки", function()
    -- Допустим, стамина лежит в локальном скрипте игрока
    if game.Players.LocalPlayer.Character:FindFirstChild("Stamina") then
        game.Players.LocalPlayer.Character.Stamina.Value = 99999
    end
end)

-- ВКЛАДКА: ТЕЛЕПОРТ
local Tab3 = Window:NewTab("Телепорты")
local Section3 = Tab3:NewSection("Места")

Section3:NewButton("Телепорт в Зону Сдачи", "Скинуть накопленное", function()
    local dropZone = workspace:FindFirstChild("DropOffZone") -- Уточни имя объекта в игре
    if dropZone then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = dropZone.CFrame
    end
end)

-- ВКЛАДКА: НАСТРОЙКИ
local Tab4 = Window:NewTab("Настройки")
local Section4 = Tab4:NewSection("Система")

Section4:NewButton("Уничтожить SHTORM", "Свалить по-тихому", function()
    Library:DestroyGui()
end)
