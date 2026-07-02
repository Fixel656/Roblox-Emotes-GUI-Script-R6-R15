--V2.9
--[[Script by Fixel656, based on Energize GUI by illremember
DO NOT COPY AND CLAIM AS YOUR OWN, if you are using some of the script for your own, 
credit is highly appreciated!]]

local GuiActive = true
local GuiEmoter = nil
local Player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local AnimPreviewEnable = true
local ToolAnimHighPrior = false

--Restart Values
local GuiPos = nil
local ScrollingFramePos = nil
local GuiClosed = false
local OptionsOpened = false

local SearchOpened = false
local PrevAnimSpeedValue = ""
local PrevSearchText = ""

local function CreateGui()

	local Emoter = Instance.new("ScreenGui") -- The actual GUI
	local SideFrame = Instance.new("Frame") -- Visible when GUI is closed
	local OpenGUI = Instance.new("ImageButton") -- Part of SideFrame
	local SideFrameTitle = Instance.new("TextLabel") -- Part of SideFrame
	local MainFrame = Instance.new("Frame") -- All of the stuff on the main frame
	
	local ViewportFrame = Instance.new("ViewportFrame")
	local ClonedChar = nil
	
	local OptionsFrame = Instance.new("Frame")
	local PauseAnimsButton = Instance.new("ImageButton")
	local StopDefAnimsButton = Instance.new("ImageButton")
	local StopAnimsEvent = Instance.new("BindableEvent") -- To stop animations when disabling StopDefaultAnims option
	local PauseAnimateButton = Instance.new("ImageButton")
	local PreviewEnableButton = Instance.new("ImageButton")
	
	local GuiBottomFrame = Instance.new("Frame")
	local SpeedFrame = Instance.new("Frame") -- Frame of Speed Changer
	local CurSpeedText = Instance.new("TextLabel") --Text showing your current anim speed
	local OptionsButton = Instance.new("ImageButton")

	local ScrollingFrame = Instance.new("ScrollingFrame") -- The scrolling frame of animations
	local ScrollingFrameR15 = Instance.new("ScrollingFrame") -- The scrolling frame of R15 animations

	local GuiTopFrame = Instance.new("Frame") -- Top of the main frame
	local DestroyGUI = Instance.new("TextButton") -- To Destroy the GUI
	local SFDestroyGUI = Instance.new("TextButton") -- To Destroy the GUI in SideFrame
	local CloseGUI = Instance.new("ImageButton") -- To close the GUI
	local Title = Instance.new("TextLabel") -- Actual title of GUI, Emoter
	
	local SearchFrame = Instance.new("Frame")
	local SearchButton = Instance.new("ImageButton")
	local SearchBox = Instance.new("TextBox")
	local BackButton = Instance.new("ImageButton")

	local SpeedNum --Value, adding to default speed of animation

	--AnimButtons are in new place now (~495 string)
	--Violet Color (0.541176, 0.647059, 1)
	--LightViolet Color (0.756863, 0.823529, 1)
	
	BgColor = Color3.fromRGB(137, 165, 255)
	ScrollBgColor = Color3.fromRGB(219, 244, 255)
	UiButColor = Color3.new(0, 0, 0) -- Color of GUI's buttons
	ButtonCol = Color3.fromRGB(192, 191, 211) -- R6 Button Color
	ButtonSelectCol = Color3.fromRGB(255, 255, 255) -- R6 Button darker color (idk how to make it just darker BgColor yet)
	R15ButtonCol = Color3.fromRGB(192, 191, 211) --R15 Button color
	R15ButtonSelectCol = Color3.fromRGB(255, 255, 255) -- R15 Button darker color

	local function AddHoverText(Object, Text)
		local TextLabel = nil
		Object.MouseEnter:connect(function()
			TextLabel = Instance.new("TextLabel")
			TextLabel.Parent = Emoter
			TextLabel.Visible = false
			TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.Text = Text
			TextLabel.AutomaticSize = Enum.AutomaticSize.XY
			TextLabel.Size = UDim2.new(0, 5, 0, 17)
			TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextLabel.TextSize = 17
			TextLabel.TextWrapped = true
			TextLabel.Font = Enum.Font.SourceSans

			local UIPadding = Instance.new("UIPadding")
			UIPadding.PaddingLeft = UDim.new(0, 2)
			UIPadding.PaddingRight = UDim.new(0, 4)
			UIPadding.PaddingBottom = UDim.new(0, 2)
			UIPadding.Parent = TextLabel

			local UserInputService = game:GetService("UserInputService")
			local mouse = Player:GetMouse()
			TextLabel.Position = UDim2.new(0, mouse.X, 0, mouse.Y + 25)
			TextLabel.Visible = true
			mouse.Move:connect(function()
				TextLabel.Position = UDim2.new(0, mouse.X, 0, mouse.Y + 25)
			end)
			-- Add hover text
		end)
		Object.MouseLeave:connect(function()
			TextLabel:Destroy()
			-- Destroy hover text
		end)
	end

	local function CreateAnimButton(Object, Name, Text, Type, LayoutPos)
		local Button = Object
		Button.Name = Name
		if Type == "R6" then
			Button.Parent = ScrollingFrame
		elseif Type == "R15" then
			Button.Parent = ScrollingFrameR15
		end
		if Type == "R6" then
			Button.BackgroundColor3 = ButtonCol
		elseif Type == "R15" then
			Button.BackgroundColor3 = R15ButtonCol
		end
		
		Button.FontFace.Weight = Enum.FontWeight.Bold
		Button.Size = UDim2.new(0, 100, 0, 30)
		Button.RichText = true
		Button.Font = Enum.Font.Roboto
		Button.Text = "<b>" .. Text .. "</b>"
		Button.TextScaled = true
		Button.LayoutOrder = LayoutPos
		
		local ButtonPadding = Instance.new("UIPadding")
		ButtonPadding.Parent = Button
		ButtonPadding.PaddingLeft = UDim.new(0, 2)
		ButtonPadding.PaddingRight = UDim.new(0, 2)
		
	end
	
	local function AddVPF()
		ViewportFrame.Parent = MainFrame
		ViewportFrame.Visible = false
		ViewportFrame.BackgroundTransparency = 1
		ViewportFrame.Size = UDim2.new(0, 225, 0, 285)
		ViewportFrame.Position = UDim2.new(1, 10, 0, 0)
		ViewportFrame.BackgroundColor3 = Color3.fromRGB(166, 174, 175)
		ViewportFrame.Ambient = Color3.fromRGB(175, 175, 175)
		ViewportFrame.LightColor = Color3.fromRGB(208, 208, 208)
		local UICorner = Instance.new("UICorner")
		UICorner.Parent = ViewportFrame

		local WorldModel = Instance.new("WorldModel")
		WorldModel.Parent = ViewportFrame
		local Character = nil
		local function WaitForChar()
			while wait() do 
				if Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild("HumanoidRootPart") then
					Character = Player.Character or Player.CharacterAdded:Wait()
					return
				end
			end
		end
		WaitForChar()
		wait(0.5)
		local VPFcam = Instance.new("Camera"); VPFcam.Parent = ViewportFrame
		VPFcam.CameraType = Enum.CameraType.Scriptable

		local targetPosition = nil
		if (game:GetService"Players".LocalPlayer.Character:WaitForChild("Humanoid").RigType == Enum.HumanoidRigType.R15) then
			targetPosition = Vector3.new(4.6, 0.2, 12) -- if R15
		else
			targetPosition = Vector3.new(4.6, -1, 12)
		end

		local targetRotation = CFrame.Angles(0, math.rad(20), 0)
		VPFcam.CFrame = CFrame.new(targetPosition) * targetRotation
		ViewportFrame.CurrentCamera = VPFcam
		VPFcam.FieldOfView = 37
		Character.Archivable = true
		ClonedChar = Character:Clone()
		ClonedChar.Name = "VPFCharacter"
		ClonedChar.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		ClonedChar.Parent = WorldModel
		if ClonedChar.Animate then
			ClonedChar.Animate:Destroy()
		end
		if ClonedChar:FindFirstChildOfClass("Tool") then
			ClonedChar:FindFirstChildOfClass("Tool"):Destroy()
		end
		ClonedChar:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0,0,-0.4), Vector3.new(0,0,7)))
	end
	AddVPF()

	local function PlayAnim(Object, ID, AnimWeight, Speed, Type, LoopedVal, NeedPause) -- Types Tutorial on Emotes section
		Object:SetAttribute("Looped", LoopedVal)
		if LoopedVal == false then
			AddHoverText(Object, "Click RMB to loop")
		end
		
		local Anim = Instance.new("Animation")
		Anim.AnimationId = "rbxassetid://"..ID
		local track = Player.Character:WaitForChild("Humanoid"):LoadAnimation(Anim)
		if Type:find("PriorLow") then
			track.Priority = Enum.AnimationPriority.Action3
		elseif Type:find("PriorHigh") then
			track.Priority = Enum.AnimationPriority.Action4
		end		
		
		local AnimSpeed = nil
		local PauseAnimsOption = false
		local AnimACTIVE = false
		
		Object.MouseButton1Click:connect(function()
			AnimACTIVE = not AnimACTIVE
			if AnimACTIVE then

				local CurLooped = Object:GetAttribute("Looped")
				if CurLooped == false then
					track.Looped = false
				elseif CurLooped == true then
					track.Looped = true
				end

				track:Play(AnimWeight, 1, Speed + SpeedNum)
				if PauseAnimsOption then
					track:AdjustSpeed(0)
				end
				AnimSpeed = Speed + SpeedNum
				ViewportFrame.Visible = false
				if Object.Parent == ScrollingFrame then
					Object.BackgroundColor3 = ButtonSelectCol
				elseif Object.Parent == ScrollingFrameR15 then
					Object.BackgroundColor3 = R15ButtonSelectCol
				end
				Object.UIStroke.Thickness = 2
				Object.UIStroke.Color = Color3.new(0.0392157, 0.501961, 1)
				CurSpeedText.Text = Speed + SpeedNum
				
				if Type:find("Pause") then
					local PauseTask = task.spawn(function()
						wait(1)
						track:AdjustSpeed(0)
						AnimSpeed = 0
					end)
					while wait() do
						if AnimACTIVE == false then
							task.cancel(PauseTask)
							return
						end
					end
				end
			else
				track:Stop()
				if Object.Parent == ScrollingFrame then
					Object.BackgroundColor3 = ButtonCol
				elseif Object.Parent == ScrollingFrameR15 then
					Object.BackgroundColor3 = R15ButtonCol
				end
				Object.UIStroke.Thickness = 1
				Object.UIStroke.Color = Color3.new(0, 0, 0)
				CurSpeedText.Text = ""
			end
		end)
		
		Object.MouseButton2Click:connect(function()
			local CurLooped = Object:GetAttribute("Looped")
			if CurLooped == false then
				AnimACTIVE = not AnimACTIVE
				if AnimACTIVE then
					track.Looped = true
					track:Play(AnimWeight, 1, Speed + SpeedNum)
					if PauseAnimsOption then
						track:AdjustSpeed(0)
					end
					AnimSpeed = Speed + SpeedNum
					ViewportFrame.Visible = false
					if Object.Parent == ScrollingFrame then
						Object.BackgroundColor3 = ButtonSelectCol
					elseif Object.Parent == ScrollingFrameR15 then
						Object.BackgroundColor3 = R15ButtonSelectCol
					end
					Object.UIStroke.Thickness = 2
					Object.UIStroke.Color = Color3.new(0.972549, 0.670588, 0.0627451)
					CurSpeedText.Text = Speed + SpeedNum

				else
					track:Stop()
					track.Looped = false
					if Object.Parent == ScrollingFrame then
						Object.BackgroundColor3 = ButtonCol
					elseif Object.Parent == ScrollingFrameR15 then
						Object.BackgroundColor3 = R15ButtonCol
					end
					Object.UIStroke.Thickness = 1
					Object.UIStroke.Color = Color3.new(0, 0, 0)
					CurSpeedText.Text = ""
				end
			end
		end)
		
		PauseAnimsButton.MouseButton1Click:Connect(function()
			PauseAnimsOption = not PauseAnimsOption
			if PauseAnimsOption then
				track:AdjustSpeed(0)
				PauseAnimsButton.BackgroundColor3 = R15ButtonSelectCol
			else
				track:AdjustSpeed(AnimSpeed)
				PauseAnimsButton.BackgroundColor3 = R15ButtonCol
			end
		end)
		
		track.Ended:connect(function()
			AnimACTIVE = false
			if Object.Parent == ScrollingFrame then
				Object.BackgroundColor3 = ButtonCol
			elseif Object.Parent == ScrollingFrameR15 then
				Object.BackgroundColor3 = R15ButtonCol
			end
			Object.UIStroke.Thickness = 1
			Object.UIStroke.Color = Color3.new(0, 0, 0)
			CurSpeedText.Text = ""
		end)

		StopAnimsEvent.Event:Connect(function()
			AnimACTIVE = false
			PauseAnimsOption = false
			track:Stop()
			if Object.Parent == ScrollingFrame then
				Object.BackgroundColor3 = ButtonCol
			elseif Object.Parent == ScrollingFrameR15 then
				Object.BackgroundColor3 = R15ButtonCol
			end
			Object.UIStroke.Thickness = 1
			Object.UIStroke.Color = Color3.new(0, 0, 0)
			CurSpeedText.Text = ""
		end)
		
		local VPFtrack = ClonedChar:WaitForChild("Humanoid"):LoadAnimation(Anim)
		local VPFActive = false
		Object.MouseEnter:connect(function()
			if AnimPreviewEnable and not AnimACTIVE then
				VPFActive = true
				VPFtrack.Looped = true
				VPFtrack:Play(0, 1, Speed + SpeedNum)
				ViewportFrame.Visible = true
				game.TweenService:Create(ViewportFrame, TweenInfo.new(.1), {BackgroundTransparency = 0}):Play()
				if Type:find("Pause") then
					local PauseTask = task.spawn(function()
						wait(1)
						VPFtrack:AdjustSpeed(0)
					end)
					while wait() do
						if VPFActive == false then
							task.cancel(PauseTask)
							return
						end
					end
				end
			end
		end)

		Object.MouseLeave:connect(function()
			if AnimPreviewEnable then
				VPFActive = false
				game.TweenService:Create(ViewportFrame, TweenInfo.new(.1), {BackgroundTransparency = 1}):Play()
				ViewportFrame.Visible = false
				VPFtrack:Stop(0)
			end
		end)
	end

	-- Properties
	-- SideFrame

	Emoter.Name = "Emoter"
	Emoter.ResetOnSpawn = false
	Emoter.DisplayOrder = 100
	if game:GetService("RunService"):IsStudio() then --Made this as i test script mostly in Studio
		Emoter.Parent = game.Players.LocalPlayer.PlayerGui
	else
		Emoter.Parent = game.CoreGui
	end

	SideFrame.Name = "SideFrame"
	SideFrame.Parent = Emoter
	SideFrame.Active = true
	SideFrame.BackgroundColor3 = BgColor
	SideFrame.Size = UDim2.new(0, 225, 0, 32)
	SideFrame.Visible = false
	SideFrame.Position = UDim2.new(0, 10, 0, 10)

	local UIDragDetectorSideFrame = Instance.new("UIDragDetector")
	UIDragDetectorSideFrame.Parent = SideFrame

	OpenGUI.Name = "OpenGUI"
	OpenGUI.Parent = SideFrame
	OpenGUI.AnchorPoint = Vector2.new(0, 0.5)
	OpenGUI.BackgroundTransparency = 0
	OpenGUI.BackgroundColor3 = BgColor
	OpenGUI.Position = UDim2.new(0, 0, 0.5, 0)
	OpenGUI.Size = UDim2.new(0, 32, 0, 32)
	OpenGUI.Image = "rbxassetid://129394195458921"
	AddHoverText(OpenGUI, "Open/Close GUI")

	SideFrameTitle.Name = "SideFrameTitle"
	SideFrameTitle.Parent = SideFrame
	SideFrameTitle.AnchorPoint = Vector2.new(0.5, 0.5)
	SideFrameTitle.BackgroundTransparency = 1
	SideFrameTitle.Position = UDim2.new(0.5, 0, 0.5, 0)
	SideFrameTitle.Size = UDim2.new(0, 119, 0, 31)
	SideFrameTitle.Font = Enum.Font.SourceSansBold
	SideFrameTitle.TextStrokeColor3 = Color3.new(1, 1, 1)
	SideFrameTitle.Text = "Emote GUI"
	SideFrameTitle.TextSize = 24
	SideFrameTitle.TextStrokeTransparency = 0

	SFDestroyGUI.Name = "DestroyGUI"
	SFDestroyGUI.Parent = SideFrame
	SFDestroyGUI.AnchorPoint = Vector2.new(1, 0.5)
	SFDestroyGUI.BackgroundTransparency = 0
	SFDestroyGUI.Position = UDim2.new(1, 0, 0.5, 0)
	SFDestroyGUI.Size = UDim2.new(0, 32, 0, 32)
	SFDestroyGUI.BackgroundColor3 = BgColor
	SFDestroyGUI.Font = Enum.Font.FredokaOne
	SFDestroyGUI.Text = "X"
	SFDestroyGUI.TextColor3 = UiButColor
	SFDestroyGUI.TextSize = 34
	SFDestroyGUI.TextWrapped = true
	AddHoverText(SFDestroyGUI, "Delete GUI")

	-- MainFrame

	MainFrame.Name = "MainFrame"
	MainFrame.Parent = Emoter
	MainFrame.Active = true
	MainFrame.BackgroundColor3 = BgColor
	MainFrame.BackgroundTransparency = 1
	MainFrame.Size = UDim2.new(0, 460, 0, 285)
	MainFrame.Position = UDim2.new(0, 10, 0, 10)

	local UIDragDetectorMainFrame = Instance.new("UIDragDetector")
	UIDragDetectorMainFrame.Parent = MainFrame

	-- GuiBottomFrame

	GuiBottomFrame.Name = "GuiBottomFrame"
	GuiBottomFrame.Parent = MainFrame
	GuiBottomFrame.AnchorPoint = Vector2.new(0, 1)
	GuiBottomFrame.Size = UDim2.new(0, 460, 0, 35)
	GuiBottomFrame.Position = UDim2.new(0, 0, 1, 1)
	GuiBottomFrame.Active = true
	GuiBottomFrame.BackgroundColor3 = BgColor

	SpeedFrame.Name = "SpeedFrame"
	SpeedFrame.Parent = GuiBottomFrame
	SpeedFrame.Size = UDim2.new(0.5, 0, 0, 35)
	SpeedFrame.BackgroundTransparency = 1
	SpeedFrame.Active = true
	SpeedFrame.BorderSizePixel = 0
	SpeedFrame.BackgroundColor3 = Color3.fromRGB(138, 165, 255)

	local GBUIPadding = Instance.new("UIPadding")
	GBUIPadding.PaddingLeft = UDim.new(0, 5)
	GBUIPadding.PaddingRight = UDim.new(0, 5)
	GBUIPadding.Parent = GuiBottomFrame

	local SFLayout = Instance.new("UIGridLayout")
	SFLayout.Name = "UIGridLayout"
	SFLayout.Parent = SpeedFrame
	SFLayout.FillDirection = Enum.FillDirection.Vertical
	SFLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SFLayout.CellSize = UDim2.new(0, 90, 0, 31)
	SFLayout.VerticalAlignment = Enum.VerticalAlignment.Center

	local SpeedValue = Instance.new("TextBox")
	SpeedValue.Parent = SpeedFrame
	SpeedValue.Name = "SpeedValue"
	SpeedValue.ClearTextOnFocus = false
	SpeedValue.AnchorPoint = Vector2.new(0.5, 0)
	SpeedValue.Size = UDim2.new(0, 100, 0, 40)
	SpeedValue.LayoutOrder = 2
	SpeedValue.Position = UDim2.new(0.5, 0, 0, 0)
	SpeedValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SpeedValue.TextColor3 = Color3.fromRGB(0, 0, 0)
	SpeedValue.Text = ""
	SpeedValue.PlaceholderText = "0 = Default"
	SpeedValue.Font = Enum.Font.SourceSans
	SpeedValue.TextScaled = true
	AddHoverText(SpeedValue, "Enter a number to add speed")

	local SVPadding = Instance.new("UIPadding")
	SVPadding.Parent = SpeedValue
	SVPadding.PaddingLeft = UDim.new(0, 2)
	SVPadding.PaddingRight = UDim.new(0, 2)

	local ValueText = Instance.new("TextLabel")
	ValueText.Name = "ValueText"
	ValueText.Parent = SpeedFrame
	ValueText.Size = UDim2.new(0, 200, 0, 50)
	ValueText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ValueText.BackgroundTransparency = 1
	ValueText.BorderSizePixel = 0
	ValueText.BackgroundColor3 = Color3.fromRGB(226, 198, 93)
	ValueText.TextStrokeTransparency = 0
	ValueText.TextColor3 = Color3.fromRGB(255, 255, 255)
	ValueText.Text = "Add Speed"
	ValueText.Font = Enum.Font.SourceSansBold
	ValueText.TextScaled = true

	--

	CurSpeedText.Name = "CurSpeedText"
	CurSpeedText.AnchorPoint = Vector2.new(1, 0)
	CurSpeedText.Size = UDim2.new(0, 0, 0, 35)
	CurSpeedText.AutomaticSize = Enum.AutomaticSize.X
	CurSpeedText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CurSpeedText.BackgroundTransparency = 1
	CurSpeedText.Position = UDim2.new(1, 0, 0, -2)
	CurSpeedText.BorderSizePixel = 0
	CurSpeedText.BackgroundColor3 = Color3.fromRGB(226, 198, 93)
	CurSpeedText.TextStrokeTransparency = 0
	CurSpeedText.TextColor3 = Color3.fromRGB(255, 255, 255)
	CurSpeedText.Text = ""
	CurSpeedText.TextXAlignment = Enum.TextXAlignment.Right
	CurSpeedText.TextWrapped = true
	CurSpeedText.Font = Enum.Font.SourceSans
	CurSpeedText.TextScaled = true
	CurSpeedText.Parent = GuiBottomFrame
	AddHoverText(CurSpeedText, "Current anim speed")

	SpeedValue.Changed:Connect(function()
		SpeedNum = SpeedValue.Text
		if SpeedValue.Text == "" then
			SpeedNum = 0
		end
	end)
	
	OptionsButton.Parent = GuiBottomFrame
	OptionsButton.Name = "OptionsButton"
	OptionsButton.AnchorPoint = Vector2.new(0.5, 0.5)
	OptionsButton.Size = UDim2.new(0, 35, 0, 35)
	OptionsButton.Position = UDim2.new(0.5, 0, 0.5, 0)
	OptionsButton.BorderSizePixel = 0
	OptionsButton.BackgroundColor3 = BgColor
	OptionsButton.ImageColor3 = UiButColor
	OptionsButton.Image = "rbxassetid://80468028389803"
	AddHoverText(OptionsButton, "Options")
	
	--Scrolling Frames

	ScrollingFrame.Parent = MainFrame
	ScrollingFrame.BackgroundColor3 = ScrollBgColor
	ScrollingFrame.Position = UDim2.new(0, 0, 0, 34)
	ScrollingFrame.ScrollBarImageColor3 = Color3.new(0, 0, 0)
	ScrollingFrame.Size = UDim2.new(0, 460, 0, 215)

	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0.5, 10)
	ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ScrollingFrame.ScrollBarThickness = 10

	local SF6UIListLayout = Instance.new("UIListLayout")
	SF6UIListLayout.Parent = ScrollingFrame
	SF6UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	SF6UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	SF6UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SF6UIListLayout.Wraps = true
	SF6UIListLayout.Padding = UDim.new(0, 10)

	local SF6UIPadding = Instance.new("UIPadding")
	SF6UIPadding.Parent = ScrollingFrame
	SF6UIPadding.PaddingTop = UDim.new(0, 7)
	SF6UIPadding.PaddingBottom = UDim.new(0, 10)
	SF6UIPadding.PaddingRight = UDim.new(0, 16)
	SF6UIPadding.PaddingLeft = UDim.new(0, 5)

	ScrollingFrameR15.Name = "ScrollingFrameR15"
	ScrollingFrameR15.Parent = MainFrame
	ScrollingFrameR15.BackgroundColor3 = ScrollBgColor
	ScrollingFrameR15.Position = UDim2.new(0, 0, 0, 34)
	ScrollingFrameR15.ScrollBarImageColor3 = Color3.new(0, 0, 0)
	ScrollingFrameR15.Size = UDim2.new(0, 460, 0, 215)

	ScrollingFrameR15.CanvasSize = UDim2.new(0, 0, 0.5, 10)
	ScrollingFrameR15.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ScrollingFrameR15.Visible = false
	ScrollingFrameR15.ScrollBarThickness = 10

	local SF15UIListLayout = Instance.new("UIListLayout")
	SF15UIListLayout.Parent = ScrollingFrameR15
	SF15UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	SF15UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	SF15UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SF15UIListLayout.Wraps = true
	SF15UIListLayout.Padding = UDim.new(0, 10)

	local SF15UIPadding = Instance.new("UIPadding")
	SF15UIPadding.Parent = ScrollingFrameR15
	SF15UIPadding.PaddingTop = UDim.new(0, 7)
	SF15UIPadding.PaddingBottom = UDim.new(0, 10)
	SF15UIPadding.PaddingRight = UDim.new(0, 16)
	SF15UIPadding.PaddingLeft = UDim.new(0, 5)

	GuiTopFrame.Name = "GuiTopFrame"
	GuiTopFrame.Parent = MainFrame
	GuiTopFrame.BackgroundColor3 = BgColor
	GuiTopFrame.BorderColor3 = Color3.new(0.243137, 0.243137, 0.243137)
	GuiTopFrame.Size = UDim2.new(0, 460, 0, 32)

	DestroyGUI.Name = "DestroyGUI"
	DestroyGUI.Parent = GuiTopFrame
	DestroyGUI.AnchorPoint = Vector2.new(1, 0.5)
	DestroyGUI.BackgroundTransparency = 0
	DestroyGUI.BackgroundColor3 = BgColor
	DestroyGUI.Position = UDim2.new(1, 0, 0.5, 0)
	DestroyGUI.Size = UDim2.new(0, 32, 0, 32)
	DestroyGUI.Font = Enum.Font.FredokaOne
	DestroyGUI.Text = "X"
	DestroyGUI.TextColor3 = UiButColor
	DestroyGUI.TextSize = 34
	DestroyGUI.TextWrapped = true
	AddHoverText(DestroyGUI, "Delete GUI")

	CloseGUI.Name = "CloseGUI"
	CloseGUI.Parent = GuiTopFrame
	CloseGUI.AnchorPoint = Vector2.new(0, 0.5)
	CloseGUI.BackgroundColor3 = BgColor
	CloseGUI.BackgroundTransparency = 0
	CloseGUI.Position = UDim2.new(0, 0, 0.5, 0)
	CloseGUI.Size = UDim2.new(0, 32, 0, 32)
	CloseGUI.Image = "rbxassetid://118017289302281"
	AddHoverText(CloseGUI, "Open/Close GUI")

	Title.Name = "Title"
	Title.Parent = GuiTopFrame
	Title.AnchorPoint = Vector2.new(0.5, 0.5)
	Title.Position = UDim2.new(0.5, 0, 0.5, 0)
	Title.BackgroundColor3 = Color3.new(1, 1, 1)
	Title.BackgroundTransparency = 1
	Title.Size = UDim2.new(0, 119, 0, 31)
	Title.Text = "Emotes GUI"
	Title.Font = Enum.Font.SourceSansBold
	Title.TextStrokeColor3 = Color3.new(1, 1, 1)
	Title.TextColor3 = Color3.new(0.164706, 0.164706, 0.164706)
	Title.TextSize = 24
	Title.TextStrokeTransparency = 0
	Title.TextWrapped = false
	
	OptionsFrame.Parent = MainFrame
	OptionsFrame.Name = "OptionsFrame"
	OptionsFrame.AnchorPoint = Vector2.new(0.5, 0)
	OptionsFrame.Size = UDim2.new(0, 178, 0, 46)
	OptionsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	OptionsFrame.Visible = false
	OptionsFrame.Position = UDim2.new(0.5, 0, 1, -43)
	OptionsFrame.BorderSizePixel = 0
	OptionsFrame.BackgroundColor3 = Color3.fromRGB(219, 244, 255)
	OptionsFrame.ZIndex = -1

	local OFUIGridLayout = Instance.new("UIGridLayout")
	OFUIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	OFUIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	OFUIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	OFUIGridLayout.CellSize = UDim2.new(0, 40, 0, 40)
	OFUIGridLayout.CellPadding = UDim2.new(0, 4, 0, 4)
	OFUIGridLayout.Parent = OptionsFrame

	PauseAnimsButton.Name = "PauseAnimsButton"
	PauseAnimsButton.Size = UDim2.new(0, 100, 0, 100)
	PauseAnimsButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	PauseAnimsButton.BorderSizePixel = 0
	PauseAnimsButton.BackgroundColor3 = R15ButtonCol
	PauseAnimsButton.Image = "rbxassetid://103681828169035"
	PauseAnimsButton.Parent = OptionsFrame
	PauseAnimsButton.ZIndex = 0
	AddHoverText(PauseAnimsButton, "Pause ALL Anims")

	StopDefAnimsButton.Name = "StopDefAnimsButton"
	StopDefAnimsButton.Size = UDim2.new(0, 100, 0, 100)
	StopDefAnimsButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	StopDefAnimsButton.BorderSizePixel = 0
	StopDefAnimsButton.BackgroundColor3 = R15ButtonCol
	StopDefAnimsButton.Image = "rbxassetid://116957047917442"
	StopDefAnimsButton.Parent = OptionsFrame
	StopDefAnimsButton.ZIndex = 0
	AddHoverText(StopDefAnimsButton, "Stop Default Anims. May not work on some games")
	
	PauseAnimateButton.Name = "PauseAnimateButton"
	PauseAnimateButton.Size = UDim2.new(0, 100, 0, 100)
	PauseAnimateButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	PauseAnimateButton.BorderSizePixel = 0
	PauseAnimateButton.BackgroundColor3 = R15ButtonCol
	PauseAnimateButton.Image = "rbxassetid://109849420482663"
	PauseAnimateButton.Parent = OptionsFrame
	PauseAnimateButton.ZIndex = 0
	AddHoverText(PauseAnimateButton, "Pause Default Animate Script (will look like you're lagging")

	PreviewEnableButton.Name = "PreviewEnableButton"
	PreviewEnableButton.Size = UDim2.new(0, 100, 0, 100)
	PreviewEnableButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	PreviewEnableButton.BorderSizePixel = 0
	PreviewEnableButton.BackgroundColor3 = R15ButtonCol
	PreviewEnableButton.Image = "rbxassetid://134858066894422"
	PreviewEnableButton.Parent = OptionsFrame
	PreviewEnableButton.ZIndex = 0
	AddHoverText(PreviewEnableButton, "Enable Animation Preview")
	
	--Search Box Items
	SearchFrame.Parent = MainFrame
	SearchFrame.Name = "SearchFrame"
	SearchFrame.ZIndex = 0
	SearchFrame.AnchorPoint = Vector2.new(1, 0)
	SearchFrame.Size = UDim2.new(0, 165, 0, 40)
	SearchFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchFrame.Position = UDim2.new(1, 35, 0.119, 0)
	SearchFrame.BorderSizePixel = 0
	SearchFrame.BackgroundColor3 = BgColor

	SearchButton.Name = "SearchButton"
	SearchButton.ZIndex = 0
	SearchButton.AnchorPoint = Vector2.new(1, 0)
	SearchButton.Size = UDim2.new(0, 34, 0, 40)
	SearchButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchButton.LayoutOrder = 2
	SearchButton.Position = UDim2.new(1, 0, 0.075, 0)
	SearchButton.BorderSizePixel = 0
	SearchButton.BackgroundColor3 = BgColor
	SearchButton.ScaleType = Enum.ScaleType.Fit
	SearchButton.ImageColor3 = Color3.fromRGB(0, 0, 0)
	SearchButton.Image = "rbxassetid://118685771787843"
	SearchButton.Parent = SearchFrame
	AddHoverText(SearchButton, "Search (T)")

	SearchBox.Name = "SearchBox"
	SearchBox.ZIndex = 0
	SearchBox.Visible = false
	SearchBox.AnchorPoint = Vector2.new(0.5, 0)
	SearchBox.Size = UDim2.new(0, 139, 0, 34)
	SearchBox.LayoutOrder = 1
	SearchBox.Position = UDim2.new(0.469697, 0, 0.075, 0)
	SearchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SearchBox.TextColor3 = Color3.fromRGB(0, 0, 0)
	SearchBox.PlaceholderText = "Search..."
	SearchBox.Text = ""
	SearchBox.Font = Enum.Font.SourceSans
	SearchBox.ClearTextOnFocus = false
	SearchBox.TextScaled = true
	SearchBox.TextXAlignment = Enum.TextXAlignment.Left
	SearchBox.Parent = SearchFrame
	AddHoverText(SearchBox, "Search for animation (T)")

	local UIPadding = Instance.new("UIPadding")
	UIPadding.PaddingLeft = UDim.new(0, 2)
	UIPadding.PaddingRight = UDim.new(0, 2)
	UIPadding.Parent = SearchBox

	BackButton.Name = "BackButton"
	BackButton.ZIndex = 0
	BackButton.Visible = false
	BackButton.AnchorPoint = Vector2.new(1, 0)
	BackButton.Size = UDim2.new(0, 19, 0, 40)
	BackButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	BackButton.LayoutOrder = 2
	BackButton.Position = UDim2.new(1, 0, 0, 0)
	BackButton.BackgroundColor3 = BgColor
	BackButton.ScaleType = Enum.ScaleType.Crop
	BackButton.ImageColor3 = Color3.fromRGB(0, 0, 0)
	BackButton.Image = "rbxassetid://2418687610"
	BackButton.Parent = SearchFrame
	AddHoverText(BackButton, "Hide")

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 1)
	UIListLayout.Parent = SearchFrame
	
	-- Buttons
	
	if (game:GetService"Players".LocalPlayer.Character:WaitForChild("Humanoid").RigType == Enum.HumanoidRigType.R15) then
		ScrollingFrame.Visible = false
		ScrollingFrameR15.Visible = true
		Title.Text = "Emotes GUI (R15)"
		SideFrameTitle.Text = "Emotes GUI (R15)"
	else
		ScrollingFrame.Visible = true
		ScrollingFrameR15.Visible = false
		Title.Text = "Emotes GUI (R6)"
		SideFrameTitle.Text = "Emotes GUI (R6)"

	end
	
	DestroyGUI.MouseButton1Click:connect(function()
		GuiActive = false
		StopAnimsEvent:Fire()
		Emoter:Destroy()
	end)
	SFDestroyGUI.MouseButton1Click:connect(function()
		GuiActive = false
		StopAnimsEvent:Fire()
		Emoter:Destroy()
	end)
	OpenGUI.MouseButton1Click:connect(function()
		MainFrame.Visible = true
		SideFrame.Visible = false
		MainFrame.Position = SideFrame.Position
	end)
	CloseGUI.MouseButton1Click:connect(function()
		MainFrame.Visible = false
		SideFrame.Visible = true
		SideFrame.Position = MainFrame.Position
	end)
	
	local OptionsButtonClick = true
	OptionsButton.MouseButton1Click:Connect(function()
		if OptionsButtonClick == true then
			if not OptionsFrame.Visible then
				OptionsButtonClick = false
				OptionsFrame.Visible = true
				game.TweenService:Create(OptionsFrame, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 1, 7)}):Play()
				wait(.3)
				OptionsButtonClick = true
			else
				OptionsButtonClick = false
				game.TweenService:Create(OptionsFrame, TweenInfo.new(.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 1, -43)}):Play()
				wait(.2)
				OptionsFrame.Visible = false
				OptionsButtonClick = true
			end
		end
	end)
	
	local SearchButtonClick = true
	SearchButton.MouseButton1Click:Connect(function()
		if SearchButtonClick == true then
			SearchButtonClick = false
			SearchButton.Visible = false
			BackButton.Visible = true
			SearchBox.Visible = true
			game.TweenService:Create(SearchFrame, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Position = UDim2.new(1, 164, 0.119, 0)}):Play()
			wait(.3)
			SearchButtonClick = true
		end
	end)
	BackButton.MouseButton1Click:Connect(function()
		if SearchButtonClick == true then
			SearchButtonClick = false
			game.TweenService:Create(SearchFrame, TweenInfo.new(.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {Position = UDim2.new(1, 35, 0.119, 0)}):Play()
			wait(.2)
			SearchButton.Visible = true
			BackButton.Visible = false
			SearchBox.Visible = false
			SearchButtonClick = true
		end
	end)
	
	if SearchOpened == true then
		SearchButton.Visible = false
		BackButton.Visible = true
		SearchBox.Visible = true
		SearchFrame.Position = UDim2.new(1, 164, 0.119, 0)
	else
		SearchButton.Visible = true
		BackButton.Visible = false
		SearchBox.Visible = false
		SearchFrame.Position = UDim2.new(1, 35, 0.119, 0)
	end
	
	SearchBox.Changed:Connect(function()
		for _, Button in ipairs(ScrollingFrameR15:GetDescendants() and ScrollingFrame:GetDescendants()) do
			if Button:IsA("TextButton") and string.find(Button.Text:lower(), SearchBox.Text) then
				Button.Visible = true
			elseif Button:IsA("TextButton") and not string.find(Button.Text, SearchBox.Text) then
				Button.Visible = false
			elseif Button.Name == "DivideFrame" then
				Button.Visible = false
			end
			
			if SearchBox.Text == "" then
				if Button:IsA("TextButton") then
					Button.Visible = true
				elseif Button.Name == "DivideFrame"  then
					Button.Visible = true
				end

			end

		end
	end)
	
	local input = UserInputService.InputBegan:Connect(function(input, processed)
		if input.KeyCode == Enum.KeyCode.T then
			if SearchBox.Visible == false then
				SearchButtonClick = false
				SearchButton.Visible = false
				BackButton.Visible = true
				SearchBox.Visible = true
				game.TweenService:Create(SearchFrame, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Position = UDim2.new(1, 164, 0.119, 0)}):Play()
				wait(.3)
				SearchButtonClick = true
			end
			SearchBox:CaptureFocus()
		end
	end)
	
	local DefaultAnimsNameList = {"Animation1", "Animation2", "Animation3", "ClimbAnim", "FallAnim", "JumpAnim", "RunAnim", "SitAnim", "ToolNoneAnim", "WalkAnim", "CheerAnim", "LaughAnim", "PointAnim", "Swim", "SwimIdle", "ToolLungeAnim", "ToolSlashAnim", "WaveAnim"}
	
	local PauseDefAnimsOption = false
	PauseAnimsButton.MouseButton1Click:Connect(function()
		PauseDefAnimsOption = not PauseDefAnimsOption
		if PauseDefAnimsOption then
			local playingTracks = Player.Character.Humanoid:GetPlayingAnimationTracks()
			for _, animtrack in ipairs(playingTracks) do
				if table.find(DefaultAnimsNameList, animtrack.Name) then
					animtrack:AdjustSpeed(0)
				end
			end
		else

			local playingTracks = Player.Character.Humanoid:GetPlayingAnimationTracks()
			for _, animtrack in ipairs(playingTracks) do
				if table.find(DefaultAnimsNameList, animtrack.Name) then
					animtrack:AdjustSpeed(1) --Gonna fix it soon (maybe)
				end
			end
		end
	end)
	
	local AnimateScript = Player.Character:WaitForChild("Animate")
	PauseAnimateButton.MouseButton1Click:Connect(function()
		if AnimateScript.Disabled == false then
			AnimateScript.Disabled = true
			PauseAnimateButton.BackgroundColor3 = R15ButtonSelectCol
		else
			StopAnimsEvent:Fire()
			AnimateScript.Disabled = false
			PauseAnimateButton.BackgroundColor3 = R15ButtonCol
			PauseDefAnimsOption = false
			PauseAnimsButton.BackgroundColor3 = R15ButtonCol
		end
	end)
	
	local StopDefAnimsOption = false
	StopDefAnimsButton.MouseButton1Click:Connect(function()
		StopDefAnimsOption = not StopDefAnimsOption
		if StopDefAnimsOption then

			local playingTracks = Player.Character.Humanoid:GetPlayingAnimationTracks()
			Player.Character.Animate.Disabled = true

			for _, animtrack in ipairs(playingTracks) do
				if table.find(DefaultAnimsNameList, animtrack.Name) then
					animtrack:Stop()
				end
			end
			StopDefAnimsButton.BackgroundColor3 = R15ButtonSelectCol
			
			PauseAnimateButton.BackgroundColor3 = R15ButtonCol
			PauseAnimateButton.ImageTransparency = 0.5
			PauseAnimateButton.Interactable = false
		else
			StopAnimsEvent:Fire()
			Player.Character.Animate.Disabled = false
			StopDefAnimsButton.BackgroundColor3 = R15ButtonCol
			
			PauseDefAnimsOption = false
			PauseAnimsButton.BackgroundColor3 = R15ButtonCol
			PauseAnimateButton.BackgroundColor3 = R15ButtonCol
			PauseAnimateButton.ImageTransparency = 0
			PauseAnimateButton.Interactable = true
		end
	end)
	
	if AnimPreviewEnable == true then
		PreviewEnableButton.BackgroundColor3 = R15ButtonSelectCol
	end
	PreviewEnableButton.MouseButton1Click:Connect(function()
		if AnimPreviewEnable == true then
			AnimPreviewEnable = false
			PreviewEnableButton.BackgroundColor3 = R15ButtonCol
		else
			AnimPreviewEnable = true
			PreviewEnableButton.BackgroundColor3 = R15ButtonSelectCol
		end
	end)
	
	local function CreateDivideFrame(Title, LayoutOrder, Type)
		local DivideFrame = Instance.new("Frame")
		local Line = Instance.new("Frame")
		local TextLabel = Instance.new("TextLabel")
		
		DivideFrame.Name = "DivideFrame"
		DivideFrame.Size = UDim2.new(0.98, 0, 0, 20)
		DivideFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		DivideFrame.BackgroundTransparency = 1
		DivideFrame.BorderSizePixel = 0
		DivideFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		DivideFrame.LayoutOrder = LayoutOrder

		Line.Name = "Line"
		Line.AnchorPoint = Vector2.new(0, 0.5)
		Line.Size = UDim2.new(1, 0, 0, 3)
		Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Line.Position = UDim2.new(0, 0, 0.5, 0)
		Line.BorderSizePixel = 0
		Line.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Line.Parent = DivideFrame

		TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		TextLabel.AutomaticSize = Enum.AutomaticSize.X
		TextLabel.Size = UDim2.new(0, 50, 0, 25)
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.BackgroundColor3 = Color3.fromRGB(219, 244, 255)
		TextLabel.TextSize = 25
		TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.Text = Title
		TextLabel.TextWrapped = true
		TextLabel.Font = Enum.Font.SourceSansBold
		TextLabel.Parent = DivideFrame

		local UIPadding = Instance.new("UIPadding")
		UIPadding.PaddingLeft = UDim.new(0, 8)
		UIPadding.PaddingRight = UDim.new(0, 10)
		UIPadding.Parent = TextLabel
		
		if Type == "R6" then
			DivideFrame.Parent = ScrollingFrame
		elseif Type == "R15" then
			DivideFrame.Parent = ScrollingFrameR15
		end
	end

	-- EMOTES
	
	--[[Functions Template
	local AnimName = Instance.new("TextButton")
	CreateAnimButton(Obj, "Name", "Text", "R6", 0)
	PlayAnim(Obj, "IdNumber", .1, 1, "PriorLow", true)
	
	- CreateAnimation has Object (Button), Name of object, Text, Type ow whiich type of scrolling frame will it be, 
	and LayoutOrder to organize Anim button to its type
	- PlayAnim has Object (Button), Id of anim, Anim FadeTime, speed of anim, Type of Anim and Looped state value (if anim is unlooped you can loop it by clicking RMB).
	Type of anim is checked as Type:find("PriorLow"), so you can type in multiple states inside.
	States available: PriorLow/PriorHigh (Priority of animation), Pause (Animation will stop after 1 second) 
	]]
	
	--DivideFrames
	CreateDivideFrame("Dances", 1, "R6")
	CreateDivideFrame("Actions", 2, "R6")
	CreateDivideFrame("Idles & Walks", 3, "R6")
	CreateDivideFrame("Weird", 4, "R6")
	CreateDivideFrame("Attack", 5, "R6")
	
	CreateDivideFrame("Dances", 1, "R15")
	CreateDivideFrame("Actions", 2, "R15")
	CreateDivideFrame("Walk & Run", 3, "R15")
	CreateDivideFrame("Weird", 4, "R15")
	CreateDivideFrame("Poses & Idles", 5, "R15")
	CreateDivideFrame("Attack", 6, "R15")

	-- R6 Emotes
	if (game:GetService"Players".LocalPlayer.Character:WaitForChild("Humanoid").RigType == Enum.HumanoidRigType.R6) then
		local Dance1 = Instance.new("TextButton")
		CreateAnimButton(Dance1, "Dance1", "Dance 1", "R6", 1)
		PlayAnim(Dance1, "182491037", .1, 1, "PriorLow", true)
		local Dance2 = Instance.new("TextButton")
		CreateAnimButton(Dance2, "Dance2", "Dance 2", "R6", 1)
		PlayAnim(Dance2, "182436842", .1, 1, "PriorLow", true)
		local Dance3 = Instance.new("TextButton")
		CreateAnimButton(Dance3, "Dance3", "Dance 3", "R6", 1)
		PlayAnim(Dance3, "182491368", .1, 1, "PriorLow", true)
		local MoonDance = Instance.new("TextButton")
		CreateAnimButton(MoonDance, "MoonDance", "Moon Dance", "R6", 1)
		PlayAnim(MoonDance, "45834924", .1, 1, "PriorLow", true)
		local SpinDance = Instance.new("TextButton")
		CreateAnimButton(SpinDance, "SpinDance", "Spin Dance", "R6", 1)
		PlayAnim(SpinDance, "429730430", .1, 1, "PriorLow", true)
		local JumpingJacks = Instance.new("TextButton")
		CreateAnimButton(JumpingJacks, "JumpingJacks", "Jumping Jacks", "R6", 1)
		PlayAnim(JumpingJacks, "429681631", .1, 1, "PriorLow", true)
		local Bang = Instance.new("TextButton")
		CreateAnimButton(Bang, "Bang", "Bang", "R6", 1)
		PlayAnim(Bang, "148840371", .1, 3, "PriorLow", true)
		local MovingDance = Instance.new("TextButton")
		CreateAnimButton(MovingDance, "MovingDance", "Moving Dance", "R6", 1)
		PlayAnim(MovingDance, "429703734", .1, 1, "PriorLow", true)
		local GoofyDance = Instance.new("TextButton")
		CreateAnimButton(GoofyDance, "GoofyDance", "Goofy Dance", "R6", 1)
		PlayAnim(GoofyDance, "27789359", .1, 0.8, "PriorLow", true)
		local WeirdDance = Instance.new("TextButton")
		CreateAnimButton(WeirdDance, "WeirdDance", "Weird Dance", "R6", 1)
		PlayAnim(WeirdDance, "28488254", .1, 0.8, "PriorLow", true)
		local Laugh = Instance.new("TextButton")
		CreateAnimButton(Laugh, "Laugh", "Laugh", "R6", 2)
		PlayAnim(Laugh, "129423131", .1, 1, "PriorLow", false)
		local Cheer = Instance.new("TextButton")
		CreateAnimButton(Cheer, "Cheer", "Cheer", "R6", 2)
		PlayAnim(Cheer, "129423030", .1, 1, "PriorLow", false)
		local Point = Instance.new("TextButton")
		CreateAnimButton(Point, "Point", "Point", "R6", 2)
		PlayAnim(Point, "128853357", .1, 1, "PriorLow", false)
		local Wave = Instance.new("TextButton")
		CreateAnimButton(Wave, "Wave", "Wave", "R6", 2)
		PlayAnim(Wave, "128777973", .1, 1, "PriorLow", false)
		local Dab = Instance.new("TextButton")
		CreateAnimButton(Dab, "Dab", "Dab", "R6", 2)
		PlayAnim(Dab, "248263260", .1, 1, "PriorLow", true)
		local ToolHandle = Instance.new("TextButton")
		CreateAnimButton(ToolHandle, "ToolHandle", "Tool Handle", "R6", 2)
		PlayAnim(ToolHandle, "125750867", .1, 1, "PriorHigh", true)
		local Crouch = Instance.new("TextButton")
		CreateAnimButton(Crouch, "Crouch", "Crouch", "R6", 3)
		PlayAnim(Crouch, "182724289", .1, 1, "PriorLow", true)
		local Faint = Instance.new("TextButton")
		CreateAnimButton(Faint, "Faint", "Faint", "R6", 3)
		PlayAnim(Faint, "181526230", .1, 1, "PriorHigh", true)
		local FloorCrawl = Instance.new("TextButton")
		CreateAnimButton(FloorCrawl, "FloorCrawl", "Floor Crawl", "R6", 3)
		PlayAnim(FloorCrawl, "282574440", .1, 1, "PriorLow", true)
		local Levitate = Instance.new("TextButton")
		CreateAnimButton(Levitate, "Levitate", "Levitate", "R6", 3)
		PlayAnim(Levitate, "313762630", .1, 1, "PriorHigh", true)
		local DinoWalk = Instance.new("TextButton")
		CreateAnimButton(DinoWalk, "DinoWalk", "Dino Walk", "R6", 3)
		PlayAnim(DinoWalk, "204328711", .1, 1, "PriorLow", true)
		local Climb = Instance.new("TextButton")
		CreateAnimButton(Climb, "Climb", "Climb Walk", "R6", 3)
		PlayAnim(Climb, "125750800", .1, 1, "PriorLow", true)
		local Scared = Instance.new("TextButton")
		CreateAnimButton(Scared, "Scared", "Scared", "R6", 3)
		PlayAnim(Scared, "180612465", .1, 0.3, "PriorLowPause", true)
		local FloatingHead = Instance.new("TextButton")
		CreateAnimButton(FloatingHead, "FloatingHead", "Floating Head", "R6", 3)
		PlayAnim(FloatingHead, "121572214", .1, 1, "PriorHigh", true)
		local FloatSit = Instance.new("TextButton")
		CreateAnimButton(FloatSit, "FloatSit", "Float Sit", "R6", 3)
		PlayAnim(FloatSit, "179224234", .5, 1, "PriorLow", true)
		local Spinner = Instance.new("TextButton")
		CreateAnimButton(Spinner, "Spinner", "Spinner", "R6", 4)
		PlayAnim(Spinner, "188632011", .1, 2, "PriorHigh", true)
		local StrangePos = Instance.new("TextButton")
		CreateAnimButton(StrangePos, "StrangePos", "Strange Position", "R6", 4)
		PlayAnim(StrangePos, "248336459", .1, 1, "PriorLow", true)
		local HeadThrow = Instance.new("TextButton")
		CreateAnimButton(HeadThrow, "HeadThrow", "Head Throw", "R6", 4)
		PlayAnim(HeadThrow, "35154961", .1, 1, "PriorHigh", false)
		local ArmTurbine = Instance.new("TextButton")
		CreateAnimButton(ArmTurbine, "ArmTurbine", "Arm Turbine", "R6", 4)
		PlayAnim(ArmTurbine, "259438880", .1, 3, "PriorLow", true)
		local BarrelRoll = Instance.new("TextButton")
		CreateAnimButton(BarrelRoll, "BarrelRoll", "Barrel Roll", "R6", 4)
		PlayAnim(BarrelRoll, "136801964", .1, 1, "PriorLow", true)
		local MegaInsane = Instance.new("TextButton")
		CreateAnimButton(MegaInsane, "MegaInsane", "Mega Insane", "R6", 4)
		PlayAnim(MegaInsane, "184574340", .1, 40, "PriorLow", true)
		local WeirdMove = Instance.new("TextButton")
		CreateAnimButton(WeirdMove, "WeirdMove", "Weird Move", "R6", 4)
		PlayAnim(WeirdMove, "215384594", .1, 1, "PriorLow", true)
		local CloneIllusion = Instance.new("TextButton")
		CreateAnimButton(CloneIllusion, "CloneIllusion", "Clone Illusion", "R6", 4)
		PlayAnim(CloneIllusion, "215384594", .1, 1e10, "PriorLow", true)
		local Insane = Instance.new("TextButton")
		CreateAnimButton(Insane, "Insane", "Insane", "R6", 4)
		PlayAnim(Insane, "33796059", .1, 1e8, "PriorLow", true)
		local WallHack = Instance.new("TextButton")
		CreateAnimButton(WallHack, "WallHack", "Wall Hack", "R6", 4)
		PlayAnim(WallHack, "204295235", .1, 1e4, "PriorLow", true)
		CreateAnimButton(WallHack, "WallHack", "Wall Hack", "R6", 4)
		PlayAnim(WallHack, "204295235", .1, -89999, "PriorLow", true)
		local FullSwing = Instance.new("TextButton")
		CreateAnimButton(FullSwing, "FullSwing", "Full Swing", "R6", 5)
		PlayAnim(FullSwing, "218504594", .1, 1, "PriorHigh", false)
		local NunchakSlash = Instance.new("TextButton")
		CreateAnimButton(NunchakSlash, "NunchakSlash", "Nunchak Slash", "R6", 5)
		PlayAnim(NunchakSlash, "204292303", .1, 1.5, "PriorLow", false)
		local FullPunch = Instance.new("TextButton")
		CreateAnimButton(FullPunch, "FullPunch", "Full Punch", "R6", 5)
		PlayAnim(FullPunch, "204062532", .1, 1.5, "PriorLow", false)
		local SwordSpin = Instance.new("TextButton")
		CreateAnimButton(SwordSpin, "SwordSpin", "Sword Spin", "R6", 5)
		PlayAnim(SwordSpin, "186934910", .1, 0.8, "PriorLow", false)
		local Punches = Instance.new("TextButton")
		CreateAnimButton(Punches, "Punches", "Punches", "R6", 5)
		PlayAnim(Punches, "126753849", .1, 2, "PriorLow", false)
		local HeroJump = Instance.new("TextButton")
		CreateAnimButton(HeroJump, "HeroJump", "Hero Jump", "R6", 5)
		PlayAnim(HeroJump, "184574340", .1, 1, "PriorLow", false)
		local DoubleSlash = Instance.new("TextButton")
		CreateAnimButton(DoubleSlash, "DoubleSlash", "Double Slash", "R6", 5)
		PlayAnim(DoubleSlash, "35978879", .1, 2, "PriorLow", false)
		local SwordSwing = Instance.new("TextButton")
		CreateAnimButton(SwordSwing, "SwordSwing", "Sword Swing", "R6", 5)
		PlayAnim(SwordSwing, "32659699", .1, 1, "PriorLow", false)
	end

	--R15 Emotes (Types: Dance (1), Action (2), Walk (3), WeirdAnim (4), Idle (5), Attack (6))
	if (game:GetService"Players".LocalPlayer.Character:WaitForChild("Humanoid").RigType == Enum.HumanoidRigType.R15) then
		local Dance1 = Instance.new("TextButton")
		CreateAnimButton(Dance1, "Dance1", "Dance 1", "R15", 1)
		PlayAnim(Dance1, "507771955", .1, 1, "PriorLow", true)
		local Dance2 = Instance.new("TextButton")
		CreateAnimButton(Dance2, "Dance2", "Dance 2", "R15", 1)
		PlayAnim(Dance2, "507776720", .1, 1, "PriorLow", true)
		local Dance3 = Instance.new("TextButton")
		CreateAnimButton(Dance3, "Dance3", "Dance 3", "R15", 1)
		PlayAnim(Dance3, "507777451", .1, 1, "PriorLow", true)
		local SillyAnimals = Instance.new("TextButton")
		CreateAnimButton(SillyAnimals, "SillyAnimals", "Silly Animals Dance", "R15", 1)
		PlayAnim(SillyAnimals, "98943029911905", .1, 1, "PriorLow", true)
		local ScubaSwim = Instance.new("TextButton")
		CreateAnimButton(ScubaSwim, "ScubaSwim", "Scuba Swim", "R15", 1)
		PlayAnim(ScubaSwim, "133144141297457", .1, 1, "PriorLow", true)
		local SnakeDance = Instance.new("TextButton")
		CreateAnimButton(SnakeDance, "SnakeDance", "Snake Dance", "R15", 1)
		PlayAnim(SnakeDance, "102379382117775", .1, 1, "PriorLow", true)
		local PitbullDance = Instance.new("TextButton")
		CreateAnimButton(PitbullDance, "PitbullDance", "Pitbull Dance", "R15", 1)
		PlayAnim(PitbullDance, "102593046003485", .1, 1, "PriorLow", true)
		local LaDetoneDance = Instance.new("TextButton")
		CreateAnimButton(LaDetoneDance, "LaDetoneDance", "La Detone Dance", "R15", 1)
		PlayAnim(LaDetoneDance, "102779295838500", .1, 1, "PriorLow", true)
		local DiaDeliciaDance = Instance.new("TextButton")
		CreateAnimButton(DiaDeliciaDance, "DiaDeliciaDance", "Dia Delicia Dance", "R15", 1)
		PlayAnim(DiaDeliciaDance, "108759656834820", .1, 1, "PriorLow", true)
		local CrabDance = Instance.new("TextButton")
		CreateAnimButton(CrabDance, "CrabDance", "Crab Dance", "R15", 1)
		PlayAnim(CrabDance, "115209133522801", .1, 1, "PriorLow", true)
		local RatDance = Instance.new("TextButton")
		CreateAnimButton(RatDance, "RatDance", "Rat Dance", "R15", 1)
		PlayAnim(RatDance, "78684440273676", .1, 1, "PriorLow", true)
		local IWantMoneyDance = Instance.new("TextButton")
		CreateAnimButton(IWantMoneyDance, "IWantMoneyDance", "IWantMoney Dance", "R15", 1)
		PlayAnim(IWantMoneyDance, "115781688996859", .1, 1, "PriorLow", true)
		local FortniteDance = Instance.new("TextButton")
		CreateAnimButton(FortniteDance, "FortniteDance", "Fortnite Dance", "R15", 1)
		PlayAnim(FortniteDance, "126199405283943", .1, 1, "PriorLow", true)
		local GangnamStyle = Instance.new("TextButton")
		CreateAnimButton(GangnamStyle, "GangnamStyle", "Gangnam Style", "R15", 1)
		PlayAnim(GangnamStyle, "129764254213842", .1, 0.9, "PriorLow", true)
		local CartoonDance = Instance.new("TextButton")
		CreateAnimButton(CartoonDance, "CartoonDance", "Cartoon Dance", "R15", 1)
		PlayAnim(CartoonDance, "123516934346404", .1, 0.8, "PriorLow", true)
		local RussianKick = Instance.new("TextButton")
		CreateAnimButton(RussianKick, "RussianKick", "Russian Kick", "R15", 1)
		PlayAnim(RussianKick, "70653974473742", .1, 1, "PriorLow", true)
		local MannrobicsDance = Instance.new("TextButton")
		CreateAnimButton(MannrobicsDance, "MannrobicsDance", "Mannrobics Dance", "R15", 1)
		PlayAnim(MannrobicsDance, "73932117454031", .1, 1, "PriorLow", true)
		local PennywiseDance = Instance.new("TextButton")
		CreateAnimButton(PennywiseDance, "PennywiseDance", "Pennywise Dance", "R15", 1)
		PlayAnim(PennywiseDance, "138755180984581", .1, 1, "PriorLow", true)
		local BreakDance = Instance.new("TextButton")
		CreateAnimButton(BreakDance, "BreakDance", "Break Dance", "R15", 1)
		PlayAnim(BreakDance, "10214311282", .1, 1, "PriorLow", true)
		local Rambunctious = Instance.new("TextButton")
		CreateAnimButton(Rambunctious, "Rambunctious", "Rambunctious", "R15", 1)
		PlayAnim(Rambunctious, "129991743366120", .1, 1, "PriorLow", true)
		local NightmailDance = Instance.new("TextButton")
		CreateAnimButton(NightmailDance, "NightmailDance", "Nightmail Dance", "R15", 1)
		PlayAnim(NightmailDance, "103655955630769", .1, 1, "PriorLow", true)
		local TennaArmDance = Instance.new("TextButton")
		CreateAnimButton(TennaArmDance, "TennaArmDance", "Tenna Arm Dance", "R15", 1)
		PlayAnim(TennaArmDance, "140315159513795", .1, 1.1, "PriorLow", true)
		local TennaSwingDance = Instance.new("TextButton")
		CreateAnimButton(TennaSwingDance, "TennaSwingDance", "Tenna Swing Dance", "R15", 1)
		PlayAnim(TennaSwingDance, "77984841414450", .1, 1, "PriorLow", true)
		local TakeTheL = Instance.new("TextButton")
		CreateAnimButton(TakeTheL, "TakeTheL", "Take The L", "R15", 1)
		PlayAnim(TakeTheL, "106769842240175", .1, 1, "PriorLow", true)
		local AwkwardWave = Instance.new("TextButton")
		CreateAnimButton(AwkwardWave, "AwkwardWave", "Awkward Wave", "R15", 2)
		PlayAnim(AwkwardWave, "86074172929360", .1, 1, "PriorLow", true)
		local FingerGun = Instance.new("TextButton")
		CreateAnimButton(FingerGun, "FingerGun", "Finger-Gun", "R15", 2)
		PlayAnim(FingerGun, "73468073017890", .1, 1, "PriorLow", false)
		local PushUp = Instance.new("TextButton")
		CreateAnimButton(PushUp, "PushUp", "Push Ups", "R15", 2)
		PlayAnim(PushUp, "80326183054599", .1, 1, "PriorLow", true)
		local Bodybuilder = Instance.new("TextButton")
		CreateAnimButton(Bodybuilder, "Bodybuilder", "Bodybuilder", "R15", 2)
		PlayAnim(Bodybuilder, "10713990381", .1, 1, "PriorLow", true)
		local Laugh = Instance.new("TextButton")
		CreateAnimButton(Laugh, "Laugh", "Laugh", "R15", 2)
		PlayAnim(Laugh, "507770818", .1, 1, "PriorLow", false)
		local BigLaugh = Instance.new("TextButton")
		CreateAnimButton(BigLaugh, "BigLaugh", "Big Laugh", "R15", 2)
		PlayAnim(BigLaugh, "98974619620224", .1, 1, "PriorLow", true)
		local Bored = Instance.new("TextButton")
		CreateAnimButton(Bored, "Bored", "Bored", "R15", 2)
		PlayAnim(Bored, "10713992055", .1, 1, "PriorLow", true)
		local Applaud = Instance.new("TextButton")
		CreateAnimButton(Applaud, "Applaud", "Applaud", "R15", 2)
		PlayAnim(Applaud, "10713966026", .1, 1, "PriorLow", true)
		local FakeDeadRagdoll = Instance.new("TextButton")
		CreateAnimButton(FakeDeadRagdoll, "FakeDeadRagdoll", "Fake DeadRagdoll", "R15", 2)
		PlayAnim(FakeDeadRagdoll, "80098083655931", .1, 1, "PriorLow", true)
		local FakeDeath = Instance.new("TextButton")
		CreateAnimButton(FakeDeath, "FakeDeath", "FakeDeath", "R15", 2)
		PlayAnim(FakeDeath, "88130117312312", .1, 1, "PriorLowPause", true)
		local Wave = Instance.new("TextButton")
		CreateAnimButton(Wave, "Wave", "Wave", "R15", 2)
		PlayAnim(Wave, "10714359093", .1, 1, "PriorLow", false)
		local Point = Instance.new("TextButton")
		CreateAnimButton(Point, "Point", "Point", "R15", 2)
		PlayAnim(Point, "10714395441", .1, 1, "PriorLow", false)
		local Cheer = Instance.new("TextButton")
		CreateAnimButton(Cheer, "Cheer", "Cheer", "R15", 2)
		PlayAnim(Cheer, "507770677", .1, 1, "PriorLow", false)
		local Salute = Instance.new("TextButton")
		CreateAnimButton(Salute, "Salute", "Salute", "R15", 2)
		PlayAnim(Salute, "10714389988", .1, 1, "PriorLow", false)
		local Shrug = Instance.new("TextButton")
		CreateAnimButton(Shrug, "Shrug", "Shrug", "R15", 2)
		PlayAnim(Shrug, "10714374484", .1, 1, "PriorLow", false)
		local Tank = Instance.new("TextButton")
		CreateAnimButton(Tank, "Tank", "Tank", "R15", 3)
		PlayAnim(Tank, "115951523870527", .5, 1, "PriorLow", true)
		local RaceCar = Instance.new("TextButton")
		CreateAnimButton(RaceCar, "RaceCar", "Race Car", "R15", 3)
		PlayAnim(RaceCar, "72382226286301", .5, 1, "PriorLow", true)
		local Helicopter = Instance.new("TextButton")
		CreateAnimButton(Helicopter, "Helicopter", "Helicopter", "R15", 3)
		PlayAnim(Helicopter, "76510079095692", .5, 1, "PriorLow", true)
		local Plane = Instance.new("TextButton")
		CreateAnimButton(Plane, "Plane", "Plane", "R15", 3)
		PlayAnim(Plane, "94462256787399", .5, 0.5, "PriorLow", true)
		local CarDriving = Instance.new("TextButton")
		CreateAnimButton(CarDriving, "CarDriving", "Car Driving", "R15", 3)
		PlayAnim(CarDriving, "132471972345518", .5, 0.5, "PriorLow", true)
		local ChibiWalk = Instance.new("TextButton")
		CreateAnimButton(ChibiWalk, "ChibiWalk", "Chibi Walk", "R15", 3)
		PlayAnim(ChibiWalk, "85887415033585", .1, 1.3, "PriorLow", true)
		local MedusaWalk = Instance.new("TextButton")
		CreateAnimButton(MedusaWalk, "MedusaWalk", "Medusa Walk", "R15", 3)
		PlayAnim(MedusaWalk, "131663132818596", .1, 1.5, "PriorLow", true)
		local TallCreatureWalk = Instance.new("TextButton")
		CreateAnimButton(TallCreatureWalk, "TallCreatureWalk", "Tall Creature Walk", "R15", 3)
		PlayAnim(TallCreatureWalk, "134010853417610", .1, 1.5, "PriorLow", true)
		local Crawl = Instance.new("TextButton")
		CreateAnimButton(Crawl, "Crawl", "Crawl", "R15", 3)
		PlayAnim(Crawl, "106501741606953", .1, 1, "PriorLow", true)
		local ShadowRun = Instance.new("TextButton")
		CreateAnimButton(ShadowRun, "ShadowRun", "Shadow Running", "R15", 3)
		PlayAnim(ShadowRun, "82598234841035", .1, 0.8, "PriorLow", true)
		local AdidasRun = Instance.new("TextButton")
		CreateAnimButton(AdidasRun, "AdidasRun", "Adidas Running", "R15", 3)
		PlayAnim(AdidasRun, "18537384940", .1, 1, "PriorLow", true)
		local JumpingSpider = Instance.new("TextButton")
		CreateAnimButton(JumpingSpider, "JumpingSpider", "Jumping Spider", "R15", 4)
		PlayAnim(JumpingSpider, "139310328821985", .1, 1, "PriorLow", true)
		local InsaneDog = Instance.new("TextButton")
		CreateAnimButton(InsaneDog, "InsaneDog", "Insane Dog", "R15", 4)
		PlayAnim(InsaneDog, "96435804447949", .1, 1, "PriorLow", true)
		local WormAnim = Instance.new("TextButton")
		CreateAnimButton(WormAnim, "WormAnim", "Worm Fly", "R15", 4)
		PlayAnim(WormAnim, "135990691658209", .3, 1, "PriorLow", true)
		local Orbit = Instance.new("TextButton")
		CreateAnimButton(Orbit, "Orbit", "Orbit", "R15", 4)
		PlayAnim(Orbit, "108359356964182", .5, 1, "PriorLow", true)
		local Hanging = Instance.new("TextButton")
		CreateAnimButton(Hanging, "Hanging", "Hanging", "R15", 4)
		PlayAnim(Hanging, "125662782523118", .1, 1, "PriorLow", true)
		local LaggyWalkTroll = Instance.new("TextButton")
		CreateAnimButton(LaggyWalkTroll, "LaggyWalkTroll", "Laggy Walk Troll", "R15", 4)
		PlayAnim(LaggyWalkTroll, "119199812452698", .1, 1, "PriorLow", true)
		local InchWorm = Instance.new("TextButton")
		CreateAnimButton(InchWorm, "InchWorm", "Inch Worm", "R15", 4)
		PlayAnim(InchWorm, "119096405600200", .1, 1, "PriorLow", true)
		local GoofyWiggle = Instance.new("TextButton")
		CreateAnimButton(GoofyWiggle, "GoofyWiggle", "Goofy Wiggle", "R15", 4)
		PlayAnim(GoofyWiggle, "74917195706355", .1, 1, "PriorLow", true)
		local Tornado = Instance.new("TextButton")
		CreateAnimButton(Tornado, "Tornado", "Tornado", "R15", 4)
		PlayAnim(Tornado, "135373056067761", .1, 1, "PriorLow", true)
		local AdminFly = Instance.new("TextButton")
		CreateAnimButton(AdminFly, "AdminFly", "Admin Fly", "R15", 4)
		PlayAnim(AdminFly, "85063861261432", .1, 1, "PriorLow", true)
		local ObbyHead = Instance.new("TextButton")
		CreateAnimButton(ObbyHead, "ObbyHead", "Little Obbyist", "R15", 4)
		PlayAnim(ObbyHead, "115569573258316", .1, 1, "PriorLow", true)
		local Insane = Instance.new("TextButton")
		CreateAnimButton(Insane, "Insane", "Insane", "R15", 4)
		PlayAnim(Insane, "93087898023268", .1, 1, "PriorLow", true)
		local GoofyFLY = Instance.new("TextButton")
		CreateAnimButton(GoofyFLY, "GoofyFLY", "Goofy FLY", "R15", 4)
		PlayAnim(GoofyFLY, "118417760427139", .1, 1, "PriorLow", true)
		local BodyPhone = Instance.new("TextButton")
		CreateAnimButton(BodyPhone, "BodyPhone", "Body Phone", "R15", 4)
		PlayAnim(BodyPhone, "73390669780316", .1, 0.8, "PriorLow", false)
		local Spin = Instance.new("TextButton")
		CreateAnimButton(Spin, "Spin", "Spin", "R15", 4)
		PlayAnim(Spin, "110792133024438", .1, 1, "PriorLow", true)
		local SpinAround = Instance.new("TextButton")
		CreateAnimButton(SpinAround, "SpinAround", "SpinAround", "R15", 4)
		PlayAnim(SpinAround, "91004858616595", .1, 1, "PriorLow", true)
		local FloatingSpace = Instance.new("TextButton")
		CreateAnimButton(FloatingSpace, "FloatingSpace", "Floating Space", "R15", 4)
		PlayAnim(FloatingSpace, "71209604118044", .1, 1, "PriorLow", true)
		local FloatingSpace2 = Instance.new("TextButton")
		CreateAnimButton(FloatingSpace2, "FloatingSpace2", "Floating Space 2", "R15", 4)
		PlayAnim(FloatingSpace2, "70394064781064", .1, 1, "PriorLow", true)
		local FloatingHeadSitting = Instance.new("TextButton")
		CreateAnimButton(FloatingHeadSitting, "FloatingHeadSitting", "Floating Head Sit", "R15", 5)
		PlayAnim(FloatingHeadSitting, "111681053387222", .3, 1, "PriorLow", true)
		local VibeIdle = Instance.new("TextButton")
		CreateAnimButton(VibeIdle, "VibeIdle", "Vibe Idle", "R15", 5)
		PlayAnim(VibeIdle, "99638411514722", .1, 1, "PriorLow", true)
		local FloatChillSit = Instance.new("TextButton")
		CreateAnimButton(FloatChillSit, "FloatChillSit", "Float Chill Sit", "R15", 5)
		PlayAnim(FloatChillSit, "97361223864206", .1, 0.5, "PriorLow", true)
		local FloatIdle = Instance.new("TextButton")
		CreateAnimButton(FloatIdle, "FloatIdle", "Float Idle", "R15", 5)
		PlayAnim(FloatIdle, "94942486115057", .1, 1, "PriorLow", true)
		local TPose = Instance.new("TextButton")
		CreateAnimButton(TPose, "TPose", "T Pose", "R15", 5)
		PlayAnim(TPose, "121655148084031", .1, 1, "PriorLow", true)
		local CrouchR15 = Instance.new("TextButton")
		CreateAnimButton(CrouchR15, "CrouchR15", "Crouch", "R15", 5)
		PlayAnim(CrouchR15, "97517127273301", .3, 1, "PriorLow", true)
		local Crawl = Instance.new("TextButton")
		CreateAnimButton(Crawl, "Crawl", "Crawl", "R15", 5)
		PlayAnim(Crawl, "106501741606953", .3, 1, "PriorLow", true)
		local Sitting = Instance.new("TextButton")
		CreateAnimButton(Sitting, "Sitting", "Sitting", "R15", 5)
		PlayAnim(Sitting, "94763556845023", .1, 1, "PriorLow", true)
		local MM2Sit = Instance.new("TextButton")
		CreateAnimButton(MM2Sit, "MM2Sit", "MM2 Sit", "R15", 5)
		PlayAnim(MM2Sit, "130577643309726", .1, 1, "PriorLow", true)
		local Box = Instance.new("TextButton")
		CreateAnimButton(Box, "Box", "Box", "R15", 5)
		PlayAnim(Box, "73753845465382", .1, 1, "PriorLow", true)
		local Sleeping = Instance.new("TextButton")
		CreateAnimButton(Sleeping, "Sleeping", "Sleeping", "R15", 5)
		PlayAnim(Sleeping, "121641415206650", .5, 1, "PriorLow", true)
		local HeadJuggle = Instance.new("TextButton")
		CreateAnimButton(HeadJuggle, "HeadJuggle", "Head Juggle", "R15", 5)
		PlayAnim(HeadJuggle, "136767849845319", .1, 1, "PriorLow", true)
		local FloatingOnClouds = Instance.new("TextButton")
		CreateAnimButton(FloatingOnClouds, "FloatingOnClouds", "Floating On Clouds", "R15", 5)
		PlayAnim(FloatingOnClouds, "77840765435893", .1, 1, "PriorLow", true)
		local SitAnim = Instance.new("TextButton")
		CreateAnimButton(SitAnim, "SitAnim", "Sit Anim", "R15", 5)
		PlayAnim(SitAnim, "507768133", .1, 1, "PriorLow", true)
		local ToolHandle = Instance.new("TextButton")
		CreateAnimButton(ToolHandle, "ToolHandle", "Tool Handle", "R15", 5)
		PlayAnim(ToolHandle, "507768375", .1, 1, "PriorHigh", true)
		local FightingIdle = Instance.new("TextButton")
		CreateAnimButton(FightingIdle, "FightingIdle", "Fighting Idle", "R15", 5)
		PlayAnim(FightingIdle, "105947156749343", .1, 1, "PriorLow", true)
		local DaHoodStomp = Instance.new("TextButton")
		CreateAnimButton(DaHoodStomp, "DaHoodStomp", "DaHood Stomp", "R15", 6)
		PlayAnim(DaHoodStomp, "92249489340640", .1, 1, "PriorLow", false)
		local QuadPunch = Instance.new("TextButton")
		CreateAnimButton(QuadPunch, "QuadPunch", "Quad Punch", "R15", 6)
		PlayAnim(QuadPunch, "139643944264511", .1, 1, "PriorLow", false)
		local TennaKick = Instance.new("TextButton")
		CreateAnimButton(TennaKick, "TennaKick", "TennaKick", "R15", 6)
		PlayAnim(TennaKick, "118139885865308", .1, 1, "PriorLow", false)
		local Dropkick = Instance.new("TextButton")
		CreateAnimButton(Dropkick, "Dropkick", "Dropkick", "R15", 6)
		PlayAnim(Dropkick, "133566007754001", .1, 1, "PriorLow", false)
	end
	
	-- UI Decorations
	
	local UiCornerParts = {"GuiTopFrame", "CloseGUI", "DestroyGUI", "GuiBottomFrame", "SpeedValue", "SideFrame", "OpenGUI", "ViewportFrame", "OptionsFrame", "PauseAnimsButton", "StopDefAnimsButton", "PauseAnimateButton", "PreviewEnableButton", "SearchFrame", "SearchButton", "BackButton"}
	local UiStrokeParts = {"GuiTopFrame", "GuiBottomFrame", "SpeedValue", "SearchBox", "SideFrame", "ScrollingFrame", "ScrollingFrameR15", "OptionsFrame", "PauseAnimsButton", "StopDefAnimsButton", "PauseAnimateButton", "PreviewEnableButton", "SearchFrame"}
	local UiStroke1Parts = {"SpeedValue", "SearchBox", "PauseAnimsButton", "StopDefAnimsButton", "PauseAnimateButton", "PreviewEnableButton"}
	local UiGradientParts = {"GuiTopFrame", "GuiBottomFrame", "SideFrame", "SettingsButton", "DestroyGUI", "CloseGUI", "OpenGUI", "OptionsButton", "PauseAnimsButton", "StopDefAnimsButton", "PauseAnimateButton", "PreviewEnableButton", "SearchFrame", "SearchButton", "BackButton"}

	for _, UiPart in ipairs(Emoter:GetDescendants()) do
		if table.find(UiCornerParts, UiPart.Name) then
			local UICorner = Instance.new("UICorner")
			UICorner.Parent = UiPart
			UICorner.CornerRadius = UDim.new(0, 5)
			if UiPart.Name == "GuiTopFrame" then
				UICorner.BottomRightRadius = UDim.new(0, 0)
				UICorner.BottomLeftRadius = UDim.new(0, 0)
			elseif UiPart.Name == "GuiBottomFrame" then
				UICorner.TopLeftRadius = UDim.new(0, 0)
				UICorner.TopRightRadius = UDim.new(0, 0)
			end

		end

		if table.find(UiStrokeParts, UiPart.Name) then
			local UIStroke = Instance.new("UIStroke")
			UIStroke.Parent = UiPart
			UIStroke.Thickness = 2
			UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			if table.find(UiStroke1Parts, UiPart.Name) then
				UIStroke.Thickness = 1
			end
		end
		
		if table.find(UiGradientParts, UiPart.Name) then
			local UIGradient = Instance.new("UIGradient")
			UIGradient.Parent = UiPart
			UIGradient.Color = ColorSequence.new(Color3.fromRGB(207, 207, 207), Color3.fromRGB(255, 255, 255))
			UIGradient.Rotation = -90
		end

		if (UiPart.Parent.Name == "ScrollingFrame" or UiPart.Parent.Name == "ScrollingFrameR15") and UiPart:IsA("TextButton") then
			local UICorner = Instance.new("UICorner")
			UICorner.Parent = UiPart
			UICorner.CornerRadius = UDim.new(0, 3)
			local UIStroke = Instance.new("UIStroke")
			UIStroke.Parent = UiPart
			UIStroke.Thickness = 1
			UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			local UIGradient = Instance.new("UIGradient")
			UIGradient.Parent = UiPart
			UIGradient.Color = ColorSequence.new(Color3.fromRGB(207, 207, 207), Color3.fromRGB(255, 255, 255))
			UIGradient.Rotation = -90

		end
	end
	
	--OnRestart things

	if GuiPos ~= nil then
		SideFrame.Position = GuiPos
	end
	if GuiClosed == true then
		SideFrame.Visible = true
	end
	if GuiPos ~= nil then
		MainFrame.Position = GuiPos
	end
	if GuiClosed == true then
		MainFrame.Visible = false
	end
	if OptionsOpened == true then
		OptionsFrame.Visible = true
		OptionsFrame.Position = UDim2.new(0.5, 0, 1, 7)
	end

	if ScrollingFramePos ~= nil then
		ScrollingFrame.CanvasPosition = ScrollingFramePos
	end
	if ScrollingFramePos ~= nil then
		ScrollingFrameR15.CanvasPosition = ScrollingFramePos
	end
	SearchBox.Text = PrevSearchText
	SpeedValue.Text = PrevAnimSpeedValue
	
	GuiEmoter = Emoter

end

local function OnRestart()
	if GuiEmoter.MainFrame.Visible == true then
		GuiClosed = false
		GuiPos = GuiEmoter.MainFrame.Position
	elseif GuiEmoter.SideFrame.Visible == true then
		GuiClosed = true
		GuiPos = GuiEmoter.SideFrame.Position
	end
	if (game:GetService"Players".LocalPlayer.Character:WaitForChild("Humanoid").RigType == Enum.HumanoidRigType.R15) then
		ScrollingFramePos = GuiEmoter.MainFrame.ScrollingFrameR15.CanvasPosition
	else
		ScrollingFramePos = GuiEmoter.MainFrame.ScrollingFrame.CanvasPosition
	end
	if GuiEmoter.MainFrame.OptionsFrame.Visible == true then
		OptionsOpened = true
	else
		OptionsOpened = false
	end
	
	if GuiEmoter.MainFrame.SearchFrame.SearchBox.Visible == true then
		SearchOpened = true
	else
		SearchOpened = false
	end
	PrevAnimSpeedValue = GuiEmoter.MainFrame.GuiBottomFrame.SpeedFrame.SpeedValue.Text
	PrevSearchText = GuiEmoter.MainFrame.SearchFrame.SearchBox.Text
	GuiEmoter:Destroy()
	CreateGui()
end

-- PLEASE DO NOT DELETE THIS
game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Welcome to Emoter Gui!", Text = "Wait for script to load!", Duration = 5, Icon = "rbxassetid://85975257618857"})
-- PLEASE DO NOT DELETE THIS

CreateGui()

Player.CharacterAdded:connect(function()
	if GuiActive and Player.Character:WaitForChild("Humanoid") then
		OnRestart()
	end
end)
