-- === LOGIC FLY V9.1: ALIGNPOSITION STABLE FIX ===
_G.FlyEnabled = false

-- Tạo AlignPosition & AlignOrientation (Cơ chế vật lý mới, ổn định hơn BodyVelocity)
local alignPos = Instance.new("AlignPosition")
alignPos.MaxForce = 40000
alignPos.Responsiveness = 25 -- Độ nhạy phản hồi (cao = bám sát input ngay lập tức)
alignPos.RigidityEnabled = false

local alignOri = Instance.new("AlignOrientation")
alignOri.MaxTorque = 40000
alignOri.Responsiveness = 25

-- Attachment gốc gắn vào HRP
local att0 = Instance.new("Attachment")
att0.Name = "FlyAtt0"

-- Attachment đích (di chuyển theo hướng nhìn camera)
local att1 = Instance.new("Attachment")
att1.Name = "FlyAtt1"

RunService.RenderStepped:Connect(function()
    if _G.FlyEnabled and LocalPlayer.Character then
        local hrp = getHRP(LocalPlayer.Character)
        if hrp then
            -- Gán attachment nếu chưa có
            if not hrp:FindFirstChild("FlyAtt0") then att0.Parent = hrp end
            if not alignPos.Attachment0 then 
                alignPos.Attachment0 = att0 
                alignPos.Attachment1 = att1 
                alignPos.Parent = hrp 
                alignOri.Attachment0 = att0 
                alignOri.Attachment1 = att1 
                alignOri.Parent = hrp 
            end
            
            -- Bật PlatformStand chống animation đi bộ làm giật cục
            LocalPlayer.Character.Humanoid.PlatformStand = true
            
            -- Tính toán vị trí đích dựa trên hướng nhìn camera
            local camCFrame = Camera.CFrame
            local lookVec = camCFrame.LookVector
            local rightVec = camCFrame.RightVector
            
            local moveDir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + lookVec end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - lookVec end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - rightVec end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + rightVec end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            
            -- Cập nhật vị trí attachment đích
            -- Nhân với 50 để tạo khoảng cách đủ lớn, AlignPosition sẽ tự kéo nhân vật đến đó mượt mà
            att1.WorldPosition = hrp.Position + moveDir.Unit * 50
            
            -- Xoay người theo hướng nhìn camera
            att1.WorldCFrame = CFrame.new(att1.WorldPosition, hrp.Position + lookVec)
            
        end
    else
        -- Tắt Fly: Gỡ attachment và恢复 PlatformStand
        if alignPos.Parent then
            alignPos.Parent = nil
            alignOri.Parent = nil
            att0.Parent = nil
            att1.Parent = nil
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.PlatformStand = false
            end
        end
    end
end)
