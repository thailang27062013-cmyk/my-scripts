-- 1. Tải thư viện Orion UI (Đẹp, mượt, tối ưu cho di động)
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

-- 2. Tạo Cửa số Menu chính
local Window = OrionLib:MakeWindow({
    Name = "My Custom Hub", 
    HidePremium = true, 
    SaveConfig = false, 
    ConfigFolder = "MyScriptConfig",
    IntroText = "Đang tải Menu..."
})

-- 3. Tạo Tab chính
local MainTab = Window:MakeTab({
    Name = "Tính Năng",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- 4. Thêm các mục điều khiển (Button, Toggle, Slider)

-- Nút bấm thực thi lệnh (Button)
MainTab:AddButton({
    Name = "In lời chào",
    Callback = function()
        print("Script đã chạy thành công trên Delta!")
    end    
})

-- Công tắc Bật/Tắt (Toggle)
MainTab:AddToggle({
    Name = "Tự động căn chỉnh (AimAssist)",
    Default = false,
    Callback = function(Value)
        _G.AimEnabled = Value
        if Value then
            print("Trạng thái Aim: BẬT")
        else
            print("Trạng thái Aim: TẮT")
        end
    end    
})

-- Thanh trượt điều chỉnh chỉ số (Slider)
MainTab:AddSlider({
    Name = "Độ nhạy Aim (Smoothness)",
    Min = 1,
    Max = 100,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Đơn vị",
    Callback = function(Value)
        _G.AimSmooth = Value
        print("Độ mượt hiện tại:", Value)
    end    
})

-- 5. Khởi tạo hoàn tất Menu
OrionLib:Init()
