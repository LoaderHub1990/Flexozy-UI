--[[
    Flexozy UI - ตัวอย่างสคริปต์ (ใช้ครบทุกฟีเจอร์ใหม่)
    โหลดไลบรารีจาก GitHub (LoaderHub1990/Flexozy-UI) แล้วสร้างหน้าต่างตัวอย่าง
]]

local Flexozy = loadstring(game:HttpGet("https://raw.githubusercontent.com/LoaderHub1990/Flexozy-UI/refs/heads/main/FlexozyUI.lua"))()

local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")
local LP      = Players.LocalPlayer

local jumpConn -- เก็บ connection ไว้ปิดตอน Unload

local W = Flexozy:CreateWindow({
    Title      = "Flexozy",
    SubTitle   = "Demo Hub",
    Monogram   = "FX",
    Accent     = "Violet",
    Language   = "EN",
    ToggleKey  = Enum.KeyCode.RightControl,
    OnUnload   = function()
        if jumpConn then jumpConn:Disconnect() end
    end,
})

-- คำแปลภาษาไทยของข้อความในสคริปต์นี้ (ใช้ได้ทั้งแสดงผลและค้นหาใน Search)
W:AddTranslations({
    ["Player"] = "ผู้เล่น", ["Walk speed"] = "ความเร็วเดิน", ["Jump power"] = "แรงกระโดด",
    ["Infinite jump"] = "กระโดดไม่จำกัด", ["Hold Space to keep jumping"] = "กดค้างเพื่อกระโดดต่อเนื่อง",
    ["Reset character"] = "รีเซ็ตตัวละคร", ["Respawn your character"] = "เกิดใหม่",
    ["Farm"] = "ฟาร์ม", ["Auto farm"] = "ฟาร์มอัตโนมัติ", ["Demo loop that fills the progress bar"] = "ลูปตัวอย่างที่ทำให้แถบความคืบหน้าเดิน",
    ["Farm progress"] = "ความคืบหน้าการฟาร์ม", ["Farm key"] = "ปุ่มลัดฟาร์ม",
    ["Targets"] = "เป้าหมาย", ["Advanced"] = "ขั้นสูง",
    ["Server"] = "เซิร์ฟเวอร์", ["Rejoin"] = "เข้าเซิร์ฟเวอร์ใหม่", ["Copy JobId"] = "คัดลอก JobId",
    ["About"] = "เกี่ยวกับ", ["Changelog"] = "บันทึกการอัปเดต", ["Credits"] = "เครดิต",
})

-- ===================== Home =====================
local Home = W:Tab({ Title = "Home", Icon = Flexozy.Icons.Grid, Subtitle = "Overview" })
W:BuildHome(Home)
W:BuildDiscord(Home, "https://discord.gg/WFUejxeggt") -- การ์ด Discord: ออนไลน์/ออฟไลน์/สมาชิก

-- ===================== Main =====================
W:Section("Main")
local Main = W:Tab({ Title = "Player", Icon = Flexozy.Icons.Zap, Subtitle = "Character options" })

local function hum()
    local ch = LP.Character
    return ch and ch:FindFirstChildOfClass("Humanoid")
end

local pl = Main:Group("Player", "Left")
pl:Slider({
    Title = "Walk speed", Min = 16, Max = 100, Default = 16, Step = 1, Flag = "Main.WalkSpeed",
    Tooltip = "Default Roblox speed is 16",
    Callback = function(v) local h = hum() if h then h.WalkSpeed = v end end,
})
pl:Slider({
    Title = "Jump power", Min = 50, Max = 200, Default = 50, Step = 5, Flag = "Main.JumpPower",
    Callback = function(v)
        local h = hum()
        if h then h.UseJumpPower = true h.JumpPower = v end
    end,
})
pl:Toggle({
    Title = "Infinite jump", Desc = "Hold Space to keep jumping", Default = false, Flag = "Main.InfJump",
    Tooltip = "Lets you jump again while in the air",
    Callback = function(on)
        if jumpConn then jumpConn:Disconnect() jumpConn = nil end
        if on then
            jumpConn = UIS.JumpRequest:Connect(function()
                local h = hum()
                if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        end
    end,
})
pl:Button({
    Title = "Reset character", Desc = "Respawn your character",
    Callback = function() local h = hum() if h then h.Health = 0 end end,
})

local farm = Main:Group("Farm", "Right")
local running = false
local progress = farm:Progress({ Title = "Farm progress", Min = 0, Max = 100, Default = 0 })
farm:Toggle({
    Title = "Auto farm", Desc = "Demo loop that fills the progress bar", Default = false, Flag = "Main.AutoFarm",
    Tooltip = "ตัวอย่างเท่านั้น: เติมแถบทีละ 5% ทุกครึ่งวินาที",
    Callback = function(on)
        running = on
        if on then
            task.spawn(function()
                local n = 0
                while running and not W.Unloaded do
                    n = (n >= 100) and 0 or (n + 5)
                    progress.Set(n)
                    task.wait(0.5)
                end
            end)
        else
            progress.Set(0)
        end
    end,
})
farm:Keybind({
    Title = "Farm key", Default = Enum.KeyCode.F, Flag = "Main.FarmKey",
    Callback = function() W:Notify({ Title = "Farm", Content = "Key pressed", Duration = 2 }) end,
})

-- กลุ่มที่พับได้ (เริ่มต้นพับไว้) — ลองพิมพ์ "Targets" ในช่อง Search จะเด้งมาขยายให้เอง
local adv = Main:Group("Advanced", { Side = "Left", Collapsible = true, Collapsed = true })
adv:Dropdown({
    Title = "Targets", Options = { "Players", "NPCs", "Chests", "Bosses" }, Default = { "NPCs" }, Multi = true,
    Flag = "Main.Targets", Tooltip = "เลือกได้หลายอย่าง",
    Callback = function(list) print("Targets:", table.concat(list, ", ")) end,
})

-- ===================== Server =====================
local Srv = W:Tab({ Title = "Server", Icon = Flexozy.Icons.Server, Subtitle = "Server tools" })
local st = Srv:Group("Server", "Left")
st:Button({
    Title = "Rejoin", Desc = "Rejoin this server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
    end,
})
st:Button({
    Title = "Copy JobId",
    Callback = function()
        local fn = setclipboard or toclipboard
        if fn then
            fn(game.JobId)
            W:Notify({ Title = "Server", Content = "Copied", Type = "Success", Force = true })
        else
            W:Notify({ Title = "Server", Content = "executor ไม่รองรับ setclipboard", Type = "Error", Force = true })
        end
    end,
})

local info = Srv:Group("About", "Right")
info:Paragraph({
    Title = "Changelog",
    Content = "v3.3.0\n- เพิ่ม Discord widget\n- เพิ่มช่องค้นหา (Search)\n- กลุ่มพับ/ขยายได้\n- Paragraph, Code, Progress, Tooltip",
})
info:Code({ Title = "Credits", Content = "Made with Flexozy UI\nhttps://flexozy.xyz" })

-- ===================== Settings =====================
W:Section("System")
local Settings = W:Tab({ Title = "Settings", Icon = Flexozy.Icons.Settings, Subtitle = "UI & config", Bottom = true })
W:BuildSettings(Settings)

-- โหลดคอนฟิกที่เซฟไว้ (ต้องเรียกหลังสร้าง element ครบทุกตัว) แล้วค่อยแจ้งเตือน
W:LoadConfig()
W:Notify({ Title = "Flexozy", Content = "Loaded - กด RightControl เพื่อซ่อน/แสดง", Type = "Success", Duration = 4 })
