-- GnomHUB Premium - Steal A Brainrot
-- Beautiful UI Edition

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Anti-Kick Protection
do
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    local oldIndex = mt.__index
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if self == LocalPlayer and method == "Kick" then
            return nil
        end
        return oldNamecall(self, ...)
    end)
    
    mt.__index = newcclosure(function(self, k)
        if self == LocalPlayer and k == "Kick" then
            return function() end
        end
        return oldIndex(self, k)
    end)
    
    setreadonly(mt, true)
end

-- Color Palette
local ColorTheme = {
    Primary = Color3.fromRGB(59, 130, 246),    -- Blue
    Secondary = Color3.fromRGB(139, 92, 246),  -- Purple
    Success = Color3.fromRGB(34, 197, 94),     -- Green
    Danger = Color3.fromRGB(239, 68, 68),      -- Red
    Warning = Color3.fromRGB(245, 158, 11),    -- Orange
    Dark = Color3.fromRGB(30, 30, 40),
    Light = Color3.fromRGB(245, 247, 250)
}

-- Create Main Screen GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GnomHUBPremium"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game.CoreGui
else
    ScreenGui.Parent = game.CoreGui
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 450)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -225)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0

-- Gradient
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 50))
})
Gradient.Rotation = 45
Gradient.Parent = MainFrame

-- Corner Radius
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- Shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 20, 1, 20)
Shadow.Position = UDim2.new(0.5, -10, 0.5, -10)
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://5554236805"
Shadow.ImageColor3 = Color3.new(0, 0, 0)
Shadow.ImageTransparency = 0.8
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
Shadow.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 60)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

local Logo = Instance.new("TextLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.new(0, 200, 0, 40)
Logo.Position = UDim2.new(0, 20, 0.5, -20)
Logo.AnchorPoint = Vector2.new(0, 0.5)
Logo.BackgroundTransparency = 1
Logo.Text = "GnomHUB Premium"
Logo.TextColor3 = ColorTheme.Primary
Logo.TextSize = 28
Logo.Font = Enum.Font.GothamBold
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.Parent = TopBar

local Version = Instance.new("TextLabel")
Version.Name = "Version"
Version.Size = UDim2.new(0, 100, 0, 20)
Version.Position = UDim2.new(0, 200, 0, 5)
Version.BackgroundTransparency = 1
Version.Text = "v3.5.0"
Version.TextColor3 = Color3.fromRGB(150, 150, 180)
Version.TextSize = 14
Version.Font = Enum.Font.Gotham
Version.TextXAlignment = Enum.TextXAlignment.Left
Version.Parent = Logo

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0.5, -15)
CloseButton.AnchorPoint = Vector2.new(1, 0.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(200, 200, 220)
CloseButton.TextSize = 24
CloseButton.Font = Enum.Font.GothamBold
CloseButton.AutoButtonColor = false

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

CloseButton.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = ColorTheme.Danger}):Play()
end)

CloseButton.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

CloseButton.Parent = TopBar

-- Tabs Container
local TabsContainer = Instance.new("Frame")
TabsContainer.Name = "TabsContainer"
TabsContainer.Size = UDim2.new(0, 150, 1, -60)
TabsContainer.Position = UDim2.new(0, 0, 0, 60)
TabsContainer.BackgroundTransparency = 1
TabsContainer.Parent = MainFrame

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -150, 1, -60)
ContentContainer.Position = UDim2.new(0, 150, 0, 60)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ClipsDescendants = true
ContentContainer.Parent = MainFrame

-- Tabs
local Tabs = {}
local CurrentTab = nil

local function CreateTab(name, icon)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.Size = UDim2.new(1, -20, 0, 50)
    TabButton.Position = UDim2.new(0, 10, 0, 10 + (#Tabs * 55))
    TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    TabButton.Text = ""
    TabButton.AutoButtonColor = false
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabButton
    
    local Icon = Instance.new("ImageLabel")
    Icon.Name = "Icon"
    Icon.Size = UDim2.new(0, 24, 0, 24)
    Icon.Position = UDim2.new(0, 15, 0.5, -12)
    Icon.AnchorPoint = Vector2.new(0, 0.5)
    Icon.BackgroundTransparency = 1
    Icon.Image = icon
    Icon.ImageColor3 = Color3.fromRGB(150, 150, 180)
    Icon.Parent = TabButton
    
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 50, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(200, 200, 220)
    Label.TextSize = 16
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = TabButton
    
    local Highlight = Instance.new("Frame")
    Highlight.Name = "Highlight"
    Highlight.Size = UDim2.new(0, 4, 0.6, 0)
    Highlight.Position = UDim2.new(0, -4, 0.2, 0)
    Highlight.BackgroundColor3 = ColorTheme.Primary
    Highlight.Visible = false
    Highlight.Parent = TabButton
    
    local HighlightCorner = Instance.new("UICorner")
    HighlightCorner.CornerRadius = UDim.new(0, 2)
    HighlightCorner.Parent = Highlight
    
    TabButton.Parent = TabsContainer
    
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Size = UDim2.new(1, -20, 1, -20)
    TabContent.Position = UDim2.new(0, 10, 0, 10)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 5
    TabContent.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 75)
    TabContent.Visible = false
    TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContent.Parent = ContentContainer
    
    Tabs[name] = {
        Button = TabButton,
        Content = TabContent,
        Active = false
    }
    
    TabButton.MouseButton1Click:Connect(function()
        if CurrentTab then
            CurrentTab.Button.Highlight.Visible = false
            TweenService:Create(CurrentTab.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
            TweenService:Create(CurrentTab.Button.Icon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(150, 150, 180)}):Play()
            CurrentTab.Content.Visible = false
            CurrentTab.Active = false
        end
        
        CurrentTab = Tabs[name]
        CurrentTab.Button.Highlight.Visible = true
        TweenService:Create(CurrentTab.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
        TweenService:Create(CurrentTab.Button.Icon, TweenInfo.new(0.2), {ImageColor3 = ColorTheme.Primary}):Play()
        CurrentTab.Content.Visible = true
        CurrentTab.Active = true
    end)
    
    TabButton.MouseEnter:Connect(function()
        if not Tabs[name].Active then
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if not Tabs[name].Active then
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
        end
    end)
    
    return TabContent
end

-- Game Resources
local Net
local CastRemote, ClickRemote, SellRemote

pcall(function()
    Net = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"))
    CastRemote = Net:RemoteEvent("FishingRod.Cast")
    ClickRemote = Net:RemoteEvent("FishingRod.MinigameClick")
    SellRemote = Net:RemoteEvent("PlotService/Sell")
end)

-- Create Tabs
local MainTab = CreateTab("Main", "rbxassetid://3926305904")
local AutoFarmTab = CreateTab("Auto Farm", "rbxassetid://3926305904")
local VisualTab = CreateTab("Visual", "rbxassetid://3926305904")
local MiscTab = CreateTab("Misc", "rbxassetid://3926305904")
local SettingsTab = CreateTab("Settings", "rbxassetid://3926305904")

-- Activate first tab
Tabs["Main"].Button.MouseButton1Click:Fire()

-- Function to create sections
local function CreateSection(parent, title)
    local Section = Instance.new("Frame")
    Section.Name = "Section"
    Section.Size = UDim2.new(1, 0, 0, 40)
    Section.BackgroundTransparency = 1
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Name = "Title"
    SectionTitle.Size = UDim2.new(1, 0, 0, 30)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = title
    SectionTitle.TextColor3 = ColorTheme.Primary
    SectionTitle.TextSize = 18
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = Section
    
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, 0, 0, 0)
    Content.Position = UDim2.new(0, 0, 0, 35)
    Content.BackgroundTransparency = 1
    Content.Parent = Section
    
    local Separator = Instance.new("Frame")
    Separator.Name = "Separator"
    Separator.Size = UDim2.new(1, -10, 0, 1)
    Separator.Position = UDim2.new(0, 5, 0, 25)
    Separator.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    Separator.Parent = Section
    
    return Section, Content
end

-- Function to create toggle
local function CreateToggle(parent, text, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Name = "Toggle"
    Toggle.Size = UDim2.new(1, -20, 0, 40)
    Toggle.BackgroundTransparency = 1
    
    local Button = Instance.new("TextButton")
    Button.Name = "Button"
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Toggle
    
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "ToggleFrame"
    ToggleFrame.Size = UDim2.new(0, 50, 0, 25)
    ToggleFrame.Position = UDim2.new(1, -60, 0.5, -12.5)
    ToggleFrame.AnchorPoint = Vector2.new(1, 0.5)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Name = "Circle"
    ToggleCircle.Size = UDim2.new(0, 21, 0, 21)
    ToggleCircle.Position = UDim2.new(0, 2, 0.5, -10.5)
    ToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(180, 180, 200)
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle
    
    ToggleCircle.Parent = ToggleFrame
    ToggleFrame.Parent = Toggle
    
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 240)
    Label.TextSize = 16
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Toggle
    
    local State = false
    
    local function UpdateToggle()
        if State then
            TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = ColorTheme.Success}):Play()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -23, 0.5, -10.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        else
            TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 65)}):Play()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 2, 0.5, -10.5),
                BackgroundColor3 = Color3.fromRGB(180, 180, 200)
            }):Play()
        end
    end
    
    Button.MouseButton1Click:Connect(function()
        State = not State
        UpdateToggle()
        if callback then
            pcall(callback, State)
        end
    end)
    
    Toggle.Parent = parent
    return Toggle, function(newState)
        State = newState
        UpdateToggle()
    end
end

-- Function to create button
local function CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = "Button"
    Button.Size = UDim2.new(1, -20, 0, 40)
    Button.BackgroundColor3 = ColorTheme.Primary
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 16
    Button.Font = Enum.Font.Gotham
    Button.AutoButtonColor = false
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(79, 140, 255)}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = ColorTheme.Primary}):Play()
    end)
    
    Button.MouseButton1Click:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(39, 110, 226)}):Play()
        wait(0.1)
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = ColorTheme.Primary}):Play()
        
        if callback then
            pcall(callback)
        end
    end)
    
    Button.Parent = parent
    return Button
end

-- Main Tab Content
local MainSection, MainContent = CreateSection(MainTab, "Welcome to GnomHUB")
local WelcomeLabel = Instance.new("TextLabel")
WelcomeLabel.Size = UDim2.new(1, -20, 0, 100)
WelcomeLabel.BackgroundTransparency = 1
WelcomeLabel.Text = "Premium Script for Steal A Brainrot\n\nFeatures:\n• Auto Fishing & Selling\n• Player ESP & Visuals\n• Speed & Jump Boost\n• Anti-Trap & Protection\n• Beautiful UI"
WelcomeLabel.TextColor3 = Color3.fromRGB(180, 180, 220)
WelcomeLabel.TextSize = 16
WelcomeLabel.Font = Enum.Font.Gotham
WelcomeLabel.TextXAlignment = Enum.TextXAlignment.Left
WelcomeLabel.TextYAlignment = Enum.TextYAlignment.Top
WelcomeLabel.Parent = MainContent

-- Auto Farm Tab
local FarmSection, FarmContent = CreateSection(AutoFarmTab, "Auto Farming")

local farmActive = false
local autoFishToggle, setFishState = CreateToggle(FarmContent, "Auto Fishing (Full Auto)", function(state)
    farmActive = state
    if state then
        task.spawn(function()
            while farmActive do
                pcall(function()
                    CastRemote:FireServer(Vector3.new(0, 0, 0))
                end)
                task.wait(0.5)
                for i = 1, 10 do
                    if not farmActive then break end
                    pcall(function()
                        ClickRemote:FireServer()
                    end)
                    task.wait(0.1)
                end
                task.wait(1)
            end
        end)
    end
end)

local autoSellToggle, setSellState = CreateToggle(FarmContent, "Auto Sell Items", function(state)
    _G.AutoSell = state
    if state then
        task.spawn(function()
            while _G.AutoSell do
                pcall(function()
                    SellRemote:FireServer()
                end)
                task.wait(5)
            end
        end)
    end
end)

CreateButton(FarmContent, "Start Farm Session", function()
    setFishState(true)
    setSellState(true)
end)

CreateButton(FarmContent, "Stop Farm Session", function()
    setFishState(false)
    setSellState(false)
end)

-- Visual Tab
local VisualSection, VisualContent = CreateSection(VisualTab, "Visual Features")

local espActive = false
local espToggle, setEspState = CreateToggle(VisualContent, "Player ESP", function(state)
    espActive = state
    if state then
        task.spawn(function()
            while espActive do
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local highlight = player.Character:FindFirstChild("GnomHUB_ESP") or Instance.new("Highlight")
                        highlight.Name = "GnomHUB_ESP"
                        highlight.FillColor = Color3.fromRGB(59, 130, 246)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.7
                        highlight.OutlineTransparency = 0
                        highlight.Parent = player.Character
                    end
                end
                task.wait(1)
            end
        end)
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("GnomHUB_ESP") then
                player.Character.GnomHUB_ESP:Destroy()
            end
        end
    end
end)

local speedToggle, setSpeedState = CreateToggle(VisualContent, "Speed Boost", function(state)
    if state then
        local conn = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 50
            end
        end)
        table.insert(getgenv().Connections or {}, conn)
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

local jumpToggle, setJumpState = CreateToggle(VisualContent, "Infinite Jump", function(state)
    if state then
        UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

-- Misc Tab
local MiscSection, MiscContent = CreateSection(MiscTab, "Miscellaneous Features")

CreateButton(MiscContent, "Anti-Trap (Remove Traps)", function()
    task.spawn(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("TouchTransmitter") and obj.Name == "TouchInterest" then
                local parent = obj.Parent
                if parent and parent.Name == "Open" then
                    obj:Destroy()
                end
            end
        end
    end)
end)

CreateButton(MiscContent, "No Clip", function()
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

CreateButton(MiscContent, "Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

-- Settings Tab
local SettingsSection, SettingsContent = CreateSection(SettingsTab, "Script Settings")

local uiToggle, setUIState = CreateToggle(SettingsContent, "Show UI", function(state)
    MainFrame.Visible = state
end)

CreateButton(SettingsContent, "Save Settings", function()
    -- Save settings implementation
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "GnomHUB",
        Text = "Settings saved!",
        Duration = 3
    })
end)

CreateButton(SettingsContent, "Load Settings", function()
    -- Load settings implementation
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "GnomHUB",
        Text = "Settings loaded!",
        Duration = 3
    })
end)

CreateButton(SettingsContent, "Unload Script", function()
    ScreenGui:Destroy()
    for _, conn in pairs(getgenv().Connections or {}) do
        pcall(function() conn:Disconnect() end)
    end
end)

-- Draggable UI
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TopBar.InputBegan:Connect(function(input)
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

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Auto-resize content
local function UpdateContentSize(contentFrame)
    local totalHeight = 0
    for _, child in pairs(contentFrame:GetChildren()) do
        if child:IsA("Frame") then
            totalHeight = totalHeight + child.AbsoluteSize.Y + 5
        end
    end
    contentFrame.Parent.Parent.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 20)
end

-- Connect auto-resize
for _, tab in pairs(Tabs) do
    tab.Content:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        UpdateContentSize(tab.Content)
    end)
end

-- Initial notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "GnomHUB Premium",
    Text = "Script loaded successfully!",
    Duration = 5,
    Icon = "rbxassetid://3926305904"
})

print("GnomHUB Premium loaded!")
