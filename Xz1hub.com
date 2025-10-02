-- XZ1Hub Ultra Beautiful GUI Library
-- Made by XZ1Hub Team - Premium Version
-- Version 2.0 - Maximum Beauty Edition

local XZ1Hub = {}
XZ1Hub.__index = XZ1Hub

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

-- 🎨 Ultra Beautiful Themes
local Themes = {
    Ocean = {
        name = "Ocean Blue",
        bg = Color3.fromRGB(10, 14, 30),
        bgLight = Color3.fromRGB(18, 25, 45),
        bgDark = Color3.fromRGB(6, 10, 20),
        primary = Color3.fromRGB(58, 134, 255),
        secondary = Color3.fromRGB(138, 180, 255),
        accent = Color3.fromRGB(0, 230, 255),
        success = Color3.fromRGB(0, 255, 150),
        danger = Color3.fromRGB(255, 82, 82),
        text = Color3.fromRGB(255, 255, 255),
        textDim = Color3.fromRGB(180, 190, 210)
    },
    Sunset = {
        name = "Sunset Paradise",
        bg = Color3.fromRGB(25, 10, 20),
        bgLight = Color3.fromRGB(40, 18, 30),
        bgDark = Color3.fromRGB(15, 5, 12),
        primary = Color3.fromRGB(255, 107, 129),
        secondary = Color3.fromRGB(255, 158, 68),
        accent = Color3.fromRGB(254, 202, 87),
        success = Color3.fromRGB(123, 237, 159),
        danger = Color3.fromRGB(255, 82, 82),
        text = Color3.fromRGB(255, 255, 255),
        textDim = Color3.fromRGB(200, 180, 190)
    },
    Matrix = {
        name = "Matrix Cyber",
        bg = Color3.fromRGB(5, 15, 8),
        bgLight = Color3.fromRGB(10, 25, 15),
        bgDark = Color3.fromRGB(2, 8, 4),
        primary = Color3.fromRGB(0, 255, 128),
        secondary = Color3.fromRGB(100, 255, 180),
        accent = Color3.fromRGB(180, 255, 220),
        success = Color3.fromRGB(0, 255, 100),
        danger = Color3.fromRGB(255, 80, 80),
        text = Color3.fromRGB(200, 255, 220),
        textDim = Color3.fromRGB(120, 180, 140)
    },
    Purple = {
        name = "Purple Dream",
        bg = Color3.fromRGB(15, 10, 25),
        bgLight = Color3.fromRGB(25, 18, 40),
        bgDark = Color3.fromRGB(8, 5, 15),
        primary = Color3.fromRGB(138, 43, 226),
        secondary = Color3.fromRGB(186, 85, 255),
        accent = Color3.fromRGB(224, 130, 255),
        success = Color3.fromRGB(123, 237, 159),
        danger = Color3.fromRGB(255, 82, 82),
        text = Color3.fromRGB(255, 255, 255),
        textDim = Color3.fromRGB(200, 180, 220)
    },
    Dark = {
        name = "Dark Elite",
        bg = Color3.fromRGB(12, 12, 15),
        bgLight = Color3.fromRGB(20, 20, 25),
        bgDark = Color3.fromRGB(6, 6, 8),
        primary = Color3.fromRGB(99, 102, 241),
        secondary = Color3.fromRGB(139, 92, 246),
        accent = Color3.fromRGB(167, 139, 250),
        success = Color3.fromRGB(52, 211, 153),
        danger = Color3.fromRGB(248, 113, 113),
        text = Color3.fromRGB(255, 255, 255),
        textDim = Color3.fromRGB(156, 163, 175)
    }
}

-- ✨ Helper Functions
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 12)
    corner.Parent = parent
    return corner
end

local function createStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.7
    stroke.Parent = parent
    return stroke
end

local function createGradient(parent, colors, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = colors
    gradient.Rotation = rotation or 0
    gradient.Parent = parent
    return gradient
end

local function createShadow(parent, size, imageColor)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, size, 1, size)
    shadow.Position = UDim2.new(0, -size/2, 0, -size/2)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = imageColor or Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent
    return shadow
end

local function tween(obj, properties, duration, style)
    TweenService:Create(obj, TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    ), properties):Play()
end

-- 🎯 Main Library
function XZ1Hub:CreateWindow(config)
    local window = {
        Tabs = {},
        CurrentTab = nil,
        Theme = Themes[config.Theme] or Themes.Ocean,
        IsOpen = false
    }
    
    -- ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name = "XZ1HubGUI_V2"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 999999999
    gui.IgnoreGuiInset = true
    gui.Parent = CoreGui
    
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    
    -- 🎨 Floating Icon Button (Ultra Beautiful)
    local iconFrame = Instance.new("Frame")
    iconFrame.Size = UDim2.new(0, 75, 0, 75)
    iconFrame.Position = UDim2.new(0, 25, 0, 25)
    iconFrame.BackgroundColor3 = window.Theme.bgLight
    iconFrame.BorderSizePixel = 0
    iconFrame.ZIndex = 1000
    iconFrame.Parent = gui
    createCorner(iconFrame, 20)
    
    -- Multi-color animated border
    local iconStroke = createStroke(iconFrame, window.Theme.primary, 3, 0.3)
    
    local iconGradient = createGradient(iconFrame, ColorSequence.new({
        ColorSequenceKeypoint.new(0, window.Theme.bgLight),
        ColorSequenceKeypoint.new(0.5, window.Theme.bg),
        ColorSequenceKeypoint.new(1, window.Theme.bgDark)
    }), 135)
    
    -- Beautiful shadow
    createShadow(iconFrame, 40, window.Theme.primary)
    
    local iconButton = Instance.new("TextButton")
    iconButton.Size = UDim2.new(1, 0, 1, 0)
    iconButton.BackgroundTransparency = 1
    iconButton.Text = ""
    iconButton.ZIndex = 1001
    iconButton.Parent = iconFrame
    
    -- Custom Logo Image
    local iconLogo = Instance.new("ImageLabel")
    iconLogo.Size = UDim2.new(0.85, 0, 0.85, 0)
    iconLogo.Position = UDim2.new(0.075, 0, 0.075, 0)
    iconLogo.BackgroundTransparency = 1
    iconLogo.Image = "rbxassetid://131561855830841"
    iconLogo.ImageColor3 = Color3.fromRGB(255, 255, 255)
    iconLogo.ScaleType = Enum.ScaleType.Fit
    iconLogo.ZIndex = 1003
    iconLogo.Parent = iconFrame
    
    -- Animated rings around icon
    local function createRing(delay)
        local ring = Instance.new("Frame")
        ring.Size = UDim2.new(1, 10, 1, 10)
        ring.Position = UDim2.new(0, -5, 0, -5)
        ring.BackgroundTransparency = 1
        ring.ZIndex = 999
        ring.Parent = iconFrame
        
        local ringStroke = createStroke(ring, window.Theme.primary, 2, 1)
        createCorner(ring, 22)
        
        spawn(function()
            wait(delay)
            while ring.Parent do
                tween(ringStroke, {Transparency = 0.3}, 1, Enum.EasingStyle.Sine)
                tween(ring, {Size = UDim2.new(1, 30, 1, 30), Position = UDim2.new(0, -15, 0, -15)}, 1, Enum.EasingStyle.Sine)
                wait(1)
                ringStroke.Transparency = 1
                ring.Size = UDim2.new(1, 10, 1, 10)
                ring.Position = UDim2.new(0, -5, 0, -5)
                wait(2)
            end
        end)
        
        return ring
    end
    
    createRing(0)
    createRing(1)
    
    -- 🖼️ Main Window (Ultra Modern)
    local mainSize = isMobile and {w = 700, h = 450} or {w = 850, h = 500}
    
    local mainBlur = Instance.new("Frame")
    mainBlur.Size = UDim2.new(0, mainSize.w, 0, mainSize.h)
    mainBlur.Position = UDim2.new(0.5, -mainSize.w/2, 0.5, -mainSize.h/2)
    mainBlur.BackgroundColor3 = window.Theme.bg
    mainBlur.BackgroundTransparency = 0.05
    mainBlur.BorderSizePixel = 0
    mainBlur.Visible = false
    mainBlur.ZIndex = 500
    mainBlur.Parent = gui
    createCorner(mainBlur, 20)
    
    -- Glassmorphism effect
    local glassOverlay = Instance.new("Frame")
    glassOverlay.Size = UDim2.new(1, 0, 1, 0)
    glassOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    glassOverlay.BackgroundTransparency = 0.98
    glassOverlay.BorderSizePixel = 0
    glassOverlay.ZIndex = 501
    glassOverlay.Parent = mainBlur
    createCorner(glassOverlay, 20)
    
    -- Animated border
    local mainStroke = createStroke(mainBlur, window.Theme.primary, 2, 0.5)
    createGradient(mainStroke, ColorSequence.new({
        ColorSequenceKeypoint.new(0, window.Theme.primary),
        ColorSequenceKeypoint.new(0.5, window.Theme.accent),
        ColorSequenceKeypoint.new(1, window.Theme.secondary)
    }), 0)
    
    -- Beautiful shadow
    createShadow(mainBlur, 60, window.Theme.primary)
    
    -- Background gradient animation
    local bgGradient = createGradient(mainBlur, ColorSequence.new({
        ColorSequenceKeypoint.new(0, window.Theme.bg),
        ColorSequenceKeypoint.new(0.5, window.Theme.bgLight),
        ColorSequenceKeypoint.new(1, window.Theme.bgDark)
    }), 135)
    
    -- 🎯 Top Bar (Modern Header)
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 55)
    topBar.BackgroundColor3 = window.Theme.bgLight
    topBar.BackgroundTransparency = 0.3
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 502
    topBar.Parent = mainBlur
    createCorner(topBar, 20)
    
    createGradient(topBar, ColorSequence.new({
        ColorSequenceKeypoint.new(0, window.Theme.bgLight),
        ColorSequenceKeypoint.new(1, window.Theme.bg)
    }), 90)
    
    -- Title with icon
    local titleIcon = Instance.new("ImageLabel")
    titleIcon.Size = UDim2.new(0, 38, 0, 38)
    titleIcon.Position = UDim2.new(0, 12, 0.5, -19)
    titleIcon.BackgroundColor3 = window.Theme.primary
    titleIcon.BackgroundTransparency = 0.8
    titleIcon.Image = "rbxassetid://131561855830841"
    titleIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    titleIcon.ScaleType = Enum.ScaleType.Fit
    titleIcon.BorderSizePixel = 0
    titleIcon.ZIndex = 503
    titleIcon.Parent = topBar
    createCorner(titleIcon, 10)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.6, 0, 1, 0)
    title.Position = UDim2.new(0, 58, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = config.Title or "XZ1Hub Premium"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.TextColor3 = window.Theme.text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 503
    title.Parent = topBar
    
    createGradient(title, ColorSequence.new({
        ColorSequenceKeypoint.new(0, window.Theme.primary),
        ColorSequenceKeypoint.new(1, window.Theme.accent)
    }), 0)
    
    -- Status indicator
    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.new(0, 10, 0, 10)
    statusDot.Position = UDim2.new(1, -120, 0.5, -5)
    statusDot.BackgroundColor3 = window.Theme.success
    statusDot.BorderSizePixel = 0
    statusDot.ZIndex = 503
    statusDot.Parent = topBar
    createCorner(statusDot, 5)
    
    -- Pulse animation for status dot
    spawn(function()
        while statusDot.Parent do
            tween(statusDot, {BackgroundTransparency = 0}, 0.8)
            wait(0.8)
            tween(statusDot, {BackgroundTransparency = 0.5}, 0.8)
            wait(0.8)
        end
    end)
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(0, 60, 1, 0)
    statusText.Position = UDim2.new(1, -105, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "Active"
    statusText.Font = Enum.Font.GothamSemibold
    statusText.TextSize = 12
    statusText.TextColor3 = window.Theme.success
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.ZIndex = 503
    statusText.Parent = topBar
    
    -- Modern close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 38, 0, 38)
    closeBtn.Position = UDim2.new(1, -48, 0.5, -19)
    closeBtn.BackgroundColor3 = window.Theme.danger
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.Text = "✕"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BorderSizePixel = 0
    closeBtn.ZIndex = 503
    closeBtn.Parent = topBar
    createCorner(closeBtn, 10)
    
    -- 📑 Tab Container (Left Sidebar)
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Size = UDim2.new(0, 160, 1, -65)
    tabContainer.Position = UDim2.new(0, 8, 0, 60)
    tabContainer.BackgroundTransparency = 1
    tabContainer.BorderSizePixel = 0
    tabContainer.ScrollBarThickness = 4
    tabContainer.ScrollBarImageColor3 = window.Theme.primary
    tabContainer.ScrollBarImageTransparency = 0.5
    tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContainer.ZIndex = 502
    tabContainer.Parent = mainBlur
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 10)
    tabLayout.Parent = tabContainer
    
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContainer.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- 📦 Content Container
    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, -180, 1, -65)
    contentContainer.Position = UDim2.new(0, 173, 0, 60)
    contentContainer.BackgroundTransparency = 1
    contentContainer.ZIndex = 502
    contentContainer.Parent = mainBlur
    
    -- 🎬 Functions
    local function openWindow()
        if window.IsOpen then return end
        window.IsOpen = true
        mainBlur.Visible = true
        mainBlur.Size = UDim2.new(0, 0, 0, 0)
        mainBlur.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        tween(mainBlur, {
            Size = UDim2.new(0, mainSize.w, 0, mainSize.h),
            Position = UDim2.new(0.5, -mainSize.w/2, 0.5, -mainSize.h/2)
        }, 0.5, Enum.EasingStyle.Back)
    end
    
    local function closeWindow()
        if not window.IsOpen then return end
        window.IsOpen = false
        
        tween(mainBlur, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, 0.4, Enum.EasingStyle.Back)
        
        wait(0.4)
        mainBlur.Visible = false
    end
    
    iconButton.MouseButton1Click:Connect(function()
        if window.IsOpen then closeWindow() else openWindow() end
        tween(iconFrame, {Size = UDim2.new(0, 85, 0, 85)}, 0.1)
        wait(0.1)
        tween(iconFrame, {Size = UDim2.new(0, 75, 0, 75)}, 0.1)
    end)
    
    closeBtn.MouseButton1Click:Connect(closeWindow)
    
    closeBtn.MouseEnter:Connect(function()
        tween(closeBtn, {BackgroundTransparency = 0, Size = UDim2.new(0, 42, 0, 42)}, 0.2)
    end)
    
    closeBtn.MouseLeave:Connect(function()
        tween(closeBtn, {BackgroundTransparency = 0.3, Size = UDim2.new(0, 38, 0, 38)}, 0.2)
    end)
    
    -- Dragging
    local dragging, dragInput, dragStart, startPos
    
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainBlur.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainBlur.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Continuous animations
    spawn(function()
        while mainBlur.Parent do
            tween(bgGradient, {Rotation = bgGradient.Rotation + 360}, 20, Enum.EasingStyle.Linear)
            wait(20)
        end
    end)
    
    -- 📑 Tab System
    function window:CreateTab(tabName, icon)
        local tab = {
            Name = tabName,
            Icon = icon or "📄",
            Elements = {},
            Content = nil,
            Button = nil
        }
        
        -- Tab Button (Ultra Modern)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, -5, 0, 42)
        tabBtn.BackgroundColor3 = window.Theme.bgLight
        tabBtn.BackgroundTransparency = 0.5
        tabBtn.Text = ""
        tabBtn.BorderSizePixel = 0
        tabBtn.ZIndex = 503
        tabBtn.Parent = tabContainer
        createCorner(tabBtn, 12)
        
        if #self.Tabs == 0 then
            tabBtn.BackgroundTransparency = 0
            createStroke(tabBtn, window.Theme.primary, 2, 0.3)
        end
        
        local tabIcon = Instance.new("TextLabel")
        tabIcon.Size = UDim2.new(0, 30, 1, 0)
        tabIcon.Position = UDim2.new(0, 10, 0, 0)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Text = tab.Icon
        tabIcon.Font = Enum.Font.GothamBold
        tabIcon.TextSize = 18
        tabIcon.TextColor3 = #self.Tabs == 0 and window.Theme.primary or window.Theme.textDim
        tabIcon.ZIndex = 504
        tabIcon.Parent = tabBtn
        
        local tabLabel = Instance.new("TextLabel")
        tabLabel.Size = UDim2.new(1, -50, 1, 0)
        tabLabel.Position = UDim2.new(0, 45, 0, 0)
        tabLabel.BackgroundTransparency = 1
        tabLabel.Text = tabName
        tabLabel.Font = Enum.Font.GothamBold
        tabLabel.TextSize = 13
        tabLabel.TextColor3 = #self.Tabs == 0 and window.Theme.text or window.Theme.textDim
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabLabel.ZIndex = 504
        tabLabel.Parent = tabBtn
        
        tab.Button = tabBtn
        tab.Icon = tabIcon
        tab.Label = tabLabel
        
        -- Tab Content
        local content = Instance.new("ScrollingFrame")
        content.Size = UDim2.new(1, -5, 1, 0)
        content.BackgroundTransparency = 1
        content.BorderSizePixel = 0
        content.ScrollBarThickness = 6
        content.ScrollBarImageColor3 = window.Theme.primary
        content.ScrollBarImageTransparency = 0.5
        content.CanvasSize = UDim2.new(0, 0, 0, 0)
        content.Visible = #self.Tabs == 0
        content.ZIndex = 503
        content.Parent = contentContainer
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 10)
        contentLayout.Parent = content
        
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            content.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
        end)
        
        tab.Content = content
        
        -- Tab switching with animation
        tabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(self.Tabs) do
                t.Content.Visible = false
                tween(t.Button, {BackgroundTransparency = 0.5}, 0.2)
                t.Icon.TextColor3 = window.Theme.textDim
                t.Label.TextColor3 = window.Theme.textDim
                local stroke = t.Button:FindFirstChild("UIStroke")
                if stroke then stroke:Destroy() end
            end
            
            content.Visible = true
            tween(tabBtn, {BackgroundTransparency = 0}, 0.2)
            tabIcon.TextColor3 = window.Theme.primary
            tabLabel.TextColor3 = window.Theme.tex
