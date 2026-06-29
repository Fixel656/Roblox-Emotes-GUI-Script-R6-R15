--[[V1
AnimationIdDetector by Fixel
DO NOT COPY AND CLAIM AS YOUR OWN, if you are using some of the script for your own, 
credit is highly appreciated!]]

local AnimIdDetector = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ResultsListFrame = Instance.new("ScrollingFrame")
local AnimObjResultsListFrame = Instance.new("ScrollingFrame")

local GuiTopFrame = Instance.new("Frame")
local DestroyGUI = Instance.new("TextButton")
local Title = Instance.new("TextLabel")

local ViewportFrame = Instance.new("ViewportFrame")
local ClonedChar = nil

local GuiBottomFrame = Instance.new("Frame")
local StartButton = Instance.new("ImageButton")
local ModelValue = Instance.new("TextBox")

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local OperationActive = false

local function AddHoverText(Object, Text)
	local TextLabel = nil
	Object.MouseEnter:connect(function()
		TextLabel = Instance.new("TextLabel")
		TextLabel.Parent = AnimIdDetector
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

local function AddVPF()
	ViewportFrame.Parent = MainFrame
	ViewportFrame.Visible = false
	ViewportFrame.BackgroundTransparency = 1
	ViewportFrame.Size = UDim2.new(0, 225, 1, 0)
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
	ClonedChar.Name = "AIDVPFCharacter"
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

local function PlayAnim(Object, ID)
	local Anim = Instance.new("Animation")
	Anim.AnimationId = "rbxassetid://".. ID
	local track = Player.Character:WaitForChild("Humanoid"):LoadAnimation(Anim)
	
	track.Priority = Enum.AnimationPriority.Action4

	local AnimSpeed = nil
	local PauseAnimsOption = false
	local AnimACTIVE = false

	local VPFtrack = ClonedChar:WaitForChild("Humanoid"):LoadAnimation(Anim)
	local VPFActive = false
	Object.MouseEnter:connect(function()
		VPFActive = true
		VPFtrack.Looped = true
		VPFtrack:Play(0, 1, 1)
		ViewportFrame.Visible = true
		game.TweenService:Create(ViewportFrame, TweenInfo.new(.1), {BackgroundTransparency = 0}):Play()
	end)

	Object.MouseLeave:connect(function()
		VPFActive = false
		game.TweenService:Create(ViewportFrame, TweenInfo.new(.1), {BackgroundTransparency = 1}):Play()
		ViewportFrame.Visible = false
		VPFtrack:Stop(0)
	end)
end

local function AddResult(Name, Id, Priority)
	local ResultFrame = Instance.new("Frame")
	local PriorityText = Instance.new("TextLabel")
	local AnimNameText = Instance.new("TextBox")
	local AnimIdText = Instance.new("TextBox")
	
	if Priority == nil then
		ResultFrame.Parent = AnimObjResultsListFrame
	else
		ResultFrame.Parent = ResultsListFrame
	end
	ResultFrame.Name = "ResultFrame"
	ResultFrame.Size = UDim2.new(1, 0, 0, 25)
	ResultFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ResultFrame.Position = UDim2.new(0.1201044, 0, 0.137931, 0)
	ResultFrame.BorderSizePixel = 0
	ResultFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

	AnimNameText.Name = "AnimNameText"
	AnimNameText.LayoutOrder = 0
	AnimNameText.Size = UDim2.new(0, 150, 0, 37)
	AnimNameText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	AnimNameText.BackgroundTransparency = 1
	AnimNameText.Position = UDim2.new(0.1331593, 0, 0, 0)
	AnimNameText.BorderSizePixel = 0
	AnimNameText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	AnimNameText.TextSize = 31
	AnimNameText.TextColor3 = Color3.fromRGB(0, 0, 0)
	AnimNameText.TextEditable = false
	AnimNameText.Font = Enum.Font.SourceSansBold
	AnimNameText.ClearTextOnFocus = false
	AnimNameText.TextScaled = true
	AnimNameText.TextXAlignment = Enum.TextXAlignment.Left
	AnimNameText.Parent = ResultFrame

	AnimIdText.Name = "AnimIdText"
	AnimIdText.LayoutOrder = 2
	AnimIdText.Size = UDim2.new(0, 165, 0, 37)
	AnimIdText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	AnimIdText.BackgroundTransparency = 1
	AnimIdText.Position = UDim2.new(0.5718015, 0, 0.2432432, 0)
	AnimIdText.BorderSizePixel = 0
	AnimIdText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	AnimIdText.TextSize = 31
	AnimIdText.TextColor3 = Color3.fromRGB(0, 0, 0)
	AnimIdText.TextEditable = false
	AnimIdText.Font = Enum.Font.SourceSansBold
	AnimIdText.ClearTextOnFocus = false
	AnimIdText.TextScaled = true
	AnimIdText.Parent = ResultFrame
	
	PriorityText.Name = "PriorityText"
	PriorityText.LayoutOrder = 2
	PriorityText.Size = UDim2.new(0, 72, 0, 37)
	PriorityText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	PriorityText.BackgroundTransparency = 1
	PriorityText.BorderSizePixel = 0
	PriorityText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	PriorityText.Text = "-"
	PriorityText.TextSize = 29
	PriorityText.TextColor3 = Color3.fromRGB(0, 0, 0)
	PriorityText.TextWrapped = true
	PriorityText.Font = Enum.Font.SourceSansBold
	PriorityText.TextScaled = true
	PriorityText.Parent = ResultFrame

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Wraps = true
	UIListLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
	UIListLayout.Parent = ResultFrame

	local UIPadding = Instance.new("UIPadding")
	UIPadding.PaddingLeft = UDim.new(0, 3)
	UIPadding.PaddingRight = UDim.new(0, 3)
	UIPadding.Parent = PriorityText

	local UIStroke = Instance.new("UIStroke")
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Parent = AnimIdText

	local UIPadding1 = Instance.new("UIPadding")
	UIPadding1.PaddingLeft = UDim.new(0, 3)
	UIPadding1.PaddingRight = UDim.new(0, 3)
	UIPadding1.Parent = AnimNameText

	local UIPadding2 = Instance.new("UIPadding")
	UIPadding2.PaddingLeft = UDim.new(0, 3)
	UIPadding2.PaddingRight = UDim.new(0, 3)
	UIPadding2.Parent = AnimIdText

	local UICorner = Instance.new("UICorner")
	UICorner.TopLeftRadius = UDim.new(0, 5)
	UICorner.CornerRadius = UDim.new(0, 5)
	UICorner.TopRightRadius = UDim.new(0, 5)
	UICorner.BottomRightRadius = UDim.new(0, 5)
	UICorner.BottomLeftRadius = UDim.new(0, 5)
	UICorner.Parent = ResultFrame

	local UIStroke1 = Instance.new("UIStroke")
	UIStroke1.Parent = ResultFrame

	AnimNameText.Text = Name
	AnimIdText.Text = Id
	if Priority ~= nil then
		PriorityText.Text = Priority
	end

	PlayAnim(ResultFrame, Id)
	AddHoverText(PriorityText, "Animation Priority")
	AddHoverText(AnimNameText, "Animation Name")
	AddHoverText(AnimIdText, "Animation Id")
end

AnimIdDetector.Name = "AnimIdDetector"
AnimIdDetector.Parent = game.Players.LocalPlayer.PlayerGui
AnimIdDetector.DisplayOrder = 100

MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 413, 0, 275)
MainFrame.BackgroundTransparency = 1
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.Active = true
MainFrame.BackgroundColor3 = Color3.fromRGB(137, 165, 255)
MainFrame.Parent = AnimIdDetector

local UIDragDetector = Instance.new("UIDragDetector")
UIDragDetector.Parent = MainFrame

ResultsListFrame.Name = "ResultsListFrame"
ResultsListFrame.Size = UDim2.new(1, 0, 0, 205)
ResultsListFrame.Position = UDim2.new(0, 0, 0, 34)
ResultsListFrame.BackgroundColor3 = Color3.fromRGB(219, 244, 255)
ResultsListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ResultsListFrame.CanvasSize = UDim2.new(0, 0, 0.5, 0)
ResultsListFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
ResultsListFrame.ScrollBarThickness = 10
ResultsListFrame.Parent = MainFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 5)
UIPadding.PaddingBottom = UDim.new(0, 5)
UIPadding.PaddingLeft = UDim.new(0, 5)
UIPadding.PaddingRight = UDim.new(0, 16)
UIPadding.Parent = ResultsListFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = ResultsListFrame

AnimObjResultsListFrame.Name = "AnimObjResultsListFrame"
AnimObjResultsListFrame.Size = UDim2.new(1, 0, 0, 205)
AnimObjResultsListFrame.Position = UDim2.new(0, 0, 0, 34)
AnimObjResultsListFrame.Visible = false
AnimObjResultsListFrame.BackgroundColor3 = Color3.fromRGB(180, 184, 255)
AnimObjResultsListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
AnimObjResultsListFrame.CanvasSize = UDim2.new(0, 0, 0.5, 0)
AnimObjResultsListFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
AnimObjResultsListFrame.ScrollBarThickness = 10
AnimObjResultsListFrame.Parent = MainFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 5)
UIPadding.PaddingBottom = UDim.new(0, 5)
UIPadding.PaddingLeft = UDim.new(0, 5)
UIPadding.PaddingRight = UDim.new(0, 16)
UIPadding.Parent = AnimObjResultsListFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = AnimObjResultsListFrame

GuiTopFrame.Name = "GuiTopFrame"
GuiTopFrame.Size = UDim2.new(1, 0, 0, 32)
GuiTopFrame.BorderColor3 = Color3.fromRGB(62, 62, 62)
GuiTopFrame.BackgroundColor3 = Color3.fromRGB(137, 165, 255)
GuiTopFrame.Parent = MainFrame

local TipLabel = Instance.new("TextLabel")
TipLabel.Parent = GuiTopFrame
TipLabel.AnchorPoint = Vector2.new(0.5, 0)
TipLabel.Size = UDim2.new(0, 400, 0, 42)
TipLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TipLabel.BackgroundTransparency = 1
TipLabel.Position = UDim2.new(0.5, 0, 0, 110)
TipLabel.TextSize = 14
TipLabel.Text = "Detected animations will be shown here"
TipLabel.TextWrapped = true
TipLabel.Font = Enum.Font.SourceSansBold
TipLabel.TextTransparency = 0.7
TipLabel.TextScaled = true

task.spawn(function()
	while true do
		if ResultsListFrame:FindFirstChildOfClass("Frame") then
			TipLabel:Destroy()
		end
		task.wait()
	end
end)

DestroyGUI.Name = "DestroyGUI"
DestroyGUI.AnchorPoint = Vector2.new(1, 0.5)
DestroyGUI.Size = UDim2.new(0, 32, 0, 32)
DestroyGUI.Position = UDim2.new(1, 0, 0.5, 0)
DestroyGUI.BackgroundColor3 = Color3.fromRGB(137, 165, 255)
DestroyGUI.TextSize = 34
DestroyGUI.TextColor3 = Color3.fromRGB(0, 0, 0)
DestroyGUI.Text = "X"
DestroyGUI.TextWrapped = true
DestroyGUI.Font = Enum.Font.FredokaOne
DestroyGUI.Parent = GuiTopFrame
AddHoverText(DestroyGUI, "Delete GUI")

local AnimTypeButton = Instance.new("ImageButton")
AnimTypeButton.Name = "AnimTypeButton"
AnimTypeButton.Parent = GuiTopFrame
AnimTypeButton.AnchorPoint = Vector2.new(0, 0.5)
AnimTypeButton.BackgroundColor3 = Color3.fromRGB(137, 165, 255)
AnimTypeButton.ImageColor3 = Color3.fromRGB(0, 0, 0)
AnimTypeButton.BackgroundTransparency = 0
AnimTypeButton.Position = UDim2.new(0, 0, 0.5, 0)
AnimTypeButton.Size = UDim2.new(0, 32, 0, 32)
AnimTypeButton.Image = "rbxassetid://88751076321975"
AddHoverText(AnimTypeButton, "Change Animation extraction type (Humanoid/Animation Object")

Title.Name = "Title"
Title.AnchorPoint = Vector2.new(0.5, 0.5)
Title.Size = UDim2.new(0, 119, 0, 31)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.5, 0, 0.5, 0)
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
Title.TextStrokeTransparency = 0
Title.TextSize = 24
Title.TextColor3 = Color3.fromRGB(42, 42, 42)
Title.Text = "Anim ID Detector"
Title.Font = Enum.Font.SourceSansBold
Title.Parent = GuiTopFrame

GuiBottomFrame.Name = "GuiBottomFrame"
GuiBottomFrame.AnchorPoint = Vector2.new(0, 1)
GuiBottomFrame.Size = UDim2.new(1, 0, 0, 35)
GuiBottomFrame.Position = UDim2.new(0, 0, 1, 1)
GuiBottomFrame.Active = true
GuiBottomFrame.BackgroundColor3 = Color3.fromRGB(137, 165, 255)
GuiBottomFrame.Parent = MainFrame

StartButton.Name = "StartButton"
StartButton.AnchorPoint = Vector2.new(1, 0.5)
StartButton.Size = UDim2.new(0, 51, 0, 35)
StartButton.LayoutOrder = 1
StartButton.Position = UDim2.new(1, 0, 0.5, 0)
StartButton.BackgroundColor3 = Color3.fromRGB(37, 255, 26)
StartButton.ScaleType = Enum.ScaleType.Fit
StartButton.Image = "rbxassetid://8215093320"
StartButton.Parent = GuiBottomFrame
AddHoverText(StartButton, "Start/Stop detecting animations")

local UICorner3 = Instance.new("UICorner")
UICorner3.TopLeftRadius = UDim.new(0, 0)
UICorner3.CornerRadius = UDim.new(0, 0)
UICorner3.TopRightRadius = UDim.new(0, 0)
UICorner3.BottomRightRadius = UDim.new(0, 5)
UICorner3.BottomLeftRadius = UDim.new(0, 0)
UICorner3.Parent = StartButton

ModelValue.Name = "ModelValue"
ModelValue.AnchorPoint = Vector2.new(0.5, 0)
ModelValue.Size = UDim2.new(0, 351, 0, 29)
ModelValue.Position = UDim2.new(0.4280488, 0, 0.0857143, 0)
ModelValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ModelValue.TextWrapped = true
ModelValue.TextColor3 = Color3.fromRGB(0, 0, 0)
ModelValue.PlaceholderText = "Your Char is Default"
ModelValue.Text = ""
ModelValue.CursorPosition = -1
ModelValue.Font = Enum.Font.SourceSans
ModelValue.TextXAlignment = Enum.TextXAlignment.Left
ModelValue.ClearTextOnFocus = false
ModelValue.TextScaled = true
ModelValue.Parent = GuiBottomFrame
AddHoverText(ModelValue, "Enter a name or a path to character")

local UIPadding1 = Instance.new("UIPadding")
UIPadding1.PaddingLeft = UDim.new(0, 2)
UIPadding1.PaddingRight = UDim.new(0, 2)
UIPadding1.Parent = ModelValue

local UIListLayout1 = Instance.new("UIListLayout")
UIListLayout1.FillDirection = Enum.FillDirection.Horizontal
UIListLayout1.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout1.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout1.HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween
UIListLayout1.Padding = UDim.new(0, 5)
UIListLayout1.Parent = GuiBottomFrame

local UIPadding2 = Instance.new("UIPadding")
UIPadding2.PaddingLeft = UDim.new(0, 3)
UIPadding2.Parent = GuiBottomFrame

-- UI Decorations

local UiCornerParts = {"GuiTopFrame", "DestroyGUI", "GuiBottomFrame", "ModelValue", "ViewportFrame", "AnimTypeButton"}
local UiStrokeParts = {"GuiTopFrame", "GuiBottomFrame", "ModelValue", "ResultsListFrame", "AnimObjResultsListFrame"}
local UiStroke1Parts = {"ModelValue"}
local UiGradientParts = {"GuiTopFrame", "GuiBottomFrame", "DestroyGUI", "StartButton", "AnimTypeButton"}

for _, UiPart in ipairs(AnimIdDetector:GetDescendants()) do
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

-- Functions

DestroyGUI.MouseButton1Click:connect(function()
	AnimIdDetector:Destroy()
end)

AnimTypeButton.MouseButton1Click:Connect(function()
	ResultsListFrame.Visible = not ResultsListFrame.Visible
	AnimObjResultsListFrame.Visible = not AnimObjResultsListFrame.Visible
	if ResultsListFrame.Visible == true then
		AnimTypeButton.Image = "rbxassetid://88751076321975"
	else
		AnimTypeButton.Image = "rbxassetid://85975257618857"
	end
end)

local function DetectPlayingAnimations()
	local Humanoid = Character:WaitForChild("Humanoid")
	local playingTracks = Humanoid:GetPlayingAnimationTracks()

	for i, track in ipairs(playingTracks) do
		local animationObject = track.Animation
		if animationObject then

			local IdNumberString = string.match(animationObject.AnimationId, "%d+") 
			local SameResult = false
			
			for i, Result in ipairs(ResultsListFrame:GetDescendants()) do
				if Result.Name == "AnimIdText" and Result.Text == IdNumberString then
					SameResult = true
					break
				end
			end
			
			if SameResult == false then
				AddResult(track.Name, IdNumberString, track.Priority.Name)
			end

		end
	end
end

local targetAnimObjServices = {
	game:GetService("Workspace"),
	game:GetService("ReplicatedStorage"),
	game:GetService("ReplicatedFirst"),
	game:GetService("Players"),
	game:GetService("StarterGui"),
	game:GetService("StarterPack"),
	game:GetService("StarterPlayer"),
}

local function DetectAnimationObjects()
	for _, service in ipairs(targetAnimObjServices) do
		for i, Object in ipairs(service:GetDescendants()) do
			if Object:IsA("Animation") or Object:IsA("AnimationClip") then

				local IdNumberString = string.match(Object.AnimationId, "%d+") 
				local SameResult = false

				for i, Result in ipairs(AnimObjResultsListFrame:GetDescendants()) do
					if Result.Name == "AnimIdText" and Result.Text == IdNumberString then
						SameResult = true
						break
					end
				end

				if SameResult == false then
					AddResult(Object.Name, IdNumberString)
				end

			end
		end
	end
end

task.spawn(function()
	while true do
		if OperationActive then
			DetectPlayingAnimations()
			DetectAnimationObjects()
		end
		wait(.1)
	end
end)

local targetServices = {
	game:GetService("Workspace"),
	game:GetService("ReplicatedStorage"),
	game:GetService("Players"),
	game:GetService("StarterGui"),
}

local function findObjectByName(name)
	for _, service in ipairs(targetServices) do
		-- GetDescendants проверяет вообще все объекты внутри сервиса на всех уровнях вложенности
		for _, v in ipairs(service:GetDescendants()) do
			if v.Name == name and v:IsA("Model") and v:FindFirstChild("Humanoid") then
				return v
			end
		end
	end
	return nil -- Если ничего не нашли
end


local function findObjectByPath(pathString)
	local pathStringChanged = string.gsub(pathString, "^%s*(.-)%s*$", "%1")

	local parts = {}
	for part in string.gmatch(pathStringChanged, "[^%.]+") do
		table.insert(parts, part)
	end

	if #parts == 0 then return nil end
	if parts[1] ~= "game" then
		local FoundPlayer = findObjectByName(pathString)
		return FoundPlayer
	end

	local currentObject = game

	for i = 2, #parts do
		local nextName = parts[i]
		local nextObject = currentObject:FindFirstChild(nextName)

		if not nextObject and currentObject == game and (nextName == "workspace" or nextName == "Workspace") then
			nextObject = game:GetService("Workspace")
		end
		
		if currentObject == game.Players and nextName == "LocalPlayer" then
			nextObject = game.Players.LocalPlayer
		end
		
		if not nextObject then
			warn("Can't find: '" .. nextName .. "' in " .. currentObject:GetFullName())
			return nil
		end

		currentObject = nextObject
	end

	return currentObject
end


StartButton.MouseButton1Click:connect(function()
	OperationActive = not OperationActive
	if OperationActive then
		StartButton.Image = "rbxassetid://99514193135085"
		
		local pathInput = ModelValue.Text
		if pathInput == "" then
			Character = Player.Character or Player.CharacterAdded:Wait()
			return
		end
		local foundObject = findObjectByPath(pathInput)

		if foundObject then
			game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Changed", Text = "CharacterChanged to ".. foundObject.Name, Duration = 3})
			Character = foundObject
		else
			warn("No such Object")
		end
	else
		StartButton.Image = "rbxassetid://8215093320"
	end
end)
game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Welcome to Animation Detector!", Text = "Wait for script to load", Duration = 5, Icon = "rbxassetid://88751076321975"})
