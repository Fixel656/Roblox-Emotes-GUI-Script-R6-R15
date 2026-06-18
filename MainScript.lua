--V1
--Original by illremember, edited by Fixel656
--DO NOT COPY AND CLAIM AS OWN, if you are using some of the script for your own, 
--credit (especially of original author) is highly appreciated! 

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

	local GuiBottomFrame = Instance.new("Frame")
	local SpeedFrame = Instance.new("Frame") -- Frame of Speed Changer
	local CurSpeedText = Instance.new("TextLabel") --Text showing your current anim speed

	local ScrollingFrame = Instance.new("ScrollingFrame") -- The scrolling frame of animations
	local CheckR = Instance.new("TextLabel") -- Check if R15 or R6, currently invisible
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
	ButtonCol = BgColor -- R6 Button Color
	ButtonBackCol = Color3.new(0.427451, 0.490196, 0.792157) -- R6 Button darker color (idk how to make it just darker BgColor yet)
	R15ButtonCol = Color3.new(0.682353, 0.701961, 0.792157) --R15 Button color
	R15ButtonBackCol = Color3.new(0.882353, 0.901961, 0.992157) -- R15 Button darker color

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

	local function PlayAnim(Object, ID, AnimWeight, Speed, Type, LoopedVal, NeedPause) -- Types: PriorLow, PriorHigh
		Object:SetAttribute("Looped", LoopedVal)
		local Anim = Instance.new("Animation")
		Anim.AnimationId = ID
		local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
		if Type == "PriorLow" then
			track.Priority = Enum.AnimationPriority.Action3
		elseif Type == "PriorHigh" then
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
				CurSpeedText.Text = "Speed: ".. Speed + SpeedNum

				if NeedPause == true then
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

				CurSpeedText.Text = "Speed: -"
			end
			track.Ended:connect(function()
				AnimACTIVE = false
				if Object.Parent == ScrollingFrame then
					Object.BackgroundColor3 = ButtonCol
				elseif Object.Parent == ScrollingFrameR15 then
					Object.BackgroundColor3 = R15ButtonCol
				end
				CurSpeedText.Text = "Speed: -"
			end)
		end)

	end
	
	local function AddHoverText(Object, Text)
		Object.MouseEnter:connect(function()
			-- Add hover text
		end)
		Object.MouseLeave:connect(function()
			-- Destroy hover text
		end)
	end

	-- Properties
	-- SideFrame

	Emoter.Name = "Emoter"
	Emoter.Parent = game.Players.LocalPlayer.PlayerGui

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

	--SpeedFrame Parts
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
	ScrollingFrameR15.CanvasSize = UDim2.new(0, 0, 3.5, 0)
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
	CheckR.Text = "Text"
	CheckR.TextScaled = true
	CheckR.TextSize = 14
	CheckR.TextWrapped = true
	
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

	-- EMOTES	

	--[[Functions Template
	local AnimName = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Obj, "Name", "Text", "R6", 0)
	PlayAnim(Obj, "rbxassetid://", .1, 1, "PriorLow", true)
	
	CreateAnimation has Object (Button), Name of object, Text, Type ow whiich type of scrolling frame will it be, and LayoutOrder to organize Anim button to its type
	PlayAnim has Object (Button), Id of anim, Anim FadeTime, speed of anim, Looped state AND check if anim needs to be paused after second of playing
	]]

	-- R6 Emotes

	local Dance1 = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Dance1, "Dance1", "Dance 1", "R6", 0)
	PlayAnim(Dance1, "rbxassetid://182491037", .1, 1, "PriorLow", true)
	local Dance2 = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Dance2, "Dance2", "Dance 2", "R6", 0)
	PlayAnim(Dance2, "rbxassetid://182436842", .1, 1, "PriorLow", true)
	local Dance3 = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Dance3, "Dance3", "Dance 3", "R6", 0)
	PlayAnim(Dance3, "rbxassetid://182491368", .1, 1, "PriorLow", true)
	local MoonDance = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(MoonDance, "MoonDance", "Moon Dance", "R6", 0)
	PlayAnim(MoonDance, "rbxassetid://45834924", .1, 1, "PriorLow", true)
	local SpinDance = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(SpinDance, "SpinDance", "Spin Dance", "R6", 0)
	PlayAnim(SpinDance, "rbxassetid://429730430", .1, 1, "PriorLow", true)
	local JumpingJacks = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(JumpingJacks, "JumpingJacks", "Jumping Jacks", "R6", 0)
	PlayAnim(JumpingJacks, "rbxassetid://429681631", .1, 1, "PriorLow", true)
	local Bang = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Bang, "Bang", "Bang", "R6", 0)
	PlayAnim(Bang, "rbxassetid://148840371", .1, 3, "PriorLow", true)
	local MovingDance = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(MovingDance, "MovingDance", "Moving Dance", "R6", 0)
	PlayAnim(MovingDance, "rbxassetid://429703734", .1, 1, "PriorLow", true)
	local Dab = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Dab, "Dab", "Dab", "R6", 0)
	PlayAnim(Dab, "rbxassetid://248263260", .1, 1, "PriorLow", true)
	local GoofyDance = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(GoofyDance, "GoofyDance", "Goofy Dance", "R6", 0)
	PlayAnim(GoofyDance, "rbxassetid://27789359", .1, 0.8, "PriorLow", true)
	local WeirdDance = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(WeirdDance, "WeirdDance", "Weird Dance", "R6", 0)
	PlayAnim(WeirdDance, "rbxassetid://28488254", .1, 0.8, "PriorLow", true)
	local Laugh = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Laugh, "Laugh", "Laugh", "R6", 0)
	PlayAnim(Laugh, "rbxassetid://129423131", .1, 1, "PriorLow", false)
	local Cheer = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Cheer, "Cheer", "Cheer", "R6", 0)
	PlayAnim(Cheer, "rbxassetid://129423030", .1, 1, "PriorLow", true)
	local Point = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Point, "Point", "Point", "R6", 0)
	PlayAnim(Point, "rbxassetid://128853357", .1, 1, "PriorLow", false)
	local Wave = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Wave, "Wave", "Wave", "R6", 0)
	PlayAnim(Wave, "rbxassetid://128777973", .1, 1, "PriorLow", false)
	local Crouch = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Crouch, "Crouch", "Crouch", "R6", 1)
	PlayAnim(Crouch, "rbxassetid://182724289", .1, 1, "PriorLow", true)
	local Faint = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Faint, "Faint", "Faint", "R6", 1)
	PlayAnim(Faint, "rbxassetid://181526230", .1, 1, "PriorHigh", true)
	local FloorCrawl = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(FloorCrawl, "FloorCrawl", "Floor Crawl", "R6", 1)
	PlayAnim(FloorCrawl, "rbxassetid://282574440", .1, 1, "PriorLow", true)
	local Levitate = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Levitate, "Levitate", "Levitate", "R6", 1)
	PlayAnim(Levitate, "rbxassetid://313762630", .1, 1, "PriorHigh", true)
	local DinoWalk = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(DinoWalk, "DinoWalk", "Dino Walk", "R6", 1)
	PlayAnim(DinoWalk, "rbxassetid://204328711", .1, 1, "PriorLow", true)
	local Climb = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Climb, "Climb", "Climb Walk", "R6", 0)
	PlayAnim(Climb, "rbxassetid://125750800", .1, 1, "PriorLow", true)
	local ToolHandle = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(ToolHandle, "ToolHandle", "Tool Handle", "R6", 1)
	PlayAnim(ToolHandle, "rbxassetid://125750867", .1, 1, "PriorHigh", true)
	local Scared = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Scared, "Scared", "Scared", "R6", 1)
	PlayAnim(Scared, "rbxassetid://180612465", .1, 0.3, "PriorLow", true, true)
	local FloatingHead = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(FloatingHead, "FloatingHead", "Floating Head", "R6", 1)
	PlayAnim(FloatingHead, "rbxassetid://121572214", .1, 1, "PriorHigh", true)
	local FloatSit = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(FloatSit, "FloatSit", "Float Sit", "R6", 1)
	PlayAnim(FloatSit, "rbxassetid://179224234", .5, 1, "PriorLow", true)
	local Spinner = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Spinner, "Spinner", "Spinner", "R6", 2)
	PlayAnim(Spinner, "rbxassetid://188632011", .1, 2, "PriorHigh", true)
	local StrangePos = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(StrangePos, "StrangePos", "Strange Position", "R6", 2)
	PlayAnim(StrangePos, "rbxassetid://248336459", .1, 1, "PriorLow", true)
	local HeadThrow = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(HeadThrow, "HeadThrow", "Head Throw", "R6", 2)
	PlayAnim(HeadThrow, "rbxassetid://35154961", .1, 1, "PriorHigh", false)
	local ArmTurbine = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(ArmTurbine, "ArmTurbine", "Arm Turbine", "R6", 2)
	PlayAnim(ArmTurbine, "rbxassetid://259438880", .1, 3, "PriorLow", true)
	local BarrelRoll = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(BarrelRoll, "BarrelRoll", "Barrel Roll", "R6", 2)
	PlayAnim(BarrelRoll, "rbxassetid://136801964", .1, 1, "PriorLow", true)
	local MegaInsane = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(MegaInsane, "MegaInsane", "Mega Insane", "R6", 3)
	PlayAnim(MegaInsane, "rbxassetid://184574340", .1, 40, "PriorLow", true)
	local WeirdMove = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(WeirdMove, "WeirdMove", "Weird Move", "R6", 3)
	PlayAnim(WeirdMove, "rbxassetid://215384594", .1, 1, "PriorLow", true)
	local CloneIllusion = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(CloneIllusion, "CloneIllusion", "Clone Illusion", "R6", 3)
	PlayAnim(CloneIllusion, "rbxassetid://215384594", .1, 1e10, "PriorLow", true)
	local Insane = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Insane, "Insane", "Insane", "R6", 3)
	PlayAnim(Insane, "rbxassetid://33796059", .1, 1e8, "PriorLow", true)
	local WallHack = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(WallHack, "WallHack", "Wall Hack", "R6", 3)
	PlayAnim(WallHack, "rbxassetid://204295235", .1, 1e4, "PriorLow", true)
	local FullSwing = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(FullSwing, "FullSwing", "Full Swing", "R6", 4)
	PlayAnim(FullSwing, "rbxassetid://218504594", .1, 1, "PriorHigh", true)
	local NunchakSlash = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(NunchakSlash, "NunchakSlash", "Nunchak Slash", "R6", 4)
	PlayAnim(NunchakSlash, "rbxassetid://204292303", .1, 1.5, "PriorLow", false)
	local FullPunch = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(FullPunch, "FullPunch", "Full Punch", "R6", 4)
	PlayAnim(FullPunch, "rbxassetid://204062532", .1, 1, "PriorLow", true)
	local SwordSpin = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(SwordSpin, "SwordSpin", "Sword Spin", "R6", 4)
	PlayAnim(SwordSpin, "rbxassetid://186934910", .1, 0.8, "PriorLow", true)
	local Punches = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Punches, "Punches", "Punches", "R6", 4)
	PlayAnim(Punches, "rbxassetid://126753849", .1, 2, "PriorLow", true)
	local HeroJump = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(HeroJump, "HeroJump", "Hero Jump", "R6", 4)
	PlayAnim(HeroJump, "rbxassetid://184574340", .1, 1, "PriorLow", true)
	local DoubleSlash = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(DoubleSlash, "DoubleSlash", "Double Slash", "R6", 4)
	PlayAnim(DoubleSlash, "rbxassetid://35978879", .1, 2, "PriorLow", true)
	local SwordSwing = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(SwordSwing, "SwordSwing", "Sword Swing", "R6", 4)
	PlayAnim(SwordSwing, "rbxassetid://32659699", .1, 1, "PriorLow", true)

	--R15 Emotes

	local WormAnim = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(WormAnim, "WormAnim", "Worm Fly", "R15")
	PlayAnim(WormAnim, "rbxassetid://135990691658209", .1, 1, "PriorLow", true)
	local Orbit = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Orbit, "Orbit", "Orbit", "R15")
	PlayAnim(Orbit, "rbxassetid://108359356964182", .1, 1, "PriorLow", true)
	local TakeTheL = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(TakeTheL, "TakeTheL", "Take The L", "R15")
	PlayAnim(TakeTheL, "rbxassetid://106769842240175", .1, 1, "PriorLow", true)
	local SillyAnimals = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(SillyAnimals, "SillyAnimals", "Silly Animals Dance", "R15")
	PlayAnim(SillyAnimals, "rbxassetid://98943029911905", .1, 1, "PriorLow", true)
	local Hanging = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Hanging, "Hanging", "Hanging", "R15")
	PlayAnim(Hanging, "rbxassetid://125662782523118", .1, 1, "PriorLow", true)
	local AwkwardWave = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(AwkwardWave, "AwkwardWave", "Awkward Wave", "R15")
	PlayAnim(AwkwardWave, "rbxassetid://86074172929360", .1, 1, "PriorLow", true)
	local ScubaSwim = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(ScubaSwim, "ScubaSwim", "Scuba Swim", "R15")
	PlayAnim(ScubaSwim, "rbxassetid://133144141297457", .1, 1, "PriorLow", true)
	local FloatingHeadIdle = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(FloatingHeadIdle, "FloatingHeadIdle", "Floating Head Idle", "R15")
	PlayAnim(FloatingHeadIdle, "rbxassetid://111681053387222", .1, 1, "PriorLow", true)
	local SnakeDance = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(SnakeDance, "SnakeDance", "Snake Dance", "R15")
	PlayAnim(SnakeDance, "rbxassetid://102379382117775", .1, 1, "PriorLow", true)
	local ShakeItToMax = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(ShakeItToMax, "ShakeItToMax", "Shake It To the Max", "R15")
	PlayAnim(ShakeItToMax, "rbxassetid://99879110127289", .1, 1, "PriorLow", true)
	local PitbullDance = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(PitbullDance, "PitbullDance", "Pitbull Dance", "R15")
	PlayAnim(PitbullDance, "rbxassetid://102593046003485", .1, 1, "PriorLow", true)
	local LaDetoneDance = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(LaDetoneDance, "LaDetoneDance", "La Detone Dance", "R15")
	PlayAnim(LaDetoneDance, "rbxassetid://102779295838500", .1, 1, "PriorLow", true)
	local BrazillianVibe = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(BrazillianVibe, "BrazillianVibe", "Brazillian Vibe", "R15")
	PlayAnim(BrazillianVibe, "rbxassetid://99638411514722", .1, 1, "PriorLow", true)
	local DiaDeliciaDance = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(DiaDeliciaDance, "DiaDeliciaDance", "Dia Delicia Dance", "R15")
	PlayAnim(DiaDeliciaDance, "rbxassetid://108759656834820", .1, 1, "PriorLow", true)
	local Dwerk = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Dwerk, "Dwerk", "Dwerk", "R15")
	PlayAnim(Dwerk, "rbxassetid://105281048589270", .1, 1, "PriorLow", true)
	local LaggyWalkTroll = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(LaggyWalkTroll, "LaggyWalkTroll", "Laggy Walk Troll", "R15")
	PlayAnim(LaggyWalkTroll, "rbxassetid://119199812452698", .1, 1, "PriorLow", true)
	local Tank = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Tank, "Tank", "Tank", "R15")
	PlayAnim(Tank, "rbxassetid://115951523870527", .1, 1, "PriorLow", true)
	local FingerGun = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(FingerGun, "FingerGun", "Finger-Gun", "R15")
	PlayAnim(FingerGun, "rbxassetid://73468073017890", .1, 1, "PriorLow", true)
	local Helicopter = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Helicopter, "Helicopter", "Helicopter", "R15")
	PlayAnim(Helicopter, "rbxassetid://76510079095692", .1, 1, "PriorLow", true)
	local RaceCar = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(RaceCar, "RaceCar", "Race Car", "R15")
	PlayAnim(RaceCar, "rbxassetid://72382226286301", .1, 1, "PriorLow", true)
	local JumpingSpider = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(JumpingSpider, "JumpingSpider", "Jumping Spider", "R15")
	PlayAnim(JumpingSpider, "rbxassetid://139310328821985", .1, 1, "PriorLow", true)
	local CrabDance = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(CrabDance, "CrabDance", "Crab Dance", "R15")
	PlayAnim(CrabDance, "rbxassetid://115209133522801", .1, 1, "PriorLow", true)
	local InsaneDog = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(InsaneDog, "InsaneDog", "Insane Dog", "R15")
	PlayAnim(InsaneDog, "rbxassetid://96435804447949", .1, 1, "PriorLow", true)
	local InchWorm = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(InchWorm, "InchWorm", "Inch Worm", "R15")
	PlayAnim(InchWorm, "rbxassetid://119096405600200", .1, 1, "PriorLow", true)
	local GoofyWiggle = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(GoofyWiggle, "GoofyWiggle", "Goofy Wiggle", "R15")
	PlayAnim(GoofyWiggle, "rbxassetid://74917195706355", .1, 1, "PriorLow", true)
	local Tornado = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Tornado, "Tornado", "Tornado", "R15")
	PlayAnim(Tornado, "rbxassetid://135373056067761", .1, 1, "PriorLow", true)
	local FloatChillSit = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(FloatChillSit, "FloatChillSit", "Float Chill Sit", "R15")
	PlayAnim(FloatChillSit, "rbxassetid://97361223864206", .1, 1, "PriorLow", true)
	local FloatIdle = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(FloatIdle, "FloatIdle", "Float Idle", "R15")
	PlayAnim(FloatIdle, "rbxassetid://94942486115057", .1, 1, "PriorLow", true)
	local GoofyFLY = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(GoofyFLY, "GoofyFLY", "Goofy FLY", "R15")
	PlayAnim(GoofyFLY, "rbxassetid://118417760427139", .1, 1, "PriorLow", true)
	local AdminFly = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(AdminFly, "AdminFly", "Admin Fly", "R15")
	PlayAnim(AdminFly, "rbxassetid://85063861261432", .1, 1, "PriorLow", true)
	local ObbyHead = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(ObbyHead, "ObbyHead", "Little Obbyist", "R15")
	PlayAnim(ObbyHead, "rbxassetid://115569573258316", .1, 1, "PriorLow", true)
	local Sitting = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Sitting, "Sitting", "Sitting", "R15")
	PlayAnim(Sitting, "rbxassetid://94763556845023", .1, 1, "PriorLow", true)
	local MM2Sit = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(MM2Sit, "MM2Sit", "MM2 Sit", "R15")
	PlayAnim(MM2Sit, "rbxassetid://130577643309726", .1, 1, "PriorLow", true)
	local RatDance = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(RatDance, "RatDance", "Rat Dance", "R15")
	PlayAnim(RatDance, "rbxassetid://78684440273676", .1, 1, "PriorLow", true)
	local IWantMoneyDance = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(IWantMoneyDance, "IWantMoneyDance", "IWantMoney Dance", "R15")
	PlayAnim(IWantMoneyDance, "rbxassetid://115781688996859", .1, 1, "PriorLow", true)
	local FortniteDance = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(FortniteDance, "FortniteDance", "Fortnite Dance", "R15")
	PlayAnim(FortniteDance, "rbxassetid://126199405283943", .1, 1, "PriorLow", true)
	local GangnamStyle = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(GangnamStyle, "GangnamStyle", "Gangnam Style", "R15")
	PlayAnim(GangnamStyle, "rbxassetid://129764254213842", .1, 1, "PriorLow", true)
	local Box = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Box, "Box", "Box", "R15")
	PlayAnim(Box, "rbxassetid://73753845465382", .1, 1, "PriorLow", true)
	local Plane = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Plane, "Plane", "Plane", "R15")
	PlayAnim(Plane, "rbxassetid://94462256787399", .1, 1, "PriorLow", true)
	local  MedusaWalk = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(MedusaWalk, "MedusaWalk", "Medusa Walk", "R15")
	PlayAnim(MedusaWalk, "rbxassetid://131663132818596", .1, 1, "PriorLow", true)
	local TallCreatureWalk = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(TallCreatureWalk, "TallCreatureWalk", "Tall Creature Walk", "R15")
	PlayAnim(TallCreatureWalk, "rbxassetid://134010853417610", .1, 1, "PriorLow", true)
	local Insane = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Insane, "Insane", "Insane", "R15")
	PlayAnim(Insane, "rbxassetid://93087898023268", .1, 1, "PriorLow", true)
	local DaHoodStomp = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(DaHoodStomp, "DaHoodStomp", "DaHood Stomp", "R15")
	PlayAnim(DaHoodStomp, "rbxassetid://92249489340640", .1, 1, "PriorLow", true)
	local BodyPhone = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(BodyPhone, "BodyPhone", "Body Phone", "R15")
	PlayAnim(BodyPhone, "rbxassetid://73390669780316", .1, 1, "PriorLow", true)
	local CartoonDance = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(CartoonDance, "CartoonDance", "Cartoon Dance", "R15")
	PlayAnim(CartoonDance, "rbxassetid://123516934346404", .1, 1, "PriorLow", true)
	local CarDriving = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(CarDriving, "CarDriving", "Car Driving", "R15")
	PlayAnim(CarDriving, "rbxassetid://132471972345518", .1, 1, "PriorLow", true)
	local Sleeping = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Sleeping, "Sleeping", "Sleeping", "R15")
	PlayAnim(Sleeping, "rbxassetid://121641415206650", .1, 1, "PriorLow", true)
	local RussianKick = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(RussianKick, "RussianKick", "Russian Kick", "R15")
	PlayAnim(RussianKick, "rbxassetid://70653974473742", .1, 1, "PriorLow", true)
	local MannrobicsDance = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(MannrobicsDance, "MannrobicsDance", "Mannrobics Dance", "R15")
	PlayAnim(MannrobicsDance, "rbxassetid://73932117454031", .1, 1, "PriorLow", true)
	local PennywiseDance = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(PennywiseDance, "PennywiseDance", "Pennywise Dance", "R15")
	PlayAnim(PennywiseDance, "rbxassetid://138755180984581", .1, 1, "PriorLow", true)
	local RestingHeadJuggle = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(RestingHeadJuggle, "RestingHeadJuggle", "Resting Head Juggle", "R15")
	PlayAnim(RestingHeadJuggle, "rbxassetid://136767849845319", .1, 1, "PriorLow", true)
	local PushUp = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(PushUp, "PushUp", "Push Ups", "R15")
	PlayAnim(PushUp, "rbxassetid://80326183054599", .1, 1, "PriorLow", true)
	local BreakDance = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(BreakDance, "BreakDance", "Break Dance", "R15")
	PlayAnim(BreakDance, "rbxassetid://10214311282", .1, 1, "PriorLow", true)
	local Rambunctious = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Rambunctious, "Rambunctious", "Rambunctious", "R15")
	PlayAnim(Rambunctious, "rbxassetid://129991743366120", .1, 1, "PriorLow", true)
	local Bodybuilder = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Bodybuilder, "Bodybuilder", "Bodybuilder", "R15")
	PlayAnim(Bodybuilder, "rbxassetid://10713990381", .1, 1, "PriorLow", true)
	local BigLaugh = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(BigLaugh, "BigLaugh", "Big Laugh", "R15")
	PlayAnim(BigLaugh, "rbxassetid://98974619620224", .1, 1, "PriorLow", true)
	local Bored = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Bored, "Bored", "Bored", "R15")
	PlayAnim(Bored, "rbxassetid://10713992055", .1, 1, "PriorLow", true)
	local Applaud = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Applaud, "Applaud", "Applaud", "R15")
	PlayAnim(Applaud, "rbxassetid://10713966026", .1, 1, "PriorLow", true)
	local Spin = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Spin, "Spin", "Spin", "R15")
	PlayAnim(Spin, "rbxassetid://110792133024438", .1, 1, "PriorLow", true)
	local SpinAround = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(SpinAround, "SpinAround", "SpinAround", "R15")
	PlayAnim(SpinAround, "rbxassetid://91004858616595", .1, 1, "PriorLow", true)
	local FloatingOnClouds = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(FloatingOnClouds, "FloatingOnClouds", "Floating On Clouds", "R15")
	PlayAnim(FloatingOnClouds, "rbxassetid://77840765435893", .1, 1, "PriorLow", true)
	local NightmailDance = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(NightmailDance, "NightmailDance", "Nightmai lDance", "R15")
	PlayAnim(NightmailDance, "rbxassetid://103655955630769", .1, 1, "PriorLow", true)
	local FloatingSpace = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(FloatingSpace, "FloatingSpace", "Floating Space", "R15")
	PlayAnim(FloatingSpace, "rbxassetid://71209604118044", .1, 1, "PriorLow", true)
	local FloatingSpace2 = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(FloatingSpace2, "FloatingSpace2", "Floating Space 2", "R15")
	PlayAnim(FloatingSpace2, "rbxassetid://70394064781064", .1, 1, "PriorLow", true)
	local FakeDeadRagdoll = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(FakeDeadRagdoll, "FakeDeadRagdoll", "Fake DeadRagdoll", "R15")
	PlayAnim(FakeDeadRagdoll, "rbxassetid://80098083655931", .1, 1, "PriorLow", true)
	local FakeDeath = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(FakeDeath, "FakeDeath", "FakeDeath", "R15")
	PlayAnim(FakeDeath, "rbxassetid://88130117312312", .1, 1, "PriorLow", true, true)
	local ShadowRun = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(ShadowRun, "ShadowRun", "Shadow Running", "R15")
	PlayAnim(ShadowRun, "rbxassetid://82598234841035", .1, 0.8, "PriorLow", true)
	local AdidasRun = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(AdidasRun, "AdidasRun", "Adidas Running", "R15")
	PlayAnim(AdidasRun, "rbxassetid://18537384940", .1, 1, "PriorLow", true)
	local SitAnim = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(SitAnim, "SitAnim", "Sit Anim", "R15")
	PlayAnim(SitAnim, "rbxassetid://507768133", .1, 1, "PriorLow", true)
	local ToolHandle = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(ToolHandle, "ToolHandle", "Tool Handle", "R15")
	PlayAnim(ToolHandle, "rbxassetid://507768375", .1, 1, "PriorLow", true)
	local Wave = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Wave, "Wave", "Wave", "R15")
	PlayAnim(Wave, "rbxassetid://507770239", .1, 1, "PriorLow", true)
	local Point = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Point, "Point", "Point", "R15")
	PlayAnim(Point, "rbxassetid://10714395441", .1, 1, "PriorLow", true)
	local Dance1 = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Dance1, "Dance1", "Dance 1", "R15")
	PlayAnim(Dance1, "rbxassetid://507771955", .1, 1, "PriorLow", true)
	local Dance2 = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Dance2, "Dance2", "Dance 2", "R15")
	PlayAnim(Dance2, "rbxassetid://507776720", .1, 1, "PriorLow", true)
	local Dance3 = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Dance3, "Dance3", "Dance 3", "R15")
	PlayAnim(Dance3, "rbxassetid://507777451", .1, 1, "PriorLow", true)
	local Laugh = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Laugh, "Laugh", "Laugh", "R15")
	PlayAnim(Laugh, "rbxassetid://507770818", .1, 1, "PriorLow", true)
	local Cheer = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Cheer, "Cheer", "Cheer", "R15")
	PlayAnim(Cheer, "rbxassetid://507770677", .1, 1, "PriorLow", true)
	local Salute = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(Salute, "Salute", "Salute", "R15")
	PlayAnim(Salute, "rbxassetid://3360689775", .1, 1, "PriorLow", true)
	local QuadPunch = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(QuadPunch, "QuadPunch", "Quad Punch", "R15")
	PlayAnim(QuadPunch, "rbxassetid://139643944264511", .1, 1, "PriorLow", true)
	local FightingIdle = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(FightingIdle, "FightingIdle", "Fighting Idle", "R15")
	PlayAnim(FightingIdle, "rbxassetid://105947156749343", .1, 1, "PriorLow", true)
	local TennaKick = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(TennaKick, "TennaKick", "TennaKick", "R15")
	PlayAnim(TennaKick, "rbxassetid://118139885865308", .1, 1, "PriorLow", true)
	local TennaArmDance = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(TennaArmDance, "TennaArmDance", "Tenna Arm Dance", "R15")
	PlayAnim(TennaArmDance, "rbxassetid://140315159513795", .1, 1, "PriorLow", true)
	local TennaSwingDance = Instance.new("TextButton")--COMPLETE
	CreateAnimButton(TennaSwingDance, "TennaSwingDance", "Tenna Swing Dance", "R15")
	PlayAnim(TennaSwingDance, "rbxassetid://77984841414450", .1, 1, "PriorLow", true)

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

	-- Buttons




	--[[ Script to stop all animations from default Animate Script cuz why not
	
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
