-- Meme Sea Hub V8.0 - Solar UI Full Logic Edition
-- Giao diện đẹp, an toàn, tích hợp đầy đủ chức năng hack

-- 1. TẢI THƯ VIỆN SOLAR UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/moon-dev-1/Solar-Hub/main/source.lua"))()
local Window = Library:CreateWindow({
    Title = "Meme Sea Hub V8.0",
    Theme = "Dark",
    Size = UDim2.fromOffset(320, 420),
    Position = UDim2.fromOffset(15, 15)
})

-- 2. KHAI BÁO SERVICE & HÀM HỖ TRỢ
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local function getHRP(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") 
        or char:FindFirstChild("UpperTorso") 
        or char:FindFirstChild("Torso")
end

-- 3. TAB COMBAT (SILENT AIM + ESP)
local CombatTab = Window:AddTab("Combat")
local CombatSection = CombatTab:AddSection("Aim & ESP")

_G.SilentAim = false
_G.AimRange = 150
_G.ESPEnabled = false
local silentTarget = nil
local isFiring = false
local espCache = {}

-- Silent Aim Logic
task.spawn(function()
    while task.wait(0.2) do
        if not _G.SilentAim then 
            silentTarget = nil; continue 
        end
        local closestDist = math.huge; silentTarget = nil
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local targetHRP = getHRP(p.Character)
                local humanoid = p.Character:FindFirstChild("Humanoid")
                if targetHRP and humanoid and humanoid.Health > 0 then
                    local dist = (targetHRP.Position - Camera.CFrame.Position).Magnitude
                    if dist < closestDist and dist <= _G.AimRange then
                        closestDist = dist; silentTarget = p.Character
                    end
                end
            end
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isFiring = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isFiring = false
    end
end)

RunService.RenderStepped:Connect(function()
    -- Silent Aim
    if _G.SilentAim and silentTarget and silentTarget.Parent and isFiring then
        local targetHRP = getHRP(silentTarget)
        local myChar = LocalPlayer.Character
        if targetHRP and myChar then
            local tool = myChar:FindFirstChildWhichIsA("Tool")
            if tool and tool:FindFirstChild("Handle") then
                local headPos = targetHRP.Position + Vector3.new(0, 2, 0)
                tool.Handle.CFrame = CFrame.new(tool.Handle.Position, headPos)
            end
        end
    end
    
    -- ESP Logic
    if _G.ESPEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local head = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("UpperTorso")
                if head then
                    if not espCache[p.Name] then
                        local esp = Instance.new("BillboardGui")
                        esp.Name = "ESP_SolarV8"; esp.Size = UDim2.new(0, 80, 0, 20); esp.AlwaysOnTop = true; esp.Parent = head
                        local lbl = Instance.new("TextLabel")
                        lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.new(1,0,0)
                        lbl.TextStrokeTransparency = 0; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12; lbl.Parent = esp
                        espCache[p.Name] = {gui = esp, label = lbl}
                    end
                    local myHRP = getHRP(LocalPlayer.Character)
                    local targetHRP = getHRP(p.Character)
                    if myHRP and targetHRP and espCache[p.Name] then
                        local dist = math.floor((targetHRP.Position - myHRP.Position).Magnitude)
                        espCache[p.Name].label.Text = p.Name .. " [" .. dist .. "m]"
                    end
                end
            end
        end
    else
        for name, data in pairs(espCache) do
            if data.gui and data.gui.Parent then data.gui:Destroy() end
        end
        table.clear(espCache)
    end
end)

CombatSection:AddToggle({
    Name = "Silent Aim (FF Style)", Description = "Bắn đất vẫn headshot",
    Flag = "silent_aim", Default = false,
    Callback = function(Value) _G.SilentAim = Value; print("[V8.0] Silent Aim: " .. tostring(Value)) end
})
CombatSection:AddSlider({
    Name = "Aim Range", Description = "Tầm quét mục tiêu (m)",
    Flag = "aim_range", Min = 50, Max = 300, Default = 150, Rounding = 0,
    Callback = function(Value) _G.AimRange = Value end
})
CombatSection:AddToggle({
    Name = "ESP Player", Description = "Hiện tên + khoảng cách",
    Flag = "esp_player", Default = false,
    Callback = function(Value) _G.ESPEnabled = Value; print("[V8.0] ESP: " .. tostring(Value)) end
})

-- 4. TAB MOVEMENT (FLY + SPEED + NOCLIP)
local MoveTab = Window:AddTab("Movement")
local MoveSection = MoveTab:AddSection("Physics")

_G.FlyEnabled = false
_G.SpeedEnabled = false
_G.NoclipEnabled = false

local bodyPos = Instance.new("BodyPosition")
bodyPos.MaxForce = Vector3.new(math.huge, math.huge, math.huge); bodyPos.P = 10000; bodyPos.D = 1000
local bodyGyro = Instance.new("BodyGyro")
bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); bodyGyro.P = 10000
local speedThread = nil

RunService.RenderStepped:Connect(function()
    -- Fly Logic
    if _G.FlyEnabled and LocalPlayer.Character then
        local hrp = getHRP(LocalPlayer.Character)
        if hrp then
            local camDir = Camera.CFrame.LookVector; local camRight = Camera.CFrame.RightVector
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

RunService.Stepped:Connect(function()
    -- Noclip Logic
    if _G.NoclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

MoveSection:AddToggle({
    Name = "Fly Mode", Description = "Bay tự do (WASD + Space/Shift)",
    Flag = "fly_mode", Default = false,
    Callback = function(Value)
        _G.FlyEnabled = Value
        local char = LocalPlayer.Character; local hrp = getHRP(char)
        if char and hrp and char:FindFirstChild("Humanoid") then
            if Value then
                bodyPos.Parent = hrp; bodyGyro.Parent = hrp
                bodyPos.Position = hrp.Position; bodyGyro.CFrame = Camera.CFrame
                char.Humanoid.PlatformStand = true
            else
                bodyPos.Parent = nil; bodyGyro.Parent = nil
                char.Humanoid.PlatformStand = false
            end
        end
        print("[V8.0] Fly: " .. tostring(Value))
    end
})
MoveSection:AddToggle({
    Name = "Speed Force", Description = "Phá khóa tốc độ nhân vật",
    Flag = "speed_force", Default = false,
    Callback = function(Value)
        _G.SpeedEnabled = Value
        if Value then
            speedThread = task.spawn(function()
                while task.wait() do
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = 100 end
                end
            end)
        else
            if speedThread then task.cancel(speedThread); speedThread = nil end
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = 16 end
        end
        print("[V8.0] Speed: " .. tostring(Value))
    end
})
MoveSection:AddToggle({
    Name = "Noclip", Description = "Xuyên tường an toàn",
    Flag = "noclip", Default = false,
    Callback = function(Value) _G.NoclipEnabled = Value; print("[V8.0] Noclip: " .. tostring(Value)) end
})

-- 5. HOÀN TẤT
Library:SetWatermark("Meme Sea V8.0 | Solar UI Safe")
print("[V8.0] Full Logic Loaded Successfully!")
