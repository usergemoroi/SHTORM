-- [[ PROJECT: SHTORM | MASTER V11 (FIXED) ]] --
-- [[ МЕТОД: CLEAN C-FRAME LOOP + ANTI-RUBBERBAND ]] --

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Theme = {
    SchemeColor = Color3.fromRGB(255, 255, 255), 
    Background = Color3.fromRGB(20, 20, 20),
    Header = Color3.fromRGB(0, 0, 0),
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(30, 30, 30)
}

local Window = Library.CreateLib("SHTORM | MASTER V11 (Fix)", Theme)
local Main = Window:NewTab("Master")
local Section = Main:NewSection("Управление Полетом")

-- Переменные для хранения состояния (чтобы не было наслоения циклов)
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local NoclipConnection = nil
local CurrentBV = nil
local CurrentBG = nil -- BodyGyro для стабилизации вращения

_G.MasterSpeed = 1 -- Стандартная скорость

Section:NewToggle("Активировать Master-Noclip", "Без откидывания назад", function(state)
    local char = Players.LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")

    if not char or not hrp or not hum then return end

    if state then
        -- 1. Очистка перед запуском (на случай багов)
        if CurrentBV then CurrentBV:Destroy() end
        if CurrentBG then CurrentBG:Destroy() end
        if NoclipConnection then NoclipConnection:Disconnect() end

        -- 2. Создаем физические стабилизаторы
        CurrentBV = Instance.new("BodyVelocity")
        CurrentBV.Velocity = Vector3.new(0, 0, 0)
        CurrentBV.MaxForce = Vector3.new(9e9, 9e9, 9e9) -- Блокируем ВСЮ физику игры
        CurrentBV.P = 1000
        CurrentBV.Parent = hrp

        CurrentBG = Instance.new("BodyGyro") -- Чтобы персонажа не крутило
        CurrentBG.P = 9e9
        CurrentBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        CurrentBG.CFrame = hrp.CFrame
        CurrentBG.Parent = hrp

        -- Переводим гуманоид в состояние полета (отключает гравитацию движка)
        hum.PlatformStand = true

        -- 3. Запускаем ЕДИНЫЙ цикл
        NoclipConnection = RunService.RenderStepped:Connect(function()
            if not char or not hrp or not hum then 
                if NoclipConnection then NoclipConnection:Disconnect() end
                return 
            end

            -- А. ПРОХОД СКВОЗЬ СТЕНЫ (Только нужные части)
            hrp.CanCollide = false
            if char:FindFirstChild("UpperTorso") then char.UpperTorso.CanCollide = false end
            if char:FindFirstChild("LowerTorso") then char.LowerTorso.CanCollide = false end
            if char:FindFirstChild("Torso") then char.Torso.CanCollide = false end
            if char:FindFirstChild("Head") then char.Head.CanCollide = false end

            -- Б. ДВИЖЕНИЕ (CFRAME)
            -- Используем LookVector камеры для движения вперед/назад, если нужно
            -- Но оставим управление WASD как просили
            
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                -- Нормализуем и умножаем на скорость
                local newPos = hrp.CFrame + (moveDir * (_G.MasterSpeed or 0.5))
                hrp.CFrame = newPos
                
                -- Поворачиваем персонажа туда, куда он идет
                CurrentBG.CFrame = CFrame.new(hrp.Position, hrp.Position + moveDir)
            else
                -- Если не жмем кнопки - фиксируем вращение
                CurrentBG.CFrame = hrp.CFrame
            end

            -- В. АНТИ-ОТКАТ (Сброс скоростей)
            hrp.Velocity = Vector3.new(0, 0, 0)
            hrp.RotVelocity = Vector3.new(0, 0, 0)
        end)

    else
        -- ВЫКЛЮЧЕНИЕ
        if NoclipConnection then 
            NoclipConnection:Disconnect() 
            NoclipConnection = nil
        end
        
        if CurrentBV then CurrentBV:Destroy() CurrentBV = nil end
        if CurrentBG then CurrentBG:Destroy() CurrentBG = nil end
        
        -- Возвращаем физику
        if hum then 
            hum.PlatformStand = false 
            hum:ChangeState(Enum.HumanoidStateType.GettingUp) -- Чтобы не лежал на полу
        end
    end
end)

Section:NewSlider("Скорость (Master)", "Регулировка скорости полета", 50, 5, function(v)
    _G.MasterSpeed = v / 10 -- Делим на 10, чтобы слайдер 50 давал скорость 5
end)

Section:NewButton("Emergency Reset", "Если застрял", function()
    local char = Players.LocalPlayer.Character
    if char then
        char:BreakJoints() -- Ресет персонажа
    end
end)

Section:NewKeybind("Меню", "Скрыть/Показать", Enum.KeyCode.RightControl, function()
    Library:ToggleGui()
end)
