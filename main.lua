local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local player = Players.LocalPlayer

-- ================= GUI =================

local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 200)
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.Parent = gui

-- Rounded Frame
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 16)
frameCorner.Parent = frame

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(25,25,25)
topBar.Parent = frame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 16)
topCorner.Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 35, 0, 0)
title.Text = "AUTO COOK PANEL"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

-- Minimize (KIRI)
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 30, 1, 0)
minimize.Position = UDim2.new(0, 0, 0, 0)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(80,80,80)
minimize.TextColor3 = Color3.new(1,1,1)
minimize.Parent = topBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minimize

-- Close (KANAN)
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 1, 0)
close.Position = UDim2.new(1, -30, 0, 0)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(150,0,0)
close.TextColor3 = Color3.new(1,1,1)
close.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = close

-- Content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -30)
content.Position = UDim2.new(0, 0, 0, 30)
content.BackgroundTransparency = 1
content.Parent = frame

-- Toggle Button
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 180, 0, 40)
button.Position = UDim2.new(0.5, -90, 0, 10)
button.Text = "AUTO COOK : OFF"
button.BackgroundColor3 = Color3.fromRGB(150,0,0)
button.TextColor3 = Color3.new(1,1,1)
button.Parent = content

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 10)
btnCorner.Parent = button

-- Status Text
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 55)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.new(1,1,1)
statusLabel.TextScaled = true
statusLabel.Text = "Status: Idle"
statusLabel.Parent = content

-- Inventory Info
local inventoryLabel = Instance.new("TextLabel")
inventoryLabel.Size = UDim2.new(1, -20, 0, 70)
inventoryLabel.Position = UDim2.new(0, 10, 0, 85)
inventoryLabel.BackgroundTransparency = 1
inventoryLabel.TextColor3 = Color3.new(1,1,1)
inventoryLabel.TextScaled = true
inventoryLabel.TextWrapped = true
inventoryLabel.Text = "Inventory Loading..."
inventoryLabel.Parent = content

-- ================= DRAG =================

local dragging = false
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		update(input)
	end
end)

-- ================= MINIMIZE =================

local minimized = false

minimize.MouseButton1Click:Connect(function()
	minimized = not minimized

	if minimized then
		content.Visible = false
		frame.Size = UDim2.new(0, 240, 0, 30)
		minimize.Text = "+"
	else
		content.Visible = true
		frame.Size = UDim2.new(0, 240, 0, 200)
		minimize.Text = "-"
	end
end)

-- ================= CLOSE =================

local running = false

close.MouseButton1Click:Connect(function()
	running = false
	task.wait(0.2)
	gui:Destroy()
end)

-- ================= PROXIMITY PROMPT =================

local currentPrompt = nil

ProximityPromptService.PromptShown:Connect(function(prompt)
	currentPrompt = prompt
end)

ProximityPromptService.PromptHidden:Connect(function(prompt)
	if currentPrompt == prompt then
		currentPrompt = nil
	end
end)

local function triggerPrompt()
	if currentPrompt then
		fireproximityprompt(currentPrompt, currentPrompt.HoldDuration)
		task.wait(0.5)
	end
end

-- ================= INVENTORY =================

local function countItem(name)
	local count = 0

	for _, item in pairs(player.Backpack:GetChildren()) do
		if item.Name == name then
			count += 1
		end
	end

	if player.Character then
		for _, item in pairs(player.Character:GetChildren()) do
			if item.Name == name then
				count += 1
			end
		end
	end

	return count
end

local function updateInventory()
	inventoryLabel.Text =
		"Water : "..countItem("Water").."\n"..
		"Sugar : "..countItem("Sugar Block Bag").."\n"..
		"Gelatin : "..countItem("Gelatin").."\n"..
		"Empty Bag : "..countItem("Empty Bag")
end

player.Backpack.ChildAdded:Connect(updateInventory)
player.Backpack.ChildRemoved:Connect(updateInventory)

updateInventory()

-- ================= AUTO COOK =================

local function setStatus(text)
	statusLabel.Text = "Status: " .. text
end

local function equipTool(name)
	local tool = player.Backpack:FindFirstChild(name)
		or player.Character:FindFirstChild(name)

	if tool then
		player.Character.Humanoid:EquipTool(tool)
		task.wait(0.8)
	end
end

local function waitWithCancel(seconds)
	for i = 1, seconds do
		if not running then
			return false
		end
		task.wait(1)
	end
	return true
end

local function autoCookLoop()
	while running do

		setStatus("Menuangkan Air...")
		equipTool("Water")
		triggerPrompt()

		setStatus("Menunggu...")
		if not waitWithCancel(23) then break end

		setStatus("Menambahkan Sugar...")
		equipTool("Sugar Block Bag")
		triggerPrompt()

		setStatus("Memasukkan Gelatin...")
		equipTool("Gelatin")
		triggerPrompt()

		setStatus("Menunggu...")
		if not waitWithCancel(48) then break end

		setStatus("Mengambil Empty Bag...")
		equipTool("Empty Bag")
		triggerPrompt()

		setStatus("Mengulang...")
		task.wait(1)
	end

	setStatus("Idle")
end

button.MouseButton1Click:Connect(function()
	running = not running

	if running then
		button.Text = "AUTO COOK : ON"
		button.BackgroundColor3 = Color3.fromRGB(0,150,0)
		task.spawn(autoCookLoop)
	else
		button.Text = "AUTO COOK : OFF"
		button.BackgroundColor3 = Color3.fromRGB(150,0,0)
		setStatus("Idle")
	end
end)
