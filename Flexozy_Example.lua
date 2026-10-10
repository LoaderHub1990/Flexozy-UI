getgenv().Flexozy_Config = {
    Title      = "Flexozy",
    SubTitle   = "Blox Fruits | ทะเลที่สอง",
    Monogram   = "FX",
    Size       = Vector2.new(720, 520),
    ToggleKey  = Enum.KeyCode.RightControl,
    StatsPill  = true,
    UIScale    = 1,
    Accent     = "Violet",
    ConfigName = "default",
    Language   = "EN",
    LanguageScope = "All",
}
local Flexozy = loadstring(game:HttpGet("https://raw.githubusercontent.com/USER/REPO/main/FlexozyUI.lua"))()
local Cfg = getgenv().Flexozy_Config
local Win = Flexozy:CreateWindow({
    Title = Cfg.Title, SubTitle = Cfg.SubTitle, Monogram = Cfg.Monogram,
    Size = Cfg.Size, ToggleKey = Cfg.ToggleKey, StatsPill = Cfg.StatsPill,
    Accent = Cfg.Accent, ConfigName = Cfg.ConfigName,
    Language = Cfg.Language, LanguageScope = Cfg.LanguageScope,
})
if Cfg.UIScale and Cfg.UIScale ~= 1 then Win:SetUIScale(Cfg.UIScale) end

Win:AddTranslations({
    ["Level/Quest Farm"] = "ฟาร์มเลเวล/เควส",
    ["Level and quest automation"] = "ระบบฟาร์มเลเวลและเควสอัตโนมัติ",
    ["Farm Settings"] = "ตั้งค่าฟาร์ม",
    ["Auto Farm Level"] = "ฟาร์มเลเวลอัตโนมัติ",
    ["Farm Method"] = "รูปแบบการฟาร์ม",
    ["Normal"] = "ปกติ",
    ["Fast"] = "เร็ว",
    ["Safe"] = "ปลอดภัย",
    ["Distance"] = "ระยะห่าง",
    ["Tuning"] = "ปรับแต่ง",
    ["Do Something"] = "ทำอะไรสักอย่าง",
})
Win:Section("Main Menu")
local Home = Win:Tab({ Title = "Home", Subtitle = "Overview and server info", Icon = Flexozy.Icons.Grid })
Win:BuildHome(Home)
Win:Section("Auto Farm")
local Level = Win:Tab({ Title = "Level/Quest Farm", Subtitle = "Level and quest automation", Icon = Flexozy.Icons.Sword })
local g = Level:Group("Farm Settings", "Left")
g:Toggle("Auto Farm Level", "คำอธิบายใต้ชื่อ", false, function(on)
    print("Auto Farm:", on)
end, "AutoFarm")
g:Dropdown("Farm Method", { "Normal", "Fast", "Safe" }, "Normal", function(v)
    print("Method:", v)
end, "FarmMethod")
local weapons = g:Dropdown({
    Title = "Weapons", Options = { "Melee", "Sword", "Fruit", "Gun" }, Default = { "Melee" },
    Multi = true, Flag = "Weapons",
    Callback = function(list) print("Weapons:", table.concat(list, ", ")) end,
})
g:Divider()
g:Keybind({
    Title = "Quick toggle farm", Default = Enum.KeyCode.F, Flag = "FarmKey",
    Callback = function(k) print("กดปุ่ม", k.Name) end,
})
local g2 = Level:Group("Tuning", "Right")
g2:Slider("Distance", 5, 50, 15, "studs", function(v) print("Distance:", v) end, 1, "Distance")
g2:Slider({ Title = "Attack Delay", Min = 0, Max = 1, Step = 0.05, Default = 0.2, Suffix = "s", Flag = "AtkDelay",
    Callback = function(v) print("Delay:", v) end })
g2:Input("Target name", "พิมพ์ชื่อ แล้วกด Enter", "", function(text) print("Target:", text) end, "Target")
g2:Button("Do Something", "คำอธิบายปุ่ม", function()
    Win:Notify({ Title = "Flexozy", Content = "Clicked!", Type = "Success" })
end)
local Misc = Win:Tab({ Title = "Misc", Subtitle = "Notifications and dynamic lists", Icon = Flexozy.Icons.Zap })
local n = Misc:Group("Notifications", "Left")
n:Button("Info", nil, function() Win:Notify({ Title = "Info", Content = "ข้อความทั่วไป" }) end)
n:Button("Success", nil, function() Win:Notify({ Title = "Success", Content = "สำเร็จ", Type = "Success" }) end)
n:Button("Warning", nil, function() Win:Notify({ Title = "Warning", Content = "ระวัง", Type = "Warning" }) end)
n:Button("Error", nil, function() Win:Notify({ Title = "Error", Content = "ผิดพลาด", Type = "Error", Duration = 5 }) end)
local d = Misc:Group("Dynamic dropdown", "Right")
local plist = d:Dropdown("Players", {}, nil, function(name) print("เลือก:", name) end)
local function refreshPlayers()
    local names = {}
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do table.insert(names, p.Name) end
    plist.Refresh(names)
end
refreshPlayers()
d:Button("Refresh players", "อัปเดตรายชื่อผู้เล่นในเซิร์ฟ", refreshPlayers)
local info = d:Label("Label ตัวนี้เปลี่ยนข้อความได้ด้วย .Set(...)")
d:Button("Change label", nil, function() info.Set("เปลี่ยนแล้ว: " .. os.date("%H:%M:%S")) end)
Win:Section("Extra Features")
local Set = Win:Tab({ Title = "Settings", Subtitle = "Interface options", Icon = Flexozy.Icons.Settings })
Win:BuildSettings(Set)
Win:LoadConfig()
Win:Notify({ Title = Cfg.Title, Content = "UI loaded  |  กด " .. Win.Key.Name .. " เพื่อซ่อน/แสดง", Type = "Success" })
