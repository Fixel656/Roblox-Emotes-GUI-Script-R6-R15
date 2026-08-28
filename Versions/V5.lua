--[[Script by Fixel656, based on Energize GUI by illremember
DO NOT COPY AND CLAIM AS YOUR OWN, if you are using some of the script for your own, 
credit is highly appreciated!]]

local ScriptVersion = "V5.0"
local GuiActive = true
local GuiEmoter = nil
local AnimationHandler = "Animate"
local Player = game.Players.LocalPlayer
local IsInStudio = game:GetService("RunService"):IsStudio()
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local ContextActionService = game:GetService("ContextActionService")

--Settings
local ToolAnimHighPriorEnabled = false
local AnimPreviewEnabled = true
local DebugInfoEnabled = false
local AnalyticsEnabled = true
local LoadAnimationsOnRestart = true

local ToolIdleAnimHighPriorEnabled = false
local ToolActionAnimHighPriorEnabled = true
local AnimSwitchModeEnabled = false
local AnimSwitchModeRunIdleExceptionEnabled = true
local AnimSmoothFadeEnabled = true
local HigherPriorityEnabled = false

local IdleTypeEnabled = true
local RunningTypeEnabled = true
local RunningTypeStopStandingEnabled = true
local RunningTypeCharSpeedEnabled = true
local RunningTypeMinSpeedEnabled = true
local RunningTypeStopJumpingEnabled = true
local RunningTypeStopClimbingEnabled = true

local theme = "LightPurple"
local UIGradientEnabled = true
local UICornerEnabled = true
local XSize = 460
local YSize = 285

local LoadGithubSGAEnabled = true
local LoadGithubCustomAnimsEnabled = true
local LoadLocalSGAEnabled = true
local LoadLocalCustomAnimsEnabled = true

local HotkeysEnabled = true
local DoubleHotkeyEnabled = false
local SearchHotkey = Instance.new("StringValue")
local CloseHotkey = Instance.new("StringValue")
local SitHotkey = Instance.new("StringValue")
local SwitchAnimHotkey = Instance.new("StringValue")
local AnimFadeHotkey = Instance.new("StringValue")
local SettingsHotkey = Instance.new("StringValue")
local StopAnimsHotkey = Instance.new("StringValue")
local EmoteWheelHotkey = Instance.new("StringValue")

CloseHotkey.Value = "T"
SettingsHotkey.Value = "Y"
SearchHotkey.Value = "H"
SitHotkey.Value = "J"
SwitchAnimHotkey.Value = "V"
StopAnimsHotkey.Value = "N"
AnimFadeHotkey.Value = "B"

EmoteWheelHotkey.Value = "Comma" --Not affected by "Hotkeys Enabled" setting

local ConfigFileName = "EmoterConfig.json"
if not IsInStudio then
	if isfile("EmoterData/"..ConfigFileName) then
		local rawData = readfile("EmoterData/"..ConfigFileName)
		local DecodedSettings = HttpService:JSONDecode(rawData)
		-- Accessing the loaded data
		AnimPreviewEnabled = DecodedSettings.ConfAnimPreviewEnabled
		DebugInfoEnabled = DecodedSettings.ConfDebugInfoEnabled
		AnalyticsEnabled = DecodedSettings.ConfAnalyticsEnabled
		LoadAnimationsOnRestart = DecodedSettings.ConfLoadAnimationsOnRestart

		ToolIdleAnimHighPriorEnabled = DecodedSettings.ConfToolIdleAnimHighPriorEnabled
		ToolActionAnimHighPriorEnabled = DecodedSettings.ConfToolActionAnimHighPriorEnabled
		AnimSwitchModeEnabled = DecodedSettings.ConfAnimSwitchModeEnabled
		AnimSwitchModeRunIdleExceptionEnabled = DecodedSettings.ConfAnimSwitchModeRunIdleExceptionEnabled
		AnimSmoothFadeEnabled = DecodedSettings.ConfAnimSmoothFadeEnabled
		HigherPriorityEnabled = DecodedSettings.ConfHigherPriorityEnabled

		IdleTypeEnabled = DecodedSettings.ConfIdleTypeEnabled
		RunningTypeEnabled = DecodedSettings.ConfRunningTypeEnabled
		RunningTypeStopStandingEnabled = DecodedSettings.ConfRunningTypeStopStandingEnabled
		RunningTypeCharSpeedEnabled = DecodedSettings.ConfRunningTypeCharSpeedEnabled
		RunningTypeMinSpeedEnabled = DecodedSettings.ConfRunningTypeMinSpeedEnabled
		RunningTypeStopJumpingEnabled = DecodedSettings.ConfRunningTypeStopJumpingEnabled
		RunningTypeStopClimbingEnabled = DecodedSettings.ConfRunningTypeStopClimbingEnabled

		theme = DecodedSettings.ConfTheme
		UIGradientEnabled = DecodedSettings.ConfUIGradientEnabled
		UICornerEnabled = DecodedSettings.ConfUICornerEnabled
		XSize = DecodedSettings.ConfXSize
		YSize = DecodedSettings.ConfYSize

		LoadGithubSGAEnabled = DecodedSettings.ConfLoadGithubSGAEnabled
		LoadGithubCustomAnimsEnabled = DecodedSettings.ConfLoadGithubCustomAnimsEnabled
		LoadLocalSGAEnabled = DecodedSettings.ConfLoadLocalSGAEnabled
		LoadLocalCustomAnimsEnabled = DecodedSettings.ConfLoadLocalCustomAnimsEnabled

		HotkeysEnabled = DecodedSettings.ConfHotkeysEnabled
		DoubleHotkeyEnabled = DecodedSettings.ConfDoubleHotkeyEnabled
		SearchHotkey.Value = tostring(DecodedSettings.ConfSearchHotkey)
		CloseHotkey.Value = tostring(DecodedSettings.ConfCloseHotkey)
		SitHotkey.Value = tostring(DecodedSettings.ConfSitHotkey)
		SwitchAnimHotkey.Value = tostring(DecodedSettings.ConfSwitchAnimHotkey)
		AnimFadeHotkey.Value = tostring(DecodedSettings.ConfAnimFadeHotkey)
		SettingsHotkey.Value = tostring(DecodedSettings.ConfSettingsHotkey)
		StopAnimsHotkey.Value = tostring(DecodedSettings.StopAnimsHotkey)
		EmoteWheelHotkey.Value = tostring(DecodedSettings.ConfEmoteWheelHotkey)
	end
end

if AnalyticsEnabled and not IsInStudio then task.spawn(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Fixel656/Roblox-Emotes-GUI-Script-R6-R15/refs/heads/main/Documentations%20%26%20Changelogs/CountHandler.lua",true))() end) end
-- P.S. This CountHandler made to see how many people are using this script and does NOT collect any other data

local BgColor = Color3.fromRGB(137, 165, 255)
local ScrollBgColor = Color3.fromRGB(240, 255, 255)
local UiButColor = Color3.new(0, 0, 0) -- Color of GUI's buttons and Texts
local ButtonCol = Color3.fromRGB(192, 191, 211) -- R6 Button Color
local ButtonSelectCol = Color3.fromRGB(255, 255, 255) -- R6 Button darker color (idk how to make it just darker BgColor yet)

--Restart Values
local GuiPos = nil
local SettingsPos = nil
local ScrollingFramePos = nil
local ScrollingFrameSpecificPos = nil
local GuiClosed = false
local OptionsOpened = false
local SettingsOpened = false
local CurrentSection = "Default"
local AltPressed = false

local PrevAnimSpeedValue = ""
local SearchOpened = false
local PrevSearchText = ""
local CustomAnimOpened = false
local PrevCustomAnimId = ""

local RestartAnimations = {}

local EmoteWheelEmotes = {Emote1 = nil, Emote2 = nil, Emote3 = nil, Emote4 = nil, Emote5 = nil, Emote6 = nil, Emote7 = nil, Emote8 = nil}

if (Player.Character:WaitForChild("Humanoid").RigType == Enum.HumanoidRigType.R15) then
	EmoteWheelEmotes.Emote1 = "R15Wave"
	EmoteWheelEmotes.Emote2 = "R15FortniteDance"
	EmoteWheelEmotes.Emote3 = "R15GangnamStyle"
	EmoteWheelEmotes.Emote4 = "R15RussianKick"
	EmoteWheelEmotes.Emote5 = "R15Rambunctious"
	EmoteWheelEmotes.Emote6 = "R15Helicopter"
	EmoteWheelEmotes.Emote7 = "R15MiniWalk"
	EmoteWheelEmotes.Emote8 = "R15TakeTheL"
else
	EmoteWheelEmotes.Emote1 = "R6Dance1"
	EmoteWheelEmotes.Emote2 = "R6Dance2"
	EmoteWheelEmotes.Emote3 = "R6Dance3"
	EmoteWheelEmotes.Emote4 = "R6MovingDance"
	EmoteWheelEmotes.Emote5 = "R6Bang"
	EmoteWheelEmotes.Emote6 = "R6SpinDance"
	EmoteWheelEmotes.Emote7 = "R6FloatSit"
	EmoteWheelEmotes.Emote8 = "R6Spinner"
end


local function CreateGui()
	print("Loading Emoter GUI...")

	local SpeedNum = 0 --Value, adding to default speed of animation
	local AnimInfo = Instance.new("StringValue")
	local NegativeNumber = 1
	local DefaultWalkSpeed = 16
	local Humanoid = nil
	local ClonedChar = nil
	local RigType = nil
	local GuiLoaded = false
	local GuiRestarted = false
	if (Player.Character:WaitForChild("Humanoid").RigType == Enum.HumanoidRigType.R15) then
		RigType = "R15"
	elseif (Player.Character:WaitForChild("Humanoid").RigType == Enum.HumanoidRigType.R6) then
		RigType = "R6"
	else
		RigType = "R15"
	end

	local DefaultAnimsNameList = {"Animation1", "Animation2", "Animation3", "ClimbAnim", "FallAnim", "JumpAnim", "RunAnim", "SitAnim", "ToolNoneAnim", "WalkAnim", "CheerAnim", "LaughAnim", "PointAnim", "Swim", "SwimIdle", "ToolLungeAnim", "ToolSlashAnim", "WaveAnim"}
	local ToolIdleAnimsList = {"ToolNoneAnim", "507768375", "182393478"}
	local ToolActionAnimsList = {"ToolLungeAnim", "ToolSlashAnim", "522638767", "522635514", "129967390", "129967478"}

	local Emoter = Instance.new("ScreenGui") --The actual GUI
	local MainFrame = Instance.new("Frame") --All of the stuff on the main frame
	local ViewportFrame = Instance.new("ViewportFrame") --Frame with animation preview

	local SideFrame = Instance.new("Frame") --Visible when GUI is closed
	local SideFrameTitle = Instance.new("TextLabel")
	local OpenGUI = Instance.new("ImageButton")
	local SFDestroyGUI = Instance.new("TextButton")

	local GuiTopFrame = Instance.new("Frame") --Top of the main frame
	local DestroyGUI = Instance.new("TextButton")
	local CloseGUI = Instance.new("ImageButton")
	local Title = Instance.new("TextLabel")

	local GuiBottomFrame = Instance.new("Frame") --Bottom of the main frame
	local SpeedFrame = Instance.new("Frame") -- Frame of Speed Changer
	local CurAnimInfoTitle = Instance.new("TextLabel")
	local OptionsButton = Instance.new("ImageButton")

	local ScrollingFrame = Instance.new("ScrollingFrame") --Scrolling frame of R6 animations
	local ScrollingFrameR15 = Instance.new("ScrollingFrame") --Scrolling frame of R15 animations
	local ScrollingFrameSpecific = Instance.new("ScrollingFrame") --Scrolling frame of specific game animations
	local ScrollingFramesList = {
		ScrollingFrame,
		ScrollingFrameR15,
		ScrollingFrameSpecific
	}

	local OptionsFrame = Instance.new("Frame") --Frame of additional options
	local StopAnimsEvent = Instance.new("BindableEvent") --Event to stop animations when disabling StopDefaultAnims option
	local PauseAnimsButton = Instance.new("ImageButton")
	local StopDefAnimsButton = Instance.new("ImageButton")
	local PauseAnimateButton = Instance.new("ImageButton")
	local SitButton = Instance.new("ImageButton")
	local ReversePlayButton = Instance.new("ImageButton")
	local EmoteWheelButton = Instance.new("ImageButton")

	local SearchFrame = Instance.new("Frame") --Frame for searching anims
	local SearchButton = Instance.new("ImageButton")
	local SearchBox = Instance.new("TextBox")
	local BackButton = Instance.new("ImageButton")

	local CustomAnimFrame = Instance.new("Frame") --Frame for adding anims by it's Id
	local CustomAnimButton = Instance.new("ImageButton")
	local IdBox = Instance.new("TextBox")
	local CustomAnimBackButton = Instance.new("ImageButton")
	local PlayAnimButton = Instance.new("ImageButton")

	local DefaultSection = Instance.new("TextButton") --Sections in case when you have specific game anims
	local SpecGameSection = Instance.new("TextButton")

	local EmoteWheel = Instance.new("Frame") --Emote wheel 
	local EmoteWheelText = Instance.new("TextLabel")
	local Emote1 = Instance.new("TextButton")
	local Emote2 = Instance.new("TextButton")
	local Emote3 = Instance.new("TextButton")
	local Emote4 = Instance.new("TextButton")
	local Emote5 = Instance.new("TextButton")
	local Emote6 = Instance.new("TextButton")
	local Emote7 = Instance.new("TextButton")
	local Emote8 = Instance.new("TextButton")

	local SettingsFrame = Instance.new("Frame") --Settings
	local GuiName = Instance.new("TextLabel")
	local AutorText = Instance.new("TextLabel")
	local VersionText = Instance.new("TextLabel")
	local SettingsStuff = Instance.new("ScrollingFrame")
	local ThemeOption = Instance.new("Frame")
	local ThemeOptionText = Instance.new("TextLabel")
	local PurpleThemeColor = Instance.new("TextButton")
	local OrangeThemeColor = Instance.new("TextButton")
	local YellowThemeColor = Instance.new("TextButton")
	local BlackThemeColor = Instance.new("TextButton")
	local HotkeysEditOption = Instance.new("TextButton")
	local HotkeysFrame = Instance.new("Frame")
	local HotkeysStuff = Instance.new("ScrollingFrame")
	local HotkeyFrameName = Instance.new("TextLabel")
	local MoreButtonsFrame = Instance.new("Frame")
	local SaveSettingsButton = Instance.new("ImageButton")
	local LaunchIdDetectorButton = Instance.new("ImageButton")
	local ResetButton = Instance.new("ImageButton")
	local GithubLinkButton = Instance.new("ImageButton")

	if theme == "LightOrange" then
		BgColor = Color3.fromRGB(255, 171, 35)
		ScrollBgColor = Color3.fromRGB(240, 255, 255)
		UiButColor = Color3.new(0, 0, 0)
		ButtonCol = Color3.fromRGB(192, 191, 211)
		ButtonSelectCol = Color3.fromRGB(255, 255, 255)
	elseif theme == "LightPurple" then
		BgColor = Color3.fromRGB(137, 165, 255)
		ScrollBgColor = Color3.fromRGB(240, 255, 255)
		UiButColor = Color3.new(0, 0, 0)
		ButtonCol = Color3.fromRGB(192, 191, 211)
		ButtonSelectCol = Color3.fromRGB(255, 255, 255)
	elseif theme == "LightYellow" then
		BgColor = Color3.fromRGB(255, 250, 112)
		ScrollBgColor = Color3.fromRGB(240, 255, 255)
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

	print("Checking functions...")
	local function AddVPF()
		ViewportFrame.Parent = MainFrame
		ViewportFrame.Visible = false
		ViewportFrame.AnchorPoint = Vector2.new(0, 0.5)
		ViewportFrame.BackgroundTransparency = 1
		ViewportFrame.Size = UDim2.new(0, 225, 0, 285)
		ViewportFrame.Position = UDim2.new(1, 10, 0.5, 0)
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
		targetPosition = Vector3.new(4.6, 0.2, 12)
		if RigType == "R15" then
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
		if ClonedChar:FindFirstChild(AnimationHandler) then
			ClonedChar:FindFirstChild(AnimationHandler):Destroy()
		end
		if ClonedChar:FindFirstChildOfClass("Tool") then
			ClonedChar:FindFirstChildOfClass("Tool"):Destroy()
		end
		ClonedChar:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0,0,-0.4), Vector3.new(0,0,7)))
	end
	AddVPF()

	local function AddHoverText(Object, Text)
		local TextLabel = nil
		Object.MouseEnter:connect(function()
			TextLabel = Instance.new("TextLabel")
			TextLabel.Parent = Emoter
			TextLabel.Visible = false
			TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.AutomaticSize = Enum.AutomaticSize.XY
			TextLabel.Size = UDim2.new(0, 5, 0, 17)
			TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
			TextLabel.TextSize = 17
			TextLabel.TextWrapped = true
			TextLabel.Font = Enum.Font.SourceSans
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.RichText = true


			if Text.Value then
				TextLabel.Text = Text.Value
			else
				TextLabel.Text = Text
			end

			local UIPadding = Instance.new("UIPadding")
			UIPadding.PaddingLeft = UDim.new(0, 2)
			UIPadding.PaddingRight = UDim.new(0, 2)
			UIPadding.PaddingBottom = UDim.new(0, 2)
			UIPadding.Parent = TextLabel

			local UISizeConstraint = Instance.new("UISizeConstraint")
			UISizeConstraint.Parent = TextLabel
			UISizeConstraint.MaxSize = Vector2.new(400, 3000)

			local UserInputService = game:GetService("UserInputService")
			local mouse = Player:GetMouse()
			TextLabel.Position = UDim2.new(0, mouse.X, 0, mouse.Y + 85)
			TextLabel.Visible = true
			mouse.Move:connect(function()
				TextLabel.Position = UDim2.new(0, mouse.X, 0, mouse.Y + 85)
			end)
			-- Add hover text
		end)
		Object.MouseLeave:connect(function()
			TextLabel:Destroy()
			-- Destroy hover text
		end)
	end

	local PlayingEmoteData = {}
	local function updateTextLabel()
		local TextTable = {}

		for _, item in ipairs(PlayingEmoteData) do
			table.insert(TextTable, item.Name .. ": " .. tostring(item.Speed) .. ", " .. item.Priotity)
		end

		AnimInfo.Value = table.concat(TextTable, "\n")
		if AnimInfo.Value == "" then
			CurAnimInfoTitle.Visible = false
		else
			CurAnimInfoTitle.Visible = true
		end
	end
	local function AddEmote(EmoteName, SpeedValue, PriorityValue)
		for index, item in ipairs(PlayingEmoteData) do
			if item.Name == EmoteName then
				table.remove(PlayingEmoteData, index)
				break
			end
		end

		table.insert(PlayingEmoteData, 1, {Name = EmoteName, Speed = SpeedValue, Priotity = PriorityValue})
		updateTextLabel()
	end
	local function RemoveEmote(EmoteName)
		for index, item in ipairs(PlayingEmoteData) do
			if item.Name == EmoteName then
				table.remove(PlayingEmoteData, index)
				break
			end
		end
		updateTextLabel()
	end

	local function CreateAnimButton(Object, Name, Text, Type, LayoutPos)
		local Button = Object
		Button.Name = Name

		if Type == "R6" then
			if ScrollingFrame:FindFirstChild(Name) then 
				ScrollingFrame:FindFirstChild(Name):Destroy() 
				--print("Found copy of anim: "..Name)
			end
			Button.Parent = ScrollingFrame
		elseif Type == "R15" then
			if ScrollingFrameR15:FindFirstChild(Name) then 
				ScrollingFrameR15:FindFirstChild(Name):Destroy() 
				--print("Found copy of anim: "..Name)
			end
			Button.Parent = ScrollingFrameR15
		elseif Type == "Spec" then
			if ScrollingFrameSpecific:FindFirstChild(Name) then 
				ScrollingFrameSpecific:FindFirstChild(Name):Destroy() 
				--print("Found copy of anim: "..Name)
			end
			Button.Parent = ScrollingFrameSpecific
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
		
		local UIStroke = Instance.new("UIStroke")
		UIStroke.Parent = Button
		UIStroke.Thickness = 1
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

		local ButtonPadding = Instance.new("UIPadding")
		ButtonPadding.Parent = Button
		ButtonPadding.PaddingLeft = UDim.new(0, 2)
		ButtonPadding.PaddingRight = UDim.new(0, 2)
	end

	local function PlayAnim(Button, ID, FadeTime, Speed, Type, LoopedVal, NeedPause) -- Types Tutorial on Emotes section
		local Frame
		if Button.Parent.Name == "ScrollingFrame" then Frame = "R6"
		elseif Button.Parent.Name == "ScrollingFrameR15" then Frame = "R15"
		elseif Button.Parent.Name == "ScrollingFrameSpecific" then Frame = "Spec"
		end
		
		Button:SetAttribute("Looped", LoopedVal)
		if LoopedVal == false then
			AddHoverText(Button, "Click RMB to loop")
		end

		local Humanoid = Player.Character:WaitForChild("Humanoid")
		local Anim = Instance.new("Animation")
		Anim.Name = "AAnimation"
		Anim.AnimationId = "rbxassetid://"..ID
		local track = Humanoid:LoadAnimation(Anim)
		if Type:find("PriorLow") then
			track.Priority = Enum.AnimationPriority.Action3
		elseif Type:find("PriorHigh") then
			track.Priority = Enum.AnimationPriority.Action4
		end		

		local AnimSpeed = nil
		local PauseAnimsOption = false
		local SwitchModeFactor = false
		local IsMoving = false
		local IsPlaying = false
		local AnimACTIVE = false

		Button.Destroying:Connect(function()
			track:Destroy()
			Anim:Destroy()
			Humanoid = nil
		end)

		local function StartAnim()
			if DebugInfoEnabled then print(Button.Name.." - Id: "..string.match(track.Animation.AnimationId, "%d+")..", AnimLength: "..track.Length..", AnimSpeed: "..track.Speed..", AnimType: "..Type..", Looped: "..tostring(track.Looped)) end

			if AnimSwitchModeEnabled == true then
				if not (((Type:find("Running") and RunningTypeEnabled) or (Type:find("Idle") and IdleTypeEnabled)) and AnimSwitchModeRunIdleExceptionEnabled) then
					SwitchModeFactor = true
					StopAnimsEvent:Fire()
					AnimACTIVE = true
				end
			end

			local CurLooped = Button:GetAttribute("Looped")
			if CurLooped == false then
				track.Looped = false
			elseif CurLooped == true then
				track.Looped = true
			end

			local AnimWeight = 1
			if HigherPriorityEnabled then
				if Type:find("PriorHigh") then
					AnimWeight = 20000
				elseif Type:find("PriorLow") then
					track.Priority = Enum.AnimationPriority.Action4
					AnimWeight = 10000
				end
			end

			if AltPressed then
				track.Priority = Enum.AnimationPriority.Action4
				if HigherPriorityEnabled then
					AnimWeight = 20000
				end
			end

			AnimSpeed = Speed + SpeedNum
			ViewportFrame.Visible = false
			Button.BackgroundColor3 = ButtonSelectCol
			Button.UIStroke.Thickness = 2
			AddEmote(Button.Name, Speed + SpeedNum, track.Priority.Name)

			if Type:find("Running") and RunningTypeEnabled then
				Button.UIStroke.Color = Color3.new(0, 0.898039, 0.478431)
			elseif Type:find("Idle") and IdleTypeEnabled then
				Button.UIStroke.Color = Color3.new(0.741176, 0, 0.890196)
			elseif Type:find("Pause") then
				Button.UIStroke.Color = Color3.new(0.835294, 0.85098, 0)
			else
				if track.Looped == true then
					Button.UIStroke.Color = Color3.new(0.0392157, 0.501961, 1)
				else
					Button.UIStroke.Color = Color3.new(0.972549, 0.670588, 0.0627451)
				end
			end

			if Type:find("Running") and RunningTypeEnabled and RunningTypeStopStandingEnabled and IsMoving == false then return end
			if Type:find("Idle") and IdleTypeEnabled and IsMoving == true then return end

			if AnimSmoothFadeEnabled == true then
				track:Play(FadeTime, AnimWeight, (Speed + SpeedNum) * NegativeNumber)
			else
				track:Play(0, AnimWeight, (Speed + SpeedNum) * NegativeNumber)
			end
			IsPlaying = true

			if PauseAnimsOption then
				track:AdjustSpeed(0)
			end

			if Type:find("Pause") then
				local NumberStr = string.match(Type, "Pause([%d%.]+)")
				local Number = tonumber(NumberStr) or 1
				local PauseTask = task.spawn(function()
					while wait() do
						if track.TimePosition >= Number then
							track:AdjustSpeed(0)
							if DebugInfoEnabled then print("Paused at "..track.TimePosition) end
							AnimSpeed = 0
							return
						end
					end
				end)
				while wait() do
					if AnimACTIVE == false then
						task.cancel(PauseTask)
						return
					end
				end
			end
		end
		local function StopAnim(Reason)
			if Type:find("PriorLow") then
				track.Priority = Enum.AnimationPriority.Action3
			elseif Type:find("PriorHigh") then
				track.Priority = Enum.AnimationPriority.Action4
			end	

			if AnimSmoothFadeEnabled == false then
				track:Stop(0)
				track:Stop()
			else
				track:Stop(FadeTime)
			end
			IsPlaying = false
			
			if (Reason == "Destroy") then return end

			Button.BackgroundColor3 = ButtonCol
			Button.UIStroke.Thickness = 1
			Button.UIStroke.Color = Color3.new(0, 0, 0)
			RemoveEmote(Button.Name)
		end

		Button.MouseButton1Click:connect(function()
			AnimACTIVE = not AnimACTIVE
			if AnimACTIVE then
				StartAnim()
			else
				StopAnim()
			end
		end)
		Button.MouseButton2Click:connect(function()
			local CurLooped = Button:GetAttribute("Looped")
			if CurLooped == false then
				AnimACTIVE = not AnimACTIVE
				if AnimACTIVE then
					StartAnim()
					track.Looped = true
					Button.UIStroke.Color = Color3.new(0.0392157, 0.501961, 1)
				else
					StopAnim()
				end
			end
		end)

		PauseAnimsButton.MouseButton1Click:Connect(function()
			PauseAnimsOption = not PauseAnimsOption
			if PauseAnimsOption then
				track:AdjustSpeed(0)
				PauseAnimsButton.BackgroundColor3 = ButtonSelectCol
				if DebugInfoEnabled and AnimACTIVE then print("Paused at:"..track.TimePosition) end
			else
				track:AdjustSpeed((Speed + SpeedNum) * NegativeNumber)
				PauseAnimsButton.BackgroundColor3 = ButtonCol
			end
		end)

		Button.Changed:connect(function()
			if GuiRestarted == true or GuiActive == false then return end
			if Button.BackgroundColor3 == ButtonCol and AnimACTIVE then
				AnimACTIVE = false
				StopAnim()
			elseif Button.BackgroundColor3 == ButtonSelectCol and not AnimACTIVE then
				AnimACTIVE = true
				StartAnim()
			end
		end)

		track.Ended:connect(function()
			if (Type:find("Running") and RunningTypeEnabled) or (Type:find("Idle") and IdleTypeEnabled) then return end
			AnimACTIVE = false
			Button.BackgroundColor3 = ButtonCol
			Button.UIStroke.Thickness = 1
			Button.UIStroke.Color = Color3.new(0, 0, 0)
			RemoveEmote(Button.Name)
		end)

		StopAnimsEvent.Event:Connect(function(Reason)
			if not (Reason == "Reset/Destroy" or Reason == "Forced") and AnimSwitchModeRunIdleExceptionEnabled and ((Type:find("Running") and RunningTypeEnabled) or (Type:find("Idle") and IdleTypeEnabled)) then return end
			if AnimACTIVE == false then return end

			if (Reason == "Reset/Destroy") and ((Type:find("Running") and RunningTypeEnabled) or (Type:find("Idle") and IdleTypeEnabled)) then
				local Name = Button.Name
				if AnimACTIVE then
					table.insert(RestartAnimations, Frame..Name)
				end
			end

			if SwitchModeFactor == true then 
				SwitchModeFactor = false	
				return 
			end
			if GuiActive == false or GuiRestarted == true then track:Destroy() end

			AnimACTIVE = false
			PauseAnimsOption = false
			if (Reason == "Reset/Destroy") then
				StopAnim("Destroy")
			else
				StopAnim()
			end
		end)
		
		local MinWalkSpeedNumStr = string.match(Type, "Running([%d%.]+)")
		local MinWalkSpeedNum = tonumber(MinWalkSpeedNumStr) or 0.5
		if tonumber(MinWalkSpeedNumStr) ~= nil then AddHoverText(Button, "Minimal WalkSpeed to play:"..MinWalkSpeedNum) end
		if Type:find("Running") then
			if RunningTypeMinSpeedEnabled == false then
				MinWalkSpeedNum = 0.5
			end
			Humanoid.Running:Connect(function(currentSpeed)
				if GuiActive and GuiRestarted == false then
					if currentSpeed > 0.5 then
						IsMoving = true
					else
						IsMoving = false
					end
				end
				if AnimACTIVE and RunningTypeEnabled and GuiActive and GuiRestarted == false then
					if RunningTypeMinSpeedEnabled == false then
						MinWalkSpeedNum = 0.5
					end
					if currentSpeed > 0.5 and Humanoid.WalkSpeed >= MinWalkSpeedNum then

						local AnimWeight = 1
						if HigherPriorityEnabled then
							if Type:find("PriorHigh") then
								AnimWeight = 250
							elseif Type:find("PriorLow") then
								track.Priority = Enum.AnimationPriority.Action4
								AnimWeight = 100
							end
						end

						if not IsPlaying then
							if AnimSmoothFadeEnabled == true then
								track:Play(FadeTime, AnimWeight, (Speed + SpeedNum) * NegativeNumber)
							else
								track:Play(0, AnimWeight, (Speed + SpeedNum) * NegativeNumber)
							end
							IsPlaying = true
						end

						local characterRelativeSpeed = currentSpeed / DefaultWalkSpeed
						if RunningTypeStopStandingEnabled == false then
							characterRelativeSpeed = Humanoid.WalkSpeed / DefaultWalkSpeed
						end

						local finalAnimationSpeed = characterRelativeSpeed * (Speed + SpeedNum) * NegativeNumber
						if RunningTypeCharSpeedEnabled then
							track:AdjustSpeed(finalAnimationSpeed)
						end
					else
						if IsPlaying and RunningTypeStopStandingEnabled then
							if AnimSmoothFadeEnabled == false then
								track:Stop(0)
								track:Stop()
							else
								track:Stop(FadeTime)
							end
							IsPlaying = false
						end
					end
				elseif GuiActive and GuiRestarted == false then
					if IsPlaying and RunningTypeEnabled then
						if AnimSmoothFadeEnabled == false then
							track:Stop(0)
							track:Stop()
						else
							track:Stop(FadeTime)
						end
						IsPlaying = false
					end
				end
			end)

			Humanoid.Swimming:Connect(function()
				if IsPlaying and RunningTypeEnabled then
					track:Stop()
					IsPlaying = false
				end
			end)
			Humanoid.Jumping:Connect(function()
				if IsPlaying and RunningTypeEnabled and RunningTypeStopJumpingEnabled then
					track:Stop()
					IsPlaying = false
				end
			end)
			Humanoid.FreeFalling:Connect(function()
				if IsPlaying and RunningTypeEnabled and RunningTypeStopJumpingEnabled then
					track:Stop()
					IsPlaying = false
				end
			end)
			Humanoid.Climbing:Connect(function()
				if IsPlaying and RunningTypeEnabled and RunningTypeStopClimbingEnabled then
					track:Stop()
					IsPlaying = false
				end
			end)
		end

		if Type:find("Idle") then
			Humanoid.Running:Connect(function(currentSpeed)
				if GuiActive then
					if currentSpeed > 0.5 then
						IsMoving = true
					else
						IsMoving = false
					end
				end
				if AnimACTIVE and IdleTypeEnabled and GuiActive and GuiRestarted == false then
					if currentSpeed > 0.5 then
						if IsPlaying then
							track:Stop()
							IsPlaying = false
						end
					else
						if IsPlaying == false then
							local AnimWeight = 1
							if HigherPriorityEnabled then
								if Type:find("PriorHigh") then
									AnimWeight = 250
								elseif Type:find("PriorLow") then
									track.Priority = Enum.AnimationPriority.Action4
									AnimWeight = 100
								end
							end

							if not IsPlaying then
								if AnimSmoothFadeEnabled == true then
									track:Play(FadeTime, AnimWeight, (Speed + SpeedNum) * NegativeNumber)
								else
									track:Play(0, AnimWeight, (Speed + SpeedNum) * NegativeNumber)
								end
								IsPlaying = true
							end

							IsPlaying = true
						end
					end
				elseif GuiActive and GuiRestarted == false then
					if IsPlaying and IdleTypeEnabled then
						if AnimSmoothFadeEnabled == false then
							track:Stop(0)
							track:Stop()
						else
							track:Stop(FadeTime)
						end
						IsPlaying = false
					end
				end
			end)

			Humanoid.Swimming:Connect(function()
				if IsPlaying and IdleTypeEnabled then
					track:Stop()
					IsPlaying = false
				end
			end)
			Humanoid.Jumping:Connect(function()
				if IsPlaying and IdleTypeEnabled then
					track:Stop()
					IsPlaying = false
				end
			end)
			Humanoid.FreeFalling:Connect(function()
				if IsPlaying and IdleTypeEnabled then
					track:Stop()
					IsPlaying = false
				end
			end)
			Humanoid.Climbing:Connect(function()
				if IsPlaying and IdleTypeEnabled then
					track:Stop()
					IsPlaying = false
				end
			end)
			Humanoid.Seated:Connect(function()
				if IsPlaying and IdleTypeEnabled then
					track:Stop()
					IsPlaying = false
				end
			end)
		end

		local VPFtrack = ClonedChar:WaitForChild("Humanoid"):LoadAnimation(Anim)
		local VPFActive = false
		Button.MouseEnter:connect(function()
			if AnimPreviewEnabled and not AnimACTIVE then
				VPFActive = true
				VPFtrack.Looped = true
				VPFtrack:Play(0, 1, (Speed + SpeedNum) * NegativeNumber)
				ViewportFrame.Visible = true
				game.TweenService:Create(ViewportFrame, TweenInfo.new(.1), {BackgroundTransparency = 0}):Play()

				if Type:find("Pause") then
					local NumberStr = string.match(Type, "Pause([%d%.]+)")
					local Number = tonumber(NumberStr) or 1

					local PauseTask = task.spawn(function()
						wait(Number)
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

		Button.MouseLeave:connect(function()
			if AnimPreviewEnabled then
				VPFActive = false
				game.TweenService:Create(ViewportFrame, TweenInfo.new(.1), {BackgroundTransparency = 1}):Play()
				ViewportFrame.Visible = false
				VPFtrack:Stop()
			end
		end)
		
		for index, RestartedAnim in ipairs(RestartAnimations) do
			local prefix, suffix
			if string.match(RestartedAnim, "^R15") then
				prefix, suffix = string.match(RestartedAnim, "^(R15)(.+)$")
			elseif string.match(RestartedAnim, "^Spec") then
				prefix, suffix = string.match(RestartedAnim, "^(Spec)(.+)$")
			elseif string.match(RestartedAnim, "^R6") then
				prefix, suffix = string.match(RestartedAnim, "^(R6)(.+)$")
			end

			if prefix == Frame and suffix == Button.Name then
				task.spawn(function()
					Button:WaitForChild("UIStroke")
					AnimACTIVE = true
					StartAnim()
				end)
			end
		end
	end

	local function AddSettings(Setting, Title, Text, LayoutOrder)
		local OptionButton = Instance.new("TextButton")
		OptionButton.Name = Title
		OptionButton.Size = UDim2.new(1, 0, 0, 25)
		OptionButton.BackgroundTransparency = 1
		OptionButton.LayoutOrder = LayoutOrder
		OptionButton.Position = UDim2.new(0, 0, 0.1558714, 0)
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
		CheckImage.ImageColor3 = UiButColor
		CheckImage.Parent = OptionButton
		if Setting == true then
			CheckImage.Image = "rbxassetid://130396712201457"
		else
			CheckImage.Image = ""
		end
		if theme == "Black" then
			CheckImage.BackgroundColor3 = ButtonCol
		end

		local UIStroke = Instance.new("UIStroke")
		UIStroke.Parent = CheckImage

		local UIListLayout = Instance.new("UIListLayout")
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 5)
		UIListLayout.Parent = OptionButton

		local TextLabel = Instance.new("TextLabel")
		TextLabel.Size = UDim2.new(0.9500334, -10, 0, 25)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Position = UDim2.new(0.115608, 0, 0, 0)
		TextLabel.TextColor3 = UiButColor
		TextLabel.TextSize = 14
		TextLabel.Text = Text
		TextLabel.Font = Enum.Font.SourceSans
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.Parent = OptionButton

		local UIPadding = Instance.new("UIPadding")
		UIPadding.PaddingBottom = UDim.new(0, 2)
		UIPadding.Parent = TextLabel
	end

	local function AddHotkey(Hotkey, FrameName, Text)
		local HotkeyFrame = Instance.new("Frame")
		HotkeyFrame.Name = FrameName
		HotkeyFrame.Size = UDim2.new(1, 0, 0, 25)
		HotkeyFrame.BackgroundTransparency = 1
		HotkeyFrame.Parent = HotkeysStuff

		local HotkeyText = Instance.new("TextLabel")
		HotkeyText.Size = UDim2.new(0.8241132, -10, 0, 25)
		HotkeyText.BackgroundTransparency = 1
		HotkeyText.TextColor3 = UiButColor
		HotkeyText.TextSize = 14
		HotkeyText.Text = Text
		HotkeyText.TextWrapped = true
		HotkeyText.Font = Enum.Font.SourceSans
		HotkeyText.TextXAlignment = Enum.TextXAlignment.Left
		HotkeyText.Parent = HotkeyFrame

		local UIPadding = Instance.new("UIPadding")
		UIPadding.PaddingBottom = UDim.new(0, 2)
		UIPadding.Parent = HotkeyText

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
					if input.KeyCode.Name == "Backspace" or input.KeyCode.Name == "Enter" then
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
		end)
	end

	local function CreateDivideFrame(Title, LayoutOrder, Type)
		local HasButton = false
		if Type == "Spec" then
			for _, v in pairs(ScrollingFrameSpecific:GetChildren()) do
				if v:IsA("TextButton") then
					if v.LayoutOrder == LayoutOrder + 1 then
						HasButton = true
						break
					end
				end		
			end
		else
			HasButton = true
		end
		if HasButton == false then return end

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
		TextLabel.Size = UDim2.new(0, 0, 0, 25)
		TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.BackgroundColor3 = ScrollBgColor
		TextLabel.TextSize = 25
		TextLabel.TextColor3 = UiButColor
		TextLabel.Text = Title
		TextLabel.Font = Enum.Font.SourceSansBold
		TextLabel.Parent = DivideFrame

		local UIPadding = Instance.new("UIPadding")
		UIPadding.PaddingLeft = UDim.new(0, 8)
		UIPadding.PaddingRight = UDim.new(0, 10)
		UIPadding.Parent = TextLabel

		if Type == "Settings" then
			DivideFrame.Size = UDim2.new(0.98, 0, 0, 15)
			Line.Size = UDim2.new(1, 0, 0, 2)
			TextLabel.Size = UDim2.new(0, 50, 0, 20)
			TextLabel.TextSize = 17
		end

		if Type == "R6" then
			DivideFrame.Parent = ScrollingFrame
		elseif Type == "R15" then
			DivideFrame.Parent = ScrollingFrameR15
		elseif Type == "Spec" then
			DivideFrame.Parent = ScrollingFrameSpecific
		elseif Type == "Settings" then
			DivideFrame.Parent = SettingsStuff
		end
	end


	-- Creating Objects
	print("Creating Objects...")
	Emoter.Name = "Emoter"
	Emoter.ResetOnSpawn = false
	Emoter.IgnoreGuiInset = true
	if IsInStudio then --Made this as i test script mostly in Studio
		Emoter.Parent = game.Players.LocalPlayer.PlayerGui
		Emoter.DisplayOrder = 100
	else
		Emoter.Parent = game.CoreGui
		Emoter.DisplayOrder = -1
	end
	if not IsInStudio then
		Emoter.Enabled = false
	end

	-- SideFrame
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
	MainFrame.Size = UDim2.new(0, XSize, 0, YSize)
	MainFrame.Position = UDim2.new(0, 10, 0, 70)

	local UIDragDetectorMainFrame = Instance.new("UIDragDetector")
	UIDragDetectorMainFrame.Parent = MainFrame


	-- GuiTopFrame
	GuiTopFrame.Name = "GuiTopFrame"
	GuiTopFrame.Parent = MainFrame
	GuiTopFrame.BackgroundColor3 = BgColor
	GuiTopFrame.BorderColor3 = Color3.new(0.243137, 0.243137, 0.243137)
	GuiTopFrame.Size = UDim2.new(1, 0, 0, 32)

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
	Title.Text = "Emoter GUI"
	Title.Font = Enum.Font.SourceSansBold
	Title.TextColor3 = Color3.new(1, 1, 1)
	Title.TextSize = 24
	Title.TextStrokeTransparency = 0
	Title.TextWrapped = false


	-- GuiBottomFrame
	GuiBottomFrame.Name = "GuiBottomFrame"
	GuiBottomFrame.Parent = MainFrame
	GuiBottomFrame.AnchorPoint = Vector2.new(0, 1)
	GuiBottomFrame.Size = UDim2.new(1, 0, 0, 35)
	GuiBottomFrame.Position = UDim2.new(0, 0, 1, 1)
	GuiBottomFrame.Active = true
	GuiBottomFrame.BackgroundColor3 = BgColor

	SpeedFrame.Name = "SpeedFrame"
	SpeedFrame.Parent = GuiBottomFrame
	SpeedFrame.Size = UDim2.new(0.5, 0, 0, 35)
	SpeedFrame.BackgroundTransparency = 1
	SpeedFrame.Active = true

	local SFLayout = Instance.new("UIGridLayout")
	SFLayout.Name = "UIGridLayout"
	SFLayout.Parent = SpeedFrame
	SFLayout.FillDirection = Enum.FillDirection.Vertical
	SFLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SFLayout.CellSize = UDim2.new(0, 90, 0, 28)
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
	SpeedValue.BackgroundColor3 = ScrollBgColor
	SpeedValue.TextColor3 = UiButColor
	SpeedValue.Text = ""
	SpeedValue.PlaceholderText = "0 = Default"
	SpeedValue.Font = Enum.Font.SourceSans
	SpeedValue.TextScaled = true
	AddHoverText(SpeedValue, "Enter a number to add speed")

	local ValueText = Instance.new("TextLabel")
	ValueText.Name = "ValueText"
	ValueText.Parent = SpeedFrame
	ValueText.Size = UDim2.new(0, 200, 0, 50)
	ValueText.BackgroundTransparency = 1
	ValueText.TextStrokeTransparency = 0
	ValueText.TextColor3 = Color3.fromRGB(255, 255, 255)
	ValueText.Text = "Add Speed"
	ValueText.Font = Enum.Font.SourceSansBold
	ValueText.TextScaled = true

	CurAnimInfoTitle.Name = "CurAnimInfoTitle"
	CurAnimInfoTitle.AnchorPoint = Vector2.new(1, 0)
	CurAnimInfoTitle.Size = UDim2.new(0, 0, 0, 35)
	CurAnimInfoTitle.AutomaticSize = Enum.AutomaticSize.X
	CurAnimInfoTitle.BackgroundTransparency = 1
	CurAnimInfoTitle.Position = UDim2.new(1, 0, 0, 0)
	CurAnimInfoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	CurAnimInfoTitle.Text = "[info]"
	CurAnimInfoTitle.TextXAlignment = Enum.TextXAlignment.Right
	CurAnimInfoTitle.TextWrapped = true
	CurAnimInfoTitle.Font = Enum.Font.SourceSansBold
	CurAnimInfoTitle.TextScaled = true
	CurAnimInfoTitle.TextStrokeTransparency = 0
	CurAnimInfoTitle.Visible = false
	CurAnimInfoTitle.Parent = GuiBottomFrame
	AddHoverText(CurAnimInfoTitle, AnimInfo)


	--Scrolling Frames
	ScrollingFrame.Parent = MainFrame
	ScrollingFrame.BackgroundColor3 = ScrollBgColor
	ScrollingFrame.Position = UDim2.new(0, 0, 0, 34)
	ScrollingFrame.ScrollBarImageColor3 = UiButColor
	ScrollingFrame.Size = UDim2.new(1, 0, 1, -69)
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
	ScrollingFrameR15.Size = UDim2.new(1, 0, 1, -69)
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

	ScrollingFrameSpecific.Name = "ScrollingFrameSpecific"
	ScrollingFrameSpecific.Parent = MainFrame
	ScrollingFrameSpecific.BackgroundColor3 = ScrollBgColor
	ScrollingFrameSpecific.Position = UDim2.new(0, 0, 0, 34)
	ScrollingFrameSpecific.ScrollBarImageColor3 = UiButColor
	ScrollingFrameSpecific.Size = UDim2.new(1, 0, 1, -69)
	ScrollingFrameSpecific.CanvasSize = UDim2.new(0, 0, 0.5, 10)
	ScrollingFrameSpecific.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ScrollingFrameSpecific.Visible = false
	ScrollingFrameSpecific.ScrollBarThickness = 10

	local SFSpecListLayout = Instance.new("UIListLayout")
	SFSpecListLayout.Parent = ScrollingFrameSpecific
	SFSpecListLayout.FillDirection = Enum.FillDirection.Horizontal
	SFSpecListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	SFSpecListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SFSpecListLayout.Wraps = true
	SFSpecListLayout.Padding = UDim.new(0, 10)


	--Options Frame
	OptionsFrame.Parent = MainFrame
	OptionsFrame.Name = "OptionsFrame"
	OptionsFrame.AnchorPoint = Vector2.new(0.5, 0)
	OptionsFrame.Size = UDim2.new(0, 266, 0, 46)
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

	ReversePlayButton.Parent = OptionsFrame
	ReversePlayButton.Name = "ReversePlayButton"
	ReversePlayButton.ZIndex = 0
	ReversePlayButton.Size = UDim2.new(0, 100, 0, 100)
	ReversePlayButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ReversePlayButton.BorderSizePixel = 0
	ReversePlayButton.BackgroundColor3 = ButtonCol
	ReversePlayButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
	ReversePlayButton.Image = "rbxassetid://131026391298968"
	AddHoverText(ReversePlayButton, "Reverse Animation")

	SitButton.Name = "SitButton"
	SitButton.Size = UDim2.new(0, 100, 0, 100)
	SitButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SitButton.BorderSizePixel = 0
	SitButton.BackgroundColor3 = ButtonCol
	SitButton.Image = "rbxassetid://94572819761865"
	SitButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
	SitButton.Parent = OptionsFrame
	SitButton.ZIndex = 0
	AddHoverText(SitButton, "Ragdoll-like falling with sit animation")

	EmoteWheelButton.Parent = OptionsFrame
	EmoteWheelButton.Name = "EmoteWheelButton"
	EmoteWheelButton.ZIndex = 0
	EmoteWheelButton.Size = UDim2.new(0, 100, 0, 100)
	EmoteWheelButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	EmoteWheelButton.BorderSizePixel = 0
	EmoteWheelButton.BackgroundColor3 = ButtonCol
	EmoteWheelButton.ImageColor3 = UiButColor
	EmoteWheelButton.Image = "rbxassetid://104869367027493"
	EmoteWheelButton.ScaleType = Enum.ScaleType.Crop
	AddHoverText(EmoteWheelButton, "Show Emote wheel")


	--Search Box
	SearchFrame.Parent = MainFrame
	SearchFrame.Name = "SearchFrame"
	SearchFrame.ZIndex = 0
	SearchFrame.AnchorPoint = Vector2.new(1, 0)
	SearchFrame.Size = UDim2.new(0, 164, 0, 35)
	SearchFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchFrame.Position = UDim2.new(1, 31, 0, 34)
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
	AddHoverText(SearchButton, "Search")

	SearchBox.Name = "SearchBox"
	SearchBox.ZIndex = 0
	SearchBox.Visible = false
	SearchBox.AnchorPoint = Vector2.new(0.5, 0)
	SearchBox.Size = UDim2.new(0, 139, 0, 29)
	SearchBox.LayoutOrder = 1
	SearchBox.Position = UDim2.new(0.469697, 0, 0.075, 0)
	SearchBox.BackgroundColor3 = ScrollBgColor
	SearchBox.TextColor3 = UiButColor
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
	CustomAnimFrame.Parent = MainFrame
	CustomAnimFrame.Name = "CustomAnimFrame"
	CustomAnimFrame.ZIndex = 0
	CustomAnimFrame.AnchorPoint = Vector2.new(1, 0)
	CustomAnimFrame.Size = UDim2.new(0, 194, 0, 35)
	CustomAnimFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CustomAnimFrame.Position = UDim2.new(1, 31, 0, 73)
	CustomAnimFrame.BorderSizePixel = 0
	CustomAnimFrame.BackgroundColor3 = BgColor

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

	IdBox.Name = "IdBox"
	IdBox.ZIndex = 0
	IdBox.Visible = false
	IdBox.AnchorPoint = Vector2.new(0.5, 0)
	IdBox.Size = UDim2.new(0, 140, 0, 29)
	IdBox.LayoutOrder = 1
	IdBox.Position = UDim2.new(0.469697, 0, 0.075, 0)
	IdBox.BackgroundColor3 = ScrollBgColor
	IdBox.TextWrapped = true
	IdBox.TextColor3 = UiButColor
	IdBox.PlaceholderText = "Enter Id..."
	IdBox.Text = ""
	IdBox.CursorPosition = -1
	IdBox.Font = Enum.Font.SourceSans
	IdBox.TextXAlignment = Enum.TextXAlignment.Left
	IdBox.ClearTextOnFocus = false
	IdBox.TextScaled = true
	IdBox.Parent = CustomAnimFrame

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
	PlayAnimButton.Image = "rbxassetid://15081504003"
	PlayAnimButton.Parent = CustomAnimFrame
	AddHoverText(PlayAnimButton, "Add animation (On start of Gui)")


	--Choose ScrollingFrame Buttons
	DefaultSection.Parent = MainFrame
	DefaultSection.Name = "DefaultSection"
	DefaultSection.ZIndex = 0
	DefaultSection.AnchorPoint = Vector2.new(1, 0)
	DefaultSection.Size = UDim2.new(0, 52, 0, 32)
	DefaultSection.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DefaultSection.Position = UDim2.new(1, 51, 1, -104)
	DefaultSection.BorderSizePixel = 0
	DefaultSection.BackgroundColor3 = BgColor
	DefaultSection.TextSize = 26
	DefaultSection.TextColor3 = UiButColor
	DefaultSection.RichText = true
	DefaultSection.Text = "<b>R</b>"
	if RigType == "R15" then
		DefaultSection.Text = "<b>R15</b>"
	elseif RigType == "R6" then
		DefaultSection.Text = "<b>R6</b>"
	end
	DefaultSection.Font = Enum.Font.Roboto
	DefaultSection.TextXAlignment = Enum.TextXAlignment.Left
	AddHoverText(DefaultSection, "Default Animations")

	SpecGameSection.Parent = MainFrame
	SpecGameSection.Name = "SpecGameSection"
	SpecGameSection.ZIndex = 0
	SpecGameSection.AnchorPoint = Vector2.new(1, 0)
	SpecGameSection.Size = UDim2.new(0, 72, 0, 32)
	SpecGameSection.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SpecGameSection.Position = UDim2.new(1, 71, 1, -68)
	SpecGameSection.BorderSizePixel = 0
	SpecGameSection.BackgroundColor3 = BgColor
	SpecGameSection.TextSize = 26
	SpecGameSection.TextColor3 = UiButColor
	SpecGameSection.RichText = true
	SpecGameSection.Text = "<b>Game</b>"
	SpecGameSection.Font = Enum.Font.Roboto
	SpecGameSection.TextXAlignment = Enum.TextXAlignment.Left


	--EmoteWheel
	EmoteWheel.Parent = Emoter
	EmoteWheel.Name = "EmoteWheel"
	EmoteWheel.AnchorPoint = Vector2.new(0.5, 0.5)
	EmoteWheel.Size = UDim2.new(0, 380, 0, 380)
	EmoteWheel.BackgroundTransparency = 1
	EmoteWheel.Position = UDim2.new(0.5, 0, 0.5, 0)
	EmoteWheel.Visible = false
	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	UIAspectRatioConstraint.Parent = EmoteWheel

	local ShadowFrame = Instance.new("Frame")
	ShadowFrame.Parent = EmoteWheel
	ShadowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	ShadowFrame.Size = UDim2.new(1, 0, 1, 0)
	ShadowFrame.Position = UDim2.new(0.5,0,0.5,0)
	ShadowFrame.BackgroundTransparency = 1
	ShadowFrame.ZIndex = 100

	local UICorner = Instance.new("UICorner")
	UICorner.Parent = ShadowFrame
	UICorner.CornerRadius = UDim.new(1, 0)

	local OutUIShadow = Instance.new("UIShadow")
	OutUIShadow.Parent = ShadowFrame
	OutUIShadow.BlurRadius = UDim.new(0, 15)
	OutUIShadow.Transparency = 0.35
	OutUIShadow.Spread = UDim2.new(0.19, 0, 0.19, 0)
	OutUIShadow.ZIndex = 100
	local InUIShadow = Instance.new("UIShadow")
	InUIShadow.Parent = ShadowFrame
	InUIShadow.BlurRadius = UDim.new(0, 15)
	InUIShadow.Transparency = 0.35
	InUIShadow.Spread = UDim2.new(-0.4, 0, -0.4, 0)
	InUIShadow.ZIndex = 100

	EmoteWheelText.Parent = EmoteWheel
	EmoteWheelText.Name = "Text"
	EmoteWheelText.AnchorPoint = Vector2.new(0.5, 0.5)
	EmoteWheelText.Size = UDim2.new(0.5, 0, 0.1, 0)
	EmoteWheelText.BackgroundTransparency = 1
	EmoteWheelText.Position = UDim2.new(0.5, 0, 0.5, 0)
	EmoteWheelText.TextStrokeTransparency = 0
	EmoteWheelText.TextSize = 14
	EmoteWheelText.TextColor3 = Color3.fromRGB(255, 255, 255)
	EmoteWheelText.RichText = true
	EmoteWheelText.Font = Enum.Font.Roboto
	EmoteWheelText.Text = "<b>Select an Emote</b>"
	EmoteWheelText.TextScaled = true
	EmoteWheelText.ZIndex = 100

	Emote1.Name = "Emote1"
	Emote1.AnchorPoint = Vector2.new(0.5, 0.5)
	Emote1.Size = UDim2.new(0.23, 0, 0.23, 0)
	Emote1.Position = UDim2.new(0.5, 0, 0.09, 0)
	Emote1.BackgroundColor3 = ButtonCol
	Emote1.TextColor3 = UiButColor
	Emote1.Font = Enum.Font.SourceSansBold
	Emote1.TextScaled = true
	Emote1.ZIndex = 100
	Emote1.Parent = EmoteWheel

	Emote2.Name = "Emote2"
	Emote2.AnchorPoint = Vector2.new(0.5, 0.5)
	Emote2.Size = UDim2.new(0.23, 0, 0.23, 0)
	Emote2.Position = UDim2.new(0.8, 0, 0.2, 0)
	Emote2.BackgroundColor3 = ButtonCol
	Emote2.TextColor3 = UiButColor
	Emote2.Font = Enum.Font.SourceSansBold
	Emote2.TextScaled = true
	Emote2.ZIndex = 100
	Emote2.Parent = EmoteWheel

	Emote3.Name = "Emote3"
	Emote3.AnchorPoint = Vector2.new(0.5, 0.5)
	Emote3.Size = UDim2.new(0.23, 0, 0.23, 0)
	Emote3.Position = UDim2.new(0.91, 0, 0.5, 0)
	Emote3.BackgroundColor3 = ButtonCol
	Emote3.TextColor3 = UiButColor
	Emote3.Font = Enum.Font.SourceSansBold
	Emote3.TextScaled = true
	Emote3.ZIndex = 100
	Emote3.Parent = EmoteWheel

	Emote4.Name = "Emote4"
	Emote4.AnchorPoint = Vector2.new(0.5, 0.5)
	Emote4.Size = UDim2.new(0.23, 0, 0.23, 0)
	Emote4.Position = UDim2.new(0.8, 0, 0.8, 0)
	Emote4.BackgroundColor3 = ButtonCol
	Emote4.TextColor3 = UiButColor
	Emote4.Font = Enum.Font.SourceSansBold
	Emote4.TextScaled = true
	Emote4.ZIndex = 100
	Emote4.Parent = EmoteWheel

	Emote5.Name = "Emote5"
	Emote5.AnchorPoint = Vector2.new(0.5, 0.5)
	Emote5.Size = UDim2.new(0.23, 0, 0.23, 0)
	Emote5.Position = UDim2.new(0.5, 0, 0.91, 0)
	Emote5.BackgroundColor3 = ButtonCol
	Emote5.TextColor3 = UiButColor
	Emote5.Font = Enum.Font.SourceSansBold
	Emote5.TextScaled = true
	Emote5.ZIndex = 100
	Emote5.Parent = EmoteWheel

	Emote6.Name = "Emote6"
	Emote6.AnchorPoint = Vector2.new(0.5, 0.5)
	Emote6.Size = UDim2.new(0.23, 0, 0.23, 0)
	Emote6.Position = UDim2.new(0.2, 0, 0.8, 0)
	Emote6.BackgroundColor3 = ButtonCol
	Emote6.TextColor3 = UiButColor
	Emote6.Font = Enum.Font.SourceSansBold
	Emote6.TextScaled = true
	Emote6.ZIndex = 100
	Emote6.Parent = EmoteWheel

	Emote7.Name = "Emote7"
	Emote7.AnchorPoint = Vector2.new(0.5, 0.5)
	Emote7.Size = UDim2.new(0.23, 0, 0.23, 0)
	Emote7.Position = UDim2.new(0.09, 0, 0.5, 0)
	Emote7.BackgroundColor3 = ButtonCol
	Emote7.TextColor3 = UiButColor
	Emote7.Font = Enum.Font.SourceSansBold
	Emote7.TextScaled = true
	Emote7.ZIndex = 100
	Emote7.Parent = EmoteWheel

	Emote8.Name = "Emote8"
	Emote8.AnchorPoint = Vector2.new(0.5, 0.5)
	Emote8.Size = UDim2.new(0.23, 0, 0.23, 0)
	Emote8.Position = UDim2.new(0.2, 0, 0.2, 0)
	Emote8.BackgroundColor3 = ButtonCol
	Emote8.TextColor3 = UiButColor
	Emote8.Font = Enum.Font.SourceSansBold
	Emote8.TextScaled = true
	Emote8.ZIndex = 100
	Emote8.Parent = EmoteWheel


	--SettingsFrame
	CreateDivideFrame("Animation", 1, "Settings")
	CreateDivideFrame("Running & Idle", 2, "Settings")
	CreateDivideFrame("Style", 3, "Settings")
	CreateDivideFrame("Hotkeys", 4, "Settings")
	CreateDivideFrame("Data", 5, "Settings")

	SettingsFrame.Parent = Emoter
	SettingsFrame.Name = "SettingsFrame"
	SettingsFrame.AnchorPoint = Vector2.new(0.5, 0)
	SettingsFrame.Size = UDim2.new(0, 220, 0, 286)
	SettingsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SettingsFrame.Position = MainFrame.Position + UDim2.new(0, 590, 0, 0)
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

	AutorText.Name = "AutorText"
	AutorText.Size = UDim2.new(1, 0, -0.025, 25)
	AutorText.LayoutOrder = 1
	AutorText.BackgroundTransparency = 1
	AutorText.Position = UDim2.new(-0.0069782, 0, 0.0940293, 0)
	AutorText.TextSize = 14
	AutorText.Text = "by Fixel"
	AutorText.Font = Enum.Font.SourceSans
	AutorText.TextScaled = true
	AutorText.TextColor3 = UiButColor
	AutorText.Parent = SettingsFrame

	VersionText.Parent = SettingsFrame
	VersionText.Name = "VersionText"
	VersionText.AnchorPoint = Vector2.new(1, 0)
	VersionText.Size = UDim2.new(0.2124352, 0, -0.025, 25)
	VersionText.LayoutOrder = 1
	VersionText.BackgroundTransparency = 1
	VersionText.Position = UDim2.new(1, -2, 0, 0)
	VersionText.TextSize = 14
	VersionText.Text = ScriptVersion
	VersionText.TextColor3 = Color3.fromRGB(147, 147, 147)
	VersionText.TextWrapped = true
	VersionText.Font = Enum.Font.SourceSans
	VersionText.TextXAlignment = Enum.TextXAlignment.Right
	VersionText.TextYAlignment = Enum.TextYAlignment.Top

	SettingsStuff.Name = "SettingsStuff"
	SettingsStuff.Size = UDim2.new(1, 0, 0.648, 0)
	SettingsStuff.BackgroundTransparency = 1
	SettingsStuff.Position = UDim2.new(0, 0, 0.18, 0)
	SettingsStuff.ScrollBarImageColor3 = UiButColor
	SettingsStuff.CanvasSize = UDim2.new(0, 0, 0.5, 10)
	SettingsStuff.AutomaticCanvasSize = Enum.AutomaticSize.Y
	SettingsStuff.ScrollBarThickness = 3
	SettingsStuff.Parent = SettingsFrame

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = SettingsStuff

	ThemeOption.Name = "ThemeOption"
	ThemeOption.Size = UDim2.new(1, 0, 0, 25)
	ThemeOption.LayoutOrder = 3
	ThemeOption.BackgroundTransparency = 1
	ThemeOption.Parent = SettingsStuff

	local UIListLayout5 = Instance.new("UIListLayout")
	UIListLayout5.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout5.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout5.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout5.Padding = UDim.new(0, 5)
	UIListLayout5.Parent = ThemeOption

	ThemeOptionText.Name = "ThemeOptionText"
	ThemeOptionText.Size = UDim2.new(0, 124, 0, 25)
	ThemeOptionText.BackgroundTransparency = 1
	ThemeOptionText.TextSize = 14
	ThemeOptionText.TextColor3 = UiButColor
	ThemeOptionText.Text = "Theme"
	ThemeOptionText.Font = Enum.Font.SourceSans
	ThemeOptionText.TextXAlignment = Enum.TextXAlignment.Left
	ThemeOptionText.Parent = ThemeOption

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

	BlackThemeColor.Name = "BlackThemeColor"
	BlackThemeColor.Size = UDim2.new(0, 15, 0, 15)
	BlackThemeColor.LayoutOrder = 1
	BlackThemeColor.BorderColor3 = UiButColor
	BlackThemeColor.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
	BlackThemeColor.Text = ""
	BlackThemeColor.Parent = ThemeOption
	AddHoverText(BlackThemeColor, "Black theme")

	local YSizeOption = Instance.new("Frame")
	YSizeOption.Parent = SettingsStuff
	YSizeOption.Name = "YSizeOptionOption"
	YSizeOption.Size = UDim2.new(1, 0, 0, 25)
	YSizeOption.LayoutOrder = 3
	YSizeOption.BackgroundTransparency = 1

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)
	UIListLayout.Parent = YSizeOption

	local YSizeOptionText = Instance.new("TextLabel")
	YSizeOptionText.Name = "YSizeOptionText"
	YSizeOptionText.Size = UDim2.new(0, 94, 0, 25)
	YSizeOptionText.BackgroundTransparency = 1
	YSizeOptionText.TextSize = 14
	YSizeOptionText.TextColor3 = Color3.fromRGB(0, 0, 0)
	YSizeOptionText.Text = "Vertical size"
	YSizeOptionText.Font = Enum.Font.SourceSans
	YSizeOptionText.TextXAlignment = Enum.TextXAlignment.Left
	YSizeOptionText.Parent = YSizeOption

	local UIPadding = Instance.new("UIPadding")
	UIPadding.PaddingBottom = UDim.new(0, 2)
	UIPadding.Parent = YSizeOptionText

	local X05YSixe = Instance.new("TextButton")
	X05YSixe.Name = "X05YSixe"
	X05YSixe.Size = UDim2.new(0, 25, 0, 15)
	X05YSixe.BorderColor3 = Color3.fromRGB(0, 0, 0)
	X05YSixe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	X05YSixe.Text = "0.5x"
	X05YSixe.Parent = YSizeOption

	local X1YSize = Instance.new("TextButton")
	X1YSize.Name = "X1YSize"
	X1YSize.Size = UDim2.new(0, 20, 0, 15)
	X1YSize.BorderColor3 = Color3.fromRGB(0, 0, 0)
	X1YSize.Position = UDim2.new(0.5861111, 0, 0.2, 0)
	X1YSize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	X1YSize.Text = "1x"
	X1YSize.Parent = YSizeOption

	local X15YSize = Instance.new("TextButton")
	X15YSize.Name = "X15YSize"
	X15YSize.Size = UDim2.new(0, 25, 0, 15)
	X15YSize.BorderColor3 = Color3.fromRGB(0, 0, 0)
	X15YSize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	X15YSize.Text = "1.5x"
	X15YSize.Parent = YSizeOption

	local X2YSize = Instance.new("TextButton")
	X2YSize.Name = "X2YSize"
	X2YSize.Size = UDim2.new(0, 20, 0, 15)
	X2YSize.BorderColor3 = Color3.fromRGB(0, 0, 0)
	X2YSize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	X2YSize.Text = "2x"
	X2YSize.Parent = YSizeOption

	local XSizeOption = Instance.new("Frame")
	XSizeOption.Parent = SettingsStuff
	XSizeOption.Name = "XSizeOption"
	XSizeOption.Size = UDim2.new(1, 0, 0, 25)
	XSizeOption.LayoutOrder = 3
	XSizeOption.BackgroundTransparency = 1

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)
	UIListLayout.Parent = XSizeOption

	local XSizeOptionText = Instance.new("TextLabel")
	XSizeOptionText.Name = "XSizeOptionText"
	XSizeOptionText.Size = UDim2.new(0, 104, 0, 25)
	XSizeOptionText.BackgroundTransparency = 1
	XSizeOptionText.TextSize = 14
	XSizeOptionText.TextColor3 = Color3.fromRGB(0, 0, 0)
	XSizeOptionText.Text = "Horizontal size"
	XSizeOptionText.Font = Enum.Font.SourceSans
	XSizeOptionText.TextXAlignment = Enum.TextXAlignment.Left
	XSizeOptionText.Parent = XSizeOption

	local UIPadding = Instance.new("UIPadding")
	UIPadding.PaddingBottom = UDim.new(0, 2)
	UIPadding.Parent = XSizeOptionText

	local X2Size = Instance.new("TextButton")
	X2Size.Name = "X2Sixe"
	X2Size.Size = UDim2.new(0, 20, 0, 15)
	X2Size.BorderColor3 = Color3.fromRGB(0, 0, 0)
	X2Size.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	X2Size.Text = "2x"
	X2Size.Parent = XSizeOption

	local X3Size = Instance.new("TextButton")
	X3Size.Name = "X3Size"
	X3Size.Size = UDim2.new(0, 20, 0, 15)
	X3Size.BorderColor3 = Color3.fromRGB(0, 0, 0)
	X3Size.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	X3Size.Text = "3x"
	X3Size.Parent = XSizeOption

	local X4Size = Instance.new("TextButton")
	X4Size.Name = "X4Size"
	X4Size.Size = UDim2.new(0, 20, 0, 15)
	X4Size.BorderColor3 = Color3.fromRGB(0, 0, 0)
	X4Size.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	X4Size.Text = "4x"
	X4Size.Parent = XSizeOption

	local X5Size = Instance.new("TextButton")
	X5Size.Name = "X5Size"
	X5Size.Size = UDim2.new(0, 20, 0, 15)
	X5Size.BorderColor3 = Color3.fromRGB(0, 0, 0)
	X5Size.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	X5Size.Text = "5x"
	X5Size.Parent = XSizeOption

	AddSettings(AnimPreviewEnabled, "PreviewOption", "Enable Animation Preview", 0)
	AddSettings(DebugInfoEnabled, "DebugInfoOption", "Show Debug information", 0)
	AddSettings(AnalyticsEnabled, "AnalyticsOption", "Enable analytics (hover for info)", 0)
	AddSettings(LoadAnimationsOnRestart, "LoadAnimationsOnRestartOption", "Play 'Running' & 'Idle' anims on reset", 0)

	AddSettings(ToolIdleAnimHighPriorEnabled, "ToolIdlePriorityOption", "High priority on ToolIdle anims", 1)
	AddSettings(ToolActionAnimHighPriorEnabled, "ToolActionPriorityOption", "High priority on ToolAction anims", 1)
	AddSettings(AnimSwitchModeEnabled, "SwitchOption", "Anims Switch mode", 1)
	AddSettings(AnimSwitchModeRunIdleExceptionEnabled, "SwitchRunIdleExceptionOption", "Exception for 'Running' and 'Idle'", 1)
	AddSettings(AnimSmoothFadeEnabled, "AnimFadeOption", "Anim smooth Start/Stop", 1)
	AddSettings(HigherPriorityEnabled, "HigherPriorityOption", "Animations Higher priority", 1)

	AddSettings(IdleTypeEnabled, "IdleTypeOption", "Enable 'Idle' type", 2)
	AddSettings(RunningTypeEnabled, "RunningTypeOption", "Enable 'Running' type", 2)
	AddSettings(RunningTypeStopStandingEnabled, "RunningTypeStopStandingOption", "Stop animation while not running", 2)
	AddSettings(RunningTypeCharSpeedEnabled, "RunningTypeCharSpeedOption", "AnimSpeed depends on character's", 2)
	AddSettings(RunningTypeMinSpeedEnabled, "RunningTypeMinSpeedOption", "Enable 'MinimumSpeed' value", 2)
	AddSettings(RunningTypeStopJumpingEnabled, "RunningTypeStopJumpingOption", "Stop animation while jumping", 2)
	AddSettings(RunningTypeStopClimbingEnabled, "RunningTypeStopClimbingOption", "Stop animation while climbing", 2)

	AddSettings(UICornerEnabled, "UICornerOption", "Enable UICorners", 3)
	AddSettings(UIGradientEnabled, "UIGradientOption", "Enable UIGradients", 3)
	AddSettings(HotkeysEnabled, "HotkeysOption", "Enable Hotkeys", 4)

	AddSettings(LoadGithubSGAEnabled, "LoadGithubSGAOption", "Load SpecificGameAnims from Github", 5)
	AddSettings(LoadGithubCustomAnimsEnabled, "LoadGithubCustomAnimOption", "Load AdditionalAnims from Github", 5)
	AddSettings(LoadLocalSGAEnabled, "LoadLocalSGAOption", "Load SpecificGameAnims from local", 5)
	AddSettings(LoadLocalCustomAnimsEnabled, "LoadLocalCustomAnimOption", "Load AdditionalAnims from local", 5)

	HotkeysEditOption.Name = "HotkeysEditOption"
	HotkeysEditOption.Size = UDim2.new(0.55, 0, 0, 20)
	HotkeysEditOption.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HotkeysEditOption.LayoutOrder = 4
	HotkeysEditOption.Position = UDim2.new(0, 0, 0.1558714, 0)
	HotkeysEditOption.BorderSizePixel = 0
	HotkeysEditOption.BackgroundColor3 = ButtonCol
	HotkeysEditOption.TextColor3 = UiButColor
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

	HotkeysFrame.Name = "HotkeysFrame"
	HotkeysFrame.AnchorPoint = Vector2.new(0, 0.5)
	HotkeysFrame.Size = UDim2.new(0, 190, 0, 138)
	HotkeysFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HotkeysFrame.Position = UDim2.new(1, 10, 0.76, 0)
	HotkeysFrame.BorderSizePixel = 0
	HotkeysFrame.BackgroundColor3 = ScrollBgColor
	HotkeysFrame.Visible = false
	HotkeysFrame.Parent = SettingsFrame

	HotkeysStuff.Name = "HotkeysStuff"
	HotkeysStuff.Size = UDim2.new(1, 0, 0.845, 0)
	HotkeysStuff.BackgroundTransparency = 1
	HotkeysStuff.Position = UDim2.new(0, 0, 0.155, 0)
	HotkeysStuff.ScrollBarImageColor3 = UiButColor
	HotkeysStuff.CanvasSize = UDim2.new(0, 0, 0.5, 10)
	HotkeysStuff.AutomaticCanvasSize = Enum.AutomaticSize.Y
	HotkeysStuff.HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar
	HotkeysStuff.ScrollBarThickness = 3
	HotkeysStuff.Parent = HotkeysFrame

	local UIListLayout8 = Instance.new("UIListLayout")
	UIListLayout8.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout8.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout8.Parent = HotkeysStuff

	HotkeyFrameName.Name = "Name"
	HotkeyFrameName.Size = UDim2.new(1, 0, -0.043, 25)
	HotkeyFrameName.BackgroundTransparency = 1
	HotkeyFrameName.Position = UDim2.new(0, 0, 0.018, 0)
	HotkeyFrameName.TextColor3 = UiButColor
	HotkeyFrameName.TextSize = 14
	HotkeyFrameName.Text = "Hotkeys"
	HotkeyFrameName.TextWrapped = true
	HotkeyFrameName.Font = Enum.Font.Highway
	HotkeyFrameName.TextScaled = true
	HotkeyFrameName.Parent = HotkeysFrame

	AddHotkey(SearchHotkey, "SearchHotkey", "Search")
	AddHotkey(CloseHotkey, "CloseHotkey", "Close/Open Gui")
	AddHotkey(SitHotkey, "SitHotkey", "Ragdoll-like falling")
	AddHotkey(SettingsHotkey, "SettingsHotkey", "Open Settings")
	AddHotkey(SwitchAnimHotkey, "SwitchAnimHotkey", "Switch Anim Setting")
	AddHotkey(AnimFadeHotkey, "AnimFadeHotkey", "Animation Fade Setting")
	AddHotkey(StopAnimsHotkey, "StopAnimsHotkey", "Stop all Animations")
	AddHotkey(EmoteWheelHotkey, "EmoteWheelHotkey", "Open Emote Wheel")

	MoreButtonsFrame.Parent = SettingsFrame
	MoreButtonsFrame.Name = "MoreButtonsFrame"
	MoreButtonsFrame.Interactable = true
	MoreButtonsFrame.AnchorPoint = Vector2.new(0, 1)
	MoreButtonsFrame.Size = UDim2.new(1, 0, 0, 50)
	MoreButtonsFrame.BackgroundTransparency = 1
	MoreButtonsFrame.Position = UDim2.new(0, 0, 1, 0)

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 22)
	UIListLayout.Parent = MoreButtonsFrame

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

	LaunchIdDetectorButton.Name = "LaunchIdDetectorButton"
	LaunchIdDetectorButton.Size = UDim2.new(0, 35, 0, 35)
	LaunchIdDetectorButton.Position = UDim2.new(0.4093264, 0, 0.845614, 0)
	LaunchIdDetectorButton.BackgroundColor3 = ButtonCol
	LaunchIdDetectorButton.ImageColor3 = UiButColor
	LaunchIdDetectorButton.Image = "rbxassetid://88751076321975"
	LaunchIdDetectorButton.Parent = MoreButtonsFrame
	AddHoverText(LaunchIdDetectorButton, "Launch IdDetector Script")

	ResetButton.Parent = MoreButtonsFrame
	ResetButton.Name = "ResetButton"
	ResetButton.Size = UDim2.new(0, 35, 0, 35)
	ResetButton.Position = UDim2.new(0.2487047, 0, 0.8561404, 0)
	ResetButton.BackgroundColor3 = ButtonCol
	ResetButton.Image = "rbxassetid://84090157888894"
	ResetButton.ImageColor3 = UiButColor
	AddHoverText(ResetButton, "Reset Gui")

	GithubLinkButton.Name = "GithubLinkButton"
	GithubLinkButton.Size = UDim2.new(0, 35, 0, 35)
	GithubLinkButton.Position = UDim2.new(0.7720207, 0, 0.845614, 0)
	GithubLinkButton.BackgroundColor3 = ButtonCol
	GithubLinkButton.Image = "rbxassetid://133448000957069"
	GithubLinkButton.ImageColor3 = UiButColor
	GithubLinkButton.Parent = MoreButtonsFrame
	AddHoverText(GithubLinkButton, "Get the Github for Tutorials and more Info! (Copy Link)")


	-- Buttons and other functions
	print("Loading buttons and other functions...")
	DestroyGUI.MouseButton1Click:connect(function()
		GuiActive = false
		StopAnimsEvent:Fire("Reset/Destroy")
		Emoter:Destroy()
	end)
	SFDestroyGUI.MouseButton1Click:connect(function()
		GuiActive = false
		StopAnimsEvent:Fire("Reset/Destroy")
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

	if RigType == "R15" then
		ScrollingFrame.Visible = false
		ScrollingFrameR15.Visible = true
		Title.Text = "Emoter GUI (R15)"
		SideFrameTitle.Text = "Emoter GUI (R15)"
	else
		ScrollingFrame.Visible = true
		ScrollingFrameR15.Visible = false
		Title.Text = "Emoter GUI (R6)"
		SideFrameTitle.Text = "Emoter GUI (R6)"
	end

	SpeedValue.Changed:Connect(function()
		SpeedNum = SpeedValue.Text
		if SpeedValue.Text == "" then
			SpeedNum = 0
		end
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


	--Searchbox
	local SearchButtonClick = true
	SearchButton.MouseButton1Click:Connect(function()
		if SearchButtonClick == true then
			SearchButtonClick = false
			SearchButton.Visible = false
			BackButton.Visible = true
			SearchBox.Visible = true
			SFUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
			game.TweenService:Create(SearchFrame, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Position = UDim2.new(1, 164, 0, 34)}):Play()
			wait(.3)
			SearchButtonClick = true
		end
	end)
	BackButton.MouseButton1Click:Connect(function()
		if SearchButtonClick == true then
			SearchButtonClick = false
			game.TweenService:Create(SearchFrame, TweenInfo.new(.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {Position = UDim2.new(1, 31, 0, 34)}):Play()
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
		SearchFrame.Position = UDim2.new(1, 164, 0, 34)
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


	--Custom Anim Search
	local CustomAnimButtonClick = true
	CustomAnimButton.MouseButton1Click:Connect(function()
		if CustomAnimButtonClick == true then
			CustomAnimButtonClick = false
			CustomAnimButton.Visible = false
			CustomAnimBackButton.Visible = true
			IdBox.Visible = true
			PlayAnimButton.Visible = true
			CAFUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
			game.TweenService:Create(CustomAnimFrame, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Position = UDim2.new(1, 194, 0, 73)}):Play()
			wait(.3)
			CustomAnimButtonClick = true
		end
	end)
	CustomAnimBackButton.MouseButton1Click:Connect(function()
		if CustomAnimButtonClick == true then
			CustomAnimButtonClick = false
			game.TweenService:Create(CustomAnimFrame, TweenInfo.new(.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {Position = UDim2.new(1, 31, 0, 73)}):Play()
			wait(.2)
			CAFUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
			CustomAnimButton.Visible = true
			CustomAnimBackButton.Visible = false
			IdBox.Visible = false
			PlayAnimButton.Visible = false
			CustomAnimButtonClick = true
		end
	end)

	PlayAnimButton.MouseButton1Click:Connect(function()
		if IdBox.Text == "" or string.match(IdBox.Text, "%a") then
			game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Error", Text = "Anim Id is empty or has letters", Duration = 3})
			return end

		local SameResult = false

		for _, Frame in ipairs(ScrollingFramesList) do
			for i, Result in ipairs(Frame:GetDescendants()) do
				if Result:IsA("TextButton") and Result.Name == IdBox.Text then
					SameResult = true
					game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Error", Text = "There's already Anim with this Id", Duration = 3})
					break
				end
			end
		end

		if SameResult == false then
			local Anim = Instance.new("TextButton")
			if RigType == "R6" then
				CreateAnimButton(Anim, IdBox.Text, IdBox.Text, "R6", 0)
			else
				CreateAnimButton(Anim, IdBox.Text, IdBox.Text, "R15", 0)
			end
			PlayAnim(Anim, IdBox.Text, .1, 1, "PriorLow", false)
			local UiStroke = Instance.new("UIStroke")
			UiStroke.Parent = Anim
			UiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		end

	end)

	if CustomAnimOpened == true then
		CustomAnimButton.Visible = false
		CustomAnimBackButton.Visible = true
		IdBox.Visible = true
		PlayAnimButton.Visible = true
		CAFUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		CustomAnimFrame.Position = UDim2.new(1, 194, 0, 73)
	end


	--Choose Section Buttons
	DefaultSection.MouseButton1Click:Connect(function()
		ScrollingFrameSpecific.Visible = false
		DefaultSection.UIStroke.Color = Color3.fromRGB(255, 255, 255)
		SpecGameSection.UIStroke.Color = Color3.fromRGB(0, 0, 0)
		if RigType == "R6" then
			ScrollingFrame.Visible = true
			ScrollingFrameR15.Visible = false
		else
			ScrollingFrame.Visible = false
			ScrollingFrameR15.Visible = true
		end
	end)

	SpecGameSection.MouseButton1Click:Connect(function()
		SpecGameSection.UIStroke.Color = Color3.fromRGB(255, 255, 255)
		DefaultSection.UIStroke.Color = Color3.fromRGB(0, 0, 0)
		ScrollingFrameSpecific.Visible = true
		ScrollingFrame.Visible = false
		ScrollingFrameR15.Visible = false
	end)


	--Option Buttons
	local PauseDefAnimsOption = false
	PauseAnimsButton.MouseButton1Click:Connect(function()
		PauseDefAnimsOption = not PauseDefAnimsOption
		if PauseDefAnimsOption then
			local playingTracks = Player.Character.Humanoid:GetPlayingAnimationTracks()
			for _, animtrack in ipairs(playingTracks) do
				if animtrack.Name ~= "AAnimation" then
					animtrack:AdjustSpeed(0)
				end
			end
		else

			local playingTracks = Player.Character.Humanoid:GetPlayingAnimationTracks()
			for _, animtrack in ipairs(playingTracks) do
				if animtrack.Name ~= "AAnimation" then
					animtrack:AdjustSpeed(1) -- always playing at speed 1. Gonna fix it (maybe)
				end
			end
		end
	end)

	PauseAnimateButton.MouseButton1Click:Connect(function()
		local AnimateScript = Player.Character:FindFirstChild(AnimationHandler)
		if AnimateScript.Disabled == false then
			AnimateScript.Disabled = true
			PauseAnimateButton.BackgroundColor3 = ButtonSelectCol
		else
			StopAnimsEvent:Fire("Forced")
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
			StopAnimsEvent:Fire("Forced")
			Player.Character.Animate.Disabled = false
			StopDefAnimsButton.BackgroundColor3 = ButtonCol

			PauseDefAnimsOption = false
			PauseAnimsButton.BackgroundColor3 = ButtonCol
			PauseAnimateButton.BackgroundColor3 = ButtonCol
			PauseAnimateButton.ImageTransparency = 0
			PauseAnimateButton.Interactable = true
		end
	end)

	local AnimReversed = false
	ReversePlayButton.MouseButton1Click:Connect(function()
		AnimReversed = not AnimReversed
		if AnimReversed then
			NegativeNumber = -1
			ReversePlayButton.BackgroundColor3 = ButtonSelectCol
		else
			NegativeNumber = 1
			ReversePlayButton.BackgroundColor3 = ButtonCol
		end
	end)
	EmoteWheelButton.MouseButton1Click:Connect(function()
		EmoteWheel.Visible = true
	end)

	SitButton.MouseButton1Click:Connect(function()
		if Humanoid.Sit == false then
			Humanoid.Sit = true
		else
			Humanoid.Sit = false
		end
	end)

	--Settings buttons
	local PreviewOptionButton = SettingsStuff.PreviewOption
	PreviewOptionButton.MouseButton1Click:Connect(function()
		AnimPreviewEnabled = not AnimPreviewEnabled
		if AnimPreviewEnabled == true then
			PreviewOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			ViewportFrame.Visible = false
			PreviewOptionButton.CheckImage.Image = ""
		end
	end)

	local DebugInfoButton = SettingsStuff.DebugInfoOption
	AddHoverText(DebugInfoButton, "Show debug information in Developer console (Animation data and other things)")
	DebugInfoButton.MouseButton1Click:Connect(function()
		DebugInfoEnabled = not DebugInfoEnabled
		if DebugInfoEnabled == true then
			DebugInfoButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			DebugInfoButton.CheckImage.Image = ""
		end
	end)

	local AnalyticsButton = SettingsStuff.AnalyticsOption
	AddHoverText(AnalyticsButton, "<b>DISCLAIMER</b>: these analytics are made only to see NUMBER of people using my script. I don't save or even share any personal data, UserId, Username and any other data")
	AnalyticsButton.MouseButton1Click:Connect(function()
		AnalyticsEnabled = not AnalyticsEnabled
		if AnalyticsEnabled == true then
			AnalyticsButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			AnalyticsButton.CheckImage.Image = ""
		end
	end)
	
	local LoadAnimationsOnRestartButton = SettingsStuff.LoadAnimationsOnRestartOption
	AddHoverText(LoadAnimationsOnRestartButton, "Automatically plays 'Running' and 'Idle' animations when you restart GUI or when your character reappears")
	LoadAnimationsOnRestartButton.MouseButton1Click:Connect(function()
		LoadAnimationsOnRestart = not LoadAnimationsOnRestart
		if LoadAnimationsOnRestart == true then
			LoadAnimationsOnRestartButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			LoadAnimationsOnRestartButton.CheckImage.Image = ""
		end
	end)

	if ToolIdleAnimHighPriorEnabled or ToolActionAnimHighPriorEnabled then
		ToolAnimHighPriorEnabled = true
	else
		ToolAnimHighPriorEnabled = false
	end

	local function ToolAnimPriorityCheck()
		if ToolAnimHighPriorEnabled == true then
			local playingTracks = Player.Character:WaitForChild("Humanoid"):GetPlayingAnimationTracks()
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

					if (table.find(ToolIdleAnimsList, animtrack.Name) or table.find(ToolIdleAnimsList, IdNumberString)) and animtrack.Name ~= "AAnimation" and ToolIdleAnimHighPriorEnabled then
						animtrack.Priority = Enum.AnimationPriority.Action4
						if HigherPriorityEnabled then
							animtrack:AdjustWeight(30000)
						end
					elseif (table.find(ToolActionAnimsList, animtrack.Name) or table.find(ToolActionAnimsList, IdNumberString)) and animtrack.Name ~= "AAnimation" and ToolActionAnimHighPriorEnabled then
						animtrack.Priority = Enum.AnimationPriority.Action4
						animtrack:AdjustWeight(10000)
						if HigherPriorityEnabled then
							animtrack:AdjustWeight(40000)
						else
							animtrack:AdjustWeight(10000)
						end
					end
				end
			else
				for _, animtrack in ipairs(playingTracks) do
					local animationObject = animtrack.Animation
					local IdNumberString = string.match(animationObject.AnimationId, "%d+") 

					if (table.find(ToolIdleAnimsList, animtrack.Name) or table.find(ToolIdleAnimsList, IdNumberString)) and animtrack.Name ~= "AAnimation" then
						animtrack.Priority = Enum.AnimationPriority.Idle
						animtrack:AdjustWeight(1)
					elseif (table.find(ToolActionAnimsList, animtrack.Name) or table.find(ToolActionAnimsList, IdNumberString)) and animtrack.Name ~= "AAnimation" then
						animtrack.Priority = Enum.AnimationPriority.Action
						animtrack:AdjustWeight(1)
					end
				end
			end
		end
	end

	Player.Character:WaitForChild("Humanoid").AnimationPlayed:Connect(function()
		if GuiActive and GuiRestarted == false then
			ToolAnimPriorityCheck()
		end
	end)

	local ToolIdleAnimPriorityButton = SettingsStuff.ToolIdlePriorityOption
	AddHoverText(ToolIdleAnimPriorityButton, "Makes tool <b>Idle</b> animations play even when your animations are playing (like white list). Doesn't work for ALL games and need to be configured. More information in my <b>Github</b>")
	ToolIdleAnimPriorityButton.MouseButton1Click:Connect(function()
		ToolIdleAnimHighPriorEnabled = not ToolIdleAnimHighPriorEnabled
		if ToolIdleAnimHighPriorEnabled or ToolActionAnimHighPriorEnabled then
			ToolAnimHighPriorEnabled = true
		else
			ToolAnimHighPriorEnabled = false
		end

		if ToolIdleAnimHighPriorEnabled == true then
			ToolIdleAnimPriorityButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			ToolIdleAnimPriorityButton.CheckImage.Image = ""
		end
		ToolAnimPriorityCheck()
	end)
	local ToolActionAnimPriorityButton = SettingsStuff.ToolActionPriorityOption
	AddHoverText(ToolActionAnimPriorityButton, "Makes tool <b>Action</b> or other <b>Action</b> animations play even when your animations are playing (like white list). Doesn't work for ALL games and need to be configured. More information in my <b>Github</b>")
	ToolActionAnimPriorityButton.MouseButton1Click:Connect(function()
		ToolActionAnimHighPriorEnabled = not ToolActionAnimHighPriorEnabled
		if ToolActionAnimHighPriorEnabled or ToolIdleAnimHighPriorEnabled then
			ToolAnimHighPriorEnabled = true
		else
			ToolAnimHighPriorEnabled = false
		end

		if ToolActionAnimHighPriorEnabled == true then
			ToolActionAnimPriorityButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			ToolActionAnimPriorityButton.CheckImage.Image = ""
		end
		ToolAnimPriorityCheck()
	end)

	local SwitchOptionButton = SettingsStuff.SwitchOption
	AddHoverText(SwitchOptionButton, "<b>Switching</b> animations instead of <b>layering</b>")
	SwitchOptionButton.MouseButton1Click:Connect(function()
		AnimSwitchModeEnabled = not AnimSwitchModeEnabled
		if AnimSwitchModeEnabled == true then
			SwitchOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			SwitchOptionButton.CheckImage.Image = ""
		end
	end)

	local SwitchRunIdleExceptionOptionButton = SettingsStuff.SwitchRunIdleExceptionOption
	AddHoverText(SwitchRunIdleExceptionOptionButton, "Make an exception of Switch mode for 'Running' and 'Idle' animation types")
	SwitchRunIdleExceptionOptionButton.MouseButton1Click:Connect(function()
		AnimSwitchModeRunIdleExceptionEnabled = not AnimSwitchModeRunIdleExceptionEnabled
		if AnimSwitchModeRunIdleExceptionEnabled == true then
			SwitchRunIdleExceptionOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			SwitchRunIdleExceptionOptionButton.CheckImage.Image = ""
		end
	end)

	local AnimFadeOptionButton = SettingsStuff.AnimFadeOption
	AddHoverText(AnimFadeOptionButton, "Enables <b>FadeTime</b> of animation. If disabled, animations will play instantly")
	AnimFadeOptionButton.MouseButton1Click:Connect(function()
		AnimSmoothFadeEnabled = not AnimSmoothFadeEnabled
		if AnimSmoothFadeEnabled == true then
			AnimFadeOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			AnimFadeOptionButton.CheckImage.Image = ""
		end
	end)

	local HigherPriorityOptionButton = SettingsStuff.HigherPriorityOption
	AddHoverText(HigherPriorityOptionButton, "Makes animations priority <b>higher</b>. This is made for games, where developers are making some or all of their animations with <b>Action4</b> priority (the highest one). Highly <b>not recommended</b> to use if not needed, as it uses high AnimWeight to overwrite animations, Which makes animations play not very good, especially if you play more than 1 animation")
	HigherPriorityOptionButton.MouseButton1Click:Connect(function()
		HigherPriorityEnabled = not HigherPriorityEnabled
		if HigherPriorityEnabled == true then
			HigherPriorityOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			HigherPriorityOptionButton.CheckImage.Image = ""
		end
	end)

	local IdleTypeOptionButton = SettingsStuff.IdleTypeOption
	AddHoverText(IdleTypeOptionButton, "Enables 'Idle' function of most of <b>idle-like</b> animations. With this function animation is playing only when your character isn't moving")
	IdleTypeOptionButton.MouseButton1Click:Connect(function()
		IdleTypeEnabled = not IdleTypeEnabled
		if IdleTypeEnabled == true then
			IdleTypeOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			IdleTypeOptionButton.CheckImage.Image = ""
		end
	end)

	local RunningTypeOptionButton = SettingsStuff.RunningTypeOption
	AddHoverText(RunningTypeOptionButton, "Enables 'Running' function of most of <b>running-like</b> animations. With this function animation speed is changing depending on the character's speed, and the animations themselves stop when your character stops")
	RunningTypeOptionButton.MouseButton1Click:Connect(function()
		RunningTypeEnabled = not RunningTypeEnabled
		if RunningTypeEnabled == true then
			RunningTypeOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			RunningTypeOptionButton.CheckImage.Image = ""
		end
	end)

	local RunningTypeStopStandingOptionButton = SettingsStuff.RunningTypeStopStandingOption
	AddHoverText(RunningTypeStopStandingOptionButton, "Stop animation when your character is <b>not moving (standing)</b> and play it again when your character is running")
	RunningTypeStopStandingOptionButton.MouseButton1Click:Connect(function()
		RunningTypeStopStandingEnabled = not RunningTypeStopStandingEnabled
		if RunningTypeStopStandingEnabled == true then
			RunningTypeStopStandingOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			RunningTypeStopStandingOptionButton.CheckImage.Image = ""
		end
	end)

	local RunningTypeStopJumpingOptionButton = SettingsStuff.RunningTypeStopJumpingOption
	AddHoverText(RunningTypeStopJumpingOptionButton, "Stop animation when your character is <b>jumping</b> and play it again when your character is running")
	RunningTypeStopJumpingOptionButton.MouseButton1Click:Connect(function()
		RunningTypeStopJumpingEnabled = not RunningTypeStopJumpingEnabled
		if RunningTypeStopJumpingEnabled == true then
			RunningTypeStopJumpingOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			RunningTypeStopJumpingOptionButton.CheckImage.Image = ""
		end
	end)

	local RunningTypeStopClimbingOptionButton = SettingsStuff.RunningTypeStopClimbingOption
	AddHoverText(RunningTypeStopClimbingOptionButton, "Stop animation when your character is <b>climbing</b> and play it again when your character is running")
	RunningTypeStopClimbingOptionButton.MouseButton1Click:Connect(function()
		RunningTypeStopClimbingEnabled = not RunningTypeStopClimbingEnabled
		if RunningTypeStopClimbingEnabled == true then
			RunningTypeStopClimbingOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			RunningTypeStopClimbingOptionButton.CheckImage.Image = ""
		end
	end)

	local RunningTypeCharSpeedOptionButton = SettingsStuff.RunningTypeCharSpeedOption
	AddHoverText(RunningTypeCharSpeedOptionButton, "Change animation speed depending on your character's speed")
	RunningTypeCharSpeedOptionButton.MouseButton1Click:Connect(function()
		RunningTypeCharSpeedEnabled = not RunningTypeCharSpeedEnabled
		if RunningTypeCharSpeedEnabled == true then
			RunningTypeCharSpeedOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			RunningTypeCharSpeedOptionButton.CheckImage.Image = ""
		end
	end)

	local RunningTypeMinSpeedOption = SettingsStuff.RunningTypeMinSpeedOption
	AddHoverText(RunningTypeMinSpeedOption, "Some animations uses Value for 'Running' type, like some <b>sprinting</b> animations. This Value is minimum WalkSpeed of your character needed for animation to play it. If your character's WalkSpeed is less than this minimum, animation won't play")
	RunningTypeMinSpeedOption.MouseButton1Click:Connect(function()
		RunningTypeMinSpeedEnabled = not RunningTypeMinSpeedEnabled
		if RunningTypeMinSpeedEnabled == true then
			RunningTypeMinSpeedOption.CheckImage.Image = "rbxassetid://130396712201457"
		else
			RunningTypeMinSpeedOption.CheckImage.Image = ""
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
		game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Changed theme", Text = "Changed theme to LightPurple, please restart GUI", Duration = 3})
	end)
	OrangeThemeColor.MouseButton1Click:Connect(function()
		theme = "LightOrange"
		game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Changed theme", Text = "Changed theme to LightOrange, please restart GUI", Duration = 3})
	end)
	YellowThemeColor.MouseButton1Click:Connect(function()
		theme = "LightYellow"
		game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Changed theme", Text = "Changed theme to LightYellow, please restart GUI", Duration = 3})
	end)
	BlackThemeColor.MouseButton1Click:Connect(function()
		theme = "Black"
		game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Changed theme", Text = "Changed theme to Black, please restart GUI", Duration = 3})
	end)

	local UICornerOptionButton = SettingsStuff.UICornerOption
	AddHoverText(UICornerOptionButton, "Enables rounded corners in GUI")
	UICornerOptionButton.MouseButton1Click:Connect(function()
		UICornerEnabled = not UICornerEnabled
		if UICornerEnabled == true then
			UICornerOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			UICornerOptionButton.CheckImage.Image = ""
		end
	end)

	local UIGradientOptionButton = SettingsStuff.UIGradientOption
	AddHoverText(UIGradientOptionButton, "Enables gradient in GUI")
	UIGradientOptionButton.MouseButton1Click:Connect(function()
		UIGradientEnabled = not UIGradientEnabled
		if UIGradientEnabled == true then
			UIGradientOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			UIGradientOptionButton.CheckImage.Image = ""
		end
	end)

	X05YSixe.MouseButton1Click:Connect(function()
		YSize = 209
		MainFrame.Size = UDim2.new(0, XSize, 0, YSize)
		ScrollingFrame.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameR15.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameSpecific.Size = UDim2.new(1, 0, 1, -69)
	end)

	X1YSize.MouseButton1Click:Connect(function()
		YSize = 285
		MainFrame.Size = UDim2.new(0, XSize, 0, YSize)
		ScrollingFrame.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameR15.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameSpecific.Size = UDim2.new(1, 0, 1, -69)
	end)

	X15YSize.MouseButton1Click:Connect(function()
		YSize = 450
		MainFrame.Size = UDim2.new(0, XSize, 0, YSize)
		ScrollingFrame.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameR15.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameSpecific.Size = UDim2.new(1, 0, 1, -69)
	end)

	X2YSize.MouseButton1Click:Connect(function()
		YSize = 660
		MainFrame.Size = UDim2.new(0, XSize, 0, YSize)
		ScrollingFrame.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameR15.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameSpecific.Size = UDim2.new(1, 0, 1, -69)
	end)

	X2Size.MouseButton1Click:Connect(function()
		XSize = 240
		MainFrame.Size = UDim2.new(0, XSize, 0, YSize)
		ScrollingFrame.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameR15.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameSpecific.Size = UDim2.new(1, 0, 1, -69)

		ValueText.Visible = false
		if RigType == "R15" then
			Title.Text = "Emoter R15"
		else
			Title.Text = "Emoter R6"
		end
	end)

	X3Size.MouseButton1Click:Connect(function()
		XSize = 350
		MainFrame.Size = UDim2.new(0, XSize, 0, YSize)
		ScrollingFrame.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameR15.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameSpecific.Size = UDim2.new(1, 0, 1, -69)

		ValueText.Visible = false
		if RigType == "R15" then
			Title.Text = "Emoter GUI (R15)"
		else
			Title.Text = "Emoter GUI (R6)"
		end
	end)

	X4Size.MouseButton1Click:Connect(function()
		XSize = 460
		MainFrame.Size = UDim2.new(0, XSize, 0, YSize)
		ScrollingFrame.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameR15.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameSpecific.Size = UDim2.new(1, 0, 1, -69)

		ValueText.Visible = true
		if RigType == "R15" then
			Title.Text = "Emoter GUI (R15)"
		else
			Title.Text = "Emoter GUI (R6)"
		end
	end)

	X5Size.MouseButton1Click:Connect(function()
		XSize = 571
		MainFrame.Size = UDim2.new(0, XSize, 0, YSize)
		ScrollingFrame.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameR15.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameSpecific.Size = UDim2.new(1, 0, 1, -69)

		ValueText.Visible = true
		if RigType == "R15" then
			Title.Text = "Emoter GUI (R15)"
		else
			Title.Text = "Emoter GUI (R6)"
		end
	end)

	local LoadGithubSGAOptionButton = SettingsStuff.LoadGithubSGAOption
	AddHoverText(LoadGithubSGAOptionButton, "Enables loading SGA (SpecificGameAnims) from Github")
	LoadGithubSGAOptionButton.MouseButton1Click:Connect(function()
		LoadGithubSGAEnabled = not LoadGithubSGAEnabled
		if LoadGithubSGAEnabled == true then
			LoadGithubSGAOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			LoadGithubSGAOptionButton.CheckImage.Image = ""
		end
	end)

	local LoadGithubCustomAnimOptionButton = SettingsStuff.LoadGithubCustomAnimOption
	AddHoverText(LoadGithubCustomAnimOptionButton, "Enables loading additional animations from Github")
	LoadGithubCustomAnimOptionButton.MouseButton1Click:Connect(function()
		LoadGithubCustomAnimsEnabled = not LoadGithubCustomAnimsEnabled
		if LoadGithubCustomAnimsEnabled == true then
			LoadGithubCustomAnimOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			LoadGithubCustomAnimOptionButton.CheckImage.Image = ""
		end
	end)

	local LoadLocalSGAOptionButton = SettingsStuff.LoadLocalSGAOption
	AddHoverText(LoadLocalSGAOptionButton, "Enables loading SGA (SpecificGameAnims) from your local files. More information in my <b>Github</b>")
	LoadLocalSGAOptionButton.MouseButton1Click:Connect(function()
		LoadLocalSGAEnabled = not LoadLocalSGAEnabled
		if LoadLocalSGAEnabled == true then
			LoadLocalSGAOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			LoadLocalSGAOptionButton.CheckImage.Image = ""
		end
	end)

	local LoadLocalCustomAnimOptionButton = SettingsStuff.LoadLocalCustomAnimOption
	AddHoverText(LoadLocalCustomAnimOptionButton, "Enables loading additional animations from your local files. More information in my <b>Github</b>")
	LoadLocalCustomAnimOptionButton.MouseButton1Click:Connect(function()
		LoadLocalCustomAnimsEnabled = not LoadLocalCustomAnimsEnabled
		if LoadLocalCustomAnimsEnabled == true then
			LoadLocalCustomAnimOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			LoadLocalCustomAnimOptionButton.CheckImage.Image = ""
		end
	end)

	SaveSettingsButton.MouseButton1Click:Connect(function()
		local SettingsToSave = {
			ConfAnimPreviewEnabled = AnimPreviewEnabled,
			ConfDebugInfoEnabled = DebugInfoEnabled,
			ConfAnalyticsEnabled = AnalyticsEnabled,
			ConfLoadAnimationsOnRestart = LoadAnimationsOnRestart,

			ConfToolIdleAnimHighPriorEnabled = ToolIdleAnimHighPriorEnabled,
			ConfToolActionAnimHighPriorEnabled = ToolActionAnimHighPriorEnabled,
			ConfAnimSwitchModeEnabled = AnimSwitchModeEnabled,
			ConfAnimSwitchModeRunIdleExceptionEnabled = AnimSwitchModeRunIdleExceptionEnabled,
			ConfAnimSmoothFadeEnabled = AnimSmoothFadeEnabled,
			ConfHigherPriorityEnabled = HigherPriorityEnabled,

			ConfIdleTypeEnabled = IdleTypeEnabled,
			ConfRunningTypeEnabled = RunningTypeEnabled,
			ConfRunningTypeStopStandingEnabled = RunningTypeStopStandingEnabled,
			ConfRunningTypeCharSpeedEnabled = RunningTypeCharSpeedEnabled,
			ConfRunningTypeMinSpeedEnabled = RunningTypeMinSpeedEnabled,
			ConfRunningTypeStopJumpingEnabled = RunningTypeStopJumpingEnabled,
			ConfRunningTypeStopClimbingEnabled = RunningTypeStopClimbingEnabled,

			ConfTheme = theme,
			ConfUIGradientEnabled = UIGradientEnabled,
			ConfUICornerEnabled = UICornerEnabled,
			ConfXSize = XSize,
			ConfYSize = YSize,

			ConfLoadGithubSGAEnabled = LoadGithubSGAEnabled,
			ConfLoadGithubCustomAnimsEnabled = LoadGithubCustomAnimsEnabled,
			ConfLoadLocalSGAEnabled = LoadLocalSGAEnabled,
			ConfLoadLocalCustomAnimsEnabled = LoadLocalCustomAnimsEnabled,

			ConfHotkeysEnabled = HotkeysEnabled,
			ConfDoubleHotkeyEnabled = DoubleHotkeyEnabled,
			ConfSearchHotkey = SearchHotkey.Value,
			ConfCloseHotkey = CloseHotkey.Value,
			ConfSitHotkey = SitHotkey.Value,
			ConfSwitchAnimHotkey = SwitchAnimHotkey.Value,
			ConfAnimFadeHotkey = AnimFadeHotkey.Value,
			ConfSettingsHotkey = SettingsHotkey.Value,
			StopAnimsHotkey = StopAnimsHotkey.Value,
			ConfEmoteWheelHotkey = EmoteWheelHotkey.Value
		}
		local encodedData = HttpService:JSONEncode(SettingsToSave)
		writefile("EmoterData/"..ConfigFileName, encodedData)
		game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Saved", Text = "Succesfully saved settings!", Duration = 3})
	end)

	LaunchIdDetectorButton.MouseButton1Click:Connect(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Fixel656/Roblox-Emotes-GUI-Script-R6-R15/refs/heads/main/AnimationIdDetector.lua",true))()
	end)

	ResetButton.MouseButton1Click:Connect(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Restarting", Text = "Restarting Gui...", Duration = 3})
		table.clear(RestartAnimations)
		StopAnimsEvent:Fire("Reset/Destroy")
		SettingsFrame.Visible = false
		GuiRestarted = true
		OnRestart()
	end)

	GithubLinkButton.MouseButton1Click:Connect(function()
		setclipboard("https://github.com/Fixel656/Roblox-Emotes-GUI-Script-R6-R15/tree/main")
		game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Copied", Text = "Copied link to your clipboard!", Duration = 3})
	end)

	--Hotkey Functions
	UserInputService.InputBegan:Connect(function(input, processed)

		if processed then return end
		if GuiActive == false then return end

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

		if tostring(input.KeyCode.Name) == CloseHotkey.Value and HotkeysEnabled then
			if MainFrame.Visible == true then
				SideFrame.Position = MainFrame.Position
			else
				MainFrame.Position = SideFrame.Position
			end
			MainFrame.Visible = not MainFrame.Visible
			SideFrame.Visible = not SideFrame.Visible
		end

		if tostring(input.KeyCode.Name) == SettingsHotkey.Value and HotkeysEnabled then
			SettingsFrame.Visible = not SettingsFrame.Visible
		end

		if tostring(input.KeyCode.Name) == SwitchAnimHotkey.Value and HotkeysEnabled then
			AnimSwitchModeEnabled = not AnimSwitchModeEnabled
			if AnimSwitchModeEnabled == true then
				SwitchOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
			else
				SwitchOptionButton.CheckImage.Image = ""
			end
		end

		if tostring(input.KeyCode.Name) == AnimFadeHotkey.Value and HotkeysEnabled then
			AnimSmoothFadeEnabled = not AnimSmoothFadeEnabled
			if AnimSmoothFadeEnabled == true then
				AnimFadeOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
			else
				AnimFadeOptionButton.CheckImage.Image = ""
			end
		end
		
		if tostring(input.KeyCode.Name) == StopAnimsHotkey.Value and HotkeysEnabled then
			StopAnimsEvent:Fire("Forced")
		end
		
		if tostring(input.KeyCode.Name) == EmoteWheelHotkey.Value then
			EmoteWheel.Visible = not EmoteWheel.Visible
		end

		if tostring(input.KeyCode.Name) == SitHotkey.Value and HotkeysEnabled then
			if Humanoid.Sit == false then
				Humanoid.Sit = true
			else
				Humanoid.Sit = false
			end
		end

		--EmoteWheelClosing
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if EmoteWheel.Visible then
				local mousePos = UserInputService:GetMouseLocation()
				local guiObjects = Player.PlayerGui:GetGuiObjectsAtPosition(mousePos.X, mousePos.Y - 60)
				if not IsInStudio then
					guiObjects = game.CoreGui:GetGuiObjectsAtPosition(mousePos.X, mousePos.Y - 60)
				end

				local clickedInside = false
				for _, obj in ipairs(guiObjects) do
					if obj:IsDescendantOf(EmoteWheel) or obj == EmoteWheel then
						clickedInside = true
						break
					end
				end

				if not clickedInside then
					wait()
					EmoteWheel.Visible = false
				end
			end
		end

		if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
			AltPressed = true
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
			AltPressed = false
		end
	end)

	-- EMOTES

	--[[Functions Template
	local InstanceName = Instance.new("TextButton")
	CreateAnimButton(InstanceName, "ButtonName", "ButtonText", "SFrameType (R6, R15 or Spec)", LayoutOrder)
	PlayAnim(InstanceName, "AnimId", FadeTime, AnimSpeed, "PriorityPauseRunningIdle", Looped(true/false))
	]]
	print("Adding Emotes from script...")
	--DivideFrames
	CreateDivideFrame("Dances", 1, "R6")
	CreateDivideFrame("Actions", 2, "R6")
	CreateDivideFrame("Idles & Walks", 3, "R6")
	CreateDivideFrame("Weird", 4, "R6")
	CreateDivideFrame("Attack", 5, "R6")

	CreateDivideFrame("Dances", 1, "R15")
	CreateDivideFrame("Actions", 2, "R15")
	CreateDivideFrame("Walk & Run", 3, "R15")
	CreateDivideFrame("Poses & Idles", 4, "R15")
	CreateDivideFrame("Weird", 5, "R15")
	CreateDivideFrame("Attack", 6, "R15")


	-- R6 Emotes
	local function R6Anims()
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
		PlayAnim(DinoWalk, "204328711", .1, 1.5, "PriorLowRunning", true)
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
	local function R15Anims()
		local Dance1 = Instance.new("TextButton")
		CreateAnimButton(Dance1, "Dance1", "Dance 1", "R15", 1)
		PlayAnim(Dance1, "507771955", .1, 1, "PriorLow", true)
		local Dance2 = Instance.new("TextButton")
		CreateAnimButton(Dance2, "Dance2", "Dance 2", "R15", 1)
		PlayAnim(Dance2, "507776720", .1, 1, "PriorLow", true)
		local Dance3 = Instance.new("TextButton")
		CreateAnimButton(Dance3, "Dance3", "Dance 3", "R15", 1)
		PlayAnim(Dance3, "507777451", .1, 1, "PriorLow", true)
		local FlossDance = Instance.new("TextButton")
		CreateAnimButton(FlossDance, "FlossDance", "Floss Dance", "R15", 1)
		PlayAnim(FlossDance, "10714340543", .1, 1, "PriorLow", true)
		local Monkey = Instance.new("TextButton")
		CreateAnimButton(Monkey, "Monkey", "Monkey", "R15", 1)
		PlayAnim(Monkey, "10714388352", .1, 1, "PriorLow", true)
		local IWantMoneyDance = Instance.new("TextButton")
		CreateAnimButton(IWantMoneyDance, "IWantMoneyDance", "IWantMoney Dance", "R15", 1)
		PlayAnim(IWantMoneyDance, "115781688996859", .1, 1, "PriorLow", true)
		local FortniteDance = Instance.new("TextButton")
		CreateAnimButton(FortniteDance, "FortniteDance", "Fortnite Dance", "R15", 1)
		PlayAnim(FortniteDance, "126199405283943", .1, 1, "PriorLow", true)
		local GangnamStyle = Instance.new("TextButton")
		CreateAnimButton(GangnamStyle, "GangnamStyle", "Gangnam Style", "R15", 1)
		PlayAnim(GangnamStyle, "129764254213842", .1, 0.9, "PriorLow", true)
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
		PlayAnim(TakeTheL, "117865821073911", .1, 1, "PriorLow", true)
		local JumpJacks = Instance.new("TextButton")
		CreateAnimButton(JumpJacks, "JumpJacks", "Jump Jacks", "R15", 1)
		PlayAnim(JumpJacks, "10714375667", .1, 1, "PriorLow", true)

		local Wave = Instance.new("TextButton")
		CreateAnimButton(Wave, "Wave", "Wave", "R15", 2)
		PlayAnim(Wave, "10714359093", .1, 1, "PriorLow", false)
		local HighWave = Instance.new("TextButton")
		CreateAnimButton(HighWave, "HighWave", "HighWave", "R15", 2)
		PlayAnim(HighWave, "10714362852", .1, 1, "PriorLow", false)
		local AwkwardWave = Instance.new("TextButton")
		CreateAnimButton(AwkwardWave, "AwkwardWave", "Awkward Wave", "R15", 2)
		PlayAnim(AwkwardWave, "86074172929360", .1, 1, "PriorLow", true)
		local Point = Instance.new("TextButton")
		CreateAnimButton(Point, "Point", "Point", "R15", 2)
		PlayAnim(Point, "10714395441", .1, 1, "PriorLow", false)
		local Beckon = Instance.new("TextButton")
		CreateAnimButton(Beckon, "Beckon", "Beckon", "R15", 2)
		PlayAnim(Beckon, "10713984554", .1, 1, "PriorLow", false)
		local Happy = Instance.new("TextButton")
		CreateAnimButton(Happy, "Happy", "Happy", "R15", 2)
		PlayAnim(Happy, "10714352626", .1, 1, "PriorLow", false)
		local Cheer = Instance.new("TextButton")
		CreateAnimButton(Cheer, "Cheer", "Cheer", "R15", 2)
		PlayAnim(Cheer, "507770677", .1, 1, "PriorLow", false)
		local Celebrate = Instance.new("TextButton")
		CreateAnimButton(Celebrate, "Celebrate", "Celebrate", "R15", 2)
		PlayAnim(Celebrate, "10714016223", .1, 1, "PriorLow", false)
		local Salute = Instance.new("TextButton")
		CreateAnimButton(Salute, "Salute", "Salute", "R15", 2)
		PlayAnim(Salute, "10714389988", .1, 1, "PriorLow", false)
		local Shrug = Instance.new("TextButton")
		CreateAnimButton(Shrug, "Shrug", "Shrug", "R15", 2)
		PlayAnim(Shrug, "10714374484", .1, 1, "PriorLow", false)
		local Thinking = Instance.new("TextButton")
		CreateAnimButton(Thinking, "Thinking", "Thinking", "R15", 2)
		PlayAnim(Thinking, "123167401858016", .1, 1, "PriorLow", false)
		local Confused = Instance.new("TextButton")
		CreateAnimButton(Confused, "Confused", "Confused", "R15", 2)
		PlayAnim(Confused, "4940561610", .1, 1, "PriorLow", false)
		local Agree = Instance.new("TextButton")
		CreateAnimButton(Agree, "Agree", "Agree", "R15", 2)
		PlayAnim(Agree, "10713954623", .1, 1, "PriorLow", false)
		local Disagree = Instance.new("TextButton")
		CreateAnimButton(Disagree, "Disagree", "Disagree", "R15", 2)
		PlayAnim(Disagree, "10714065135", .1, 1, "PriorLow", false)
		local DolphinBang = Instance.new("TextButton")
		CreateAnimButton(DolphinBang, "DolphinBang", "Dolphin Bang", "R15", 2)
		PlayAnim(DolphinBang, "10714068222", .1, 1, "PriorLow", false)
		local Twirl = Instance.new("TextButton")
		CreateAnimButton(Twirl, "Twirl", "Twirl", "R15", 2)
		PlayAnim(Twirl, "10714293450", .1, 1, "PriorLow", false)
		local HeroLanding = Instance.new("TextButton")
		CreateAnimButton(HeroLanding, "HeroLanding", "Hero Landing", "R15", 2)
		PlayAnim(HeroLanding, "10714360164", .1, 1, "PriorLow", false)
		local Shy = Instance.new("TextButton")
		CreateAnimButton(Shy, "Shy", "Shy", "R15", 2)
		PlayAnim(Shy, "10714369325", .1, 1, "PriorLow", false)
		local Coward = Instance.new("TextButton")
		CreateAnimButton(Coward, "Coward", "Coward", "R15", 2)
		PlayAnim(Coward, "4940563117", .1, 1, "PriorLow", false)
		local Dizzy = Instance.new("TextButton")
		CreateAnimButton(Dizzy, "Dizzy", "Dizzy", "R15", 2)
		PlayAnim(Dizzy, "10714066964", .1, 1, "PriorLow", false)
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
		local FakeDeath = Instance.new("TextButton")
		CreateAnimButton(FakeDeath, "FakeDeath", "FakeDeath", "R15", 2)
		PlayAnim(FakeDeath, "88130117312312", .1, 1, "PriorLowPause", true)

		local Tank = Instance.new("TextButton")
		CreateAnimButton(Tank, "Tank", "Tank", "R15", 3)
		PlayAnim(Tank, "115951523870527", .5, 1, "PriorLow", true)
		local RaceCar = Instance.new("TextButton")
		CreateAnimButton(RaceCar, "RaceCar", "Race Car", "R15", 3)
		PlayAnim(RaceCar, "72382226286301", .5, 1, "PriorLow", true)
		local Helicopter = Instance.new("TextButton")
		CreateAnimButton(Helicopter, "Helicopter", "Helicopter", "R15", 3)
		PlayAnim(Helicopter, "76510079095692", .5, 1, "PriorLow", true)
		local CarDriving = Instance.new("TextButton")
		CreateAnimButton(CarDriving, "CarDriving", "Car Driving", "R15", 3)
		PlayAnim(CarDriving, "132471972345518", .5, 0.5, "PriorLow", true)
		local Crawl = Instance.new("TextButton")
		CreateAnimButton(Crawl, "Crawl", "Crawl", "R15", 3)
		PlayAnim(Crawl, "106501741606953", .1, 1, "PriorLow", true)
		local BigBadWolf = Instance.new("TextButton")
		CreateAnimButton(BigBadWolf, "BigBadWolf", "Big Bad Wolf", "R15", 3)
		PlayAnim(BigBadWolf, "84490859002106", .1, 1, "PriorLow", true)
		local Wheel = Instance.new("TextButton")
		CreateAnimButton(Wheel, "Wheel", "Wheel", "R15", 3)
		PlayAnim(Wheel, "116700088132671", .1, 0.65, "PriorLowRunning", true)
		local DefaultR6Run = Instance.new("TextButton")
		CreateAnimButton(DefaultR6Run, "DefaultR6Run", "R6 Run", "R15", 3)
		PlayAnim(DefaultR6Run, "88923549940250", .1, 1, "PriorLowRunning", true)
		local MiniWalk = Instance.new("TextButton")
		CreateAnimButton(MiniWalk, "MiniWalk", "Mini Walk", "R15", 3)
		PlayAnim(MiniWalk, "85887415033585", .1, 1.3, "PriorLowRunning", true)
		local MedusaWalk = Instance.new("TextButton")
		CreateAnimButton(MedusaWalk, "MedusaWalk", "Medusa Walk", "R15", 3)
		PlayAnim(MedusaWalk, "131663132818596", .1, 1.5, "PriorLowRunning", true)
		local TallCreatureWalk = Instance.new("TextButton")
		CreateAnimButton(TallCreatureWalk, "TallCreatureWalk", "Tall Creature Walk", "R15", 3)
		PlayAnim(TallCreatureWalk, "134010853417610", .1, 1.5, "PriorLowRunning", true)
		local ShadowRun = Instance.new("TextButton")
		CreateAnimButton(ShadowRun, "ShadowRun", "Shadow Running", "R15", 3)
		PlayAnim(ShadowRun, "82598234841035", .1, 0.8, "PriorLowRunning", true)
		local AdidasRun = Instance.new("TextButton")
		CreateAnimButton(AdidasRun, "AdidasRun", "Adidas Running", "R15", 3)
		PlayAnim(AdidasRun, "18537384940", .1, 1, "PriorLowRunning", true)
		local HappyRun = Instance.new("TextButton")
		CreateAnimButton(HappyRun, "HappyRun", "Happy Run", "R15", 3)
		PlayAnim(HappyRun, "136336776520965", .1, 1, "PriorLowRunning", true)
		local FloatingRun = Instance.new("TextButton")
		CreateAnimButton(FloatingRun, "FloatingRun", "Floating Run", "R15", 3)
		PlayAnim(FloatingRun, "98995968630900", .1, 1, "PriorLowRunning", true)
		local MotionRun = Instance.new("TextButton")
		CreateAnimButton(MotionRun, "MotionRun", "Motion Run", "R15", 3)
		PlayAnim(MotionRun, "101925097435036", .1, 1, "PriorLowRunning", true)
		
		local HappyIdle = Instance.new("TextButton")
		CreateAnimButton(HappyIdle, "HappyIdle", "Happy Idle", "R15", 4)
		PlayAnim(HappyIdle, "88212525150688", .1, 1, "PriorLowIdle", true)
		local MiniIdle = Instance.new("TextButton")
		CreateAnimButton(MiniIdle, "MiniIdle", "Mini Idle", "R15", 4)
		PlayAnim(MiniIdle, "82127055873357", .1, 1, "PriorLowIdle", true)
		local VibeIdle = Instance.new("TextButton")
		CreateAnimButton(VibeIdle, "VibeIdle", "Vibe Idle", "R15", 4)
		PlayAnim(VibeIdle, "99638411514722", .1, 1, "PriorLowIdle", true)
		local TallIdle = Instance.new("TextButton")
		CreateAnimButton(TallIdle, "TallIdle", "Tall Idle", "R15", 4)
		PlayAnim(TallIdle, "73645108622491", .1, 1, "PriorLowIdle", true)
		local FloatingHeadSitting = Instance.new("TextButton")
		CreateAnimButton(FloatingHeadSitting, "FloatingHeadSitting", "Floating Head Sit", "R15", 4)
		PlayAnim(FloatingHeadSitting, "111681053387222", .1, 1, "PriorLow", true)
		local FloatChillSit = Instance.new("TextButton")
		CreateAnimButton(FloatChillSit, "FloatChillSit", "Float Chill Sit", "R15", 4)
		PlayAnim(FloatChillSit, "97361223864206", .1, 0.5, "PriorLow", true)
		local FloatIdle = Instance.new("TextButton")
		CreateAnimButton(FloatIdle, "FloatIdle", "Float Idle", "R15", 4)
		PlayAnim(FloatIdle, "90055248227279", .1, 1, "PriorLowIdle", true)
		local DefaultR6Idle = Instance.new("TextButton")
		CreateAnimButton(DefaultR6Idle, "DefaultR6Idle", "R6 Idle", "R15", 4)
		PlayAnim(DefaultR6Idle, "130392105157572", .1, 1, "PriorLowIdle", true)
		local TPose = Instance.new("TextButton")
		CreateAnimButton(TPose, "TPose", "T Pose", "R15", 4)
		PlayAnim(TPose, "121655148084031", .1, 1, "PriorLow", true)
		local CrouchR15 = Instance.new("TextButton")
		CreateAnimButton(CrouchR15, "CrouchR15", "Crouch", "R15", 4)
		PlayAnim(CrouchR15, "97517127273301", .3, 1, "PriorLow", true)
		local Sitting = Instance.new("TextButton")
		CreateAnimButton(Sitting, "Sitting", "Sitting", "R15", 4)
		PlayAnim(Sitting, "94763556845023", .1, 1, "PriorLow", true)
		local MM2Sit = Instance.new("TextButton")
		CreateAnimButton(MM2Sit, "MM2Sit", "MM2 Sit", "R15", 4)
		PlayAnim(MM2Sit, "130577643309726", .1, 1, "PriorLow", true)
		local Box = Instance.new("TextButton")
		CreateAnimButton(Box, "Box", "Box", "R15", 4)
		PlayAnim(Box, "73753845465382", .1, 1, "PriorLow", true)
		local Sleeping = Instance.new("TextButton")
		CreateAnimButton(Sleeping, "Sleeping", "Sleeping", "R15", 4)
		PlayAnim(Sleeping, "121641415206650", .5, 1, "PriorLow", true)
		local HeadJuggle = Instance.new("TextButton")
		CreateAnimButton(HeadJuggle, "HeadJuggle", "Head Juggle", "R15", 4)
		PlayAnim(HeadJuggle, "136767849845319", .1, 1, "PriorLow", true)
		local FloatingOnClouds = Instance.new("TextButton")
		CreateAnimButton(FloatingOnClouds, "FloatingOnClouds", "Floating On Clouds", "R15", 4)
		PlayAnim(FloatingOnClouds, "77840765435893", .1, 1, "PriorLow", true)
		local SitAnim = Instance.new("TextButton")
		CreateAnimButton(SitAnim, "SitAnim", "Sit Anim", "R15", 4)
		PlayAnim(SitAnim, "507768133", .1, 1, "PriorLow", true)
		local ToolHandle = Instance.new("TextButton")
		CreateAnimButton(ToolHandle, "ToolHandle", "Tool Handle", "R15", 4)
		PlayAnim(ToolHandle, "507768375", .1, 1, "PriorHigh", true)
		local FightingIdle = Instance.new("TextButton")
		CreateAnimButton(FightingIdle, "FightingIdle", "Fighting Idle", "R15", 4)
		PlayAnim(FightingIdle, "105947156749343", .1, 1, "PriorLowIdle", true)

		local JumpingSpider = Instance.new("TextButton")
		CreateAnimButton(JumpingSpider, "JumpingSpider", "Jumping Spider", "R15", 5)
		PlayAnim(JumpingSpider, "139310328821985", .1, 1, "PriorLow", true)
		local InsaneDog = Instance.new("TextButton")
		CreateAnimButton(InsaneDog, "InsaneDog", "Insane Dog", "R15", 5)
		PlayAnim(InsaneDog, "96435804447949", .1, 1, "PriorLow", true)
		local WormAnim = Instance.new("TextButton")
		CreateAnimButton(WormAnim, "WormAnim", "Worm Fly", "R15", 5)
		PlayAnim(WormAnim, "135990691658209", .3, 1, "PriorLow", true)
		local Orbit = Instance.new("TextButton")
		CreateAnimButton(Orbit, "Orbit", "Orbit", "R15", 5)
		PlayAnim(Orbit, "108359356964182", .5, 1, "PriorLow", true)
		local Hanging = Instance.new("TextButton")
		CreateAnimButton(Hanging, "Hanging", "Hanging", "R15", 5)
		PlayAnim(Hanging, "125662782523118", .1, 1, "PriorLow", true)
		local LaggyWalkTroll = Instance.new("TextButton")
		CreateAnimButton(LaggyWalkTroll, "LaggyWalkTroll", "Laggy Walk Troll", "R15", 5)
		PlayAnim(LaggyWalkTroll, "119199812452698", .1, 1, "PriorLow", true)
		local InchWorm = Instance.new("TextButton")
		CreateAnimButton(InchWorm, "InchWorm", "Inch Worm", "R15", 5)
		PlayAnim(InchWorm, "119096405600200", .1, 1, "PriorLow", true)
		local GoofyWiggle = Instance.new("TextButton")
		CreateAnimButton(GoofyWiggle, "GoofyWiggle", "Goofy Wiggle", "R15", 5)
		PlayAnim(GoofyWiggle, "74917195706355", .1, 1, "PriorLow", true)
		local Tornado = Instance.new("TextButton")
		CreateAnimButton(Tornado, "Tornado", "Tornado", "R15", 5)
		PlayAnim(Tornado, "135373056067761", .1, 1, "PriorLow", true)
		local AdminFly = Instance.new("TextButton")
		CreateAnimButton(AdminFly, "AdminFly", "Admin Fly", "R15", 5)
		PlayAnim(AdminFly, "85063861261432", .1, 1, "PriorLow", true)
		local ObbyHead = Instance.new("TextButton")
		CreateAnimButton(ObbyHead, "ObbyHead", "Little Obbyist", "R15", 5)
		PlayAnim(ObbyHead, "115569573258316", .1, 1, "PriorLow", true)
		local Insane = Instance.new("TextButton")
		CreateAnimButton(Insane, "Insane", "Insane", "R15", 5)
		PlayAnim(Insane, "93087898023268", .1, 1, "PriorLow", true)
		local GoofyFLY = Instance.new("TextButton")
		CreateAnimButton(GoofyFLY, "GoofyFLY", "Goofy FLY", "R15", 5)
		PlayAnim(GoofyFLY, "118417760427139", .1, 1, "PriorLow", true)
		local BodyPhone = Instance.new("TextButton")
		CreateAnimButton(BodyPhone, "BodyPhone", "Body Phone", "R15", 5)
		PlayAnim(BodyPhone, "73390669780316", .1, 0.8, "PriorLow", false)
		local Spin = Instance.new("TextButton")
		CreateAnimButton(Spin, "Spin", "Spin", "R15", 5)
		PlayAnim(Spin, "110792133024438", .1, 1, "PriorHigh", true)
		local HyperSpin = Instance.new("TextButton")
		CreateAnimButton(HyperSpin, "HyperSpin", "Hyper Spin", "R15", 5)
		PlayAnim(HyperSpin, "125165371323590", .1, 1, "PriorLow", true)
		local SpinAround = Instance.new("TextButton")
		CreateAnimButton(SpinAround, "SpinAround", "SpinAround", "R15", 5)
		PlayAnim(SpinAround, "91004858616595", .1, 1, "PriorLow", true)
		local FloatingSpace = Instance.new("TextButton")
		CreateAnimButton(FloatingSpace, "FloatingSpace", "Floating Space", "R15", 5)
		PlayAnim(FloatingSpace, "71209604118044", .1, 1, "PriorLow", true)
		local FloatingSpace2 = Instance.new("TextButton")
		CreateAnimButton(FloatingSpace2, "FloatingSpace2", "Floating Space 2", "R15", 5)
		PlayAnim(FloatingSpace2, "70394064781064", .1, 0.5, "PriorLow", true)

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

	if RigType == "R6" then
		R6Anims()
	else
		R15Anims()
	end
	
	local function AdditionalAnimsOperation()
		print("[AdditionalAnims File]: Adding animations from AdditionalAnims file in Github")
		
		local finalUrl = "https://raw.githubusercontent.com/Fixel656/Roblox-Emotes-GUI-Script-R6-R15/refs/heads/main/SpecificGameAnimations/AdditionalAnimations"

		local success, fileContent = pcall(function()
			return game:HttpGet(finalUrl)
		end)
		if not success or not fileContent or fileContent == "404: Not Found" then
			warn("[AdditionalAnims File]: AdditionalAnims file wasn't found")
			return 
		end
		local success2, data = pcall(function()
			return HttpService:JSONDecode(fileContent)
		end)
		if not success2 or not data then
			warn("[AdditionalAnims File]: Error in JSON structure in AdditionalAnims file")
			return
		end
		for categoryName, animationsList in pairs(data) do
			if categoryName == "CustomEmotes" and #data["CustomEmotes"] ~= 0 then
				print("[AdditionalAnims File]: Extracting Animations")
				for _, info in ipairs(animationsList) do
					local danceButton = Instance.new("TextButton")
					CreateAnimButton(danceButton, info[1], info[2], info[3], info[4])
					PlayAnim(danceButton, info[5], info[6], info[7], info[8], info[9])
				end
			elseif categoryName == "DefaultAnims" and #data["DefaultAnims"] ~= 0 then
				print("[AdditionalAnims File]: Adding Default animations")
				for _, id in ipairs(data["DefaultAnims"]) do
					if not table.find(DefaultAnimsNameList, id) then
						table.insert(DefaultAnimsNameList, tostring(id))
					end
				end
			end
		end
		print("[AdditionalAnims File]: Loaded Data!")
	end

	local function CustomAnimsOperation()
		print("[CustomAnims File]: Searching CustomAnims file")
		local success, fileContent = pcall(function()
			return readfile("EmoterData/CustomAnims.lua")
		end)
		if not success or not fileContent then 
			warn("[CustomAnims File]: CustomAnims file wasn't found")
			return 
		end
		local success2, data = pcall(function()
			return HttpService:JSONDecode(fileContent)
		end)
		if not success2 or not data then
			warn("[CustomAnims File]: Error in JSON structure in CustomAnims file")
			return
		end
		for categoryName, animationsList in pairs(data) do
			if categoryName == "CustomEmotes" and #data["CustomEmotes"] ~= 0 then
				print("[CustomAnims File]: Extracting Animations")
				for _, info in ipairs(animationsList) do
					local danceButton = Instance.new("TextButton")
					CreateAnimButton(danceButton, info[1], info[2], info[3], info[4])
					PlayAnim(danceButton, info[5], info[6], info[7], info[8], info[9])
				end
			elseif categoryName == "DefaultAnims" and #data["DefaultAnims"] ~= 0 then
				print("[CustomAnims File]: Adding Default animations")
				for _, id in ipairs(data["DefaultAnims"]) do
					if not table.find(DefaultAnimsNameList, id) then
						table.insert(DefaultAnimsNameList, tostring(id))
					end
				end
			elseif categoryName == "ToolActionAnims" and #data["ToolActionAnims"] ~= 0 then
				print("[CustomAnims File]: Adding ToolAction Animations")
				for _, id in ipairs(data["ToolActionAnims"]) do
					if not table.find(ToolActionAnimsList, id) then
						table.insert(ToolActionAnimsList, tostring(id))
					end
				end
			elseif categoryName == "ToolIdleAnims" and #data["ToolIdleAnims"] ~= 0 then
				print("[CustomAnims File]: Adding ToolIdle Animations")
				for _, id in ipairs(data["ToolIdleAnims"]) do
					if not table.find(ToolIdleAnimsList, id) then
						table.insert(ToolIdleAnimsList, tostring(id))
					end
				end
			elseif categoryName == "R6EmoteWheelEmotes" and #data["EmoteWheelEmotes"] ~= 0 and RigType == "R6" then
				print("[SpecGameAnims File]: Adding EmoteWhell Data")
				local info = data["EmoteWheelEmotes"]
				EmoteWheelEmotes.Emote1 = info[1]
				EmoteWheelEmotes.Emote2 = info[2]
				EmoteWheelEmotes.Emote3 = info[3]
				EmoteWheelEmotes.Emote4 = info[4]
				EmoteWheelEmotes.Emote5 = info[5]
				EmoteWheelEmotes.Emote6 = info[6]
				EmoteWheelEmotes.Emote7 = info[7]
				EmoteWheelEmotes.Emote8 = info[8]
			elseif categoryName == "R15EmoteWheelEmotes" and #data["EmoteWheelEmotes"] ~= 0 and RigType == "R15" then
				print("[SpecGameAnims File]: Adding EmoteWhell Data")
				local info = data["EmoteWheelEmotes"]
				EmoteWheelEmotes.Emote1 = info[1]
				EmoteWheelEmotes.Emote2 = info[2]
				EmoteWheelEmotes.Emote3 = info[3]
				EmoteWheelEmotes.Emote4 = info[4]
				EmoteWheelEmotes.Emote5 = info[5]
				EmoteWheelEmotes.Emote6 = info[6]
				EmoteWheelEmotes.Emote7 = info[7]
				EmoteWheelEmotes.Emote8 = info[8]
			end
		end
		print("[CustomAnims File]: Loaded Data!")
	end

	local function GithubSpecGameAnimsOperation()
		local baseUrl = "https://raw.githubusercontent.com/Fixel656/Roblox-Emotes-GUI-Script-R6-R15/refs/heads/main/SpecificGameAnimations/"
		local finalUrl = baseUrl .. tostring(game.GameId)

		print("[SpecGameAnims Github]: Searching Anims file in Github for game ".. game.GameId)

		local success, fileContent = pcall(function()
			return game:HttpGet(finalUrl)
		end)
		if not success or not fileContent or fileContent == "404: Not Found" then
			warn("[SpecGameAnims Github]: No file in Github for this game")
			return
		end
		local success2, data = pcall(function()
			return HttpService:JSONDecode(fileContent)
		end)
		if not success2 or not data then
			warn("[SpecGameAnims Github]: Error in JSON structure in file")
			return
		end

		for categoryName, animationsList in pairs(data) do
			if categoryName == "CustomEmotes" and #data["CustomEmotes"] ~= 0 then
				print("[SpecGameAnims Github]: Extracting Animations")
				for _, info in ipairs(animationsList) do
					local danceButton = Instance.new("TextButton")
					CreateAnimButton(danceButton, info[1], info[2], info[3], info[4])
					PlayAnim(danceButton, info[5], info[6], info[7], info[8], info[9])
				end
			elseif categoryName == "DefaultAnims" and #data["DefaultAnims"] ~= 0 then
				print("[SpecGameAnims Github]: Adding Default animations")
				for _, id in ipairs(data["DefaultAnims"]) do
					if not table.find(DefaultAnimsNameList, id) then
						table.insert(DefaultAnimsNameList, tostring(id))
					end
				end
			elseif categoryName == "ToolActionAnims" and #data["ToolActionAnims"] ~= 0 then
				print("[SpecGameAnims Github]: Adding ToolAction Animations")
				for _, id in ipairs(data["ToolActionAnims"]) do
					if not table.find(ToolActionAnimsList, id) then
						table.insert(ToolActionAnimsList, tostring(id))
					end
				end
			elseif categoryName == "ToolIdleAnims" and #data["ToolIdleAnims"] ~= 0 then
				print("[SpecGameAnims Github]: Adding ToolIdle Animations")
				for _, id in ipairs(data["ToolIdleAnims"]) do
					if not table.find(ToolIdleAnimsList, id) then
						table.insert(ToolIdleAnimsList, tostring(id))
					end
				end
			elseif categoryName == "EmoteWheelEmotes" and #data["EmoteWheelEmotes"] ~= 0 then
				print("[SpecGameAnims File]: Adding EmoteWhell Data")
				local info = data["EmoteWheelEmotes"]
				EmoteWheelEmotes.Emote1 = info[1]
				EmoteWheelEmotes.Emote2 = info[2]
				EmoteWheelEmotes.Emote3 = info[3]
				EmoteWheelEmotes.Emote4 = info[4]
				EmoteWheelEmotes.Emote5 = info[5]
				EmoteWheelEmotes.Emote6 = info[6]
				EmoteWheelEmotes.Emote7 = info[7]
				EmoteWheelEmotes.Emote8 = info[8]
			end
		end
		print("[SpecGameAnims Github]: Loaded Data!")
	end

	local function FileSpecGameAnimsOperation()
		print("[SpecGameAnims File]: Searching Specific GameAnims file")
		local targetNumber = tostring(game.GameId)
		local folderPath = "EmoterData/SpecificAnims"
		local targetFilePath = nil
		local fileFound = false

		local success, files = pcall(listfiles, folderPath)
		if not success then
			warn("[SpecGameAnims File]: Your exploit doesn't support function listfiles() or folder id empty")
			return
		end
		for _, filePath in ipairs(files) do
			local fileName = filePath:match("[^/\\]+$") or filePath
			local extractedNumber = fileName:match("(%d+)")

			if extractedNumber then
				if DebugInfoEnabled then print("[SpecGameAnims File]: Found file: " .. fileName .. " | Extracted number: " .. extractedNumber) end
				if extractedNumber == targetNumber then
					print("[SpecGameAnims File]: Found file: " .. filePath)
					fileFound = true
					targetFilePath = filePath

					break
				end
			end
		end
		if not fileFound then
			warn("[SpecGameAnims File]: File with number " .. targetNumber .. "hasn't found in files")
			return
		end
		local success2, fileContent = pcall(function()
			return readfile(targetFilePath)
		end)
		if not success2 or not fileContent then
			warn("[SpecGameAnims File]: Didn't read file")
			return
		end
		local success3, data = pcall(function()
			return HttpService:JSONDecode(fileContent)
		end)
		if not success3 or not data then
			warn("[SpecGameAnims File]: Error in JSON structure in file")
			return
		end

		for categoryName, animationsList in pairs(data) do
			if categoryName == "CustomEmotes" and #data["CustomEmotes"] ~= 0 then
				print("[SpecGameAnims File]: Extracting Animations")
				for _, info in ipairs(animationsList) do
					local danceButton = Instance.new("TextButton")
					CreateAnimButton(danceButton, info[1], info[2], info[3], info[4])
					PlayAnim(danceButton, info[5], info[6], info[7], info[8], info[9])
				end
			elseif categoryName == "DefaultAnims" and #data["DefaultAnims"] ~= 0 then
				print("[SpecGameAnims File]: Adding Default animations")
				for _, id in ipairs(data["DefaultAnims"]) do
					if not table.find(DefaultAnimsNameList, id) then
						table.insert(DefaultAnimsNameList, tostring(id))
					end
				end
			elseif categoryName == "ToolActionAnims" and #data["ToolActionAnims"] ~= 0 then
				print("[SpecGameAnims File]: Adding ToolAction Animations")
				for _, id in ipairs(data["ToolActionAnims"]) do
					if not table.find(ToolActionAnimsList, id) then
						table.insert(ToolActionAnimsList, tostring(id))
					end
				end
			elseif categoryName == "ToolIdleAnims" and #data["ToolIdleAnims"] ~= 0 then
				print("[SpecGameAnims File]: Adding ToolIdle Animations")
				for _, id in ipairs(data["ToolIdleAnims"]) do
					if not table.find(ToolIdleAnimsList, id) then
						table.insert(ToolIdleAnimsList, tostring(id))
					end
				end
			elseif categoryName == "EmoteWheelEmotes" and #data["EmoteWheelEmotes"] ~= 0 then
				print("[SpecGameAnims File]: Adding EmoteWhell Data")
				local info = data["EmoteWheelEmotes"]
				EmoteWheelEmotes.Emote1 = info[1]
				EmoteWheelEmotes.Emote2 = info[2]
				EmoteWheelEmotes.Emote3 = info[3]
				EmoteWheelEmotes.Emote4 = info[4]
				EmoteWheelEmotes.Emote5 = info[5]
				EmoteWheelEmotes.Emote6 = info[6]
				EmoteWheelEmotes.Emote7 = info[7]
				EmoteWheelEmotes.Emote8 = info[8]
			elseif categoryName == "AdditionalData" then
				if data["AdditionalData"].DefaultWalkSpeed then
					DefaultWalkSpeed = data["AdditionalData"].DefaultWalkSpeed
					print("Chaged DefaultWalkSpeed to "..DefaultWalkSpeed)
				elseif data["AdditionalData"].AnimationHandlerName then
					AnimationHandler = data["AdditionalData"].AnimationHandlerName
				end
			end
		end
		print("[SpecGameAnims File]: Loaded data!")
	end

	if not IsInStudio then
		print("Adding Emotes from files...")
		if LoadGithubCustomAnimsEnabled then
			AdditionalAnimsOperation()
		end
		if LoadLocalCustomAnimsEnabled then
			CustomAnimsOperation()
		end
		if LoadGithubSGAEnabled then
			GithubSpecGameAnimsOperation()
		end
		if LoadLocalSGAEnabled then
			FileSpecGameAnimsOperation()
		end
	end
	if DebugInfoEnabled then
		for index, id in ipairs(ToolActionAnimsList) do
			print("Номер: " .. index .. " | ID анимации: " .. id)
		end
	end

	CreateDivideFrame("Dances", 0, "Spec")
	CreateDivideFrame("Actions", 1, "Spec")
	CreateDivideFrame("Walk & Run", 2, "Spec")
	CreateDivideFrame("Poses & Idles", 3, "Spec")
	CreateDivideFrame("Weird", 4, "Spec")
	CreateDivideFrame("Attack", 5, "Spec")

	print("Loading Emote wheel and other functions...")
	if not ScrollingFrameSpecific:FindFirstChildOfClass("TextButton") then
		SpecGameSection.Visible = false
		DefaultSection.Visible = false
		CurrentSection = "Default"
	else
		AddHoverText(SpecGameSection, "Specific game Animations")
	end

	--Emote wheel
	local function EmoteWheelButton(Button, AnimButtonName, KeyCode, ActionName)
		local NumLabel = Instance.new("TextLabel")
		NumLabel.Parent = Button
		NumLabel.Size = UDim2.new(1, 0, 1, 0)
		NumLabel.BackgroundTransparency = 1
		NumLabel.TextColor3 = UiButColor
		NumLabel.Text = string.match(ActionName, "%d+")
		NumLabel.Font = Enum.Font.Roboto
		NumLabel.TextTransparency = 0.87
		NumLabel.TextScaled = true
		NumLabel.ZIndex = 100

		local prefix, suffix
		if string.match(AnimButtonName, "^R15") then
			prefix, suffix = string.match(AnimButtonName, "^(R15)(.+)$")
		elseif string.match(AnimButtonName, "^Spec") then
			prefix, suffix = string.match(AnimButtonName, "^(Spec)(.+)$")
		elseif string.match(AnimButtonName, "^R6") then
			prefix, suffix = string.match(AnimButtonName, "^(R6)(.+)$")
		end

		local AnimButton
		if prefix == "R15" then
			AnimButton = ScrollingFrameR15:FindFirstChild(suffix) or ScrollingFrameR15:FindFirstChild("Dance1")
		elseif prefix == "R6" then
			AnimButton = ScrollingFrame:FindFirstChild(suffix) or ScrollingFrame:FindFirstChild("Dance1")
		elseif prefix == "Spec" then
			AnimButton = ScrollingFrameSpecific:FindFirstChild(suffix) or ScrollingFrame:FindFirstChild("Dance1")
		end
		Button.Text = string.gsub(AnimButton.Text, "<[^>]+>", "")

		local AnimActive = false
		Button.MouseButton1Click:connect(function()
			EmoteWheel.Visible = false
			AnimActive = not AnimActive
			if AnimActive == true then
				AnimButton.BackgroundColor3 = ButtonSelectCol
			else
				AnimButton.BackgroundColor3 = ButtonCol
			end
		end)

		AnimButton.Changed:Connect(function()
			if AnimButton.BackgroundColor3 == ButtonSelectCol then
				Button.BackgroundColor3 = ButtonSelectCol
				AnimActive = true
			else
				Button.BackgroundColor3 = ButtonCol
				AnimActive = false
			end
		end)

		local function onKeyPress(actionName, inputState, inputObject)
			if inputState == Enum.UserInputState.Begin then
				EmoteWheel.Visible = false
				AnimActive = not AnimActive
				if AnimActive == true then
					AnimButton.BackgroundColor3 = ButtonSelectCol
				else
					AnimButton.BackgroundColor3 = ButtonCol
				end
			end
			return Enum.ContextActionResult.Sink
		end

		local function updateInputHandling()
			if EmoteWheel.Visible then
				ContextActionService:BindAction(ActionName, onKeyPress, false, KeyCode)
			else
				ContextActionService:UnbindAction(ActionName)
			end
		end

		updateInputHandling()
		EmoteWheel:GetPropertyChangedSignal("Visible"):Connect(updateInputHandling)

	end
	EmoteWheelButton(Emote1, EmoteWheelEmotes.Emote1, Enum.KeyCode.One, "InterceptKey1")
	EmoteWheelButton(Emote2, EmoteWheelEmotes.Emote2, Enum.KeyCode.Two, "InterceptKey2")
	EmoteWheelButton(Emote3, EmoteWheelEmotes.Emote3, Enum.KeyCode.Three, "InterceptKey3")
	EmoteWheelButton(Emote4, EmoteWheelEmotes.Emote4, Enum.KeyCode.Four, "InterceptKey4")
	EmoteWheelButton(Emote5, EmoteWheelEmotes.Emote5, Enum.KeyCode.Five, "InterceptKey5")
	EmoteWheelButton(Emote6, EmoteWheelEmotes.Emote6, Enum.KeyCode.Six, "InterceptKey6")
	EmoteWheelButton(Emote7, EmoteWheelEmotes.Emote7, Enum.KeyCode.Seven, "InterceptKey7")
	EmoteWheelButton(Emote8, EmoteWheelEmotes.Emote8, Enum.KeyCode.Eight, "InterceptKey8")


	-- UI Decorations
	print("Decorating GUI...")
	local UiCornerParts = {"SpecGameSection", "DefaultSection", "Emote1", "Emote2", "Emote3", "Emote4", "Emote5", "Emote6", "Emote7", "Emote8", "ResetButton", "CustomAnimFrame", "PlayAnimButton", "CustomAnimButton", "HotkeysEditOption", "SaveSettingsButton", "LaunchIdDetectorButton", "GithubLinkButton", "HotkeysFrame", "SettingsFrame", "SettingsButton", "GuiTopFrame", "CloseGUI", "DestroyGUI", "GuiBottomFrame", "SpeedValue", "SideFrame", "OpenGUI", "ViewportFrame", "OptionsFrame", "PauseAnimsButton", "StopDefAnimsButton", "PauseAnimateButton", "SitButton", "EmoteWheelButton", "ReversePlayButton", "SearchFrame", "SearchButton"}
	local UiStrokeParts = {"SpecGameSection", "DefaultSection", "Emote1", "Emote2", "Emote3", "Emote4", "Emote5", "Emote6", "Emote7", "Emote8", "CustomAnimFrame", "HotkeysFrame", "SettingsFrame", "GuiTopFrame", "GuiBottomFrame", "SideFrame", "ScrollingFrame", "ScrollingFrameR15", "ScrollingFrameSpecific", "OptionsFrame", "SearchFrame"}
	local UiStroke1Parts = {"ResetButton", "PlayAnimButton", "IdBox", "HotkeysEditOption", "SaveSettingsButton", "LaunchIdDetectorButton", "GithubLinkButton", "SpeedValue", "SearchBox", "PauseAnimsButton", "StopDefAnimsButton", "PauseAnimateButton", "SitButton", "EmoteWheelButton", "ReversePlayButton"}
	local UiGradientParts = {"SpecGameSection", "DefaultSection", "Emote1", "Emote2", "Emote3", "Emote4", "Emote5", "Emote6", "Emote7", "Emote8", "CustomAnimBackButton", "BackButton", "CustomAnimFrame", "PlayAnimButton", "CustomAnimButton", "SettingsButton", "GuiTopFrame", "GuiBottomFrame", "SideFrame", "SettingsButton", "DestroyGUI", "CloseGUI", "OpenGUI", "OptionsButton", "PauseAnimsButton", "StopDefAnimsButton", "PauseAnimateButton", "SitButton", "EmoteWheelButton", "ReversePlayButton", "SearchFrame", "SearchButton", "BackButton"}

	for _, UiPart in ipairs(Emoter:GetDescendants()) do
		if table.find(UiCornerParts, UiPart.Name) and UICornerEnabled then
			local UICorner = Instance.new("UICorner")
			UICorner.Parent = UiPart
			UICorner.CornerRadius = UDim.new(0, 5)
			if UiPart.Name == "GuiTopFrame" then
				UICorner.BottomRightRadius = UDim.new(0, 0)
				UICorner.BottomLeftRadius = UDim.new(0, 0)
			elseif UiPart.Name == "GuiBottomFrame" then
				UICorner.TopLeftRadius = UDim.new(0, 0)
				UICorner.TopRightRadius = UDim.new(0, 0)
			elseif UiPart.Parent == EmoteWheel then
				UICorner.CornerRadius = UDim.new(0, 20)
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

		if table.find(UiGradientParts, UiPart.Name) and UIGradientEnabled then
			local UIGradient = Instance.new("UIGradient")
			UIGradient.Parent = UiPart
			UIGradient.Color = ColorSequence.new(Color3.fromRGB(207, 207, 207), Color3.fromRGB(255, 255, 255))
			UIGradient.Rotation = -90
		end

		if (UiPart.Parent.Name == "ScrollingFrame" or UiPart.Parent.Name == "ScrollingFrameR15" or UiPart.Parent.Name == "ScrollingFrameSpecific") and UiPart:IsA("TextButton") then
			if UICornerEnabled then
				local UICorner = Instance.new("UICorner")
				UICorner.Parent = UiPart
				UICorner.CornerRadius = UDim.new(0, 3)
			end
			if UIGradientEnabled then
				local UIGradient = Instance.new("UIGradient")
				UIGradient.Parent = UiPart
				UIGradient.Color = ColorSequence.new(Color3.fromRGB(207, 207, 207), Color3.fromRGB(255, 255, 255))
				UIGradient.Rotation = -90
			end

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
	AddUiPadding("CurAnimInfoTitle",0,0,1,5)
	AddUiPadding("ScrollingFrame",5,16,7,10)
	AddUiPadding("ScrollingFrameR15",5,16,7,10)
	AddUiPadding("ScrollingFrameSpecific",5,16,7,10)
	AddUiPadding("SearchBox",2,2)
	AddUiPadding("SettingsStuff",5,8,3,5)
	AddUiPadding("SwitchRunIdleExceptionOption", 20)
	AddUiPadding("ThemeOptionText",0,0,0,2)
	AddUiPadding("HotkeysEditOption",0,0,0,2)
	AddUiPadding("HotkeysStuff",10,10,5,5)
	AddUiPadding("SearchFrame",2)
	AddUiPadding("IdBox",2,2)
	AddUiPadding("CustomAnimFrame",2)
	AddUiPadding("DefaultSection",6,0,2)
	AddUiPadding("SpecGameSection",6,0,2)
	AddUiPadding("Emote1",3,3,3,3)
	AddUiPadding("Emote2",3,3,3,3)
	AddUiPadding("Emote3",3,3,3,3)
	AddUiPadding("Emote4",3,3,3,3)
	AddUiPadding("Emote5",3,3,3,3)
	AddUiPadding("Emote6",3,3,3,3)
	AddUiPadding("Emote7",3,3,3,3)
	AddUiPadding("Emote8",3,3,3,3)


	--OnRestart things
	Emoter.Enabled = true

	SettingsFrame.Visible = true --Made this so HotkeysFrame will be scrollable even if you scroll SettingsFrame before opening HotkeysFrame. Idk why it happens
	HotkeysFrame.Visible = true
	wait()
	SettingsFrame.Visible = false
	HotkeysFrame.Visible = false

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
	if CurrentSection == "Default" then
		DefaultSection.UIStroke.Color = Color3.fromRGB(255, 255, 255)
		if RigType == "R15" then
			ScrollingFrameR15.Visible = true
		else
			ScrollingFrame.Visible = true
		end
		ScrollingFrameSpecific.Visible = false
	elseif CurrentSection == "Specific" then
		SpecGameSection.UIStroke.Color = Color3.fromRGB(255, 255, 255)
		ScrollingFrameR15.Visible = false
		ScrollingFrame.Visible = false
		ScrollingFrameSpecific.Visible = true
	end

	if ScrollingFramePos ~= nil then
		ScrollingFrame.CanvasPosition = ScrollingFramePos
		ScrollingFrameR15.CanvasPosition = ScrollingFramePos
	end
	if ScrollingFrameSpecificPos ~= nil then
		ScrollingFrameSpecific.CanvasPosition = ScrollingFrameSpecificPos
	end
	SearchBox.Text = PrevSearchText
	IdBox.Text = PrevCustomAnimId
	SpeedValue.Text = PrevAnimSpeedValue
	if XSize < 460 then
		ValueText.Visible = false
		if XSize < 350 then
			if RigType == "R15" then
				Title.Text = "Emoter R15"
			else
				Title.Text = "Emoter R6"
			end
		end
	end

	GuiEmoter = Emoter
	print("Script loaded!")
	
	local RestartPlayer
	RestartPlayer = Player.CharacterAdded:Connect(function()
		if not GuiActive or not GuiRestarted then
			RestartPlayer:Disconnect()
		end
		if GuiActive and GuiRestarted == false and Player.Character:WaitForChild("Humanoid") then
			table.clear(RestartAnimations)
			StopAnimsEvent:Fire("Reset/Destroy")
			OnRestart()
			RestartPlayer:Disconnect()
		end
	end)
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
	else
		SettingsOpened = false
	end
	SettingsPos = GuiEmoter.SettingsFrame.Position
	if (game:GetService"Players".LocalPlayer.Character:WaitForChild("Humanoid").RigType == Enum.HumanoidRigType.R15) then
		ScrollingFramePos = GuiEmoter.MainFrame.ScrollingFrameR15.CanvasPosition
	else
		ScrollingFramePos = GuiEmoter.MainFrame.ScrollingFrame.CanvasPosition
	end
	ScrollingFrameSpecificPos = GuiEmoter.MainFrame.ScrollingFrameSpecific.CanvasPosition
	if GuiEmoter.MainFrame.OptionsFrame.Visible == true then
		OptionsOpened = true
	else
		OptionsOpened = false
	end
	if GuiEmoter.MainFrame.ScrollingFrameR15.Visible or GuiEmoter.MainFrame.ScrollingFrame.Visible then
		CurrentSection = "Default"
	elseif GuiEmoter.MainFrame.ScrollingFrameSpecific.Visible then
		CurrentSection = "Specific"
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
	if DebugInfoEnabled then
		for index, id in ipairs(RestartAnimations) do
			print("Restored: "..id)
		end
	end
end

game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Welcome to Emoter Gui!", Text = "Wait for script to load!", Duration = 5, Icon = "rbxassetid://87633233506740"})
CreateGui()
