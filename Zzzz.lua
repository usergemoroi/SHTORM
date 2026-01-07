--[[
    GnomHub | Premium System
    Features: Ultra Lagger, No-Slow Noclip, CFrame Speed, Akali Notifications
]]

-- Загрузка системы уведомлений из твоего файла ted.lua
local AkaliNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynasty/main/AkaliNotif.lua"))()
local Notify = AkaliNotif.Notify

-- Загрузка библиотеки интерфейса
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("GnomHub | PRIVATE", "Midnight")

Notify({
    Title = "GnomHub",
    Description = "Скрипт загружен! Все системы GnomHub активны.",
    Duration = 5
})

-- Вкладка Разрушения (Лаггер)
local Destr = Window:NewTab("Destruction")
local LSection = Destr:NewSection("Server Overload")

LSection:NewButton("PACKET LAG: CRASH", "Нажми несколько раз для жесткого лага", function()
    Notify({Title = "GnomHub", Description = "Отправка тяжелых пакетов...", Duration = 2})
    for i = 1, 2500 do
        task.spawn(function()
            -- Метод из der.txt: спам символами + звуки
            local chat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
            if chat then
                chat.SayMessageRequest:FireServer(string.rep("▓", 250), "All")
            end
            game.Players.LocalPlayer.Character.Humanoid:ChangeState(11)
        end)
    end
end)

LSection:NewToggle("Lag Aura (Loop)", "Постоянно лагать сервер", function(state)
    _G.GnomLag = state
    if state then
        Notify({Title = "GnomHub", Description = "Аура лага включена!", Duration = 3})
        task.spawn(function()
            while _G.GnomLag do
                for i = 1, 100 do
                    game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                end
                task.wait(0.01)
            end
        end)
    end
end)

-- Вкладка Движения (Bypasses)
local Move = Window:NewTab("Movement")
local MSection = Move:NewSection("Gnom Movement")

MSection:NewToggle("Gnom Noclip (FLY)", "Сквозь стены без замедления", function(state)
    _G.Noclip = state
    if state then
        Notify({Title = "GnomHub", Description = "Noclip: ВКЛ (Режим призрака)", Duration = 2})
    end
    game:GetService("RunService").Stepped:Connect(function()
        if _G.Noclip and game.Players.LocalPlayer.Character then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
            -- Фикс замедления: даем персонажу микро-левитацию вместо полной остановки
            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 1.1, 0)
        end
    end)
end)

MSection:NewSlider("CFrame Speed", "Скорость без киков", 1000, 16, function(s)
    _G.Speed = s
    task.spawn(function()
        while _G.Speed > 16 do
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hum = char.Humanoid
                if hum.MoveDirection.Magnitude > 0 then
                    char:TranslateBy(hum.MoveDirection * (s/150))
                end
            end
            task.wait()
        end
    end)
end)

MSection:NewSlider("Gnom Jump", "Высота прыжка", 500, 50, function(s)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = s
    game.Players.LocalPlayer.Character.Humanoid.UseJumpPower = true
end)

-- Вкладка Визуала
local Vis = Window:NewTab("Visuals")
local VSection = Vis:NewSection("Vision & VFX")

VSection:NewToggle("Player ESP", "ВХ на игроков (Box)", function(state)
    _G.ESP = state
    if state then
        Notify({Title = "GnomHub", Description = "ESP Активировано", Duration = 2})
    end
    while _G.ESP do
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character then
                if not p.Character:FindFirstChild("GnomHigh") then
                    local h = Instance.new("Highlight", p.Character)
                    h.Name = "GnomHigh"
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
            end
        end
        task.wait(1)
    end
end)

VSection:NewButton("God Appearance (Rainbow)", "Красивые визуальные эффекты", function()
    local p = game.Players.LocalPlayer.Character
    for _, part in pairs(p:GetChildren()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.ForceField
            part.Color = Color3.fromRGB(0, 255, 255)
            Instance.new("Sparkles", part).SparkleColor = Color3.fromRGB(0, 255, 255)
        end
    end
    Notify({Title = "GnomHub", Description = "Визуальные эффекты применены!", Duration = 3})
end)
