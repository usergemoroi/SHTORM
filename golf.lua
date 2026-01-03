-- Gnom Hub | Hide the Body - Полная рабочая версия
getgenv().GnomHub = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if game.CoreGui:FindFirstChild("GnomHubUI") then
    game.CoreGui:FindFirstChild("GnomHubUI"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GnomHubUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 500)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 45)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 35, 75)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8, 0, 0)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -100, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Gnom Hub | Hide the Body"
TitleLabel.TextColor3 = Color3.fromRGB(120, 170, 255)
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0.5, -15)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.white
CloseButton.TextSize = 16
CloseButton.Parent = TitleBar

local UICornerClose = Instance.new("UICorner")
UICornerClose.CornerRadius = UDim.new(0, 4)
UICornerClose.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, 0, 0, 40)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local Tabs = {
    "🚀 Персонаж",
    "🤖 Автоматизация", 
    "👁 Визуалы",
    "⚙ Другое"
}

local TabButtons = {}
local TabContents = {}

local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -20, 1, -100)
ContentContainer.Position = UDim2.new(0, 10, 0, 90)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local function CreateButton(text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = color
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.white
    btn.TextSize = 16
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    return btn
end

local function CreateToggle(name, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundTransparency = 1
    
    local toggle = Instance.new("TextButton")
    toggle.Name = "Toggle"
    toggle.Size = UDim2.new(0, 35, 0, 35)
    toggle.Position = UDim2.new(0, 0, 0, 5)
    toggle.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    toggle.Font = Enum.Font.GothamBold
    toggle.Text = ""
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = toggle
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -45, 1, 0)
    label.Position = UDim2.new(0, 45, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 230, 255)
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    toggle.Parent = frame
    
    return {Frame = frame, Toggle = toggle, Label = label, State = default}
end

for i, tabName in ipairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Name = "Tab_"..i
    TabButton.Size = UDim2.new(1/#Tabs, -5, 1, 0)
    TabButton.Position = UDim2.new((i-1)/#Tabs, 0, 0, 0)
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 50, 100)
    TabButton.BorderSizePixel = 0
    TabButton.Font = Enum.Font.Gotham
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(180, 200, 255)
    TabButton.TextSize = 14
    TabButton.Parent = TabContainer
    
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = "Content_"..i
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = Color3.fromRGB(60, 120, 220)
    TabContent.Visible = (i == 1)
    TabContent.Parent = ContentContainer
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = TabContent
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    TabButtons[i] = TabButton
    TabContents[i] = TabContent
    
    TabButton.MouseButton1Click:Connect(function()
        for j, content in ipairs(TabContents) do
            content.Visible = false
            TabButtons[j].BackgroundColor3 = Color3.fromRGB(40, 50, 100)
        end
        TabContent.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(60, 80, 160)
    end)
end

TabButtons[1].BackgroundColor3 = Color3.fromRGB(60, 80, 160)

local SpeedEnabled = false
local FlightEnabled = false
local ESPEnabled = false
local NoClipEnabled = false
local AutoHideEnabled = false
local AutoFarmEnabled = false

local function UpdateSpeed()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = SpeedEnabled and 50 or 16
    end
end

local FlightBodyVelocity
local function UpdateFlight()
    if FlightEnabled then
        if LocalPlayer.Character then
            FlightBodyVelocity = Instance.new("BodyVelocity")
            FlightBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            FlightBodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
            FlightBodyVelocity.Parent = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        end
    elseif FlightBodyVelocity then
        FlightBodyVelocity:Destroy()
        FlightBodyVelocity = nil
    end
end

local function UpdateNoClip()
    NoClipEnabled = not NoClipEnabled
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not NoClipEnabled
            end
        end
    end
end

local ESPHighlights = {}
local function UpdateESP()
    ESPEnabled = not ESPEnabled
    
    for player, highlight in pairs(ESPHighlights) do
        highlight:Destroy()
    end
    ESPHighlights = {}
    
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESP_"..player.Name
                highlight.FillColor = Color3.fromRGB(255, 50, 50)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.4
                
                if player.Character then
                    highlight.Parent = player.Character
                end
                
                player.CharacterAdded:Connect(function(char)
                    highlight.Parent = char
                end)
                
                ESPHighlights[player] = highlight
            end
        end
    end
end

local BodyHighlight
local function UpdateBodyHighlight()
    if workspace:FindFirstChild("DeadBody") and not BodyHighlight then
        BodyHighlight = Instance.new("Highlight")
        BodyHighlight.Name = "BodyHighlight"
        BodyHighlight.FillColor = Color3.fromRGB(255, 0, 255)
        BodyHighlight.OutlineColor = Color3.fromRGB(255, 255, 0)
        BodyHighlight.Parent = workspace.DeadBody
    elseif BodyHighlight and not workspace:FindFirstChild("DeadBody") then
        BodyHighlight:Destroy()
        BodyHighlight = nil
    end
end

spawn(function()
    while true do
        if BodyHighlight then
            UpdateBodyHighlight()
        end
        wait(1)
    end
end)

local function TeleportToHidingSpot()
    local spots = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") and (obj.Name:lower():find("hide") or obj.Name:lower():find("bush") or obj.Name:lower():find("box")) then
            table.insert(spots, obj)
        end
    end
    
    if #spots > 0 and LocalPlayer.Character then
        local spot = spots[math.random(1, #spots)]
        LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = spot.CFrame + Vector3.new(0, 3, 0)
    end
end

local function TeleportBodyToMe()
    local body = workspace:FindFirstChild("DeadBody")
    if body and LocalPlayer.Character then
        body.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
    end
end

local function AutoHideBody()
    while AutoHideEnabled do
        wait(3)
        local body = workspace:FindFirstChild("DeadBody")
        if body and LocalPlayer.Character then
            local hidingSpots = {}
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Part") and obj.Name:lower():find("hide") then
                    table.insert(hidingSpots, obj)
                end
            end
            
            if #hidingSpots > 0 then
                local spot = hidingSpots[math.random(1, #hidingSpots)]
                body.CFrame = spot.CFrame
            end
        end
    end
end

local function AutoFarm()
    while AutoFarmEnabled do
        wait(2)
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Part") and (obj.Name:lower():find("coin") or obj.Name:lower():find("cash") or obj.Name:lower():find("money")) then
                if LocalPlayer.Character then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame
                    wait(0.5)
                end
            end
        end
    end
end

local function AntiDetection()
    pcall(function()
        LocalPlayer.Character.Humanoid:SetAttribute("StepVolume", 0)
        if LocalPlayer.Character.Head:FindFirstChild("NameTag") then
            LocalPlayer.Character.Head.NameTag:Destroy()
        end
    end)
end

local content1 = TabContents[1]

local speedToggle = CreateToggle("Высокая скорость", false)
speedToggle.Toggle.MouseButton1Click:Connect(function()
    SpeedEnabled = not SpeedEnabled
    speedToggle.Toggle.BackgroundColor3 = SpeedEnabled and Color3.fromRGB(60, 180, 100) or Color3.fromRGB(70, 70, 90)
    UpdateSpeed()
end)
speedToggle.Frame.Parent = content1

local flightToggle = CreateToggle("Полёт (Нажми X)", false)
flightToggle.Toggle.MouseButton1Click:Connect(function()
    FlightEnabled = not FlightEnabled
    flightToggle.Toggle.BackgroundColor3 = FlightEnabled and Color3.fromRGB(60, 180, 100) or Color3.fromRGB(70, 70, 90)
    UpdateFlight()
end)
flightToggle.Frame.Parent = content1

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.X and FlightEnabled and FlightBodyVelocity then
        FlightBodyVelocity.Velocity = Vector3.new(0, 50, 0)
        wait(0.2)
        FlightBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
end)

local teleportButton = CreateButton("📌 Телепорт к укрытию", Color3.fromRGB(50, 100, 200))
teleportButton.MouseButton1Click:Connect(TeleportToHidingSpot)
teleportButton.Parent = content1

local noclipToggle = CreateToggle("NoClip (Нажми N)", false)
noclipToggle.Toggle.MouseButton1Click:Connect(function()
    UpdateNoClip()
    noclipToggle.Toggle.BackgroundColor3 = NoClipEnabled and Color3.fromRGB(60, 180, 100) or Color3.fromRGB(70, 70, 90)
end)
noclipToggle.Frame.Parent = content1

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.N then
        UpdateNoClip()
        noclipToggle.Toggle.BackgroundColor3 = NoClipEnabled and Color3.fromRGB(60, 180, 100) or Color3.fromRGB(70, 70, 90)
    end
end)

local content2 = TabContents[2]

local autohideToggle = CreateToggle("Авто-прятание тела", false)
autohideToggle.Toggle.MouseButton1Click:Connect(function()
    AutoHideEnabled = not AutoHideEnabled
    autohideToggle.Toggle.BackgroundColor3 = AutoHideEnabled and Color3.fromRGB(60, 180, 100) or Color3.fromRGB(70, 70, 90)
    if AutoHideEnabled then
        spawn(AutoHideBody)
    end
end)
autohideToggle.Frame.Parent = content2

local autofarmToggle = CreateToggle("Авто-ферма валюты", false)
autofarmToggle.Toggle.MouseButton1Click:Connect(function()
    AutoFarmEnabled = not AutoFarmEnabled
    autofarmToggle.Toggle.BackgroundColor3 = AutoFarmEnabled and Color3.fromRGB(60, 180, 100) or Color3.fromRGB(70, 70, 90)
    if AutoFarmEnabled then
        spawn(AutoFarm)
    end
end)
autofarmToggle.Frame.Parent = content2

local autorestartToggle = CreateToggle("Авто-рестарт раунда", false)
autorestartToggle.Toggle.MouseButton1Click:Connect(function()
    local state = autorestartToggle.Toggle.BackgroundColor3 == Color3.fromRGB(60, 180, 100)
    autorestartToggle.Toggle.BackgroundColor3 = not state and Color3.fromRGB(60, 180, 100) or Color3.fromRGB(70, 70, 90)
    
    spawn(function()
        while autorestartToggle.Toggle.BackgroundColor3 == Color3.fromRGB(60, 180, 100) do
            wait(5)
            for _, gui in pairs(game.CoreGui:GetDescendants()) do
                if gui:IsA("TextButton") and (gui.Text:lower():find("restart") or gui.Text:lower():find("play again")) then
                    gui:Fire("MouseButton1Click")
                end
            end
        end
    end)
end)
autorestartToggle.Frame.Parent = content2

local content3 = TabContents[3]

local espToggle = CreateToggle("ESP игроков", false)
espToggle.Toggle.MouseButton1Click:Connect(function()
    UpdateESP()
    espToggle.Toggle.BackgroundColor3 = ESPEnabled and Color3.fromRGB(60, 180, 100) or Color3.fromRGB(70, 70, 90)
end)
espToggle.Frame.Parent = content3

local bodylightToggle = CreateToggle("Подсветка тела", false)
bodylightToggle.Toggle.MouseButton1Click:Connect(function()
    local state = bodylightToggle.Toggle.BackgroundColor3 == Color3.fromRGB(60, 180, 100)
    bodylightToggle.Toggle.BackgroundColor3 = not state and Color3.fromRGB(60, 180, 100) or Color3.fromRGB(70, 70, 90)
    
    if not state then
        spawn(function()
            while bodylightToggle.Toggle.BackgroundColor3 == Color3.fromRGB(60, 180, 100) do
                UpdateBodyHighlight()
                wait(0.5)
            end
        end)
    end
end)
bodylightToggle.Frame.Parent = content3

local content4 = TabContents[4]

local antidetectToggle = CreateToggle("Анти-обнаружение", false)
antidetectToggle.Toggle.MouseButton1Click:Connect(function()
    local state = antidetectToggle.Toggle.BackgroundColor3 == Color3.fromRGB(60, 180, 100)
    antidetectToggle.Toggle.BackgroundColor3 = not state and Color3.fromRGB(60, 180, 100) or Color3.fromRGB(70, 70, 90)
    if not state then
        AntiDetection()
    end
end)
antidetectToggle.Frame.Parent = content4

local teleportbodyButton = CreateButton("📦 Телепорт тело ко мне", Color3.fromRGB(180, 80, 180))
teleportbodyButton.MouseButton1Click:Connect(TeleportBodyToMe)
teleportbodyButton.Parent = content4

for i, content in ipairs(TabContents) do
    local totalHeight = 0
    for _, child in pairs(content:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") then
            totalHeight = totalHeight + child.Size.Y.Offset + 10
        end
    end
    content.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

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

MainFrame.BackgroundTransparency = 1
TitleBar.BackgroundTransparency = 1
TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0.1}):Play()
TweenService:Create(TitleBar, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()

print("✅ Gnom Hub загружен успешно!")
print("📍 Перетаскивание: за заголовок")
print("🎮 Вкладки: Персонаж, Автоматизация, Визуалы, Другое")

LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    UpdateSpeed()
    if FlightEnabled then UpdateFlight() end
end)
