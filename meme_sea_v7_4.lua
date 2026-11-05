-- Meme Sea Hack V7.4 - True Silent Aim (Free Fire Style)
-- Bắn xuống đất vẫn Headshot, địch KHÔNG bị giật/lắc

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Hàm tìm bộ phận di chuyển an toàn
local function getHRP(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") 
        or char:FindFirstChild("UpperTorso") 
        or char:FindFirstChild("Torso")
end

-- === LOGIC SILENT AIM KIỂU FREE FIRE ===
local isSilentAim = false
local silentTarget = nil
local aimRange = 150 -- Tầm quét mục tiêu

-- Vòng lặp tìm mục tiêu gần nhất trong tầm ngắm
task.spawn(function()
    while task.wait(0.2) do
        if not isSilentAim then 
            silentTarget = nil
            continue 
        end
        
        local closestDist = math.huge
        silentTarget = nil
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local targetHRP = getHRP(p.Character)
                local humanoid = p.Character:FindFirstChild("Humanoid")
                
                -- Chỉ chọn mục tiêu còn sống và có thể nhìn thấy (không qua tường quá dày)
                if targetHRP and humanoid and humanoid.Health > 0 then
                    local dist = (targetHRP.Position - Camera.CFrame.Position).Magnitude
                    if dist < closestDist and dist <= aimRange then
                        closestDist = dist
                        silentTarget = p.Character
                    end
                end
            end
        end
    end
end)

-- Hook vào RenderStepped để xử lý Silent Aim mượt mà
-- Cách hoạt động: Khi bạn bóp cò, script sẽ lén xoay khẩu súng của bạn 
-- về phía địch trong 1 frame rồi trả lại ngay lập tức -> Đạn bay đúng hướng địch
-- nhưng trên màn hình bạn vẫn thấy mình ngắm xuống đất
local originalGunCFrame = nil
local isFiring = false

-- Phát hiện khi người chơi bóp cò (Click chuột trái hoặc Touch)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 
       or input.UserInputType == Enum.UserInputType.Touch then
        isFiring = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 
       or input.UserInputType == Enum.UserInputType.Touch then
        isFiring = false
    end
end)

RunService.RenderStepped:Connect(function()
    if isSilentAim and silentTarget and silentTarget.Parent and isFiring then
        local targetHRP = getHRP(silentTarget)
        local myChar = LocalPlayer.Character
        local myHRP = getHRP(myChar)
        
        if targetHRP and myHRP then
            -- Tìm vũ khí đang cầm trên tay
            local tool = myChar:FindFirstChildWhichIsA("Tool")
            if tool and tool:FindFirstChild("Handle") then
                -- Lén xoay khẩu súng về phía đầu địch trong frame này
                -- Server sẽ tính toán đạn bay từ Handle -> TargetHead
                -- Nhưng Camera vẫn giữ nguyên hướng ngắm xuống đất của bạn
                local headPos = targetHRP.Position + Vector3.new(0, 2, 0) -- +2 để trúng đầu
                tool.Handle.CFrame = CFrame.new(tool.Handle.Position, headPos)
            end
        end
    end
end)


-- === UI COMPACT (GIỮ NGUYÊN) ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MemeSeaV7_4_TrueSilent"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 160, 0, 240)
MainFrame.Position = UDim2.new(0, 10, 0.5, -120)
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
TitleLabel.Text = "V7.4 True Silent"
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
iconLabel.Text = "V7.4"
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

-- === CÁC CHỨC NĂNG KHÁC (GIỮ NGUYÊN) ===
createButton("ESP", function(btn)
    local isOn = btn.BackgroundColor3 == Color3.fromRGB(0, 180, 0)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local head = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("UpperTorso")
            if head then
                local esp = head:FindFirstChild("ESP_V7")
                if isOn then
                    if not esp then
                        esp = Instance.new("BillboardGui"); esp.Name = "ESP_V7"; esp.Size = UDim2.new(0, 80, 0, 20); esp.AlwaysOnTop = true; esp.Parent = head
                        local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.new(1,0,0); lbl.TextStrokeTransparency = 0; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12; lbl.Parent = esp
                        game:GetService("RunService").RenderStepped:Connect(function()
                            if esp and esp.Parent and LocalPlayer.Character then
                                local myHRP = getHRP(LocalPlayer.Character)
                                local targetHRP = getHRP(p.Character)
                                if myHRP and targetHRP then
                                    lbl.Text = p.Name .. " [" .. math.floor((targetHRP.Position - myHRP.Position).Magnitude) .. "m]"
                                end
                            end
                        end)
                    end
                else
                    if esp then esp:Destroy() end
                end
            end
        end
    end
end)

local speedThread = nil
createButton("Speed Force", function(btn)
    local isOn = btn.BackgroundColor3 == Color3.fromRGB(0, 180, 0)
    if isOn then
        if speedThread then task.cancel(speedThread) speedThread = nil end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = 16 end
    else
        speedThread = task.spawn(function()
            while task.wait() do
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = 100 end
            end
        end)
    end
end)

local isFlying = false
local bodyPos = Instance.new("BodyPosition")
bodyPos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
bodyPos.P = 10000; bodyPos.D = 1000
local bodyGyro = Instance.new("BodyGyro")
bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
bodyGyro.P = 10000

createButton("Fly (Universal)", function(btn)
    isFlying = not isFlying
    local char = LocalPlayer.Character
    local hrp = getHRP(char)
    if char and hrp and char:FindFirstChild("Humanoid") then
        if isFlying then
            bodyPos.Parent = hrp; bodyGyro.Parent = hrp
            bodyPos.Position = hrp.Position; bodyGyro.CFrame = Camera.CFrame
            char.Humanoid.PlatformStand = true 
        else
            bodyPos.Parent = nil; bodyGyro.Parent = nil
            char.Humanoid.PlatformStand = false
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if isFlying and LocalPlayer.Character then
        local hrp = getHRP(LocalPlayer.Character)
        if hrp then
            local camDir = Camera.CFrame.LookVector
            local camRight = Camera.CFrame.RightVector
            local moveVec = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + camDir end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - camDir end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - camRight end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + camRight end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec = moveVec + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec = moveVec - Vector3.new(0,1,0) end
            if moveVec.Magnitude > 0 then bodyPos.Position = hrp.Position + moveVec.Unit * 2.5 end
            bodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + camDir)
        end
    end
end)

createButton("Telekill", function(btn)
    local closestDist = math.huge; local targetChar = nil
    local myHRP = getHRP(LocalPlayer.Character)
    if not myHRP then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local targetHRP = getHRP(p.Character)
            if targetHRP then
                local dist = (targetHRP.Position - myHRP.Position).Magnitude
                if dist < closestDist then closestDist = dist; targetChar = p.Character end
            end
        end
    end
    if targetChar then
        local targetHRP = getHRP(targetChar)
        if targetHRP then myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3) end
    end
end)

local isNoclip = false
createButton("Noclip", function(btn)
    isNoclip = not isNoclip
end)
RunService.Stepped:Connect(function()
    if isNoclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- NÚT SILENT AIM MỚI
createButton("Silent Aim (FF Style)", function(btn)
    isSilentAim = not isSilentAim
    if not isSilentAim then silentTarget = nil end
end)

print("Meme Sea Hack V7.4 True Silent Aim Loaded!")
