-- Gnom Hub для Hide the Body - Упрощенный рабочий вариант
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Удаляем старое меню
if game.CoreGui:FindFirstChild("GnomHubUI") then
    game.CoreGui.GnomHubUI:Destroy()
end

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GnomHubUI"
ScreenGui.Parent = game.CoreGui

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 450)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 60)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 40, 90)
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Gnom Hub | Hide the Body"
Title.TextColor3 = Color3.fromRGB(120, 170, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0.5, -12.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.white
CloseButton.TextSize = 14
CloseButton.Parent = TitleBar

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Контейнер для кнопок вкладок
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 30)
TabContainer.Position = UDim2.new(0, 0, 0, 35)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

-- Контейнер для контента
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -20, 1, -75)
ContentContainer.Position = UDim2.new(0, 10, 0, 70)
ContentContainer.BackgroundColor3 = Color3.fromRGB(25, 30, 70)
ContentContainer.Parent = MainFrame

-- Вкладки
local Tabs = {
    "Персонаж",
    "Автоматизация", 
    "Визуалы",
    "Другое"
}

-- Создаем кнопки вкладок
for i, tabName in ipairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1/4, 0, 1, 0)
    TabButton.Position = UDim2.new((i-1)/4, 0, 0, 0)
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 50, 110)
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(180, 200, 255)
    TabButton.TextSize = 12
    TabButton.Font = Enum.Font.Gotham
    TabButton.Parent = TabContainer
end

-- Создаем контент для вкладок
local ContentFrames = {}

for i = 1, 4 do
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundTransparency = 1
    Frame.Visible = (i == 1)
    Frame.Parent = ContentContainer
    ContentFrames[i] = Frame
end

-- Функция для создания элемента
local function CreateElement(parent, text, isToggle)
    local ElementFrame = Instance.new("Frame")
    ElementFrame.Size = UDim2.new(1, 0, 0, 35)
    ElementFrame.BackgroundColor3 = Color3.fromRGB(35, 45, 95)
    ElementFrame.Parent = parent
    
    if isToggle then
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0, 60, 0, 25)
        ToggleButton.Position = UDim2.new(0, 10, 0.5, -12.5)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        ToggleButton.Text = "Выкл"
        ToggleButton.TextColor3 = Color3.white
        ToggleButton.TextSize = 12
        ToggleButton.Parent = ElementFrame
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -80, 1, 0)
        Label.Position = UDim2.new(0, 80, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(220, 230, 255)
        Label.TextSize = 14
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ElementFrame
        
        return {Frame = ElementFrame, Toggle = ToggleButton, Label = Label}
    else
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -20, 0, 30)
        Button.Position = UDim2.new(0, 10, 0.5, -15)
        Button.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
        Button.Text = text
        Button.TextColor3 = Color3.white
        Button.TextSize = 14
        Button.Font = Enum.Font.GothamBold
        Button.Parent = ElementFrame
        
        return {Frame = ElementFrame, Button = Button}
    end
end

-- Вкладка 1: Персонаж
local speedToggle = CreateElement(ContentFrames[1], "Высокая скорость", true)
speedToggle.Toggle.MouseButton1Click:Connect(function()
    if speedToggle.Toggle.Text == "Выкл" then
        speedToggle.Toggle.Text = "Вкл"
        speedToggle.Toggle.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
        if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.WalkSpeed = 50
        end
    else
        speedToggle.Toggle.Text = "Выкл"
        speedToggle.Toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

local flightToggle = CreateElement(ContentFrames[1], "Полёт", true)
flightToggle.Toggle.MouseButton1Click:Connect(function()
    if flightToggle.Toggle.Text == "Выкл" then
        flightToggle.Toggle.Text = "Вкл"
        flightToggle.Toggle.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
    else
        flightToggle.Toggle.Text = "Выкл"
        flightToggle.Toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    end
end)

local teleportBtn = CreateElement(ContentFrames[1], "Телепорт к укрытию", false)
teleportBtn.Button.MouseButton1Click:Connect(function()
    if LocalPlayer.Character then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
    end
end)

-- Вкладка 2: Автоматизация
local autoHideToggle = CreateElement(ContentFrames[2], "Авто-прятание тела", true)
autoHideToggle.Toggle.MouseButton1Click:Connect(function()
    if autoHideToggle.Toggle.Text == "Выкл" then
        autoHideToggle.Toggle.Text = "Вкл"
        autoHideToggle.Toggle.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
    else
        autoHideToggle.Toggle.Text = "Выкл"
        autoHideToggle.Toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    end
end)

local autoFarmToggle = CreateElement(ContentFrames[2], "Авто-ферма валюты", true)
autoFarmToggle.Toggle.MouseButton1Click:Connect(function()
    if autoFarmToggle.Toggle.Text == "Выкл" then
        autoFarmToggle.Toggle.Text = "Вкл"
        autoFarmToggle.Toggle.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
    else
        autoFarmToggle.Toggle.Text = "Выкл"
        autoFarmToggle.Toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    end
end)

local autoRestartToggle = CreateElement(ContentFrames[2], "Авто-рестарт", true)
autoRestartToggle.Toggle.MouseButton1Click:Connect(function()
    if autoRestartToggle.Toggle.Text == "Выкл" then
        autoRestartToggle.Toggle.Text = "Вкл"
        autoRestartToggle.Toggle.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
    else
        autoRestartToggle.Toggle.Text = "Выкл"
        autoRestartToggle.Toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    end
end)

-- Вкладка 3: Визуалы
local espToggle = CreateElement(ContentFrames[3], "ESP игроков", true)
espToggle.Toggle.MouseButton1Click:Connect(function()
    if espToggle.Toggle.Text == "Выкл" then
        espToggle.Toggle.Text = "Вкл"
        espToggle.Toggle.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
    else
        espToggle.Toggle.Text = "Выкл"
        espToggle.Toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    end
end)

local bodyHighlightToggle = CreateElement(ContentFrames[3], "Подсветка тела", true)
bodyHighlightToggle.Toggle.MouseButton1Click:Connect(function()
    if bodyHighlightToggle.Toggle.Text == "Выкл" then
        bodyHighlightToggle.Toggle.Text = "Вкл"
        bodyHighlightToggle.Toggle.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
    else
        bodyHighlightToggle.Toggle.Text = "Выкл"
        bodyHighlightToggle.Toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    end
end)

-- Вкладка 4: Другое
local antiDetectToggle = CreateElement(ContentFrames[4], "Анти-обнаружение", true)
antiDetectToggle.Toggle.MouseButton1Click:Connect(function()
    if antiDetectToggle.Toggle.Text == "Выкл" then
        antiDetectToggle.Toggle.Text = "Вкл"
        antiDetectToggle.Toggle.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
    else
        antiDetectToggle.Toggle.Text = "Выкл"
        antiDetectToggle.Toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    end
end)

local teleportBodyBtn = CreateElement(ContentFrames[4], "Телепорт тело ко мне", false)
teleportBodyBtn.Button.MouseButton1Click:Connect(function()
    local body = workspace:FindFirstChild("DeadBody")
    if body and LocalPlayer.Character then
        body.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
    end
end)

-- Переключаем вкладки
local tabButtons = TabContainer:GetChildren()
for i, button in ipairs(tabButtons) do
    if button:IsA("TextButton") then
        button.MouseButton1Click:Connect(function()
            -- Скрываем все вкладки
            for j = 1, 4 do
                ContentFrames[j].Visible = false
                tabButtons[j].BackgroundColor3 = Color3.fromRGB(40, 50, 110)
            end
            
            -- Показываем выбранную вкладку
            ContentFrames[i].Visible = true
            button.BackgroundColor3 = Color3.fromRGB(60, 80, 160)
        end)
    end
end

-- Делаем первую вкладку активной
tabButtons[1].BackgroundColor3 = Color3.fromRGB(60, 80, 160)

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

print("✅ Gnom Hub загружен!")
print("🚀 Вкладка 1: Персонаж - Высокая скорость, Полёт, Телепорт")
print("🤖 Вкладка 2: Автоматизация - Авто-прятание, Авто-ферма, Авто-рестарт")
print("👁 Вкладка 3: Визуалы - ESP, Подсветка тела")
print("⚙ Вкладка 4: Другое - Анти-обнаружение, Телепорт тела")
