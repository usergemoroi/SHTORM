-- Gnom Hub | Hide the Body Ultimate Script
-- Исправленная версия с рабочим GUI

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Очистка старых GUI
if game.CoreGui:FindFirstChild("GnomHub") then
    game.CoreGui:FindFirstChild("GnomHub"):Destroy()
end

-- Основной GUI
local ScreenGui = Instance.new("ScreenGui")
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
MainFrame.BorderColor3 = Color3.fromRGB(50, 100, 200)
MainFrame.BorderSizePixel = 2
MainFrame.Parent = ScreenGui

-- Тень
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 10, 1, 10)
Shadow.Position = UDim2.new(0, -5, 0, -5)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://5554236805"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.7
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
Title.Text = "   Gnom Hub | Hide the Body"
Title.TextColor3 = Color3.fromRGB(100, 150, 255)
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
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

-- Вкладки
local TabButtonsFrame = Instance.new("Frame")
TabButtonsFrame.Name = "TabButtons"
TabButtonsFrame.Size = UDim2.new(1, 0, 0, 40)
TabButtonsFrame.Position = UDim2.new(0, 0, 0, 50)
TabButtonsFrame.BackgroundTransparency = 1
TabButtonsFrame.Parent = MainFrame

-- Создаем контейнер для контента вкладок
local TabContentFrame = Instance.new("Frame")
TabContentFrame.Name = "TabContent"
TabContentFrame.Size = UDim2.new(1, -20, 1, -110)
TabContentFrame.Position = UDim2.new(0, 10, 0, 100)
TabContentFrame.BackgroundTransparency = 1
TabContentFrame.Parent = MainFrame

-- Создаем ScrollingFrame для контента
local ContentScrolling = Instance.new("ScrollingFrame")
ContentScrolling.Name = "ContentScrolling"
ContentScrolling.Size = UDim2.new(1, 0, 1, 0)
ContentScrolling.BackgroundTransparency = 1
ContentScrolling.BorderSizePixel = 0
ContentScrolling.ScrollBarThickness = 4
ContentScrolling.ScrollBarImageColor3 = Color3.fromRGB(50, 100, 200)
ContentScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentScrolling.Parent = TabContentFrame

-- UIListLayout для элементов
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ContentScrolling
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Создаем вкладки
local tabs = {
    {Name = "🚀 Персонаж", Color = Color3.fromRGB(50, 150, 255)},
    {Name = "🤖 Автоматизация", Color = Color3.fromRGB(150, 50, 255)},
    {Name = "👁 Визуалы", Color = Color3.fromRGB(50, 255, 150)},
    {Name = "⚙ Другое", Color = Color3.fromRGB(255, 150, 50)}
}

local currentTab = 1

-- Функция обновления контента
local function updateContent(tabIndex)
    -- Очищаем старый контент
    for _, child in pairs(ContentScrolling:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    if tabIndex == 1 then
        -- 🚀 Персонаж
        local function createSpeedToggle()
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 50)
            frame.BackgroundColor3 = Color3.fromRGB(30, 40, 80)
            frame.BorderSizePixel = 0
            frame.LayoutOrder = 1
            
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(0, 100, 0, 30)
            button.Position = UDim2.new(0.5, -50, 0.5, -15)
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            button.Font = Enum.Font.GothamBold
            button.Text = "Выкл"
            button.TextColor3 = Color3.white
            button.TextSize = 14
            button.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -120, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.Text = "Высокая скорость"
            label.TextColor3 = Color3.fromRGB(200, 220, 255)
            label.TextSize = 16
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            
            local active = false
            button.MouseButton1Click:Connect(function()
                active = not active
                if active then
                    button.Text = "Вкл"
                    button.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid.WalkSpeed = 50
                    end
                else
                    button.Text = "Выкл"
                    button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid.WalkSpeed = 16
                    end
                end
            end)
            
            return frame
        end
        
        local function createFlightToggle()
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 50)
            frame.BackgroundColor3 = Color3.fromRGB(30, 40, 80)
            frame.BorderSizePixel = 0
            frame.LayoutOrder = 2
            
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(0, 100, 0, 30)
            button.Position = UDim2.new(0.5, -50, 0.5, -15)
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            button.Font = Enum.Font.GothamBold
            button.Text = "Выкл"
            button.TextColor3 = Color3.white
            button.TextSize = 14
            button.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -120, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.Text = "Полёт (X)"
            label.TextColor3 = Color3.fromRGB(200, 220, 255)
            label.TextSize = 16
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            
            local bodyVelocity
            local active = false
            
            button.MouseButton1Click:Connect(function()
                active = not active
                if active then
                    button.Text = "Вкл"
                    button.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
                    
                    local character = LocalPlayer.Character
                    if character then
                        bodyVelocity = Instance.new("BodyVelocity")
                        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                        bodyVelocity.Parent = character.PrimaryPart or character:WaitForChild("HumanoidRootPart")
                    end
                else
                    button.Text = "Выкл"
                    button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                    if bodyVelocity then
                        bodyVelocity:Destroy()
                    end
                end
            end)
            
            return frame
        end
        
        local function createTeleportButton()
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 0, 40)
            button.BackgroundColor3 = Color3.fromRGB(40, 80, 160)
            button.BorderSizePixel = 0
            button.Font = Enum.Font.GothamBold
            button.Text = "📌 Телепорт к укрытию"
            button.TextColor3 = Color3.white
            button.TextSize = 16
            button.LayoutOrder = 3
            
            button.MouseButton1Click:Connect(function()
                -- Поиск случайного укрытия
                local hidingSpots = {}
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Part") and (obj.Name:lower():find("hide") or obj.Name:lower():find("bush") 
                       or obj.Name:lower():find("box") or obj.Name:lower():find("cover")) then
                        table.insert(hidingSpots, obj)
                    end
                end
                
                if #hidingSpots > 0 then
                    local spot = hidingSpots[math.random(1, #hidingSpots)]
                    if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
                        LocalPlayer.Character.PrimaryPart.CFrame = spot.CFrame + Vector3.new(0, 5, 0)
                    end
                end
            end)
            
            return button
        end
        
        -- Добавляем элементы
        createSpeedToggle().Parent = ContentScrolling
        createFlightToggle().Parent = ContentScrolling
        createTeleportButton().Parent = ContentScrolling
        
    elseif tabIndex == 2 then
        -- 🤖 Автоматизация
        local function createAutoHideToggle()
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 50)
            frame.BackgroundColor3 = Color3.fromRGB(30, 40, 80)
            frame.BorderSizePixel = 0
            frame.LayoutOrder = 1
            
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(0, 100, 0, 30)
            button.Position = UDim2.new(0.5, -50, 0.5, -15)
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            button.Font = Enum.Font.GothamBold
            button.Text = "Выкл"
            button.TextColor3 = Color3.white
            button.TextSize = 14
            button.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -120, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.Text = "Авто-прятание тела"
            label.TextColor3 = Color3.fromRGB(200, 220, 255)
            label.TextSize = 16
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            
            local active = false
            button.MouseButton1Click:Connect(function()
                active = not active
                if active then
                    button.Text = "Вкл"
                    button.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
                    spawn(function()
                        while active do
                            wait(2)
                            local body = workspace:FindFirstChild("DeadBody")
                            if body and LocalPlayer.Character then
                                -- Телепортируем тело в случайное место
                                body.CFrame = CFrame.new(
                                    math.random(-100, 100),
                                    5,
                                    math.random(-100, 100)
                                )
                            end
                        end
                    end)
                else
                    button.Text = "Выкл"
                    button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                end
            end)
            
            return frame
        end
        
        local function createAutoFarmToggle()
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 50)
            frame.BackgroundColor3 = Color3.fromRGB(30, 40, 80)
            frame.BorderSizePixel = 0
            frame.LayoutOrder = 2
            
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(0, 100, 0, 30)
            button.Position = UDim2.new(0.5, -50, 0.5, -15)
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            button.Font = Enum.Font.GothamBold
            button.Text = "Выкл"
            button.TextColor3 = Color3.white
            button.TextSize = 14
            button.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -120, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.Text = "Авто-ферма валюты"
            label.TextColor3 = Color3.fromRGB(200, 220, 255)
            label.TextSize = 16
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            
            return frame
        end
        
        local function createAutoRestartToggle()
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 50)
            frame.BackgroundColor3 = Color3.fromRGB(30, 40, 80)
            frame.BorderSizePixel = 0
            frame.LayoutOrder = 3
            
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(0, 100, 0, 30)
            button.Position = UDim2.new(0.5, -50, 0.5, -15)
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            button.Font = Enum.Font.GothamBold
            button.Text = "Выкл"
            button.TextColor3 = Color3.white
            button.TextSize = 14
            button.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -120, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.Text = "Авто-рестарт раунда"
            label.TextColor3 = Color3.fromRGB(200, 220, 255)
            label.TextSize = 16
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            
            return frame
        end
        
        -- Добавляем элементы
        createAutoHideToggle().Parent = ContentScrolling
        createAutoFarmToggle().Parent = ContentScrolling
        createAutoRestartToggle().Parent = ContentScrolling
        
    elseif tabIndex == 3 then
        -- 👁 Визуалы
        local function createESPToggle()
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 50)
            frame.BackgroundColor3 = Color3.fromRGB(30, 40, 80)
            frame.BorderSizePixel = 0
            frame.LayoutOrder = 1
            
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(0, 100, 0, 30)
            button.Position = UDim2.new(0.5, -50, 0.5, -15)
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            button.Font = Enum.Font.GothamBold
            button.Text = "Выкл"
            button.TextColor3 = Color3.white
            button.TextSize = 14
            button.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -120, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.Text = "ESP игроков"
            label.TextColor3 = Color3.fromRGB(200, 220, 255)
            label.TextSize = 16
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            
            local highlights = {}
            local active = false
            
            button.MouseButton1Click:Connect(function()
                active = not active
                if active then
                    button.Text = "Вкл"
                    button.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
                    
                    -- Включаем ESP
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "ESP_" .. player.Name
                            highlight.FillColor = Color3.fromRGB(255, 50, 50)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.FillTransparency = 0.5
                            highlight.Parent = player.Character
                            highlights[player] = highlight
                        end
                    end
                else
                    button.Text = "Выкл"
                    button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                    
                    -- Выключаем ESP
                    for player, highlight in pairs(highlights) do
                        highlight:Destroy()
                    end
                    highlights = {}
                end
            end)
            
            return frame
        end
        
        local function createBodyHighlighter()
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 50)
            frame.BackgroundColor3 = Color3.fromRGB(30, 40, 80)
            frame.BorderSizePixel = 0
            frame.LayoutOrder = 2
            
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(0, 100, 0, 30)
            button.Position = UDim2.new(0.5, -50, 0.5, -15)
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            button.Font = Enum.Font.GothamBold
            button.Text = "Выкл"
            button.TextColor3 = Color3.white
            button.TextSize = 14
            button.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -120, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.Text = "Подсветка тела"
            label.TextColor3 = Color3.fromRGB(200, 220, 255)
            label.TextSize = 16
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            
            local active = false
            local highlight
            
            button.MouseButton1Click:Connect(function()
                active = not active
                if active then
                    button.Text = "Вкл"
                    button.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
                    
                    spawn(function()
                        while active do
                            wait(0.5)
                            local body = workspace:FindFirstChild("DeadBody")
                            if body and not body:FindFirstChild("BodyHighlight") then
                                highlight = Instance.new("Highlight")
                                highlight.Name = "BodyHighlight"
                                highlight.FillColor = Color3.fromRGB(255, 0, 255)
                                highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                                highlight.Parent = body
                            end
                        end
                    end)
                else
                    button.Text = "Выкл"
                    button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                    if highlight then
                        highlight:Destroy()
                    end
                end
            end)
            
            return frame
        end
        
        -- Добавляем элементы
        createESPToggle().Parent = ContentScrolling
        createBodyHighlighter().Parent = ContentScrolling
        
    elseif tabIndex == 4 then
        -- ⚙ Другое
        local function createNoClipToggle()
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 50)
            frame.BackgroundColor3 = Color3.fromRGB(30, 40, 80)
            frame.BorderSizePixel = 0
            frame.LayoutOrder = 1
            
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(0, 100, 0, 30)
            button.Position = UDim2.new(0.5, -50, 0.5, -15)
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            button.Font = Enum.Font.GothamBold
            button.Text = "Выкл"
            button.TextColor3 = Color3.white
            button.TextSize = 14
            button.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -120, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.Text = "NoClip (N)"
            label.TextColor3 = Color3.fromRGB(200, 220, 255)
            label.TextSize = 16
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            
            local active = false
            button.MouseButton1Click:Connect(function()
                active = not active
                if active then
                    button.Text = "Вкл"
                    button.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
                    
                    spawn(function()
                        while active do
                            if LocalPlayer.Character then
                                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                                    if part:IsA("BasePart") then
                                        part.CanCollide = false
                                    end
                                end
                            end
                            wait(0.1)
                        end
                    end)
                else
                    button.Text = "Выкл"
                    button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                end
            end)
            
            return frame
        end
        
        local function createAntiDetectionToggle()
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 50)
            frame.BackgroundColor3 = Color3.fromRGB(30, 40, 80)
            frame.BorderSizePixel = 0
            frame.LayoutOrder = 2
            
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(0, 100, 0, 30)
            button.Position = UDim2.new(0.5, -50, 0.5, -15)
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            button.Font = Enum.Font.GothamBold
            button.Text = "Выкл"
            button.TextColor3 = Color3.white
            button.TextSize = 14
            button.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -120, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.Text = "Анти-обнаружение"
            label.TextColor3 = Color3.fromRGB(200, 220, 255)
            label.TextSize = 16
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            
            button.MouseButton1Click:Connect(function()
                if button.Text == "Выкл" then
                    button.Text = "Вкл"
                    button.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
                else
                    button.Text = "Выкл"
                    button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                end
            end)
            
            return frame
        end
        
        local function createTeleportBodyButton()
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 0, 40)
            button.BackgroundColor3 = Color3.fromRGB(40, 80, 160)
            button.BorderSizePixel = 0
            button.Font = Enum.Font.GothamBold
            button.Text = "📦 Телепорт тело ко мне"
            button.TextColor3 = Color3.white
            button.TextSize = 16
            button.LayoutOrder = 3
            
            button.MouseButton1Click:Connect(function()
                local body = workspace:FindFirstChild("DeadBody")
                if body and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
                    body.CFrame = LocalPlayer.Character.PrimaryPart.CFrame
                end
            end)
            
            return button
        end
        
        -- Добавляем элементы
        createNoClipToggle().Parent = ContentScrolling
        createAntiDetectionToggle().Parent = ContentScrolling
        createTeleportBodyButton().Parent = ContentScrolling
    end
    
    -- Обновляем размер CanvasSize
    local totalHeight = 0
    for _, child in pairs(ContentScrolling:GetChildren()) do
        if child:IsA("Frame") then
            totalHeight = totalHeight + child.Size.Y.Offset + 10
        elseif child:IsA("TextButton") then
            totalHeight = totalHeight + child.Size.Y.Offset + 10
        end
    end
    
    ContentScrolling.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- Создаем кнопки вкладок
for i, tab in pairs(tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Name = "Tab" .. i
    TabButton.Size = UDim2.new(1/#tabs, 0, 1, 0)
    TabButton.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
    TabButton.BackgroundColor3 = (i == 1) and Color3.fromRGB(50, 80, 160) or Color3.fromRGB(30, 45, 90)
    TabButton.BorderSizePixel = 0
    TabButton.Font = Enum.Font.Gotham
    TabButton.Text = tab.Name
    TabButton.TextColor3 = Color3.fromRGB(200, 220, 255)
    TabButton.TextSize = 14
    TabButton.Parent = TabButtonsFrame
    
    TabButton.MouseButton1Click:Connect(function()
        currentTab = i
        updateContent(i)
        
        -- Обновляем цвета кнопок
        for j, btn in pairs(TabButtonsFrame:GetChildren()) do
            if btn:IsA("TextButton") then
                if tonumber(btn.Name:match("%d+")) == i then
                    btn.BackgroundColor3 = Color3.fromRGB(50, 80, 160)
                else
                    btn.BackgroundColor3 = Color3.fromRGB(30, 45, 90)
                end
            end
        end
    end)
end

-- Загружаем первую вкладку
updateContent(1)

-- Функция перетаскивания окна
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

-- Анимация появления
MainFrame.BackgroundTransparency = 1
Title.BackgroundTransparency = 1

local fadeIn = TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0.1})
local titleFadeIn = TweenService:Create(Title, TweenInfo.new(0.5), {BackgroundTransparency = 0})

fadeIn:Play()
titleFadeIn:Play()

print("✅ Gnom Hub загружен успешно!")
print("🎮 Управление: Перетаскивайте окно за заголовок")
