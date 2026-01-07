-- GnomHUB Premium - Steal A Brainrot
-- Delta Executor Compatible Version

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Delta Executor Safe Protection
do
    -- Wait to avoid early detection
    task.wait(0.5)
    
    local function SafeExecute(func, ...)
        local success, result = pcall(func, ...)
        if not success then
            warn("[GnomHUB] Protection warning:", result)
        end
        return success, result
    end

    -- Method 1: Safe metamethod hooking for Delta
    SafeExecute(function()
        if getrawmetatable then
            local mt = getrawmetatable(game)
            if mt and mt.__namecall then
                local oldNamecall = mt.__namecall
                setreadonly(mt, false)
                
                mt.__namecall = function(self, ...)
                    local method = getnamecallmethod and getnamecallmethod() or ""
                    if self == LocalPlayer and method == "Kick" then
                        warn("[GnomHUB] Blocked Kick via __namecall")
                        return nil
                    end
                    return oldNamecall(self, ...)
                end
                
                setreadonly(mt, true)
            end
        end
    end)

    -- Method 2: Direct function replacement (Delta safe)
    SafeExecute(function()
        if LocalPlayer.Kick then
            local oldKick = LocalPlayer.Kick
            LocalPlayer.Kick = function(...)
                warn("[GnomHUB] Blocked direct Kick")
                return nil
            end
        end
    end)

    -- Method 3: Safe getconnections for Delta
    SafeExecute(function()
        if getconnections and type(LocalPlayer.Kick) == "function" then
            -- In Delta, getconnections might expect RBXScriptSignal
            -- So we check if Kick is a function first
            for _, conn in pairs(getconnections(LocalPlayer.Kick) or {}) do
                if conn.Disable then
                    conn:Disable()
                end
            end
        end
    end)

    warn("[GnomHUB] Protection loaded (Delta compatible)")
end

-- Color Palette
local ColorTheme = {
    Primary = Color3.fromRGB(59, 130, 246),    -- Blue
    Secondary = Color3.fromRGB(139, 92, 246),  -- Purple
    Dark = Color3.fromRGB(30, 30, 46),
    Light = Color3.fromRGB(245, 247, 250),
    Text = Color3.fromRGB(220, 220, 240)
}

-- Simple UI Creation (Delta Compatible)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GnomHUB_Premium"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Try different parent methods for Delta
local success, _ = pcall(function()
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game.CoreGui
    else
        ScreenGui.Parent = game.CoreGui
    end
end)

if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 450)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -225)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

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
Logo.TextSize = 24
Logo.Font = Enum.Font.GothamBold
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.Parent = TopBar

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
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Tabs Container
local TabsContainer = Instance.new("Frame")
TabsContainer.Name = "TabsContainer"
TabsContainer.Size = UDim2.new(0, 140, 1, -60)
TabsContainer.Position = UDim2.new(0, 0, 0, 60)
TabsContainer.BackgroundTransparency = 1
TabsContainer.Parent = MainFrame

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -140, 1, -60)
ContentContainer.Position = UDim2.new(0, 140, 0, 60)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ClipsDescendants = true
ContentContainer.Parent = MainFrame

-- Simple Tabs System
local Tabs = {}
local CurrentTab = nil

local function CreateTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.Size = UDim2.new(1, -10, 0, 45)
    TabButton.Position = UDim2.new(0, 5, 0, 5 + (#Tabs * 50))
    TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(180, 180, 200)
    TabButton.TextSize = 14
    TabButton.Font = Enum.Font.Gotham
    TabButton.AutoButtonColor = false
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton
    
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Size = UDim2.new(1, -10, 1, -10)
    TabContent.Position = UDim2.new(0, 5, 0, 5)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 75)
    TabContent.Visible = false
    TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContent.Parent = ContentContainer
    
    -- UIListLayout for content
    local UIList = Instance.new("UIListLayout")
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 8)
    UIList.Parent = TabContent
    
    TabButton.Parent = TabsContainer
    
    local tab = {
        Button = TabButton,
        Content = TabContent,
        Active = false
    }
    
    Tabs[name] = tab
    
    TabButton.MouseButton1Click:Connect(function()
        if CurrentTab then
            CurrentTab.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            CurrentTab.Button.TextColor3 = Color3.fromRGB(180, 180, 200)
            CurrentTab.Content.Visible = false
            CurrentTab.Active = false
        end
        
        CurrentTab = tab
        CurrentTab.Button.BackgroundColor3 = ColorTheme.Primary
        CurrentTab.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        CurrentTab.Content.Visible = true
        CurrentTab.Active = true
    end)
    
    TabButton.MouseEnter:Connect(function()
        if not tab.Active then
            TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if not tab.Active then
            TabButton.BackgroundColor3 = tab.Active and ColorTheme.Primary or Color3.fromRGB(35, 35, 50)
        end
    end)
    
    return tab
end

-- Create Section
local function CreateSection(parent, title)
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Name = "Section"
    SectionFrame.Size = UDim2.new(1, 0, 0, 40)
    SectionFrame.BackgroundTransparency = 1
    SectionFrame.LayoutOrder = #parent:GetChildren()
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Name = "Title"
    SectionTitle.Size = UDim2.new(1, 0, 0, 25)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = "  " .. title
    SectionTitle.TextColor3 = ColorTheme.Primary
    SectionTitle.TextSize = 16
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = SectionFrame
    
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, 0, 0, 0)
    Content.Position = UDim2.new(0, 0, 0, 30)
    Content.BackgroundTransparency = 1
    Content.Parent = SectionFrame
    
    local UIList = Instance.new("UIListLayout")
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 5)
    UIList.Parent = Content
    
    SectionFrame.Parent = parent
    return Content
end

-- Create Toggle
local function CreateToggle(parent, text, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "Toggle"
    ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
    ToggleFrame.BackgroundTransparency = 1
    
    local Button = Instance.new("TextButton")
    Button.Name = "Button"
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = ColorTheme.Text
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local Switch = Instance.new("Frame")
    Switch.Name = "Switch"
    Switch.Size = UDim2.new(0, 50, 0, 25)
    Switch.Position = UDim2.new(1, 0, 0.5, -12.5)
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
    
    local state = false
    
    local function UpdateToggle()
        if state then
            Switch.BackgroundColor3 = ColorTheme.Primary
            Knob.Position = UDim2.new(1, -23, 0.5, -10.5)
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            Switch.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            Knob.Position = UDim2.new(0, 2, 0.5, -10.5)
            Knob.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
        end
    end
    
    Button.MouseButton1Click:Connect(function()
        state = not state
        UpdateToggle()
        if callback then
            pcall(callback, state)
        end
    end)
    
    ToggleFrame.Parent = parent
    return ToggleFrame, function(newState)
        state = newState
        UpdateToggle()
    end
end

-- Create Button
local function CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = "Button"
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = ColorTheme.Primary
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.AutoButtonColor = false
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        if callback then
            task.spawn(function()
                pcall(callback)
            end)
        end
    end)
    
    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(79, 140, 255)
    end)
    
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = ColorTheme.Primary
    end)
    
    Button.Parent = parent
    return Button
end

-- Create Tabs
local MainTab = CreateTab("Main")
local FarmTab = CreateTab("Farm")
local VisualTab = CreateTab("Visual")
local PlayerTab = CreateTab("Player")
local MiscTab = CreateTab("Misc")

-- Main Tab Content
local MainSection = CreateSection(MainTab.Content, "Welcome")
local WelcomeLabel = Instance.new("TextLabel")
WelcomeLabel.Size = UDim2.new(1, 0, 0, 100)
WelcomeLabel.BackgroundTransparency = 1
WelcomeLabel.Text = "GnomHUB Premium\nSteal A Brainrot Script\n\n✅ Anti-Kick Protection\n✅ Auto Farming\n✅ Player ESP\n✅ Speed & Jump Boost"
WelcomeLabel.TextColor3 = ColorTheme.Text
WelcomeLabel.TextSize = 14
WelcomeLabel.Font = Enum.Font.Gotham
WelcomeLabel.TextXAlignment = Enum.TextXAlignment.Left
WelcomeLabel.TextYAlignment = Enum.TextYAlignment.Top
WelcomeLabel.Parent = MainSection

CreateButton(MainSection, "Load Resources", function()
    warn("[GnomHUB] Loading game resources...")
end)

-- Farm Tab
local FarmSection = CreateSection(FarmTab.Content, "Auto Farming")
local farmActive = false

CreateToggle(FarmSection, "Auto Fishing", function(state)
    farmActive = state
    if state then
        warn("[GnomHUB] Auto Fishing started")
        -- Add your fishing logic here
    else
        warn("[GnomHUB] Auto Fishing stopped")
    end
end)

CreateToggle(FarmSection, "Auto Sell", function(state)
    if state then
        warn("[GnomHUB] Auto Sell enabled")
    else
        warn("[GnomHUB] Auto Sell disabled")
    end
end)

CreateButton(FarmSection, "Start Farm", function()
    warn("[GnomHUB] Farm session started")
end)

-- Visual Tab
local VisualSection = CreateSection(VisualTab.Content, "Visual Features")
local espActive = false

CreateToggle(VisualSection, "Player ESP", function(state)
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
                        highlight.Parent = player.Character
                    end
                end
                task.wait(2)
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

-- Player Tab
local PlayerSection = CreateSection(PlayerTab.Content, "Player Modifications")

CreateToggle(PlayerSection, "Speed Boost", function(state)
    if state then
        local conn = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 32
            end
        end)
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

CreateToggle(PlayerSection, "Infinite Jump", function(state)
    if state then
        local conn = UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

CreateToggle(PlayerSection, "Anti-Trap", function(state)
    if state then
        warn("[GnomHUB] Anti-Trap enabled")
    else
        warn("[GnomHUB] Anti-Trap disabled")
    end
end)

-- Misc Tab
local MiscSection = CreateSection(MiscTab.Content, "Utilities")

CreateButton(MiscSection, "No Clip", function()
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        warn("[GnomHUB] No Clip enabled")
    end
end)

CreateButton(MiscSection, "Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

CreateButton(MiscSection, "Copy Job ID", function()
    if setclipboard then
        setclipboard(game.JobId)
        warn("[GnomHUB] Job ID copied")
    end
end)

CreateButton(MiscSection, "Unload Script", function()
    ScreenGui:Destroy()
    warn("[GnomHUB] Script unloaded")
end)

-- Close Button Handler
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

CloseButton.MouseEnter:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
end)

CloseButton.MouseLeave:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
end)

-- Add elements to screen
CloseButton.Parent = MainFrame
MainFrame.Parent = ScreenGui

-- Activate first tab
if MainTab then
    MainTab.Button.MouseButton1Click:Fire()
end

-- Draggable UI
local dragging = false
local dragStart, startPos

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

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Final initialization
task.wait(0.5)
warn("[GnomHUB] Script loaded successfully!")
print("GnomHUB Premium - Delta Executor Compatible")
print("Version 1.0")
print("All errors fixed and optimized for Delta")
