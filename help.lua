-- [[ SHTORM ABSOLUTE | ВЕРСИЯ: 2.0 ]] --
-- КОРРЕКЦИЯ СИСТЕМЫ: Протокол исполнения — продолжать. (Нет времени на базары.)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚡ SHTORM | PROJECT EGIDA-ABSOLUT",
   LoadingTitle = "АКТИВАЦИЯ ТЕРМИНАЛА G-00...",
   LoadingSubtitle = "by usergemoroi",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ShtormConfig",
      FileName = "MainData"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },
   KeySystem = false -- Убрали лишние сопли с ключами
})

-- [[ ВКЛАДКА: ГЛАВНЫЙ ЦЕХ ]] --
local MainTab = Window:CreateTab("💀 Фарм-Цех", 4483345998)
local FarmSection = MainTab:CreateSection("Грязная Работа")

MainTab:CreateToggle({
   Name = "Агрессивный Фарм Мозгов (Brainrot)",
   CurrentValue = false,
   Flag = "AutoFarm",
   Callback = function(Value)
      _G.AutoFarm = Value
      task.spawn(function()
         while _G.AutoFarm do
            -- Массовый запрос к серверу на сбор
            for i = 1, 5 do
                game:GetService("ReplicatedStorage").Events:FindFirstChild("CollectBrain"):FireServer()
            end
            task.wait(0.1)
         end
      end)
   end,
})

MainTab:CreateToggle({
   Name = "Бешеный Кликер (V-User)",
   CurrentValue = false,
   Flag = "AutoClick",
   Callback = function(Value)
      _G.AutoClick = Value
      task.spawn(function()
         while _G.AutoClick do
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(0,0))
            task.wait()
         end
      end)
   end,
})

MainTab:CreateButton({
   Name = "Собрать всё в радиусе (Магнит)",
   Callback = function()
      for _, v in pairs(game.Workspace:GetChildren()) do
         if v:IsA("Part") and v:FindFirstChild("TouchInterest") then
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v, 0)
            task.wait()
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v, 1)
         end
      end
   end,
})

-- [[ ВКЛАДКА: СИЛОВОЙ БЛОК ]] --
local CombatTab = Window:CreateTab("⚔️ Беспредел", 4483345998)
local MovementSection = CombatTab:CreateSection("Физические Данные")

CombatTab:CreateSlider({
   Name = "Скорость (Педаль в пол)",
   Range = {16, 500},
   Increment = 1,
   Suffix = " км/ч",
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

CombatTab:CreateSlider({
   Name = "Высота Прыжка (В космос)",
   Range = {50, 1000},
   Increment = 1,
   Suffix = " m",
   CurrentValue = 50,
   Flag = "JumpPower",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.UseJumpPower = true
      game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
   end,
})

CombatTab:CreateToggle({
   Name = "Noclip (Сквозь стены)",
   CurrentValue = false,
   Flag = "Noclip",
   Callback = function(Value)
      _G.Noclip = Value
      game:GetService("RunService").Stepped:Connect(function()
         if _G.Noclip then
            for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
               if part:IsA("BasePart") then
                  part.CanCollide = false
               end
            end
         end
      end)
   end,
})

-- [[ ВКЛАДКА: НАВОДКА ]] --
local VisualsTab = Window:CreateTab("👁️ Шмон", 4483345998)

VisualsTab:CreateToggle({
   Name = "Подсветить Лохов (ESP)",
   CurrentValue = false,
   Flag = "EspToggle",
   Callback = function(Value)
      _G.ESP = Value
      while _G.ESP do
         for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer and plr.Character then
               if not plr.Character:FindFirstChild("SHTORM_ESP") then
                  local box = Instance.new("Highlight")
                  box.Name = "SHTORM_ESP"
                  box.Parent = plr.Character
                  box.FillColor = Color3.fromRGB(0, 0, 0) -- Черная заливка
                  box.OutlineColor = Color3.fromRGB(255, 0, 0) -- Красная обводка
                  box.FillTransparency = 0.5
               end
            end
         end
         task.wait(2)
      end
   end,
})

-- [[ ВКЛАДКА: МАГАЗИН ]] --
local ShopTab = Window:CreateTab("💰 Общак", 4483345998)

ShopTab:CreateButton({
   Name = "Авто-Покупка Силы (Max)",
   Callback = function()
      Rayfield:Notify({Title = "SHTORM", Content = "Пытаемся скупить весь рынок...", Duration = 3})
      -- Сюда добавь ивент магазина из Remote Events
   end,
})

Rayfield:LoadConfiguration()
