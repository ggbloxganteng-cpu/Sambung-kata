-- Fish and Monster - Instant Fishing + Teleport

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local network = rs:WaitForChild("Modules"):WaitForChild("Utility"):WaitForChild("Network"):WaitForChild("Events"):WaitForChild("RemoteEvent")

local autoInstant = false

-- Koordinat Teleport
local mainPos = CFrame.new(137, 405, -359)
local blinkPos = CFrame.new(0, 405, 0)

local sg = Instance.new("ScreenGui")
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = sg

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,50)
title.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
title.Text = "🎣 INSTANT + TELEPORT"
title.TextColor3 = Color3.fromRGB(0,0,0)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1,-30,0,60)
btn.Position = UDim2.new(0,15,0,70)
btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
btn.Text = "START INSTANT + TP"
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.TextScaled = true
btn.Font = Enum.Font.GothamBold
btn.Parent = frame

btn.MouseButton1Click:Connect(function()
    autoInstant = not autoInstant
    btn.Text = autoInstant and "INSTANT + TP (ON)" or "START INSTANT + TP"
    
    if autoInstant then
        spawn(function()
            while autoInstant do
                -- Cast
                network:FireServer("CastFishingLine", 0.9987221360206604)
                wait(0.1)

                -- Reel Complete
                network:FireServer("FishingReelComplete", Vector3.new(126.2335, 398.0111, -264.304))
                wait(0.1)

                -- Teleport Blink
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local root = player.Character.HumanoidRootPart
                    root.CFrame = mainPos
                    wait(0.05)
                    root.CFrame = blinkPos
                    wait(0.05)
                    root.CFrame = mainPos   -- Kembali ke posisi utama
                end

                wait(0.2)
            end
        end)
    end
end)

print("✅ Script Instant + Teleport Loaded!")
print("Klik tombol untuk mulai")
