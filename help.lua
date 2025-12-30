-- [[ SHTORM SCRIPT: BRAINROT EDITION ]] --
-- Терминал G-00 активирован. Протокол исполнения — продолжать.

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "⚡ SHTORM | PROJECT EGIDA", HidePremium = true, SaveConfig = true, ConfigFolder = "ShtormConfig", IntroText = "SHTORM АКТИВИРОВАН"})

-- ГЛАВНАЯ ВКЛАДКА (ОСНОВНОЕ)
local MainTab = Window:MakeTab({
	Name = "Главная",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

MainTab:AddLabel("Статус: Маза тянется жёстко")

-- ФУНКЦИИ ФАРМА
MainTab:AddToggle({
	Name = "Авто-фарм Brainrot",
	Default = false,
	Callback = function(Value)
		_G.AutoFarm = Value
		while _G.AutoFarm do
			-- Логика сбора валюты/мозгов
			game:GetService("ReplicatedStorage").Events.CollectBrain:FireServer()
			task.wait(0.1)
		end
	end    
})

MainTab:AddToggle({
	Name = "Авто-клик (Удар по почкам)",
	Default = false,
	Callback = function(Value)
		_G.AutoClick = Value
		spawn(function()
			while _G.AutoClick do
				game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
				task.wait(0.01)
			end
		end)
	end
})

-- ВКЛАДКА ПЕРСОНАЖА
local PlayerTab = Window:MakeTab({
	Name = "Игрок",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

PlayerTab:AddSlider({
	Name = "Скорость бега (Форсаж)",
	Min = 16,
	Max = 300,
	Default = 16,
	Color = Color3.fromRGB(0,0,0),
	Increment = 1,
	ValueName = "Скорость",
	Callback = function(Value)
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
	end    
})

PlayerTab:AddButton({
	Name = "Высокий прыжок (В облака)",
	Callback = function()
      game.Players.LocalPlayer.Character.Humanoid.JumpPower = 100
  	end    
})

-- ВКЛАДКА ВИЗУАЛОВ (ESP)
local VisualTab = Window:MakeTab({
	Name = "Визуалы",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

VisualTab:AddButton({
	Name = "Подсветить терпил (ESP)",
	Callback = function()
		for i, v in pairs(game.Players:GetPlayers()) do
			if v ~= game.Players.LocalPlayer and v.Character then
				local Highlight = Instance.new("Highlight")
				Highlight.Parent = v.Character
				Highlight.FillColor = Color3.fromRGB(255, 0, 0)
				Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
			end
		end
	end
})

-- ЗАВЕРШЕНИЕ
OrionLib:Init()
