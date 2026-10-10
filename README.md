# Flexozy UI

ไลบรารี UI สำหรับ Roblox (Luau) สไตล์ดาร์ก มีแอนิเมชัน ปรับธีมได้ และมีหมวด Settings พร้อมใช้ (ปรับขนาด UI, เปลี่ยนสี, ปุ่มลัด, เซฟคอนฟิก)

- **Version:** 3.0.0
- **ไฟล์หลัก:** `FlexozyUI.lua`
- **ตัวอย่างครบทุกคอมโพเนนต์:** `Flexozy_Example.lua`

---

## ฟีเจอร์

| ฟีเจอร์ | รายละเอียด |
|---|---|
| คอมโพเนนต์ | Toggle, Slider (ทศนิยมได้), Dropdown (เลือกอันเดียว / หลายอัน), Button, Input, Keybind, Label, Divider |
| หมวด Settings สำเร็จรูป | `Win:BuildSettings(tab)` บรรทัดเดียวได้ครบ |
| ปรับขนาด UI | 25% – 200% + ย่ออัตโนมัติเมื่อจอเล็ก (Auto-fit) |
| ธีมสี | 8 สี สลับได้ทันทีโดยไม่ต้องรีโหลด |
| เซฟ / โหลดคอนฟิก | บันทึกลงไฟล์ผ่าน `writefile` (ตั้ง `Flag` ให้คอมโพเนนต์แล้วเซฟอัตโนมัติ) |
| แจ้งเตือน | 4 ชนิด (Info / Success / Warning / Error) ซ้อนได้หลายอัน |
| อื่นๆ | ปุ่มลอยเปิด/ปิดเมนู (ลากได้), แถบ FPS/MS, หน้า Home แสดงข้อมูลเซิร์ฟ, รองรับมือถือ |

---

## วิธีอัปขึ้น GitHub แล้วใช้งาน

1. สร้าง Repository ใหม่บน GitHub (ตั้งเป็น **Public**)
2. อัปโหลดไฟล์ `FlexozyUI.lua`, `Flexozy_Example.lua`, `README.md`
3. เปิดไฟล์ `FlexozyUI.lua` บน GitHub → กดปุ่ม **Raw** → คัดลอกลิงก์ที่ได้ (หน้าตาแบบนี้)

```
https://raw.githubusercontent.com/USERNAME/REPO/main/FlexozyUI.lua
```

4. นำลิงก์ไปใส่ในสคริปต์ของคุณ

```lua
local Flexozy = loadstring(game:HttpGet("https://raw.githubusercontent.com/USERNAME/REPO/main/FlexozyUI.lua"))()
```

> ถ้าไม่อยากใช้ GitHub: วาง `FlexozyUI.lua` ในโฟลเดอร์ workspace ของ executor แล้วใช้
> `loadstring(readfile("FlexozyUI.lua"))()`

---

## เริ่มต้นใช้งานเร็ว

```lua
local Flexozy = loadstring(game:HttpGet("URL_RAW"))()

local Win = Flexozy:CreateWindow({
    Title    = "Flexozy",
    SubTitle = "My Script Hub",
})

Win:Section("Main")
local Home = Win:Tab({ Title = "Home", Subtitle = "Overview", Icon = Flexozy.Icons.Grid })
Win:BuildHome(Home)

local Farm = Win:Tab({ Title = "Farm", Subtitle = "Auto farm", Icon = Flexozy.Icons.Sword })
local g = Farm:Group("Settings", "Left")
g:Toggle("Auto Farm", "เปิด/ปิดฟาร์ม", false, function(on)
    print("Auto Farm:", on)
end)

Win:Section("Extra")
local Set = Win:Tab({ Title = "Settings", Subtitle = "Interface options", Icon = Flexozy.Icons.Settings })
Win:BuildSettings(Set)

Win:LoadConfig()   -- บรรทัดสุดท้ายเสมอ
```

---

## CreateWindow

```lua
local Win = Flexozy:CreateWindow({
    Title      = "Flexozy",                    -- ชื่อบนหัวหน้าต่าง
    SubTitle   = "Script Hub",                 -- ข้อความรอง
    Monogram   = "FX",                         -- ตัวอักษรในโลโก้ + ปุ่มลอย
    Size       = Vector2.new(720, 520),
    ToggleKey  = Enum.KeyCode.RightControl,    -- ปุ่มซ่อน/แสดง (เปลี่ยนได้ใน Settings)
    StatsPill  = true,                         -- แถบ FPS / MS
    Accent     = "Violet",                     -- Violet Blue Cyan Green Yellow Orange Red Pink หรือ Color3
    ConfigName = "default",                    -- ไฟล์คอนฟิก: Flexozy/default.json
    Folder     = "Flexozy",                    -- โฟลเดอร์เก็บคอนฟิก
    AutoSave   = true,
    OnUnload   = function() end,               -- เรียกตอน Unload
})
```

## เมธอดของหน้าต่าง (`Win`)

| เมธอด | ทำอะไร |
|---|---|
| `Win:Section("ชื่อ")` | หัวข้อคั่นในแถบข้าง |
| `Win:Tab({Title, Subtitle, Icon})` | สร้างแท็บ |
| `Win:BuildHome(tab)` | สร้างหน้า Home (ข้อมูลเกม/เซิร์ฟ/FPS) |
| `Win:BuildSettings(tab)` | สร้างหมวด Settings ครบชุด |
| `Win:Select("ชื่อแท็บ")` | สลับไปแท็บนั้น |
| `Win:Notify({...})` | แจ้งเตือน |
| `Win:Toggle(true/false)` | แสดง / ซ่อนหน้าต่าง (ไม่ใส่ค่า = สลับ) |
| `Win:SetUIScale(1.5)` | ปรับขนาด UI (0.25 – 3) |
| `Win:SetAccent("Blue")` | เปลี่ยนสีธีม (ชื่อหรือ `Color3`) |
| `Win:SetOpacity(0.9)` | ความทึบของหน้าต่าง |
| `Win:SaveConfig()` | บันทึกคอนฟิกทันที |
| `Win:LoadConfig()` | โหลดคอนฟิก + เปิดเซฟอัตโนมัติ |
| `Win:ResetSettings()` | คืนค่าหมวด UI เป็นค่าเริ่มต้น |
| `Win:Unload()` | ปิด UI และตัดการเชื่อมต่อทั้งหมด |

ค่าอื่นที่เข้าถึงได้: `Win.Flags` (ค่าของทุกคอมโพเนนต์ที่ตั้ง Flag), `Win.Key` (ปุ่มซ่อน/แสดงปัจจุบัน), `Win.Main`, `Win.Float`, `Win.StatsPill`

---

## คอมโพเนนต์

สร้างจาก `Tab:Group("ชื่อการ์ด", "Left" | "Right")` (ไม่ใส่ฝั่ง = เต็มความกว้าง)
ทุกคอมโพเนนต์เรียกได้ 2 แบบ: **เรียงพารามิเตอร์** หรือ **ส่งตาราง**

```lua
g:Toggle("ชื่อ", "คำอธิบาย", false, function(v) end, "FlagName")
g:Toggle({ Title = "ชื่อ", Desc = "คำอธิบาย", Default = false, Callback = function(v) end, Flag = "FlagName" })
```

### Toggle
```lua
local t = g:Toggle("Auto Farm", "คำอธิบาย", false, function(on) end, "AutoFarm")
t.Set(true)      -- ตั้งค่า (เรียก callback ด้วย)  |  t.Set(true, true) = ไม่เรียก callback
t.Get()          -- true / false
```

### Slider
```lua
-- (ชื่อ, min, max, default, หน่วย, callback, step, flag)
local s = g:Slider("Distance", 5, 50, 15, "studs", function(v) end, 1, "Distance")
-- แบบตาราง: ทศนิยม + ยิง callback ตอนปล่อยมือ
g:Slider({ Title = "Delay", Min = 0, Max = 1, Step = 0.05, Default = 0.2, Suffix = "s", OnRelease = true,
           Callback = function(v) end })
s.Set(20)  s.Get()
```

### Dropdown
```lua
-- เลือกอันเดียว: (ชื่อ, ตัวเลือก, ค่าเริ่มต้น, callback, flag)
local d = g:Dropdown("Method", { "Normal", "Fast", "Safe" }, "Normal", function(v) end, "Method")

-- เลือกหลายอัน: callback ได้ตารางที่เลือก
local m = g:Dropdown({ Title = "Weapons", Options = { "Melee", "Sword", "Fruit" }, Default = { "Melee" },
                       Multi = true, Callback = function(list) end })

d.Get()                          -- ค่าปัจจุบัน
d.Set("Fast")                    -- ตั้งค่า
d.Refresh({ "A", "B", "C" })     -- เปลี่ยนรายการตัวเลือกใหม่ (เช่น รายชื่อผู้เล่น)
```

### Button
```lua
local b = g:Button("Teleport", "คำอธิบาย", function() end)
b.SetTitle("ชื่อใหม่")
```

### Input
```lua
-- (ชื่อ, placeholder, ค่าเริ่มต้น, callback, flag)  — callback เรียกเมื่อกด Enter หรือคลิกออกจากช่อง
local i = g:Input("Target", "พิมพ์ชื่อ", "", function(text) end, "Target")
i.Get()  i.Set("abc")
```

### Keybind
```lua
g:Keybind({
    Title = "Quick toggle", Default = Enum.KeyCode.F, Flag = "QuickKey",
    Callback = function(key) end,   -- เรียกเมื่อกดปุ่มที่ตั้งไว้
    Changed  = function(key) end,   -- เรียกเมื่อผู้ใช้ตั้งปุ่มใหม่
})
-- ตอนตั้งปุ่ม: กดปุ่มที่ต้องการ | Esc = ยกเลิก | Backspace = ล้างปุ่ม
```

### Label / Divider
```lua
local l = g:Label("ข้อความ")   l.Set("ข้อความใหม่")
g:Divider()
```

---

## แจ้งเตือน (Notify)

```lua
Win:Notify({
    Title    = "Flexozy",
    Content  = "โหลดสำเร็จ",
    Duration = 3,            -- วินาที
    Type     = "Success",    -- Info (ค่าเริ่มต้น) | Success | Warning | Error
})
```

---

## หมวด Settings (`Win:BuildSettings(tab)`)

เรียกบรรทัดเดียวจะได้ตัวแปรเหล่านี้ทั้งหมด (ทุกตัวถูกเซฟลงคอนฟิกให้อัตโนมัติ):

| กลุ่ม | ตัวแปร | Flag |
|---|---|---|
| Appearance | **UI Size** 25% – 200% | `UI.Scale` |
| | Quick size (25 / 50 / 75 / 100 / 125 / 150 / 200%) | – |
| | Auto-fit to screen (ย่ออัตโนมัติเมื่อจอเล็ก) | `UI.AutoFit` |
| | Accent color (8 สี) | `UI.Accent` |
| | Window opacity | `UI.Opacity` |
| Interface | Show FPS / MS pill | `UI.StatsPill` |
| | Show floating button | `UI.FloatButton` |
| | Notifications | `UI.Notify` |
| | Toggle UI key | `UI.ToggleKey` |
| | Unload UI | – |
| Config | Auto-save | `UI.AutoSave` |
| | Config name + Save / Load / Reset | – |

> **เคล็ดลับเรื่องขนาด:** ถ้าลาก UI Size แล้วมือถือ/จอเล็กเกินไป ให้ใช้ Quick size หรือกดปุ่ม Reset UI settings ได้เสมอ

---

## ระบบคอนฟิก (เซฟค่าอัตโนมัติ)

1. ใส่พารามิเตอร์ `Flag` ให้คอมโพเนนต์ที่ต้องการเซฟ
2. เรียก `Win:LoadConfig()` เป็นบรรทัดสุดท้ายของสคริปต์ (หลังสร้างคอมโพเนนต์ครบแล้ว)
3. หลังจากนั้นทุกครั้งที่เปลี่ยนค่า จะเซฟลง `Flexozy/<ConfigName>.json` ให้เอง

```lua
g:Toggle("Auto Farm", nil, false, function(on) end, "AutoFarm")
g:Slider("Distance", 5, 50, 15, "studs", function(v) end, 1, "Distance")

Win:LoadConfig()

-- อ่านค่าที่ตั้งไว้ในลูปฟาร์ม
while task.wait() do
    if Win.Flags.AutoFarm then
        local dist = Win.Flags.Distance
        -- ...
    end
end
```

ต้องใช้ executor ที่รองรับ `writefile` / `readfile` / `isfile` ถ้าไม่รองรับ UI ยังใช้ได้ปกติ แค่เซฟไม่ได้

---

## ไอคอนที่มีให้

`Flexozy.Icons.` → `Grid` `Sword` `Skull` `Zap` `Server` `Eye` `Settings` `Refresh` `Teleport`
(ใช้ `rbxassetid://...` ของคุณเองได้ใน `Icon = "rbxassetid://123"`)

---

## แก้ปัญหาเบื้องต้น

| อาการ | วิธีแก้ |
|---|---|
| UI ไม่ขึ้น | ตรวจลิงก์ว่าเป็นลิงก์ **raw** และ repo เป็น Public |
| UI ใหญ่/เล็กเกินไป | Settings → UI Size หรือ Quick size |
| ซ่อน UI แล้วหาไม่เจอ | กดปุ่มลอย (FX) หรือปุ่ม `RightControl` |
| เซฟคอนฟิกไม่ได้ | executor ไม่รองรับ `writefile` |
| ค่าที่เซฟไม่กลับมา | ต้องเรียก `Win:LoadConfig()` ท้ายสคริปต์ และตั้ง `Flag` ให้คอมโพเนนต์ |

---

## License

ใช้ได้อิสระ แก้ไขและแจกต่อได้ (ใส่เครดิต Flexozy จะขอบคุณมาก)
