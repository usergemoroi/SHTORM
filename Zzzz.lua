-- GnomHub: Steal a Brainrot Edition
-- Optimized for Delta Executor

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Создание окна
local Window = WindUI:CreateWindow({
    Title = "GnomHub | Steal a Brainrot",
    Icon = "rbxassetid://114691672281339",
    Author = "by GnomHub Team",
    Folder = "GnomHubLagConfig"
})

local MainTab = Window:Tab({ Title = "Главная", Icon = "bomb" })

--- [ ЛОГИКА LAG BOMB ] ---
local lagActive = false

MainTab:Toggle({
    Title = "Packet Lag Bomb",
    Desc = "Замораживает экран (Screen Freeze)",
    Callback = function(state)
        lagActive = state
        
        if state then
            WindUI:Notify({
                Title = "Активировано",
                Content = "Lag Bomb запущена! Подойдите к цели.",
                Icon = "warn"
            })
            
            -- Основной цикл лаггера
            task.spawn(function()
                while lagActive do
                    -- Создание нагрузки на рендер (вызывает застой экрана у слабых устройств)
                    for i = 1, 1000 do
                        if not lagActive then break end
                        local p = Instance.new("Part")
                        p.Size = Vector3.new(0.1, 0.1, 0.1)
                        p.Transparency = 1
                        p.CanCollide = false
                        p.Anchored = true
                        p.Position = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(math.random(-5,5), 5, math.random(-5,5))
                        p.Parent = workspace
                        
                        -- Быстрое удаление, чтобы не крашнуть свой сервер сразу
                        task.delay(0.05, function() p:Destroy() end)
                    end
                    
                    -- Маленькая пауза, чтобы твой телефон не вылетел моментально
                    RunService.RenderStepped:Wait()
                end
            end)
        else
            WindUI:Notify({
                Title = "Деактивировано",
                Content = "Нагрузка снята.",
                Icon = "check"
            })
        end
    end
})

-- Дополнительная кнопка для NoClip (чтобы зайти на базу, если закрыто)
MainTab:Button({
    Title = "Проход сквозь стены (NoClip)",
    Callback = function()
        local char = LocalPlayer.Character
        if char then
            for _, obj in pairs(char:GetDescendants()) do
                if obj:IsA("BasePart") then
                    obj.CanCollide = false
                end
            end
            WindUI:Notify({Title = "NoClip", Content = "Стены отключены", Icon = "info"})
        end
    end
})

Window:SelectTab(1)
