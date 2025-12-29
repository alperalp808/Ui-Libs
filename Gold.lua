--// Simple Tab UI Library (MM2 Style)

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- UI
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "TabUI"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.fromOffset(520, 360)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

-- Left Tab Bar
local Tabs = Instance.new("Frame", Main)
Tabs.Size = UDim2.fromOffset(120, 360)
Tabs.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Tabs.BorderSizePixel = 0

local TabLayout = Instance.new("UIListLayout", Tabs)
TabLayout.Padding = UDim.new(0, 6)
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Content
local Pages = Instance.new("Frame", Main)
Pages.Position = UDim2.fromOffset(120, 0)
Pages.Size = UDim2.fromOffset(400, 360)
Pages.BackgroundTransparency = 1

-- LIB
local Library = {}
Library.Tabs = {}

-- TAB CREATE
function Library:CreateTab(name)
	local TabButton = Instance.new("TextButton", Tabs)
	TabButton.Size = UDim2.fromOffset(100, 36)
	TabButton.Text = name
	TabButton.Font = Enum.Font.GothamBold
	TabButton.TextSize = 13
	TabButton.TextColor3 = Color3.new(1,1,1)
	TabButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
	Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0,6)

	local Page = Instance.new("ScrollingFrame", Pages)
	Page.Size = UDim2.fromScale(1,1)
	Page.CanvasSize = UDim2.new(0,0,0,0)
	Page.ScrollBarImageTransparency = 1
	Page.Visible = false

	local Layout = Instance.new("UIListLayout", Page)
	Layout.Padding = UDim.new(0, 8)

	TabButton.MouseButton1Click:Connect(function()
		for _,v in pairs(Pages:GetChildren()) do
			if v:IsA("ScrollingFrame") then
				v.Visible = false
			end
		end
		Page.Visible = true
	end)

	if #Pages:GetChildren() == 1 then
		Page.Visible = true
	end

	local Tab = {}

	-- SECTION
	function Tab:AddSection(title)
		local Section = Instance.new("Frame", Page)
		Section.Size = UDim2.new(1, -10, 0, 30)
		Section.BackgroundColor3 = Color3.fromRGB(30,30,30)
		Instance.new("UICorner", Section).CornerRadius = UDim.new(0,6)

		local Title = Instance.new("TextLabel", Section)
		Title.Size = UDim2.fromScale(1,1)
		Title.Text = title
		Title.TextColor3 = Color3.fromRGB(180,180,180)
		Title.BackgroundTransparency = 1
		Title.Font = Enum.Font.GothamBold
		Title.TextSize = 12

		local SectionAPI = {}

		-- TOGGLE
		function SectionAPI:AddToggle(opt)
			local T = Instance.new("TextButton", Page)
			T.Size = UDim2.new(1, -10, 0, 34)
			T.Text = opt.Name
			T.BackgroundColor3 = Color3.fromRGB(45,45,45)
			T.TextColor3 = Color3.new(1,1,1)
			T.Font = Enum.Font.Gotham
			T.TextSize = 12
			Instance.new("UICorner", T).CornerRadius = UDim.new(0,6)

			local state = false
			T.MouseButton1Click:Connect(function()
				state = not state
				T.BackgroundColor3 = state and Color3.fromRGB(90,60,140) or Color3.fromRGB(45,45,45)
				if opt.Callback then
					opt.Callback(state)
				end
			end)
		end

		-- BUTTON
		function SectionAPI:AddButton(opt)
			local B = Instance.new("TextButton", Page)
			B.Size = UDim2.new(1, -10, 0, 32)
			B.Text = opt.Name
			B.BackgroundColor3 = Color3.fromRGB(60,60,60)
			B.TextColor3 = Color3.new(1,1,1)
			B.Font = Enum.Font.Gotham
			B.TextSize = 12
			Instance.new("UICorner", B).CornerRadius = UDim.new(0,6)

			B.MouseButton1Click:Connect(function()
				if opt.Callback then opt.Callback() end
			end)
		end

		-- TEXTBOX
		function SectionAPI:AddTextbox(opt)
			local Box = Instance.new("TextBox", Page)
			Box.Size = UDim2.new(1, -10, 0, 32)
			Box.PlaceholderText = opt.Name
			Box.BackgroundColor3 = Color3.fromRGB(50,50,50)
			Box.TextColor3 = Color3.new(1,1,1)
			Box.Font = Enum.Font.Gotham
			Box.TextSize = 12
			Instance.new("UICorner", Box).CornerRadius = UDim.new(0,6)

			Box.FocusLost:Connect(function()
				if opt.Callback then opt.Callback(Box.Text) end
			end)
		end

		return SectionAPI
	end

	return Tab
end

-- EXPORT
return Library