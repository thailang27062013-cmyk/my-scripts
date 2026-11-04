-- Meme Sea Hack V7.1 - Fly/ESP/Speed Fix Only
-- Noclip giữ nguyên bản cũ, chỉ sửa 3 chức năng kia

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- === UI COMPACT (GIỮ NGUYÊN V6) ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MemeSeaV7_1"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 160, 0, 220)
MainFrame.Position = UDim2.new(0, 10, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 28)
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 8)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Position = UDim2.new(0, 8, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "V7.1 FlyFix"
TitleLabel.TextColor3 = Color3.new(1,1,1)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 24, 0, 24)
MinimizeBtn.Position = UDim2.new(1, -28, 0, 2)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.new(1,1,1)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
MinimizeBtn.Parent = TitleBar
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 4)

local MinimizedIcon = Instance.new("ImageButton")
MinimizedIcon.Size = UDim2.new(0, 40, 0, 40)
MinimizedIcon.Position = UDim2.new(0, 10, 0.5, -20)
MinimizedIcon.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MinimizedIcon.Visible = false
MinimizedIcon.Parent = ScreenGui
Instance.new("UICorner", MinimizedIcon).CornerRadius = UDim.new(1, 0)

local iconLabel = Instance.new("TextLabel")
iconLabel.Size = UDim2.new(1, 0, 1, 0)
iconLabel.BackgroundTransparency = 1
iconLabel.Text = "V7.1"
iconLabel.TextColor3 = Color3.new(1,1,1)
iconLabel.Font = Enum.Font.GothamBold
iconLabel.TextSize = 12
iconLabel.Parent = MinimizedIcon

MinimizeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; MinimizedIcon.Visible = true end)
MinimizedIcon.MouseButton1Click:Connect(function() MainFrame.Visible = true; MinimizedIcon.Visible = false end)

local ButtonContainer = Instance.new("ScrollingFrame")
ButtonContainer.Size = UDim2.new(1, -8, 1, -36)
ButtonContainer.Position = UDim2.new(0, 4, 0, 32)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ButtonContainer.ScrollBarThickness = 3
ButtonContainer.Parent = MainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 4)
layout.Parent = ButtonContainer

local function createButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = ButtonContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    btn.MouseButton1Click:Connect(function()
        callback(btn)
        btn.BackgroundColor3 = (btn.BackgroundColor3 == Color3.fromRGB(60, 60, 60)) and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 60)
    end)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
    end)
end

-- Drag Logic
local dragging, dragInput, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
TitleBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (input.Position - dragStart).X, startPos.Y.Scale, startPos.Y.Offset + (input.Position - dragStart).Y) end end)

-- === CHỨC NĂNG ĐÃ SỬA ===

-- 1. ESP FIX (Cập nhật khoảng cách real-time)
createButton("ESP", function(btn)
    local isOn = btn.BackgroundColor3 == Color3.fromRGB(0, 180, 0)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local esp = p.Character.Head:FindFirstChild("ESP_V7")
            if isOn then
                if not esp then
                    esp = Instance.new("BillboardGui"); esp.Name = "ESP_V7"; esp.Size = UDim2.new(0, 80, 0, 20); esp.AlwaysOnTop = true; esp.Parent = p.Character.Head
                    local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.new(1,0,0); lbl.TextStrokeTransparency = 0; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12; lbl.Parent = esp
                    
                    -- Cập nhật khoảng cách liên tục
                    game:GetService("RunService").RenderStepped:Connect(function()
                        if esp and esp.Parent and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = math.floor((p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                            lbl.Text = p.Name .. " [" .. dist .. "m]"
                        end
                    end)
                end
            else
                if esp then esp:Destroy() end
            end
        end
    end
end)

-- 2. SPEED FIX (An toàn hơn)
createButton("Speed", function(btn)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        local humanoid = char.Humanoid
        humanoid.WalkSpeed = (humanoid.WalkSpeed <= 20) and 100 or 16
    end
end)

-- 3. FLY FIX (BodyPosition + BodyGyro + PlatformStand)
local isFlying = false
local bodyPos = Instance.new("BodyPosition")
bodyPos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
bodyPos.P = 10000; bodyPos.D = 1000

local bodyGyro = Instance.new("BodyGyro")
bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
bodyGyro.P = 10000

createButton("Fly (Fixed)", function(btn)
    isFlying = not isFlying
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        local hrp = char.HumanoidRootPart
        if isFlying then
            bodyPos.Parent = hrp
            bodyGyro.Parent = hrp
            bodyPos.Position = hrp.Position
            bodyGyro.CFrame = Camera.CFrame
            char.Humanoid.PlatformStand = true -- Vô hiệu hóa animation đi bộ
        else
            bodyPos.Parent = nil
            bodyGyro.Parent = nil
            char.Humanoid.PlatformStand = false
        end
    end
end)

-- Điều khiển Fly theo hướng Camera
RunService.RenderStepped:Connect(function()
    if isFlying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local camDir = Camera.CFrame.LookVector
        local camRight = Camera.CFrame.RightVector
        
        local moveVec = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + camDir end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - camDir end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - camRight end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + camRight end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec = moveVec + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec = moveVec - Vector3.new(0,1,0) end
        
        if moveVec.Magnitude > 0 then
            bodyPos.Position = hrp.Position + moveVec.Unit * 2.5 -- Tốc độ bay
        end
        
        -- Luôn xoay người theo camera để tận dụng aimlock game
        bodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + camDir)
    end
end)

-- 4. TELEKILL (Giữ nguyên)
createButton("Telekill", function(btn)
    local closestDist = math.huge; local targetChar = nil
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if dist < closestDist then closestDist = dist; targetChar = p.Character end
        end
    end
    if targetChar and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end
end)

-- 5. NOCLIP (GIỮ NGUYÊN BẢN CŨ)
local isNoclip = false
createButton("Noclip", function(btn)
    isNoclip = not isNoclip
end)

RunService.Stepped:Connect(function()
    if isNoclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

print("Meme Sea Hack V7.1 Loaded! Fly & ESP Fixed.")
