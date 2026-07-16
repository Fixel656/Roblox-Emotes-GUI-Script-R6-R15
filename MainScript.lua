--V3
--[[Script by Fixel656, based on Energize GUI by illremember
DO NOT COPY AND CLAIM AS YOUR OWN, if you are using some of the script for your own, 
credit is highly appreciated!]]

local GuiActive = true
local GuiEmoter = nil
local Player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

--Settings
local ToolAnimHighPrior = false
local AnimPreviewEnable = true
local AnimSwitchMode = false
local AnimSmoothFade = true
local theme = "LightPurple"

local HotkeysEnabled = true
local SearchHotkey = Instance.new("StringValue")
local CloseHotkey = Instance.new("StringValue")
local SitHotkey = Instance.new("StringValue")
local SwitchAnimHotkey = Instance.new("StringValue")
local AnimFadeHotkey = Instance.new("StringValue")
local SettingsHotkey = Instance.new("StringValue")

SearchHotkey.Value = "Y"
CloseHotkey.Value = "T"
SitHotkey.Value = "G"
SwitchAnimHotkey.Value = "V"
AnimFadeHotkey.Value = "B"
SettingsHotkey.Value = "H"

local BgColor = Color3.fromRGB(137, 165, 255)
local ScrollBgColor = Color3.fromRGB(219, 244, 255)
local UiButColor = Color3.new(0, 0, 0) -- Color of GUI's buttons and Texts
local ButtonCol = Color3.fromRGB(192, 191, 211) -- R6 Button Color
local ButtonSelectCol = Color3.fromRGB(255, 255, 255) -- R6 Button darker color (idk how to make it just darker BgColor yet)

--Restart Values
local GuiPos = nil
local SettingsPos = nil
local ScrollingFramePos = nil
local GuiClosed = false
local OptionsOpened = false
local SettingsOpened = false

local PrevAnimSpeedValue = ""
local SearchOpened = false
local PrevSearchText = ""
local CustomAnimOpened = false
local PrevCustomAnimId = ""

local DefaultAnimsNameList = {"Animation1", "Animation2", "Animation3", "ClimbAnim", "FallAnim", "JumpAnim", "RunAnim", "SitAnim", "ToolNoneAnim", "WalkAnim", "CheerAnim", "LaughAnim", "PointAnim", "Swim", "SwimIdle", "ToolLungeAnim", "ToolSlashAnim", "WaveAnim"}

local ConfigFileName = "EmoterConfig.json"

if not game:GetService("RunService"):IsStudio() then
	if isfile("EmoterData/"..ConfigFileName) then
		local rawData = readfile("EmoterData/"..ConfigFileName)
		local decodedSettings = HttpService:JSONDecode(rawData)
		-- Accessing the loaded data
		AnimPreviewEnable = decodedSettings.ConfAnimPreviewEnable
		ToolAnimHighPrior = decodedSettings.ConfToolAnimHighPrior
		AnimSwitchMode = decodedSettings.ConfAnimSwitchMode
		AnimSmoothFade = decodedSettings.ConfAnimSmoothFade
		theme = decodedSettings.ConfTheme
		HotkeysEnabled = decodedSettings.ConfHotkeysEnabled
		SearchHotkey.Value = decodedSettings.ConfSearchHotkey
		CloseHotkey.Value = decodedSettings.ConfCloseHotkey
		SitHotkey.Value = decodedSettings.ConfSitHotkey
		SwitchAnimHotkey.Value = decodedSettings.ConfSwitchAnimHotkey
		AnimFadeHotkey.Value = decodedSettings.ConfAnimFadeHotkey
		SettingsHotkey.Value = decodedSettings.ConfSettingsHotkey
	end
end

local function CreateGui()

	local SpeedNum --Value, adding to default speed of animation
	local Humanoid = nil
	local ClonedChar = nil

	local Emoter = Instance.new("ScreenGui") -- The actual GUI
	local MainFrame = Instance.new("Frame") -- All of the stuff on the main frame

	local SideFrame = Instance.new("Frame") -- Visible when GUI is closed
	local SideFrameTitle = Instance.new("TextLabel")
	local OpenGUI = Instance.new("ImageButton")
	local SFDestroyGUI = Instance.new("TextButton") -- To Destroy the GUI in SideFrame

	local ViewportFrame = Instance.new("ViewportFrame")

	local GuiTopFrame = Instance.new("Frame") -- Top of the main frame
	local DestroyGUI = Instance.new("TextButton") -- To Destroy the GUI
	local CloseGUI = Instance.new("ImageButton") -- To close the GUI
	local Title = Instance.new("TextLabel") -- Actual title of GUI, Emoter

	local GuiBottomFrame = Instance.new("Frame")
	local SpeedFrame = Instance.new("Frame") -- Frame of Speed Changer
	local CurSpeedText = Instance.new("TextLabel") --Text showing your current anim speed
	local OptionsButton = Instance.new("ImageButton")

	local ScrollingFrame = Instance.new("ScrollingFrame") -- The scrolling frame of animations
	local ScrollingFrameR15 = Instance.new("ScrollingFrame") -- The scrolling frame of R15 animations
	local ScrollingFramesList = {
		ScrollingFrame,
		ScrollingFrameR15
	}

	local SearchFrame = Instance.new("Frame")
	local SearchButton = Instance.new("ImageButton")
	local SearchBox = Instance.new("TextBox")
	local BackButton = Instance.new("ImageButton")

	local OptionsFrame = Instance.new("Frame")
	local PauseAnimsButton = Instance.new("ImageButton")
	local StopDefAnimsButton = Instance.new("ImageButton")
	local StopAnimsEvent = Instance.new("BindableEvent") -- To stop animations when disabling StopDefaultAnims option
	local PauseAnimateButton = Instance.new("ImageButton")
	local SitButton = Instance.new("ImageButton")

	local SettingsFrame = Instance.new("Frame")

	if theme == "LightOrange" then
		BgColor = Color3.fromRGB(255, 171, 35)
		ScrollBgColor = Color3.fromRGB(219, 244, 255)
		UiButColor = Color3.new(0, 0, 0)
		ButtonCol = Color3.fromRGB(192, 191, 211)
		ButtonSelectCol = Color3.fromRGB(255, 255, 255)
	elseif theme == "LightPurple" then
		BgColor = Color3.fromRGB(137, 165, 255)
		ScrollBgColor = Color3.fromRGB(219, 244, 255)
		UiButColor = Color3.new(0, 0, 0)
		ButtonCol = Color3.fromRGB(192, 191, 211)
		ButtonSelectCol = Color3.fromRGB(255, 255, 255)
	elseif theme == "LightYellow" then
		BgColor = Color3.fromRGB(255, 250, 112)
		ScrollBgColor = Color3.fromRGB(219, 244, 255)
		UiButColor = Color3.new(0, 0, 0)
		ButtonCol = Color3.fromRGB(192, 191, 211)
		ButtonSelectCol = Color3.fromRGB(255, 255, 255)
	elseif theme == "Black" then
		BgColor = Color3.fromRGB(65, 65, 65)
		ScrollBgColor = Color3.fromRGB(20, 20, 20)
		UiButColor = Color3.new(1, 1, 1)
		ButtonCol = Color3.fromRGB(65, 65, 65)
		ButtonSelectCol = Color3.fromRGB(129, 129, 129)
	end

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
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left

			local UIPadding = Instance.new("UIPadding")
			UIPadding.PaddingLeft = UDim.new(0, 2)
			UIPadding.PaddingRight = UDim.new(0, 2)
			UIPadding.PaddingBottom = UDim.new(0, 2)
			UIPadding.Parent = TextLabel

			local UISizeConstraint = Instance.new("UISizeConstraint")
			UISizeConstraint.Parent = TextLabel
			UISizeConstraint.MaxSize = Vector2.new(300, 3000)

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

		Button.BackgroundColor3 = ButtonCol

		Button.FontFace.Weight = Enum.FontWeight.Bold
		Button.Size = UDim2.new(0, 100, 0, 30)
		Button.TextColor3 = UiButColor
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
					Humanoid = Character:FindFirstChild("Humanoid")
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

	local function PlayAnim(Object, ID, FadeTime, Speed, Type, LoopedVal, NeedPause) -- Types Tutorial on Emotes section
		Object:SetAttribute("Looped", LoopedVal)
		if LoopedVal == false then
			AddHoverText(Object, "Click RMB to loop")
		end

		local Anim = Instance.new("Animation")
		Anim.Name = "AAnimation"
		Anim.AnimationId = "rbxassetid://"..ID
		local track = Player.Character:WaitForChild("Humanoid"):LoadAnimation(Anim)
		if Type:find("PriorLow") then
			track.Priority = Enum.AnimationPriority.Action3
		elseif Type:find("PriorHigh") then
			track.Priority = Enum.AnimationPriority.Action4
		end		

		local AnimSpeed = nil
		local PauseAnimsOption = false
		local SwitchModeFactor = false
		local AnimACTIVE = false

		Object.MouseButton1Click:connect(function()
			AnimACTIVE = not AnimACTIVE
			if AnimACTIVE then

				if AnimSwitchMode == true then
					SwitchModeFactor = true
					StopAnimsEvent:Fire()
					AnimACTIVE = true
				end

				local CurLooped = Object:GetAttribute("Looped")
				if CurLooped == false then
					track.Looped = false
				elseif CurLooped == true then
					track.Looped = true
				end

				if AnimSmoothFade == true then
					track:Play(FadeTime, 1, Speed + SpeedNum)
				else
					track:Play(0, 1, Speed + SpeedNum)
				end

				if PauseAnimsOption then
					track:AdjustSpeed(0)
				end
				AnimSpeed = Speed + SpeedNum
				ViewportFrame.Visible = false
				Object.BackgroundColor3 = ButtonSelectCol
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
				if AnimSmoothFade == false then
					track:Stop(0)
				end
				track:Stop()
				Object.BackgroundColor3 = ButtonCol
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
					track:Play(FadeTime, 1, Speed + SpeedNum)
					if PauseAnimsOption then
						track:AdjustSpeed(0)
					end
					AnimSpeed = Speed + SpeedNum
					ViewportFrame.Visible = false
					Object.BackgroundColor3 = ButtonSelectCol
					Object.UIStroke.Thickness = 2
					Object.UIStroke.Color = Color3.new(0.972549, 0.670588, 0.0627451)
					CurSpeedText.Text = Speed + SpeedNum

				else
					track:Stop()
					track.Looped = false
					Object.BackgroundColor3 = ButtonCol
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
				PauseAnimsButton.BackgroundColor3 = ButtonSelectCol
			else
				track:AdjustSpeed(AnimSpeed)
				PauseAnimsButton.BackgroundColor3 = ButtonCol
			end
		end)

		track.Ended:connect(function()
			AnimACTIVE = false
			Object.BackgroundColor3 = ButtonCol
			Object.UIStroke.Thickness = 1
			Object.UIStroke.Color = Color3.new(0, 0, 0)
			CurSpeedText.Text = ""
		end)

		StopAnimsEvent.Event:Connect(function()
			if SwitchModeFactor == true then 
				SwitchModeFactor = false	
				return 
			end
			CurSpeedText.Text = ""
			AnimACTIVE = false
			PauseAnimsOption = false
			track:Stop()
			Object.BackgroundColor3 = ButtonCol
			Object.UIStroke.Thickness = 1
			Object.UIStroke.Color = Color3.new(0, 0, 0)
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
				VPFtrack:Stop()
			end
		end)
	end


	-- Creating Objects
	-- SideFrame
	Emoter.Name = "Emoter"
	Emoter.ResetOnSpawn = false
	if game:GetService("RunService"):IsStudio() then --Made this as i test script mostly in Studio
		Emoter.Parent = game.Players.LocalPlayer.PlayerGui
		Emoter.DisplayOrder = 100
	else
		Emoter.Parent = game.CoreGui
		Emoter.DisplayOrder = -1
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

	SideFrameTitle.Name = "SideFrameTitle"
	SideFrameTitle.Parent = SideFrame
	SideFrameTitle.AnchorPoint = Vector2.new(0.5, 0.5)
	SideFrameTitle.BackgroundTransparency = 1
	SideFrameTitle.Position = UDim2.new(0.5, 0, 0.5, 0)
	SideFrameTitle.Size = UDim2.new(0, 119, 0, 31)
	SideFrameTitle.Font = Enum.Font.SourceSansBold
	SideFrameTitle.TextColor3 = Color3.new(1, 1, 1)
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

	OpenGUI.Name = "OpenGUI"
	OpenGUI.Parent = SideFrame
	OpenGUI.AnchorPoint = Vector2.new(0, 0.5)
	OpenGUI.BackgroundTransparency = 0
	OpenGUI.BackgroundColor3 = BgColor
	OpenGUI.Position = UDim2.new(0, 0, 0.5, 0)
	OpenGUI.Size = UDim2.new(0, 32, 0, 32)
	OpenGUI.Image = "rbxassetid://101249930107274"
	OpenGUI.ImageColor3 = UiButColor
	AddHoverText(OpenGUI, "Open/Close GUI")


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


	-- GuiTopFrame
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
	CloseGUI.Image = "rbxassetid://105612912027138"
	CloseGUI.ImageColor3 = UiButColor
	AddHoverText(CloseGUI, "Open/Close GUI")

	local SettingsButton = Instance.new("ImageButton")
	SettingsButton.Parent = GuiTopFrame
	SettingsButton.Name = "SettingsButton"
	SettingsButton.AnchorPoint = Vector2.new(1, 0.5)
	SettingsButton.Size = UDim2.new(0, 32, 0, 32)
	SettingsButton.Position = UDim2.new(1, -32, 0.5, 0)
	SettingsButton.BackgroundColor3 = BgColor
	SettingsButton.ImageColor3 = UiButColor
	SettingsButton.Image = "rbxassetid://129555881355020"
	AddHoverText(SettingsButton, "Settings")

	Title.Name = "Title"
	Title.Parent = GuiTopFrame
	Title.AnchorPoint = Vector2.new(0.5, 0.5)
	Title.Position = UDim2.new(0.5, 0, 0.5, 0)
	Title.BackgroundColor3 = Color3.new(1, 1, 1)
	Title.BackgroundTransparency = 1
	Title.Size = UDim2.new(0, 119, 0, 31)
	Title.Text = "Emotes GUI"
	Title.Font = Enum.Font.SourceSansBold
	Title.TextColor3 = Color3.new(1, 1, 1)
	Title.TextSize = 24
	Title.TextStrokeTransparency = 0
	Title.TextWrapped = false


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

	local SFLayout = Instance.new("UIGridLayout")
	SFLayout.Name = "UIGridLayout"
	SFLayout.Parent = SpeedFrame
	SFLayout.FillDirection = Enum.FillDirection.Vertical
	SFLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SFLayout.CellSize = UDim2.new(0, 90, 0, 31)
	SFLayout.VerticalAlignment = Enum.VerticalAlignment.Center

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
	CurSpeedText.Font = Enum.Font.SourceSansBold
	CurSpeedText.TextScaled = true
	CurSpeedText.Parent = GuiBottomFrame
	AddHoverText(CurSpeedText, "Current anim speed")
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
	ScrollingFrame.ScrollBarImageColor3 = UiButColor
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

	ScrollingFrameR15.Name = "ScrollingFrameR15"
	ScrollingFrameR15.Parent = MainFrame
	ScrollingFrameR15.BackgroundColor3 = ScrollBgColor
	ScrollingFrameR15.Position = UDim2.new(0, 0, 0, 34)
	ScrollingFrameR15.ScrollBarImageColor3 = UiButColor
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


	--Options Frame
	OptionsFrame.Parent = MainFrame
	OptionsFrame.Name = "OptionsFrame"
	OptionsFrame.AnchorPoint = Vector2.new(0.5, 0)
	OptionsFrame.Size = UDim2.new(0, 178, 0, 46)
	OptionsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	OptionsFrame.Visible = false
	OptionsFrame.Position = UDim2.new(0.5, 0, 1, -43)
	OptionsFrame.BorderSizePixel = 0
	OptionsFrame.BackgroundColor3 = ScrollBgColor
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
	PauseAnimsButton.BackgroundColor3 = ButtonCol
	PauseAnimsButton.Image = "rbxassetid://103681828169035"
	PauseAnimsButton.Parent = OptionsFrame
	PauseAnimsButton.ZIndex = 0
	AddHoverText(PauseAnimsButton, "Pause ALL Anims")

	StopDefAnimsButton.Name = "StopDefAnimsButton"
	StopDefAnimsButton.Size = UDim2.new(0, 100, 0, 100)
	StopDefAnimsButton.BorderSizePixel = 0
	StopDefAnimsButton.BackgroundColor3 = ButtonCol
	StopDefAnimsButton.Image = "rbxassetid://116957047917442"
	StopDefAnimsButton.Parent = OptionsFrame
	StopDefAnimsButton.ZIndex = 0
	AddHoverText(StopDefAnimsButton, "Stop Default Anims. May not work on some games")

	PauseAnimateButton.Name = "PauseAnimateButton"
	PauseAnimateButton.Size = UDim2.new(0, 100, 0, 100)
	PauseAnimateButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	PauseAnimateButton.BorderSizePixel = 0
	PauseAnimateButton.BackgroundColor3 = ButtonCol
	PauseAnimateButton.Image = "rbxassetid://109849420482663"
	PauseAnimateButton.Parent = OptionsFrame
	PauseAnimateButton.ZIndex = 0
	AddHoverText(PauseAnimateButton, "Pause Default Animate Script (will look like you're lagging)")

	SitButton.Name = "SitButton"
	SitButton.Size = UDim2.new(0, 100, 0, 100)
	SitButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SitButton.BorderSizePixel = 0
	SitButton.BackgroundColor3 = ButtonCol
	SitButton.Image = "rbxassetid://94572819761865"
	SitButton.ImageColor3 = UiButColor
	SitButton.Parent = OptionsFrame
	SitButton.ZIndex = 0
	AddHoverText(SitButton, "Ragdoll-like falling with sit animation (G)")


	--Search Box
	SearchFrame.Parent = MainFrame
	SearchFrame.Name = "SearchFrame"
	SearchFrame.ZIndex = 0
	SearchFrame.AnchorPoint = Vector2.new(1, 0)
	SearchFrame.Size = UDim2.new(0, 164, 0, 35)
	SearchFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchFrame.Position = UDim2.new(1, 31, 0.119, 0)
	SearchFrame.BorderSizePixel = 0
	SearchFrame.BackgroundColor3 = BgColor

	SearchButton.Name = "SearchButton"
	SearchButton.ZIndex = 0
	SearchButton.AnchorPoint = Vector2.new(1, 0)
	SearchButton.Size = UDim2.new(0, 30, 1, 0)
	SearchButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchButton.LayoutOrder = 2
	SearchButton.Position = UDim2.new(1, 0, 0.075, 0)
	SearchButton.BorderSizePixel = 0
	SearchButton.BackgroundColor3 = BgColor
	SearchButton.ScaleType = Enum.ScaleType.Fit
	SearchButton.Image = "rbxassetid://118685771787843"
	SearchButton.ImageColor3 = UiButColor
	SearchButton.Parent = SearchFrame
	AddHoverText(SearchButton, "Search (T)")

	SearchBox.Name = "SearchBox"
	SearchBox.ZIndex = 0
	SearchBox.Visible = false
	SearchBox.AnchorPoint = Vector2.new(0.5, 0)
	SearchBox.Size = UDim2.new(0, 140, 0, 29)
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

	BackButton.Name = "BackButton"
	BackButton.ZIndex = 0
	BackButton.Visible = false
	BackButton.AnchorPoint = Vector2.new(1, 0)
	BackButton.Size = UDim2.new(0, 19, 1, 0)
	BackButton.BorderSizePixel = 0
	BackButton.LayoutOrder = 0
	BackButton.Position = UDim2.new(1, 0, 0, 0)
	BackButton.BackgroundColor3 = BgColor
	BackButton.ScaleType = Enum.ScaleType.Crop
	BackButton.Image = "rbxassetid://2418687610"
	BackButton.ImageColor3 = UiButColor
	BackButton.Parent = SearchFrame
	AddHoverText(BackButton, "Hide")

	local SFUIListLayout = Instance.new("UIListLayout")
	SFUIListLayout.FillDirection = Enum.FillDirection.Horizontal
	SFUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	SFUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	SFUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SFUIListLayout.Padding = UDim.new(0, 1)
	SFUIListLayout.Parent = SearchFrame


	--CustomAnimFrame
	local CustomAnimFrame = Instance.new("Frame")
	CustomAnimFrame.Parent = MainFrame
	CustomAnimFrame.Name = "CustomAnimFrame"
	CustomAnimFrame.ZIndex = 0
	CustomAnimFrame.AnchorPoint = Vector2.new(1, 0)
	CustomAnimFrame.Size = UDim2.new(0, 194, 0, 35)
	CustomAnimFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CustomAnimFrame.Position = UDim2.new(1, 31, 0.119, 39)
	CustomAnimFrame.BorderSizePixel = 0
	CustomAnimFrame.BackgroundColor3 = BgColor

	local CustomAnimButton = Instance.new("ImageButton")
	CustomAnimButton.Name = "CustomAnimButton"
	CustomAnimButton.ZIndex = 0
	CustomAnimButton.Visible = true
	CustomAnimButton.AnchorPoint = Vector2.new(1, 0)
	CustomAnimButton.Size = UDim2.new(0, 30, 1, 0)
	CustomAnimButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CustomAnimButton.LayoutOrder = 2
	CustomAnimButton.Position = UDim2.new(1.4484849, 0, 0.9714286, 0)
	CustomAnimButton.BorderSizePixel = 0
	CustomAnimButton.BackgroundColor3 = BgColor
	CustomAnimButton.ScaleType = Enum.ScaleType.Fit
	CustomAnimButton.Image = "rbxassetid://74724767412656"
	CustomAnimButton.ImageColor3 = UiButColor
	CustomAnimButton.Parent = CustomAnimFrame
	AddHoverText(CustomAnimButton, "Play animation with Id")

	local IdBox = Instance.new("TextBox")
	IdBox.Name = "IdBox"
	IdBox.ZIndex = 0
	IdBox.Visible = false
	IdBox.AnchorPoint = Vector2.new(0.5, 0)
	IdBox.Size = UDim2.new(0, 140, 0, 29)
	IdBox.LayoutOrder = 1
	IdBox.Position = UDim2.new(0.469697, 0, 0.075, 0)
	IdBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	IdBox.TextWrapped = true
	IdBox.TextColor3 = Color3.fromRGB(0, 0, 0)
	IdBox.PlaceholderText = "Enter Id..."
	IdBox.Text = ""
	IdBox.CursorPosition = -1
	IdBox.Font = Enum.Font.SourceSans
	IdBox.TextXAlignment = Enum.TextXAlignment.Left
	IdBox.ClearTextOnFocus = false
	IdBox.TextScaled = true
	IdBox.Parent = CustomAnimFrame

	local CustomAnimBackButton = Instance.new("ImageButton")
	CustomAnimBackButton.Name = "CustomAnimBackButton"
	CustomAnimBackButton.ZIndex = 0
	CustomAnimBackButton.Visible = false
	CustomAnimBackButton.AnchorPoint = Vector2.new(1, 0)
	CustomAnimBackButton.Size = UDim2.new(0, 19, 1, 0)
	CustomAnimBackButton.BorderSizePixel = 0
	CustomAnimBackButton.Position = UDim2.new(0.1212121, 0, 0, 0)
	CustomAnimBackButton.BackgroundColor3 = BgColor
	CustomAnimBackButton.ScaleType = Enum.ScaleType.Crop
	CustomAnimBackButton.ImageColor3 = UiButColor
	CustomAnimBackButton.Image = "rbxassetid://2418687610"
	CustomAnimBackButton.Parent = CustomAnimFrame
	AddHoverText(CustomAnimBackButton, "Hide")

	local CAFUIListLayout = Instance.new("UIListLayout")
	CAFUIListLayout.FillDirection = Enum.FillDirection.Horizontal
	CAFUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	CAFUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	CAFUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	CAFUIListLayout.Padding = UDim.new(0, 1)
	CAFUIListLayout.Parent = CustomAnimFrame

	local PlayAnimButton = Instance.new("ImageButton")
	PlayAnimButton.Name = "PlayAnimButton"
	PlayAnimButton.ZIndex = 0
	PlayAnimButton.Visible = false
	PlayAnimButton.AnchorPoint = Vector2.new(1, 0)
	PlayAnimButton.Size = UDim2.new(0.0103627, 30, 1, 0)
	PlayAnimButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	PlayAnimButton.LayoutOrder = 3
	PlayAnimButton.Position = UDim2.new(1, 0, 0, 0)
	PlayAnimButton.BorderSizePixel = 0
	PlayAnimButton.BackgroundColor3 = ButtonCol
	PlayAnimButton.ScaleType = Enum.ScaleType.Fit
	PlayAnimButton.ImageColor3 = UiButColor
	PlayAnimButton.Image = "rbxassetid://8215093320"
	PlayAnimButton.Parent = CustomAnimFrame
	AddHoverText(PlayAnimButton, "Play animation")


	--SettingsFrame
	SettingsFrame.Parent = Emoter
	SettingsFrame.Name = "SettingsFrame"
	SettingsFrame.AnchorPoint = Vector2.new(0.5, 0)
	SettingsFrame.Size = UDim2.new(0, 193, 0, 286)
	SettingsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SettingsFrame.Position = MainFrame.Position + UDim2.new(0, 575, 0, 0)
	SettingsFrame.BorderSizePixel = 0
	SettingsFrame.BackgroundColor3 = ScrollBgColor
	SettingsFrame.Visible = false

	local UIShadow = Instance.new("UIShadow")
	UIShadow.BlurRadius = UDim.new(0, 20)
	UIShadow.Transparency = 0.5
	UIShadow.Parent = SettingsFrame

	local UIDragDetector = Instance.new("UIDragDetector")
	UIDragDetector.DragUDim2 = UDim2.new(0, -89, 0, 32)
	UIDragDetector.Parent = SettingsFrame

	local GuiName = Instance.new("TextLabel")
	GuiName.Name = "Name"
	GuiName.Size = UDim2.new(1, 0, 0.0022999, 25)
	GuiName.BackgroundTransparency = 1
	GuiName.Position = UDim2.new(0, 0, 0.0175439, 0)
	GuiName.TextSize = 14
	GuiName.Text = "Emoter GUI"
	GuiName.Font = Enum.Font.Highway
	GuiName.TextScaled = true
	GuiName.TextColor3 = UiButColor
	GuiName.Parent = SettingsFrame

	local AutorText = Instance.new("TextLabel")
	AutorText.Name = "AutorText"
	AutorText.Size = UDim2.new(1, 0, -0.025, 25)
	AutorText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	AutorText.LayoutOrder = 1
	AutorText.BackgroundTransparency = 1
	AutorText.Position = UDim2.new(-0.0069782, 0, 0.0940293, 0)
	AutorText.BorderSizePixel = 0
	AutorText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	AutorText.TextColor3 = Color3.new(0, 0, 0)
	AutorText.TextSize = 14
	AutorText.Text = "by Fixel"
	AutorText.Font = Enum.Font.SourceSans
	AutorText.TextScaled = true
	AutorText.TextColor3 = UiButColor
	AutorText.Parent = SettingsFrame

	local SettingsStuff = Instance.new("Frame")
	SettingsStuff.Name = "SettingsStuff"
	SettingsStuff.Size = UDim2.new(1, 0, 0.8196392, 0)
	SettingsStuff.BackgroundTransparency = 1
	SettingsStuff.Position = UDim2.new(0, 0, 0.1803608, 0)
	SettingsStuff.BorderSizePixel = 0
	SettingsStuff.Parent = SettingsFrame

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = SettingsStuff

	local function AddSettings(Setting, Title, Text, LayoutOrder)
		local OptionButton = Instance.new("TextButton")
		OptionButton.Name = Title
		OptionButton.Size = UDim2.new(1, 0, 0, 25)
		OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionButton.BackgroundTransparency = 1
		OptionButton.LayoutOrder = LayoutOrder
		OptionButton.Position = UDim2.new(0, 0, 0.1558714, 0)
		OptionButton.BorderSizePixel = 0
		OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionButton.TextSize = 14
		OptionButton.Font = Enum.Font.SourceSans
		OptionButton.TextTransparency = 1
		OptionButton.Parent = SettingsStuff

		local CheckImage = Instance.new("ImageLabel")
		CheckImage.Name = "CheckImage"
		CheckImage.AnchorPoint = Vector2.new(0, 0.5)
		CheckImage.Size = UDim2.new(0, 15, 0, 15)
		CheckImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
		CheckImage.Position = UDim2.new(0, 0, 0.5, 0)
		CheckImage.BorderSizePixel = 1
		CheckImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		CheckImage.Image = "rbxassetid://130396712201457"
		CheckImage.ImageColor3 = Color3.fromRGB(0, 0, 0)
		CheckImage.Parent = OptionButton
		if Setting == true then
			CheckImage.Image = "rbxassetid://130396712201457"
		else
			CheckImage.Image = ""
		end

		local UIStroke = Instance.new("UIStroke")
		UIStroke.Parent = CheckImage

		local UIListLayout1 = Instance.new("UIListLayout")
		UIListLayout1.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout1.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout1.Padding = UDim.new(0, 5)
		UIListLayout1.Parent = OptionButton

		local TextLabel = Instance.new("TextLabel")
		TextLabel.Size = UDim2.new(0.9500334, -10, 0, 25)
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Position = UDim2.new(0.115608, 0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel.TextColor3 = UiButColor
		TextLabel.TextSize = 14
		TextLabel.Text = Text
		TextLabel.Font = Enum.Font.SourceSans
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.Parent = OptionButton

		local UIPadding1 = Instance.new("UIPadding")
		UIPadding1.PaddingBottom = UDim.new(0, 2)
		UIPadding1.Parent = TextLabel

	end

	AddSettings(ToolAnimHighPrior, "ToolPriorityOption", "High priority on Tool anims", 0)
	AddSettings(AnimPreviewEnable, "PreviewOption", "Enable Animation Preview", 1)
	AddSettings(AnimSwitchMode, "SwitchOption", "Anims Switch mode", 2)
	AddSettings(AnimSmoothFade, "AnimFadeOption", "Anim smooth Start/Stop", 3)
	AddSettings(HotkeysEnabled, "HotkeysOption", "Enable Hotkeys", 5)

	local ThemeOption = Instance.new("Frame")
	ThemeOption.Name = "ThemeOption"
	ThemeOption.Size = UDim2.new(1, 0, 0, 25)
	ThemeOption.LayoutOrder = 4
	ThemeOption.BackgroundTransparency = 1
	ThemeOption.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ThemeOption.Parent = SettingsStuff

	local UIListLayout5 = Instance.new("UIListLayout")
	UIListLayout5.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout5.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout5.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout5.Padding = UDim.new(0, 5)
	UIListLayout5.Parent = ThemeOption

	local ThemeOptionText = Instance.new("TextLabel")
	ThemeOptionText.Name = "ThemeOptionText"
	ThemeOptionText.Size = UDim2.new(0.6, -10, 0, 25)
	ThemeOptionText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ThemeOptionText.BackgroundTransparency = 1
	ThemeOptionText.BorderSizePixel = 0
	ThemeOptionText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ThemeOptionText.TextSize = 14
	ThemeOptionText.TextColor3 = UiButColor
	ThemeOptionText.Text = "Theme"
	ThemeOptionText.Font = Enum.Font.SourceSans
	ThemeOptionText.TextXAlignment = Enum.TextXAlignment.Left
	ThemeOptionText.Parent = ThemeOption
	AddHoverText(ThemeOption, "Change theme of Gui (Restart required)")

	local PurpleThemeColor = Instance.new("TextButton")
	PurpleThemeColor.Name = "PurpleThemeColor"
	PurpleThemeColor.Size = UDim2.new(0, 15, 0, 15)
	PurpleThemeColor.BorderColor3 = Color3.fromRGB(0, 0, 0)
	PurpleThemeColor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	PurpleThemeColor.Text = ""
	PurpleThemeColor.Parent = ThemeOption
	AddHoverText(PurpleThemeColor, "Light theme with purple parts")

	local PurpleGradient = Instance.new("UIGradient")
	PurpleGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(137, 165, 255)), ColorSequenceKeypoint.new(0.4342561, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))})
	PurpleGradient.Rotation = 90
	PurpleGradient.Parent = PurpleThemeColor

	local OrangeThemeColor = Instance.new("TextButton")
	OrangeThemeColor.Name = "OrangeThemeColor"
	OrangeThemeColor.Size = UDim2.new(0, 15, 0, 15)
	OrangeThemeColor.BorderColor3 = Color3.fromRGB(0, 0, 0)
	OrangeThemeColor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	OrangeThemeColor.Text = ""
	OrangeThemeColor.Parent = ThemeOption
	AddHoverText(OrangeThemeColor, "Light theme with orange parts")

	local OrangeGradient = Instance.new("UIGradient")
	OrangeGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 171, 35)), ColorSequenceKeypoint.new(0.4342561, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))})
	OrangeGradient.Rotation = 90
	OrangeGradient.Parent = OrangeThemeColor

	local YellowThemeColor = Instance.new("TextButton")
	YellowThemeColor.Name = "YellowThemeColor"
	YellowThemeColor.Size = UDim2.new(0, 15, 0, 15)
	YellowThemeColor.BorderColor3 = Color3.fromRGB(0, 0, 0)
	YellowThemeColor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	YellowThemeColor.Text = ""
	YellowThemeColor.Parent = ThemeOption
	AddHoverText(YellowThemeColor, "Light theme with yellow parts")

	local YellowGradient = Instance.new("UIGradient")
	YellowGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 250, 112)), ColorSequenceKeypoint.new(0.4342561, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))})
	YellowGradient.Rotation = 90
	YellowGradient.Parent = YellowThemeColor

	local BlackThemeColor = Instance.new("TextButton")
	BlackThemeColor.Name = "BlackThemeColor"
	BlackThemeColor.Size = UDim2.new(0, 15, 0, 15)
	BlackThemeColor.LayoutOrder = 1
	BlackThemeColor.BorderColor3 = UiButColor
	BlackThemeColor.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
	BlackThemeColor.Text = ""
	BlackThemeColor.Parent = ThemeOption
	AddHoverText(BlackThemeColor, "Black theme")

	local HotkeysEditOption = Instance.new("TextButton")
	HotkeysEditOption.Name = "HotkeysEditOption"
	HotkeysEditOption.Size = UDim2.new(0.55, 0, 0, 22)
	HotkeysEditOption.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HotkeysEditOption.LayoutOrder = 5
	HotkeysEditOption.Position = UDim2.new(0, 0, 0.1558714, 0)
	HotkeysEditOption.BorderSizePixel = 0
	HotkeysEditOption.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HotkeysEditOption.TextColor3 = Color3.new(0, 0, 0)
	HotkeysEditOption.TextSize = 14
	HotkeysEditOption.Text = "Edit Hotkeys..."
	HotkeysEditOption.Font = Enum.Font.SourceSans
	HotkeysEditOption.Parent = SettingsStuff

	local UIListLayout7 = Instance.new("UIListLayout")
	UIListLayout7.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout7.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout7.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout7.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout7.Padding = UDim.new(0, 5)
	UIListLayout7.Parent = HotkeysEditOption

	local HotkeysFrame = Instance.new("Frame")
	HotkeysFrame.Name = "HotkeysFrame"
	HotkeysFrame.AnchorPoint = Vector2.new(0.5, 0)
	HotkeysFrame.Size = UDim2.new(0, 193, 0, 285)
	HotkeysFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HotkeysFrame.Position = UDim2.new(0.517, 199, -0.1859649, 53)
	HotkeysFrame.BorderSizePixel = 0
	HotkeysFrame.BackgroundColor3 = ScrollBgColor
	HotkeysFrame.Visible = false
	HotkeysFrame.Parent = SettingsFrame

	local HotkeysStuff = Instance.new("Frame")
	HotkeysStuff.Name = "HotkeysStuff"
	HotkeysStuff.Size = UDim2.new(1, 0, 0.8801966, 0)
	HotkeysStuff.BackgroundTransparency = 1
	HotkeysStuff.Position = UDim2.new(0, 0, 0.1198031, 0)
	HotkeysStuff.Parent = HotkeysFrame

	local UIListLayout8 = Instance.new("UIListLayout")
	UIListLayout8.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout8.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout8.Parent = HotkeysStuff

	local HotkeyFrameName = Instance.new("TextLabel")
	HotkeyFrameName.Name = "Name"
	HotkeyFrameName.Size = UDim2.new(1, 0, 0.0022999, 25)
	HotkeyFrameName.BackgroundTransparency = 1
	HotkeyFrameName.Position = UDim2.new(0, 0, 0.0175439, 0)
	HotkeyFrameName.TextColor3 = UiButColor
	HotkeyFrameName.TextSize = 14
	HotkeyFrameName.Text = "Hotkeys"
	HotkeyFrameName.TextWrapped = true
	HotkeyFrameName.Font = Enum.Font.Highway
	HotkeyFrameName.TextScaled = true
	HotkeyFrameName.Parent = HotkeysFrame

	local function AddHotkey(Hotkey, FrameName, Text)
		local HotkeyFrame = Instance.new("Frame")
		HotkeyFrame.Name = FrameName
		HotkeyFrame.Size = UDim2.new(1, 0, 0, 25)
		HotkeyFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		HotkeyFrame.BackgroundTransparency = 1
		HotkeyFrame.BorderSizePixel = 0
		HotkeyFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		HotkeyFrame.Parent = HotkeysStuff

		local HotkeyText = Instance.new("TextLabel")
		HotkeyText.Size = UDim2.new(0.8241132, -10, 0, 25)
		HotkeyText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		HotkeyText.BackgroundTransparency = 1
		HotkeyText.BorderSizePixel = 0
		HotkeyText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		HotkeyText.TextColor3 = UiButColor
		HotkeyText.TextSize = 14
		HotkeyText.Text = Text
		HotkeyText.TextWrapped = true
		HotkeyText.Font = Enum.Font.SourceSans
		HotkeyText.TextXAlignment = Enum.TextXAlignment.Left
		HotkeyText.Parent = HotkeyFrame

		local UIPadding9 = Instance.new("UIPadding")
		UIPadding9.PaddingBottom = UDim.new(0, 2)
		UIPadding9.Parent = HotkeyText

		local RebindButton = Instance.new("TextButton")
		RebindButton.AnchorPoint = Vector2.new(1, 0.5)
		RebindButton.Size = UDim2.new(0.234, 0, 0, 21)
		RebindButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		RebindButton.Position = UDim2.new(1, 0, 0.5, 0)
		RebindButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		RebindButton.TextColor3 = Color3.new(0, 0, 0)
		RebindButton.TextSize = 14
		RebindButton.Text = Hotkey.Value or "..."
		RebindButton.Font = Enum.Font.SourceSans
		RebindButton.Parent = HotkeyFrame

		local isListening = false

		RebindButton.MouseButton1Click:Connect(function()
			if isListening then return end

			isListening = true
			RebindButton.Text = "..."
		end)

		UserInputService.InputBegan:Connect(function(input, gameProcessed)

			if gameProcessed then return end 

			if isListening then
				if input.UserInputType == Enum.UserInputType.Keyboard then
					if input.KeyCode.Name == "Backspace" then
						Hotkey.Value = nil
						isListening = false
						RebindButton.Text = "..."
						return
					end
					Hotkey.Value = tostring(input.KeyCode.Name)
					isListening = false
					RebindButton.Text = Hotkey.Value
					print(Hotkey.Value)
				end
				return
			end

			--[[local function performCustomAction()
				print("Keybind activated! Key pressed: " .. Hotkey.Value)
			end
			if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Hotkey then
				performCustomAction()
			end]]
		end)
	end

	AddHotkey(SearchHotkey, "SearchHotkey", "Search")
	AddHotkey(CloseHotkey, "CloseHotkey", "Close/Open Gui")
	AddHotkey(SitHotkey, "SitHotkey", "Ragdoll-like falling")
	AddHotkey(SettingsHotkey, "SettingsHotkey", "Open Settings")
	--[[AddHotkey(SwitchAnimHotkey, "SwitchAnimHotkey", "Switch Anim Setting")
	AddHotkey(AnimFadeHotkey, "AnimFadeHotkey", "Animation Fade Setting")]]

	local MoreButtonsFrame = Instance.new("Frame")
	MoreButtonsFrame.Parent = SettingsFrame
	MoreButtonsFrame.Name = "MoreButtonsFrame"
	MoreButtonsFrame.Interactable = true
	MoreButtonsFrame.AnchorPoint = Vector2.new(0, 1)
	MoreButtonsFrame.Size = UDim2.new(1, 0, 0, 50)
	MoreButtonsFrame.BackgroundTransparency = 1
	MoreButtonsFrame.Position = UDim2.new(0, 0, 1, 0)
	MoreButtonsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 12)
	UIListLayout.Parent = MoreButtonsFrame

	local SaveSettingsButton = Instance.new("ImageButton")
	SaveSettingsButton.Name = "SaveSettingsButton"
	SaveSettingsButton.Size = UDim2.new(0, 35, 0, 35)
	SaveSettingsButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SaveSettingsButton.Position = UDim2.new(0.0518135, 0, 0.845614, 0)
	SaveSettingsButton.BorderSizePixel = 0
	SaveSettingsButton.BackgroundColor3 = ButtonCol
	SaveSettingsButton.Image = "rbxassetid://11768914234"
	SaveSettingsButton.ImageColor3 = UiButColor
	SaveSettingsButton.Parent = MoreButtonsFrame
	AddHoverText(SaveSettingsButton, "Save settings")

	local LaunchIdDetectorButton = Instance.new("ImageButton")
	LaunchIdDetectorButton.Name = "LaunchIdDetectorButton"
	LaunchIdDetectorButton.Size = UDim2.new(0, 35, 0, 35)
	LaunchIdDetectorButton.Position = UDim2.new(0.4093264, 0, 0.845614, 0)
	LaunchIdDetectorButton.BackgroundColor3 = ButtonCol
	LaunchIdDetectorButton.ImageColor3 = UiButColor
	LaunchIdDetectorButton.Image = "rbxassetid://88751076321975"
	LaunchIdDetectorButton.Parent = MoreButtonsFrame
	AddHoverText(LaunchIdDetectorButton, "Launch IdDetector Script")

	local ResetButton = Instance.new("ImageButton")
	ResetButton.Parent = MoreButtonsFrame
	ResetButton.Name = "ResetButton"
	ResetButton.Size = UDim2.new(0, 35, 0, 35)
	ResetButton.Position = UDim2.new(0.2487047, 0, 0.8561404, 0)
	ResetButton.BackgroundColor3 = ButtonCol
	ResetButton.Image = "rbxassetid://84090157888894"
	ResetButton.ImageColor3 = UiButColor
	AddHoverText(ResetButton, "Reset Gui")

	local GithubLinkButton = Instance.new("ImageButton")
	GithubLinkButton.Name = "GithubLinkButton"
	GithubLinkButton.Size = UDim2.new(0, 35, 0, 35)
	GithubLinkButton.Position = UDim2.new(0.7720207, 0, 0.845614, 0)
	GithubLinkButton.BackgroundColor3 = ButtonCol
	GithubLinkButton.Image = "rbxassetid://133448000957069"
	GithubLinkButton.ImageColor3 = UiButColor
	GithubLinkButton.Parent = MoreButtonsFrame
	AddHoverText(GithubLinkButton, "Get the Github for Tutorials and more Info! (Copy Link)")


	-- Buttons and other functions
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
	SettingsButton.MouseButton1Click:Connect(function()
		SettingsFrame.Visible = not SettingsFrame.Visible
	end)

	--Settings buttons
	local ToolAnimPriorityButton = SettingsStuff.ToolPriorityOption
	ToolAnimPriorityButton.MouseButton1Click:Connect(function()
		ToolAnimHighPrior = not ToolAnimHighPrior
		if ToolAnimHighPrior == true then
			ToolAnimPriorityButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			ToolAnimPriorityButton.CheckImage.Image = ""
		end
	end)

	local PreviewOptionButton = SettingsStuff.PreviewOption
	PreviewOptionButton.MouseButton1Click:Connect(function()
		AnimPreviewEnable = not AnimPreviewEnable
		if AnimPreviewEnable == true then
			PreviewOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			ViewportFrame.Visible = false
			PreviewOptionButton.CheckImage.Image = ""
		end
	end)

	local SwitchOptionButton = SettingsStuff.SwitchOption
	SwitchOptionButton.MouseButton1Click:Connect(function()
		AnimSwitchMode = not AnimSwitchMode
		if AnimSwitchMode == true then
			SwitchOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			SwitchOptionButton.CheckImage.Image = ""
		end
	end)

	local AnimFadeOptionButton = SettingsStuff.AnimFadeOption
	AnimFadeOptionButton.MouseButton1Click:Connect(function()
		AnimSmoothFade = not AnimSmoothFade
		if AnimSmoothFade == true then
			AnimFadeOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			AnimFadeOptionButton.CheckImage.Image = ""
		end
	end)

	local HotkeysOptionButton = SettingsStuff.HotkeysOption
	HotkeysOptionButton.MouseButton1Click:Connect(function()
		HotkeysEnabled = not HotkeysEnabled
		if HotkeysEnabled == true then
			HotkeysOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			HotkeysOptionButton.CheckImage.Image = ""
		end
	end)

	HotkeysEditOption.MouseButton1Click:Connect(function()
		HotkeysFrame.Visible = not HotkeysFrame.Visible
	end)

	PurpleThemeColor.MouseButton1Click:Connect(function()
		theme = "LightPurple"
	end)
	OrangeThemeColor.MouseButton1Click:Connect(function()
		theme = "LightOrange"
	end)
	YellowThemeColor.MouseButton1Click:Connect(function()
		theme = "LightYellow"
	end)
	BlackThemeColor.MouseButton1Click:Connect(function()
		theme = "Black"
	end)

	SaveSettingsButton.MouseButton1Click:Connect(function()
		print(1)
		local mySettings = {
			ConfAnimPreviewEnable = AnimPreviewEnable,
			ConfToolAnimHighPrior = ToolAnimHighPrior,
			ConfAnimSwitchMode = AnimSwitchMode,
			ConfAnimSmoothFade = AnimSmoothFade,
			ConfTheme = theme,
			ConfHotkeysEnabled = HotkeysEnabled,
			ConfSearchHotkey = SearchHotkey.Value,
			ConfCloseHotkey = CloseHotkey.Value,
			ConfSitHotkey = SitHotkey.Value,
			ConfSwitchAnimHotkey = SwitchAnimHotkey.Value,
			ConfAnimFadeHotkey = AnimFadeHotkey.Value,
			ConfSettingsHotkey = SettingsHotkey.Value
		}
		local encodedData = HttpService:JSONEncode(mySettings)
		writefile("EmoterData/"..ConfigFileName, encodedData)
		print(2)
	end)

	LaunchIdDetectorButton.MouseButton1Click:Connect(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Fixel656/Roblox-Emotes-GUI-Script-R6-R15/refs/heads/main/AnimationIdDetector.lua",true))()
	end)

	ResetButton.MouseButton1Click:Connect(function()
		OnRestart()
	end)

	GithubLinkButton.MouseButton1Click:Connect(function()
		setclipboard("https://github.com/Fixel656/Roblox-Emotes-GUI-Script-R6-R15/tree/main")
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


	--Searchbox
	local SearchButtonClick = true
	SearchButton.MouseButton1Click:Connect(function()
		if SearchButtonClick == true then
			SearchButtonClick = false
			SearchButton.Visible = false
			BackButton.Visible = true
			SearchBox.Visible = true
			SFUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
			game.TweenService:Create(SearchFrame, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Position = UDim2.new(1, 164, 0.119, 0)}):Play()
			wait(.3)
			SearchButtonClick = true
		end
	end)
	BackButton.MouseButton1Click:Connect(function()
		if SearchButtonClick == true then
			SearchButtonClick = false
			game.TweenService:Create(SearchFrame, TweenInfo.new(.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {Position = UDim2.new(1, 31, 0.119, 0)}):Play()
			wait(.2)
			SFUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
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
		SFUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		SearchFrame.Position = UDim2.new(1, 164, 0.119, 0)
	end

	SearchBox.Changed:Connect(function()
		for _, ScrollFrame in ipairs(ScrollingFramesList) do
			for _, Button in ipairs(ScrollFrame:GetDescendants()) do
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
		end
	end)


	--CustomAnimSearch
	local CustomAnimButtonClick = true
	CustomAnimButton.MouseButton1Click:Connect(function()
		if CustomAnimButtonClick == true then
			CustomAnimButtonClick = false
			CustomAnimButton.Visible = false
			CustomAnimBackButton.Visible = true
			IdBox.Visible = true
			PlayAnimButton.Visible = true
			CAFUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
			game.TweenService:Create(CustomAnimFrame, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Position = UDim2.new(1, 194, 0.119, 39)}):Play()
			wait(.3)
			CustomAnimButtonClick = true
		end
	end)
	CustomAnimBackButton.MouseButton1Click:Connect(function()
		if CustomAnimButtonClick == true then
			CustomAnimButtonClick = false
			game.TweenService:Create(CustomAnimFrame, TweenInfo.new(.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {Position = UDim2.new(1, 31, 0.119, 39)}):Play()
			wait(.2)
			CAFUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
			CustomAnimButton.Visible = true
			CustomAnimBackButton.Visible = false
			IdBox.Visible = false
			PlayAnimButton.Visible = false
			CustomAnimButtonClick = true
		end
	end)

	local CustomAnim = Instance.new("Animation")
	CustomAnim.Name = "CustomAAnimation"
	local track = nil
	local CustomAnimACTIVE = false
	PlayAnimButton.MouseButton1Click:Connect(function()
		CustomAnim.AnimationId = "rbxassetid://"..IdBox.Text
		if track == nil then
			track = Player.Character:WaitForChild("Humanoid"):LoadAnimation(CustomAnim)
		end
		if CustomAnim.AnimationId == "rbxassetid://" then return end
		track.Priority = Enum.AnimationPriority.Action3

		local PauseAnimsOption = false

		CustomAnimACTIVE = not CustomAnimACTIVE
		if CustomAnimACTIVE then
			PlayAnimButton.Image = "rbxassetid://99514193135085"
			if AnimSmoothFade == true then
				track:Play(.1, 1, 1 + SpeedNum)
			else
				track:Play(0, 1, 1 + SpeedNum)
			end

			if PauseAnimsOption then
				track:AdjustSpeed(0)
			end

		else
			PlayAnimButton.Image = "rbxassetid://8215093320"
			if AnimSmoothFade == false then
				track:Stop(0)
			end
			track:Stop()
			track:Destroy()
		end
	end)

	if CustomAnimOpened == true then
		CustomAnimButton.Visible = false
		CustomAnimBackButton.Visible = true
		IdBox.Visible = true
		PlayAnimButton.Visible = true
		CAFUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		CustomAnimFrame.Position = UDim2.new(1, 194, 0.119, 39)
	end


	--Option Buttons
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

	local AnimateScript = Player.Character:FindFirstChild("Animate")
	PauseAnimateButton.MouseButton1Click:Connect(function()
		if AnimateScript.Disabled == false then
			AnimateScript.Disabled = true
			PauseAnimateButton.BackgroundColor3 = ButtonSelectCol
		else
			StopAnimsEvent:Fire()
			AnimateScript.Disabled = false
			PauseAnimateButton.BackgroundColor3 = ButtonCol
			PauseDefAnimsOption = false
			PauseAnimsButton.BackgroundColor3 = ButtonCol
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
			StopDefAnimsButton.BackgroundColor3 = ButtonSelectCol

			PauseAnimateButton.BackgroundColor3 = ButtonCol
			PauseAnimateButton.ImageTransparency = 0.5
			PauseAnimateButton.Interactable = false
		else
			StopAnimsEvent:Fire()
			Player.Character.Animate.Disabled = false
			StopDefAnimsButton.BackgroundColor3 = ButtonCol

			PauseDefAnimsOption = false
			PauseAnimsButton.BackgroundColor3 = ButtonCol
			PauseAnimateButton.BackgroundColor3 = ButtonCol
			PauseAnimateButton.ImageTransparency = 0
			PauseAnimateButton.Interactable = true
		end
	end)

	local function CreateDivideFrame(Title, LayoutOrder, Type)
		local DivideFrame = Instance.new("Frame")
		local Line = Instance.new("Frame")
		local TextLabel = Instance.new("TextLabel")

		DivideFrame.Name = "DivideFrame"
		DivideFrame.Size = UDim2.new(0.98, 0, 0, 15)
		DivideFrame.BackgroundTransparency = 1
		DivideFrame.LayoutOrder = LayoutOrder

		Line.Name = "Line"
		Line.AnchorPoint = Vector2.new(0, 0.5)
		Line.Size = UDim2.new(1, 0, 0, 3)
		Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Line.Position = UDim2.new(0, 0, 0.5, 0)
		Line.BorderSizePixel = 0
		Line.BackgroundColor3 = UiButColor
		Line.Parent = DivideFrame

		TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		TextLabel.AutomaticSize = Enum.AutomaticSize.X
		TextLabel.Size = UDim2.new(0, 50, 0, 25)
		TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.BackgroundColor3 = ScrollBgColor
		TextLabel.TextSize = 25
		TextLabel.TextColor3 = UiButColor
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

	local ToolIdleAnimsList = {"ToolNoneAnim", "507768375", "182393478"}
	local ToolActionAnimsList = {"ToolLungeAnim", "ToolSlashAnim", "522638767", "522635514", }
	local Task = task.spawn(function()
		while GuiActive == true do
			if ToolAnimHighPrior == true then
				local playingTracks = Humanoid:GetPlayingAnimationTracks()
				local anyTrue = false
				for _, ScrollFrame in ipairs(ScrollingFramesList) do
					for _, item in ipairs(ScrollFrame:GetChildren()) do
						if item:IsA("TextButton") and item.BackgroundColor3 == ButtonSelectCol then
							anyTrue = true
							break
						end
					end
				end

				if anyTrue then
					for _, animtrack in ipairs(playingTracks) do
						local animationObject = animtrack.Animation
						local IdNumberString = string.match(animationObject.AnimationId, "%d+") 

						if table.find(ToolIdleAnimsList, animtrack.Name) or table.find(ToolIdleAnimsList, IdNumberString) then
							animtrack.Priority = Enum.AnimationPriority.Action4
						end
						if table.find(ToolActionAnimsList, animtrack.Name) or table.find(ToolActionAnimsList, IdNumberString) then
							animtrack.Priority = Enum.AnimationPriority.Action4
							animtrack:AdjustWeight(100)
						end
					end
				else
					for _, animtrack in ipairs(playingTracks) do
						local animationObject = animtrack.Animation
						local IdNumberString = string.match(animationObject.AnimationId, "%d+") 

						if table.find(ToolIdleAnimsList, animtrack.Name) or table.find(ToolIdleAnimsList, IdNumberString) then
							animtrack.Priority = Enum.AnimationPriority.Idle
						end
						if table.find(ToolActionAnimsList, animtrack.Name) or table.find(ToolActionAnimsList, IdNumberString) then
							animtrack.Priority = Enum.AnimationPriority.Action
							animtrack:AdjustWeight(1)
						end
					end
				end
			end
			task.wait()
		end
	end)

	SitButton.MouseButton1Click:Connect(function()
		if Humanoid.Sit == false then
			Humanoid.Sit = true
		else
			Humanoid.Sit = false
		end
	end)

	--Hotkey Functions
	UserInputService.InputBegan:Connect(function(input, processed)
		if input.KeyCode.Name == SearchHotkey.Value and HotkeysEnabled then
			if MainFrame.Visible == true then
				SearchBox:CaptureFocus()
				if SearchBox.Visible == false then
					SearchButtonClick = false
					SearchButton.Visible = false
					BackButton.Visible = true
					SearchBox.Visible = true
					SFUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
					game.TweenService:Create(SearchFrame, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Position = UDim2.new(1, 164, 0.119, 0)}):Play()
					wait(.3)
					SearchButtonClick = true
				end
			end
		end
	end)
	UserInputService.InputBegan:Connect(function(input, processed)
		if tostring(input.KeyCode.Name) == SitHotkey.Value and HotkeysEnabled then
			if Humanoid.Sit == false then
				Humanoid.Sit = true
			else
				Humanoid.Sit = false
			end
		end
	end)
	UserInputService.InputBegan:Connect(function(input, processed)
		if tostring(input.KeyCode.Name) == CloseHotkey.Value and HotkeysEnabled then
			MainFrame.Visible = not MainFrame.Visible
			SideFrame.Visible = not SideFrame.Visible
			if MainFrame.Visible == true then
				SideFrame.Position = MainFrame.Position
			else
				MainFrame.Position = SideFrame.Position
			end
		end
	end)
	UserInputService.InputBegan:Connect(function(input, processed)
		if tostring(input.KeyCode.Name) == SettingsHotkey.Value and HotkeysEnabled then
			SettingsFrame.Visible = not SettingsFrame.Visible
		end
	end)


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

	--R15 Emotes
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
		PlayAnim(FloatingSpace2, "70394064781064", .1, 0.5, "PriorLow", true)
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

	local UiCornerParts = {"ResetButton", "CustomAnimFrame", "PlayAnimButton", "CustomAnimButton", "HotkeysEditOption", "SaveSettingsButton", "LaunchIdDetectorButton", "GithubLinkButton", "HotkeysFrame", "SettingsFrame", "SettingsButton", "GuiTopFrame", "CloseGUI", "DestroyGUI", "GuiBottomFrame", "SpeedValue", "SideFrame", "OpenGUI", "ViewportFrame", "OptionsFrame", "PauseAnimsButton", "StopDefAnimsButton", "PauseAnimateButton", "SitButton", "SearchFrame", "SearchButton"}
	local UiStrokeParts = {"CustomAnimFrame", "HotkeysFrame", "SettingsFrame", "GuiTopFrame", "GuiBottomFrame", "SideFrame", "ScrollingFrame", "ScrollingFrameR15", "OptionsFrame", "SearchFrame"}
	local UiStroke1Parts = {"ResetButton", "PlayAnimButton", "IdBox", "HotkeysEditOption", "SaveSettingsButton", "LaunchIdDetectorButton", "GithubLinkButton", "SpeedValue", "SearchBox", "PauseAnimsButton", "StopDefAnimsButton", "PauseAnimateButton", "SitButton"}
	local UiGradientParts = {"CustomAnimBackButton", "BackButton", "CustomAnimFrame", "PlayAnimButton", "CustomAnimButton", "SettingsButton", "GuiTopFrame", "GuiBottomFrame", "SideFrame", "SettingsButton", "DestroyGUI", "CloseGUI", "OpenGUI", "OptionsButton", "PauseAnimsButton", "StopDefAnimsButton", "PauseAnimateButton", "SitButton", "SearchFrame", "SearchButton", "BackButton"}

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

		if table.find(UiStrokeParts, UiPart.Name) or table.find(UiStroke1Parts, UiPart.Name) then
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

	local function AddUiPadding(Part, left, right, top, bottom)
		for _, UiPart in ipairs(Emoter:GetDescendants()) do
			if UiPart.Name == Part then
				local UIPadding = Instance.new("UIPadding")
				UIPadding.PaddingLeft = UDim.new(0, left)
				UIPadding.PaddingRight = UDim.new(0, right)
				UIPadding.PaddingTop = UDim.new(0, top)
				UIPadding.PaddingBottom = UDim.new(0, bottom)
				UIPadding.Parent = UiPart
			end
		end
	end

	AddUiPadding("GuiBottomFrame",5,5)
	AddUiPadding("SpeedValue",2,2)
	AddUiPadding("ScrollingFrame",5,16,7,10)
	AddUiPadding("ScrollingFrameR15",5,16,7,10)
	AddUiPadding("SearchBox",2,2)
	AddUiPadding("SettingsStuff",10,10,5)
	AddUiPadding("ThemeOptionText",0,0,0,2)
	AddUiPadding("HotkeysEditOption",0,0,0,2)
	AddUiPadding("HotkeysStuff",10,10,5)
	AddUiPadding("SearchFrame",2)
	AddUiPadding("IdBox",2,2)
	AddUiPadding("CustomAnimFrame",2)

	--OnRestart things
	if GuiPos ~= nil then
		SideFrame.Position = GuiPos
	end
	if GuiPos ~= nil then
		MainFrame.Position = GuiPos
	end
	if SettingsPos ~= nil then
		SettingsFrame.Position = SettingsPos
	end
	if GuiClosed == true then
		SideFrame.Visible = true
	end
	if GuiClosed == true then
		MainFrame.Visible = false
	end
	if OptionsOpened == true then
		OptionsFrame.Visible = true
		OptionsFrame.Position = UDim2.new(0.5, 0, 1, 7)
	end
	if SettingsOpened == true then
		SettingsFrame.Visible = true
	end

	if ScrollingFramePos ~= nil then
		ScrollingFrame.CanvasPosition = ScrollingFramePos
	end
	if ScrollingFramePos ~= nil then
		ScrollingFrameR15.CanvasPosition = ScrollingFramePos
	end
	SearchBox.Text = PrevSearchText
	IdBox.Text = PrevCustomAnimId
	SpeedValue.Text = PrevAnimSpeedValue

	GuiEmoter = Emoter
end

function OnRestart()
	if GuiEmoter.MainFrame.Visible == true then
		GuiClosed = false
		GuiPos = GuiEmoter.MainFrame.Position
	elseif GuiEmoter.SideFrame.Visible == true then
		GuiClosed = true
		GuiPos = GuiEmoter.SideFrame.Position
	end
	if GuiEmoter.SettingsFrame.Visible == true then
		SettingsOpened = true
	end
	SettingsPos = GuiEmoter.SettingsFrame.Position
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
	if GuiEmoter.MainFrame.CustomAnimFrame.IdBox.Visible == true then
		CustomAnimOpened = true
	else
		CustomAnimOpened = false
	end
	PrevAnimSpeedValue = GuiEmoter.MainFrame.GuiBottomFrame.SpeedFrame.SpeedValue.Text
	PrevSearchText = GuiEmoter.MainFrame.SearchFrame.SearchBox.Text
	PrevCustomAnimId = GuiEmoter.MainFrame.CustomAnimFrame.IdBox.Text
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
