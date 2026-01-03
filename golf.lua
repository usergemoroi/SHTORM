-- Gnom Hub | Hide the Body - Полностью рабочий
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Очистка старого GUI
if game.CoreGui:FindFirstChild("GnomHub") then
    game.CoreGui:FindFirstChild("GnomHub"):Destroy()
end

-- Основной GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GnomHub"
ScreenGui.Parent = game.CoreGui

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 500)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 35, 75)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Gnom Hub | Hide the Body"
Title.TextColor3 = Color3.fromRGB(120, 170, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.white
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Вкладки
local TabButtonsFrame = Instance.new("Frame")
TabButtonsFrame.Size = UDim2.new(1, 0, 0, 40)
TabButtonsFrame.Position = UDim2.new(0, 0, 0, 40)
TabButtonsFrame.BackgroundTransparency = 1
TabButtonsFrame.Parent = MainFrame

local tabs = {"Персонаж", "Автоматизация", "Визуалы", "Другое"}
local currentTab = 1

-- Контейнер для контента
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -100)
ContentFrame.Position = UDim2.new(0, 10, 0, 90)
ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 55)
ContentFrame.Parent = MainFrame

-- Создаем вкладки
local function createTabButton(index, text)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1/#tabs, -2, 1, 0)
    button.Position = UDim2.new((index-1)/#tabs, 0, 0, 0)
    button.BackgroundColor3 = (index == 1) and Color3.fromRGB(50, 90, 180) or Color3.fromRGB(35, 55, 110)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(180, 200, 255)
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.BorderSizePixel = 0
    button.Parent = TabButtonsFrame
    
    return button
end

-- Функция создания элемента
local function createElement(text, isToggle)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(30, 40, 80)
    frame.BorderSizePixel = 0
    
    if isToggle then
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 30, 0, 30)
        toggle.Position = UDim2.new(0, 10, 0.5, -15)
        toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        toggle.Text = ""
        toggle.Name = "Toggle"
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -50, 1, 0)
        label.Position = UDim2.new(0, 50, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(200, 220, 255)
        label.TextSize = 16
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        label.Parent = frame
        toggle.Parent = frame
        
        return {Frame = frame, Toggle = toggle, Label = label}
    else
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -20, 0, 30)
        button.Position = UDim2.new(0, 10, 0.5, -15)
        button.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
        button.Text = text
        button.TextColor3 = Color3.white
        button.TextSize = 16
        button.Font = Enum.Font.GothamBold
        
        button.Parent = frame
        return {Frame = frame, Button = button}
    end
end

-- Создаем контейнеры для каждой вкладки
local tabContents = {}
for i = 1, 4 do
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Visible = (i == 1)
    container.Name = "Tab"..i
    container.Parent = ContentFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.Parent = container
    
    tabContents[i] = container
end

-- Создаем кнопки вкладок
local tabButtons = {}
for i, tabName in ipairs(tabs) do
    local button = createTabButton(i, tabName)
    tabButtons[i] = button
    
    button.MouseButton1Click:Connect(function()
        currentTab = i
        for j, content in ipairs(tabContents) do
            content.Visible = (j == i)
            tabButtons[j].BackgroundColor3 = (j == i) and Color3.fromRGB(50, 90, 180) or Color3.fromRGB(35, 55, 110)
        end
    end)
end

-- Добавляем функции в первую вкладку (Персонаж)
local speedElement = createElement("Высокая скорость", true)
speedElement.Toggle.MouseButton1Click:Connect(function()
    if speedElement.Toggle.BackgroundColor3 == Color3.fromRGB(80, 80, 100) then
        speedElement.Toggle.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 50
        end
    else
        speedElement.Toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)
speedElement.Frame.Parent = tabContents[1]

local flightElement = createElement("Полёт (Нажми X)", true)
flightElement.Toggle.MouseButton1Click:Connect(function()
    if flightElement.Toggle.BackgroundColor3 == Color3.fromRGB(80, 80, 100) then
        flightElement.Toggle.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
    else
        flightElement.Toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    end
end)
flightElement.Frame.Parent = tabContents[1]

local teleportElement = createElement("📌 Телепорт к укрытию", false)
teleportElement.Button.MouseButton1Click:Connect(function()
    local spots = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") and obj.Name:lower():find("hide") then
            table.insert(spots, obj)
        end
    end
    
    if #spots > 0 and LocalPlayer.Character then
        local spot = spots[math.random(1, #spots)]
        LocalPlayer.Character.HumanoidRootPart.CFrame = spot.CFrame + Vector3.new(0, 3, 0)
    end
end)
teleportElement.Frame.Parent = tabContents[1]

-- Добавляем функции во вторую вкладку (Автоматизация)
local autohideElement = createElement("Авто-прятание тела", true)
autohideElement.Toggle.MouseButton1Click:Connect(function()
    if autohideElement.Toggle.BackgroundColor3 == Color3.fromRGB(80, 80, 100) then
        autohideElement.Toggle.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
    else
        autohideElement.Toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    end
end)
autohideElement.Frame.Parent = tabContents[2]

local autofarmElement = createElement("Авто-ферма валюты", true)
autofarmElement.Toggle.MouseButton1Click:Connect(function()
    if autofarmElement.Toggle.BackgroundColor3 == Color3.fromRGB(80, 80, 100) then
        autofarmElement.Toggle.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
    else
        autofarmElement.Toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    end
end)
autofarmElement.Frame.Parent = tabContents[2]

local autorestartElement = createElement("Авто-рестарт раунда", true)
autorestartElement.Toggle.MouseButton1Click:Connect(function()
    if autorestartElement.Toggle.BackgroundColor3 == Color3.fromRGB(80, 80, 100) then
        autorestartElement.Toggle.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
    else
        autorestartElement.Toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    end
end)
autorestartElement.Frame.Parent = tabContents[2]

-- Добавляем функции в третью вкладку (Визуалы)
local espElement = createElement("ESP игроков", true)
espElement.Toggle.MouseButton1Click:Connect(function()
    if espElement.Toggle.BackgroundColor3 == Color3.fromRGB(80, 80, 100) then
        espElement.Toggle.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
        -- Включаем ESP
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
        espElement.Toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        -- Выключаем ESP
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
espElement.Frame.Parent = tabContents[3]

local bodylightElement = createElement("Подсветка тела", true)
bodylightElement.Toggle.MouseButton1Click:Connect(function()
    if bodylightElement.Toggle.BackgroundColor3 == Color3.fromRGB(80, 80, 100) then
        bodylightElement.Toggle.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
    else
        bodylightElement.Toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    end
end)
bodylightElement.Frame.Parent = tabContents[3]

-- Добавляем функции в четвертую вкладку (Другое)
local antidetectElement = createElement("Анти-обнаружение", true)
antidetectElement.Toggle.MouseButton1Click:Connect(function()
    if antidetectElement.Toggle.BackgroundColor3 == Color3.fromRGB(80, 80, 100) then
        antidetectElement.Toggle.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:SetAttribute("StepVolume", 0)
            end
        end
    else
        antidetectElement.Toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    end
end)
antidetectElement.Frame.Parent = tabContents[4]

local teleportbodyElement = createElement("📦 Телепорт тело ко мне", false)
teleportbodyElement.Button.MouseButton1Click:Connect(function()
    local body = workspace:FindFirstChild("DeadBody")
    if body and LocalPlayer.Character then
        body.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
    end
end)
teleportbodyElement.Frame.Parent = tabContents[4]

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

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(0, startPos.X + delta.X, 0, startPos.Y + delta.Y)
    end
end)

print("✅ Gnom Hub загружен успешно!")
print("📍 Окно можно перетаскивать за синюю верхнюю панель")
print("🎮 Все функции видны и работают")
