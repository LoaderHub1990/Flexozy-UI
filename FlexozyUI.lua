local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local RunService   = game:GetService("RunService")
local Players      = game:GetService("Players")
local CoreGui      = game:GetService("CoreGui")
local Stats        = game:GetService("Stats")
local Market       = game:GetService("MarketplaceService")
local HttpService  = game:GetService("HttpService")
local LP           = Players.LocalPlayer
local WHITE, BLACK = Color3.new(1, 1, 1), Color3.new(0, 0, 0)
local function C(r, g, b) return Color3.fromRGB(r, g, b) end
local Flexozy = {
    Version = "3.0.0",
    Icons = {
        Grid     = "rbxassetid://10709752035",
        Sword    = "rbxassetid://10709818534",
        Skull    = "rbxassetid://10734962068",
        Zap      = "rbxassetid://10709791882",
        Server   = "rbxassetid://10734963400",
        Eye      = "rbxassetid://10747375132",
        Settings = "rbxassetid://10734950309",
        Refresh  = "rbxassetid://10734933222",
        Teleport = "rbxassetid://10723404337",
    },
    Accents = {
        Violet = C(139, 92, 246),
        Blue   = C(59, 130, 246),
        Cyan   = C(6, 182, 212),
        Green  = C(34, 197, 94),
        Yellow = C(234, 179, 8),
        Orange = C(249, 115, 22),
        Red    = C(239, 68, 68),
        Pink   = C(236, 72, 153),
    },
    AccentNames = { "Violet", "Blue", "Cyan", "Green", "Yellow", "Orange", "Red", "Pink" },
}
local T = {
    Window = C(18, 18, 22),
    Panel  = C(24, 24, 29),
    Card   = C(30, 30, 36),
    Card2  = C(39, 39, 47),
    Stroke = C(56, 56, 66),
    Text   = C(245, 246, 250),
    Dim    = C(150, 152, 163),
    Muted  = C(104, 106, 118),
    Accent = Flexozy.Accents.Violet,
    Danger = C(239, 68, 68),
    Warn   = C(245, 158, 11),
    Ok     = C(34, 197, 94),
}
local function New(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    o.Parent = parent
    return o
end
local function Round(o, r)
    return New("UICorner", { CornerRadius = UDim.new(0, r) }, o)
end
local function Stroke(o, col, th, tr)
    return New("UIStroke", {
        Color = col or T.Stroke, Thickness = th or 1, Transparency = tr or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, o)
end
local function Label(parent, props)
    local d = {
        BackgroundTransparency = 1, BorderSizePixel = 0,
        Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = T.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }
    for k, v in pairs(props) do d[k] = v end
    return New("TextLabel", d, parent)
end
local function Tween(o, t, props, style, dir)
    local tw = TweenService:Create(o, TweenInfo.new(t, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props)
    tw:Play()
    return tw
end
local function Hex(c)
    return string.format("#%02x%02x%02x", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
end
local function Opts(names, ...)
    local first = ...
    if type(first) == "table" then return first end
    local pack = table.pack(...)
    local o = {}
    for i, n in ipairs(names) do o[n] = pack[i] end
    return o
end
local function Press(obj, depth)
    local s = obj:FindFirstChildOfClass("UIScale") or New("UIScale", {}, obj)
    Tween(s, 0.07, { Scale = depth or 0.95 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    task.delay(0.07, function()
        if s.Parent then Tween(s, 0.3, { Scale = 1 }, Enum.EasingStyle.Back) end
    end)
end
local function Interact(btn, noRipple)
    btn.InputBegan:Connect(function(i)
        if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then return end
        Press(btn)
        if noRipple then return end
        btn.ClipsDescendants = true
        local ab, sz = btn.AbsolutePosition, btn.AbsoluteSize
        local rx = math.clamp((i.Position.X - ab.X) / math.max(sz.X, 1), 0, 1)
        local ry = math.clamp((i.Position.Y - ab.Y) / math.max(sz.Y, 1), 0, 1)
        local r = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(rx, ry), Size = UDim2.fromScale(0, 0),
            BackgroundColor3 = WHITE, BackgroundTransparency = 0.82, BorderSizePixel = 0, ZIndex = btn.ZIndex + 5,
        }, btn)
        Round(r, 999)
        New("UIAspectRatioConstraint", { AspectRatio = 1, DominantAxis = Enum.DominantAxis.Width }, r)
        local tw = Tween(r, 0.55, { Size = UDim2.fromScale(2.2, 2.2), BackgroundTransparency = 1 })
        tw.Completed:Connect(function() r:Destroy() end)
    end)
end
local function GuiParent()
    local ok, p = pcall(function() return (gethui and gethui()) or CoreGui end)
    return (ok and p) or LP:WaitForChild("PlayerGui")
end
local function MakeDraggable(handle, target, conn)
    local dragging, startIn, startPos, moved = false, nil, nil, false
    conn(handle.InputBegan, function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging, moved = true, false
            startIn, startPos = i.Position, target.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    conn(UIS.InputChanged, function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - startIn
            if d.Magnitude > 4 then moved = true end
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    return function() return moved end
end
local function NormLang(l)
    l = tostring(l or "EN"):upper()
    if l == "TH" or l == "THAI" or l == "ไทย" then return "TH" end
    return "EN"
end

local function NormScope(sc)
    if sc == "Tabs" or sc == "Functions" then return sc end
    return "All"
end

local DefaultDict = {
    ["Home"] = "หน้าหลัก", ["Main"] = "หลัก", ["Settings"] = "ตั้งค่า",
    ["Good morning"] = "สวัสดีตอนเช้า", ["Good afternoon"] = "สวัสดีตอนบ่าย", ["Good evening"] = "สวัสดีตอนเย็น",
    ["Players"] = "ผู้เล่น", ["Session time"] = "เวลาที่เล่น", ["Performance (FPS)"] = "ประสิทธิภาพ (FPS)", ["Avg"] = "เฉลี่ย",
    ["None"] = "ไม่มี",
    ["Appearance"] = "หน้าตา", ["Language"] = "ภาษา", ["About"] = "เกี่ยวกับ", ["Interface"] = "อินเทอร์เฟซ",
    ["Protection"] = "การป้องกัน", ["Config"] = "คอนฟิก",
    ["UI Size"] = "ขนาด UI", ["Quick size"] = "ขนาดด่วน",
    ["Auto-fit to screen"] = "ปรับให้พอดีหน้าจอ", ["Shrink UI automatically on small screens"] = "ย่อ UI อัตโนมัติเมื่อจอเล็ก",
    ["Accent color"] = "สีธีม", ["Window opacity"] = "ความทึบของหน้าต่าง",
    ["Violet"] = "ม่วง", ["Blue"] = "น้ำเงิน", ["Cyan"] = "ฟ้า", ["Green"] = "เขียว",
    ["Yellow"] = "เหลือง", ["Orange"] = "ส้ม", ["Red"] = "แดง", ["Pink"] = "ชมพู",
    ["Language scope"] = "ขอบเขตการแปล", ["All"] = "ทั้งหมด", ["Tabs"] = "แท็บ", ["Functions"] = "ฟังก์ชัน",
    ["All = everything, Tabs = tab names only, Functions = features only"] = "ทั้งหมด = ทุกอย่าง, แท็บ = เฉพาะชื่อแท็บ, ฟังก์ชัน = เฉพาะตัวเลือกฟีเจอร์",
    ["Toggle key"] = "ปุ่มซ่อน/แสดง",
    ["Show FPS / MS pill"] = "แสดงแถบ FPS / MS", ["FPS and ping bar at the top of the screen"] = "แถบ FPS และ Ping ด้านบนจอ",
    ["Show floating button"] = "แสดงปุ่มลอย", ["Floating button to open/close the menu"] = "ปุ่มลอยเปิด/ปิดเมนู",
    ["Notifications"] = "การแจ้งเตือน", ["Toggle UI key"] = "ปุ่มซ่อน/แสดง UI",
    ["Unload UI"] = "ปิด UI", ["Close and disconnect everything"] = "ปิดและตัดการเชื่อมต่อทั้งหมด",
    ["Anti-AFK"] = "กันหลุด (Anti-AFK)", ["Prevents the 20-minute idle kick"] = "กันโดนเตะเมื่อไม่ขยับ 20 นาที",
    ["Auto rejoin"] = "เข้าเกมใหม่อัตโนมัติ", ["Rejoin automatically if disconnected or kicked"] = "เข้าเกมใหม่เองเมื่อหลุดหรือโดนเตะ",
    ["Auto-save"] = "เซฟอัตโนมัติ", ["Save settings automatically"] = "เซฟค่าที่ตั้งให้อัตโนมัติ",
    ["Config name"] = "ชื่อคอนฟิก",
    ["Save config"] = "บันทึกคอนฟิก", ["Save all values to a file"] = "บันทึกค่าทั้งหมดลงไฟล์",
    ["Load config"] = "โหลดคอนฟิก", ["Load values from the file"] = "โหลดค่าจากไฟล์",
    ["Reset UI settings"] = "รีเซ็ตการตั้งค่า UI", ["Restore UI options to default"] = "คืนค่าหมวด UI เป็นค่าเริ่มต้น",
    ["Saved"] = "บันทึกแล้ว", ["Loaded"] = "โหลดแล้ว", ["UI settings reset"] = "รีเซ็ตการตั้งค่าแล้ว",
}

local function Greeting()
    local h = tonumber(os.date("%H")) or 12
    if h < 12 then return "Good morning" elseif h < 18 then return "Good afternoon" end
    return "Good evening"
end
local function ToColor(c)
    if type(c) == "string" then return Flexozy.Accents[c], c end
    if typeof(c) == "Color3" then return c, nil end
    return nil
end
function Flexozy:CreateWindow(cfg)
    cfg = cfg or {}
    local title  = cfg.Title or "Flexozy"
    local sub    = cfg.SubTitle or "Script Hub"
    local mono   = cfg.Monogram or "FX"
    local size   = cfg.Size or Vector2.new(720, 520)
    local HEADER = 66
    local startAccent, startName = ToColor(cfg.Accent or "Violet")
    T.Accent = startAccent or Flexozy.Accents.Violet
    local W = {
        Tabs = {}, Conns = {}, Updaters = {}, ThemeFns = {},
        Flags = {}, Setters = {}, Defaults = {},
        Key = cfg.ToggleKey or Enum.KeyCode.RightControl,
        UserScale = 1, AutoFit = true, AutoSave = cfg.AutoSave ~= false,
        ConfigName = cfg.ConfigName or "default", Folder = cfg.Folder or "Flexozy",
        NotifyEnabled = true, AccentName = startName or "Violet",
        Lang = NormLang(cfg.Language), LangScope = NormScope(cfg.LanguageScope), LangFns = {}, Dict = { EN = {}, TH = {} },
        Shown = true, Listening = false, Version = Flexozy.Version,
    }
    local function Conn(sig, fn)
        local c = sig:Connect(fn)
        table.insert(W.Conns, c)
        return c
    end
    local function Themed(fn)
        fn()
        table.insert(W.ThemeFns, fn)
        return fn
    end
    W.Themed = Themed
    local function AccentGrad(obj, rot)
        obj.BackgroundColor3 = WHITE
        local g = New("UIGradient", { Rotation = rot or 90 }, obj)
        Themed(function()
            g.Color = ColorSequence.new(T.Accent:Lerp(WHITE, 0.18), T.Accent:Lerp(BLACK, 0.22))
        end)
        return g
    end
    local function Tr(raw, kind)
        local sc = W.LangScope
        local on = sc == "All" or (sc == "Tabs" and kind == "tab") or (sc == "Functions" and kind == "func")
        if type(raw) == "table" then
            if on then return raw[W.Lang] or raw.EN or raw.TH or "" end
            return raw.EN or raw.TH or ""
        end
        raw = tostring(raw == nil and "" or raw)
        if on then
            local d = W.Dict[W.Lang]
            return (d and d[raw]) or raw
        end
        return raw
    end

    local function Loc(raw, kind, apply)
        local function run() apply(Tr(raw, kind)) end
        run()
        table.insert(W.LangFns, run)
        return function(newRaw)
            if newRaw ~= nil then raw = newRaw end
            run()
        end
    end

    local function Relang()
        for _, fn in ipairs(W.LangFns) do pcall(fn) end
    end

    function W:AddTranslations(map)
        for en, th in pairs(map or {}) do
            W.Dict.TH[en] = th
            W.Dict.EN[th] = en
        end
        Relang()
    end
    W:AddTranslations(DefaultDict)

    function W:SetLanguage(l)
        W.Lang = NormLang(l)
        local st = W.Setters["UI.Lang"]
        if st then pcall(st, W.Lang == "TH" and "ไทย" or "English", true) end
        Relang()
    end

    function W:SetLanguageScope(sc)
        W.LangScope = NormScope(sc)
        local st = W.Setters["UI.LangScope"]
        if st then pcall(st, W.LangScope, true) end
        Relang()
    end

    local afkConn, rejoinConn
    function W:SetAntiAfk(on)
        W.AntiAfk = on == true
        if afkConn then afkConn:Disconnect() afkConn = nil end
        if W.AntiAfk then
            afkConn = LP.Idled:Connect(function()
                pcall(function()
                    local vu = game:GetService("VirtualUser")
                    vu:CaptureController()
                    vu:ClickButton2(Vector2.new(0, 0))
                end)
            end)
        end
        local st = W.Setters["UI.AntiAfk"]
        if st then pcall(st, W.AntiAfk, true) end
    end

    function W:SetAutoRejoin(on)
        W.AutoRejoin = on == true
        if rejoinConn then rejoinConn:Disconnect() rejoinConn = nil end
        if W.AutoRejoin then
            task.spawn(function()
                local ok, overlay = pcall(function()
                    return CoreGui:WaitForChild("RobloxPromptGui", 10):WaitForChild("promptOverlay", 10)
                end)
                if not ok or not overlay or not W.AutoRejoin or W.Unloaded then return end
                if rejoinConn then rejoinConn:Disconnect() end
                rejoinConn = overlay.ChildAdded:Connect(function(c)
                    if c.Name == "ErrorPrompt" then
                        task.wait(1.5)
                        pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId, LP) end)
                    end
                end)
            end)
        end
        local st = W.Setters["UI.AutoRejoin"]
        if st then pcall(st, W.AutoRejoin, true) end
    end

    local function FlagSet(flag, v)
        if flag then
            W.Flags[flag] = v
            W:_queueSave()
        end
    end
    local function FlagReg(flag, v, setter)
        if flag then
            W.Flags[flag] = v
            W.Setters[flag] = setter
            W.Defaults[flag] = v
        end
    end
    local function fsOk()
        return type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
    end
    local function cfgPath(name) return W.Folder .. "/" .. (name or W.ConfigName) .. ".json" end
    local saveTok = 0
    function W:_queueSave()
        if not (W.AutoSave and W._canSave) or W._loading then return end
        saveTok += 1
        local t = saveTok
        task.delay(1.2, function()
            if t == saveTok and not W.Unloaded then W:SaveConfig() end
        end)
    end
    function W:SaveConfig(name)
        if not fsOk() then return false, "executor ไม่รองรับ writefile" end
        local ok, err = pcall(function()
            if makefolder and isfolder and not isfolder(W.Folder) then makefolder(W.Folder) end
            writefile(cfgPath(name), HttpService:JSONEncode({ Version = Flexozy.Version, Flags = W.Flags }))
        end)
        return ok, err
    end
    function W:LoadConfig(name)
        W._canSave = true
        if not fsOk() then return false, "executor ไม่รองรับ readfile" end
        local p = cfgPath(name)
        local okE, exists = pcall(isfile, p)
        if not (okE and exists) then return false, "ไม่พบไฟล์คอนฟิก" end
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(p)) end)
        if not ok or type(data) ~= "table" or type(data.Flags) ~= "table" then return false, "ไฟล์คอนฟิกเสีย" end
        W._loading = true
        for k, v in pairs(data.Flags) do
            local s = W.Setters[k]
            if s then pcall(s, v, false) end
        end
        W._loading = false
        return true
    end
    function W:ResetSettings()
        W._loading = true
        for k, v in pairs(W.Defaults) do
            if k:sub(1, 3) == "UI." and W.Setters[k] then pcall(W.Setters[k], v, false) end
        end
        W._loading = false
        W:_queueSave()
    end
    local parent = GuiParent()
    pcall(function() local o = parent:FindFirstChild("Flexozy_UI") if o then o:Destroy() end end)
    local Gui = New("ScreenGui", { Name = "Flexozy_UI", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true }, parent)
    W.Gui = Gui
    local Main = New("Frame", {
        Name = "Main", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(size.X, size.Y), BackgroundColor3 = T.Window,
        BackgroundTransparency = 0.03, BorderSizePixel = 0,
    }, Gui)
    Round(Main, 16)
    local mainStroke = Stroke(Main, T.Stroke, 1.2)
    New("UIGradient", { Color = ColorSequence.new(WHITE, C(208, 208, 220)), Rotation = 90 }, Main)
    W.Main = Main
    Themed(function() mainStroke.Color = T.Stroke:Lerp(T.Accent, 0.35) end)
    local Scale = New("UIScale", {}, Main)
    local function TargetScale()
        local s = W.UserScale
        if W.AutoFit then
            local cam = workspace.CurrentCamera
            if cam then
                local vp = cam.ViewportSize
                s = math.min(s, vp.X * 0.94 / size.X, vp.Y * 0.92 / size.Y)
            end
        end
        return math.clamp(s, 0.2, 3)
    end
    function W:Rescale()
        if W.Shown then Scale.Scale = TargetScale() end
    end
    Scale.Scale = TargetScale()
    if workspace.CurrentCamera then
        Conn(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), function() W:Rescale() end)
    end
    local function ResolveLogo(src, cb)
        if src == nil or src == "" then return end
        if type(src) == "number" then cb("rbxassetid://" .. tostring(src)) return end
        src = tostring(src)
        if src:match("^%d+$") then cb("rbxassetid://" .. src) return end
        if src:match("^rbxassetid://") or src:match("^rbxthumb://") or src:match("^rbxasset://") then cb(src) return end
        task.spawn(function()
            local ok, asset = pcall(function()
                if not getcustomasset then error("no getcustomasset") end
                if src:match("^https?://") then
                    if not (writefile and isfile) then error("no fs") end
                    local key = (src:gsub("[^%w]", "")):sub(-24)
                    local path = W.Folder .. "/logo_" .. key .. ".png"
                    if makefolder and isfolder and not isfolder(W.Folder) then makefolder(W.Folder) end
                    if not isfile(path) then writefile(path, game:HttpGet(src)) end
                    return getcustomasset(path)
                end
                return getcustomasset(src)
            end)
            if ok and asset then cb(asset) end
        end)
    end

    local function ApplyLogo(host, onLoaded, src, inset)
        ResolveLogo(src, function(img)
            if not host.Parent then return end
            local il = New("ImageLabel", {
                Position = UDim2.fromOffset(inset, inset), Size = UDim2.new(1, -inset * 2, 1, -inset * 2),
                BackgroundTransparency = 1, Image = img, ScaleType = Enum.ScaleType.Fit,
            }, host)
            Round(il, 9)
            onLoaded()
        end)
    end

    local Header = New("Frame", { Size = UDim2.new(1, 0, 0, HEADER), BackgroundTransparency = 1 }, Main)
    MakeDraggable(Header, Main, Conn)
    local Logo = New("Frame", { Size = UDim2.fromOffset(40, 40), Position = UDim2.fromOffset(18, 13), BorderSizePixel = 0 }, Header)
    Round(Logo, 11)
    AccentGrad(Logo, 45)
    local logoText = Label(Logo, { Size = UDim2.fromScale(1, 1), Text = mono, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = WHITE, TextXAlignment = Enum.TextXAlignment.Center })
    ApplyLogo(Logo, function()
        logoText.Visible = false
        Logo.BackgroundTransparency = 1
    end, cfg.Logo, 0)
    Label(Header, { Position = UDim2.fromOffset(68, 14), Size = UDim2.new(1, -200, 0, 18), Text = title, Font = Enum.Font.GothamBold, TextSize = 14 })
    Label(Header, { Position = UDim2.fromOffset(68, 34), Size = UDim2.new(1, -200, 0, 14), Text = sub, TextSize = 10, TextColor3 = T.Muted })
    local function HeaderButton(xFromRight)
        local b = New("TextButton", {
            Size = UDim2.fromOffset(32, 32), Position = UDim2.new(1, xFromRight, 0, 17),
            BackgroundColor3 = T.Card, Text = "", AutoButtonColor = false,
        }, Header)
        Round(b, 9)
        Stroke(b, T.Stroke, 1)
        Interact(b)
        b.MouseEnter:Connect(function() Tween(b, 0.15, { BackgroundColor3 = T.Card2 }) end)
        b.MouseLeave:Connect(function() Tween(b, 0.15, { BackgroundColor3 = T.Card }) end)
        return b
    end
    local BtnCollapse = HeaderButton(-86)
    local sq = New("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(13, 13), BackgroundTransparency = 1 }, BtnCollapse)
    Round(sq, 3)
    Stroke(sq, T.Text, 1.5)
    local BtnClose = HeaderButton(-48)
    Label(BtnClose, { Size = UDim2.fromScale(1, 1), Text = "X", Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Center })
    local hl = New("Frame", { Size = UDim2.new(1, -24, 0, 1), Position = UDim2.new(0, 12, 0, HEADER - 1), BackgroundColor3 = WHITE, BorderSizePixel = 0 }, Main)
    New("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.1), NumberSequenceKeypoint.new(1, 1) }) }, hl)
    Themed(function() hl.BackgroundColor3 = T.Accent end)
    local Body = New("Frame", { Position = UDim2.fromOffset(0, HEADER), Size = UDim2.new(1, 0, 1, -HEADER), BackgroundTransparency = 1 }, Main)
    local Sidebar = New("Frame", { Position = UDim2.fromOffset(10, 8), Size = UDim2.new(0, 190, 1, -18), BackgroundColor3 = T.Panel, BorderSizePixel = 0 }, Body)
    Round(Sidebar, 14)
    Stroke(Sidebar, T.Stroke, 1, 0.3)
    local Nav = New("ScrollingFrame", {
        Position = UDim2.fromOffset(6, 6), Size = UDim2.new(1, -12, 1, -78),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
        ScrollBarImageColor3 = T.Stroke, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(),
    }, Sidebar)
    New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4) }, Nav)
    local navOrder = 0
    local function NextNav() navOrder += 1 return navOrder end
    local UserCard = New("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 8, 1, -8), Size = UDim2.new(1, -16, 0, 56), BackgroundColor3 = T.Card, BorderSizePixel = 0 }, Sidebar)
    Round(UserCard, 12)
    Stroke(UserCard, T.Stroke, 1, 0.3)
    local Avatar = New("ImageLabel", {
        Size = UDim2.fromOffset(36, 36), Position = UDim2.fromOffset(10, 10), BackgroundColor3 = T.Card2,
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LP.UserId) .. "&w=150&h=150",
    }, UserCard)
    Round(Avatar, 18)
    local Dot = New("Frame", { Size = UDim2.fromOffset(10, 10), Position = UDim2.fromOffset(38, 37), BackgroundColor3 = T.Ok, BorderSizePixel = 0 }, UserCard)
    Round(Dot, 5)
    Stroke(Dot, T.Card, 2)
    Label(UserCard, { Position = UDim2.fromOffset(54, 12), Size = UDim2.new(1, -60, 0, 16), Text = LP.DisplayName, Font = Enum.Font.GothamBold, TextSize = 11 })
    Label(UserCard, { Position = UDim2.fromOffset(54, 29), Size = UDim2.new(1, -60, 0, 14), Text = "@" .. LP.Name, TextSize = 9.5, TextColor3 = T.Muted })
    local Footer
    local function GetFooter()
        if not Footer then
            Footer = New("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 6, 1, -70), Size = UDim2.new(1, -12, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1 }, Sidebar)
            New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), VerticalAlignment = Enum.VerticalAlignment.Bottom }, Footer)
            Nav.Size = UDim2.new(1, -12, 1, -124)
        end
        return Footer
    end
    local Content = New("Frame", { Position = UDim2.fromOffset(210, 8), Size = UDim2.new(1, -220, 1, -18), BackgroundTransparency = 1 }, Body)
    function W:Section(name)
        local f = New("Frame", { Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, LayoutOrder = NextNav() }, Nav)
        local sl = Label(f, { Position = UDim2.fromOffset(10, 4), Size = UDim2.new(1, -10, 1, -4), Text = "", Font = Enum.Font.GothamMedium, TextSize = 9.5, TextColor3 = T.Muted })
        Loc(name, "tab", function(t) sl.Text = string.upper(t) end)
    end
    function W:Tab(tcfg)
        if type(tcfg) == "string" then tcfg = { Title = tcfg } end
        tcfg = tcfg or {}
        local Tab = { Title = type(tcfg.Title) == "table" and (tcfg.Title.EN or tcfg.Title.TH) or tcfg.Title or "Tab", _o = 0 }
        function Tab:_ord() self._o += 1 return self._o end
        local active = false
        local btn = New("TextButton", {
            Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = T.Card2, BackgroundTransparency = 1,
            Text = "", AutoButtonColor = false, LayoutOrder = NextNav(),
        }, tcfg.Bottom and GetFooter() or Nav)
        Round(btn, 10)
        local bStroke = Stroke(btn, T.Stroke, 1, 1)
        Interact(btn)
        local bar = New("Frame", { Size = UDim2.fromOffset(3, 16), Position = UDim2.new(0, 5, 0.5, -8), BackgroundColor3 = T.Accent, BorderSizePixel = 0, Visible = false }, btn)
        Round(bar, 2)
        local icon = New("ImageLabel", { Size = UDim2.fromOffset(16, 16), Position = UDim2.new(0, 18, 0.5, -8), BackgroundTransparency = 1, Image = tcfg.Icon or Flexozy.Icons.Grid, ImageColor3 = T.Dim }, btn)
        local name = Label(btn, { Position = UDim2.fromOffset(46, 0), Size = UDim2.new(1, -52, 1, 0), Text = "", TextColor3 = T.Dim, TextSize = 12, Font = Enum.Font.GothamMedium })
        Loc(tcfg.Title or "Tab", "tab", function(t) name.Text = t end)
        local Page = New("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false,
            ScrollBarThickness = 2, ScrollBarImageColor3 = T.Stroke, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(),
        }, Content)
        New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) }, Page)
        New("UIPadding", { PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 12) }, Page)
        local head = New("Frame", { Size = UDim2.new(1, 0, 0, 52), BackgroundTransparency = 1, LayoutOrder = 0 }, Page)
        local hT = Label(head, { Position = UDim2.fromOffset(2, 2), Size = UDim2.new(1, 0, 0, 24), Text = "", Font = Enum.Font.GothamBold, TextSize = 20 })
        Loc(tcfg.Title or "Tab", "tab", function(t) hT.Text = t end)
        local hS = Label(head, { Position = UDim2.fromOffset(2, 27), Size = UDim2.new(1, 0, 0, 14), Text = "", TextSize = 10.5, TextColor3 = T.Dim })
        Loc(tcfg.Subtitle or "", "tab", function(t) hS.Text = t end)
        local ul = New("Frame", { Position = UDim2.fromOffset(2, 46), Size = UDim2.fromOffset(34, 3), BorderSizePixel = 0 }, head)
        Round(ul, 2)
        AccentGrad(ul, 0)
        Tab.Content = Page
        Tab.Button = btn
        Themed(function()
            bar.BackgroundColor3 = T.Accent
            if active then
                bStroke.Color = T.Accent
                icon.ImageColor3 = T.Accent
            end
        end)
        local function SetActive(on)
            active = on
            Page.Visible = on
            bar.Visible = on
            Tween(btn, 0.18, { BackgroundTransparency = on and 0 or 1 })
            Tween(bStroke, 0.18, { Transparency = on and 0.35 or 1, Color = on and T.Accent or T.Stroke })
            Tween(name, 0.18, { TextColor3 = on and T.Text or T.Dim })
            Tween(icon, 0.18, { ImageColor3 = on and T.Accent or T.Dim })
        end
        Tab.SetActive = SetActive
        function Tab:Activate()
            for _, t in ipairs(W.Tabs) do if t ~= self then t.SetActive(false) end end
            W.ActiveTab = self
            SetActive(true)
            Page.CanvasPosition = Vector2.new(0, 0)
            Page.Position = UDim2.fromOffset(0, 12)
            Tween(Page, 0.3, { Position = UDim2.fromOffset(0, 0) })
        end
        btn.MouseEnter:Connect(function()
            if W.ActiveTab ~= Tab then Tween(btn, 0.15, { BackgroundTransparency = 0.6 }) end
        end)
        btn.MouseLeave:Connect(function()
            if W.ActiveTab ~= Tab then Tween(btn, 0.15, { BackgroundTransparency = 1 }) end
        end)
        btn.MouseButton1Click:Connect(function() Tab:Activate() end)
        function Tab:Group(gtitle, side)
            local host = Page
            if side == "Left" or side == "Right" then
                if not self._cols then
                    local cols = New("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = self:_ord() }, Page)
                    local l = New("Frame", { Size = UDim2.new(0.5, -5, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1 }, cols)
                    local r = New("Frame", { Position = UDim2.new(0.5, 5, 0, 0), Size = UDim2.new(0.5, -5, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1 }, cols)
                    for _, f in ipairs({ l, r }) do
                        New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) }, f)
                    end
                    self._cols = { Left = l, Right = r }
                end
                host = self._cols[side]
            end
            local card = New("Frame", {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = T.Card, BorderSizePixel = 0, LayoutOrder = self:_ord(),
            }, host)
            Round(card, 12)
            Stroke(card, T.Stroke, 1, 0.3)
            New("UIPadding", { PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }, card)
            New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) }, card)
            local n = 0
            local function ord() n += 1 return n end
            if gtitle then
                local gh = New("Frame", { Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, LayoutOrder = 0 }, card)
                local gb = New("Frame", { Position = UDim2.fromOffset(0, 2), Size = UDim2.fromOffset(3, 12), BorderSizePixel = 0 }, gh)
                Round(gb, 2)
                AccentGrad(gb, 90)
                local gl = Label(gh, { Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -10, 1, 0), Text = "", Font = Enum.Font.GothamBold, TextSize = 12 })
                Loc(gtitle, "func", function(t) gl.Text = t end)
            end
            local G = { Card = card }
            function G:Label(text)
                local l = Label(card, {
                    Size = UDim2.new(1, 0, 0, 14), AutomaticSize = Enum.AutomaticSize.Y, Text = "",
                    TextColor3 = T.Dim, TextSize = 10.5, TextWrapped = true,
                    TextTruncate = Enum.TextTruncate.None, LayoutOrder = ord(),
                })
                local setL = Loc(text or "", "func", function(t) l.Text = t end)
                return { Instance = l, Set = function(t) setL(t) end }
            end
            function G:Divider()
                New("Frame", { Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = T.Stroke, BackgroundTransparency = 0.4, BorderSizePixel = 0, LayoutOrder = ord() }, card)
            end
            function G:Toggle(...)
                local o = Opts({ "Title", "Desc", "Default", "Callback", "Flag" }, ...)
                local cb = o.Callback or function() end
                local state = o.Default == true
                local desc = o.Desc
                local row = New("Frame", { Size = UDim2.new(1, 0, 0, desc and 38 or 24), BackgroundTransparency = 1, LayoutOrder = ord() }, card)
                local hit = New("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "" }, row)
                local tl = Label(row, { Size = UDim2.new(1, -52, 0, 16), Text = "", Font = Enum.Font.GothamMedium, TextSize = 11.5 })
                Loc(o.Title or "Toggle", "func", function(t) tl.Text = t end)
                if desc then
                    local dl = Label(row, { Position = UDim2.fromOffset(0, 18), Size = UDim2.new(1, -52, 0, 14), Text = "", TextSize = 9.5, TextColor3 = T.Dim })
                    Loc(desc, "func", function(t) dl.Text = t end)
                end
                local pill = New("TextButton", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(38, 20), BackgroundColor3 = T.Card2, Text = "", AutoButtonColor = false }, row)
                Round(pill, 10)
                Interact(pill, true)
                local knob = New("Frame", { Size = UDim2.fromOffset(14, 14), Position = UDim2.new(0, 3, 0.5, -7), BackgroundColor3 = WHITE, BorderSizePixel = 0 }, pill)
                Round(knob, 7)
                local function paint(animate)
                    local pos = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
                    local col = state and T.Accent or T.Card2
                    if animate then
                        Tween(pill, 0.18, { BackgroundColor3 = col })
                        Tween(knob, 0.18, { Position = pos })
                    else
                        pill.BackgroundColor3 = col
                        knob.Position = pos
                    end
                end
                Themed(function() paint(false) end)
                local function set(v, silent)
                    state = v == true
                    paint(true)
                    FlagSet(o.Flag, state)
                    if not silent then task.spawn(cb, state) end
                end
                pill.MouseButton1Click:Connect(function() set(not state) end)
                hit.MouseButton1Click:Connect(function() set(not state) end)
                FlagReg(o.Flag, state, set)
                return { Set = set, Get = function() return state end, Instance = row }
            end
            function G:Slider(...)
                local o = Opts({ "Title", "Min", "Max", "Default", "Suffix", "Callback", "Step", "Flag", "OnRelease" }, ...)
                local cb = o.Callback or function() end
                local min, max = o.Min or 0, o.Max or 100
                local step = (o.Step and o.Step > 0) and o.Step or 1
                local dec = 0
                if step % 1 ~= 0 then dec = #((tostring(step)):match("%.(%d+)") or "") end
                local fmt = "%." .. dec .. "f"
                local suffix = o.Suffix or ""
                local function snap(v)
                    v = math.clamp(v, min, max)
                    v = min + math.floor((v - min) / step + 0.5) * step
                    return tonumber(string.format(fmt, math.clamp(v, min, max)))
                end
                local val = snap(o.Default or min)
                local row = New("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, LayoutOrder = ord() }, card)
                local tl = Label(row, { Size = UDim2.new(1, -80, 0, 16), Text = "", Font = Enum.Font.GothamMedium, TextSize = 11.5 })
                Loc(o.Title or "Slider", "func", function(t) tl.Text = t end)
                local vl = Label(row, { Position = UDim2.new(1, -80, 0, 0), Size = UDim2.fromOffset(80, 16), TextXAlignment = Enum.TextXAlignment.Right, Font = Enum.Font.GothamBold, TextSize = 10.5, TextColor3 = T.Accent })
                local track = New("Frame", { Position = UDim2.fromOffset(0, 26), Size = UDim2.new(1, 0, 0, 6), BackgroundColor3 = T.Card2, BorderSizePixel = 0 }, row)
                Round(track, 3)
                local fill = New("Frame", { Size = UDim2.fromScale(0, 1), BorderSizePixel = 0 }, track)
                Round(fill, 3)
                AccentGrad(fill, 0)
                local knob = New("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.fromOffset(12, 12), BackgroundColor3 = WHITE, BorderSizePixel = 0 }, track)
                Round(knob, 6)
                Themed(function() vl.TextColor3 = T.Accent end)
                local dragging, pending = false, false
                local function visual()
                    local r = (val - min) / math.max(max - min, 1e-9)
                    fill.Size = UDim2.fromScale(r, 1)
                    knob.Position = UDim2.fromScale(r, 0.5)
                    vl.Text = string.format(fmt, val) .. (suffix ~= "" and (" " .. suffix) or "")
                end
                visual()
                local function set(v, silent)
                    val = snap(tonumber(v) or val)
                    visual()
                    FlagSet(o.Flag, val)
                    if not silent then
                        if o.OnRelease and dragging then pending = true else task.spawn(cb, val) end
                    end
                end
                FlagReg(o.Flag, val, set)
                local hit = New("TextButton", { Position = UDim2.fromOffset(0, 18), Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Text = "" }, row)
                local function fromX(x)
                    local r = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
                    set(min + (max - min) * r)
                end
                hit.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        Page.ScrollingEnabled = false
                        Tween(knob, 0.15, { Size = UDim2.fromOffset(17, 17) }, Enum.EasingStyle.Back)
                        fromX(i.Position.X)
                    end
                end)
                Conn(UIS.InputChanged, function(i)
                    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                        fromX(i.Position.X)
                    end
                end)
                Conn(UIS.InputEnded, function(i)
                    if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) and dragging then
                        dragging = false
                        Page.ScrollingEnabled = true
                        Tween(knob, 0.2, { Size = UDim2.fromOffset(12, 12) }, Enum.EasingStyle.Back)
                        if pending then
                            pending = false
                            task.spawn(cb, val)
                        end
                    end
                end)
                return { Set = set, Get = function() return val end, Instance = row }
            end
            function G:Dropdown(...)
                local o = Opts({ "Title", "Options", "Default", "Callback", "Flag", "Multi" }, ...)
                local cb = o.Callback or function() end
                local options = o.Options or {}
                local multi = o.Multi == true
                local sel, chosen = nil, {}
                if multi then
                    for _, v in ipairs(type(o.Default) == "table" and o.Default or {}) do chosen[v] = true end
                else
                    sel = o.Default
                    if sel == nil then sel = options[1] end
                end
                local open = false
                local CLOSED, ITEM, MAXV = 54, 30, 6
                local function listH() return math.min(#options, MAXV) * ITEM end
                local row = New("Frame", { Size = UDim2.new(1, 0, 0, CLOSED), BackgroundTransparency = 1, ClipsDescendants = true, LayoutOrder = ord() }, card)
                local tl = Label(row, { Size = UDim2.new(1, 0, 0, 14), Text = "", TextSize = 10.5, TextColor3 = T.Dim })
                Loc(o.Title or "Dropdown", "func", function(t) tl.Text = t end)
                local box = New("TextButton", { Position = UDim2.fromOffset(0, 18), Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = T.Card2, Text = "", AutoButtonColor = false }, row)
                Round(box, 8)
                Stroke(box, T.Stroke, 1, 0.3)
                Interact(box)
                local vl = Label(box, { Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -34, 1, 0), Text = "", Font = Enum.Font.GothamMedium, TextSize = 11 })
                local arrow = Label(box, { Position = UDim2.new(1, -26, 0, 0), Size = UDim2.fromOffset(20, 32), Text = "v", TextXAlignment = Enum.TextXAlignment.Center, TextColor3 = T.Dim, Font = Enum.Font.GothamBold })
                local list = New("ScrollingFrame", {
                    Position = UDim2.fromOffset(0, 56), Size = UDim2.new(1, 0, 0, listH()), BackgroundTransparency = 1, BorderSizePixel = 0,
                    ScrollBarThickness = 2, ScrollBarImageColor3 = T.Stroke, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(),
                }, row)
                New("UIListLayout", { Padding = UDim.new(0, 2) }, list)
                local entries = {}
                local function arr()
                    local t = {}
                    for _, v in ipairs(options) do if chosen[v] then t[#t + 1] = v end end
                    return t
                end
                local function display()
                    if multi then
                        local t = arr()
                        for i, v in ipairs(t) do t[i] = Tr(v, "func") end
                        return #t > 0 and table.concat(t, ", ") or Tr("None", "func")
                    end
                    return sel ~= nil and Tr(sel, "func") or Tr("None", "func")
                end
                local function paint()
                    for _, e in ipairs(entries) do
                        local on = (multi and chosen[e.opt]) or (not multi and sel == e.opt)
                        e.lbl.TextColor3 = on and T.Text or T.Dim
                        e.mark.Visible = on and true or false
                        e.mark.BackgroundColor3 = T.Accent
                    end
                    vl.Text = display()
                end
                Themed(paint)
                local function setOpen(v)
                    open = v
                    if v then
                        if W._ddOpen and W._ddOpen ~= setOpen then pcall(W._ddOpen, false) end
                        W._ddOpen = setOpen
                    elseif W._ddOpen == setOpen then
                        W._ddOpen = nil
                    end
                    Tween(row, 0.2, { Size = UDim2.new(1, 0, 0, v and (CLOSED + 4 + listH()) or CLOSED) })
                    arrow.Text = v and "^" or "v"
                end
                box.MouseButton1Click:Connect(function() setOpen(not open) end)
                local function emit()
                    local v = multi and arr() or sel
                    FlagSet(o.Flag, v)
                    return v
                end
                local function build()
                    for _, c in ipairs(list:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    table.clear(entries)
                    for _, opt in ipairs(options) do
                        local ob = New("TextButton", { Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = T.Card2, BackgroundTransparency = 0.4, Text = "", AutoButtonColor = false }, list)
                        Round(ob, 7)
                        Interact(ob)
                        local lbl = Label(ob, { Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -30, 1, 0), Text = Tr(opt, "func"), TextSize = 10.5, TextColor3 = T.Dim })
                        local mark = New("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(6, 6), BackgroundColor3 = T.Accent, BorderSizePixel = 0, Visible = false }, ob)
                        Round(mark, 3)
                        table.insert(entries, { opt = opt, lbl = lbl, mark = mark })
                        ob.MouseEnter:Connect(function() Tween(ob, 0.12, { BackgroundTransparency = 0 }) end)
                        ob.MouseLeave:Connect(function() Tween(ob, 0.12, { BackgroundTransparency = 0.4 }) end)
                        ob.MouseButton1Click:Connect(function()
                            if multi then
                                chosen[opt] = (not chosen[opt]) or nil
                                paint()
                                task.spawn(cb, emit())
                            else
                                sel = opt
                                paint()
                                setOpen(false)
                                task.spawn(cb, emit())
                            end
                        end)
                    end
                    list.Size = UDim2.new(1, 0, 0, listH())
                    if open then row.Size = UDim2.new(1, 0, 0, CLOSED + 4 + listH()) end
                    paint()
                end
                build()
                table.insert(W.LangFns, function()
                    for _, e in ipairs(entries) do e.lbl.Text = Tr(e.opt, "func") end
                    paint()
                end)
                local function set(v, silent)
                    if multi then
                        chosen = {}
                        for _, x in ipairs(type(v) == "table" and v or {}) do chosen[x] = true end
                    else
                        sel = v
                    end
                    paint()
                    local out = emit()
                    if not silent then task.spawn(cb, out) end
                end
                FlagReg(o.Flag, multi and arr() or sel, set)
                local D = { Instance = row, Set = set }
                function D.Get() return multi and arr() or sel end
                function D.Refresh(newOptions, keep)
                    options = newOptions or {}
                    if keep == false then
                        chosen = {}
                        sel = (not multi) and options[1] or nil
                    elseif multi then
                        local nc = {}
                        for _, v in ipairs(options) do if chosen[v] then nc[v] = true end end
                        chosen = nc
                    else
                        local found = false
                        for _, v in ipairs(options) do if v == sel then found = true break end end
                        if not found then sel = options[1] end
                    end
                    build()
                end
                return D
            end
            function G:Button(...)
                local o = Opts({ "Title", "Desc", "Callback" }, ...)
                local cb = o.Callback or function() end
                local desc = o.Desc
                local h = desc and 44 or 34
                local b = New("TextButton", { Size = UDim2.new(1, 0, 0, h), BackgroundColor3 = T.Card2, Text = "", AutoButtonColor = false, LayoutOrder = ord() }, card)
                Round(b, 9)
                local bs = Stroke(b, T.Stroke, 1, 0.3)
                Interact(b)
                local tl = Label(b, { Position = UDim2.fromOffset(12, desc and 6 or 0), Size = UDim2.new(1, -40, 0, desc and 16 or 34), Text = "", Font = Enum.Font.GothamBold, TextSize = 11 })
                local setTl = Loc(o.Title or "Button", "func", function(t) tl.Text = t end)
                local dl, setDl
                if desc then
                    dl = Label(b, { Position = UDim2.fromOffset(12, 23), Size = UDim2.new(1, -40, 0, 14), Text = "", TextSize = 9, TextColor3 = T.Dim })
                    setDl = Loc(desc, "func", function(t) dl.Text = t end)
                end
                local chev = Label(b, { Position = UDim2.new(1, -26, 0, 0), Size = UDim2.fromOffset(16, h), Text = ">", TextXAlignment = Enum.TextXAlignment.Center, TextColor3 = T.Dim, Font = Enum.Font.GothamBold })
                b.MouseEnter:Connect(function()
                    Tween(b, 0.15, { BackgroundColor3 = T.Card2:Lerp(T.Accent, 0.12) })
                    Tween(bs, 0.15, { Color = T.Accent, Transparency = 0.5 })
                    Tween(chev, 0.15, { TextColor3 = T.Accent })
                end)
                b.MouseLeave:Connect(function()
                    Tween(b, 0.15, { BackgroundColor3 = T.Card2 })
                    Tween(bs, 0.15, { Color = T.Stroke, Transparency = 0.3 })
                    Tween(chev, 0.15, { TextColor3 = T.Dim })
                end)
                b.MouseButton1Click:Connect(function() task.spawn(cb) end)
                return {
                    Instance = b,
                    SetTitle = function(t) setTl(t) end,
                    SetDesc = function(t) if setDl then setDl(t) end end,
                }
            end
            function G:Input(...)
                local o = Opts({ "Title", "Placeholder", "Default", "Callback", "Flag" }, ...)
                local cb = o.Callback
                local row = New("Frame", { Size = UDim2.new(1, 0, 0, 54), BackgroundTransparency = 1, LayoutOrder = ord() }, card)
                local tl = Label(row, { Size = UDim2.new(1, 0, 0, 14), Text = "", TextSize = 10.5, TextColor3 = T.Dim })
                Loc(o.Title or "Input", "func", function(t) tl.Text = t end)
                local tb = New("TextBox", {
                    Position = UDim2.fromOffset(0, 18), Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = T.Card2,
                    Text = o.Default or "", PlaceholderText = "", PlaceholderColor3 = T.Muted,
                    Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = T.Text, ClearTextOnFocus = false,
                    TextXAlignment = Enum.TextXAlignment.Left,
                }, row)
                Round(tb, 8)
                local ts = Stroke(tb, T.Stroke, 1, 0.3)
                New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }, tb)
                Loc(o.Placeholder or "", "func", function(t) tb.PlaceholderText = t end)
                tb.Focused:Connect(function() Tween(ts, 0.15, { Color = T.Accent, Transparency = 0 }) end)
                tb.FocusLost:Connect(function()
                    Tween(ts, 0.15, { Color = T.Stroke, Transparency = 0.3 })
                    FlagSet(o.Flag, tb.Text)
                    if cb then task.spawn(cb, tb.Text) end
                end)
                local function set(v, silent)
                    tb.Text = tostring(v or "")
                    FlagSet(o.Flag, tb.Text)
                    if not silent and cb then task.spawn(cb, tb.Text) end
                end
                FlagReg(o.Flag, tb.Text, set)
                return { Instance = tb, Set = set, Get = function() return tb.Text end }
            end
            function G:Keybind(...)
                local o = Opts({ "Title", "Default", "Callback", "Changed", "Flag" }, ...)
                local key = o.Default or Enum.KeyCode.Unknown
                local listening = false
                local row = New("Frame", { Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, LayoutOrder = ord() }, card)
                local tl = Label(row, { Size = UDim2.new(1, -100, 1, 0), Text = "", Font = Enum.Font.GothamMedium, TextSize = 11.5 })
                Loc(o.Title or "Keybind", "func", function(t) tl.Text = t end)
                local kb = New("TextButton", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(92, 24), BackgroundColor3 = T.Card2, Text = "", AutoButtonColor = false }, row)
                Round(kb, 7)
                local ks = Stroke(kb, T.Stroke, 1, 0.3)
                Interact(kb)
                local kl = Label(kb, { Size = UDim2.fromScale(1, 1), Text = "", TextXAlignment = Enum.TextXAlignment.Center, Font = Enum.Font.GothamBold, TextSize = 10 })
                local function show()
                    kl.Text = key == Enum.KeyCode.Unknown and Tr("None", "func") or key.Name
                    kl.TextColor3 = T.Text
                    ks.Color = T.Stroke
                end
                show()
                table.insert(W.LangFns, function() if not listening then show() end end)
                local function set(k, silent)
                    if type(k) == "string" then
                        local ok, kc = pcall(function() return Enum.KeyCode[k] end)
                        k = ok and kc or Enum.KeyCode.Unknown
                    end
                    if typeof(k) ~= "EnumItem" then k = Enum.KeyCode.Unknown end
                    key = k
                    show()
                    FlagSet(o.Flag, key.Name)
                    if not silent and o.Changed then task.spawn(o.Changed, key) end
                end
                FlagReg(o.Flag, key.Name, set)
                kb.MouseButton1Click:Connect(function()
                    listening = true
                    W.Listening = true
                    kl.Text = "..."
                    kl.TextColor3 = T.Accent
                    ks.Color = T.Accent
                end)
                Conn(UIS.InputBegan, function(i, gpe)
                    if i.UserInputType ~= Enum.UserInputType.Keyboard then return end
                    if listening then
                        listening = false
                        task.defer(function() W.Listening = false end)
                        if i.KeyCode == Enum.KeyCode.Escape then show()
                        elseif i.KeyCode == Enum.KeyCode.Backspace then set(Enum.KeyCode.Unknown)
                        else set(i.KeyCode) end
                        return
                    end
                    if not gpe and not W.Listening and key ~= Enum.KeyCode.Unknown and i.KeyCode == key and o.Callback then
                        task.spawn(o.Callback, key)
                    end
                end)
                return { Instance = row, Set = set, Get = function() return key end }
            end
            return G
        end
        table.insert(W.Tabs, Tab)
        if #W.Tabs == 1 then Tab:Activate() end
        return Tab
    end
    function W:Select(titleOrTab)
        for _, t in ipairs(W.Tabs) do
            if t == titleOrTab or t.Title == titleOrTab then t:Activate() return end
        end
    end
    function W:BuildHome(tab)
        local page = tab.Content
        local startTime = tick()
        local gc = New("Frame", { Size = UDim2.new(1, 0, 0, 80), BackgroundColor3 = T.Card, BorderSizePixel = 0, LayoutOrder = tab:_ord() }, page)
        Round(gc, 12)
        Stroke(gc, T.Stroke, 1, 0.3)
        local gbar = New("Frame", { Position = UDim2.fromOffset(0, 16), Size = UDim2.fromOffset(4, 48), BorderSizePixel = 0 }, gc)
        Round(gbar, 2)
        AccentGrad(gbar, 90)
        local greet = Label(gc, { Position = UDim2.fromOffset(18, 16), Size = UDim2.new(0.5, 0, 0, 14), Text = Greeting(), TextSize = 10.5, TextColor3 = T.Muted })
        Label(gc, { Position = UDim2.fromOffset(18, 34), Size = UDim2.new(0.5, 0, 0, 28), Text = LP.DisplayName, Font = Enum.Font.GothamBold, TextSize = 18 })
        local clock = Label(gc, { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -18, 0, 14), Size = UDim2.fromOffset(160, 26), TextXAlignment = Enum.TextXAlignment.Right, Font = Enum.Font.GothamBold, TextSize = 21 })
        local date = Label(gc, { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -18, 0, 46), Size = UDim2.fromOffset(160, 14), TextXAlignment = Enum.TextXAlignment.Right, TextSize = 10, TextColor3 = T.Muted })
        local game_ = New("Frame", { Size = UDim2.new(1, 0, 0, 130), BackgroundColor3 = T.Card, BorderSizePixel = 0, ClipsDescendants = true, LayoutOrder = tab:_ord() }, page)
        Round(game_, 14)
        Stroke(game_, T.Stroke, 1, 0.3)
        local iconUrl = "rbxthumb://type=GameIcon&id=" .. tostring(game.GameId) .. "&w=150&h=150"
        local banner = New("ImageLabel", { AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0), Size = UDim2.fromScale(0.7, 1), BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Crop, Image = iconUrl, ImageTransparency = 0.78 }, game_)
        New("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }) }, banner)
        local thumb = New("ImageLabel", { Position = UDim2.fromOffset(16, 22), Size = UDim2.fromOffset(86, 86), BackgroundColor3 = T.Card2, ScaleType = Enum.ScaleType.Crop, Image = iconUrl }, game_)
        Round(thumb, 14)
        local gName = Label(game_, { Position = UDim2.fromOffset(118, 28), Size = UDim2.new(1, -134, 0, 22), Text = "Loading...", Font = Enum.Font.GothamBold, TextSize = 15 })
        local gBy = Label(game_, { Position = UDim2.fromOffset(118, 52), Size = UDim2.new(1, -134, 0, 14), Text = "", TextSize = 10, TextColor3 = T.Muted })
        local function Pill(x, w, text)
            local p = New("Frame", { Position = UDim2.fromOffset(x, 80), Size = UDim2.fromOffset(w, 24), BackgroundColor3 = T.Card2, BackgroundTransparency = 0.2, BorderSizePixel = 0 }, game_)
            Round(p, 12)
            Stroke(p, T.Stroke, 1, 0.3)
            return Label(p, { Size = UDim2.fromScale(1, 1), Text = text, TextSize = 9.5, TextXAlignment = Enum.TextXAlignment.Center, TextColor3 = T.Dim })
        end
        Pill(118, 124, "ID " .. tostring(game.PlaceId))
        local pillPl = Pill(250, 96, "Players 0/0")
        task.spawn(function()
            local ok, info = pcall(function() return Market:GetProductInfo(game.PlaceId) end)
            if ok and info and gName.Parent then
                gName.Text = info.Name or gName.Text
                gBy.Text = "by " .. ((info.Creator and info.Creator.Name) or "Roblox")
            end
        end)
        local grid = New("Frame", { Size = UDim2.new(1, 0, 0, 144), BackgroundTransparency = 1, LayoutOrder = tab:_ord() }, page)
        New("UIGridLayout", { CellSize = UDim2.new(0.5, -5, 0, 67), CellPadding = UDim2.fromOffset(10, 10), SortOrder = Enum.SortOrder.LayoutOrder }, grid)
        local function Stat(label, idx)
            local c = New("Frame", { BackgroundColor3 = T.Card, BorderSizePixel = 0, LayoutOrder = idx }, grid)
            Round(c, 12)
            Stroke(c, T.Stroke, 1, 0.3)
            local b = New("Frame", { Position = UDim2.fromOffset(10, 12), Size = UDim2.fromOffset(3, 42), BorderSizePixel = 0 }, c)
            Round(b, 2)
            AccentGrad(b, 90)
            local sn = Label(c, { Position = UDim2.fromOffset(22, 12), Size = UDim2.new(1, -30, 0, 14), Text = "", TextSize = 10, TextColor3 = T.Muted })
            Loc(label, "ui", function(t) sn.Text = t end)
            return Label(c, { Position = UDim2.fromOffset(22, 32), Size = UDim2.new(1, -30, 0, 22), Text = "-", Font = Enum.Font.GothamBold, TextSize = 14 })
        end
        local sPlayers = Stat("Players", 1)
        local sTime    = Stat("Session time", 2)
        local sFps     = Stat("FPS", 3)
        local sPing    = Stat("Ping", 4)
        local perf = New("Frame", { Size = UDim2.new(1, 0, 0, 124), BackgroundColor3 = T.Card, BorderSizePixel = 0, LayoutOrder = tab:_ord() }, page)
        Round(perf, 12)
        Stroke(perf, T.Stroke, 1, 0.3)
        local pt = Label(perf, { Position = UDim2.fromOffset(16, 12), Size = UDim2.new(0.6, 0, 0, 14), Text = "", Font = Enum.Font.GothamBold, TextSize = 10.5 })
        Loc("Performance (FPS)", "ui", function(t) pt.Text = t end)
        local avgLbl = Label(perf, { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -16, 0, 12), Size = UDim2.fromOffset(140, 14), TextXAlignment = Enum.TextXAlignment.Right, Text = "Avg - FPS", TextSize = 10, TextColor3 = T.Dim })
        local chart = New("Frame", { Position = UDim2.fromOffset(16, 38), Size = UDim2.new(1, -32, 0, 72), BackgroundTransparency = 1, ClipsDescendants = true }, perf)
        local N = 36
        local bars, hist = {}, {}
        for i = 1, N do
            hist[i] = 0
            local b = New("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new((i - 1) / N, 1, 1, 0), Size = UDim2.new(1 / N, -2, 0.05, 0), BackgroundColor3 = T.Accent, BorderSizePixel = 0 }, chart)
            Round(b, 2)
            bars[i] = b
        end
        Themed(function()
            for _, b in ipairs(bars) do b.BackgroundColor3 = T.Accent end
        end)
        table.insert(W.Updaters, function(fps, ping)
            greet.Text = Tr(Greeting(), "ui")
            clock.Text = os.date("%H:%M")
            date.Text = os.date("%d / %m / %Y")
            local cnt, mx = #Players:GetPlayers(), Players.MaxPlayers
            sPlayers.Text = tostring(cnt)
            pillPl.Text = (Tr("Players", "ui") .. " %d/%d"):format(cnt, mx)
            local e = math.floor(tick() - startTime)
            sTime.Text = ("%02d:%02d:%02d"):format(math.floor(e / 3600), math.floor(e / 60) % 60, e % 60)
            sFps.Text = tostring(fps)
            sFps.TextColor3 = fps < 25 and T.Danger or T.Accent
            sPing.Text = ping and (tostring(ping) .. " ms") or "-"
            sPing.TextColor3 = (ping and ping > 150) and T.Danger or T.Accent
            sTime.TextColor3 = T.Text
            sPlayers.TextColor3 = T.Text
            table.remove(hist, 1)
            table.insert(hist, fps)
            local sum, mxv = 0, 60
            for _, v in ipairs(hist) do sum += v if v > mxv then mxv = v end end
            avgLbl.Text = (Tr("Avg", "ui") .. " %d FPS"):format(math.floor(sum / N + 0.5))
            for i, b in ipairs(bars) do
                b.Size = UDim2.new(1 / N, -2, math.clamp(hist[i] / mxv, 0.04, 1), 0)
            end
        end)
    end
    function W:BuildSettings(tab)
        local ap = tab:Group("Appearance", "Left")
        ap:Slider({
            Title = "UI Size", Min = 25, Max = 200, Step = 5, Default = 100, Suffix = "%",
            Flag = "UI.Scale", OnRelease = true,
            Callback = function(v) W:SetUIScale(v / 100) end,
        })
        ap:Dropdown({
            Title = "Quick size", Options = { "25%", "50%", "75%", "100%", "125%", "150%", "200%" }, Default = "100%",
            Callback = function(v) W:SetUIScale(tonumber((v:gsub("%%", ""))) / 100) end,
        })
        ap:Toggle({
            Title = "Auto-fit to screen", Desc = "Shrink UI automatically on small screens", Default = true, Flag = "UI.AutoFit",
            Callback = function(v) W.AutoFit = v W:Rescale() end,
        })
        ap:Dropdown({
            Title = "Accent color", Options = Flexozy.AccentNames, Default = W.AccentName, Flag = "UI.Accent",
            Callback = function(v) W:SetAccent(v) end,
        })
        ap:Slider({
            Title = "Window opacity", Min = 40, Max = 100, Step = 1, Default = 97, Suffix = "%", Flag = "UI.Opacity",
            Callback = function(v) W:SetOpacity(v / 100) end,
        })

        local lg = tab:Group("Language", "Left")
        lg:Dropdown({
            Title = "Language", Options = { "English", "ไทย" }, Default = W.Lang == "TH" and "ไทย" or "English", Flag = "UI.Lang",
            Callback = function(v) W:SetLanguage(v) end,
        })
        lg:Dropdown({
            Title = "Language scope", Options = { "All", "Tabs", "Functions" }, Default = W.LangScope, Flag = "UI.LangScope",
            Callback = function(v) W:SetLanguageScope(v) end,
        })
        lg:Label("All = everything, Tabs = tab names only, Functions = features only")

        local ab = tab:Group("About", "Left")
        ab:Label("Flexozy UI v" .. Flexozy.Version)
        local function keyText()
            return Tr("Toggle key", "func") .. ": " .. (W.Key == Enum.KeyCode.Unknown and Tr("None", "func") or W.Key.Name)
        end
        local keyLbl = ab:Label(keyText())
        table.insert(W.LangFns, function() keyLbl.Set(keyText()) end)

        local it = tab:Group("Interface", "Right")
        it:Toggle({
            Title = "Show FPS / MS pill", Desc = "FPS and ping bar at the top of the screen", Default = W.StatsPill.Visible, Flag = "UI.StatsPill",
            Callback = function(v) W.StatsPill.Visible = v end,
        })
        it:Toggle({
            Title = "Show floating button", Desc = "Floating button to open/close the menu", Default = true, Flag = "UI.FloatButton",
            Callback = function(v) W.Float.Visible = v end,
        })
        it:Toggle({
            Title = "Notifications", Default = true, Flag = "UI.Notify",
            Callback = function(v) W.NotifyEnabled = v end,
        })
        it:Keybind({
            Title = "Toggle UI key", Default = W.Key, Flag = "UI.ToggleKey",
            Changed = function(k)
                W.Key = k
                keyLbl.Set(keyText())
            end,
        })
        it:Button({ Title = "Unload UI", Desc = "Close and disconnect everything", Callback = function() W:Unload() end })

        local pr = tab:Group("Protection", "Right")
        pr:Toggle({
            Title = "Anti-AFK", Desc = "Prevents the 20-minute idle kick", Default = true, Flag = "UI.AntiAfk",
            Callback = function(v) W:SetAntiAfk(v) end,
        })
        pr:Toggle({
            Title = "Auto rejoin", Desc = "Rejoin automatically if disconnected or kicked", Default = false, Flag = "UI.AutoRejoin",
            Callback = function(v) W:SetAutoRejoin(v) end,
        })
        W:SetAntiAfk(true)

        local cf = tab:Group("Config", "Right")
        cf:Toggle({
            Title = "Auto-save", Desc = "Save settings automatically", Default = W.AutoSave, Flag = "UI.AutoSave",
            Callback = function(v) W.AutoSave = v end,
        })
        cf:Input({
            Title = "Config name", Placeholder = "default", Default = W.ConfigName,
            Callback = function(t)
                t = tostring(t):gsub("[^%w_%-]", "")
                if t == "" then t = "default" end
                W.ConfigName = t
            end,
        })
        cf:Button({
            Title = "Save config", Desc = "Save all values to a file",
            Callback = function()
                local ok, err = W:SaveConfig()
                W:Notify({ Title = "Config", Content = ok and (Tr("Saved", "ui") .. ": " .. W.ConfigName) or tostring(err), Type = ok and "Success" or "Error", Force = true })
            end,
        })
        cf:Button({
            Title = "Load config", Desc = "Load values from the file",
            Callback = function()
                local ok, err = W:LoadConfig()
                W:Notify({ Title = "Config", Content = ok and (Tr("Loaded", "ui") .. ": " .. W.ConfigName) or tostring(err), Type = ok and "Success" or "Error", Force = true })
            end,
        })
        cf:Button({
            Title = "Reset UI settings", Desc = "Restore UI options to default",
            Callback = function()
                W:ResetSettings()
                W:Notify({ Title = "Config", Content = "UI settings reset", Force = true })
            end,
        })
    end

    local toastHost = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 52), Size = UDim2.fromOffset(300, 0),
        AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 50,
    }, Gui)
    New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), HorizontalAlignment = Enum.HorizontalAlignment.Center }, toastHost)
    local toastN, toasts = 0, {}
    function W:Notify(n)
        n = n or {}
        if not W.NotifyEnabled and not n.Force then return end
        local col = ({ Success = T.Ok, Warning = T.Warn, Error = T.Danger })[n.Type] or T.Accent
        local dur = n.Duration or 3
        toastN += 1
        if #toasts >= 4 then
            local old = table.remove(toasts, 1)
            pcall(function() old:Destroy() end)
        end
        local wrap = New("Frame", { Size = UDim2.fromOffset(300, 52), BackgroundTransparency = 1, LayoutOrder = toastN }, toastHost)
        table.insert(toasts, wrap)
        local card = New("Frame", { Position = UDim2.fromOffset(0, -80), Size = UDim2.fromScale(1, 1), BackgroundColor3 = C(24, 25, 30), BorderSizePixel = 0 }, wrap)
        Round(card, 12)
        Stroke(card, T.Stroke, 1.2)
        local sideBar = New("Frame", { Position = UDim2.fromOffset(8, 11), Size = UDim2.fromOffset(3, 28), BackgroundColor3 = col, BorderSizePixel = 0 }, card)
        Round(sideBar, 2)
        Label(card, { Position = UDim2.fromOffset(20, 8), Size = UDim2.new(1, -34, 0, 16), Text = Tr(n.Title or "Notice", "ui"), Font = Enum.Font.GothamBold, TextSize = 11.5 })
        Label(card, { Position = UDim2.fromOffset(20, 26), Size = UDim2.new(1, -34, 0, 14), Text = Tr(n.Content or "", "ui"), TextSize = 10, TextColor3 = T.Dim })
        local prog = New("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 12, 1, -3), Size = UDim2.new(1, -24, 0, 2), BackgroundColor3 = col, BackgroundTransparency = 0.45, BorderSizePixel = 0 }, card)
        Round(prog, 1)
        Tween(card, 0.35, { Position = UDim2.fromOffset(0, 0) }, Enum.EasingStyle.Back)
        Tween(prog, dur, { Size = UDim2.new(0, 0, 0, 2) }, Enum.EasingStyle.Linear)
        task.delay(dur, function()
            if wrap and wrap.Parent then
                local tw = Tween(card, 0.25, { Position = UDim2.fromOffset(0, -80) }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                tw.Completed:Connect(function()
                    local idx = table.find(toasts, wrap)
                    if idx then table.remove(toasts, idx) end
                    wrap:Destroy()
                end)
            end
        end)
    end
    function W:SetUIScale(p)
        p = math.clamp(tonumber(p) or 1, 0.25, 3)
        W.UserScale = p
        local s = W.Setters["UI.Scale"]
        if s then pcall(s, p * 100, true) end
        if W.Shown then
            Tween(Scale, 0.18, { Scale = TargetScale() }, Enum.EasingStyle.Quad)
        else
            Scale.Scale = TargetScale()
        end
    end
    function W:SetAccent(c)
        local col, nm = ToColor(c)
        if not col then return end
        T.Accent = col
        W.AccentName = nm or "Custom"
        for _, fn in ipairs(W.ThemeFns) do pcall(fn) end
        if nm and W.Setters["UI.Accent"] then pcall(W.Setters["UI.Accent"], nm, true) end
    end
    function W:SetOpacity(o)
        o = math.clamp(tonumber(o) or 1, 0.2, 1)
        Main.BackgroundTransparency = 1 - o
    end
    function W:Toggle(show)
        if show == nil then show = not W.Shown end
        if show == W.Shown then return end
        W.Shown = show
        local target = TargetScale()
        W._tok = (W._tok or 0) + 1
        local tok = W._tok
        if show then
            Scale.Scale = target * 0.88
            Main.Visible = true
            Tween(Scale, 0.32, { Scale = target }, Enum.EasingStyle.Back)
        else
            W._ddOpen = nil
            Tween(Scale, 0.18, { Scale = target * 0.88 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            task.delay(0.18, function()
                if W._tok == tok and Gui.Parent then
                    Main.Visible = false
                    Scale.Scale = target
                end
            end)
        end
    end
    do
        local t = Scale.Scale
        Scale.Scale = t * 0.88
        Tween(Scale, 0.4, { Scale = t }, Enum.EasingStyle.Back)
    end
    local collapsed = false
    BtnCollapse.MouseButton1Click:Connect(function()
        collapsed = not collapsed
        if collapsed then
            Body.Visible = false
            Tween(Main, 0.25, { Size = UDim2.fromOffset(size.X, HEADER) })
        else
            Tween(Main, 0.25, { Size = UDim2.fromOffset(size.X, size.Y) })
            task.delay(0.12, function() if not collapsed then Body.Visible = true end end)
        end
    end)
    BtnClose.MouseButton1Click:Connect(function() W:Toggle(false) end)
    function W:Unload()
        if W.Unloaded then return end
        W.Unloaded = true
        if afkConn then pcall(function() afkConn:Disconnect() end) end
        if rejoinConn then pcall(function() rejoinConn:Disconnect() end) end
        for _, c in ipairs(W.Conns) do pcall(function() c:Disconnect() end) end
        table.clear(W.Conns)
        table.clear(W.Updaters)
        table.clear(W.ThemeFns)
        if cfg.OnUnload then pcall(cfg.OnUnload) end
        if Gui then Gui:Destroy() end
    end
    W.Destroy = W.Unload
    local Float = New("TextButton", {
        Size = UDim2.fromOffset(50, 50), Position = UDim2.new(0, 24, 0.3, 0), BackgroundColor3 = C(22, 22, 26),
        Text = mono, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = T.Text, AutoButtonColor = false,
    }, Gui)
    Round(Float, 13)
    Interact(Float)
    local floatStroke = Stroke(Float, T.Accent, 2, 0.1)
    Themed(function()
        floatStroke.Color = T.Accent
        Float.TextColor3 = T.Accent:Lerp(WHITE, 0.55)
    end)
    local moved = MakeDraggable(Float, Float, Conn)
    Float.MouseButton1Click:Connect(function()
        if moved() then return end
        W:Toggle()
    end)
    W.Float = Float
    ApplyLogo(Float, function() Float.Text = "" end, cfg.FloatLogo or cfg.Logo, 3)
    local pill = New("Frame", { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 14), Size = UDim2.fromOffset(150, 30), BackgroundColor3 = C(20, 20, 24), BackgroundTransparency = 0.1, BorderSizePixel = 0, Visible = cfg.StatsPill ~= false }, Gui)
    Round(pill, 15)
    Stroke(pill, T.Stroke, 1)
    local pillTxt = Label(pill, { Size = UDim2.fromScale(1, 1), RichText = true, TextXAlignment = Enum.TextXAlignment.Center, TextSize = 10.5, Text = "" })
    W.StatsPill = pill
    local frames, acc = 0, 0
    Conn(RunService.Heartbeat, function(dt)
        frames += 1
        acc += dt
        if acc >= 0.25 then
            local fps = math.floor(frames / acc + 0.5)
            frames, acc = 0, 0
            local ok, ping = pcall(function() return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
            ping = ok and ping or nil
            local hx = Hex(T.Accent)
            pillTxt.Text = ('<font color="%s"><b>%d</b></font> <font color="#8e919b">FPS</font>   |   <font color="%s"><b>%s</b></font> <font color="#8e919b">MS</font>'):format(hx, fps, hx, ping and tostring(ping) or "-")
            for _, fn in ipairs(W.Updaters) do pcall(fn, fps, ping) end
        end
    end)
    Conn(UIS.InputBegan, function(i, gpe)
        if gpe or W.Listening then return end
        if i.UserInputType == Enum.UserInputType.Keyboard and W.Key ~= Enum.KeyCode.Unknown and i.KeyCode == W.Key then
            W:Toggle()
        end
    end)
    return W
end
pcall(function() if getgenv then getgenv().Flexozy = Flexozy end end)
return Flexozy
