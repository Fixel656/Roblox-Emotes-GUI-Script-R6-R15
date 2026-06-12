--V1
--Original by illremember, edited by Fixel656
--DO NOT COPY AND CLAIM AS OWN, if you are using some of the script for your own, 
--credit (especially of original author) is highly appreciated!

local GuiActive = true
local GuiEmoter = nil

local function CreateGui()

	local Emoter = Instance.new("ScreenGui") -- The actual GUI
	local SideFrame = Instance.new("Frame") -- Visible when GUI is closed
	local OpenGUI = Instance.new("ImageButton") -- Part of SideFrame
	local SideFrameTitle = Instance.new("TextLabel") -- Part of SideFrame
	local MainFrame = Instance.new("Frame") -- All of the stuff on the main frame

	local SpeedFrame = Instance.new("Frame") -- Frame of Speed Changer
	local SFLayout = Instance.new("UIGridLayout")

	local ScrollingFrame = Instance.new("ScrollingFrame") -- The scrolling frame of animations
	local CheckR = Instance.new("TextLabel") -- Check if R15 or R6, currently invisible
	local ScrollingFrameR15 = Instance.new("ScrollingFrame") -- The scrolling frame of R15 animations
	
	local GuiTopFrame = Instance.new("Frame") -- Top of the main frame
	local DestroyGUI = Instance.new("TextButton") -- To Destroy the GUI
	local SFDestroyGUI = Instance.new("TextButton") -- To Destroy the GUI in SideFrame
	local CloseGUI = Instance.new("ImageButton") -- To close the GUI
	local Title = Instance.new("TextLabel") -- Actual title of GUI, Emoter

	local SpeedNum --Value, adding to default speed of animation

	local CrazySlash = Instance.new("TextButton")--COMPLETE
	local Open = Instance.new("TextButton")--COMPLETE
	local R15Spinner = Instance.new("TextButton")--COMPLETE
	local ArmsOut = Instance.new("TextButton")--COMPLETE
	local FloatSlash = Instance.new("TextButton")--COMPLETE
	local WeirdZombie = Instance.new("TextButton")--COMPLETE
	local DownSlash = Instance.new("TextButton")--COMPLETE
	local Pull = Instance.new("TextButton")--COMPLETE
	local CircleArm = Instance.new("TextButton")--COMPLETE
	local Bend = Instance.new("TextButton")--COMPLETE
	local RotateSlash = Instance.new("TextButton")--COMPLETE
	local FlingArms = Instance.new("TextButton")--COMPLETE

	local FullSwing = Instance.new("TextButton")--COMPLETE
	local GlitchLevitate = Instance.new("TextButton")--COMPLETE
	local MoonDance = Instance.new("TextButton")--COMPLETE
	local FullPunch = Instance.new("TextButton")--COMPLETE
	local Crouch = Instance.new("TextButton")--COMPLETE
	local SpinDance = Instance.new("TextButton")--COMPLETE
	local SwordSpin = Instance.new("TextButton")--COMPLETE
	local JumpingJacks = Instance.new("TextButton")--COMPLETE
	local Spinner = Instance.new("TextButton")--COMPLETE
	local MegaInsane = Instance.new("TextButton")--COMPLETE
	local Punches = Instance.new("TextButton")--COMPLETE
	local WeirdMove = Instance.new("TextButton")--COMPLETE
	local Faint = Instance.new("TextButton")--COMPLETE
	local CloneIllusion = Instance.new("TextButton")--COMPLETE
	local Levitate = Instance.new("TextButton")--COMPLETE
	local DinoWalk = Instance.new("TextButton")--COMPLETE
	local FloorCrawl = Instance.new("TextButton")--COMPLETE
	local SwordSlam = Instance.new("TextButton")--COMPLETE
	local Scared = Instance.new("TextButton")--COMPLETE
	local HeroJump = Instance.new("TextButton")--COMPLETE
	local Insane = Instance.new("TextButton")--COMPLETE
	local FloatingHead = Instance.new("TextButton")--COMPLETE
	local HeadThrow = Instance.new("TextButton")--COMPLETE
	local Bang = Instance.new("TextButton")--COMPLETE
	local MovingDance = Instance.new("TextButton")--COMPLETE
	local SuperPunch = Instance.new("TextButton")--COMPLETE
	local ArmTurbine = Instance.new("TextButton")--COMPLETE
	local Dab = Instance.new("TextButton")--COMPLETE
	local FloatSit = Instance.new("TextButton")--COMPLETE
	local BarrelRoll = Instance.new("TextButton")--COMPLETE
	local WallHack = Instance.new("TextButton")--COMPLETE
	
	BgColor = Color3.new(0.541176, 0.647059, 1)
	col = BgColor -- R6 Button Color
	loc = Color3.new(0.427451, 0.490196, 0.792157) -- R6 Button darker color (idk how to make it just darker BgColor yet)
	rcol = Color3.new(0.682353, 0.701961, 0.792157) --R15 Button color
	rloc = Color3.new(0.882353, 0.901961, 0.992157) -- R15 Button darker color
	
	-- Properties

	Emoter.Name = "Emoter"
	Emoter.Parent = game.Players.LocalPlayer.PlayerGui

	SideFrame.Name = "SideFrame"
	SideFrame.Parent = Emoter
	SideFrame.Active = true
	SideFrame.BackgroundColor3 = BgColor
	SideFrame.Position = UDim2.new(0, 10, 0, 10)
	SideFrame.Size = UDim2.new(0, 225, 0, 32)
	SideFrame.Visible = false

	OpenGUI.Name = "OpenGUI"
	OpenGUI.Parent = SideFrame
	OpenGUI.AnchorPoint = Vector2.new(0, 0.5)
	OpenGUI.BackgroundTransparency = 0
	OpenGUI.BackgroundColor3 = BgColor
	OpenGUI.Position = UDim2.new(0, 0, 0.5, 0)
	OpenGUI.Size = UDim2.new(0, 32, 0, 32)
	OpenGUI.Image = "rbxassetid://129394195458921"
	
	SideFrameTitle.Name = "SideFrameTitle"
	SideFrameTitle.Parent = SideFrame
	SideFrameTitle.AnchorPoint = Vector2.new(0.5, 0.5)
	SideFrameTitle.BackgroundColor3 = Color3.new(1, 1, 1)
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

	MainFrame.Name = "MainFrame"
	MainFrame.Parent = Emoter
	MainFrame.Active = true
	MainFrame.BackgroundColor3 = BgColor
	MainFrame.BackgroundTransparency = 1
	MainFrame.Position = UDim2.new(0, 10, 0, 10)
	MainFrame.Size = UDim2.new(0, 460, 0, 250)

	local UIDragDetectorMainFrame = Instance.new("UIDragDetector")
	UIDragDetectorMainFrame.Parent = MainFrame

	local UIDragDetectorSideFrame = Instance.new("UIDragDetector")
	UIDragDetectorSideFrame.Parent = SideFrame

	SpeedFrame.Name = "SpeedFrame"
	SpeedFrame.Parent = MainFrame
	SpeedFrame.Active = true
	SpeedFrame.Position = UDim2.new(0, 0, 1, 1)
	SpeedFrame.Size = UDim2.new(0, 460, 0, 35)
	SpeedFrame.BackgroundColor3 = BgColor

	--SpeedFrame Parts
	SFLayout.Name = "UIGridLayout"
	SFLayout.Parent = SpeedFrame
	SFLayout.FillDirection = Enum.FillDirection.Vertical
	SFLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SFLayout.CellSize = UDim2.new(0, 110, 0, 31)
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

	local CurSpeedText = Instance.new("TextLabel")
	CurSpeedText.Name = "CurSpeedText"
	CurSpeedText.Parent = MainFrame
	CurSpeedText.AnchorPoint = Vector2.new(1, 0)
	CurSpeedText.Size = UDim2.new(0, 200, 0, 35)
	CurSpeedText.Position = UDim2.new(1, 0, 1, 0)
	CurSpeedText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CurSpeedText.BackgroundTransparency = 1
	CurSpeedText.BorderSizePixel = 0
	CurSpeedText.BackgroundColor3 = Color3.fromRGB(226, 198, 93)
	CurSpeedText.TextStrokeTransparency = 0
	CurSpeedText.TextSize = 14
	CurSpeedText.TextColor3 = Color3.fromRGB(255, 255, 255)
	CurSpeedText.Text = "CurrentSpeed: "
	CurSpeedText.Font = Enum.Font.SourceSans
	CurSpeedText.TextScaled = true

	SpeedValue.Changed:Connect(function()
		SpeedNum = SpeedValue.Text
		if SpeedValue.Text == "" then
			SpeedNum = 0
		end
	end)
	
	--Scrolling Frames

	ScrollingFrame.Parent = MainFrame
	ScrollingFrame.BackgroundColor3 = Color3.new(0.862745, 0.960784, 1)
	ScrollingFrame.Position = UDim2.new(0, 0, 0, 34)
	ScrollingFrame.ScrollBarImageColor3 = Color3.new(0, 0, 0)
	ScrollingFrame.Size = UDim2.new(0, 460, 0, 215)
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 1.5, 0)
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
	ScrollingFrameR15.BackgroundColor3 = Color3.new(1, 0.564706, 0.564706)
	ScrollingFrameR15.Position = UDim2.new(0, 0, 0, 32)
	ScrollingFrameR15.ScrollBarImageColor3 = Color3.new(0, 0, 0)
	ScrollingFrameR15.Size = UDim2.new(0, 460, 0, 215)
	ScrollingFrameR15.CanvasSize = UDim2.new(0, 0, 1.5, 0)
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
	
	CloseGUI.Name = "CloseGUI"
	CloseGUI.Parent = GuiTopFrame
	CloseGUI.AnchorPoint = Vector2.new(0, 0.5)
	CloseGUI.BackgroundColor3 = BgColor
	CloseGUI.BackgroundTransparency = 0
	CloseGUI.Position = UDim2.new(0, 0, 0.5, 0)
	CloseGUI.Size = UDim2.new(0, 32, 0, 32)
	CloseGUI.Image = "rbxassetid://118017289302281"
	
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

	CheckR.Name = "CheckR"
	CheckR.Parent = GuiTopFrame
	CheckR.Visible = false
	CheckR.BackgroundColor3 = Color3.new(1, 1, 1)
	CheckR.BackgroundTransparency = 1
	CheckR.Size = UDim2.new(0, 171, 0, 32)
	CheckR.Font = Enum.Font.SourceSansBold
	CheckR.FontSize = Enum.FontSize.Size14
	CheckR.Text = "Text"
	CheckR.TextScaled = true
	CheckR.TextSize = 14
	CheckR.TextWrapped = true
	
	local function CreateAnimButton(Name, Text, ID)
		
	end
	
	-- R6 Emotes

	FullSwing.Name = "FullSwing"
	FullSwing.Parent = ScrollingFrame
	FullSwing.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	FullSwing.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	FullSwing.Position = UDim2.new(0, 17, 0, 322)
	FullSwing.Size = UDim2.new(0, 119, 0, 34)
	FullSwing.Font = Enum.Font.Highway
	FullSwing.FontSize = Enum.FontSize.Size24
	FullSwing.Text = "Full Swing"
	FullSwing.TextScaled = true

	GlitchLevitate.Name = "GlitchLevitate"
	GlitchLevitate.Parent = ScrollingFrame
	GlitchLevitate.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	GlitchLevitate.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	GlitchLevitate.Position = UDim2.new(0, 319, 0, 322)
	GlitchLevitate.Size = UDim2.new(0, 119, 0, 34)
	GlitchLevitate.Font = Enum.Font.Highway
	GlitchLevitate.FontSize = Enum.FontSize.Size24
	GlitchLevitate.Text = "Nunchak Slash"
	GlitchLevitate.TextScaled = true

	MoonDance.Name = "MoonDance"
	MoonDance.Parent = ScrollingFrame
	MoonDance.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	MoonDance.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	MoonDance.Position = UDim2.new(0, 319, 0, 280)
	MoonDance.Size = UDim2.new(0, 119, 0, 34)
	MoonDance.Font = Enum.Font.Highway
	MoonDance.FontSize = Enum.FontSize.Size24
	MoonDance.Text = "Moon Dance"
	MoonDance.TextScaled = true

	FullPunch.Name = "FullPunch"
	FullPunch.Parent = ScrollingFrame
	FullPunch.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	FullPunch.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	FullPunch.Position = UDim2.new(0, 17, 0, 280)
	FullPunch.Size = UDim2.new(0, 119, 0, 34)
	FullPunch.Font = Enum.Font.Highway
	FullPunch.FontSize = Enum.FontSize.Size24
	FullPunch.Text = "Full Punch"
	FullPunch.TextScaled = true

	Crouch.Name = "Crouch"
	Crouch.Parent = ScrollingFrame
	Crouch.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	Crouch.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	Crouch.Position = UDim2.new(0, 168, 0, 280)
	Crouch.Size = UDim2.new(0, 119, 0, 34)
	Crouch.Font = Enum.Font.Highway
	Crouch.FontSize = Enum.FontSize.Size24
	Crouch.Text = "Crouch"
	Crouch.TextScaled = true

	SpinDance.Name = "SpinDance"
	SpinDance.Parent = ScrollingFrame
	SpinDance.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	SpinDance.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	SpinDance.Position = UDim2.new(0, 168, 0, 236)
	SpinDance.Size = UDim2.new(0, 119, 0, 34)
	SpinDance.Font = Enum.Font.Highway
	SpinDance.FontSize = Enum.FontSize.Size24
	SpinDance.Text = "Spin Dance"
	SpinDance.TextScaled = true

	SwordSpin.Name = "SwordSpin"
	SwordSpin.Parent = ScrollingFrame
	SwordSpin.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	SwordSpin.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	SwordSpin.Position = UDim2.new(0, 17, 0, 236)
	SwordSpin.Size = UDim2.new(0, 119, 0, 34)
	SwordSpin.Font = Enum.Font.Highway
	SwordSpin.FontSize = Enum.FontSize.Size24
	SwordSpin.Text = "Sword Spin"
	SwordSpin.TextScaled = true

	JumpingJacks.Name = "JumpingJacks"
	JumpingJacks.Parent = ScrollingFrame
	JumpingJacks.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	JumpingJacks.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	JumpingJacks.Position = UDim2.new(0, 319, 0, 236)
	JumpingJacks.Size = UDim2.new(0, 119, 0, 34)
	JumpingJacks.Font = Enum.Font.Highway
	JumpingJacks.FontSize = Enum.FontSize.Size24
	JumpingJacks.Text = "Jumping Jacks"
	JumpingJacks.TextScaled = true

	Spinner.Name = "Spinner"
	Spinner.Parent = ScrollingFrame
	Spinner.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	Spinner.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	Spinner.Position = UDim2.new(0, 17, 0, 192)
	Spinner.Size = UDim2.new(0, 119, 0, 34)
	Spinner.Font = Enum.Font.Highway
	Spinner.FontSize = Enum.FontSize.Size24
	Spinner.Text = "Spinner"
	Spinner.TextScaled = true

	MegaInsane.Name = "MegaInsane"
	MegaInsane.Parent = ScrollingFrame
	MegaInsane.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	MegaInsane.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	MegaInsane.Position = UDim2.new(0, 168, 0, 192)
	MegaInsane.Size = UDim2.new(0, 119, 0, 34)
	MegaInsane.Font = Enum.Font.Highway
	MegaInsane.FontSize = Enum.FontSize.Size24
	MegaInsane.Text = "Mega Insane"
	MegaInsane.TextScaled = true

	Punches.Name = "Punches"
	Punches.Parent = ScrollingFrame
	Punches.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	Punches.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	Punches.Position = UDim2.new(0, 319, 0, 192)
	Punches.Size = UDim2.new(0, 119, 0, 34)
	Punches.Font = Enum.Font.Highway
	Punches.FontSize = Enum.FontSize.Size24
	Punches.Text = "Punches"
	Punches.TextScaled = true

	WeirdMove.Name = "WeirdMove"
	WeirdMove.Parent = ScrollingFrame
	WeirdMove.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	WeirdMove.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	WeirdMove.Position = UDim2.new(0, 168, 0, 148)
	WeirdMove.Size = UDim2.new(0, 119, 0, 34)
	WeirdMove.Font = Enum.Font.Highway
	WeirdMove.FontSize = Enum.FontSize.Size24
	WeirdMove.Text = "Weird Move"
	WeirdMove.TextScaled = true

	Faint.Name = "Faint"
	Faint.Parent = ScrollingFrame
	Faint.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	Faint.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	Faint.Position = UDim2.new(0, 17, 0, 148)
	Faint.Size = UDim2.new(0, 119, 0, 34)
	Faint.Font = Enum.Font.Highway
	Faint.FontSize = Enum.FontSize.Size24
	Faint.Text = "Floor Faint"
	Faint.TextScaled = true

	CloneIllusion.Name = "CloneIllusion"
	CloneIllusion.Parent = ScrollingFrame
	CloneIllusion.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	CloneIllusion.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	CloneIllusion.Position = UDim2.new(0, 319, 0, 148)
	CloneIllusion.Size = UDim2.new(0, 119, 0, 34)
	CloneIllusion.Font = Enum.Font.Highway
	CloneIllusion.FontSize = Enum.FontSize.Size24
	CloneIllusion.Text = "Clone Illusion"
	CloneIllusion.TextScaled = true

	Levitate.Name = "Levitate"
	Levitate.Parent = ScrollingFrame
	Levitate.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	Levitate.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	Levitate.Position = UDim2.new(0, 17, 0, 104)
	Levitate.Size = UDim2.new(0, 119, 0, 34)
	Levitate.Font = Enum.Font.Highway
	Levitate.FontSize = Enum.FontSize.Size24
	Levitate.Text = "Levitate"
	Levitate.TextScaled = true

	DinoWalk.Name = "DinoWalk"
	DinoWalk.Parent = ScrollingFrame
	DinoWalk.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	DinoWalk.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	DinoWalk.Position = UDim2.new(0, 168, 0, 104)
	DinoWalk.Size = UDim2.new(0, 119, 0, 34)
	DinoWalk.Font = Enum.Font.Highway
	DinoWalk.FontSize = Enum.FontSize.Size24
	DinoWalk.Text = "Dino Walk"
	DinoWalk.TextScaled = true

	FloorCrawl.Name = "FloorCrawl"
	FloorCrawl.Parent = ScrollingFrame
	FloorCrawl.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	FloorCrawl.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	FloorCrawl.Position = UDim2.new(0, 319, 0, 104)
	FloorCrawl.Size = UDim2.new(0, 119, 0, 34)
	FloorCrawl.Font = Enum.Font.Highway
	FloorCrawl.FontSize = Enum.FontSize.Size24
	FloorCrawl.Text = "Floor Crawl"
	FloorCrawl.TextScaled = true

	SwordSlam.Name = "SwordSlam"
	SwordSlam.Parent = ScrollingFrame
	SwordSlam.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	SwordSlam.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	SwordSlam.Position = UDim2.new(0, 319, 0, 60)
	SwordSlam.Size = UDim2.new(0, 119, 0, 34)
	SwordSlam.Font = Enum.Font.Highway
	SwordSlam.FontSize = Enum.FontSize.Size24
	SwordSlam.Text = "Weird body"
	SwordSlam.TextScaled = true

	Scared.Name = "Scared"
	Scared.Parent = ScrollingFrame
	Scared.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	Scared.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	Scared.Position = UDim2.new(0, 168, 0, 60)
	Scared.Size = UDim2.new(0, 119, 0, 34)
	Scared.Font = Enum.Font.Highway
	Scared.FontSize = Enum.FontSize.Size24
	Scared.Text = "Scared"
	Scared.TextScaled = true

	HeroJump.Name = "HeroJump"
	HeroJump.Parent = ScrollingFrame
	HeroJump.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	HeroJump.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	HeroJump.Position = UDim2.new(0, 17, 0, 60)
	HeroJump.Size = UDim2.new(0, 119, 0, 34)
	HeroJump.Font = Enum.Font.Highway
	HeroJump.FontSize = Enum.FontSize.Size24
	HeroJump.Text = "Hero Jump"
	HeroJump.TextScaled = true

	Insane.Name = "Insane"
	Insane.Parent = ScrollingFrame
	Insane.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	Insane.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	Insane.Position = UDim2.new(0, 319, 0, 16)
	Insane.Size = UDim2.new(0, 119, 0, 34)
	Insane.Font = Enum.Font.Highway
	Insane.FontSize = Enum.FontSize.Size24
	Insane.Text = "Insane"
	Insane.TextScaled = true

	FloatingHead.Name = "FloatingHead"
	FloatingHead.Parent = ScrollingFrame
	FloatingHead.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	FloatingHead.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	FloatingHead.Position = UDim2.new(0, 168, 0, 16)
	FloatingHead.Size = UDim2.new(0, 119, 0, 34)
	FloatingHead.Font = Enum.Font.Highway
	FloatingHead.FontSize = Enum.FontSize.Size24
	FloatingHead.Text = "Floating Head"
	FloatingHead.TextScaled = true

	HeadThrow.Name = "HeadThrow"
	HeadThrow.Parent = ScrollingFrame
	HeadThrow.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	HeadThrow.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	HeadThrow.Position = UDim2.new(0, 17, 0, 16)
	HeadThrow.Size = UDim2.new(0, 119, 0, 34)
	HeadThrow.Font = Enum.Font.Highway
	HeadThrow.FontSize = Enum.FontSize.Size24
	HeadThrow.Text = "Head Throw"
	HeadThrow.TextScaled = true
	
	Bang.Name = "Bang"
	Bang.Parent = ScrollingFrame
	Bang.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	Bang.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	Bang.Position = UDim2.new(0, 17, 0, 16)
	Bang.Size = UDim2.new(0, 119, 0, 34)
	Bang.Font = Enum.Font.Highway
	Bang.FontSize = Enum.FontSize.Size24
	Bang.Text = "Bang)"
	Bang.TextScaled = true

	MovingDance.Name = "MovingDance"
	MovingDance.Parent = ScrollingFrame
	MovingDance.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	MovingDance.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	MovingDance.Position = UDim2.new(0, 168, 0, 324)
	MovingDance.Size = UDim2.new(0, 119, 0, 34)
	MovingDance.Font = Enum.Font.Highway
	MovingDance.FontSize = Enum.FontSize.Size24
	MovingDance.Text = "Moving Dance"
	MovingDance.TextScaled = true

	SuperPunch.Name = "SuperPunch"
	SuperPunch.Parent = ScrollingFrame
	SuperPunch.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	SuperPunch.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	SuperPunch.Position = UDim2.new(0, 168, 0, 366)
	SuperPunch.Size = UDim2.new(0, 119, 0, 34)
	SuperPunch.Font = Enum.Font.Highway
	SuperPunch.FontSize = Enum.FontSize.Size24
	SuperPunch.Text = "Side slash"
	SuperPunch.TextScaled = true

	ArmTurbine.Name = "ArmTurbine"
	ArmTurbine.Parent = ScrollingFrame
	ArmTurbine.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	ArmTurbine.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	ArmTurbine.Position = UDim2.new(0, 319, 0, 366)
	ArmTurbine.Size = UDim2.new(0, 119, 0, 34)
	ArmTurbine.Font = Enum.Font.Highway
	ArmTurbine.FontSize = Enum.FontSize.Size24
	ArmTurbine.Text = "Arm Turbine"
	ArmTurbine.TextScaled = true

	Dab.Name = "Dab"
	Dab.Parent = ScrollingFrame
	Dab.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	Dab.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	Dab.Position = UDim2.new(0, 17, 0, 366)
	Dab.Size = UDim2.new(0, 119, 0, 34)
	Dab.Font = Enum.Font.Highway
	Dab.FontSize = Enum.FontSize.Size24
	Dab.Text = "Dab"
	Dab.TextScaled = true

	FloatSit.Name = "FloatSit"
	FloatSit.Parent = ScrollingFrame
	FloatSit.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	FloatSit.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	FloatSit.Position = UDim2.new(0, 168, 0, 410)
	FloatSit.Size = UDim2.new(0, 119, 0, 34)
	FloatSit.Font = Enum.Font.Highway
	FloatSit.FontSize = Enum.FontSize.Size24
	FloatSit.Text = "Float Sit"
	FloatSit.TextScaled = true

	BarrelRoll.Name = "BarrelRoll"
	BarrelRoll.Parent = ScrollingFrame
	BarrelRoll.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	BarrelRoll.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	BarrelRoll.Position = UDim2.new(0, 319, 0, 410)
	BarrelRoll.Size = UDim2.new(0, 119, 0, 34)
	BarrelRoll.Font = Enum.Font.Highway
	BarrelRoll.FontSize = Enum.FontSize.Size24
	BarrelRoll.Text = "Barrel Roll"
	BarrelRoll.TextScaled = true

	WallHack.Name = "WallHack"
	WallHack.Parent = ScrollingFrame
	WallHack.BackgroundColor3 = Color3.new(0.541176, 0.611765, 1)
	WallHack.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	WallHack.Position = UDim2.new(0, 17, 0, 410)
	WallHack.Size = UDim2.new(0, 119, 0, 34)
	WallHack.Font = Enum.Font.Highway
	WallHack.FontSize = Enum.FontSize.Size24
	WallHack.Text = "Wall hack"
	WallHack.TextScaled = true
	
	
	
	-- R15 Emotes

	CrazySlash.Name = "CrazySlash"
	CrazySlash.Parent = ScrollingFrameR15
	CrazySlash.BackgroundColor3 = Color3.new(0.682353, 0.701961, 0.792157)
	CrazySlash.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	CrazySlash.Position = UDim2.new(0, 17, 0, 16)
	CrazySlash.Size = UDim2.new(0, 119, 0, 34)
	CrazySlash.Font = Enum.Font.Highway
	CrazySlash.FontSize = Enum.FontSize.Size24
	CrazySlash.Text = "CrazySlash"
	CrazySlash.TextScaled = true

	Open.Name = "Open"
	Open.Parent = ScrollingFrameR15
	Open.BackgroundColor3 = Color3.new(0.682353, 0.701961, 0.792157)
	Open.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	Open.Position = UDim2.new(0, 168, 0, 16)
	Open.Size = UDim2.new(0, 119, 0, 34)
	Open.Font = Enum.Font.Highway
	Open.FontSize = Enum.FontSize.Size24
	Open.Text = "Open"
	Open.TextScaled = true

	R15Spinner.Name = "R15Spinner"
	R15Spinner.Parent = ScrollingFrameR15
	R15Spinner.BackgroundColor3 = Color3.new(0.682353, 0.701961, 0.792157)
	R15Spinner.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	R15Spinner.Position = UDim2.new(0, 17, 0, 60)
	R15Spinner.Size = UDim2.new(0, 119, 0, 34)
	R15Spinner.Font = Enum.Font.Highway
	R15Spinner.FontSize = Enum.FontSize.Size24
	R15Spinner.Text = "Spinner"
	R15Spinner.TextScaled = true

	ArmsOut.Name = "ArmsOut"
	ArmsOut.Parent = ScrollingFrameR15
	ArmsOut.BackgroundColor3 = Color3.new(0.682353, 0.701961, 0.792157)
	ArmsOut.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	ArmsOut.Position = UDim2.new(0, 319, 0, 16)
	ArmsOut.Size = UDim2.new(0, 119, 0, 34)
	ArmsOut.Font = Enum.Font.Highway
	ArmsOut.FontSize = Enum.FontSize.Size24
	ArmsOut.Text = "ArmsOut"
	ArmsOut.TextScaled = true

	FloatSlash.Name = "FloatSlash"
	FloatSlash.Parent = ScrollingFrameR15
	FloatSlash.BackgroundColor3 = Color3.new(0.682353, 0.701961, 0.792157)
	FloatSlash.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	FloatSlash.Position = UDim2.new(0, 168, 0, 148)
	FloatSlash.Size = UDim2.new(0, 119, 0, 34)
	FloatSlash.Font = Enum.Font.Highway
	FloatSlash.FontSize = Enum.FontSize.Size24
	FloatSlash.Text = "FloatSlash"
	FloatSlash.TextScaled = true

	WeirdZombie.Name = "WeirdZombie"
	WeirdZombie.Parent = ScrollingFrameR15
	WeirdZombie.BackgroundColor3 = Color3.new(0.682353, 0.701961, 0.792157)
	WeirdZombie.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	WeirdZombie.Position = UDim2.new(0, 17, 0, 148)
	WeirdZombie.Size = UDim2.new(0, 119, 0, 34)
	WeirdZombie.Font = Enum.Font.Highway
	WeirdZombie.FontSize = Enum.FontSize.Size24
	WeirdZombie.Text = "WeirdZombie"
	WeirdZombie.TextScaled = true

	DownSlash.Name = "DownSlash"
	DownSlash.Parent = ScrollingFrameR15
	DownSlash.BackgroundColor3 = Color3.new(0.682353, 0.701961, 0.792157)
	DownSlash.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	DownSlash.Position = UDim2.new(0, 319, 0, 148)
	DownSlash.Size = UDim2.new(0, 119, 0, 34)
	DownSlash.Font = Enum.Font.Highway
	DownSlash.FontSize = Enum.FontSize.Size24
	DownSlash.Text = "DownSlash"
	DownSlash.TextScaled = true

	Pull.Name = "Pull"
	Pull.Parent = ScrollingFrameR15
	Pull.BackgroundColor3 = Color3.new(0.682353, 0.701961, 0.792157)
	Pull.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	Pull.Position = UDim2.new(0, 17, 0, 104)
	Pull.Size = UDim2.new(0, 119, 0, 34)
	Pull.Font = Enum.Font.Highway
	Pull.FontSize = Enum.FontSize.Size24
	Pull.Text = "Pull"
	Pull.TextScaled = true

	CircleArm.Name = "CircleArm"
	CircleArm.Parent = ScrollingFrameR15
	CircleArm.BackgroundColor3 = Color3.new(0.682353, 0.701961, 0.792157)
	CircleArm.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	CircleArm.Position = UDim2.new(0, 168, 0, 104)
	CircleArm.Size = UDim2.new(0, 119, 0, 34)
	CircleArm.Font = Enum.Font.Highway
	CircleArm.FontSize = Enum.FontSize.Size24
	CircleArm.Text = "CircleArm"
	CircleArm.TextScaled = true

	Bend.Name = "Bend"
	Bend.Parent = ScrollingFrameR15
	Bend.BackgroundColor3 = Color3.new(0.682353, 0.701961, 0.792157)
	Bend.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	Bend.Position = UDim2.new(0, 319, 0, 104)
	Bend.Size = UDim2.new(0, 119, 0, 34)
	Bend.Font = Enum.Font.Highway
	Bend.FontSize = Enum.FontSize.Size24
	Bend.Text = "Bend"
	Bend.TextScaled = true

	RotateSlash.Name = "RotateSlash"
	RotateSlash.Parent = ScrollingFrameR15
	RotateSlash.BackgroundColor3 = Color3.new(0.682353, 0.701961, 0.792157)
	RotateSlash.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	RotateSlash.Position = UDim2.new(0, 319, 0, 60)
	RotateSlash.Size = UDim2.new(0, 119, 0, 34)
	RotateSlash.Font = Enum.Font.Highway
	RotateSlash.FontSize = Enum.FontSize.Size24
	RotateSlash.Text = "RotateSlash"
	RotateSlash.TextScaled = true

	FlingArms.Name = "FlingArms"
	FlingArms.Parent = ScrollingFrameR15
	FlingArms.BackgroundColor3 = Color3.new(0.682353, 0.701961, 0.792157)
	FlingArms.BorderColor3 = Color3.new(0.313726, 0.313726, 0.313726)
	FlingArms.Position = UDim2.new(0, 168, 0, 60)
	FlingArms.Size = UDim2.new(0, 119, 0, 34)
	FlingArms.Font = Enum.Font.Highway
	FlingArms.FontSize = Enum.FontSize.Size24
	FlingArms.Text = "FlingArms"
	FlingArms.TextScaled = true
	
	local UiCornerParts = {"GuiTopFrame", "CloseGUI", "DestroyGUI", "SpeedFrame", "SpeedValue", "SideFrame", "OpenGUI"}
	local UiStrokeParts = {"GuiTopFrame", "SpeedFrame", "SpeedValue", "SideFrame", "ScrollingFrame", "ScrollingFrameR15"}

	for _, UiPart in ipairs(Emoter:GetDescendants()) do
		if table.find(UiCornerParts, UiPart.Name) then
			local UICorner = Instance.new("UICorner")
			UICorner.Parent = UiPart
			UICorner.CornerRadius = UDim.new(0, 5)
			if UiPart.Name == "GuiTopFrame" then
				UICorner.BottomRightRadius = UDim.new(0, 0)
				UICorner.BottomLeftRadius = UDim.new(0, 0)
			elseif UiPart.Name == "SpeedFrame" then
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

	-- Buttons
	CloseGUI.MouseButton1Click:connect(function()
		MainFrame.Visible = false
		SideFrame.Visible = true
		SideFrame.Position = MainFrame.Position
	end)
	
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

	if (game:GetService"Players".LocalPlayer.Character:WaitForChild("Humanoid").RigType == Enum.HumanoidRigType.R15) then
		ScrollingFrame.Visible = false
		ScrollingFrameR15.Visible = true
		CheckR.Text = "R15 Animations"
		Title.Text = "Emotes GUI (R15)"
		SideFrameTitle.Text = "Emotes GUI (R15)"
	else
		ScrollingFrame.Visible = true
		ScrollingFrameR15.Visible = false
		CheckR.Text = "R6 Animations"
		Title.Text = "Emotes GUI (R6)"
		SideFrameTitle.Text = "Emotes GUI (R6)"

	end
	
	-- Playing Animations
	
	--[[ Script to stop all animations to play animations playable through /e chat command cuz without that it would look horrible
	
		if NameACTIVE then
			
			local nameList = {"Animation1", "Animation2", "ClimbAnim", "FallAnim", "JumpAnim", "RunAnim", "SitAnim", "ToolNoneAnim", "WalkAnim"}
			local playingTracks = game.Players.LocalPlayer.Character.Humanoid:GetPlayingAnimationTracks()
			game.Players.LocalPlayer.Character.Animate.Disabled = true
			
			for _, animtrack in ipairs(playingTracks) do
				if table.find(nameList, animtrack.Name) then
					animtrack:Stop()
				end
			end
			
		else

			game.Players.LocalPlayer.Character.Animate.Disabled = false

		end
	end)
	
	]]

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://148840371"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local BangACTIVE = false
	Bang.MouseButton1Click:connect(function()
		BangACTIVE = not BangACTIVE
		if BangACTIVE then
			Bang.BackgroundColor3 = loc
			while wait() do
				if track.IsPlaying == false then
					if BangACTIVE then
						track:Play(.1, 1, 3 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 3 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			Bang.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)
	
	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://35154961"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local HeadThrowACTIVE = false
	HeadThrow.MouseButton1Click:connect(function()
		HeadThrowACTIVE = not HeadThrowACTIVE
		if HeadThrowACTIVE then
			HeadThrow.BackgroundColor3 = loc
			while wait() do
				if track.IsPlaying == false then
					if HeadThrowACTIVE then
						track:Play(.1, 1, 1 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			HeadThrow.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://121572214"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local FloatingHeadACTIVE = false
	FloatingHead.MouseButton1Click:connect(function()
		FloatingHeadACTIVE = not FloatingHeadACTIVE
		if FloatingHeadACTIVE then
			track:Play(.1, 1, 1 + SpeedNum)
			FloatingHead.BackgroundColor3 = loc
			CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
		else
			track:Stop()
			FloatingHead.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://182724289"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local CrouchACTIVE = false
	Crouch.MouseButton1Click:connect(function()
		CrouchACTIVE = not CrouchACTIVE
		if CrouchACTIVE then
			track:Play(.1, 1, 1 + SpeedNum)
			Crouch.BackgroundColor3 = loc
			CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
		else
			track:Stop()
			Crouch.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://282574440"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local FloorCrawlACTIVE = false
	FloorCrawl.MouseButton1Click:connect(function()
		FloorCrawlACTIVE = not FloorCrawlACTIVE
		if FloorCrawlACTIVE then
			track:Play(.1, 1, 1 + SpeedNum)
			FloorCrawl.BackgroundColor3 = loc
			CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
		else
			track:Stop()
			FloorCrawl.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://204328711"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local DinoWalkACTIVE = false
	DinoWalk.MouseButton1Click:connect(function()
		DinoWalkACTIVE = not DinoWalkACTIVE
		if DinoWalkACTIVE then
			track:Play(.1, 1, 1 + SpeedNum)
			DinoWalk.BackgroundColor3 = loc
			CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
		else
			track:Stop()
			DinoWalk.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://429681631"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local JumpingJacksACTIVE = false
	JumpingJacks.MouseButton1Click:connect(function()
		JumpingJacksACTIVE = not JumpingJacksACTIVE
		if JumpingJacksACTIVE then
			track:Play(.1, 1, 1 + SpeedNum)
			JumpingJacks.BackgroundColor3 = loc
			CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
		else
			track:Stop()
			JumpingJacks.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://180612465"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local ScaredACTIVE = false
	Scared.MouseButton1Click:connect(function()
		ScaredACTIVE = not ScaredACTIVE
		if ScaredACTIVE then
			track:Play(.1, 1, 0.3 + SpeedNum)
			Scared.BackgroundColor3 = loc
			CurSpeedText.Text = "CurrentSpeed: ".. 0.3 + SpeedNum
			wait(1)
			track:AdjustSpeed(0)
		else
			track:Stop()
			Scared.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://184574340"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local HeroJumpACTIVE = false
	HeroJump.MouseButton1Click:connect(function()
		HeroJumpACTIVE = not JumpingJacksACTIVE
		if HeroJumpACTIVE then
			track:Play(.1, 1, 1 + SpeedNum)
			CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
		else
			track:Stop()
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://181526230"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local FaintACTIVE = false
	Faint.MouseButton1Click:connect(function()
		FaintACTIVE = not FaintACTIVE
		if FaintACTIVE then				
			track:Play(.1, 1, 1 + SpeedNum)
			Faint.BackgroundColor3 = loc
			CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
		else
			track:Stop()
			Faint.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://186934910"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local SwordSpinACTIVE = false
	SwordSpin.MouseButton1Click:connect(function()
		SwordSpinACTIVE = not SwordSpinACTIVE
		if SwordSpinACTIVE then
			SwordSpin.BackgroundColor3 = loc
			while wait() do
				if track.IsPlaying == false then
					if SwordSpinACTIVE then
						track:Play(.1, 1, 0.8 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 0.8 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			SwordSpin.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://313762630"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local LevitateACTIVE = false
	Levitate.MouseButton1Click:connect(function()
		LevitateACTIVE = not LevitateACTIVE
		if LevitateACTIVE then
			track:Play(.1, 1, 1 + SpeedNum)
			Levitate.BackgroundColor3 = loc
			CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
		else
			track:Stop()
			Levitate.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://248263260"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local DabACTIVE = false
	Dab.MouseButton1Click:connect(function()
		DabACTIVE = not DabACTIVE
		if DabACTIVE then
			Dab.BackgroundColor3 = loc
			while wait() do
				if track.IsPlaying == false then
					if DabACTIVE then
						track:Play(.1, 1, 1 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			Dab.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://188632011"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local SpinACTIVE = false
	Spinner.MouseButton1Click:connect(function()
		SpinACTIVE = not SpinACTIVE
		if SpinACTIVE then
			Spinner.BackgroundColor3 = loc
			while wait() do
				if track.IsPlaying == false then
					if SpinACTIVE then
						track:Play(.1, 1, 2 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 2 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			Spinner.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://179224234"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local FloatSitACTIVE = false
	FloatSit.MouseButton1Click:connect(function()
		FloatSitACTIVE = not FloatSitACTIVE
		if FloatSitACTIVE then
			track:Play(.1, 1, 1 + SpeedNum)
			FloatSit.BackgroundColor3 = loc
			CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
		else
			track:Stop()
			FloatSit.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://429703734"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local MovingDanceACTIVE = false
	MovingDance.MouseButton1Click:connect(function()
		MovingDanceACTIVE = not MovingDanceACTIVE
		if MovingDanceACTIVE then
			MovingDance.BackgroundColor3 = loc
			while wait() do
				if track.IsPlaying == false then
					if MovingDanceACTIVE then
						track:Play(.1, 1, 1 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			MovingDance.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://215384594"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local WeirdMoveACTIVE = false
	WeirdMove.MouseButton1Click:connect(function()
		WeirdMoveACTIVE = not WeirdMoveACTIVE
		if WeirdMoveACTIVE then
			track:Play(.1, 1, 1 + SpeedNum)
			WeirdMove.BackgroundColor3 = loc
			CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
		else
			track:Stop()
			WeirdMove.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://215384594"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local CloneIllusionACTIVE = false
	CloneIllusion.MouseButton1Click:connect(function()
		CloneIllusionACTIVE = not CloneIllusionACTIVE
		if CloneIllusionACTIVE then
			track:Play(.5, 1, 1e7 + SpeedNum)
			CloneIllusion.BackgroundColor3 = loc
			CurSpeedText.Text = "CurrentSpeed: ".. 1e7 + SpeedNum
		else
			track:Stop()
			CloneIllusion.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://204292303"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local GlitchLevitateACTIVE = false
	GlitchLevitate.MouseButton1Click:connect(function()
		GlitchLevitateACTIVE = not GlitchLevitateACTIVE
		if GlitchLevitateACTIVE then
			track:Play(.1, 1, 1.5 + SpeedNum)
			GlitchLevitate.BackgroundColor3 = loc
			CurSpeedText.Text = "CurrentSpeed: ".. 1.5 + SpeedNum
		else
			track:Stop()
			GlitchLevitate.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://429730430"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local SpinDanceACTIVE = false
	SpinDance.MouseButton1Click:connect(function()
		SpinDanceACTIVE = not SpinDanceACTIVE
		if SpinDanceACTIVE then
			SpinDance.BackgroundColor3 = loc
			while wait() do
				if track.IsPlaying == false then
					if SpinDanceACTIVE then
						track:Play(.1, 1, 1 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			SpinDance.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://45834924"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local MoonDanceACTIVE = false
	MoonDance.MouseButton1Click:connect(function()
		MoonDanceACTIVE = not MoonDanceACTIVE
		if MoonDanceACTIVE then
			MoonDance.BackgroundColor3 = loc
			while wait() do
				if track.IsPlaying == false then
					if MoonDanceACTIVE then
						track:Play(.1, 1, 1 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			MoonDance.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://204062532"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local FullPunchACTIVE = false
	FullPunch.MouseButton1Click:connect(function()
		FullPunchACTIVE = not FullPunchACTIVE
		if FullPunchACTIVE then
			FullPunch.BackgroundColor3 = loc
			while wait() do
				if track.IsPlaying == false then
					if FullPunchACTIVE then
						track:Play(.1, 1, 1 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			FullPunch.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://248336459"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local SwordSlamACTIVE = false
	SwordSlam.MouseButton1Click:connect(function()
		SwordSlamACTIVE = not SwordSlamACTIVE
		if SwordSlamACTIVE then
			SwordSlam.BackgroundColor3 = loc
			while wait() do
				if track.IsPlaying == false then
					if SwordSlamACTIVE then
						track:Play(.1, 1, 1 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			SwordSlam.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://204295235"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local WallHackACTIVE = false
	WallHack.MouseButton1Click:connect(function()
		WallHackACTIVE = not WallHackACTIVE
		if WallHackACTIVE then
			WallHack.BackgroundColor3 = loc
			while wait() do
				if track.IsPlaying == false then
					if WallHackACTIVE then
						track:Play(.1, 1, 1e4 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 1e4 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			WallHack.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://184574340"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local MegaInsaneACTIVE = false
	MegaInsane.MouseButton1Click:connect(function()
		MegaInsaneACTIVE = not MegaInsaneACTIVE
		if MegaInsaneACTIVE then
			MegaInsane.BackgroundColor3 = loc
			while wait() do
				if track.IsPlaying == false then
					if MegaInsaneACTIVE then
						track:Play(.1, 0.5, 40 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 40 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			MegaInsane.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://35978879"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local SuperPunchACTIVE = false
	SuperPunch.MouseButton1Click:connect(function()
		SuperPunchACTIVE = not SuperPunchACTIVE
		if SuperPunchACTIVE then
			SuperPunch.BackgroundColor3 = loc
			while wait() do
				if track.IsPlaying == false then
					if SuperPunchACTIVE then
						track:Play(.1, 1, 2 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 2 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			SuperPunch.BackgroundColor3 = col
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://218504594"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local FullSwingACTIVE = false
	FullSwing.MouseButton1Click:connect(function()
		FullSwingACTIVE = not FullSwingACTIVE
		if FullSwingACTIVE then
			FullSwing.BackgroundColor3 = loc
			while wait() do
				if track.IsPlaying == false then
					if FullSwingACTIVE then
						track:Play(.1, 1, 1 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			FullSwing.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://259438880"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local ArmTurbineACTIVE = false
	ArmTurbine.MouseButton1Click:connect(function()
		ArmTurbineACTIVE = not ArmTurbineACTIVE
		if ArmTurbineACTIVE then
			track:Play(.1, 1, 3 + SpeedNum)
			ArmTurbine.BackgroundColor3 = loc
			CurSpeedText.Text = "CurrentSpeed: ".. 3 + SpeedNum
		else
			track:Stop()
			ArmTurbine.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://136801964"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local BarrelRollACTIVE = false
	BarrelRoll.MouseButton1Click:connect(function()
		BarrelRollACTIVE = not BarrelRollACTIVE
		if BarrelRollACTIVE then
			BarrelRoll.BackgroundColor3 = loc
			while wait() do
				if track.IsPlaying == false then
					if BarrelRollACTIVE then
						track:Play(.1, 1, 1 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			BarrelRoll.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://33796059"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local InsaneACTIVE = false
	Insane.MouseButton1Click:connect(function()
		InsaneACTIVE = not InsaneACTIVE
		if InsaneACTIVE then
			track:Play(.1, 1, 1e8 + SpeedNum)
			Insane.BackgroundColor3 = loc
			CurSpeedText.Text = "CurrentSpeed: ".. 1e8 + SpeedNum
		else
			track:Stop()
			Insane.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://126753849"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local PunchesACTIVE = false
	Punches.MouseButton1Click:connect(function()
		PunchesACTIVE = not PunchesACTIVE
		if PunchesACTIVE then
			Punches.BackgroundColor3 = loc
			while wait() do
				if track.IsPlaying == false then
					if PunchesACTIVE then
						track:Play(.1, 1, 2 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 2 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			Punches.BackgroundColor3 = col
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)
	-- R15
	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://674871189"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local CrazySlashACTIVE = false
	CrazySlash.MouseButton1Click:connect(function()
		CrazySlashACTIVE = not CrazySlashACTIVE
		if CrazySlashACTIVE then
			CrazySlash.BackgroundColor3 = rloc
			while wait() do
				if track.IsPlaying == false then
					if CrazySlashACTIVE then
						track:Play(.1, 1, 1 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			CrazySlash.BackgroundColor3 = rcol
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://582855105"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local OpenACTIVE = false
	Open.MouseButton1Click:connect(function()
		OpenACTIVE = not OpenACTIVE
		if OpenACTIVE then
			Open.BackgroundColor3 = rloc
			while wait() do
				if track.IsPlaying == false then
					if OpenACTIVE then
						track:Play(.1, 1, 1 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			Open.BackgroundColor3 = rcol
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://754658275"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local R15SpinnerACTIVE = false
	R15Spinner.MouseButton1Click:connect(function()
		R15SpinnerACTIVE = not R15SpinnerACTIVE
		if R15SpinnerACTIVE then
			R15Spinner.BackgroundColor3 = rloc
			while wait() do
				if track.IsPlaying == false then
					if R15SpinnerACTIVE then
						track:Play(.1, 1, 1 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			R15Spinner.BackgroundColor3 = rcol
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://582384156"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local ArmsOutACTIVE = false
	ArmsOut.MouseButton1Click:connect(function()
		ArmsOutACTIVE = not ArmsOutACTIVE
		if ArmsOutACTIVE then
			ArmsOut.BackgroundColor3 = rloc
			while wait() do
				if track.IsPlaying == false then
					if ArmsOutACTIVE then
						track:Play(.1, 1, 1 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			ArmsOut.BackgroundColor3 = rcol
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://717879555"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	local FloatSlashACTIVE = false
	FloatSlash.MouseButton1Click:connect(function()
		FloatSlashACTIVE = not FloatSlashACTIVE
		if FloatSlashACTIVE then
			FloatSlash.BackgroundColor3 = rloc
			while wait() do
				if track.IsPlaying == false then
					if FloatSlashACTIVE then
						track:Play(.1, 1, 1 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			FloatSlash.BackgroundColor3 = rcol
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://708553116"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	WeirdZombieACTIVE = false
	WeirdZombie.MouseButton1Click:connect(function()
		WeirdZombieACTIVE = not WeirdZombieACTIVE
		if WeirdZombieACTIVE then
			WeirdZombie.BackgroundColor3 = rloc
			while wait() do
				if track.IsPlaying == false then
					if WeirdZombieACTIVE then
						track:Play(.1, 1, 1 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			WeirdZombie.BackgroundColor3 = rcol
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://746398327"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	DownSlashACTIVE = false
	DownSlash.MouseButton1Click:connect(function()
		DownSlashACTIVE = not DownSlashACTIVE
		if DownSlashACTIVE then
			DownSlash.BackgroundColor3 = rloc
			while wait() do
				if track.IsPlaying == false then
					if DownSlashACTIVE then
						track:Play(.1, 1, 1 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			DownSlash.BackgroundColor3 = rcol
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://675025795"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	PullACTIVE = false
	Pull.MouseButton1Click:connect(function()
		PullACTIVE = not PullACTIVE
		if PullACTIVE then
			Pull.BackgroundColor3 = rloc
			while wait() do
				if track.IsPlaying == false then
					if PullACTIVE then
						track:Play(.1, 1, 1 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			Pull.BackgroundColor3 = rcol
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://698251653"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	CircleArmACTIVE = false
	CircleArm.MouseButton1Click:connect(function()
		CircleArmACTIVE = not CircleArmACTIVE
		if CircleArmACTIVE then
			CircleArm.BackgroundColor3 = rloc
			while wait() do
				if track.IsPlaying == false then
					if CircleArmACTIVE then
						track:Play(.1, 1, 1 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			CircleArm.BackgroundColor3 = rcol
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://696096087"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	BendACTIVE = false
	Bend.MouseButton1Click:connect(function()
		BendACTIVE = not BendACTIVE
		if BendACTIVE then
			Bend.BackgroundColor3 = rloc
			while wait() do
				if track.IsPlaying == false then
					if BendACTIVE then
						track:Play(.1, 1, 1 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			Bend.BackgroundColor3 = rcol
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://675025570"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	RotateSlashACTIVE = false
	RotateSlash.MouseButton1Click:connect(function()
		RotateSlashACTIVE = not RotateSlashACTIVE
		if RotateSlashACTIVE then
			RotateSlash.BackgroundColor3 = rloc
			while wait() do
				if track.IsPlaying == false then
					if RotateSlashACTIVE then
						track:Play(.1, 1, 1 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 1 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			RotateSlash.BackgroundColor3 = rcol
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)

	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://754656200"
	local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
	FlingArmsACTIVE = false
	FlingArms.MouseButton1Click:connect(function()
		FlingArmsACTIVE = not FlingArmsACTIVE
		if FlingArmsACTIVE then
			FlingArms.BackgroundColor3 = rloc
			while wait() do
				if track.IsPlaying == false then
					if FlingArmsACTIVE then
						track:Play(.1, 1, 10 + SpeedNum)
						CurSpeedText.Text = "CurrentSpeed: ".. 10 + SpeedNum
					end
				end
			end
		else
			track:Stop()
			FlingArms.BackgroundColor3 = rcol
			CurSpeedText.Text = "CurrentSpeed: -"
		end
	end)
	
	GuiEmoter = Emoter
	
end

-- PLEASE DO NOT DELETE THIS
CreateGui()
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "Hello!",
	Text = "Thank you for using Emote GUI by illremember and Fixel!", 
	Duration = 5,
	Icon = "rbxassetid://95707366110827"
})
-- PLEASE DO NOT DELETE THIS

game.Players.LocalPlayer.CharacterAdded:connect(function()
	if GuiActive then
		GuiEmoter:Destroy()
		CreateGui()	
	end
end)
