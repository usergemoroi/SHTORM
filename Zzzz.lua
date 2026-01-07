-- GnomHUB Premium - Steal A Brainrot
-- Ultra Stable Edition

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Enhanced Anti-Kick Protection
do
    -- Wait a bit before applying protection to avoid early detection
    task.wait(0.5)
    
    local function SafePCall(func, ...)
        local success, result = pcall(func, ...)
        if not success then
            warn("[GnomHUB] Protection error:", result)
        end
        return success, result
    end

    -- Method 1: Hook metamethods
    SafePCall(function()
        local mt = getrawmetatable(game)
        if mt then
            setreadonly(mt, false)
            local oldNamecall = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if self == LocalPlayer and method == "Kick" then
                    warn("[GnomHUB] Blocked Kick attempt")
                    return nil
                end
                return oldNamecall(self, ...)
            end)
            setreadonly(mt, true)
        end
    end)

    -- Method 2: Replace Kick function
    SafePCall(function()
        local oldKick = LocalPlayer.Kick
        LocalPlayer.Kick = function(...)
            warn("[GnomHUB] Blocked direct Kick call")
            return nil
        end
    end)

    -- Method 3: Disable connections to Kick event
    SafePCall(function()
        if getconnections then
            for _, conn in pairs(getconnections(LocalPlayer.Kick) or {}) do
                conn:Disable()
            end
        end
    end)

    -- Method 4: Hook function if available
    SafePCall(function()
        if hookfunction then
            hookfunction(LocalPlayer.Kick, function(...)
                warn("[GnomHUB] Hooked Kick function")
                return nil
            end)
        end
    end)

    -- Method 5: Repeated protection (runs every 10 seconds)
    task.spawn(function()
        while task.wait(10) do
            SafePCall(function()
                -- Re-apply protection
                LocalPlayer.Kick = function(...)
                    warn("[GnomHUB] Kick blocked by recurring protection")
                    return nil
                end
            end)
        end
    end)
    
    warn("[GnomHUB] Anti-Kick protection loaded successfully")
end

-- Color Palette
local ColorTheme = {
    Primary = Color3.fromRGB(0, 184, 148),      -- Teal
    Secondary = Color3.fromRGB(253, 203, 110),  -- Gold
    Accent = Color3.fromRGB(225, 112, 85),      -- Coral
    Dark = Color3.fromRGB(30, 30, 46),
    Light = Color3.fromRGB(245, 247, 250),
    Text = Color3.fromRGB(220, 220, 240)
}

-- Game Resources (safely)
local CastRemote, ClickRemote, SellRemote
local function LoadGameResources()
    local success, net = pcall(function()
        return require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"))
    end)
    
    if success and net then
        CastRemote = net:RemoteEvent("FishingRod.Cast")
        ClickRemote = net:RemoteEvent("FishingRod.MinigameClick")
        SellRemote = net:RemoteEvent("PlotService/Sell")
        return true
    end
    return false
end

-- Create Main Screen GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GnomHUB_Premium"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Protection for different executors
if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game.CoreGui
elseif game.CoreGui:FindFirstChild("RobloxGui") then
    ScreenGui.Parent = game.CoreGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Main Frame with subtle animation
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 500)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0

-- Animated background effect
local PulseEffect = Instance.new("Frame")
PulseEffect.Size = UDim2.new(1, 0, 1, 0)
PulseEffect.BackgroundColor3 = ColorTheme.Primary
PulseEffect.BackgroundTransparency = 0.9
PulseEffect.BorderSizePixel = 0
PulseEffect.ZIndex = 0

local PulseCorner = Instance.new("UICorner")
PulseCorner.CornerRadius = UDim.new(0, 12)
PulseCorner.Parent = PulseEffect

PulseEffect.Parent = MainFrame

-- Animate pulse
task.spawn(function()
    while task.wait(3) do
        TweenService:Create(PulseEffect, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0.7
        }):Play()
        task.wait(1)
        TweenService:Create(PulseEffect, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0.9
        }):Play()
    end
end)

-- Main content frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -20)
ContentFrame.Position = UDim2.new(0, 10, 0, 10)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Corner Radius
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 70)
TopBar.BackgroundTransparency = 1
TopBar.Parent = ContentFrame

-- Logo with gradient
local LogoContainer = Instance.new("Frame")
LogoContainer.Size = UDim2.new(0, 300, 0, 60)
LogoContainer.Position = UDim2.new(0, 20, 0, 0)
LogoContainer.BackgroundTransparency = 1

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(1, 0, 1, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "GnomHUB Premium"
LogoText.TextColor3 = ColorTheme.Text
LogoText.TextSize = 32
LogoText.Font = Enum.Font.GothamBold
LogoText.TextXAlignment = Enum.TextXAlignment.Left

-- Add gradient to text
local TextGradient = Instance.new("UIGradient")
TextGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, ColorTheme.Primary),
    ColorSequenceKeypoint.new(0.5, ColorTheme.Secondary),
    ColorSequenceKeypoint.new(1, ColorTheme.Accent)
})
TextGradient.Rotation = 45
TextGradient.Parent = LogoText

LogoText.Parent = LogoContainer
LogoContainer.Parent = TopBar

-- Status indicator
local StatusIndicator = Instance.new("Frame")
StatusIndicator.Size = UDim2.new(0, 10, 0, 10)
StatusIndicator.Position = UDim2.new(1, -30, 0, 30)
StatusIndicator.AnchorPoint = Vector2.new(1, 0.5)
StatusIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
StatusIndicator.BorderSizePixel = 0

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(1, 0)
StatusCorner.Parent = StatusIndicator

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0, 100, 0, 20)
StatusLabel.Position = UDim2.new(0, -110, 0, -5)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "ACTIVE"
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.TextXAlignment = Enum.TextXAlignment.Right
StatusLabel.Parent = StatusIndicator

StatusIndicator.Parent = TopBar

-- Close/Minimize buttons
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -10, 0, 10)
CloseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(200, 200, 220)
CloseButton.TextSize = 24
CloseButton.Font = Enum.Font.GothamBold
CloseButton.AutoButtonColor = false

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Minimize button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -50, 0, 10)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MinimizeButton.Text = "−"
MinimizeButton.TextColor3 = Color3.fromRGB(200, 200, 220)
MinimizeButton.TextSize = 24
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.AutoButtonColor = false

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 6)
MinimizeCorner.Parent = MinimizeButton

-- Tabs Container
local TabsContainer = Instance.new("Frame")
TabsContainer.Name = "TabsContainer"
TabsContainer.Size = UDim2.new(0, 180, 1, -80)
TabsContainer.Position = UDim2.new(0, 0, 0, 80)
TabsContainer.BackgroundTransparency = 1
TabsContainer.Parent = ContentFrame

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -190, 1, -80)
ContentContainer.Position = UDim2.new(0, 190, 0, 80)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ClipsDescendants = true
ContentContainer.Parent = ContentFrame

-- Create UI Elements
local UIComponents = {}

-- Function to create a tab
function UIComponents:CreateTab(name, icon)
    local tab = {}
    
    -- Tab button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.Size = UDim2.new(1, -20, 0, 50)
    TabButton.Position = UDim2.new(0, 10, 0, 10 + (#UIComponents.Tabs or 0) * 55)
    TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    TabButton.Text = ""
    TabButton.AutoButtonColor = false
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabButton
    
    -- Icon
    local Icon = Instance.new("ImageLabel")
    Icon.Name = "Icon"
    Icon.Size = UDim2.new(0, 24, 0, 24)
    Icon.Position = UDim2.new(0, 15, 0.5, -12)
    Icon.AnchorPoint = Vector2.new(0, 0.5)
    Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://" .. icon
    Icon.ImageColor3 = Color3.fromRGB(180, 180, 200)
    Icon.Parent = TabButton
    
    -- Label
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 50, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 240)
    Label.TextSize = 16
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = TabButton
    
    -- Highlight
    local Highlight = Instance.new("Frame")
    Highlight.Name = "Highlight"
    Highlight.Size = UDim2.new(0, 4, 0.7, 0)
    Highlight.Position = UDim2.new(0, -6, 0.15, 0)
    Highlight.BackgroundColor3 = ColorTheme.Primary
    Highlight.Visible = false
    Highlight.Parent = TabButton
    
    local HighlightCorner = Instance.new("UICorner")
    HighlightCorner.CornerRadius = UDim.new(0, 2)
    HighlightCorner.Parent = Highlight
    
    -- Tab content
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 5
    TabContent.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80)
    TabContent.Visible = false
    TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContent.Parent = ContentContainer
    
    -- UIList for content
    local UIList = Instance.new("UIListLayout")
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 10)
    UIList.Parent = TabContent
    
    TabButton.Parent = TabsContainer
    
    -- Store tab data
    tab.Button = TabButton
    tab.Content = TabContent
    tab.Active = false
    tab.Name = name
    
    -- Click handler
    TabButton.MouseButton1Click:Connect(function()
        UIComponents:SwitchTab(name)
    end)
    
    -- Hover effects
    TabButton.MouseEnter:Connect(function()
        if not tab.Active then
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(45, 45, 65)
            }):Play()
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if not tab.Active then
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            }):Play()
        end
    end)
    
    UIComponents.Tabs = UIComponents.Tabs or {}
    UIComponents.Tabs[name] = tab
    
    return tab
end

-- Function to switch tabs
function UIComponents:SwitchTab(tabName)
    if not self.Tabs[tabName] then return end
    
    -- Deactivate current tab
    if self.CurrentTab then
        local oldTab = self.Tabs[self.CurrentTab]
        oldTab.Active = false
        oldTab.Button.Highlight.Visible = false
        oldTab.Content.Visible = false
        TweenService:Create(oldTab.Button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        }):Play()
        TweenService:Create(oldTab.Button.Icon, TweenInfo.new(0.2), {
            ImageColor3 = Color3.fromRGB(180, 180, 200)
        }):Play()
    end
    
    -- Activate new tab
    local newTab = self.Tabs[tabName]
    newTab.Active = true
    newTab.Button.Highlight.Visible = true
    newTab.Content.Visible = true
    TweenService:Create(newTab.Button, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    }):Play()
    TweenService:Create(newTab.Button.Icon, TweenInfo.new(0.2), {
        ImageColor3 = ColorTheme.Primary
    }):Play()
    
    self.CurrentTab = tabName
end

-- Create tabs
local MainTab = UIComponents:CreateTab("Main", "3926307971")
local FarmTab = UIComponents:CreateTab("Farm", "3926305904")
local VisualTab = UIComponents:CreateTab("Visual", "3926307971")
local PlayerTab = UIComponents:CreateTab("Player", "3926309567")
local MiscTab = UIComponents:CreateTab("Misc", "3926310355")

-- Function to create section
function UIComponents:CreateSection(parent, title)
    local section = {}
    
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Name = "Section"
    SectionFrame.Size = UDim2.new(1, 0, 0, 40)
    SectionFrame.BackgroundTransparency = 1
    SectionFrame.LayoutOrder = #parent:GetChildren()
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Name = "Title"
    SectionTitle.Size = UDim2.new(1, -20, 0, 30)
    SectionTitle.Position = UDim2.new(0, 10, 0, 0)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = "  " .. title
    SectionTitle.TextColor3 = ColorTheme.Primary
    SectionTitle.TextSize = 18
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = SectionFrame
    
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, 0, 0, 0)
    Content.Position = UDim2.new(0, 0, 0, 35)
    Content.BackgroundTransparency = 1
    Content.Parent = SectionFrame
    
    local UIList = Instance.new("UIListLayout")
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 5)
    UIList.Parent = Content
    
    SectionFrame.Parent = parent
    section.Frame = SectionFrame
    section.Content = Content
    
    return section
end

-- Function to create toggle
function UIComponents:CreateToggle(parent, text, callback)
    local toggle = {}
    local state = false
    
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "Toggle"
    ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
    ToggleFrame.Position = UDim2.new(0, 10, 0, 0)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    ToggleFrame.BackgroundTransparency = 0.5
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame
    
    local Button = Instance.new("TextButton")
    Button.Name = "Button"
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(0.7, -10, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = ColorTheme.Text
    Label.TextSize = 16
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local Switch = Instance.new("Frame")
    Switch.Name = "Switch"
    Switch.Size = UDim2.new(0, 50, 0, 25)
    Switch.Position = UDim2.new(1, -65, 0.5, -12.5)
    Switch.AnchorPoint = Vector2.new(1, 0.5)
    Switch.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = Switch
    
    local Knob = Instance.new("Frame")
    Knob.Name = "Knob"
    Knob.Size = UDim2.new(0, 21, 0, 21)
    Knob.Position = UDim2.new(0, 2, 0.5, -10.5)
    Knob.AnchorPoint = Vector2.new(0, 0.5)
    Knob.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
    
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob
    
    Knob.Parent = Switch
    Switch.Parent = ToggleFrame
    
    local function UpdateToggle()
        if state then
            TweenService:Create(Switch, TweenInfo.new(0.2), {
                BackgroundColor3 = ColorTheme.Primary
            }):Play()
            TweenService:Create(Knob, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -23, 0.5, -10.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        else
            TweenService:Create(Switch, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            }):Play()
            TweenService:Create(Knob, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 2, 0.5, -10.5),
                BackgroundColor3 = Color3.fromRGB(200, 200, 220)
            }):Play()
        end
    end
    
    Button.MouseButton1Click:Connect(function()
        state = not state
        UpdateToggle()
        if callback then
            pcall(callback, state)
        end
    end)
    
    -- Hover effects
    Button.MouseEnter:Connect(function()
        TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.3
        }):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.5
        }):Play()
    end)
    
    ToggleFrame.Parent = parent
    toggle.Frame = ToggleFrame
    toggle.SetState = function(newState)
        state = newState
        UpdateToggle()
    end
    toggle.GetState = function() return state end
    
    return toggle
end

-- Function to create button
function UIComponents:CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = "Button"
    Button.Size = UDim2.new(1, -20, 0, 45)
    Button.Position = UDim2.new(0, 10, 0, 0)
    Button.BackgroundColor3 = ColorTheme.Primary
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 16
    Button.Font = Enum.Font.GothamMedium
    Button.AutoButtonColor = false
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button
    
    -- Hover effects
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(0, 204, 158)
        }):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = ColorTheme.Primary
        }):Play()
    end)
    
    -- Click effects
    Button.MouseButton1Down:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(0, 164, 128)
        }):Play()
    end)
    
    Button.MouseButton1Up:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(0, 184, 148)
        }):Play()
    end)
    
    -- Click handler
    Button.MouseButton1Click:Connect(function()
        if callback then
            task.spawn(function()
                pcall(callback)
            end)
        end
    end)
    
    Button.Parent = parent
    return Button
end

-- Populate tabs
-- Main Tab
local MainSection = UIComponents:CreateSection(MainTab.Content, "Welcome")
local WelcomeText = Instance.new("TextLabel")
WelcomeText.Size = UDim2.new(1, -20, 0, 120)
WelcomeText.Position = UDim2.new(0, 10, 0, 0)
WelcomeText.BackgroundTransparency = 1
WelcomeText.Text = "🎮 GnomHUB Premium v2.0\n\n✨ Advanced features for Steal A Brainrot\n🔒 Anti-Kick Protection Active\n⚡ Fast & Stable Performance"
WelcomeText.TextColor3 = ColorTheme.Text
WelcomeText.TextSize = 16
WelcomeText.Font = Enum.Font.Gotham
WelcomeText.TextXAlignment = Enum.TextXAlignment.Left
WelcomeText.TextYAlignment = Enum.TextYAlignment.Top
WelcomeText.Parent = MainSection.Content

UIComponents:CreateButton(MainSection.Content, "Load Game Resources", function()
    if LoadGameResources() then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "GnomHUB",
            Text = "Game resources loaded!",
            Duration = 3
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "GnomHUB",
            Text = "Failed to load resources",
            Duration = 3
        })
    end
end)

-- Farm Tab
local FarmSection = UIComponents:CreateSection(FarmTab.Content, "Auto Farming")
local farmActive = false

local AutoFishToggle = UIComponents:CreateToggle(FarmSection.Content, "Auto Fishing", function(state)
    farmActive = state
    if state then
        task.spawn(function()
            while farmActive do
                if CastRemote then
                    pcall(function()
                        CastRemote:FireServer(Vector3.new(0, 0, 0))
                    end)
                end
                task.wait(0.8) -- Slower to avoid detection
                
                for i = 1, 8 do
                    if not farmActive then break end
                    if ClickRemote then
                        pcall(function()
                            ClickRemote:FireServer()
                        end)
                    end
                    task.wait(0.15)
                end
                task.wait(1.5)
            end
        end)
    end
end)

local AutoSellToggle = UIComponents:CreateToggle(FarmSection.Content, "Auto Sell", function(state)
    _G.AutoSell = state
    if state then
        task.spawn(function()
            while _G.AutoSell do
                if SellRemote then
                    pcall(function()
                        SellRemote:FireServer()
                    end)
                end
                task.wait(8) -- Slower to avoid detection
            end
        end)
    end
end)

UIComponents:CreateButton(FarmSection.Content, "Start Farming", function()
    AutoFishToggle.SetState(true)
    AutoSellToggle.SetState(true)
end)

UIComponents:CreateButton(FarmSection.Content, "Stop Farming", function()
    AutoFishToggle.SetState(false)
    AutoSellToggle.SetState(false)
end)

-- Visual Tab
local VisualSection = UIComponents:CreateSection(VisualTab.Content, "Visual Features")
local espActive = false

UIComponents:CreateToggle(VisualSection.Content, "Player ESP", function(state)
    espActive = state
    if state then
        task.spawn(function()
            while espActive do
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local highlight = player.Character:FindFirstChild("GnomHUB_ESP") or Instance.new("Highlight")
                        highlight.Name = "GnomHUB_ESP"
                        highlight.FillColor = ColorTheme.Primary
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.6
                        highlight.OutlineTransparency = 0.3
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.Parent = player.Character
                    end
                end
                task.wait(2) -- Update less frequently
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

UIComponents:CreateToggle(VisualSection.Content, "Show Base Timers", function(state)
    if state then
        -- Simple base timer display
        task.spawn(function()
            while state do
                for _, plot in pairs(workspace:FindFirstChild("Plots") and workspace.Plots:GetChildren() or {}) do
                    local timer = plot:FindFirstChild("RemainingTime", true)
                    if timer then
                        timer.Visible = true
                    end
                end
                task.wait(5)
            end
        end)
    end
end)

-- Player Tab
local PlayerSection = UIComponents:CreateSection(PlayerTab.Content, "Player Modifications")

local SpeedToggle = UIComponents:CreateToggle(PlayerSection.Content, "Speed Boost (x2)", function(state)
    if state then
        local conn = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 32 -- 2x normal speed
            end
        end)
        table.insert(_G.Connections or {}, conn)
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

local JumpToggle = UIComponents:CreateToggle(PlayerSection.Content, "Infinite Jump", function(state)
    if state then
        local conn = UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        table.insert(_G.Connections or {}, conn)
    end
end)

UIComponents:CreateToggle(PlayerSection.Content, "Anti-Trap", function(state)
    if state then
        task.spawn(function()
            while state do
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("TouchTransmitter") and obj.Name == "TouchInterest" then
                        local parent = obj.Parent
                        if parent and string.find(parent.Name:lower(), "trap") then
                            obj:Destroy()
                        end
                    end
                end
                task.wait(3)
            end
        end)
    end
end)

-- Misc Tab
local MiscSection = UIComponents:CreateSection(MiscTab.Content, "Utilities")

UIComponents:CreateButton(MiscSection.Content, "No Clip", function()
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

UIComponents:CreateButton(MiscSection.Content, "Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

UIComponents:CreateButton(MiscSection.Content, "Copy Job ID", function()
    if setclipboard then
        setclipboard(game.JobId)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "GnomHUB",
            Text = "Job ID copied!",
            Duration = 3
        })
    end
end)

-- Settings Section
local SettingsSection = UIComponents:CreateSection(MiscTab.Content, "Settings")

UIComponents:CreateToggle(SettingsSection.Content, "Hide UI", function(state)
    MainFrame.Visible = not state
end)

UIComponents:CreateButton(SettingsSection.Content, "Unload Script", function()
    -- Clean up
    for _, conn in pairs(_G.Connections or {}) do
        pcall(function() conn:Disconnect() end)
    end
    
    -- Remove ESP
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("GnomHUB_ESP") then
            player.Character.GnomHUB_ESP:Destroy()
        end
    end
    
    -- Restore player settings
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
    
    -- Destroy UI
    ScreenGui:Destroy()
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "GnomHUB",
        Text = "Script unloaded!",
        Duration = 3
    })
end)

-- Button click handlers
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    ContentFrame.Visible = not ContentFrame.Visible
    MinimizeButton.Text = ContentFrame.Visible and "−" or "+"
end)

-- Hover effects for buttons
local function SetupButtonHover(button)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        }):Play()
    end)
end

SetupButtonHover(CloseButton)
SetupButtonHover(MinimizeButton)

-- Add buttons to main frame
CloseButton.Parent = ContentFrame
MinimizeButton.Parent = ContentFrame

-- Draggable UI
local dragging = false
local dragInput, dragStart, startPos

local function UpdateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
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
        UpdateInput(input)
    end
end)

-- Initial animations
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

task.wait(0.5)

-- Open animation
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 600, 0, 500),
    Position = UDim2.new(0.5, -300, 0.5, -250)
}):Play()

-- Activate main tab
task.wait(1)
UIComponents:SwitchTab("Main")

-- Initial notification
task.wait(2)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "GnomHUB Premium",
    Text = "Loaded successfully!\nAnti-Kick protection active.",
    Duration = 5,
    Icon = "rbxassetid://3926305904"
})

print("GnomHUB Premium loaded successfully!")
warn("Anti-Kick protection is active")
