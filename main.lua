--[[
╔════════════════════════════════════════════════════════════╗
║   MULTI TOOL PANEL - AUTO COOK + ALT CLICK HAPUS          ║
║   Gabungan 2 script dengan panel terpisah & dragable      ║
╚════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer
local LocalPlayer = player

-- ================= COLOR THEME =================
local colors = {
    bg = Color3.fromRGB(18, 18, 22),
    surface = Color3.fromRGB(28, 28, 34),
    primary = Color3.fromRGB(99, 102, 241),
    success = Color3.fromRGB(34, 197, 94),
    danger = Color3.fromRGB(239, 68, 68),
    text = Color3.fromRGB(255, 255, 255),
    textDim = Color3.fromRGB(160, 160, 180),
    accent = Color3.fromRGB(168, 85, 247),
    delete = Color3.fromRGB(255, 70, 70),
}

-- ================= GLOBAL GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "MultiToolPanel"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ============================================================================
-- PANEL 1: AUTO COOK (KIRI)
-- ============================================================================

-- ================= MAIN FRAME AUTO COOK =================
local cookFrame = Instance.new("Frame")
cookFrame.Size = UDim2.new(0, 320, 0, 380)
cookFrame.Position = UDim2.new(0.02, 0, 0.1, 0)  -- Kiri
cookFrame.BackgroundColor3 = colors.bg
cookFrame.BackgroundTransparency = 0.1
cookFrame.BorderSizePixel = 0
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

-- ================= TOP BAR AUTO COOK =================
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

-- Close Button (sembunyiin panel aja, bukan hapus gui)
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

-- ================= CONTENT AUTO COOK =================
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
-- PANEL 2: ALT CLICK HAPUS (KANAN)
-- ============================================================================

-- Konfigurasi delete
local deleteConfig = {
    Cooldown = 0.2,
    Enabled = true,
}

local lastClick = 0

-- Panel Delete
local deletePanel = Instance.new("Frame")
deletePanel.Size = UDim2.new(0, 180, 0, 60)
deletePanel.Position = UDim2.new(1, -200, 0.1, 0)  -- Kanan
deletePanel.BackgroundColor3 = colors.bg
deletePanel.BackgroundTransparency = 0.1
deletePanel.BorderSizePixel = 0
deletePanel.Draggable = true
deletePanel.Active = true
deletePanel.Parent = gui

-- Glow delete
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
deleteIcon.Size = UDim2.new(0, 30, 1, 0)
deleteIcon.Position = UDim2.new(0, 10, 0, 0)
deleteIcon.BackgroundTransparency = 1
deleteIcon.Text = "🗑️"
deleteIcon.TextColor3 = colors.delete
deleteIcon.TextSize = 20
deleteIcon.Font = Enum.Font.GothamBold
deleteIcon.Parent = deletePanel

local deleteTitle = Instance.new("TextLabel")
deleteTitle.Size = UDim2.new(0.5, 0, 1, 0)
deleteTitle.Position = UDim2.new(0, 45, 0, 0)
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
deleteStatus.Position = UDim2.new(0, 120, 0.5, -12.5)
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
deleteTooltip.Size = UDim2.new(0, 100, 0, 16)
deleteTooltip.Position = UDim2.new(0, 10, 1, 4)
deleteTooltip.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
deleteTooltip.BackgroundTransparency = 0.5
deleteTooltip.Text = "⬅️ ALT + Klik"
deleteTooltip.TextColor3 = colors.textDim
deleteTooltip.TextSize = 8
deleteTooltip.Font = Enum.Font.Gotham
deleteTooltip.Parent = deletePanel

local deleteTooltipCorner = Instance.new("UICorner")
deleteTooltipCorner.CornerRadius = UDim.new(0, 4)
deleteTooltipCorner.Parent = deleteTooltip

-- ============================================================================
-- FUNGSI DRAG UNTUK KEDUA PANEL
-- ============================================================================

-- Drag function
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
end

-- Terapkan drag ke kedua panel
makeDraggable(cookFrame, cookTopBar)
makeDraggable(deletePanel, deletePanel)  -- Panel delete bisa di-drag dari mana aja

-- ============================================================================
-- MINIMIZE UNTUK AUTO COOK
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

-- Close auto cook (sembunyiin aja)
cookClose.MouseButton1Click:Connect(function()
    cookFrame.Visible = not cookFrame.Visible
end)

-- ============================================================================
-- ALT CLICK HAPUS - LOGIC
-- ============================================================================

-- Fungsi cek Alt
local function isAltPressed()
    return UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) 
        or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt)
end

-- Fungsi hapus objek
local function deleteObject(obj)
    if not obj or not obj.Parent then return false end
    
    local success = pcall(function()
        obj:Destroy()
    end)
    
    return success
end

-- Input handler untuk hapus
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    if not isAltPressed() then return end
    
    -- Cek status ON/OFF
    if not deleteConfig.Enabled then return end
    
    -- Cooldown
    if tick() - lastClick < deleteConfig.Cooldown then return end
    lastClick = tick()
    
    -- Raycast
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

-- Toggle delete panel
deletePanel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        -- Toggle ON/OFF
        deleteConfig.Enabled = not deleteConfig.Enabled
        
        -- Update tampilan
        deleteStatus.Text = deleteConfig.Enabled and "ON" or "OFF"
        deleteStatus.BackgroundColor3 = deleteConfig.Enabled and colors.success or colors.danger
        
        -- Animasi kecil
        local tweenInfo = TweenInfo.new(0.1)
        local tween = TweenService:Create(deletePanel, tweenInfo, {Size = UDim2.new(0, 185, 0, 62)})
        tween:Play()
        task.wait(0.1)
        tween = TweenService:Create(deletePanel, tweenInfo, {Size = UDim2.new(0, 180, 0, 60)})
        tween:Play()
    end
end)

-- ============================================================================
-- AUTO COOK - SEMUA FUNGSI (DARI SCRIPT PERTAMA)
-- ============================================================================

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

-- ================= INVENTORY (FIXED!) =================
local function countItem(name)
    local count = 0

    for _, item in pairs(player.Backpack:GetChildren()) do
        if item.Name == name then
            count += 1
        end
    end

    local character = player.Character
    if character then
        for _, item in pairs(character:GetChildren()) do
            if item.Name == name then
                count += 1
            end
        end
    end

    return count
end

local function updateInventory()
    local waterCount = countItem("Water")
    local sugarCount = countItem("Sugar Block Bag")
    local gelatinCount = countItem("Gelatin")
    local emptyCount = countItem("Empty Bag")
    
    cookInventoryLabel.Text = string.format(
        "💧 Water       : %d\n🍚 Sugar       : %d\n🧪 Gelatin     : %d\n👜 Empty Bag   : %d",
        waterCount,
        sugarCount,
        gelatinCount,
        emptyCount
    )
end

player.Backpack.ChildAdded:Connect(updateInventory)
player.Backpack.ChildRemoved:Connect(updateInventory)

player.CharacterAdded:Connect(function(newCharacter)
    task.wait(1)
    updateInventory()
    newCharacter.ChildAdded:Connect(updateInventory)
    newCharacter.ChildRemoved:Connect(updateInventory)
end)

task.spawn(function()
    while gui and gui.Parent do
        task.wait(5)
        updateInventory()
    end
end)

updateInventory()

-- ================= AUTO COOK LOOP =================
local cookRunning = false

local function setCookStatus(text)
    cookStatusLabel.Text = "Status: " .. text
end

local function equipTool(name)
    if not player.Character then
        return false
    end
    
    local tool = player.Backpack:FindFirstChild(name) or player.Character:FindFirstChild(name)

    if tool and player.Character and player.Character:FindFirstChild("Humanoid") then
        pcall(function()
            player.Character.Humanoid:EquipTool(tool)
        end)
        task.wait(0.5)
        return true
    end
    return false
end

local function waitWithCancel(seconds)
    for i = 1, seconds do
        if not cookRunning then
            return false
        end
        setCookStatus(string.format("⏳ Menunggu %d/%ds", i, seconds))
        task.wait(1)
    end
    return true
end

local function autoCookLoop()
    while cookRunning do
        
        setCookStatus("💧 Menuangkan Air...")
        if not equipTool("Water") then
            setCookStatus("❌ Water tidak ada!")
            cookRunning = false
            break
        end
        triggerPrompt()
        
        if not waitWithCancel(23) then break end

        setCookStatus("🍚 Menambahkan Sugar...")
        if not equipTool("Sugar Block Bag") then
            setCookStatus("❌ Sugar tidak ada!")
            cookRunning = false
            break
        end
        triggerPrompt()

        setCookStatus("🧪 Memasukkan Gelatin...")
        if not equipTool("Gelatin") then
            setCookStatus("❌ Gelatin tidak ada!")
            cookRunning = false
            break
        end
        triggerPrompt()

        if not waitWithCancel(48) then break end

        setCookStatus("👜 Mengambil Empty Bag...")
        if not equipTool("Empty Bag") then
            setCookStatus("❌ Empty Bag tidak ada!")
            cookRunning = false
            break
        end
        triggerPrompt()

        setCookStatus("🔄 Selesai, mengulang...")
        task.wait(1)
    end

    setCookStatus("Idle")
    cookRunning = false
    cookBtnText.Text = "AUTO COOK : OFF"
    cookButton.BackgroundColor3 = colors.danger
end

-- Tombol auto cook
cookButton.MouseButton1Click:Connect(function()
    cookRunning = not cookRunning

    if cookRunning then
        cookBtnText.Text = "AUTO COOK : ON"
        cookButton.BackgroundColor3 = colors.success
        setCookStatus("🚀 Memulai...")
        task.spawn(autoCookLoop)
    else
        cookBtnText.Text = "AUTO COOK : OFF"
        cookButton.BackgroundColor3 = colors.danger
        setCookStatus("Idle")
    end
    
    -- Animasi button
    local tween = TweenService:Create(cookButton, TweenInfo.new(0.2), {Size = UDim2.new(1, -5, 0, 57)})
    tween:Play()
    task.wait(0.1)
    tween = TweenService:Create(cookButton, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 55)})
    tween:Play()
end)

-- Initial setup
setCookStatus("Idle")

-- ============================================================================
-- FINAL PRINT
-- ============================================================================

print("\n" .. ("="):rep(60))
print("🔥 MULTI TOOL PANEL - READY!")
print(("="):rep(60))
print("🍳 AUTO COOK PANEL (KIRI)")
print("   - Klik START untuk auto masak")
print("   - Inventory otomatis terupdate")
print("   - Aman ketika mati")
print("")
print("🗑️ ALT CLICK HAPUS (KANAN)")
print("   - Klik panel untuk ON/OFF")
print("   - ALT + Klik kiri hapus objek")
print("   - Cooldown 0.2 detik")
print("")
print("📌 Kedua panel bisa di-DRAG!")
print("🎯 Klik [-] untuk minimize auto cook")
print("🎯 Klik [X] untuk sembunyiin panel")
print(("="):rep(60))
