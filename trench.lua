local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Trench Combat | Delta Edition",
   LoadingTitle = "Загрузка скрипта...",
   LoadingSubtitle = "by Gemini AI",
   ConfigurationSaving = { Enabled = true, Folder = "TrenchCombatConfig" }
})

-- Переменные для функций
local AimSettings = {
    Enabled = false,
    TeamCheck = true,
    Smoothness = 0.5,
    Radius = 200
}

local ESPEnabled = false
local WalkSpeed = 16

-- Вкладка Бой (Combat)
local CombatTab = Window:CreateTab("Бой (Combat)", 4483362458)

CombatTab:CreateToggle({
   Name = "Aimbot + BulletTrack",
   CurrentValue = false,
   Callback = function(Value)
      AimSettings.Enabled = Value
   end,
})

CombatTab:CreateSlider({
   Name = "Радиус захвата (FOV)",
   Min = 50,
   Max = 800,
   Default = 200,
   Color = Color3.fromRGB(255, 255, 255),
   Increment = 10,
   Callback = function(Value)
      AimSettings.Radius = Value
   end,
})

-- Вкладка Визуалы (ESP)
local VisualsTab = Window:CreateTab("Визуалы", 4483345998)

VisualsTab:CreateToggle({
   Name = "WallHack (ESP Boxes)",
   CurrentValue = false,
   Callback = function(Value)
      ESPEnabled = Value
      if Value then
          -- Цикл ESP
          task.spawn(function()
              while ESPEnabled do
                  for _, player in pairs(game.Players:GetPlayers()) do
                      if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                          if not player.Character:FindFirstChild("Highlight") then
                              local highlight = Instance.new("Highlight", player.Character)
                              highlight.FillColor = Color3.fromRGB(255, 0, 0)
                              highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                          end
                      end
                  end
                  task.wait(1)
              end
          end)
      else
          for _, player in pairs(game.Players:GetPlayers()) do
              if player.Character and player.Character:FindFirstChild("Highlight") then
                  player.Character.Highlight:Destroy()
              end
          end
      end
   end,
})

-- Вкладка Игрок
local PlayerTab = Window:CreateTab("Игрок", 4483362458)

PlayerTab:CreateSlider({
   Name = "Speed Hack (Скорость)",
   Min = 16,
   Max = 100,
   Default = 16,
   Increment = 1,
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

-- Логика Аимбота (Aimbot Logic)
game:GetService("RunService").RenderStepped:Connect(function()
    if AimSettings.Enabled then
        local target = nil
        local shortestDistance = AimSettings.Radius

        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                local pos, onScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(game.Players.LocalPlayer:GetMouse().X, game.Players.LocalPlayer:GetMouse().Y)).Magnitude
                    if distance < shortestDistance then
                        target = player.Character.HumanoidRootPart
                        shortestDistance = distance
                    end
                end
            end
        end

        if target then
            local cam = game.Workspace.CurrentCamera
            cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position)
        end
    end
end)

Rayfield:Notify({Title = "Скрипт загружен!", Content = "Приятной игры в Trench Combat", Duration = 5})
