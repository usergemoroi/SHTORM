local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "SHTORM | Trench Combat",
   LoadingTitle = "Загрузка SHTORM...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ShtormSettings",
      FileName = "TrenchConfig"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true 
   },
   KeySystem = false, 
})

-- == ПЕРЕМЕННЫЕ ==
local AimEnabled = false
local TeamCheck = true
local EspEnabled = false
local SpeedVal = 16

local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- == ФУНКЦИИ ==

-- Проверка на команду (чтобы не убивать своих)
local function IsEnemy(player)
    if not TeamCheck then return true end
    if player.Team ~= LocalPlayer.Team then return true end
    return false
end

-- Функция поиска ближайшего врага для Аима
local function GetClosestTarget()
    local closestPlayer = nil
    local shortestDistance = 9999

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and IsEnemy(v) then
            local pos = Camera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(LocalPlayer:GetMouse().X, LocalPlayer:GetMouse().Y)).Magnitude
            
            -- Проверяем, виден ли он на экране
            if magnitude < 500 then -- Радиус работы (FOV)
                if magnitude < shortestDistance then
                    shortestDistance = magnitude
                    closestPlayer = v
                end
            end
        end
    end
    return closestPlayer
end

-- == ВКЛАДКИ ==

local CombatTab = Window:CreateTab("Бой (Combat)", 4483362458)
local VisualsTab = Window:CreateTab("ВХ (Visuals)", 4483345998)
local PlayerTab = Window:CreateTab("Игрок (Player)", 4483362458)

-- == НАСТРОЙКИ БОЯ ==

CombatTab:CreateSection("Aimbot")

CombatTab:CreateToggle({
   Name = "Включить Aimbot",
   CurrentValue = false,
   Flag = "AimToggle", 
   Callback = function(Value)
      AimEnabled = Value
   end,
})

CombatTab:CreateToggle({
   Name = "Team Check (Не бить своих)",
   CurrentValue = true,
   Flag = "TeamCheck",
   Callback = function(Value)
      TeamCheck = Value
   end,
})

CombatTab:CreateLabel("Аимбот наводится жестко на голову.")

-- == НАСТРОЙКИ ВХ ==

VisualsTab:CreateSection("WallHack")

VisualsTab:CreateToggle({
   Name = "Chams (Видеть сквозь стены)",
   CurrentValue = false,
   Flag = "EspToggle",
   Callback = function(Value)
      EspEnabled = Value
      if Value then
          -- Включаем цикл подсветки
          task.spawn(function()
              while EspEnabled do
                  for _, v in pairs(Players:GetPlayers()) do
                      if v ~= LocalPlayer and v.Character then
                          -- Если это враг и у него нет подсветки
                          if IsEnemy(v) and not v.Character:FindFirstChild("ShtormGlow") then
                              local h = Instance.new("Highlight")
                              h.Name = "ShtormGlow"
                              h.Adornee = v.Character
                              h.Parent = v.Character
                              h.FillColor = Color3.fromRGB(255, 0, 0) -- Красный
                              h.OutlineColor = Color3.fromRGB(255, 255, 255) -- Белая обводка
                              h.FillTransparency = 0.5
                              h.OutlineTransparency = 0
                              h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- ГЛАВНОЕ: ВИДНО СКВОЗЬ СТЕНЫ
                          end
                      elseif v == LocalPlayer or (not IsEnemy(v)) then
                          -- Убираем подсветку со своих
                          if v.Character and v.Character:FindFirstChild("ShtormGlow") then
                              v.Character.ShtormGlow:Destroy()
                          end
                      end
                  end
                  task.wait(1)
              end
          end)
      else
          -- Удаляем все при выключении
          for _, v in pairs(Players:GetPlayers()) do
              if v.Character and v.Character:FindFirstChild("ShtormGlow") then
                  v.Character.ShtormGlow:Destroy()
              end
          end
      end
   end,
})

-- == НАСТРОЙКИ ИГРОКА ==

PlayerTab:CreateSection("Скорость")

PlayerTab:CreateSlider({
   Name = "Скорость бега",
   Range = {16, 100},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SpeedSlider", 
   Callback = function(Value)
      SpeedVal = Value
   end,
})

-- == ЛОГИКА ==

-- Аимбот Логика (RenderStepped для плавности и скорости)
RunService.RenderStepped:Connect(function()
    if AimEnabled then
        local target = GetClosestTarget()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

-- Удержание скорости (Loop)
task.spawn(function()
    while task.wait(0.5) do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if LocalPlayer.Character.Humanoid.WalkSpeed ~= SpeedVal and SpeedVal > 16 then
                LocalPlayer.Character.Humanoid.WalkSpeed = SpeedVal
            end
        end
    end
end)

Rayfield:LoadConfiguration()
