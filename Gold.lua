--// UI Library - Single File (FIXED)
--// Right Drawer Tab Selector
--// Executor / Mobile Friendly

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local Library = {}
Library.__index = Library

--==================================================
-- CREATE WINDOW
--==================================================
function Library:CreateWindow(title)
    local self = setmetatable({}, Library)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomUILib"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui

    -- MAIN FRAME
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.fromOffset(480, 360)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    Main.ClipsDescendants = true

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(90, 90, 140)

    -- TOP BAR
    local Top = Instance.new("Frame", Main)
    Top.Size = UDim2.new(1, 0, 0, 40)
    Top.BackgroundTransparency = 1

    local Title = Instance.new("TextLabel", Top)
    Title.Size = UDim2.new(1, -10, 1, 0)
    Title.Position = UDim2.fromOffset(10, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title or "UI"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextColor3 = Color3.fromRGB(220, 220, 240)
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- CONTENT AREA
    local Content = Instance.new("Frame", Main)
    Content.Position = UDim2.fromOffset(0, 40)
    Content.Size = UDim2.new(1, -60, 1, -40)
    Content.BackgroundTransparency = 1

    -- RIGHT DRAWER (TAB SELECTOR)
    local Drawer = Instance.new("Frame", Main)
    Drawer.Size = UDim2.fromOffset(60, 360)
    Drawer.Position = UDim2.new(1, 0, 0, 0)
    Drawer.BackgroundColor3 = Color3.fromRGB(26, 26, 32)

    Instance.new("UIStroke", Drawer).Color = Color3.fromRGB(100, 100, 160)

    local DrawerLayout = Instance.new("UIListLayout", Drawer)
    DrawerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    DrawerLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    DrawerLayout.Padding = UDim.new(0, 6)

    -- TOGGLE MENU (RightShift)
    UIS.InputBegan:Connect(function(i, g)
        if g then return end
        if i.KeyCode == Enum.KeyCode.RightShift then
            Main.Visible = not Main.Visible
        end
    end)

    local CurrentTabFrame = nil

    --==================================================
    -- ADD TAB
    --==================================================
    function self:AddTab(name)
        local Tab = {}

        -- TAB BUTTON (RIGHT DRAWER)
        local TabBtn = Instance.new("TextButton", Drawer)
        TabBtn.Size = UDim2.fromOffset(50, 36)
        TabBtn.Text = name
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 12
        TabBtn.TextColor3 = Color3.fromRGB(210, 210, 230)
        TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        TabBtn.AutoButtonColor = false

        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

        -- TAB FRAME
        local TabFrame = Instance.new("ScrollingFrame", Content)
        TabFrame.Size = UDim2.fromScale(1, 1)
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabFrame.ScrollBarImageTransparency = 1
        TabFrame.BackgroundTransparency = 1
        TabFrame.Visible = false

        local TabLayout = Instance.new("UIListLayout", TabFrame)
        TabLayout.Padding = UDim.new(0, 8)

        TabBtn.MouseButton1Click:Connect(function()
            if CurrentTabFrame then
                CurrentTabFrame.Visible = false
            end
            TabFrame.Visible = true
            CurrentTabFrame = TabFrame
        end)

        if not CurrentTabFrame then
            TabFrame.Visible = true
            CurrentTabFrame = TabFrame
        end

        --==================================================
        -- ADD SECTION
        --==================================================
        function Tab:AddSection(name)
            local Section = {}

            local Holder = Instance.new("Frame", TabFrame)
            Holder.Size = UDim2.new(1, -10, 0, 30)
            Holder.BackgroundColor3 = Color3.fromRGB(28, 28, 36)

            Instance.new("UICorner", Holder).CornerRadius = UDim.new(0, 10)
            Instance.new("UIStroke", Holder).Color = Color3.fromRGB(90, 90, 130)

            local SecTitle = Instance.new("TextLabel", Holder)
            SecTitle.Size = UDim2.new(1, -10, 0, 28)
            SecTitle.Position = UDim2.fromOffset(10, 0)
            SecTitle.BackgroundTransparency = 1
            SecTitle.Text = name
            SecTitle.Font = Enum.Font.GothamBold
            SecTitle.TextSize = 13
            SecTitle.TextColor3 = Color3.fromRGB(220, 220, 240)
            SecTitle.TextXAlignment = Enum.TextXAlignment.Left

            local InnerLayout = Instance.new("UIListLayout", Holder)
            InnerLayout.Padding = UDim.new(0, 6)

            -- AUTO RESIZE
            InnerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Holder.Size = UDim2.new(1, -10, 0, InnerLayout.AbsoluteContentSize.Y + 6)
                TabFrame.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
            end)

            --==================================================
            -- TOGGLE
            --==================================================
            function Section:AddToggle(data)
                local Toggle = Instance.new("TextButton", Holder)
                Toggle.Size = UDim2.new(1, -20, 0, 30)
                Toggle.Position = UDim2.fromOffset(10, 0)
                Toggle.Text = data.Name or "Toggle"
                Toggle.Font = Enum.Font.Gotham
                Toggle.TextSize = 12
                Toggle.TextColor3 = Color3.fromRGB(200, 200, 220)
                Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
                Toggle.AutoButtonColor = false

                Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 8)

                local State = false
                Toggle.MouseButton1Click:Connect(function()
                    State = not State
                    Toggle.BackgroundColor3 = State
                        and Color3.fromRGB(70, 90, 140)
                        or Color3.fromRGB(40, 40, 55)

                    if data.Callback then
                        data.Callback(State)
                    end
                end)
            end

            --==================================================
            -- BUTTON
            --==================================================
            function Section:AddButton(data)
                local Btn = Instance.new("TextButton", Holder)
                Btn.Size = UDim2.new(1, -20, 0, 30)
                Btn.Position = UDim2.fromOffset(10, 0)
                Btn.Text = data.Name or "Button"
                Btn.Font = Enum.Font.Gotham
                Btn.TextSize = 12
                Btn.TextColor3 = Color3.fromRGB(220, 220, 240)
                Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                Btn.AutoButtonColor = false

                Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

                Btn.MouseButton1Click:Connect(function()
                    if data.Callback then
                        data.Callback()
                    end
                end)
            end

            --==================================================
            -- SLIDER
            --==================================================
            function Section:AddSlider(data)
                local Min = data.Min or 0
                local Max = data.Max or 100
                local Value = data.Default or Min

                local Holder2 = Instance.new("Frame", Holder)
                Holder2.Size = UDim2.new(1, -20, 0, 40)
                Holder2.Position = UDim2.fromOffset(10, 0)
                Holder2.BackgroundTransparency = 1

                local Label = Instance.new("TextLabel", Holder2)
                Label.Size = UDim2.new(1, 0, 0, 16)
                Label.BackgroundTransparency = 1
                Label.Text = data.Name .. " : " .. Value
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 12
                Label.TextColor3 = Color3.fromRGB(220, 220, 240)
                Label.TextXAlignment = Enum.TextXAlignment.Left

                local Bar = Instance.new("Frame", Holder2)
                Bar.Position = UDim2.fromOffset(0, 22)
                Bar.Size = UDim2.new(1, 0, 0, 10)
                Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 55)

                Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

                local Fill = Instance.new("Frame", Bar)
                Fill.Size = UDim2.fromScale((Value - Min) / (Max - Min), 1)
                Fill.BackgroundColor3 = Color3.fromRGB(80, 100, 160)
                Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

                local Dragging = false
                Bar.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = true
                    end
                end)

                UIS.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = false
                    end
                end)

                UIS.InputChanged:Connect(function(i)
                    if Dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                        local pct = math.clamp(
                            (i.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X,
                            0, 1
                        )
                        Value = math.floor(Min + (Max - Min) * pct)
                        Fill.Size = UDim2.fromScale(pct, 1)
                        Label.Text = data.Name .. " : " .. Value
                        if data.Callback then
                            data.Callback(Value)
                        end
                    end
                end)
            end

            --==================================================
            -- TEXTBOX
            --==================================================
            function Section:AddTextbox(data)
                local Box = Instance.new("TextBox", Holder)
                Box.Size = UDim2.new(1, -20, 0, 30)
                Box.Position = UDim2.fromOffset(10, 0)
                Box.PlaceholderText = data.Name or "Text"
                Box.Text = ""
                Box.Font = Enum.Font.Gotham
                Box.TextSize = 12
                Box.TextColor3 = Color3.fromRGB(220, 220, 240)
                Box.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                Box.ClearTextOnFocus = false

                Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 8)

                Box.FocusLost:Connect(function()
                    if data.Callback then
                        data.Callback(Box.Text)
                    end
                end)
            end

            return Section
        end

        return Tab
    end

    return self
end

return Library