local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Настройка интерфейса SHTORM
local Window = OrionLib:MakeWindow({
    Name = "SHTORM HUB | Trench Combat", 
    HidePremium = false, 
    SaveConfig = false, 
    ConfigFolder = "ShtormConfig",
    IntroEnabled = true,
    IntroText = "SHTORM LOADED"
})

-- Глобальные переменные
getgenv().AimbotEnabled = false
getgenv().TeamCheck = true
getgenv().AimPart = "Head"
getgenv().Sensitivity = 0 -- 0 = моментальный лок, выше = плавнее
getgenv().CircleRadius = 150
getgenv().ESPEnabled = false
getgenv().ChamsEnabled = false
getgenv().SpeedValue = 16

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- === ФУНКЦИИ ===

-- Проверка: враг ли это?
local function IsEnemy(player)
    if not getgenv().TeamCheck then return true end
    if player.Team ~= LocalPlayer.Team then return true end
    return false
end

-- Функция поиска ближайшего врага
local function GetClosestEnemy()
    local ClosestPlayer = nil
    local ShortestDistance = getgenv().CircleRadius

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and IsEnemy(v) then
            local pos = Camera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude -- Используем UserInputService ниже, это упрощение
            
            -- Проверка на FOV (поле зрения)
            local vector, onScreen = Camera:WorldToViewportPoint(v.Character[getgenv().AimPart].Position)
            if onScreen then
                local MouseLocation = game:GetService("UserInputService"):GetMouseLocation()
                local Distance = (Vector2.new(MouseLocation.X, MouseLocation.Y) - Vector2.new(vector.X, vector.Y)).Magnitude
                
                if Distance < ShortestDistance then
                    ShortestDistance = Distance
                    ClosestPlayer = v
                end
            end
        end
    end
    return ClosestPlayer
end

-- Обновление Чамсов (ESP)
task.spawn(function()
    while true do
        task.wait(1)
        if getgenv().ChamsEnabled then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character then
                    -- Удаляем старые, если есть
                    if v.Character:FindFirstChild("ShtormHighlight") then
                        v.Character.ShtormHighlight:Destroy()
                    end
                    
                    if IsEnemy(v) and v.Character:FindFirstChild("HumanoidRootPart") then
                        local h = Instance.new("Highlight")
                        h.Name = "ShtormHighlight"
                        h.Parent = v.Character
                        h.Adornee = v.Character
                        h.FillColor = Color3.fromRGB(255, 0, 0) -- Красный цвет врага
                        h.OutlineColor = Color3.fromRGB(255, 255, 255)
                        h.FillTransparency = 0.5
                        h.OutlineTransparency = 0
                        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- ВИДНО СКВОЗЬ СТЕНЫ
                    end
                end
            end
        else
            -- Очистка чамсов при выключении
            for _, v in pairs(Players:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("ShtormHighlight") then
                    v.Character.ShtormHighlight:Destroy()
                end
            end
        end
    end
end)

-- === ВКЛАДКИ ===

local CombatTab = Window:MakeTab({
	Name = "Combat (Бой)",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local VisualsTab = Window:MakeTab({
	Name = "Visuals (ВХ)",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local PlayerTab = Window:MakeTab({
	Name = "Player (Персонаж)",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- === ЭЛЕМЕНТЫ МЕНЮ ===

-- Aimbot
CombatTab:AddToggle({
	Name = "Enable Aimbot",
	Default = false,
	Callback = function(Value)
		getgenv().AimbotEnabled = Value
	end    
})

CombatTab:AddToggle({
	Name = "Team Check (Не стрелять в своих)",
	Default = true,
	Callback = function(Value)
		getgenv().TeamCheck = Value
	end    
})

-- Visuals
VisualsTab:AddToggle({
	Name = "Chams (Сквозь стены)",
	Default = false,
	Callback = function(Value)
		getgenv().ChamsEnabled = Value
	end    
})

-- Speed
PlayerTab:AddSlider({
	Name = "WalkSpeed",
	Min = 16,
	Max = 100,
	Default = 16,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Speed",
	Callback = function(Value)
        getgenv().SpeedValue = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
	end    
})

-- Loop для поддержания скорости (если игра сбрасывает)
task.spawn(function()
    while task.wait(0.5) do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if LocalPlayer.Character.Humanoid.WalkSpeed ~= getgenv().SpeedValue and getgenv().SpeedValue > 16 then
                LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().SpeedValue
            end
        end
    end
end)

-- Loop Аимбота
RunService.RenderStepped:Connect(function()
    if getgenv().AimbotEnabled then
        local Target = GetClosestEnemy()
        if Target and Target.Character and Target.Character:FindFirstChild(getgenv().AimPart) then
            -- Плавное или жесткое наведение камеры
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character[getgenv().AimPart].Position)
        end
    end
end)

OrionLib:Init()
