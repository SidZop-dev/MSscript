--[[
╔════════════════════════════════════════════════════════════╗
║   ULTIMATE MULTI TOOL - AUTO COOK + HITBOX + DELETE       ║
║   + SPEED SLIDER (ANTI RESET + MINIMIZE + TOGGLE)         ║
╚════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local LocalPlayer = player

-- ================= DETEKSI PLATFORM =================
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local IS_PC = UserInputService.MouseEnabled and UserInputService.KeyboardEnabled

print("📱 Platform: " .. (IS_MOBILE and "MOBILE" or "PC"))

-- ================= COLOR THEME =================
local colors = {
    bg = Color3.fromRGB(18, 18, 22),
    surface = Color3.fromRGB(28, 28, 34),
    primary = Color3.fromRGB(99, 102, 241),
    success = Color3.fromRGB(34, 197, 94),
    danger = Color3.fromRGB(239, 68, 68),
    warning = Color3.fromRGB(255, 170, 0),
    text = Color3.fromRGB(255, 255, 255),
    textDim = Color3.fromRGB(160, 160, 180),
    accent = Color3.fromRGB(168, 85, 247),
    delete = Color3.fromRGB(255, 70, 70),
    hitbox = Color3.fromRGB(100, 100, 255),
    speed = Color3.fromRGB(255, 200, 100),
}

-- ================= GLOBAL GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "UltimateMultiTool"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ============================================================================
-- PANEL 1: AUTO COOK (KIRI)
-- ============================================================================

local cookFrame = Instance.new("Frame")
cookFrame.Size = UDim2.new(0, 320, 0, 380)
cookFrame.Position = UDim2.new(0.02, 0, 0.1, 0)
cookFrame.BackgroundColor3 = colors.bg
cookFrame.BackgroundTransparency = 0.1
cookFrame.BorderSizePixel = 0
cookFrame.Draggable = true
cookFrame.Parent = gui

-- Glow effect
for i = 1, 3 do
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1, 8*i, 1, 8*i)
    glow.Position = UDim2.new(0, -4*i, 0, -4*i)
    glow.BackgroundColor3 = colors.primary
    glow.BackgroundTransparency = 0.9
    glow.BorderSizePixel = 0
    glow.ZIndex = -i
    glow.Parent = cookFrame
    
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 20 + (2*i))
    glowCorner.Parent = glow
end

local cookCorner = Instance.new("UICorner")
cookCorner.CornerRadius = UDim.new(0, 20)
cookCorner.Parent = cookFrame

-- Top Bar
local cookTopBar = Instance.new("Frame")
cookTopBar.Size = UDim2.new(1, 0, 0, 50)
cookTopBar.BackgroundColor3 = colors.surface
cookTopBar.BackgroundTransparency = 0.3
cookTopBar.BorderSizePixel = 0
cookTopBar.Parent = cookFrame

local cookTopBarCorner = Instance.new("UICorner")
cookTopBarCorner.CornerRadius = UDim.new(0, 20)
cookTopBarCorner.Parent = cookTopBar

-- Title Icon
local cookIcon = Instance.new("TextLabel")
cookIcon.Size = UDim2.new(0, 40, 1, 0)
cookIcon.Position = UDim2.new(0, 10, 0, 0)
cookIcon.BackgroundTransparency = 1
cookIcon.Text = "🍳"
cookIcon.TextColor3 = colors.text
cookIcon.TextSize = 24
cookIcon.Font = Enum.Font.GothamBold
cookIcon.Parent = cookTopBar

-- Title Text
local cookTitle = Instance.new("TextLabel")
cookTitle.Size = UDim2.new(1, -120, 1, 0)
cookTitle.Position = UDim2.new(0, 55, 0, 0)
cookTitle.BackgroundTransparency = 1
cookTitle.Text = "AUTO COOK"
cookTitle.TextColor3 = colors.text
cookTitle.TextSize = 18
cookTitle.Font = Enum.Font.GothamBlack
cookTitle.TextXAlignment = Enum.TextXAlignment.Left
cookTitle.Parent = cookTopBar

-- Minimize Button
local cookMinimize = Instance.new("TextButton")
cookMinimize.Size = UDim2.new(0, 35, 0, 35)
cookMinimize.Position = UDim2.new(1, -80, 0.5, -17.5)
cookMinimize.BackgroundColor3 = colors.surface
cookMinimize.Text = "−"
cookMinimize.TextColor3 = colors.text
cookMinimize.TextSize = 24
cookMinimize.Font = Enum.Font.GothamBold
cookMinimize.AutoButtonColor = false
cookMinimize.Parent = cookTopBar

local cookMinCorner = Instance.new("UICorner")
cookMinCorner.CornerRadius = UDim.new(0, 10)
cookMinCorner.Parent = cookMinimize

-- Close Button
local cookClose = Instance.new("TextButton")
cookClose.Size = UDim2.new(0, 35, 0, 35)
cookClose.Position = UDim2.new(1, -40, 0.5, -17.5)
cookClose.BackgroundColor3 = colors.danger
cookClose.Text = "✕"
cookClose.TextColor3 = colors.text
cookClose.TextSize = 20
cookClose.Font = Enum.Font.GothamBold
cookClose.AutoButtonColor = false
cookClose.Parent = cookTopBar

local cookCloseCorner = Instance.new("UICorner")
cookCloseCorner.CornerRadius = UDim.new(0, 10)
cookCloseCorner.Parent = cookClose

-- Content
local cookContent = Instance.new("Frame")
cookContent.Size = UDim2.new(1, -30, 1, -70)
cookContent.Position = UDim2.new(0, 15, 0, 60)
cookContent.BackgroundTransparency = 1
cookContent.Parent = cookFrame

-- Toggle Button
local cookButton = Instance.new("TextButton")
cookButton.Size = UDim2.new(1, 0, 0, 55)
cookButton.Position = UDim2.new(0, 0, 0, 0)
cookButton.BackgroundColor3 = colors.danger
cookButton.Text = ""
cookButton.AutoButtonColor = false
cookButton.Parent = cookContent

local cookBtnCorner = Instance.new("UICorner")
cookBtnCorner.CornerRadius = UDim.new(0, 15)
cookBtnCorner.Parent = cookButton

local cookBtnText = Instance.new("TextLabel")
cookBtnText.Size = UDim2.new(1, 0, 1, 0)
cookBtnText.BackgroundTransparency = 1
cookBtnText.Text = "AUTO COOK : OFF"
cookBtnText.TextColor3 = colors.text
cookBtnText.TextSize = 18
cookBtnText.Font = Enum.Font.GothamBold
cookBtnText.Parent = cookButton

-- Status Card
local cookStatusCard = Instance.new("Frame")
cookStatusCard.Size = UDim2.new(1, 0, 0, 50)
cookStatusCard.Position = UDim2.new(0, 0, 0, 65)
cookStatusCard.BackgroundColor3 = colors.surface
cookStatusCard.BackgroundTransparency = 0.3
cookStatusCard.Parent = cookContent

local cookStatusCorner = Instance.new("UICorner")
cookStatusCorner.CornerRadius = UDim.new(0, 12)
cookStatusCorner.Parent = cookStatusCard

local cookStatusIcon = Instance.new("TextLabel")
cookStatusIcon.Size = UDim2.new(0, 40, 1, 0)
cookStatusIcon.Position = UDim2.new(0, 10, 0, 0)
cookStatusIcon.BackgroundTransparency = 1
cookStatusIcon.Text = "⚡"
cookStatusIcon.TextColor3 = colors.primary
cookStatusIcon.TextSize = 20
cookStatusIcon.Font = Enum.Font.GothamBold
cookStatusIcon.Parent = cookStatusCard

local cookStatusLabel = Instance.new("TextLabel")
cookStatusLabel.Size = UDim2.new(1, -60, 1, 0)
cookStatusLabel.Position = UDim2.new(0, 55, 0, 0)
cookStatusLabel.BackgroundTransparency = 1
cookStatusLabel.Text = "Status: Idle"
cookStatusLabel.TextColor3 = colors.text
cookStatusLabel.TextSize = 16
cookStatusLabel.Font = Enum.Font.GothamBold
cookStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
cookStatusLabel.Parent = cookStatusCard

-- Inventory Card
local cookInvCard = Instance.new("Frame")
cookInvCard.Size = UDim2.new(1, 0, 0, 140)
cookInvCard.Position = UDim2.new(0, 0, 0, 125)
cookInvCard.BackgroundColor3 = colors.surface
cookInvCard.BackgroundTransparency = 0.3
cookInvCard.Parent = cookContent

local cookInvCorner = Instance.new("UICorner")
cookInvCorner.CornerRadius = UDim.new(0, 12)
cookInvCorner.Parent = cookInvCard

local cookInvTitle = Instance.new("TextLabel")
cookInvTitle.Size = UDim2.new(1, -20, 0, 25)
cookInvTitle.Position = UDim2.new(0, 15, 0, 8)
cookInvTitle.BackgroundTransparency = 1
cookInvTitle.Text = "📦 INVENTORY"
cookInvTitle.TextColor3 = colors.primary
cookInvTitle.TextSize = 14
cookInvTitle.Font = Enum.Font.GothamBold
cookInvTitle.TextXAlignment = Enum.TextXAlignment.Left
cookInvTitle.Parent = cookInvCard

local cookInventoryLabel = Instance.new("TextLabel")
cookInventoryLabel.Size = UDim2.new(1, -20, 0, 90)
cookInventoryLabel.Position = UDim2.new(0, 15, 0, 35)
cookInventoryLabel.BackgroundTransparency = 1
cookInventoryLabel.Text = "Loading..."
cookInventoryLabel.TextColor3 = colors.textDim
cookInventoryLabel.TextSize = 14
cookInventoryLabel.Font = Enum.Font.Gotham
cookInventoryLabel.TextXAlignment = Enum.TextXAlignment.Left
cookInventoryLabel.TextYAlignment = Enum.TextYAlignment.Top
cookInventoryLabel.Parent = cookInvCard

-- ============================================================================
-- PANEL 2: HITBOX EXPANDER (TENGAH)
-- ============================================================================

local hitboxFrame = Instance.new("Frame")
hitboxFrame.Size = UDim2.new(0, 300, 0, 420)
hitboxFrame.Position = UDim2.new(0.35, -150, 0.1, 0)
hitboxFrame.BackgroundColor3 = colors.bg
hitboxFrame.BackgroundTransparency = 0.1
hitboxFrame.BorderSizePixel = 0
hitboxFrame.Draggable = true
hitboxFrame.Parent = gui

-- Glow effect
for i = 1, 3 do
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1, 8*i, 1, 8*i)
    glow.Position = UDim2.new(0, -4*i, 0, -4*i)
    glow.BackgroundColor3 = colors.hitbox
    glow.BackgroundTransparency = 0.9
    glow.BorderSizePixel = 0
    glow.ZIndex = -i
    glow.Parent = hitboxFrame
    
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 20 + (2*i))
    glowCorner.Parent = glow
end

local hitboxCorner = Instance.new("UICorner")
hitboxCorner.CornerRadius = UDim.new(0, 20)
hitboxCorner.Parent = hitboxFrame

-- Top Bar
local hitboxTopBar = Instance.new("Frame")
hitboxTopBar.Size = UDim2.new(1, 0, 0, 40)
hitboxTopBar.BackgroundTransparency = 1
hitboxTopBar.Parent = hitboxFrame

local hitboxTitle = Instance.new("TextLabel")
hitboxTitle.Size = UDim2.new(1, -80, 1, 0)
hitboxTitle.Position = UDim2.new(0, 10, 0, 0)
hitboxTitle.BackgroundTransparency = 1
hitboxTitle.Text = "🎯 HITBOX EXPANDER"
hitboxTitle.TextColor3 = Color3.new(1,1,1)
hitboxTitle.Font = Enum.Font.GothamBold
hitboxTitle.TextSize = 16
hitboxTitle.TextXAlignment = Enum.TextXAlignment.Left
hitboxTitle.Parent = hitboxTopBar

-- Minimize
local hitboxMinimize = Instance.new("TextButton")
hitboxMinimize.Size = UDim2.new(0,30,0,30)
hitboxMinimize.Position = UDim2.new(1,-70,0.5,-15)
hitboxMinimize.Text = "−"
hitboxMinimize.Font = Enum.Font.GothamBold
hitboxMinimize.TextSize = 20
hitboxMinimize.BackgroundColor3 = Color3.fromRGB(60,60,70)
hitboxMinimize.TextColor3 = Color3.new(1,1,1)
hitboxMinimize.Parent = hitboxTopBar
Instance.new("UICorner", hitboxMinimize).CornerRadius = UDim.new(0,8)

-- Close
local hitboxClose = Instance.new("TextButton")
hitboxClose.Size = UDim2.new(0,30,0,30)
hitboxClose.Position = UDim2.new(1,-35,0.5,-15)
hitboxClose.Text = "✕"
hitboxClose.Font = Enum.Font.GothamBold
hitboxClose.TextSize = 16
hitboxClose.BackgroundColor3 = Color3.fromRGB(180,50,50)
hitboxClose.TextColor3 = Color3.new(1,1,1)
hitboxClose.Parent = hitboxTopBar
Instance.new("UICorner", hitboxClose).CornerRadius = UDim.new(0,8)

-- Content
local hitboxContent = Instance.new("Frame")
hitboxContent.Size = UDim2.new(1,-20,1,-60)
hitboxContent.Position = UDim2.new(0,10,0,50)
hitboxContent.BackgroundTransparency = 1
hitboxContent.Parent = hitboxFrame

local hitboxLayout = Instance.new("UIListLayout")
hitboxLayout.Padding = UDim.new(0,10)
hitboxLayout.SortOrder = Enum.SortOrder.LayoutOrder
hitboxLayout.Parent = hitboxContent

-- Hitbox Variables
local hitboxEnabled = false
local headSize = 1.5
local bodySize = 1.2
local originalSizes = {}

local function storeOriginalSizes(char)
    if not char then return end
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            originalSizes[part] = part.Size
        end
    end
end

local function restoreOriginalSizes(char)
    if not char then return end
    for part, originalSize in pairs(originalSizes) do
        if part and part.Parent then
            part.Size = originalSize
        end
    end
    table.clear(originalSizes)
end

local function expandHitbox(char, headMult, bodyMult)
    if not char then return end
    
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            if part.Name == "Head" then
                part.Size = originalSizes[part] * headMult
            else
                part.Size = originalSizes[part] * bodyMult
            end
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    if plr == player then return end
    
    plr.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        storeOriginalSizes(char)
        if hitboxEnabled then
            expandHitbox(char, headSize, bodySize)
        end
    end)
end)

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= player and plr.Character then
        storeOriginalSizes(plr.Character)
    end
end

-- Hitbox Toggle Function
local function createHitboxToggle(text, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,45)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,45)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = hitboxContent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7,-10,1,0)
    label.Position = UDim2.new(0,10,0,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(0,60,0,30)
    status.Position = UDim2.new(1,-70,0.5,-15)
    status.BackgroundColor3 = default and Color3.fromRGB(0,120,0) or Color3.fromRGB(120,0,0)
    status.Text = default and "ON" or "OFF"
    status.TextColor3 = Color3.new(1,1,1)
    status.Font = Enum.Font.GothamBold
    status.TextSize = 14
    status.Parent = btn
    Instance.new("UICorner", status).CornerRadius = UDim.new(0,8)
    
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        status.BackgroundColor3 = state and Color3.fromRGB(0,120,0) or Color3.fromRGB(120,0,0)
        status.Text = state and "ON" or "OFF"
        if callback then callback(state) end
        
        btn:TweenSize(UDim2.new(1,-5,0,47), "Out", "Quad", 0.1)
        task.wait(0.1)
        btn:TweenSize(UDim2.new(1,0,0,45), "Out", "Quad", 0.1)
    end)
    
    return btn
end

-- Hitbox Slider Function
local function createHitboxSlider(text, min, max, default, suffix, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,0,70)
    frame.BackgroundColor3 = Color3.fromRGB(40,40,45)
    frame.Parent = hitboxContent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,-20,0,20)
    label.Position = UDim2.new(0,10,0,5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0,50,0,25)
    valueLabel.Position = UDim2.new(1,-60,0,5)
    valueLabel.BackgroundColor3 = Color3.fromRGB(100,100,255)
    valueLabel.Text = tostring(default) .. suffix
    valueLabel.TextColor3 = Color3.new(1,1,1)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 14
    valueLabel.Parent = frame
    Instance.new("UICorner", valueLabel).CornerRadius = UDim.new(0,6)
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1,-20,0,10)
    sliderBg.Position = UDim2.new(0,10,0,45)
    sliderBg.BackgroundColor3 = Color3.fromRGB(30,30,35)
    sliderBg.Parent = frame
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1,0)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(100,100,255)
    fill.Parent = sliderBg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0,15,0,15)
    knob.Position = UDim2.new((default-min)/(max-min), -7.5, 0.5, -7.5)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.Parent = sliderBg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)
    
    local dragging = false
    local currentValue = default
    
    local function updateSlider(input)
        local pos = input.Position.X - sliderBg.AbsolutePosition.X
        local percent = math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1)
        currentValue = min + (max - min) * percent
        if math.floor(min) == min and math.floor(max) == max then
            currentValue = math.floor(currentValue)
        end
        valueLabel.Text = tostring(currentValue) .. suffix
        fill.Size = UDim2.new(percent, 0, 1, 0)
        knob.Position = UDim2.new(percent, -7.5, 0.5, -7.5)
        if callback then callback(currentValue) end
    end
    
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            updateSlider(input)
        end
    end)
    
    return frame
end

-- Hitbox Toggles
createHitboxToggle("🔴 Aktifkan Hitbox", false, function(state)
    hitboxEnabled = state
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            if state then
                storeOriginalSizes(plr.Character)
                expandHitbox(plr.Character, headSize, bodySize)
            else
                restoreOriginalSizes(plr.Character)
            end
        end
    end
end)

createHitboxSlider("👤 Ukuran Kepala", 1.0, 10.0, 1.5, "x", function(value)
    headSize = value
    if hitboxEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                expandHitbox(plr.Character, headSize, bodySize)
            end
        end
    end
end)

createHitboxSlider("💪 Ukuran Badan", 1.0, 10.0, 1.2, "x", function(value)
    bodySize = value
    if hitboxEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                expandHitbox(plr.Character, headSize, bodySize)
            end
        end
    end
end)

local hitboxWarning = Instance.new("TextLabel")
hitboxWarning.Size = UDim2.new(1,0,0,40)
hitboxWarning.BackgroundTransparency = 1
hitboxWarning.Text = "⚠️ Makin gede makin gampang kena\nTapi makin gampang ketahuan!"
hitboxWarning.TextColor3 = Color3.fromRGB(255,200,0)
hitboxWarning.TextSize = 12
hitboxWarning.Font = Enum.Font.GothamBold
hitboxWarning.TextXAlignment = Enum.TextXAlignment.Left
hitboxWarning.TextYAlignment = Enum.TextYAlignment.Top
hitboxWarning.Parent = hitboxContent

-- ============================================================================
-- PANEL 3: SPEED SLIDER (BAWAH TENGAH)
-- ============================================================================

local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(0, 300, 0, 150)
speedFrame.Position = UDim2.new(0.35, -150, 0.65, -75)
speedFrame.BackgroundColor3 = colors.bg
speedFrame.BackgroundTransparency = 0.1
speedFrame.BorderSizePixel = 0
speedFrame.Draggable = false
speedFrame.Parent = gui

-- Glow effect
for i = 1, 3 do
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1, 8*i, 1, 8*i)
    glow.Position = UDim2.new(0, -4*i, 0, -4*i)
    glow.BackgroundColor3 = colors.speed
    glow.BackgroundTransparency = 0.9
    glow.BorderSizePixel = 0
    glow.ZIndex = -i
    glow.Parent = speedFrame
    
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 20 + (2*i))
    glowCorner.Parent = glow
end

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 20)
speedCorner.Parent = speedFrame

-- Title Bar
local speedTopBar = Instance.new("Frame")
speedTopBar.Size = UDim2.new(1, 0, 0, 40)
speedTopBar.BackgroundColor3 = colors.surface
speedTopBar.BackgroundTransparency = 0.3
speedTopBar.BorderSizePixel = 0
speedTopBar.Parent = speedFrame

local speedTopBarCorner = Instance.new("UICorner")
speedTopBarCorner.CornerRadius = UDim.new(0, 20)
speedTopBarCorner.Parent = speedTopBar

-- Icon
local speedIcon = Instance.new("TextLabel")
speedIcon.Size = UDim2.new(0, 40, 1, 0)
speedIcon.Position = UDim2.new(0, 10, 0, 0)
speedIcon.BackgroundTransparency = 1
speedIcon.Text = "⚡"
speedIcon.TextColor3 = colors.speed
speedIcon.TextSize = 24
speedIcon.Font = Enum.Font.GothamBold
speedIcon.Parent = speedTopBar

-- Title
local speedTitle = Instance.new("TextLabel")
speedTitle.Size = UDim2.new(1, -80, 1, 0)
speedTitle.Position = UDim2.new(0, 55, 0, 0)
speedTitle.BackgroundTransparency = 1
speedTitle.Text = "SPEED CONTROL"
speedTitle.TextColor3 = colors.text
speedTitle.TextSize = 16
speedTitle.Font = Enum.Font.GothamBlack
speedTitle.TextXAlignment = Enum.TextXAlignment.Left
speedTitle.Parent = speedTopBar

-- Minimize Button
local speedMinimize = Instance.new("TextButton")
speedMinimize.Size = UDim2.new(0, 30, 0, 30)
speedMinimize.Position = UDim2.new(1, -75, 0.5, -15)
speedMinimize.BackgroundColor3 = colors.surface
speedMinimize.Text = "−"
speedMinimize.TextColor3 = colors.text
speedMinimize.TextSize = 20
speedMinimize.Font = Enum.Font.GothamBold
speedMinimize.AutoButtonColor = false
speedMinimize.Parent = speedTopBar

local speedMinCorner = Instance.new("UICorner")
speedMinCorner.CornerRadius = UDim.new(0, 8)
speedMinCorner.Parent = speedMinimize

-- Close Button
local speedClose = Instance.new("TextButton")
speedClose.Size = UDim2.new(0, 30, 0, 30)
speedClose.Position = UDim2.new(1, -40, 0.5, -15)
speedClose.BackgroundColor3 = colors.danger
speedClose.Text = "✕"
speedClose.TextColor3 = colors.text
speedClose.TextSize = 16
speedClose.Font = Enum.Font.GothamBold
speedClose.Parent = speedTopBar

local speedCloseCorner = Instance.new("UICorner")
speedCloseCorner.CornerRadius = UDim.new(0, 8)
speedCloseCorner.Parent = speedClose

-- Content
local speedContent = Instance.new("Frame")
speedContent.Size = UDim2.new(1, -20, 1, -60)
speedContent.Position = UDim2.new(0, 10, 0, 50)
speedContent.BackgroundTransparency = 1
speedContent.Parent = speedFrame

-- Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 25)
speedLabel.Position = UDim2.new(0, 0, 0, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Adjust Speed:"
speedLabel.TextColor3 = colors.textDim
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = speedContent

-- Value display
local speedValue = Instance.new("TextLabel")
speedValue.Size = UDim2.new(0, 50, 0, 25)
speedValue.Position = UDim2.new(1, -50, 0, 0)
speedValue.BackgroundColor3 = colors.speed
speedValue.Text = "16"
speedValue.TextColor3 = colors.text
speedValue.Font = Enum.Font.GothamBold
speedValue.TextSize = 14
speedValue.Parent = speedContent
Instance.new("UICorner", speedValue).CornerRadius = UDim.new(0, 6)

-- Current speed
local speedCurrent = Instance.new("TextLabel")
speedCurrent.Size = UDim2.new(1, 0, 0, 20)
speedCurrent.Position = UDim2.new(0, 0, 0, 30)
speedCurrent.BackgroundTransparency = 1
speedCurrent.Text = "Current: 16"
speedCurrent.TextColor3 = colors.textDim
speedCurrent.TextSize = 12
speedCurrent.Font = Enum.Font.Gotham
speedCurrent.TextXAlignment = Enum.TextXAlignment.Left
speedCurrent.Parent = speedContent

-- Slider background
local speedSliderBg = Instance.new("Frame")
speedSliderBg.Size = UDim2.new(1, 0, 0, 10)
speedSliderBg.Position = UDim2.new(0, 0, 0, 60)
speedSliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
speedSliderBg.Parent = speedContent
Instance.new("UICorner", speedSliderBg).CornerRadius = UDim.new(1, 0)

-- Slider fill
local speedFill = Instance.new("Frame")
speedFill.Size = UDim2.new(0.7, 0, 1, 0)
speedFill.BackgroundColor3 = colors.speed
speedFill.Parent = speedSliderBg
Instance.new("UICorner", speedFill).CornerRadius = UDim.new(1, 0)

-- Slider knob
local speedKnob = Instance.new("Frame")
speedKnob.Size = UDim2.new(0, 20, 0, 20)
speedKnob.Position = UDim2.new(0.7, -10, 0.5, -10)
speedKnob.BackgroundColor3 = Color3.new(1, 1, 1)
speedKnob.Parent = speedSliderBg
Instance.new("UICorner", speedKnob).CornerRadius = UDim.new(1, 0)

-- Min/Max labels
local speedMin = Instance.new("TextLabel")
speedMin.Size = UDim2.new(0, 30, 0, 20)
speedMin.Position = UDim2.new(0, 0, 0, 75)
speedMin.BackgroundTransparency = 1
speedMin.Text = "0"
speedMin.TextColor3 = colors.textDim
speedMin.TextSize = 12
speedMin.Font = Enum.Font.Gotham
speedMin.TextXAlignment = Enum.TextXAlignment.Left
speedMin.Parent = speedContent

local speedMax = Instance.new("TextLabel")
speedMax.Size = UDim2.new(0, 30, 0, 20)
speedMax.Position = UDim2.new(1, -30, 0, 75)
speedMax.BackgroundTransparency = 1
speedMax.Text = "23.9"
speedMax.TextColor3 = colors.textDim
speedMax.TextSize = 12
speedMax.Font = Enum.Font.Gotham
speedMax.TextXAlignment = Enum.TextXAlignment.Right
speedMax.Parent = speedContent

-- Info
local speedInfo = Instance.new("TextLabel")
speedInfo.Size = UDim2.new(1, 0, 0, 20)
speedInfo.Position = UDim2.new(0, 0, 0, 100)
speedInfo.BackgroundTransparency = 1
speedInfo.Text = "🔄 Anti Reset | Ctrl Kanan Toggle"
speedInfo.TextColor3 = Color3.fromRGB(100, 255, 100)
speedInfo.TextSize = 9
speedInfo.Font = Enum.Font.GothamBold
speedInfo.TextXAlignment = Enum.TextXAlignment.Left
speedInfo.Parent = speedContent

-- Speed Variables
local minSpeed = 0
local maxSpeed = 23.9
local currentSpeed = 16
local speedDragging = false
local speedKeepRunning = true

-- Speed Functions
local function applySpeed()
    pcall(function()
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        if humanoid and humanoid.WalkSpeed ~= currentSpeed then
            humanoid.WalkSpeed = currentSpeed
        end
    end)
end

local function updateSpeed(value)
    currentSpeed = math.floor(value * 10) / 10
    speedValue.Text = tostring(currentSpeed)
    speedCurrent.Text = "Current: " .. currentSpeed
    speedFill.Size = UDim2.new((currentSpeed - minSpeed) / (maxSpeed - minSpeed), 0, 1, 0)
    speedKnob.Position = UDim2.new((currentSpeed - minSpeed) / (maxSpeed - minSpeed), -10, 0.5, -10)
    applySpeed()
end

-- Anti Reset Loop
task.spawn(function()
    while speedKeepRunning do
        applySpeed()
        task.wait(0.3)
    end
end)

-- Speed Slider Events
speedKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        speedDragging = true
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not speedDragging then return end
    
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local pos = input.Position.X - speedSliderBg.AbsolutePosition.X
        local percent = math.clamp(pos / speedSliderBg.AbsoluteSize.X, 0, 1)
        updateSpeed(minSpeed + (maxSpeed - minSpeed) * percent)
    end
end)

speedSliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local pos = input.Position.X - speedSliderBg.AbsolutePosition.X
        local percent = math.clamp(pos / speedSliderBg.AbsoluteSize.X, 0, 1)
        updateSpeed(minSpeed + (maxSpeed - minSpeed) * percent)
        speedDragging = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        speedDragging = false
    end
end)

-- Speed Minimize
local speedMinimized = false
local speedNormalSize = UDim2.new(0, 300, 0, 150)
local speedMinimizedSize = UDim2.new(0, 300, 0, 40)

speedMinimize.MouseButton1Click:Connect(function()
    speedMinimized = not speedMinimized
    speedContent.Visible = not speedMinimized
    speedFrame.Size = speedMinimized and speedMinimizedSize or speedNormalSize
    speedMinimize.Text = speedMinimized and "+" or "−"
end)

speedClose.MouseButton1Click:Connect(function()
    speedFrame.Visible = false
end)

-- Right Ctrl Toggle untuk Speed Panel
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    
    if input.KeyCode == Enum.KeyCode.RightControl then
        speedFrame.Visible = not speedFrame.Visible
    end
end)

-- Update speed pas respawn
player.CharacterAdded:Connect(function()
    task.wait(1)
    applySpeed()
end)

updateSpeed(16)

-- ============================================================================
-- PANEL 4: ALT CLICK HAPUS (KANAN)
-- ============================================================================

local deleteConfig = {
    Cooldown = 0.2,
    Enabled = true,
    MobileModeActive = false,
}

local lastClick = 0

local deletePanel = Instance.new("Frame")
deletePanel.Size = IS_MOBILE and UDim2.new(0, 220, 0, 100) or UDim2.new(0, 180, 0, 60)
deletePanel.Position = UDim2.new(1, -240, 0.1, 0)
deletePanel.BackgroundColor3 = colors.bg
deletePanel.BackgroundTransparency = 0.1
deletePanel.BorderSizePixel = 0
deletePanel.Draggable = true
deletePanel.Parent = gui

for i = 1, 3 do
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1, 8*i, 1, 8*i)
    glow.Position = UDim2.new(0, -4*i, 0, -4*i)
    glow.BackgroundColor3 = colors.delete
    glow.BackgroundTransparency = 0.9
    glow.BorderSizePixel = 0
    glow.ZIndex = -i
    glow.Parent = deletePanel
    
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 12 + (2*i))
    glowCorner.Parent = glow
end

local deleteCorner = Instance.new("UICorner")
deleteCorner.CornerRadius = UDim.new(0, 12)
deleteCorner.Parent = deletePanel

-- Icon & Title
local deleteIcon = Instance.new("TextLabel")
deleteIcon.Size = UDim2.new(0, 30, 0, 30)
deleteIcon.Position = UDim2.new(0, 10, 0, 5)
deleteIcon.BackgroundTransparency = 1
deleteIcon.Text = "🗑️"
deleteIcon.TextColor3 = colors.delete
deleteIcon.TextSize = 20
deleteIcon.Font = Enum.Font.GothamBold
deleteIcon.Parent = deletePanel

local deleteTitle = Instance.new("TextLabel")
deleteTitle.Size = UDim2.new(0.5, 0, 0, 30)
deleteTitle.Position = UDim2.new(0, 45, 0, 5)
deleteTitle.BackgroundTransparency = 1
deleteTitle.Text = "HAPUS"
deleteTitle.TextColor3 = colors.text
deleteTitle.TextSize = 16
deleteTitle.Font = Enum.Font.GothamBold
deleteTitle.TextXAlignment = Enum.TextXAlignment.Left
deleteTitle.Parent = deletePanel

-- Status ON/OFF
local deleteStatus = Instance.new("TextLabel")
deleteStatus.Size = UDim2.new(0, 45, 0, 25)
deleteStatus.Position = UDim2.new(0, IS_MOBILE and 140 or 120, 0, 5)
deleteStatus.BackgroundColor3 = colors.success
deleteStatus.Text = "ON"
deleteStatus.TextColor3 = colors.text
deleteStatus.TextSize = 14
deleteStatus.Font = Enum.Font.GothamBold
deleteStatus.Parent = deletePanel

local deleteStatusCorner = Instance.new("UICorner")
deleteStatusCorner.CornerRadius = UDim.new(0, 8)
deleteStatusCorner.Parent = deleteStatus

-- Tooltip
local deleteTooltip = Instance.new("TextLabel")
deleteTooltip.Size = UDim2.new(0, 150, 0, 16)
deleteTooltip.Position = UDim2.new(0, 10, 1, 4)
deleteTooltip.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
deleteTooltip.BackgroundTransparency = 0.5
deleteTooltip.Text = IS_MOBILE and "⬅️ Tekan & tahan tombol" or "⬅️ ALT + Klik"
deleteTooltip.TextColor3 = colors.textDim
deleteTooltip.TextSize = 8
deleteTooltip.Font = Enum.Font.Gotham
deleteTooltip.Parent = deletePanel

local deleteTooltipCorner = Instance.new("UICorner")
deleteTooltipCorner.CornerRadius = UDim.new(0, 4)
deleteTooltipCorner.Parent = deleteTooltip

-- Mobile Mode
if IS_MOBILE then
    local hpNote = Instance.new("TextLabel")
    hpNote.Size = UDim2.new(1, -20, 0, 20)
    hpNote.Position = UDim2.new(0, 10, 0, 35)
    hpNote.BackgroundTransparency = 1
    hpNote.Text = "📱 MODE: TEKAN & TAHAN"
    hpNote.TextColor3 = colors.accent
    hpNote.TextSize = 10
    hpNote.Font = Enum.Font.GothamBold
    hpNote.TextXAlignment = Enum.TextXAlignment.Left
    hpNote.Parent = deletePanel
    
    local deleteModeBtn = Instance.new("TextButton")
    deleteModeBtn.Size = UDim2.new(0.9, 0, 0, 35)
    deleteModeBtn.Position = UDim2.new(0.05, 0, 0, 55)
    deleteModeBtn.BackgroundColor3 = colors.surface
    deleteModeBtn.Text = ""
    deleteModeBtn.AutoButtonColor = false
    deleteModeBtn.Parent = deletePanel
    Instance.new("UICorner", deleteModeBtn).CornerRadius = UDim.new(0, 8)
    
    local deleteModeBtnText = Instance.new("TextLabel")
    deleteModeBtnText.Size = UDim2.new(1, 0, 1, 0)
    deleteModeBtnText.BackgroundTransparency = 1
    deleteModeBtnText.Text = "🔴 TEKAN & TAHAN"
    deleteModeBtnText.TextColor3 = colors.text
    deleteModeBtnText.TextSize = 12
    deleteModeBtnText.Font = Enum.Font.GothamBold
    deleteModeBtnText.Parent = deleteModeBtn
    
    deleteModeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            deleteConfig.MobileModeActive = true
            deleteModeBtn.BackgroundColor3 = colors.delete
            deleteModeBtnText.Text = "✅ MODE AKTIF"
        end
    end)
    
    deleteModeBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            deleteConfig.MobileModeActive = false
            deleteModeBtn.BackgroundColor3 = colors.surface
            deleteModeBtnText.Text = "🔴 TEKAN & TAHAN"
        end
    end)
end

-- Delete Logic
local function canDelete()
    if not deleteConfig.Enabled then return false end
    if IS_MOBILE then
        return deleteConfig.MobileModeActive
    else
        return UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt)
    end
end

local function deleteObject(obj)
    if not obj or not obj.Parent then return false end
    local success = pcall(function() obj:Destroy() end)
    return success
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    
    local isValidInput = IS_MOBILE and input.UserInputType == Enum.UserInputType.Touch
        or (not IS_MOBILE and input.UserInputType == Enum.UserInputType.MouseButton1)
    
    if not isValidInput then return end
    if not canDelete() then return end
    if tick() - lastClick < deleteConfig.Cooldown then return end
    lastClick = tick()
    
    local mousePos = UserInputService:GetMouseLocation()
    local ray = Camera:ViewportPointToRay(mousePos.X, mousePos.Y)
    
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local result = workspace:Raycast(ray.Origin, ray.Direction * 500, params)
    
    if result then
        deleteObject(result.Instance)
    end
end)

deletePanel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        deleteConfig.Enabled = not deleteConfig.Enabled
        deleteStatus.Text = deleteConfig.Enabled and "ON" or "OFF"
        deleteStatus.BackgroundColor3 = deleteConfig.Enabled and colors.success or colors.danger
    end
end)

-- ============================================================================
-- DRAG FUNCTION UNTUK SEMUA PANEL
-- ============================================================================

local function makeDraggable(frame, topBar)
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

makeDraggable(cookFrame, cookTopBar)
makeDraggable(hitboxFrame, hitboxTopBar)
makeDraggable(deletePanel, deletePanel)
makeDraggable(speedFrame, speedTopBar)

-- ============================================================================
-- MINIMIZE UNTUK SEMUA PANEL
-- ============================================================================

local cookMinimized = false
cookMinimize.MouseButton1Click:Connect(function()
    cookMinimized = not cookMinimized
    local targetSize = cookMinimized and UDim2.new(0, 320, 0, 70) or UDim2.new(0, 320, 0, 380)
    local tween = TweenService:Create(cookFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = targetSize})
    tween:Play()
    cookContent.Visible = not cookMinimized
    cookMinimize.Text = cookMinimized and "□" or "−"
end)

cookClose.MouseButton1Click:Connect(function()
    cookFrame.Visible = not cookFrame.Visible
end)

local hitboxMinimized = false
hitboxMinimize.MouseButton1Click:Connect(function()
    hitboxMinimized = not hitboxMinimized
    hitboxContent.Visible = not hitboxMinimized
    hitboxFrame.Size = hitboxMinimized and UDim2.new(0,300,0,40) or UDim2.new(0,300,0,420)
    hitboxMinimize.Text = hitboxMinimized and "□" or "−"
end)

hitboxClose.MouseButton1Click:Connect(function()
    if hitboxEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                restoreOriginalSizes(plr.Character)
            end
        end
    end
    hitboxFrame.Visible = not hitboxFrame.Visible
end)

-- ============================================================================
-- AUTO COOK - SEMUA FUNGSI (DISINGKAT)
-- ============================================================================

local currentPrompt = nil
local cookRunning = false

ProximityPromptService.PromptShown:Connect(function(prompt) currentPrompt = prompt end)
ProximityPromptService.PromptHidden:Connect(function(prompt) if currentPrompt == prompt then currentPrompt = nil end end)

local function triggerPrompt()
    if currentPrompt then
        fireproximityprompt(currentPrompt, currentPrompt.HoldDuration)
        task.wait(0.5)
    end
end

local function countItem(name)
    local count = 0
    for _, item in pairs(player.Backpack:GetChildren()) do
        if item.Name == name then count = count + 1 end
    end
    local character = player.Character
    if character then
        for _, item in pairs(character:GetChildren()) do
            if item.Name == name then count = count + 1 end
        end
    end
    return count
end

local function updateInventory()
    cookInventoryLabel.Text = string.format(
        "💧 Water: %d\n🍚 Sugar: %d\n🧪 Gelatin: %d\n👜 Empty Bag: %d",
        countItem("Water"), countItem("Sugar Block Bag"), countItem("Gelatin"), countItem("Empty Bag")
    )
end

player.Backpack.ChildAdded:Connect(updateInventory)
player.Backpack.ChildRemoved:Connect(updateInventory)
player.CharacterAdded:Connect(function() task.wait(1) updateInventory() end)
task.spawn(function() while gui and gui.Parent do task.wait(5) updateInventory() end end)
updateInventory()

local function setCookStatus(text) cookStatusLabel.Text = "Status: " .. text end

local function equipTool(name)
    if not player.Character then return false end
    local tool = player.Backpack:FindFirstChild(name) or player.Character:FindFirstChild(name)
    if tool and player.Character and player.Character:FindFirstChild("Humanoid") then
        pcall(function() player.Character.Humanoid:EquipTool(tool) end)
        task.wait(0.5)
        return true
    end
    return false
end

local function waitWithCancel(seconds)
    for i = 1, seconds do
        if not cookRunning then return false end
        setCookStatus(string.format("⏳ %d/%ds", i, seconds))
        task.wait(1)
    end
    return true
end

local function autoCookLoop()
    while cookRunning do
        setCookStatus("💧 Air...")
        if not equipTool("Water") then setCookStatus("❌ Water!"); cookRunning = false; break end
        triggerPrompt()
        if not waitWithCancel(23) then break end

        setCookStatus("🍚 Sugar...")
        if not equipTool("Sugar Block Bag") then setCookStatus("❌ Sugar!"); cookRunning = false; break end
        triggerPrompt()

        setCookStatus("🧪 Gelatin...")
        if not equipTool("Gelatin") then setCookStatus("❌ Gelatin!"); cookRunning = false; break end
        triggerPrompt()

        if not waitWithCancel(48) then break end

        setCookStatus("👜 Empty Bag...")
        if not equipTool("Empty Bag") then setCookStatus("❌ Empty Bag!"); cookRunning = false; break end
        triggerPrompt()

        setCookStatus("🔄 Ulang...")
        task.wait(1)
    end
    setCookStatus("Idle")
    cookRunning = false
    cookBtnText.Text = "AUTO COOK : OFF"
    cookButton.BackgroundColor3 = colors.danger
end

cookButton.MouseButton1Click:Connect(function()
    cookRunning = not cookRunning
    if cookRunning then
        cookBtnText.Text = "AUTO COOK : ON"
        cookButton.BackgroundColor3 = colors.success
        setCookStatus("🚀 Mulai...")
        task.spawn(autoCookLoop)
    else
        cookBtnText.Text = "AUTO COOK : OFF"
        cookButton.BackgroundColor3 = colors.danger
        setCookStatus("Idle")
    end
end)

setCookStatus("Idle")

-- ============================================================================
-- FINAL PRINT
-- ============================================================================

print("\n" .. ("="):rep(60))
print("🔥 ULTIMATE MULTI TOOL - 4 FITUR!")
print(("="):rep(60))
print("📱 Platform: " .. (IS_MOBILE and "MOBILE" or "PC"))
print("🍳 AUTO COOK (KIRI)")
print("🎯 HITBOX EXPANDER (TENGAH ATAS)")
print("⚡ SPEED CONTROL (TENGAH BAWAH)")
print("🗑️ ALT CLICK HAPUS (KANAN)")
print("")
print("📌 Semua panel bisa di-DRAG!")
print("🎯 Klik [-] untuk minimize, [X] untuk sembunyiin")
print("🎮 Speed Panel: Right Ctrl = Toggle")
print(("="):rep(60))

pcall(function()
loadstring(game:HttpGet("https://rawscripts.net/raw/South-Bronx:-The-Trenches-South-bronx-the-trenche*box-expander-85811"))()
end)
