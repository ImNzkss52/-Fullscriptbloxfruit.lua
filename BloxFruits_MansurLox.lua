-- Blox Fruits Full Script для Delta Executor
-- by @yourname (если хочешь вписать)
-- Открытие меню: RightShift

-- АНТИ-AFK
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
	vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	wait(1)
	vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- ПЕРЕМЕННЫЕ
local plr = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")

local autofarm = false
local autofruit = false
local esp = false

-- GUI
local gui = Instance.new("ScreenGui", plr.PlayerGui)
gui.Name = "BloxFruitsGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0.5, -150, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
frame.Visible = true
frame.Active = true
frame.Draggable = true

local UICorner = Instance.new("UICorner", frame)
UICorner.CornerRadius = UDim.new(0, 12)

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 10)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder

local title = Instance.new("TextLabel", frame)
title.Text = "Мансур лох"
title.Size = UDim2.new(1, -20, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 0, 0)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22

-- ФУНКЦИЯ СОЗДАНИЯ КНОПОК
function createToggle(name, default, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextColor3 = Color3.fromRGB(0, 0, 0)
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 18
	btn.BorderColor3 = Color3.fromRGB(30, 30, 30)
	btn.BorderSizePixel = 2

	local toggled = default
	btn.Text = name .. ": " .. (toggled and "ON" or "OFF")
	callback(toggled)

	btn.MouseButton1Click:Connect(function()
		toggled = not toggled
		btn.Text = name .. ": " .. (toggled and "ON" or "OFF")
		callback(toggled)
	end)
end

-- ФУНКЦИИ

-- Автофарм
createToggle("Auto Farm", false, function(state)
	autofarm = state
	if state then
		spawn(function()
			while autofarm do
				wait(1)
				for _,enemy in pairs(workspace.Enemies:GetChildren()) do
					if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
						plr.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
						repeat
							wait(0.1)
							if plr.Character:FindFirstChildOfClass("Tool") then
								plr.Character:FindFirstChildOfClass("Tool"):Activate()
							end
						until enemy.Humanoid.Health <= 0 or not autofarm
					end
				end
			end
		end)
	end
end)

-- Автосбор фруктов
createToggle("Auto Fruit Grab", false, function(state)
	autofruit = state
	if state then
		spawn(function()
			while autofruit do
				wait(5)
				for _,v in pairs(game:GetService("Workspace"):GetDescendants()) do
					if v:IsA("Tool") and string.find(v.Name, "Fruit") then
						plr.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
						wait(1)
						firetouchinterest(plr.Character.HumanoidRootPart, v.Handle, 0)
						firetouchinterest(plr.Character.HumanoidRootPart, v.Handle, 1)
					end
				end
			end
		end)
	end
end)

-- ESP
createToggle("ESP Fruits", false, function(state)
	esp = state
	if state then
		for _,v in pairs(game:GetService("Workspace"):GetDescendants()) do
			if v:IsA("Tool") and string.find(v.Name, "Fruit") and not v:FindFirstChild("ESP") then
				local Billboard = Instance.new("BillboardGui", v)
				Billboard.Name = "ESP"
				Billboard.Size = UDim2.new(0, 100, 0, 40)
				Billboard.Adornee = v:FindFirstChild("Handle")
				Billboard.AlwaysOnTop = true

				local Label = Instance.new("TextLabel", Billboard)
				Label.Size = UDim2.new(1, 0, 1, 0)
				Label.Text = v.Name
				Label.BackgroundTransparency = 1
				Label.TextColor3 = Color3.fromRGB(255, 215, 0)
				Label.TextStrokeTransparency = 0
			end
		end
	else
		for _,v in pairs(game:GetDescendants()) do
			if v:IsA("BillboardGui") and v.Name == "ESP" then
				v:Destroy()
			end
		end
	end
end)

-- ОТКРЫТИЕ/ЗАКРЫТИЕ GUI ПО КНОПКЕ
uis.InputBegan:Connect(function(input, gpe)
	if input.KeyCode == Enum.KeyCode.RightShift and not gpe then
		frame.Visible = not frame.Visible
	end
end)
