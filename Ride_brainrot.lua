-- ============================================================
-- Ride Brainrot Script by Dhany (v2 - Tab GUI)
-- Game: Ride Brainrot for Brainrots by Losi Studio
-- Tabs: Main | Auto | Character
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- ============================================================
-- SETTINGS
-- ============================================================
local Settings = {
    -- Main
    ItemDupe       = false,
    AutoCollect    = false,
    AutoRide       = false,
    AutoWin        = false,
    -- Auto
    AutoRejoin     = false,
    AutoReady      = false,
    AutoFarm       = false,
    -- Character
    SpeedHack      = false,
    NoClip         = false,
    GodMode        = false,
    InfJump        = false,
    WalkSpeed      = 100,
    JumpPower      = 100,
    DupeDelay      = 0.1,
    CollectDelay   = 0.3,
}

-- ============================================================
-- UTILS
-- ============================================================
local function Notify(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Ride Brainrot Script",
            Text = msg,
            Duration = 3,
        })
    end)
end

local function SafeCall(fn)
    local ok, err = pcall(fn)
    if not ok then warn("[RideBrainrot] " .. tostring(err)) end
end

local function Tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

local function FindRemote(keyword)
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            if string.find(v.Name:lower(), keyword:lower()) then return v end
        end
    end
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            if string.find(v.Name:lower(), keyword:lower()) then return v end
        end
    end
    return nil
end

local function FireRemote(remote, ...)
    if not remote then return end
    SafeCall(function()
        if remote:IsA("RemoteEvent") then remote:FireServer(...)
        elseif remote:IsA("RemoteFunction") then remote:InvokeServer(...) end
    end)
end

-- ============================================================
-- MAIN FEATURES
-- ============================================================

-- ITEM DUPE
task.spawn(function()
    while true do
        task.wait(Settings.DupeDelay)
        if Settings.ItemDupe then
            SafeCall(function()
                local r = FindRemote("dupe") or FindRemote("duplicate")
                    or FindRemote("item") or FindRemote("give") or FindRemote("add")
                if r then
                    FireRemote(r)
                else
                    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                        if v:IsA("RemoteEvent") then
                            local n = v.Name:lower()
                            if string.find(n, "item") or string.find(n, "collect") or string.find(n, "pick") then
                                SafeCall(function() v:FireServer() end)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- AUTO COLLECT
task.spawn(function()
    while true do
        task.wait(Settings.CollectDelay)
        if Settings.AutoCollect then
            SafeCall(function()
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") or obj:IsA("Model") then
                        local n = obj.Name:lower()
                        if string.find(n, "brainrot") or string.find(n, "item")
                        or string.find(n, "pickup") or string.find(n, "coin")
                        or string.find(n, "gem") or string.find(n, "collect") then
                            local part = obj:IsA("Model") and
                                (obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart"))
                                or obj
                            if part and part ~= HumanoidRootPart then
                                HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 2, 0)
                                task.wait(0.05)
                            end
                        end
                    end
                end
                local r = FindRemote("collect") or FindRemote("pickup") or FindRemote("grab")
                if r then FireRemote(r) end
            end)
        end
    end
end)

-- AUTO RIDE
task.spawn(function()
    while true do
        task.wait(0.5)
        if Settings.AutoRide then
            SafeCall(function()
                local r = FindRemote("ride") or FindRemote("mount") or FindRemote("sit")
                if r then
                    FireRemote(r)
                else
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("Seat") or obj:IsA("VehicleSeat") then
                            obj:Sit(Humanoid)
                            task.wait(0.1)
                        end
                    end
                end
            end)
        end
    end
end)

-- AUTO WIN
task.spawn(function()
    while true do
        task.wait(0.5)
        if Settings.AutoWin then
            SafeCall(function()
                local r = FindRemote("win") or FindRemote("finish") or FindRemote("complete") or FindRemote("goal")
                if r then FireRemote(r) end
                -- Teleport ke finish line
                for _, obj in pairs(Workspace:GetDescendants()) do
                    local n = obj.Name:lower()
                    if string.find(n, "finish") or string.find(n, "goal") or string.find(n, "end") then
                        local part = obj:IsA("Model") and obj:FindFirstChildWhichIsA("BasePart") or obj
                        if part and part:IsA("BasePart") then
                            HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                            break
                        end
                    end
                end
            end)
        end
    end
end)

-- AUTO FARM
task.spawn(function()
    while true do
        task.wait(0.2)
        if Settings.AutoFarm then
            SafeCall(function()
                local r = FindRemote("farm") or FindRemote("reward") or FindRemote("cash")
                    or FindRemote("coin") or FindRemote("earn") or FindRemote("score")
                if r then FireRemote(r) end
            end)
        end
    end
end)

-- AUTO READY
task.spawn(function()
    while true do
        task.wait(1)
        if Settings.AutoReady then
            SafeCall(function()
                local r = FindRemote("ready") or FindRemote("start") or FindRemote("vote")
                if r then FireRemote(r) end
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                if playerGui then
                    for _, gui in pairs(playerGui:GetDescendants()) do
                        if gui:IsA("TextButton") or gui:IsA("ImageButton") then
                            local n = gui.Name:lower()
                            if string.find(n, "ready") or string.find(n, "start") or string.find(n, "play") then
                                gui.MouseButton1Click:Fire()
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- AUTO REJOIN
task.spawn(function()
    while true do
        task.wait(3)
        if Settings.AutoRejoin then
            SafeCall(function()
                if Humanoid.Health <= 0 then
                    TeleportService:Teleport(game.PlaceId, LocalPlayer)
                end
            end)
        end
    end
end)

-- ============================================================
-- CHARACTER FEATURES
-- ============================================================
local noClipConn
local function ApplyNoClip(active)
    if active then
        noClipConn = RunService.Stepped:Connect(function()
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        if noClipConn then noClipConn:Disconnect() noClipConn = nil end
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
    Notify("No Clip: " .. (active and "ON" or "OFF"))
end

local function ApplySpeedHack(active)
    SafeCall(function()
        Humanoid.WalkSpeed = active and Settings.WalkSpeed or 16
        Notify("Speed Hack: " .. (active and "ON" or "OFF"))
    end)
end

local godConn
local function ApplyGodMode(active)
    SafeCall(function()
        if active then
            Humanoid.MaxHealth = math.huge
            Humanoid.Health = math.huge
            godConn = RunService.Heartbeat:Connect(function()
                if Humanoid then Humanoid.Health = Humanoid.MaxHealth end
            end)
        else
            if godConn then godConn:Disconnect() godConn = nil end
            Humanoid.MaxHealth = 100
            Humanoid.Health = 100
        end
        Notify("God Mode: " .. (active and "ON" or "OFF"))
    end)
end

local infJumpConn
local function ApplyInfJump(active)
    if active then
        infJumpConn = UserInputService.JumpRequest:Connect(function()
            if Humanoid then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
        Humanoid.JumpPower = Settings.JumpPower
    else
        if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
        Humanoid.JumpPower = 50
    end
    Notify("Inf Jump: " .. (active and "ON" or "OFF"))
end

-- ============================================================
-- GUI SETUP
-- ============================================================
local OldGui = LocalPlayer.PlayerGui:FindFirstChild("RideBrainrotGUI")
if OldGui then OldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RideBrainrotGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 310, 0, 420)
MainFrame.Position = UDim2.new(0, 20, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 8, 18)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(160, 60, 255)
Stroke.Thickness = 1.5
Stroke.Transparency = 0.3

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 48)
Header.BackgroundColor3 = Color3.fromRGB(16, 10, 30)
Header.BorderSizePixel = 0
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 16)

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 16)
HeaderFix.Position = UDim2.new(0, 0, 1, -16)
HeaderFix.BackgroundColor3 = Color3.fromRGB(16, 10, 30)
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local Title = Instance.new("TextLabel")
Title.Text = "Ride Brainrot Script v2"
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 26, 0, 26)
MinBtn.Position = UDim2.new(1, -34, 0, 11)
MinBtn.BackgroundColor3 = Color3.fromRGB(30, 15, 50)
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16
MinBtn.TextColor3 = Color3.fromRGB(200, 100, 255)
MinBtn.BorderSizePixel = 0
MinBtn.Parent = MainFrame
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 36)
TabBar.Position = UDim2.new(0, 0, 0, 48)
TabBar.BackgroundColor3 = Color3.fromRGB(14, 10, 22)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabList = Instance.new("UIListLayout", TabBar)
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabList.VerticalAlignment = Enum.VerticalAlignment.Center
TabList.Padding = UDim.new(0, 4)

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, 0, 1, -84)
ContentArea.Position = UDim2.new(0, 0, 0, 84)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local Pages = {}
local TabBtns = {}

local function MakePage()
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Color3.fromRGB(160, 60, 255)
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.Visible = false
    Page.Parent = ContentArea

    local List = Instance.new("UIListLayout", Page)
    List.Padding = UDim.new(0, 7)
    List.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local Pad = Instance.new("UIPadding", Page)
    Pad.PaddingLeft = UDim.new(0, 12)
    Pad.PaddingRight = UDim.new(0, 12)
    Pad.PaddingTop = UDim.new(0, 8)
    Pad.PaddingBottom = UDim.new(0, 8)

    return Page
end

local function SwitchTab(name)
    for n, page in pairs(Pages) do page.Visible = (n == name) end
    for n, btn in pairs(TabBtns) do
        if n == name then
            Tween(btn, {BackgroundColor3 = Color3.fromRGB(130, 40, 220)}, 0.15)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            Tween(btn, {BackgroundColor3 = Color3.fromRGB(25, 15, 40)}, 0.15)
            btn.TextColor3 = Color3.fromRGB(160, 100, 220)
        end
    end
end

local function MakeTabBtn(name, label)
    Pages[name] = MakePage()
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 88, 0, 28)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 15, 40)
    Btn.Text = label
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Btn.TextColor3 = Color3.fromRGB(160, 100, 220)
    Btn.BorderSizePixel = 0
    Btn.Parent = TabBar
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    TabBtns[name] = Btn
    Btn.MouseButton1Click:Connect(function() SwitchTab(name) end)
end

MakeTabBtn("main",      "Main")
MakeTabBtn("auto",      "Auto")
MakeTabBtn("character", "Character")

local function MakeToggle(page, labelText, settingKey, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 46)
    Row.BackgroundColor3 = Color3.fromRGB(16, 12, 26)
    Row.BorderSizePixel = 0
    Row.Parent = Pages[page]
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 10)

    local Label = Instance.new("TextLabel")
    Label.Text = labelText
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.new(0, 14, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextColor3 = Color3.fromRGB(210, 180, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(0, 44, 0, 22)
    Track.Position = UDim2.new(1, -54, 0.5, -11)
    Track.BackgroundColor3 = Color3.fromRGB(40, 25, 60)
    Track.BorderSizePixel = 0
    Track.Parent = Row
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = UDim2.new(0, 3, 0.5, -8)
    Knob.BackgroundColor3 = Color3.fromRGB(120, 60, 180)
    Knob.BorderSizePixel = 0
    Knob.Parent = Track
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local state = Settings[settingKey]

    local function Refresh()
        if state then
            Tween(Track, {BackgroundColor3 = Color3.fromRGB(140, 50, 240)}, 0.15)
            Tween(Knob, {Position = UDim2.new(0, 25, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
            Tween(Row, {BackgroundColor3 = Color3.fromRGB(22, 14, 36)}, 0.15)
        else
            Tween(Track, {BackgroundColor3 = Color3.fromRGB(40, 25, 60)}, 0.15)
            Tween(Knob, {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.fromRGB(120, 60, 180)}, 0.15)
            Tween(Row, {BackgroundColor3 = Color3.fromRGB(16, 12, 26)}, 0.15)
        end
    end
    Refresh()

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.Parent = Row

    Btn.MouseButton1Click:Connect(function()
        state = not state
        Settings[settingKey] = state
        Refresh()
        if callback then SafeCall(function() callback(state) end) end
        Notify(labelText .. ": " .. (state and "ON" or "OFF"))
    end)
end

local function MakeLabel(page, text)
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, 0, 0, 22)
    Lbl.BackgroundTransparency = 1
    Lbl.Font = Enum.Font.GothamBold
    Lbl.TextSize = 11
    Lbl.TextColor3 = Color3.fromRGB(160, 80, 255)
    Lbl.Text = text
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = Pages[page]
    local Pad = Instance.new("UIPadding", Lbl)
    Pad.PaddingLeft = UDim.new(0, 6)
end

-- MAIN TAB
MakeLabel("main", "Game Cheats")
MakeToggle("main", "Item Dupe",    "ItemDupe",    function(v) end)
MakeToggle("main", "Auto Collect", "AutoCollect", function(v) end)
MakeToggle("main", "Auto Ride",    "AutoRide",    function(v) end)
MakeToggle("main", "Auto Win",     "AutoWin",     function(v) end)

-- AUTO TAB
MakeLabel("auto", "Automation")
MakeToggle("auto", "Auto Farm",   "AutoFarm",   function(v) end)
MakeToggle("auto", "Auto Ready",  "AutoReady",  function(v) end)
MakeToggle("auto", "Auto Rejoin", "AutoRejoin", function(v) end)

-- CHARACTER TAB
MakeLabel("character", "Movement")
MakeToggle("character", "Speed Hack", "SpeedHack", ApplySpeedHack)
MakeToggle("character", "Inf Jump",   "InfJump",   ApplyInfJump)
MakeToggle("character", "No Clip",    "NoClip",    ApplyNoClip)
MakeLabel("character", "Survival")
MakeToggle("character", "God Mode",   "GodMode",   ApplyGodMode)

-- MINIMIZE + DRAG
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    TabBar.Visible = not minimized
    ContentArea.Visible = not minimized
    Tween(MainFrame, {Size = UDim2.new(0, 310, 0, minimized and 48 or 420)}, 0.25)
    MinBtn.Text = minimized and "+" or "-"
end)

local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

SwitchTab("main")
Notify("Ride Brainrot Script v2 Ready!")
