-- Gnom Hub | Hide the Body Ultimate Script
-- Load with any executor (Synapse X, KRNL, ScriptWare)

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Основной GUI
local ScreenGui = Instance.new("ScreenGui")
if game.CoreGui:FindFirstChild("GnomHub") then
    game.CoreGui:FindFirstChild("GnomHub"):Destroy()
end
ScreenGui.Name = "GnomHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 500)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 40)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Тень
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 20, 1, 20)
Shadow.Position = UDim2.new(0, -10, 0, -10)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://5554236805"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.8
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
Shadow.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(20, 30, 70)
Title.BackgroundTransparency = 0
Title.BorderSizePixel = 0
Title.Font = Enum.Font.GothamBold
Title.Text = "Gnom Hub | Hide the Body"
Title.TextColor3 = Color3.fromRGB(100, 150, 255)
Title.TextSize = 24
Title.Parent = MainFrame

-- Закрытие
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 10)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.white
CloseButton.TextSize = 18
CloseButton.Parent = Title
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Табы
local TabButtons = {}
local TabFrames = {}

local tabs = {"Персонаж", "Автоматизация", "Визуалы", "Другое"}

for i, tabName in ipairs(tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName.."Tab"
    TabButton.Size = UDim2.new(0.25, 0, 0, 40)
    TabButton.Position = UDim2.new(0.25 * (i-1), 0, 0, 50)
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 45, 90)
    TabButton.BorderSizePixel = 0
    TabButton.Font = Enum.Font.Gotham
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(150, 180, 255)
    TabButton.TextSize = 14
    TabButton.Parent = MainFrame
    
    local TabFrame = Instance.new("ScrollingFrame")
    TabFrame.Name = tabName.."Frame"
    TabFrame.Size = UDim2.new(1, -20, 1, -100)
    TabFrame.Position = UDim2.new(0, 10, 0, 100)
    TabFrame.BackgroundTransparency = 1
    TabFrame.BorderSizePixel = 0
    TabFrame.ScrollBarThickness = 4
    TabFrame.ScrollBarImageColor3 = Color3.fromRGB(50, 100, 200)
    TabFrame.Visible = (i == 1)
    TabFrame.Parent = MainFrame
    
    TabButtons[tabName] = TabButton
    TabFrames[tabName] = TabFrame
    
    TabButton.MouseButton1Click:Connect(function()
        for _, frame in pairs(TabFrames) do
            frame.Visible = false
        end
        for _, button in pairs(TabButtons) do
            button.BackgroundColor3 = Color3.fromRGB(30, 45, 90)
        end
        TabFrame.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(50, 80, 160)
    end)
end

-- Функции для создания элементов GUI
local function CreateToggle(name, parent, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 30, 0, 30)
    ToggleButton.Position = UDim2.new(0, 0, 0, 5)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Text = ""
    ToggleButton.TextSize = 14
    ToggleButton.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -40, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 40, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
    ToggleLabel.TextSize = 16
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local active = false
    
    ToggleButton.MouseButton1Click:Connect(function()
        active = not active
        if active then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 120, 220)}):Play()
        else
            ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
        end
        callback(active)
    end)
    
    return {Toggle = ToggleButton, Label = ToggleLabel}
end

local function CreateButton(name, parent, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -20, 0, 40)
    Button.Position = UDim2.new(0, 10, 0, 0)
    Button.BackgroundColor3 = Color3.fromRGB(40, 70, 140)
    Button.BorderSizePixel = 0
    Button.Font = Enum.Font.GothamBold
    Button.Text = name
    Button.TextColor3 = Color3.white
    Button.TextSize = 16
    Button.Parent = parent
    
    Button.MouseButton1Click:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 100, 200)}):Play()
        wait(0.1)
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 70, 140)}):Play()
        callback()
    end)
end

-- ФУНКЦИИ СКРИПТА
local SpeedEnabled = false
local FlightEnabled = false
local ESPEnabled = false
local AutoFarmEnabled = false
local AutoHideEnabled = false

-- 🚀 Функции персонажа
local CharFrame = TabFrames["Персонаж"]

-- Высокая скорость
CreateToggle("Высокая скорость (Shift)", CharFrame, function(state)
    SpeedEnabled = state
    if state then
        LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 50
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.LeftShift then
                LocalPlayer.Character.Humanoid.WalkSpeed = 100
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.LeftShift then
                LocalPlayer.Character.Humanoid.WalkSpeed = 50
            end
        end)
    else
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- Полёт
CreateToggle("Полёт (X)", CharFrame, function(state)
    FlightEnabled = state
    local bodyVelocity
    
    if state then
        local character = LocalPlayer.Character
        local humanoid = character:WaitForChild("Humanoid")
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Parent = character:WaitForChild("HumanoidRootPart")
        
        local flying = true
        local speed = 50
        
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.X then
                flying = not flying
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
            
            if flying then
                if input.KeyCode == Enum.KeyCode.Space then
                    bodyVelocity.Velocity = Vector3.new(0, speed, 0)
                elseif input.KeyCode == Enum.KeyCode.LeftControl then
                    bodyVelocity.Velocity = Vector3.new(0, -speed, 0)
                end
            end
        end)
    else
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
    end
end)

-- Телепорт к укрытию
CreateButton("Телепорт к лучшему укрытию", CharFrame, function()
    local hidingSpots = {}
    
    -- Поиск всех возможных укрытий
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") and (obj.Name:lower():find("hide") or obj.Name:lower():find("cover") 
           or obj.Name:lower():find("bush") or obj.Name:lower():find("box")) then
            table.insert(hidingSpots, obj)
        end
    end
    
    -- Выбор самого дальнего от игроков
    local bestSpot = nil
    local maxDistance = 0
    
    for _, spot in pairs(hidingSpots) do
        local minDist = math.huge
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local dist = (spot.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                end
            end
        end
        
        if minDist > maxDistance then
            maxDistance = minDist
            bestSpot = spot
        end
    end
    
    if bestSpot then
        LocalPlayer.Character.HumanoidRootPart.CFrame = bestSpot.CFrame + Vector3.new(0, 3, 0)
    end
end)

-- 🤖 Автоматизация действий
local AutoFrame = TabFrames["Автоматизация"]

-- Авто-прятание тела
CreateToggle("Авто-прятание тела", AutoFrame, function(state)
    AutoHideEnabled = state
    
    while AutoHideEnabled do
        wait(1)
        local body = workspace:FindFirstChild("DeadBody") or workspace:FindFirstChild("Body")
        
        if body and LocalPlayer.Team.Name == "Murderer" then
            -- Подбираем тело
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, body, 0)
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, body, 1)
            
            -- Ищем укрытие
            local hidingSpots = {}
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Part") and obj.Name:lower():find("hide") then
                    table.insert(hidingSpots, obj)
                end
            end
            
            if #hidingSpots > 0 then
                local spot = hidingSpots[math.random(1, #hidingSpots)]
                LocalPlayer.Character.HumanoidRootPart.CFrame = spot.CFrame
                
                -- "Прячем" тело
                wait(0.5)
                -- Симуляция действия прятания
                local args = {
                    [1] = "HideBody",
                    [2] = body
                }
                
                -- Поиск RemoteEvent
                local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                if remotes then
                    local hideEvent = remotes:FindFirstChild("HideEvent") or remotes:FindFirstChild("ActionEvent")
                    if hideEvent then
                        hideEvent:FireServer(unpack(args))
                    end
                end
            end
        end
    end
end)

-- Авто-ферма
CreateToggle("Авто-ферма валюты", AutoFrame, function(state)
    AutoFarmEnabled = state
    
    while AutoFarmEnabled do
        wait(2)
        -- Поиск валюты
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Part") and (obj.Name:lower():find("coin") or obj.Name:lower():find("cash") 
               or obj.Name:lower():find("money") or obj.Name:lower():find("reward")) then
                
                LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame
                wait(0.3)
                
                -- Подбор
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 0)
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 1)
            end
        end
    end
end)

-- Авто-рестарт
CreateToggle("Авто-рестарт раунда", AutoFrame, function(state)
    while state do
        wait(30) -- Каждые 30 секунд проверяем
        
        -- Проверяем конец раунда
        local roundEnd = workspace:FindFirstChild("RoundEnd") 
        or game:GetService("ReplicatedStorage"):FindFirstChild("RoundOver")
        
        if roundEnd then
            -- Нажимаем кнопку рестарта
            local restartButton = nil
            for _, gui in pairs(game:GetService("CoreGui"):GetDescendants()) do
                if gui:IsA("TextButton") and (gui.Text:lower():find("restart") 
                   or gui.Text:lower():find("play again") or gui.Text:lower():find("next round")) then
                    restartButton = gui
                    break
                end
            end
            
            if restartButton then
                restartButton:Fire("MouseButton1Click")
            end
        end
    end
end)

-- Визуалы
local VisualFrame = TabFrames["Визуалы"]

-- ESP
CreateToggle("ESP игроков", VisualFrame, function(state)
    ESPEnabled = state
    
    local highlights = {}
    
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESP_"..player.Name
                highlight.Parent = player.Character
                highlight.FillColor = player.Team.Name == "Murderer" and Color3.fromRGB(255, 50, 50) 
                                      or Color3.fromRGB(50, 255, 50)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.3
                highlights[player] = highlight
            end
        end
        
        -- Обработчик новых игроков
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function(character)
                wait(1)
                if ESPEnabled then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "ESP_"..player.Name
                    highlight.Parent = character
                    highlight.FillColor = player.Team.Name == "Murderer" and Color3.fromRGB(255, 50, 50) 
                                          or Color3.fromRGB(50, 255, 50)
                    highlights[player] = highlight
                end
            end)
        end)
    else
        for player, highlight in pairs(highlights) do
            highlight:Destroy()
        end
        highlights = {}
    end
end)

-- Поиск тела
CreateToggle("Подсветка тела", VisualFrame, function(state)
    while state do
        wait(0.5)
        local body = workspace:FindFirstChild("DeadBody")
        if body and not body:FindFirstChild("BodyHighlight") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "BodyHighlight"
            highlight.Parent = body
            highlight.FillColor = Color3.fromRGB(255, 0, 255)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
        end
    end
end)

-- Другое
local OtherFrame = TabFrames["Другое"]

-- Анти-обнаружение
CreateToggle("Анти-обнаружение", OtherFrame, function(state)
    if state then
        -- Отключаем следы крови
        pcall(function()
            game:GetService("ReplicatedStorage").BloodTrailEvent:FireServer(false)
        end)
        
        -- Уменьшаем звук шагов
        LocalPlayer.Character.Humanoid:SetAttribute("StepVolume", 0)
        
        -- Скрываем имя
        LocalPlayer.Character.Head:FindFirstChild("NameTag"):Destroy()
    end
end)

-- Телепорт с телом
CreateButton("Телепортировать тело ко мне", OtherFrame, function()
    local body = workspace:FindFirstChild("DeadBody")
    if body then
        body.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
    end
end)

-- NoClip
CreateToggle("NoClip (N)", OtherFrame, function(state)
    local noclip = state
    local character = LocalPlayer.Character
    
    if character then
        RunService.Stepped:Connect(function()
            if noclip and character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- Управление окном (перетаскивание)
local dragging
local dragInput
local dragStart
local startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                       startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Сообщение об успехе
print("✅ Gnom Hub загружен!")
print("🎮 Версия: Hide the Body Ultimate")
print("📁 Открыть/закрыть: Not provided (управление через GUI)")

-- Эффект появления
MainFrame.BackgroundTransparency = 1
Title.BackgroundTransparency = 1
TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0.1}):Play()
TweenService:Create(Title, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
