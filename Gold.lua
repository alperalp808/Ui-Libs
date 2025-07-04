--// uilib v1.2  – Symphony-Hub stili + animasyonlar
--   Toggle, Button, Dropdown, Slider, Keybind elemanları
--   TweenService ile geçiş/geri besleme animasyonları

---------------------------------------------------------------------
--  Servisler
---------------------------------------------------------------------
local Players      = game:GetService("Players")
local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

---------------------------------------------------------------------
--  Yardımcı fonksiyon: Tween oluştur (kısaltma)
---------------------------------------------------------------------
local function tween(obj, t, props, dir)
    return TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
end

---------------------------------------------------------------------
--  Kütüphane tabloları
---------------------------------------------------------------------
local Lib, Tab = {}, {}
Lib.__index, Tab.__index = Lib, Tab

---------------------------------------------------------------------
--  Sürüklenebilirlik (mouse + touch)
---------------------------------------------------------------------
local function makeDraggable(handle, window)
    local dragging, dragStart, startPos = false, nil, nil
    local function update(input)
        local d = input.Position - dragStart
        window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging, dragStart, startPos = true, i.Position, window.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            update(i)
        end
    end)
end

---------------------------------------------------------------------
--  Ana pencere oluşturucu
---------------------------------------------------------------------
function Lib:CreateWindow(o)
    o = o or {}
    local title   = o.Title  or "UILib"
    local accent  = o.Accent or Color3.fromRGB(0, 140, 255)
    local width   = o.Width  or 550
    local height  = o.Height or 350

    local gui = Instance.new("ScreenGui")
    gui.Name   = o.Name or "UILib"
    gui.IgnoreGuiInset, gui.ResetOnSpawn = true, false
    gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame", gui)
    frame.Size  = UDim2.new(0, width, 0, height)
    frame.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 0
    frame.ClipsDescendants = true
    frame.Name = "MainWindow"
    frame.ZIndex = 2
    frame:SetAttribute("Rounded", true)

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 8)

    local top = Instance.new("TextButton", frame)
    top.Size  = UDim2.new(1, 0, 0, 28)
    top.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    top.Text  = title
    top.Font  = Enum.Font.GothamBold
    top.TextSize, top.TextColor3 = 16, Color3.new(1, 1, 1)
    makeDraggable(top, frame)
    Instance.new("UICorner", top).CornerRadius = UDim.new(0, 6)

    -- sol sekme barı
    local side = Instance.new("Frame", frame)
    side.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    side.Size, side.Position = UDim2.new(0, 140, 1, -28), UDim2.new(0, 0, 0, 28)
    Instance.new("UICorner", side).CornerRadius = UDim.new(0, 6)

    local sideLayout = Instance.new("UIListLayout", side)
    sideLayout.SortOrder, sideLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 4)

    -- içerik sayfaları
    local pages = Instance.new("Folder", frame)

    -- API döndürülecek nesne
    local lib = setmetatable({Accent = accent, _pages = pages, _side = side}, Lib)

    -----------------------------------------------------------------
    --  Sekme oluşturucu
    -----------------------------------------------------------------
    function lib:Tab(name, icon)
        local btn = Instance.new("TextButton", side)
        btn.Size  = UDim2.new(1, -8, 0, 32)
        btn.Position, btn.BackgroundColor3 = UDim2.new(0, 4, 0, 0), Color3.fromRGB(180, 0, 0)
        btn.Font, btn.TextSize, btn.TextColor3 = Enum.Font.GothamBold, 14, Color3.new(1, 1, 1)
        btn.Text = (icon and (icon .. " ") or "") .. name
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        local page = Instance.new("Frame", pages)
        page.Size, page.Position = UDim2.new(1, -150, 1, -38), UDim2.new(0, 148, 0, 34)
        page.BackgroundColor3, page.Visible = Color3.fromRGB(0, 60, 150), false
        Instance.new("UICorner", page).CornerRadius = UDim.new(0, 6)

        local layout = Instance.new("UIListLayout", page)
        layout.SortOrder, layout.Padding, layout.HorizontalAlignment = Enum.SortOrder.LayoutOrder, UDim.new(0, 6), Enum.HorizontalAlignment.Center

        -- ilk sekme açık olsun
        if #side:GetChildren() == 2 then
            page.Visible = true
            btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end

        btn.MouseButton1Click:Connect(function()
            for _, p in ipairs(pages:GetChildren()) do p.Visible = false end
            for _, b in ipairs(side:GetChildren()) do if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(180, 0, 0) end end
            page.Visible, btn.BackgroundColor3 = true, Color3.fromRGB(255, 0, 0)
        end)

        local tab = setmetatable({ _page = page, Accent = accent }, Tab)
        return tab
    end

    return lib
end
