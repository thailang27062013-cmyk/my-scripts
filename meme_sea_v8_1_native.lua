-- Meme Sea Hub V8.1 - Native Safe UI (No External Downloads)
-- Giao diện đẹp, nhẹ, tương thích mọi game, không cần tải thư viện

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- === HÀM HỖ TRỢ ===
local function getHRP(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") 
        or char:FindFirstChild("UpperTorso") 
        or char:FindFirstChild("Torso")
end

-- === GIAO DIỆN NATIVE SAFE UI ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MemeSeaV8_1_Native"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Khung chính
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0, 15, 0, 15)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(60, 60, 60); Instance.new("UIStroke", MainFrame).Thickness = 1

-- Thanh tiêu đề
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -70, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Meme Sea Hub V8.1"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Nút thu nhỏ
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 2)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.new(1,1,1)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 20
MinimizeBtn.Parent = TitleBar
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

-- Icon khi thu nhỏ
local MinimizedIcon = Instance.new("ImageButton")
MinimizedIcon.Size = UDim2.new(0, 45, 0, 45)
MinimizedIcon.Position = UDim2.new(0, 15, 0.5, -22)
MinimizedIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MinimizedIcon.Visible = false
MinimizedIcon.Parent = ScreenGui
Instance.new("UICorner", MinimizedIcon).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", MinimizedIcon).Color = Color3.fromRGB(200, 150, 50); Instance.new("UIStroke", MinimizedIcon).Thickness = 2

local iconLabel = Instance.new("TextLabel")
iconLabel.Size = UDim2.new(1, 0, 1, 0)
iconLabel.BackgroundTransparency = 1
iconLabel.Text = "V8.1"
iconLabel.TextColor3 = Color3.new(1,1,1)
iconLabel.Font = Enum.Font.GothamBold
iconLabel.TextSize = 12
iconLabel.Parent = MinimizedIcon

MinimizeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; MinimizedIcon.Visible = true end)
MinimizedIcon.MouseButton1Click:Connect(function() MainFrame.Visible = true; MinimizedIcon.Visible = false end)

-- Khu chứa nội dung (Scrolling)
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -10, 1, -45)
ContentFrame.Position = UDim2.new(0, 5, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.ScrollBarThickness = 4
ContentFrame.Parent = MainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = ContentFrame

-- Hàm tạo Toggle
local function createToggle(name, desc, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.Parent = ContentFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 0, 25)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -50, 0, 15)
    descLabel.Position = UDim2.new(0, 10, 0, 30)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc
    descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 11
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = container
    
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 40, 0, 22)
    toggleBg.Position = UDim2.new(1, -45, 0.5, -11)
    toggleBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleBg.Parent = container
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)
    
    local toggleKnob = Instance.new("Frame")
    toggleKnob.Size = UDim2.new(0, 18, 0, 18)
    toggleKnob.Position = UDim2.new(0, 2, 0.5, -9)
    toggleKnob.BackgroundColor3 = Color3.new(1,1,1)
    toggleKnob.Parent = toggleBg
    Instance.new("UICorner", toggleKnob).CornerRadius = UDim.new(1, 0)
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = container
    
    local isOn = default
    local function updateVisual()
        toggleBg.BackgroundColor3 = isOn and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 60)
        toggleKnob.Position = UDim2.new(0, isOn and 20 or 2, 0.5, -9)
    end
    updateVisual()
    
    btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        updateVisual()
        callback(isOn)
    end)
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 16)
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

-- === LOGIC HACK TÍCH HỢP SẴN ===

-- 1. SILENT AIM
_G.SilentAim = false
local silentTarget = nil
local isFiring = false
task.spawn(function()
    while task.wait(0.2) do
        if not _G.SilentAim then silentTarget = nil; continue end
        local closestDist = math.huge; silentTarget = nil
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local tHRP = getHRP(p.Character)
                local hum = p.Character:FindFirstChild("Humanoid")
                if tHRP and hum and hum.Health > 0 then
                    local dist = (tHRP.Position - Camera.CFrame.Position).Magnitude
                    if dist < closestDist and dist <= 150 then closestDist = dist; silentTarget = p.Character end
                end
            end
        end
    end
end)
UserInputService.InputBegan:Connect(function(i, p) if not p and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then isFiring = true end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then isFiring = false end end)
RunService.RenderStepped:Connect(function()
    if _G.SilentAim and silentTarget and silentTarget.Parent and isFiring then
        local tHRP = getHRP(silentTarget)
        local myChar = LocalPlayer.Character
        if tHRP and myChar then
            local tool = myChar:FindFirstChildWhichIsA("Tool")
            if tool and tool:FindFirstChild("Handle") then
                tool.Handle.CFrame = CFrame.new(tool.Handle.Position, tHRP.Position + Vector3.new(0, 2, 0))
            end
        end
    end
end)

-- 2. ESP
_G.ESPEnabled = false
local espCache = {}
RunService.RenderStepped:Connect(function()
    if _G.ESPEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local head = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("UpperTorso")
                if head then
                    if not espCache[p.Name] then
                        local esp = Instance.new("BillboardGui"); esp.Name = "ESP_V8_1"; esp.Size = UDim2.new(0, 80, 0, 20); esp.AlwaysOnTop = true; esp.Parent = head
                        local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.new(1,0,0); lbl.TextStrokeTransparency = 0; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12; lbl.Parent = esp
                        espCache[p.Name] = {gui = esp, label = lbl}
                    end
                    local myHRP = getHRP(LocalPlayer.Character); local tHRP = getHRP(p.Character)
                    if myHRP and tHRP and espCache[p.Name] then
                        espCache[p.Name].label.Text = p.Name .. " [" .. math.floor((tHRP.Position - myHRP.Position).Magnitude) .. "m]"
                    end
                end
            end
        end
    else
        for _, d in pairs(espCache) do if d.gui and d.gui.Parent then d.gui:Destroy() end end
        table.clear(espCache)
    end
end)

-- 3. FLY
_G.FlyEnabled = false
local bodyPos = Instance.new("BodyPosition"); bodyPos.MaxForce = Vector3.new(math.huge,math.huge,math.huge); bodyPos.P=10000; bodyPos.D=1000
local bodyGyro = Instance.new("BodyGyro"); bodyGyro.MaxTorque = Vector3.new(math.huge,math.huge,math.huge); bodyGyro.P=10000
RunService.RenderStepped:Connect(function()
    if _G.FlyEnabled and LocalPlayer.Character then
        local hrp = getHRP(LocalPlayer.Character)
        if hrp then
            local cd = Camera.CFrame.LookVector; local cr = Camera.CFrame.RightVector; local mv = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then mv = mv + cd end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then mv = mv - cd end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then mv = mv - cr end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then mv = mv + cr end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then mv = mv + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then mv = mv - Vector3.new(0,1,0) end
            if mv.Magnitude > 0 then bodyPos.Position = hrp.Position + mv.Unit * 2.5 end
            bodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + cd)
        end
    end
end)

-- 4. SPEED
_G.SpeedEnabled = false
local speedThread = nil
local function toggleSpeed(val)
    if val then
        speedThread = task.spawn(function() while task.wait() do local c=LocalPlayer.Character; if c and c:FindFirstChild("Humanoid") then c.Humanoid.WalkSpeed=100 end end end)
    else
        if speedThread then task.cancel(speedThread); speedThread=nil end
        local c=LocalPlayer.Character; if c and c:FindFirstChild("Humanoid") then c.Humanoid.WalkSpeed=16 end
    end
end

-- 5. NOCLIP
_G.NoclipEnabled = false
RunService.Stepped:Connect(function()
    if _G.NoclipEnabled and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
    end
end)

-- === TẠO CÁC NÚT TRÊN MENU ===
createToggle("Silent Aim (FF Style)", "Bắn đất vẫn headshot", false, function(v) _G.SilentAim=v end)
createToggle("ESP Player", "Hiện tên + khoảng cách", false, function(v) _G.ESPEnabled=v end)
createToggle("Fly Mode", "Bay tự do WASD+Space/Shift", false, function(v)
    _G.FlyEnabled=v
    local c=LocalPlayer.Character; local h=getHRP(c)
    if c and h and c:FindFirstChild("Humanoid") then
        if v then bodyPos.Parent=h; bodyGyro.Parent=h; bodyPos.Position=h.Position; bodyGyro.CFrame=Camera.CFrame; c.Humanoid.PlatformStand=true
        else bodyPos.Parent=nil; bodyGyro.Parent=nil; c.Humanoid.PlatformStand=false end
    end
end)
createToggle("Speed Force", "Phá khóa tốc độ nhân vật", false, function(v) _G.SpeedEnabled=v; toggleSpeed(v) end)
createToggle("Noclip", "Xuyên tường an toàn", false, function(v) _G.NoclipEnabled=v end)

print("[V8.1 Native] Loaded Successfully! No external downloads needed.")
