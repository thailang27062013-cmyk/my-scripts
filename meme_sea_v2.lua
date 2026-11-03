-- Meme Sea Auto Farm V2 - Optimized for Delta
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Library.CreateLib("Meme Sea Hub V2", "DarkTheme")
local FarmTab = Window:NewTab("Auto Farm")
local FarmSection = FarmTab:NewSection("Cài đặt Farm")

local isFarming = false
local farmSpeed = 0.5

FarmSection:NewToggle("AutoFarmToggle", "Bật Auto Farm", function(state)
    isFarming = state
    print("[System] Trạng thái Farm: " .. tostring(state))
end)

FarmSection:NewSlider("FarmSpeed", "Tốc độ Farm (giây)", 500, 0.5, function(s) 
    farmSpeed = s / 100 
end)

FarmSection:NewButton("Teleport Spawn", "Về điểm xuất phát", function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        print("[System] Đã dịch chuyển về Spawn!")
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if isFarming then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(char.HumanoidRootPart.Position + Vector3.new(0, 10, 0))
            wait(farmSpeed)
        end
    end
end)

InterfaceManager:SetFolder("MemeSeaHub")
SaveManager:SetFolder("MemeSeaHub/saves")
SaveManager:BuildConfigSection(FarmTab)
InterfaceManager:BuildInterfaceSection(FarmTab)
