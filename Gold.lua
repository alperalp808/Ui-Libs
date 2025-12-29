--// UI LIBRARY - Single File
--// Right Drawer Tab System
--// Executor & Mobile Friendly

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local Library = {}
Library.__index = Library

--// CREATE WINDOW
function Library:CreateWindow(title)
    local self = setmetatable({}, Library)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UI_LIB"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.fromOffset(480, 360)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(20,20,26)
    Main.ClipsDescendants = true

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0,14)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(90,90,140)

    -- TOP BAR
    local Top = Instance.new("Frame", Main)
    Top.Size = UDim2.new(1,0,0,40)
    Top.BackgroundTransparency = 1

    local Title = Instance.new("TextLabel", Top)
    Title.Size = UDim2.fromScale(1,1)
    Title.BackgroundTransparency = 1
    Title.Text = title or "UI"
    Title.TextColor3 = Color3.fromRGB(220,220,240)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14

    -- CONTENT
    local Content = Instance.new("Frame", Main)
    Content.Position = UDim2.fromOffset(0,40)
    Content.Size = UDim2.new(1,-60,1,-40)
    Content.BackgroundTransparency = 1

    -- RIGHT DRAWER (TAB SELECTOR)
    local Drawer = Instance.new("Frame", Main)
    Drawer.Size = UDim2.fromOffset(60,360)
    Drawer.Position = UDim2.new(1,0,0,0)
    Drawer.BackgroundColor3 = Color3.fromRGB(26,26,32)

    Instance.new("UIStroke", Drawer).Color = Color3.fromRGB(100,100,160)

    local DrawerLayout = Instance.new("UIListLayout", Drawer)
    DrawerLayout.HorizontalAlignment = Center
    DrawerLayout.Padding = UDim.new(0,6)

    local Tabs = {}
    local CurrentTab = nil

    -- TOGGLE MENU
    UIS.InputBegan:Connect(function(i,g)
        if g then return end
        if i.KeyCode == Enum.KeyCode.RightShift then
            Main.Visible = not Main.Visible
        end
    end)

    -- TAB CREATION
    function self:AddTab(name)
        local Tab = {}
        Tab.Sections = {}

        local Btn = Instance.new("TextButton", Drawer)
        Btn.Size = UDim2.fromOffset(50,36)
        Btn.BackgroundColor3 = Color3.fromRGB(35,35,45)
        Btn.Text = name
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 12
        Btn.TextColor3 = Color3.fromRGB(210,210,230)
        Btn.AutoButtonColor = false
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)

        local TabFrame = Instance.new("ScrollingFrame", Content)
        TabFrame.Visible = false
        TabFrame.Size = UDim2.fromScale(1,1)
        TabFrame.CanvasSize = UDim2.new(0,0,0,0)
        TabFrame.ScrollBarImageTransparency = 1
        TabFrame.BackgroundTransparency = 1

        local Layout = Instance.new("UIListLayout", TabFrame)
        Layout.Padding = UDim.new(0,8)

        Btn.MouseButton1Click:Connect(function()
            if CurrentTab then
                CurrentTab.Visible = false
            end
            TabFrame.Visible = true
            CurrentTab = TabFrame
        end)

        -- SECTION
        function Tab:AddSection(name)
            local Section = {}

            local Holder = Instance.new("Frame", TabFrame)
            Holder.Size = UDim2.new(1,-10,0,30)
            Holder.BackgroundColor3 = Color3.fromRGB(28,28,36)
            Instance.new("UICorner", Holder).CornerRadius = UDim.new(0,10)
            Instance.new("UIStroke", Holder).Color = Color3.fromRGB(90,90,130)

            local Title = Instance.new("TextLabel", Holder)
            Title.Size = UDim2.new(1,-10,0,30)
            Title.Position = UDim2.fromOffset(10,0)
            Title.BackgroundTransparency = 1
            Title.Text = name
            Title.Font = Enum.Font.GothamBold
            Title.TextSize = 13
            Title.TextColor3 = Color3.fromRGB(220,220,240)
            Title.TextXAlignment = Left

            local Inner = Instance.new("UIListLayout", Holder)
            Inner.Padding = UDim.new(0,6)

            -- AUTO RESIZE
            Inner:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Holder.Size = UDim2.new(1,-10,0,Inner.AbsoluteContentSize.Y + 10)
                TabFrame.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
            end)

            -- TOGGLE
            function Section:AddToggle(data)
                local Toggle = Instance.new("TextButton", Holder)
                Toggle.Size = UDim2.new(1,-20,0,30)
                Toggle.Position = UDim2.fromOffset(10,0)
                Toggle.Text = data.Name
                Toggle.Font = Enum.Font.Gotham
                Toggle.TextSize = 12
                Toggle.TextColor3 = Color3.fromRGB(200,200,220)
                Toggle.BackgroundColor3 = Color3.fromRGB(40,40,55)
                Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0,8)

                local State = false
                Toggle.MouseButton1Click:Connect(function()
                    State = not State
                    Toggle.BackgroundColor3 = State and Color3.fromRGB(70,90,140) or Color3.fromRGB(40,40,55)
                    if data.Callback then
                        data.Callback(State)
                    end
                end)
            end

            -- BUTTON
            function Section:AddButton(data)
                local Btn = Instance.new("TextButton", Holder)
                Btn.Size = UDim2.new(1,-20,0,30)
                Btn.Position = UDim2.fromOffset(10,0)
                Btn.Text = data.Name
                Btn.Font = Enum.Font.Gotham
                Btn.TextSize = 12
                Btn.TextColor3 = Color3.fromRGB(220,220,240)
                Btn.BackgroundColor3 = Color3.fromRGB(60,60,80)
                Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)

                Btn.MouseButton1Click:Connect(function()
                    if data.Callback then
                        data.Callback()
                    end
                end)
            end

            -- TEXTBOX
            function Section:AddTextbox(data)
                local Box = Instance.new("TextBox", Holder)
                Box.Size = UDim2.new(1,-20,0,30)
                Box.Position = UDim2.fromOffset(10,0)
                Box.PlaceholderText = data.Name
                Box.Text = ""
                Box.Font = Enum.Font.Gotham
                Box.TextSize = 12
                Box.TextColor3 = Color3.fromRGB(220,220,240)
                Box.BackgroundColor3 = Color3.fromRGB(35,35,45)
                Instance.new("UICorner", Box).CornerRadius = UDim.new(0,8)

                Box.FocusLost:Connect(function()
                    if data.Callback then
                        data.Callback(Box.Text)
                    end
                end)
            end

            return Section
        end

        if not CurrentTab then
            TabFrame.Visible = true
            CurrentTab = TabFrame
        end

        table.insert(Tabs, TabFrame)
        return Tab
    end

    return self
end

return Library