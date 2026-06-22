--V2
--[[Script by Fixel656, based on Energize GUI by illremember
DO NOT COPY AND CLAIM AS YOUR OWN, if you are using some of the script for your own, 
credit is highly appreciated!]]

--V1
--Original by illremember, edited by Fixel656
--DO NOT COPY AND CLAIM AS OWN, if you are using some of the script for your own, 
--credit (especially of original author) is highly appreciated! 

local GuiActive = true
local GuiEmoter = nil
local Player = game.Players.LocalPlayer

local function CreateGui()

	local Emoter = Instance.new("ScreenGui") -- The actual GUI
	local SideFrame = Instance.new("Frame") -- Visible when GUI is closed
	local OpenGUI = Instance.new("ImageButton") -- Part of SideFrame
	local SideFrameTitle = Instance.new("TextLabel") -- Part of SideFrame
	local MainFrame = Instance.new("Frame") -- All of the stuff on the main frame

	local GuiBottomFrame = Instance.new("Frame")
	local SpeedFrame = Instance.new("Frame") -- Frame of Speed Changer
	local CurSpeedText = Instance.new("TextLabel") --Text showing your current anim speed

	local ScrollingFrame = Instance.new("ScrollingFrame") -- The scrolling frame of animations
	local ScrollingFrameR15 = Instance.new("ScrollingFrame") -- The scrolling frame of R15 animations

	local GuiTopFrame = Instance.new("Frame") -- Top of the main frame
	local DestroyGUI = Instance.new("TextButton") -- To Destroy the GUI
	local SFDestroyGUI = Instance.new("TextButton") -- To Destroy the GUI in SideFrame
	local CloseGUI = Instance.new("ImageButton") -- To close the GUI
	local Title = Instance.new("TextLabel") -- Actual title of GUI, Emoter

	local SpeedNum --Value, adding to default speed of animation

	-- AnimButtons In new place now (~340 string)

	BgColor = Color3.new(0.541176, 0.647059, 1)
	ScrollBgColor = Color3.new(0.862745, 0.960784, 1)
	ButtonCol = Color3.new(0.541176, 0.647059, 1) -- R6 Button Color
	ButtonBackCol = Color3.new(0.741176, 0.780392, 1) -- R6 Button darker color (idk how to make it just darker BgColor yet)
	R15ButtonCol = Color3.new(0.682353, 0.701961, 0.792157) --R15 Button color
	R15ButtonBackCol = Color3.new(0.882353, 0.901961, 0.992157) -- R15 Button darker color

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

		Button.Size = UDim2.new(0, 119, 0, 34)
		Button.Font = Enum.Font.Highway
		Button.Text = Text
		Button.TextScaled = true
		Button.LayoutOrder = LayoutPos

	end

	local function PlayAnim(Object, ID, AnimWeight, Speed, Type, LoopedVal, NeedPause) -- Types Tutorial on Emotes section
		Object:SetAttribute("Looped", LoopedVal)
		if LoopedVal == false then
			AddHoverText(Object, "Click RMB to loop")
		end
		local Anim = Instance.new("Animation")
		Anim.AnimationId = ID
		local track = Player.Character.Humanoid:LoadAnimation(Anim)
		if Type:find("PriorLow") then
			track.Priority = Enum.AnimationPriority.Action3
		elseif Type:find("PriorHigh") then
			track.Priority = Enum.AnimationPriority.Action4
		end		

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

				if Object.Parent == ScrollingFrame then
					Object.BackgroundColor3 = ButtonBackCol
				elseif Object.Parent == ScrollingFrameR15 then
					Object.BackgroundColor3 = R15ButtonBackCol
				end
				Object.UIStroke.Thickness = 2
				Object.UIStroke.Color = Color3.new(0.0392157, 0.501961, 1)
				CurSpeedText.Text = "Speed: ".. Speed + SpeedNum

				if Type:find("Pause") then
					wait(1)
					track:AdjustSpeed(0)
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
				CurSpeedText.Text = "Speed: -"
			end
			track.Ended:connect(function()
				AnimACTIVE = false
				if Object.Parent == ScrollingFrame then
					Object.BackgroundColor3 = ButtonCol
				elseif Object.Parent == ScrollingFrameR15 then
					Object.BackgroundColor3 = R15ButtonCol
				end
				Object.UIStroke.Thickness = 1
				Object.UIStroke.Color = Color3.new(0, 0, 0)
				CurSpeedText.Text = "Speed: -"
			end)
		end)
		Object.MouseButton2Click:connect(function()
			local CurLooped = Object:GetAttribute("Looped")
			if CurLooped == false then
				AnimACTIVE = not AnimACTIVE
				if AnimACTIVE then
					track.Looped = true
					track:Play(AnimWeight, 1, Speed + SpeedNum)

					if Object.Parent == ScrollingFrame then
						Object.BackgroundColor3 = ButtonBackCol
					elseif Object.Parent == ScrollingFrameR15 then
						Object.BackgroundColor3 = R15ButtonBackCol
					end
					Object.UIStroke.Thickness = 2
					Object.UIStroke.Color = Color3.new(0.972549, 0.670588, 0.0627451)
					CurSpeedText.Text = "Speed: ".. Speed + SpeedNum

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
					CurSpeedText.Text = "Speed: -"
				end
			end
		end)

	end

	-- Properties
	-- SideFrame

	Emoter.Name = "Emoter"
	Emoter.Parent = Player.PlayerGui

	SideFrame.Name = "SideFrame"
	SideFrame.Parent = Emoter
	SideFrame.Active = true
	SideFrame.BackgroundColor3 = BgColor
	SideFrame.Position = UDim2.new(0, 10, 0, 10)
	SideFrame.Size = UDim2.new(0, 225, 0, 32)
	SideFrame.Visible = false

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
	SFDestroyGUI.TextColor3 = Color3.new(0, 0, 0)
	SFDestroyGUI.TextSize = 34
	SFDestroyGUI.TextWrapped = true
	AddHoverText(SFDestroyGUI, "Delete GUI")

	-- MainFrame

	MainFrame.Name = "MainFrame"
	MainFrame.Parent = Emoter
	MainFrame.Active = true
	MainFrame.BackgroundColor3 = BgColor
	MainFrame.BackgroundTransparency = 1
	MainFrame.Position = UDim2.new(0, 10, 0, 10)
	MainFrame.Size = UDim2.new(0, 460, 0, 250)

	local UIDragDetectorMainFrame = Instance.new("UIDragDetector")
	UIDragDetectorMainFrame.Parent = MainFrame

	-- GuiBottomFrame

	GuiBottomFrame.Name = "GuiBottomFrame"
	GuiBottomFrame.Parent = MainFrame
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
	ValueText.Font = Enum.Font.SourceSans
	ValueText.TextScaled = true

	--

	CurSpeedText.Name = "CurSpeedText"
	CurSpeedText.AnchorPoint = Vector2.new(1, 0)
	CurSpeedText.Size = UDim2.new(0, 150, 0, 35)
	CurSpeedText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CurSpeedText.BackgroundTransparency = 1
	CurSpeedText.Position = UDim2.new(1, 0, 0, -2)
	CurSpeedText.BorderSizePixel = 0
	CurSpeedText.BackgroundColor3 = Color3.fromRGB(226, 198, 93)
	CurSpeedText.TextStrokeTransparency = 0
	CurSpeedText.TextColor3 = Color3.fromRGB(255, 255, 255)
	CurSpeedText.Text = "Speed: -"
	CurSpeedText.TextWrapped = true
	CurSpeedText.Font = Enum.Font.SourceSans
	CurSpeedText.TextScaled = true
	CurSpeedText.Parent = GuiBottomFrame

	SpeedValue.Changed:Connect(function()
		SpeedNum = SpeedValue.Text
		if SpeedValue.Text == "" then
			SpeedNum = 0
		end
	end)

	--Scrolling Frames

	ScrollingFrame.Parent = MainFrame
	ScrollingFrame.BackgroundColor3 = ScrollBgColor
	ScrollingFrame.Position = UDim2.new(0, 0, 0, 34)
	ScrollingFrame.ScrollBarImageColor3 = Color3.new(0, 0, 0)
	ScrollingFrame.Size = UDim2.new(0, 460, 0, 215)
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
	ScrollingFrame.ScrollBarThickness = 10

	local SF6UIGridLayout = Instance.new("UIGridLayout")
	SF6UIGridLayout.Parent = ScrollingFrame
	SF6UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	SF6UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SF6UIGridLayout.CellSize = UDim2.new(0, 100, 0, 30)
	SF6UIGridLayout.CellPadding = UDim2.new(0, 10, 0, 10)

	local SF6UIPadding = Instance.new("UIPadding")
	SF6UIPadding.Parent = ScrollingFrame
	SF6UIPadding.PaddingTop = UDim.new(0, 10)
	SF6UIPadding.PaddingRight = UDim.new(0, 10)

	ScrollingFrameR15.Name = "ScrollingFrameR15"
	ScrollingFrameR15.Parent = MainFrame
	ScrollingFrameR15.BackgroundColor3 = ScrollBgColor
	ScrollingFrameR15.Position = UDim2.new(0, 0, 0, 34)
	ScrollingFrameR15.ScrollBarImageColor3 = Color3.new(0, 0, 0)
	ScrollingFrameR15.Size = UDim2.new(0, 460, 0, 215)
	ScrollingFrameR15.CanvasSize = UDim2.new(0, 0, 3.7, 0)
	ScrollingFrameR15.Visible = false
	ScrollingFrameR15.ScrollBarThickness = 10

	local SF15UIGridLayout = Instance.new("UIGridLayout")
	SF15UIGridLayout.Parent = ScrollingFrameR15
	SF15UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	SF15UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SF15UIGridLayout.CellSize = UDim2.new(0, 100, 0, 30)
	SF15UIGridLayout.CellPadding = UDim2.new(0, 10, 0, 10)

	local SF15UIPadding = Instance.new("UIPadding")
	SF15UIPadding.Parent = ScrollingFrameR15
	SF15UIPadding.PaddingTop = UDim.new(0, 10)
	SF15UIPadding.PaddingRight = UDim.new(0, 10)

	--

	GuiTopFrame.Name = "GuiTopFrame"
	GuiTopFrame.Parent = MainFrame
	GuiTopFrame.BackgroundColor3 = Color3.new(0.541176, 0.647059, 1)
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
	DestroyGUI.TextColor3 = Color3.new(0, 0, 0)
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

	DestroyGUI.MouseButton1Click:connect(function()
		GuiActive = false
		Emoter:Destroy()
	end)
	SFDestroyGUI.MouseButton1Click:connect(function()
		GuiActive = false
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

	-- EMOTES	

	--[[Functions Template
	local AnimName = Instance.new("TextButton")
	CreateAnimButton(Obj, "Name", "Text", "R6", 0)
	PlayAnim(Obj, "rbxassetid://", .1, 1, "PriorLow", true)
	
	- CreateAnimation has Object (Button), Name of object, Text, Type ow whiich type of scrolling frame will it be, 
	and LayoutOrder to organize Anim button to its type
	- PlayAnim has Object (Button), Id of anim, Anim FadeTime, speed of anim, Type of Anim and Looped state value (if anim is unlooped you can loop it by clicking RMB).
	Type of anim is checked as Type:find("PriorLow"), so you can type in multiple states inside.
	States available: PriorLow/PriorHigh (Priority of animation), Pause (Animation will stop after 1 second)
	
	WARNING: CHECK 
	]]

	-- R6 Emotes

	local Dance1 = Instance.new("TextButton")
	CreateAnimButton(Dance1, "Dance1", "Dance 1", "R6", 0)
	PlayAnim(Dance1, "rbxassetid://182491037", .1, 1, "PriorLow", true)
	local Dance2 = Instance.new("TextButton")
	CreateAnimButton(Dance2, "Dance2", "Dance 2", "R6", 0)
	PlayAnim(Dance2, "rbxassetid://182436842", .1, 1, "PriorLow", true)
	local Dance3 = Instance.new("TextButton")
	CreateAnimButton(Dance3, "Dance3", "Dance 3", "R6", 0)
	PlayAnim(Dance3, "rbxassetid://182491368", .1, 1, "PriorLow", true)
	local MoonDance = Instance.new("TextButton")
	CreateAnimButton(MoonDance, "MoonDance", "Moon Dance", "R6", 0)
	PlayAnim(MoonDance, "rbxassetid://45834924", .1, 1, "PriorLow", true)
	local SpinDance = Instance.new("TextButton")
	CreateAnimButton(SpinDance, "SpinDance", "Spin Dance", "R6", 0)
	PlayAnim(SpinDance, "rbxassetid://429730430", .1, 1, "PriorLow", true)
	local JumpingJacks = Instance.new("TextButton")
	CreateAnimButton(JumpingJacks, "JumpingJacks", "Jumping Jacks", "R6", 0)
	PlayAnim(JumpingJacks, "rbxassetid://429681631", .1, 1, "PriorLow", true)
	local Bang = Instance.new("TextButton")
	CreateAnimButton(Bang, "Bang", "Bang", "R6", 0)
	PlayAnim(Bang, "rbxassetid://148840371", .1, 3, "PriorLow", true)
	local MovingDance = Instance.new("TextButton")
	CreateAnimButton(MovingDance, "MovingDance", "Moving Dance", "R6", 0)
	PlayAnim(MovingDance, "rbxassetid://429703734", .1, 1, "PriorLow", true)
	local Dab = Instance.new("TextButton")
	CreateAnimButton(Dab, "Dab", "Dab", "R6", 0)
	PlayAnim(Dab, "rbxassetid://248263260", .1, 1, "PriorLow", true)
	local GoofyDance = Instance.new("TextButton")
	CreateAnimButton(GoofyDance, "GoofyDance", "Goofy Dance", "R6", 0)
	PlayAnim(GoofyDance, "rbxassetid://27789359", .1, 0.8, "PriorLow", true)
	local WeirdDance = Instance.new("TextButton")
	CreateAnimButton(WeirdDance, "WeirdDance", "Weird Dance", "R6", 0)
	PlayAnim(WeirdDance, "rbxassetid://28488254", .1, 0.8, "PriorLow", true)
	local Laugh = Instance.new("TextButton")
	CreateAnimButton(Laugh, "Laugh", "Laugh", "R6", 0)
	PlayAnim(Laugh, "rbxassetid://129423131", .1, 1, "PriorLow", false)
	local Cheer = Instance.new("TextButton")
	CreateAnimButton(Cheer, "Cheer", "Cheer", "R6", 0)
	PlayAnim(Cheer, "rbxassetid://129423030", .1, 1, "PriorLow", true)
	local Point = Instance.new("TextButton")
	CreateAnimButton(Point, "Point", "Point", "R6", 0)
	PlayAnim(Point, "rbxassetid://128853357", .1, 1, "PriorLow", false)
	local Wave = Instance.new("TextButton")
	CreateAnimButton(Wave, "Wave", "Wave", "R6", 0)
	PlayAnim(Wave, "rbxassetid://128777973", .1, 1, "PriorLow", false)
	local Crouch = Instance.new("TextButton")
	CreateAnimButton(Crouch, "Crouch", "Crouch", "R6", 1)
	PlayAnim(Crouch, "rbxassetid://182724289", .1, 1, "PriorLow", true)
	local Faint = Instance.new("TextButton")
	CreateAnimButton(Faint, "Faint", "Faint", "R6", 1)
	PlayAnim(Faint, "rbxassetid://181526230", .1, 1, "PriorHigh", true)
	local FloorCrawl = Instance.new("TextButton")
	CreateAnimButton(FloorCrawl, "FloorCrawl", "Floor Crawl", "R6", 1)
	PlayAnim(FloorCrawl, "rbxassetid://282574440", .1, 1, "PriorLow", true)
	local Levitate = Instance.new("TextButton")
	CreateAnimButton(Levitate, "Levitate", "Levitate", "R6", 1)
	PlayAnim(Levitate, "rbxassetid://313762630", .1, 1, "PriorHigh", true)
	local DinoWalk = Instance.new("TextButton")
	CreateAnimButton(DinoWalk, "DinoWalk", "Dino Walk", "R6", 1)
	PlayAnim(DinoWalk, "rbxassetid://204328711", .1, 1, "PriorLow", true)
	local Climb = Instance.new("TextButton")
	CreateAnimButton(Climb, "Climb", "Climb Walk", "R6", 0)
	PlayAnim(Climb, "rbxassetid://125750800", .1, 1, "PriorLow", true)
	local ToolHandle = Instance.new("TextButton")
	CreateAnimButton(ToolHandle, "ToolHandle", "Tool Handle", "R6", 1)
	PlayAnim(ToolHandle, "rbxassetid://125750867", .1, 1, "PriorHigh", true)
	local Scared = Instance.new("TextButton")
	CreateAnimButton(Scared, "Scared", "Scared", "R6", 1)
	PlayAnim(Scared, "rbxassetid://180612465", .1, 0.3, "PriorLowPause", true)
	local FloatingHead = Instance.new("TextButton")
	CreateAnimButton(FloatingHead, "FloatingHead", "Floating Head", "R6", 1)
	PlayAnim(FloatingHead, "rbxassetid://121572214", .1, 1, "PriorHigh", true)
	local FloatSit = Instance.new("TextButton")
	CreateAnimButton(FloatSit, "FloatSit", "Float Sit", "R6", 1)
	PlayAnim(FloatSit, "rbxassetid://179224234", .5, 1, "PriorLow", true)
	local Spinner = Instance.new("TextButton")
	CreateAnimButton(Spinner, "Spinner", "Spinner", "R6", 2)
	PlayAnim(Spinner, "rbxassetid://188632011", .1, 2, "PriorHigh", true)
	local StrangePos = Instance.new("TextButton")
	CreateAnimButton(StrangePos, "StrangePos", "Strange Position", "R6", 2)
	PlayAnim(StrangePos, "rbxassetid://248336459", .1, 1, "PriorLow", true)
	local HeadThrow = Instance.new("TextButton")
	CreateAnimButton(HeadThrow, "HeadThrow", "Head Throw", "R6", 2)
	PlayAnim(HeadThrow, "rbxassetid://35154961", .1, 1, "PriorHigh", false)
	local ArmTurbine = Instance.new("TextButton")
	CreateAnimButton(ArmTurbine, "ArmTurbine", "Arm Turbine", "R6", 2)
	PlayAnim(ArmTurbine, "rbxassetid://259438880", .1, 3, "PriorLow", true)
	local BarrelRoll = Instance.new("TextButton")
	CreateAnimButton(BarrelRoll, "BarrelRoll", "Barrel Roll", "R6", 2)
	PlayAnim(BarrelRoll, "rbxassetid://136801964", .1, 1, "PriorLow", true)
	local MegaInsane = Instance.new("TextButton")
	CreateAnimButton(MegaInsane, "MegaInsane", "Mega Insane", "R6", 3)
	PlayAnim(MegaInsane, "rbxassetid://184574340", .1, 40, "PriorLow", true)
	local WeirdMove = Instance.new("TextButton")
	CreateAnimButton(WeirdMove, "WeirdMove", "Weird Move", "R6", 3)
	PlayAnim(WeirdMove, "rbxassetid://215384594", .1, 1, "PriorLow", true)
	local CloneIllusion = Instance.new("TextButton")
	CreateAnimButton(CloneIllusion, "CloneIllusion", "Clone Illusion", "R6", 3)
	PlayAnim(CloneIllusion, "rbxassetid://215384594", .1, 1e10, "PriorLow", true)
	local Insane = Instance.new("TextButton")
	CreateAnimButton(Insane, "Insane", "Insane", "R6", 3)
	PlayAnim(Insane, "rbxassetid://33796059", .1, 1e8, "PriorLow", true)
	local WallHack = Instance.new("TextButton")
	CreateAnimButton(WallHack, "WallHack", "Wall Hack", "R6", 3)
	PlayAnim(WallHack, "rbxassetid://204295235", .1, 1e4, "PriorLow", true)
	local FullSwing = Instance.new("TextButton")
	CreateAnimButton(FullSwing, "FullSwing", "Full Swing", "R6", 4)
	PlayAnim(FullSwing, "rbxassetid://218504594", .1, 1, "PriorHigh", false)
	local NunchakSlash = Instance.new("TextButton")
	CreateAnimButton(NunchakSlash, "NunchakSlash", "Nunchak Slash", "R6", 4)
	PlayAnim(NunchakSlash, "rbxassetid://204292303", .1, 1.5, "PriorLow", false)
	local FullPunch = Instance.new("TextButton")
	CreateAnimButton(FullPunch, "FullPunch", "Full Punch", "R6", 4)
	PlayAnim(FullPunch, "rbxassetid://204062532", .1, 1, "PriorLow", false)
	local SwordSpin = Instance.new("TextButton")
	CreateAnimButton(SwordSpin, "SwordSpin", "Sword Spin", "R6", 4)
	PlayAnim(SwordSpin, "rbxassetid://186934910", .1, 0.8, "PriorLow", false)
	local Punches = Instance.new("TextButton")
	CreateAnimButton(Punches, "Punches", "Punches", "R6", 4)
	PlayAnim(Punches, "rbxassetid://126753849", .1, 2, "PriorLow", false)
	local HeroJump = Instance.new("TextButton")
	CreateAnimButton(HeroJump, "HeroJump", "Hero Jump", "R6", 4)
	PlayAnim(HeroJump, "rbxassetid://184574340", .1, 1, "PriorLow", false)
	local DoubleSlash = Instance.new("TextButton")
	CreateAnimButton(DoubleSlash, "DoubleSlash", "Double Slash", "R6", 4)
	PlayAnim(DoubleSlash, "rbxassetid://35978879", .1, 2, "PriorLow", false)
	local SwordSwing = Instance.new("TextButton")
	CreateAnimButton(SwordSwing, "SwordSwing", "Sword Swing", "R6", 4)
	PlayAnim(SwordSwing, "rbxassetid://32659699", .1, 1, "PriorLow", false)

	--R15 Emotes (Types: Dance (1), Action (2), Walk (3), WeirdAnim (4), Idle (5), Attack (6))
	
	local Dance1 = Instance.new("TextButton")
	CreateAnimButton(Dance1, "Dance1", "Dance 1", "R15", 1)
	PlayAnim(Dance1, "rbxassetid://507771955", .1, 1, "PriorLow", true)
	local Dance2 = Instance.new("TextButton")
	CreateAnimButton(Dance2, "Dance2", "Dance 2", "R15", 1)
	PlayAnim(Dance2, "rbxassetid://507776720", .1, 1, "PriorLow", true)
	local Dance3 = Instance.new("TextButton")
	CreateAnimButton(Dance3, "Dance3", "Dance 3", "R15", 1)
	PlayAnim(Dance3, "rbxassetid://507777451", .1, 1, "PriorLow", true)
	local SillyAnimals = Instance.new("TextButton")
	CreateAnimButton(SillyAnimals, "SillyAnimals", "Silly Animals Dance", "R15", 1)
	PlayAnim(SillyAnimals, "rbxassetid://98943029911905", .1, 1, "PriorLow", true)
	local ScubaSwim = Instance.new("TextButton")
	CreateAnimButton(ScubaSwim, "ScubaSwim", "Scuba Swim", "R15", 1)
	PlayAnim(ScubaSwim, "rbxassetid://133144141297457", .1, 1, "PriorLow", true)
	local SnakeDance = Instance.new("TextButton")
	CreateAnimButton(SnakeDance, "SnakeDance", "Snake Dance", "R15", 1)
	PlayAnim(SnakeDance, "rbxassetid://102379382117775", .1, 1, "PriorLow", true)
	local PitbullDance = Instance.new("TextButton")
	CreateAnimButton(PitbullDance, "PitbullDance", "Pitbull Dance", "R15", 1)
	PlayAnim(PitbullDance, "rbxassetid://102593046003485", .1, 1, "PriorLow", true)
	local LaDetoneDance = Instance.new("TextButton")
	CreateAnimButton(LaDetoneDance, "LaDetoneDance", "La Detone Dance", "R15", 1)
	PlayAnim(LaDetoneDance, "rbxassetid://102779295838500", .1, 1, "PriorLow", true)
	local DiaDeliciaDance = Instance.new("TextButton")
	CreateAnimButton(DiaDeliciaDance, "DiaDeliciaDance", "Dia Delicia Dance", "R15", 1)
	PlayAnim(DiaDeliciaDance, "rbxassetid://108759656834820", .1, 1, "PriorLow", true)
	local CrabDance = Instance.new("TextButton")
	CreateAnimButton(CrabDance, "CrabDance", "Crab Dance", "R15", 1)
	PlayAnim(CrabDance, "rbxassetid://115209133522801", .1, 1, "PriorLow", true)
	local RatDance = Instance.new("TextButton")
	CreateAnimButton(RatDance, "RatDance", "Rat Dance", "R15", 1)
	PlayAnim(RatDance, "rbxassetid://78684440273676", .1, 1, "PriorLow", true)
	local IWantMoneyDance = Instance.new("TextButton")
	CreateAnimButton(IWantMoneyDance, "IWantMoneyDance", "IWantMoney Dance", "R15", 1)
	PlayAnim(IWantMoneyDance, "rbxassetid://115781688996859", .1, 1, "PriorLow", true)
	local FortniteDance = Instance.new("TextButton")
	CreateAnimButton(FortniteDance, "FortniteDance", "Fortnite Dance", "R15", 1)
	PlayAnim(FortniteDance, "rbxassetid://126199405283943", .1, 1, "PriorLow", true)
	local GangnamStyle = Instance.new("TextButton")
	CreateAnimButton(GangnamStyle, "GangnamStyle", "Gangnam Style", "R15", 1)
	PlayAnim(GangnamStyle, "rbxassetid://129764254213842", .1, 0.9, "PriorLow", true)
	local CartoonDance = Instance.new("TextButton")
	CreateAnimButton(CartoonDance, "CartoonDance", "Cartoon Dance", "R15", 1)
	PlayAnim(CartoonDance, "rbxassetid://123516934346404", .1, 0.8, "PriorLow", true)
	local RussianKick = Instance.new("TextButton")
	CreateAnimButton(RussianKick, "RussianKick", "Russian Kick", "R15", 1)
	PlayAnim(RussianKick, "rbxassetid://70653974473742", .1, 1, "PriorLow", true)
	local MannrobicsDance = Instance.new("TextButton")
	CreateAnimButton(MannrobicsDance, "MannrobicsDance", "Mannrobics Dance", "R15", 1)
	PlayAnim(MannrobicsDance, "rbxassetid://73932117454031", .1, 1, "PriorLow", true)
	local PennywiseDance = Instance.new("TextButton")
	CreateAnimButton(PennywiseDance, "PennywiseDance", "Pennywise Dance", "R15", 1)
	PlayAnim(PennywiseDance, "rbxassetid://138755180984581", .1, 1, "PriorLow", true)
	local BreakDance = Instance.new("TextButton")
	CreateAnimButton(BreakDance, "BreakDance", "Break Dance", "R15", 1)
	PlayAnim(BreakDance, "rbxassetid://10214311282", .1, 1, "PriorLow", true)
	local Rambunctious = Instance.new("TextButton")
	CreateAnimButton(Rambunctious, "Rambunctious", "Rambunctious", "R15", 1)
	PlayAnim(Rambunctious, "rbxassetid://129991743366120", .1, 1, "PriorLow", true)
	local NightmailDance = Instance.new("TextButton")
	CreateAnimButton(NightmailDance, "NightmailDance", "Nightmail Dance", "R15", 1)
	PlayAnim(NightmailDance, "rbxassetid://103655955630769", .1, 1, "PriorLow", true)
	local TennaArmDance = Instance.new("TextButton")
	CreateAnimButton(TennaArmDance, "TennaArmDance", "Tenna Arm Dance", "R15", 1)
	PlayAnim(TennaArmDance, "rbxassetid://140315159513795", .1, 1.1, "PriorLow", true)
	local TennaSwingDance = Instance.new("TextButton")
	CreateAnimButton(TennaSwingDance, "TennaSwingDance", "Tenna Swing Dance", "R15", 1)
	PlayAnim(TennaSwingDance, "rbxassetid://77984841414450", .1, 1, "PriorLow", true)
	local TakeTheL = Instance.new("TextButton")
	CreateAnimButton(TakeTheL, "TakeTheL", "Take The L", "R15", 1)
	PlayAnim(TakeTheL, "rbxassetid://106769842240175", .1, 1, "PriorLow", true)
	local AwkwardWave = Instance.new("TextButton")
	CreateAnimButton(AwkwardWave, "AwkwardWave", "Awkward Wave", "R15", 2)
	PlayAnim(AwkwardWave, "rbxassetid://86074172929360", .1, 1, "PriorLow", true)
	local FingerGun = Instance.new("TextButton")
	CreateAnimButton(FingerGun, "FingerGun", "Finger-Gun", "R15", 2)
	PlayAnim(FingerGun, "rbxassetid://73468073017890", .1, 1, "PriorLow", false)
	local PushUp = Instance.new("TextButton")
	CreateAnimButton(PushUp, "PushUp", "Push Ups", "R15", 2)
	PlayAnim(PushUp, "rbxassetid://80326183054599", .1, 1, "PriorLow", true)
	local Bodybuilder = Instance.new("TextButton")
	CreateAnimButton(Bodybuilder, "Bodybuilder", "Bodybuilder", "R15", 2)
	PlayAnim(Bodybuilder, "rbxassetid://10713990381", .1, 1, "PriorLow", true)
	local Laugh = Instance.new("TextButton")
	CreateAnimButton(Laugh, "Laugh", "Laugh", "R15", 2)
	PlayAnim(Laugh, "rbxassetid://507770818", .1, 1, "PriorLow", false)
	local BigLaugh = Instance.new("TextButton")
	CreateAnimButton(BigLaugh, "BigLaugh", "Big Laugh", "R15", 2)
	PlayAnim(BigLaugh, "rbxassetid://98974619620224", .1, 1, "PriorLow", true)
	local Bored = Instance.new("TextButton")
	CreateAnimButton(Bored, "Bored", "Bored", "R15", 2)
	PlayAnim(Bored, "rbxassetid://10713992055", .1, 1, "PriorLow", true)
	local Applaud = Instance.new("TextButton")
	CreateAnimButton(Applaud, "Applaud", "Applaud", "R15", 2)
	PlayAnim(Applaud, "rbxassetid://10713966026", .1, 1, "PriorLow", true)
	local FakeDeadRagdoll = Instance.new("TextButton")
	CreateAnimButton(FakeDeadRagdoll, "FakeDeadRagdoll", "Fake DeadRagdoll", "R15", 2)
	PlayAnim(FakeDeadRagdoll, "rbxassetid://80098083655931", .1, 1, "PriorLow", true)
	local FakeDeath = Instance.new("TextButton")
	CreateAnimButton(FakeDeath, "FakeDeath", "FakeDeath", "R15", 2)
	PlayAnim(FakeDeath, "rbxassetid://88130117312312", .1, 1, "PriorLowPause", true)
	local Wave = Instance.new("TextButton")
	CreateAnimButton(Wave, "Wave", "Wave", "R15", 2)
	PlayAnim(Wave, "rbxassetid://507770239", .1, 1, "PriorLow", false)
	local Point = Instance.new("TextButton")
	CreateAnimButton(Point, "Point", "Point", "R15", 2)
	PlayAnim(Point, "rbxassetid://10714395441", .1, 1, "PriorLow", false)
	local Cheer = Instance.new("TextButton")
	CreateAnimButton(Cheer, "Cheer", "Cheer", "R15", 2)
	PlayAnim(Cheer, "rbxassetid://507770677", .1, 1, "PriorLow", false)
	local Salute = Instance.new("TextButton")
	CreateAnimButton(Salute, "Salute", "Salute", "R15", 2)
	PlayAnim(Salute, "rbxassetid://10714389988", .1, 1, "PriorLow", false)
	local Shrug = Instance.new("TextButton")
	CreateAnimButton(Shrug, "Shrug", "Shrug", "R15", 2)
	PlayAnim(Shrug, "rbxassetid://10714374484", .1, 1, "PriorLow", false)
	local Tank = Instance.new("TextButton")
	CreateAnimButton(Tank, "Tank", "Tank", "R15", 3)
	PlayAnim(Tank, "rbxassetid://115951523870527", .5, 1, "PriorLow", true)
	local RaceCar = Instance.new("TextButton")
	CreateAnimButton(RaceCar, "RaceCar", "Race Car", "R15", 3)
	PlayAnim(RaceCar, "rbxassetid://72382226286301", .5, 1, "PriorLow", true)
	local Helicopter = Instance.new("TextButton")
	CreateAnimButton(Helicopter, "Helicopter", "Helicopter", "R15", 3)
	PlayAnim(Helicopter, "rbxassetid://76510079095692", .5, 1, "PriorLow", true)
	local Plane = Instance.new("TextButton")
	CreateAnimButton(Plane, "Plane", "Plane", "R15", 3)
	PlayAnim(Plane, "rbxassetid://94462256787399", .5, 0.5, "PriorLow", true)
	local CarDriving = Instance.new("TextButton")
	CreateAnimButton(CarDriving, "CarDriving", "Car Driving", "R15", 3)
	PlayAnim(CarDriving, "rbxassetid://132471972345518", .5, 0.5, "PriorLow", true)
	local ChibiWalk = Instance.new("TextButton")
	CreateAnimButton(ChibiWalk, "ChibiWalk", "Chibi Walk", "R15", 3)
	PlayAnim(ChibiWalk, "rbxassetid://85887415033585", .1, 1.7, "PriorLow", true)
	local MedusaWalk = Instance.new("TextButton")
	CreateAnimButton(MedusaWalk, "MedusaWalk", "Medusa Walk", "R15", 3)
	PlayAnim(MedusaWalk, "rbxassetid://131663132818596", .1, 1.5, "PriorLow", true)
	local TallCreatureWalk = Instance.new("TextButton")
	CreateAnimButton(TallCreatureWalk, "TallCreatureWalk", "Tall Creature Walk", "R15", 3)
	PlayAnim(TallCreatureWalk, "rbxassetid://134010853417610", .1, 1.5, "PriorLow", true)
	local Crawl = Instance.new("TextButton")
	CreateAnimButton(Crawl, "Crawl", "Crawl", "R15", 3)
	PlayAnim(Crawl, "rbxassetid://106501741606953", .1, 1, "PriorLow", true)
	local ShadowRun = Instance.new("TextButton")
	CreateAnimButton(ShadowRun, "ShadowRun", "Shadow Running", "R15", 3)
	PlayAnim(ShadowRun, "rbxassetid://82598234841035", .1, 0.8, "PriorLow", true)
	local AdidasRun = Instance.new("TextButton")
	CreateAnimButton(AdidasRun, "AdidasRun", "Adidas Running", "R15", 3)
	PlayAnim(AdidasRun, "rbxassetid://18537384940", .1, 1, "PriorLow", true)
	local JumpingSpider = Instance.new("TextButton")
	CreateAnimButton(JumpingSpider, "JumpingSpider", "Jumping Spider", "R15", 4)
	PlayAnim(JumpingSpider, "rbxassetid://139310328821985", .1, 1, "PriorLow", true)
	local InsaneDog = Instance.new("TextButton")
	CreateAnimButton(InsaneDog, "InsaneDog", "Insane Dog", "R15", 4)
	PlayAnim(InsaneDog, "rbxassetid://96435804447949", .1, 1, "PriorLow", true)
	local WormAnim = Instance.new("TextButton")
	CreateAnimButton(WormAnim, "WormAnim", "Worm Fly", "R15", 4)
	PlayAnim(WormAnim, "rbxassetid://135990691658209", .3, 1, "PriorLow", true)
	local Orbit = Instance.new("TextButton")
	CreateAnimButton(Orbit, "Orbit", "Orbit", "R15", 4)
	PlayAnim(Orbit, "rbxassetid://108359356964182", .5, 1, "PriorLow", true)
	local Hanging = Instance.new("TextButton")
	CreateAnimButton(Hanging, "Hanging", "Hanging", "R15", 4)
	PlayAnim(Hanging, "rbxassetid://125662782523118", .1, 1, "PriorLow", true)
	local LaggyWalkTroll = Instance.new("TextButton")
	CreateAnimButton(LaggyWalkTroll, "LaggyWalkTroll", "Laggy Walk Troll", "R15", 4)
	PlayAnim(LaggyWalkTroll, "rbxassetid://119199812452698", .1, 1, "PriorLow", true)
	local InchWorm = Instance.new("TextButton")
	CreateAnimButton(InchWorm, "InchWorm", "Inch Worm", "R15", 4)
	PlayAnim(InchWorm, "rbxassetid://119096405600200", .1, 1, "PriorLow", true)
	local GoofyWiggle = Instance.new("TextButton")
	CreateAnimButton(GoofyWiggle, "GoofyWiggle", "Goofy Wiggle", "R15", 4)
	PlayAnim(GoofyWiggle, "rbxassetid://74917195706355", .1, 1, "PriorLow", true)
	local Tornado = Instance.new("TextButton")
	CreateAnimButton(Tornado, "Tornado", "Tornado", "R15", 4)
	PlayAnim(Tornado, "rbxassetid://135373056067761", .1, 1, "PriorLow", true)
	local AdminFly = Instance.new("TextButton")
	CreateAnimButton(AdminFly, "AdminFly", "Admin Fly", "R15", 4)
	PlayAnim(AdminFly, "rbxassetid://85063861261432", .1, 1, "PriorLow", true)
	local ObbyHead = Instance.new("TextButton")
	CreateAnimButton(ObbyHead, "ObbyHead", "Little Obbyist", "R15", 4)
	PlayAnim(ObbyHead, "rbxassetid://115569573258316", .1, 1, "PriorLow", true)
	local Insane = Instance.new("TextButton")
	CreateAnimButton(Insane, "Insane", "Insane", "R15", 4)
	PlayAnim(Insane, "rbxassetid://93087898023268", .1, 1, "PriorLow", true)
	local GoofyFLY = Instance.new("TextButton")
	CreateAnimButton(GoofyFLY, "GoofyFLY", "Goofy FLY", "R15", 4)
	PlayAnim(GoofyFLY, "rbxassetid://118417760427139", .1, 1, "PriorLow", true)
	local BodyPhone = Instance.new("TextButton")
	CreateAnimButton(BodyPhone, "BodyPhone", "Body Phone", "R15", 4)
	PlayAnim(BodyPhone, "rbxassetid://73390669780316", .1, 0.8, "PriorLow", false)
	local Spin = Instance.new("TextButton")
	CreateAnimButton(Spin, "Spin", "Spin", "R15", 4)
	PlayAnim(Spin, "rbxassetid://110792133024438", .1, 1, "PriorLow", true)
	local SpinAround = Instance.new("TextButton")
	CreateAnimButton(SpinAround, "SpinAround", "SpinAround", "R15", 4)
	PlayAnim(SpinAround, "rbxassetid://91004858616595", .1, 1, "PriorLow", true)
	local FloatingSpace = Instance.new("TextButton")
	CreateAnimButton(FloatingSpace, "FloatingSpace", "Floating Space", "R15", 4)
	PlayAnim(FloatingSpace, "rbxassetid://71209604118044", .1, 1, "PriorLow", true)
	local FloatingSpace2 = Instance.new("TextButton")
	CreateAnimButton(FloatingSpace2, "FloatingSpace2", "Floating Space 2", "R15", 4)
	PlayAnim(FloatingSpace2, "rbxassetid://70394064781064", .1, 1, "PriorLow", true)
	local FloatingHeadSitting = Instance.new("TextButton")
	CreateAnimButton(FloatingHeadSitting, "FloatingHeadSitting", "Floating Head Sit", "R15", 5)
	PlayAnim(FloatingHeadSitting, "rbxassetid://111681053387222", .3, 1, "PriorLow", true)
	local VibeIdle = Instance.new("TextButton")
	CreateAnimButton(VibeIdle, "VibeIdle", "Vibe Idle", "R15", 5)
	PlayAnim(VibeIdle, "rbxassetid://99638411514722", .1, 1, "PriorLow", true)
	local FloatChillSit = Instance.new("TextButton")
	CreateAnimButton(FloatChillSit, "FloatChillSit", "Float Chill Sit", "R15", 5)
	PlayAnim(FloatChillSit, "rbxassetid://97361223864206", .1, 0.5, "PriorLow", true)
	local FloatIdle = Instance.new("TextButton")
	CreateAnimButton(FloatIdle, "FloatIdle", "Float Idle", "R15", 5)
	PlayAnim(FloatIdle, "rbxassetid://94942486115057", .1, 1, "PriorLow", true)
	local TPose = Instance.new("TextButton")
	CreateAnimButton(TPose, "TPose", "T Pose", "R15", 5)
	PlayAnim(TPose, "rbxassetid://121655148084031", .1, 1, "PriorLow", true)
	local CrouchR15 = Instance.new("TextButton")
	CreateAnimButton(CrouchR15, "CrouchR15", "Crouch", "R15", 5)
	PlayAnim(CrouchR15, "rbxassetid://97517127273301", .3, 1, "PriorLow", true)
	local Crawl = Instance.new("TextButton")
	CreateAnimButton(Crawl, "Crawl", "Crawl", "R15", 5)
	PlayAnim(Crawl, "rbxassetid://106501741606953", .3, 1, "PriorLow", true)
	local Sitting = Instance.new("TextButton")
	CreateAnimButton(Sitting, "Sitting", "Sitting", "R15", 5)
	PlayAnim(Sitting, "rbxassetid://94763556845023", .1, 1, "PriorLow", true)
	local MM2Sit = Instance.new("TextButton")
	CreateAnimButton(MM2Sit, "MM2Sit", "MM2 Sit", "R15", 5)
	PlayAnim(MM2Sit, "rbxassetid://130577643309726", .1, 1, "PriorLow", true)
	local Box = Instance.new("TextButton")
	CreateAnimButton(Box, "Box", "Box", "R15", 5)
	PlayAnim(Box, "rbxassetid://73753845465382", .1, 1, "PriorLow", true)
	local Sleeping = Instance.new("TextButton")
	CreateAnimButton(Sleeping, "Sleeping", "Sleeping", "R15", 5)
	PlayAnim(Sleeping, "rbxassetid://121641415206650", .5, 1, "PriorLow", true)
	local HeadJuggle = Instance.new("TextButton")
	CreateAnimButton(HeadJuggle, "HeadJuggle", "Head Juggle", "R15", 5)
	PlayAnim(HeadJuggle, "rbxassetid://136767849845319", .1, 1, "PriorLow", true)
	local FloatingOnClouds = Instance.new("TextButton")
	CreateAnimButton(FloatingOnClouds, "FloatingOnClouds", "Floating On Clouds", "R15", 5)
	PlayAnim(FloatingOnClouds, "rbxassetid://77840765435893", .1, 1, "PriorLow", true)
	local SitAnim = Instance.new("TextButton")
	CreateAnimButton(SitAnim, "SitAnim", "Sit Anim", "R15", 5)
	PlayAnim(SitAnim, "rbxassetid://507768133", .1, 1, "PriorLow", true)
	local ToolHandle = Instance.new("TextButton")
	CreateAnimButton(ToolHandle, "ToolHandle", "Tool Handle", "R15", 5)
	PlayAnim(ToolHandle, "rbxassetid://507768375", .1, 1, "PriorHigh", true)
	local FightingIdle = Instance.new("TextButton")
	CreateAnimButton(FightingIdle, "FightingIdle", "Fighting Idle", "R15", 5)
	PlayAnim(FightingIdle, "rbxassetid://105947156749343", .1, 1, "PriorLow", true)
	local DaHoodStomp = Instance.new("TextButton")
	CreateAnimButton(DaHoodStomp, "DaHoodStomp", "DaHood Stomp", "R15", 6)
	PlayAnim(DaHoodStomp, "rbxassetid://92249489340640", .1, 1, "PriorLow", false)
	local QuadPunch = Instance.new("TextButton")
	CreateAnimButton(QuadPunch, "QuadPunch", "Quad Punch", "R15", 6)
	PlayAnim(QuadPunch, "rbxassetid://139643944264511", .1, 1, "PriorLow", false)
	local TennaKick = Instance.new("TextButton")
	CreateAnimButton(TennaKick, "TennaKick", "TennaKick", "R15", 6)
	PlayAnim(TennaKick, "rbxassetid://118139885865308", .1, 1, "PriorLow", false)
	local Dropkick = Instance.new("TextButton")
	CreateAnimButton(Dropkick, "Dropkick", "Dropkick", "R15", 6)
	PlayAnim(Dropkick, "rbxassetid://133566007754001", .1, 1, "PriorLow", false)

	-- UICorners and UIStrokes

	local UiCornerParts = {"GuiTopFrame", "CloseGUI", "DestroyGUI", "GuiBottomFrame", "SpeedValue", "SideFrame", "OpenGUI"}
	local UiStrokeParts = {"GuiTopFrame", "GuiBottomFrame", "SpeedValue", "SideFrame", "ScrollingFrame", "ScrollingFrameR15"}

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
			if UiPart.Name == "SpeedValue" then
				UIStroke.Thickness = 1
			end
		end

		if (UiPart.Parent.Name == "ScrollingFrame" or UiPart.Parent.Name == "ScrollingFrameR15") and UiPart:IsA("TextButton") then
			local UICorner = Instance.new("UICorner")
			UICorner.Parent = UiPart
			UICorner.CornerRadius = UDim.new(0, 3)
			local UIStroke = Instance.new("UIStroke")
			UIStroke.Parent = UiPart
			UIStroke.Thickness = 1
			UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

		end
	end

	--[[ Script to stop all animations from default Animate Script cuz why not
	
		if NameACTIVE then
			
			local nameList = {"Animation1", "Animation2", "Animation3", "ClimbAnim", "FallAnim", "JumpAnim", "RunAnim", "SitAnim", "ToolNoneAnim", "WalkAnim", "CheerAnim", "LaughAnim", "PointAnim", "Swim", "SwimIdle", "ToolLungeAnim", "ToolSlashAnim", "WaveAnim"}
			local playingTracks = Player.Character.Humanoid:GetPlayingAnimationTracks()
			Player.Character.Animate.Disabled = true
			
			for _, animtrack in ipairs(playingTracks) do
				if table.find(nameList, animtrack.Name) then
					animtrack:Stop()
				end
			end
			
		else

			Player.Character.Animate.Disabled = false

		end
	end)
	
	]]

	GuiEmoter = Emoter

end

-- PLEASE DO NOT DELETE THIS
CreateGui()
game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Hello!", Text = "Thank you for using Emote GUI by illremember and Fixel!", Duration = 5, Icon = "rbxassetid://95707366110827"})
-- PLEASE DO NOT DELETE THIS

Player.CharacterAdded:connect(function()
	if GuiActive then
		GuiEmoter:Destroy()
		CreateGui()	
	end
end)
