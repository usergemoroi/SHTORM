-- Gnom Hub | Hide the Body - Исправленный скрипт
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Удаляем старое меню
if game.CoreGui:FindFirstChild("GnomHub") then
    game.CoreGui.GnomHub:Destroy()
end

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GnomHub"
ScreenGui.Parent = game.CoreGui

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 450)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 50)
MainFrame.Parent = ScreenGui

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 35, 80)
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Gnom Hub | Hide the Body"
TitleLabel.TextColor3 = Color3.fromRGB(120, 170, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.white
CloseButton.TextSize = 16
CloseButton.Parent = TitleBar

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Кнопки вкладок
local TabButtonsFrame = Instance.new("Frame")
TabButtonsFrame.Size = UDim2.new(1, 0, 0, 30)
TabButtonsFrame.Position = UDim2.new(0, 0, 0, 40)
TabButtonsFrame.BackgroundTransparency = 1
TabButtonsFrame.Parent = MainFrame

-- Контент вкладок
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -80)
ContentFrame.Position = UDim2.new(0, 10, 0, 75)
ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 60)
ContentFrame.Parent = MainFrame

-- Вкладки
local Tabs = {
    {Name = "🚀 Персонаж", Color = Color3.fromRGB(50, 100, 200)},
    {Name = "🤖 Автоматизация", Color = Color3.fromRGB(150, 50, 200)},
    {Name = "👁 Визуалы", Color = Color3.fromRGB(50, 200, 150)},
    {Name = "⚙ Другое", Color = Color3.fromRGB(200, 150, 50)}
}

-- Создаем контейнеры для каждой вкладки
local TabContents = {}
for i = 1, 4 do
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.Visible = (i == 1)
    content.Name = "TabContent"..i
    content.ScrollBarThickness = 4
    content.ScrollingDirection = Enum.ScrollingDirection.Y
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.Parent = ContentFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = content
    
    TabContents[i] = content
end

-- Создаем кнопки вкладок
local TabButtons = {}
for i, tab in ipairs(Tabs) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1/4, 0, 1, 0)
    button.Position = UDim2.new((i-1)/4, 0, 0, 0)
    button.BackgroundColor3 = (i == 1) and Color3.fromRGB(60, 80, 160) or Color3.fromRGB(40, 50, 110)
    button.Text = tab.Name
    button.TextColor3 = Color3.fromRGB(180, 200, 255)
    button.TextSize = 12
    button.Font = Enum.Font.Gotham
    button.Parent = TabButtonsFrame
    
    button.MouseButton1Click:Connect(function()
        -- Скрываем все вкладки
        for j = 1, 4 do
            TabContents[j].Visible = false
            TabButtons[j].BackgroundColor3 = Color3.fromRGB(40, 50, 110)
        end
        -- Показываем выбранную
        TabContents[i].Visible = true
        button.BackgroundColor3 = Color3.fromRGB(60, 80, 160)
    end)
    
    TabButtons[i] = button
end

-- Функция создания переключателя
local function CreateToggle(name, parent, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.fromRGB(30, 40, 90)
    frame.Parent = parent
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 60, 0, 25)
    button.Position = UDim2.new(0, 5, 0.5, -12.5)
    button.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    button.Text = "Выкл"
    button.TextColor3 = Color3.white
    button.TextSize = 12
    button.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Position = UDim2.new(0, 75, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 230, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local state = false
    button.MouseButton1Click:Connect(function()
        state = not state
        if state then
            button.Text = "Вкл"
            button.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
        else
            button.Text = "Выкл"
            button.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        end
        if callback then callback(state) end
    end)
    
    return button
end

-- Функция создания кнопки
local function CreateButton(name, parent, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
    button.Text = name
    button.TextColor3 = Color3.white
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Parent = parent
    
    button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    return button
end

-- 🚀 Вкладка 1: Персонаж
CreateToggle("Высокая скорость", TabContents[1], function(state)
    if LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.WalkSpeed = state and 50 or 16
    end
end)

CreateToggle("Полёт (X)", TabContents[1], function(state)
    getgenv().FlightEnabled = state
end)

CreateButton("📌 Телепорт к укрытию", TabContents[1], function()
    if LocalPlayer.Character then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
    end
end)

CreateToggle("NoClip (N)", TabContents[1], function(state)
    getgenv().NoClipEnabled = state
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not state
            end
        end
    end
end)

-- 🤖 Вкладка 2: Автоматизация
CreateToggle("Авто-прятание тела", TabContents[2], function(state)
    getgenv().AutoHide = state
end)

CreateToggle("Авто-ферма валюты", TabContents[2], function(state)
    getgenv().AutoFarm = state
end)

CreateToggle("Авто-рестарт", TabContents[2], function(state)
    getgenv().AutoRestart = state
end)

-- 👁 Вкладка 3: Визуалы
CreateToggle("ESP игроков", TabContents[3], function(state)
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255, 50, 50)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.Parent = player.Character
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                for _, child in pairs(player.Character:GetChildren()) do
                    if child:IsA("Highlight") then
                        child:Destroy()
                    end
                end
            end
        end
    end
end)

CreateToggle("Подсветка тела", TabContents[3], function(state)
    getgenv().BodyHighlight = state
    if state then
        local body = workspace:FindFirstChild("DeadBody")
        if body then
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(255, 0, 255)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.Parent = body
        end
    end
end)

-- ⚙ Вкладка 4: Другое
CreateToggle("Анти-обнаружение", TabContents[4], function(state)
    if state and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid:SetAttribute("StepVolume", 0)
    end
end)

CreateButton("📦 Телепорт тело ко мне", TabContents[4], function()
    local body = workspace:FindFirstChild("DeadBody")
    if body and LocalPlayer.Character then
        body.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
    end
end)

-- Управление полетом
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.X and getgenv().FlightEnabled and LocalPlayer.Character then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 50, 0)
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
        wait(0.3)
        bodyVelocity:Destroy()
    end
end)

-- Перетаскивание окна
local dragging = false
local dragStart = Vector2.new(0, 0)
local startPos = Vector2.new(0, 0)

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Vector2.new(MainFrame.Position.X.Offset, MainFrame.Position.Y.Offset)
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(0, startPos.X + delta.X, 0, startPos.Y + delta.Y)
    end
end)

print("✅ Gnom Hub успешно загружен!")
print("📍 Перетаскивание: за синюю верхнюю панель")
print("🎮 Вкладки: Персонаж, Автоматизация, Визуалы, Другое")
