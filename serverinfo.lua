local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

if setfpscap then setfpscap(20) end

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ServerInfoGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 190, 0, 0)
mainFrame.AnchorPoint = Vector2.new(1, 0)
mainFrame.Position = UDim2.new(1, -15, 0, 15)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 22, 30)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 16, 22)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 13, 18))
}
bgGradient.Rotation = 135
bgGradient.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Thickness = 1
stroke.Transparency = 0.88
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = mainFrame

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 38)
header.BackgroundTransparency = 1
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerGlow = Instance.new("Frame")
headerGlow.Size = UDim2.new(1, 0, 0, 2)
headerGlow.Position = UDim2.new(0, 0, 1, 0)
headerGlow.BackgroundColor3 = Color3.fromRGB(120, 145, 255)
headerGlow.BorderSizePixel = 0
headerGlow.Parent = header

local glowGradient = Instance.new("UIGradient")
glowGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 145, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 120, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 145, 255))
}
glowGradient.Parent = headerGlow

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Server Info"
title.TextColor3 = Color3.fromRGB(245, 247, 252)
title.TextSize = 13
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleButton"
toggleBtn.Size = UDim2.new(0, 28, 0, 28)
toggleBtn.Position = UDim2.new(1, -34, 0, 5)
toggleBtn.BackgroundColor3 = Color3.fromRGB(25, 28, 38)
toggleBtn.Text = "−"
toggleBtn.TextColor3 = Color3.fromRGB(245, 247, 252)
toggleBtn.TextSize = 16
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.AutoButtonColor = false
toggleBtn.Parent = header

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleBtn

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(255, 255, 255)
toggleStroke.Transparency = 0.85
toggleStroke.Thickness = 1
toggleStroke.Parent = toggleBtn

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, 0, 1, -38)
content.Position = UDim2.new(0, 0, 0, 38)
content.BackgroundTransparency = 1
content.Parent = mainFrame

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingTop = UDim.new(0, 10)
contentPadding.PaddingBottom = UDim.new(0, 10)
contentPadding.PaddingLeft = UDim.new(0, 10)
contentPadding.PaddingRight = UDim.new(0, 10)
contentPadding.Parent = content

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8)
layout.Parent = content

local function createInfoCard(labelText, defaultValue, order)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, 48)
	card.BackgroundColor3 = Color3.fromRGB(22, 25, 35)
	card.BorderSizePixel = 0
	card.LayoutOrder = order
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = card
	
	local cardGradient = Instance.new("UIGradient")
	cardGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 28, 40)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 20, 28))
	}
	cardGradient.Rotation = 90
	cardGradient.Parent = card
	
	local cardStroke = Instance.new("UIStroke")
	cardStroke.Color = Color3.fromRGB(255, 255, 255)
	cardStroke.Thickness = 1
	cardStroke.Transparency = 0.9
	cardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	cardStroke.Parent = card
	
	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(1, -16, 0, 14)
	label.Position = UDim2.new(0, 10, 0, 8)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = Color3.fromRGB(150, 160, 180)
	label.TextSize = 10
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = card
	
	local value = Instance.new("TextLabel")
	value.Name = "Value"
	value.Size = UDim2.new(1, -16, 0, 18)
	value.Position = UDim2.new(0, 10, 0, 24)
	value.BackgroundTransparency = 1
	value.Text = defaultValue
	value.TextColor3 = Color3.fromRGB(245, 247, 252)
	value.TextSize = 15
	value.Font = Enum.Font.GothamBold
	value.TextXAlignment = Enum.TextXAlignment.Left
	value.Parent = card
	
	return card, value
end

local playersCard, playersValue = createInfoCard("Players", "0/0", 1)
playersCard.Parent = content

local fpsCard, fpsValue = createInfoCard("FPS", "60", 2)
fpsCard.Parent = content

local pingCard, pingValue = createInfoCard("Ping", "0 ms", 3)
pingCard.Parent = content

local jobCard = Instance.new("Frame")
jobCard.Name = "JobId"
jobCard.Size = UDim2.new(1, 0, 0, 68)
jobCard.BackgroundColor3 = Color3.fromRGB(22, 25, 35)
jobCard.BorderSizePixel = 0
jobCard.LayoutOrder = 4
jobCard.Parent = content

local jobCorner = Instance.new("UICorner")
jobCorner.CornerRadius = UDim.new(0, 10)
jobCorner.Parent = jobCard

local jobGradient = Instance.new("UIGradient")
jobGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 28, 40)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 20, 28))
}
jobGradient.Rotation = 90
jobGradient.Parent = jobCard

local jobStroke = Instance.new("UIStroke")
jobStroke.Color = Color3.fromRGB(255, 255, 255)
jobStroke.Thickness = 1
jobStroke.Transparency = 0.9
jobStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
jobStroke.Parent = jobCard

local jobLabel = Instance.new("TextLabel")
jobLabel.Size = UDim2.new(1, -16, 0, 14)
jobLabel.Position = UDim2.new(0, 10, 0, 8)
jobLabel.BackgroundTransparency = 1
jobLabel.Text = "Job ID"
jobLabel.TextColor3 = Color3.fromRGB(150, 160, 180)
jobLabel.TextSize = 10
jobLabel.Font = Enum.Font.GothamMedium
jobLabel.TextXAlignment = Enum.TextXAlignment.Left
jobLabel.Parent = jobCard

local jobValueBg = Instance.new("Frame")
jobValueBg.Size = UDim2.new(1, -20, 0, 26)
jobValueBg.Position = UDim2.new(0, 10, 0, 26)
jobValueBg.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
jobValueBg.BorderSizePixel = 0
jobValueBg.Parent = jobCard

local jobValueCorner = Instance.new("UICorner")
jobValueCorner.CornerRadius = UDim.new(0, 6)
jobValueCorner.Parent = jobValueBg

local jobValue = Instance.new("TextLabel")
jobValue.Name = "Value"
jobValue.Size = UDim2.new(1, -60, 1, 0)
jobValue.Position = UDim2.new(0, 8, 0, 0)
jobValue.BackgroundTransparency = 1
jobValue.Text = game.JobId
jobValue.TextColor3 = Color3.fromRGB(200, 210, 230)
jobValue.TextSize = 9
jobValue.Font = Enum.Font.GothamMedium
jobValue.TextXAlignment = Enum.TextXAlignment.Left
jobValue.TextTruncate = Enum.TextTruncate.AtEnd
jobValue.Parent = jobValueBg

local copyBtn = Instance.new("TextButton")
copyBtn.Name = "CopyButton"
copyBtn.Size = UDim2.new(0, 50, 0, 20)
copyBtn.Position = UDim2.new(1, -54, 0.5, -10)
copyBtn.BackgroundColor3 = Color3.fromRGB(120, 145, 255)
copyBtn.Text = "Copy"
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.TextSize = 10
copyBtn.Font = Enum.Font.GothamBold
copyBtn.AutoButtonColor = false
copyBtn.Parent = jobValueBg

local copyBtnCorner = Instance.new("UICorner")
copyBtnCorner.CornerRadius = UDim.new(0, 5)
copyBtnCorner.Parent = copyBtn

local copyBtnGradient = Instance.new("UIGradient")
copyBtnGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 165, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 125, 255))
}
copyBtnGradient.Rotation = 45
copyBtnGradient.Parent = copyBtn

local isOpen = true
local lastFrameTime = tick()
local frameCounter = 0
local fps = 60

local function updateHeight()
	layout:ApplyLayout()
	RunService.Heartbeat:Wait()
	local contentHeight = layout.AbsoluteContentSize.Y + 58
	mainFrame.Size = UDim2.new(0, 190, 0, contentHeight)
end

updateHeight()
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateHeight)
task.defer(updateHeight)

local function toggleMenu()
	isOpen = not isOpen
	local targetHeight = isOpen and (layout.AbsoluteContentSize.Y + 58) or 38
	toggleBtn.Text = isOpen and "−" or "+"
	
	local tween = TweenService:Create(
		mainFrame,
		TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{ Size = UDim2.new(0, 190, 0, targetHeight) }
	)
	tween:Play()
end

toggleBtn.MouseButton1Click:Connect(toggleMenu)

local function addHover(button, normal, hover)
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {
			BackgroundColor3 = hover
		}):Play()
	end)
	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {
			BackgroundColor3 = normal
		}):Play()
	end)
end

addHover(copyBtn, Color3.fromRGB(120, 145, 255), Color3.fromRGB(140, 165, 255))
addHover(toggleBtn, Color3.fromRGB(25, 28, 38), Color3.fromRGB(35, 40, 55))

copyBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(game.JobId)
	end
	local originalText = copyBtn.Text
	copyBtn.Text = "Copied"
	TweenService:Create(copyBtn, TweenInfo.new(0.2), {
		BackgroundColor3 = Color3.fromRGB(76, 188, 146)
	}):Play()
	task.wait(1.2)
	copyBtn.Text = originalText
	TweenService:Create(copyBtn, TweenInfo.new(0.2), {
		BackgroundColor3 = Color3.fromRGB(120, 145, 255)
	}):Play()
end)

RunService.RenderStepped:Connect(function()
	playersValue.Text = #Players:GetPlayers() .. "/" .. Players.MaxPlayers
	
	frameCounter += 1
	local now = tick()
	if now - lastFrameTime >= 1 then
		fps = frameCounter
		frameCounter = 0
		lastFrameTime = now
		fpsValue.Text = tostring(fps)
		
		if fps >= 50 then
			fpsValue.TextColor3 = Color3.fromRGB(76, 188, 146)
		elseif fps >= 30 then
			fpsValue.TextColor3 = Color3.fromRGB(250, 197, 28)
		else
			fpsValue.TextColor3 = Color3.fromRGB(237, 66, 69)
		end
	end
	
	local ping = player:GetNetworkPing() * 1000
	pingValue.Text = string.format("%d ms", math.floor(ping))
	
	if ping < 100 then
		pingValue.TextColor3 = Color3.fromRGB(76, 188, 146)
	elseif ping < 200 then
		pingValue.TextColor3 = Color3.fromRGB(250, 197, 28)
	else
		pingValue.TextColor3 = Color3.fromRGB(237, 66, 69)
	end
end)

local dragging, dragInput, dragStart, startPos

local function updatePos(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(
		startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y
	)
end

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		updatePos(input)
	end
end)
