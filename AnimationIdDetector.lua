--[[V3.1
AnimationIdDetector by Fixel
DO NOT COPY AND CLAIM AS YOUR OWN, if you are using some of the script for your own, 
credit is highly appreciated!]]

local HttpService = game:GetService("HttpService")

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
local CharStartButton = Instance.new("ImageButton")
local ModelValue = Instance.new("TextBox")
local ObjectStartButton = Instance.new("ImageButton")
local ObjectModelValue = Instance.new("TextBox")

local ObjectNameBox = Instance.new("TextBox")
local TextNameBox = Instance.new("TextBox")
local AnimIdBox = Instance.new("TextBox")

local TargetAnimObjServices = {
	game:GetService("Workspace"),
	game:GetService("ReplicatedStorage"),
	game:GetService("ReplicatedFirst"),
	game:GetService("Players"),
	game:GetService("StarterGui"),
	game:GetService("StarterPack"),
	game:GetService("StarterPlayer"),
}
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local ObjectModel = TargetAnimObjServices

local CharOperationActive = false
local ObjectOperationActive = false
local DetectDefaultAnims = true

local CharFunctionActive = true
local ObjectFunctionActive = true

--SaveToEmoterData
local ScrollFrameType = "Spec"
local AnimType = "PriorLow"
local Looped = true

game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Welcome to Anim Detector!", Text = "Wait for script to load", Duration = 5, Icon = "rbxassetid://88751076321975"})

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
	if ClonedChar:FindFirstChild("Animate") then
		ClonedChar:FindFirstChild("Animate"):Destroy()
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

local function createUniqueObject(Object, Name, parent)
	local finalName = Name
	local counter = 1
	while parent:FindFirstChild(finalName) do
		finalName = Name .. counter
		counter = counter + 1
	end
	Object.Name = finalName
	return Object
end

local function AddResult(Name, Id, Priority, ObjectPath)
	local ResultFrame = Instance.new("Frame")
	local PriorityText = Instance.new("TextLabel")
	local AnimNameText = Instance.new("TextBox")
	local AnimIdText = Instance.new("TextBox")

	if Priority == 0 then
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

	local SaveButton = Instance.new("ImageButton")
	SaveButton.Name = "SaveButton"
	SaveButton.Parent = ResultFrame
	SaveButton.Size = UDim2.new(0, 25, 0, 25)
	SaveButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SaveButton.LayoutOrder = 3
	SaveButton.Position = UDim2.new(0.7860169, 0, 0, 0)
	SaveButton.BorderSizePixel = 0
	SaveButton.BackgroundColor3 = Color3.fromRGB(91, 255, 82)
	SaveButton.Image = "rbxassetid://6087549875"

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

	local UICorner = Instance.new("UICorner")
	UICorner.TopLeftRadius = UDim.new(0, 5)
	UICorner.CornerRadius = UDim.new(0, 5)
	UICorner.TopRightRadius = UDim.new(0, 5)
	UICorner.BottomRightRadius = UDim.new(0, 5)
	UICorner.BottomLeftRadius = UDim.new(0, 5)
	UICorner.Parent = SaveButton

	local UIStroke = Instance.new("UIStroke")
	UIStroke.Parent = SaveButton

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Wraps = true
	UIListLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
	UIListLayout.Parent = ResultFrame

	AnimNameText.Text = Name
	AnimIdText.Text = Id
	if Priority ~= 0 then
		PriorityText.Text = Priority
	elseif ObjectPath ~= nil then
		PriorityText.Text = "[Path]"
	end

	SaveButton.MouseButton1Click:Connect(function()
		if game:GetService("RunService"):IsStudio() then
			if not workspace:FindFirstChild("AnimsFolder") then
				local AnimsFolder = Instance.new("Folder")
				AnimsFolder.Name = "AnimsFolder"
				AnimsFolder.Parent = workspace
			end
			local SaveFile = game:GetObjects("rbxassetid://"..Id)[1]
			SaveFile.Parent = workspace:FindFirstChild("AnimsFolder")
			createUniqueObject(SaveFile, SaveFile.Name, workspace.AnimsFolder)
			SaveFile:SetAttribute("Id", Id)
		else
			if not game.CoreGui:FindFirstChild("AnimsFolder") then
				local AnimsFolder = Instance.new("Folder")
				AnimsFolder.Name = "AnimsFolder"
				AnimsFolder.Parent = game.CoreGui
			end
			local SaveFile = game:GetObjects("rbxassetid://"..Id)[1]
			SaveFile.Parent = game.CoreGui:FindFirstChild("AnimsFolder")
			createUniqueObject(SaveFile, SaveFile.Name, game.CoreGui.AnimsFolder)
			SaveFile:SetAttribute("Id", Id)
		end
		SaveButton.ImageTransparency = 0.5
		SaveButton.Interactable = false
	end)
	SaveButton.MouseButton2Click:Connect(function()
		ObjectNameBox.Text = string.gsub(Name, "%s", "")
		TextNameBox.Text = Name
		AnimIdBox.Text = Id
	end)

	PlayAnim(ResultFrame, Id)
	AddHoverText(SaveButton, "Save Animation to Export (Right click to add info to SaveToEmoter section")
	if ObjectPath ~= nil then
		AddHoverText(PriorityText, ObjectPath)
	end
end


AnimIdDetector.Name = "AnimIdDetector"
AnimIdDetector.DisplayOrder = 100
AnimIdDetector.ResetOnSpawn = false
if game:GetService("RunService"):IsStudio() then --Made this as i test script mostly in Studio
	AnimIdDetector.Parent = game.Players.LocalPlayer.PlayerGui
else
	AnimIdDetector.Parent = game.CoreGui
end

MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 434, 0, 275)
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
		if ResultsListFrame:FindFirstChildOfClass("Frame")  or AnimObjResultsListFrame:FindFirstChildOfClass("Frame") then
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

local SaveToEmoterButton = Instance.new("ImageButton")
SaveToEmoterButton.Parent = GuiTopFrame
SaveToEmoterButton.Name = "SaveToEmoterButton"
SaveToEmoterButton.AnchorPoint = Vector2.new(0, 0.5)
SaveToEmoterButton.Size = UDim2.new(0, 32, 0, 32)
SaveToEmoterButton.Position = UDim2.new(0, 32, 0.5, 0)
SaveToEmoterButton.BackgroundColor3 = Color3.fromRGB(137, 165, 255)
SaveToEmoterButton.Image = "rbxassetid://84180020565122"
AddHoverText(SaveToEmoterButton, "Open SaveToEmoter (For users of my Emotes GUI)")

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

local DetectDefaultAnimsButton = Instance.new("ImageButton")
DetectDefaultAnimsButton.Parent = GuiTopFrame
DetectDefaultAnimsButton.Name = "DetectDefaultAnimsButton"
DetectDefaultAnimsButton.AnchorPoint = Vector2.new(1, 0.5)
DetectDefaultAnimsButton.Size = UDim2.new(0, 32, 0, 32)
DetectDefaultAnimsButton.Position = UDim2.new(1, -32, 0.5, 0)
DetectDefaultAnimsButton.BackgroundColor3 = Color3.fromRGB(137, 165, 255)
DetectDefaultAnimsButton.Image = "rbxassetid://116957047917442"
AddHoverText(DetectDefaultAnimsButton, "Detect Default animations (For anim Objects)")

local LaunchEmoterButton = Instance.new("ImageButton")
LaunchEmoterButton.Parent = GuiTopFrame
LaunchEmoterButton.Name = "LaunchEmoterButton"
LaunchEmoterButton.AnchorPoint = Vector2.new(1, 0.5)
LaunchEmoterButton.Size = UDim2.new(0, 32, 0, 32)
LaunchEmoterButton.Position = UDim2.new(1, -64, 0.5, 0)
LaunchEmoterButton.BackgroundColor3 = Color3.fromRGB(137, 165, 255)
LaunchEmoterButton.Image = "rbxassetid://87633233506740"
AddHoverText(LaunchEmoterButton, "Launch Emoter (Emotes GUI by me)")

--GuiBootomFrame Parts
GuiBottomFrame.Name = "GuiBottomFrame"
GuiBottomFrame.AnchorPoint = Vector2.new(0, 1)
GuiBottomFrame.Size = UDim2.new(1, 0, 0, 35)
GuiBottomFrame.Position = UDim2.new(0, 0, 1, 1)
GuiBottomFrame.Active = true
GuiBottomFrame.BackgroundColor3 = Color3.fromRGB(137, 165, 255)
GuiBottomFrame.Parent = MainFrame

CharStartButton.Name = "CharStartButton"
CharStartButton.AnchorPoint = Vector2.new(1, 0.5)
CharStartButton.Size = UDim2.new(0, 51, 0, 35)
CharStartButton.LayoutOrder = 1
CharStartButton.Position = UDim2.new(1, 0, 0.5, 0)
CharStartButton.BackgroundColor3 = Color3.fromRGB(37, 255, 26)
CharStartButton.ScaleType = Enum.ScaleType.Fit
CharStartButton.Image = "rbxassetid://8215093320"
CharStartButton.Parent = GuiBottomFrame
AddHoverText(CharStartButton, "Start/Stop detecting animations")

local UICorner3 = Instance.new("UICorner")
UICorner3.TopLeftRadius = UDim.new(0, 0)
UICorner3.CornerRadius = UDim.new(0, 0)
UICorner3.TopRightRadius = UDim.new(0, 0)
UICorner3.BottomRightRadius = UDim.new(0, 5)
UICorner3.BottomLeftRadius = UDim.new(0, 0)
UICorner3.Parent = CharStartButton

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

ObjectStartButton.Name = "ObjectStartButton"
ObjectStartButton.AnchorPoint = Vector2.new(1, 0.5)
ObjectStartButton.Size = UDim2.new(0, 51, 0, 35)
ObjectStartButton.LayoutOrder = 1
ObjectStartButton.Position = UDim2.new(1, 0, 0.5, 0)
ObjectStartButton.BackgroundColor3 = Color3.fromRGB(37, 255, 26)
ObjectStartButton.ScaleType = Enum.ScaleType.Fit
ObjectStartButton.Image = "rbxassetid://8215093320"
ObjectStartButton.Visible = false
ObjectStartButton.Parent = GuiBottomFrame
AddHoverText(ObjectStartButton, "Start/Stop detecting animations")

local UICorner3 = Instance.new("UICorner")
UICorner3.TopLeftRadius = UDim.new(0, 0)
UICorner3.CornerRadius = UDim.new(0, 0)
UICorner3.TopRightRadius = UDim.new(0, 0)
UICorner3.BottomRightRadius = UDim.new(0, 5)
UICorner3.BottomLeftRadius = UDim.new(0, 0)
UICorner3.Parent = ObjectStartButton

ObjectModelValue.Name = "ObjectModelValue"
ObjectModelValue.AnchorPoint = Vector2.new(0.5, 0)
ObjectModelValue.Size = UDim2.new(0, 351, 0, 29)
ObjectModelValue.Position = UDim2.new(0.4280488, 0, 0.0857143, 0)
ObjectModelValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ObjectModelValue.TextWrapped = true
ObjectModelValue.TextColor3 = Color3.fromRGB(0, 0, 0)
ObjectModelValue.PlaceholderText = "'game' is Default"
ObjectModelValue.Text = ""
ObjectModelValue.CursorPosition = -1
ObjectModelValue.Font = Enum.Font.SourceSans
ObjectModelValue.TextXAlignment = Enum.TextXAlignment.Left
ObjectModelValue.ClearTextOnFocus = false
ObjectModelValue.TextScaled = true
ObjectModelValue.Visible = false
ObjectModelValue.Parent = GuiBottomFrame
AddHoverText(ObjectModelValue, "Enter path to find anim objects in")

local UIPadding1 = Instance.new("UIPadding")
UIPadding1.PaddingLeft = UDim.new(0, 2)
UIPadding1.PaddingRight = UDim.new(0, 2)
UIPadding1.Parent = ObjectModelValue

local UIListLayout1 = Instance.new("UIListLayout")
UIListLayout1.FillDirection = Enum.FillDirection.Horizontal
UIListLayout1.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout1.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout1.HorizontalFlex = Enum.UIFlexAlignment.Fill
UIListLayout1.Padding = UDim.new(0, 5)
UIListLayout1.Parent = GuiBottomFrame

local UIPadding2 = Instance.new("UIPadding")
UIPadding2.PaddingLeft = UDim.new(0, 3)
UIPadding2.Parent = GuiBottomFrame

local ExportButton = Instance.new("ImageButton")
ExportButton.Parent = MainFrame
ExportButton.Name = "ExportButton"
ExportButton.ZIndex = 0
ExportButton.AnchorPoint = Vector2.new(1, 0.5)
ExportButton.Size = UDim2.new(0, 35, 0, 40)
ExportButton.Position = UDim2.new(0.9631336, 51, 0.5, 0)
ExportButton.BackgroundColor3 = Color3.fromRGB(37, 255, 26)
ExportButton.ScaleType = Enum.ScaleType.Fit
ExportButton.ImageColor3 = Color3.fromRGB(0, 0, 0)
ExportButton.Image = "rbxassetid://83856799245957"
AddHoverText(ExportButton, "EXPORT")

local UICorner = Instance.new("UICorner")
UICorner.TopLeftRadius = UDim.new(0, 0)
UICorner.CornerRadius = UDim.new(0, 0)
UICorner.TopRightRadius = UDim.new(0, 5)
UICorner.BottomRightRadius = UDim.new(0, 5)
UICorner.BottomLeftRadius = UDim.new(0, 0)
UICorner.Parent = ExportButton


--SaveToEmoterFrame
local SaveToEmoterFrame = Instance.new("Frame")
SaveToEmoterFrame.Visible = false
SaveToEmoterFrame.Parent = MainFrame
SaveToEmoterFrame.Name = "SaveToEmoterFrame"
SaveToEmoterFrame.ZIndex = -1
SaveToEmoterFrame.AnchorPoint = Vector2.new(0.5, 0)
SaveToEmoterFrame.Size = UDim2.new(1, 0, 0, 106)
SaveToEmoterFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
SaveToEmoterFrame.Position = UDim2.new(0.4965438, 0, 1, 7)
SaveToEmoterFrame.BorderSizePixel = 0
SaveToEmoterFrame.BackgroundColor3 = Color3.fromRGB(240, 255, 255)

local UIStroke = Instance.new("UIStroke")
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Thickness = 2
UIStroke.Parent = SaveToEmoterFrame

local TextsFrame = Instance.new("Frame")
TextsFrame.Name = "TextsFrame"
TextsFrame.ZIndex = -1
TextsFrame.Size = UDim2.new(0.465, 0, 1, 0)
TextsFrame.BackgroundTransparency = 1
TextsFrame.Parent = SaveToEmoterFrame

ObjectNameBox.Name = "ObjectNameBox"
ObjectNameBox.Size = UDim2.new(0, 195, 0, 30)
ObjectNameBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
ObjectNameBox.Position = UDim2.new(-0.1481028, 0, -0.03, 0)
ObjectNameBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ObjectNameBox.TextSize = 14
ObjectNameBox.TextColor3 = Color3.fromRGB(0, 0, 0)
ObjectNameBox.Text = "Animation"
ObjectNameBox.Font = Enum.Font.SourceSansBold
ObjectNameBox.ClearTextOnFocus = false
ObjectNameBox.TextScaled = true
ObjectNameBox.Parent = TextsFrame
AddHoverText(ObjectNameBox, "Name of Animation and its button")

TextNameBox.Name = "TextNameBox"
TextNameBox.Size = UDim2.new(0, 195, 0, 30)
TextNameBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextNameBox.LayoutOrder = 1
TextNameBox.Position = UDim2.new(0, 0, 0.3543689, 0)
TextNameBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextNameBox.TextSize = 14
TextNameBox.TextColor3 = Color3.fromRGB(0, 0, 0)
TextNameBox.Text = "Animation"
TextNameBox.CursorPosition = -1
TextNameBox.Font = Enum.Font.SourceSansBold
TextNameBox.ClearTextOnFocus = false
TextNameBox.TextScaled = true
TextNameBox.Parent = TextsFrame
AddHoverText(TextNameBox, "Text on a Button of animation")

AnimIdBox.Name = "AnimIdBox"
AnimIdBox.Size = UDim2.new(0, 195, 0, 30)
AnimIdBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
AnimIdBox.LayoutOrder = 4
AnimIdBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AnimIdBox.TextSize = 14
AnimIdBox.TextColor3 = Color3.fromRGB(0, 0, 0)
AnimIdBox.Text = ""
AnimIdBox.CursorPosition = -1
AnimIdBox.Font = Enum.Font.SourceSansBold
AnimIdBox.ClearTextOnFocus = false
AnimIdBox.TextScaled = true
AnimIdBox.Parent = TextsFrame
AddHoverText(AnimIdBox, "Animation Id")

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Wraps = true
UIListLayout.VerticalFlex = Enum.UIFlexAlignment.SpaceBetween
UIListLayout.Parent = TextsFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 3)
UIPadding.PaddingBottom = UDim.new(0, 3)
UIPadding.PaddingLeft = UDim.new(0, 3)
UIPadding.PaddingRight = UDim.new(0, 3)
UIPadding.Parent = TextsFrame

local UIStroke1 = Instance.new("UIStroke")
UIStroke1.Thickness = 2
UIStroke1.Parent = TextsFrame

local NumberssFrame = Instance.new("Frame")
NumberssFrame.Name = "NumberssFrame"
NumberssFrame.ZIndex = -1
NumberssFrame.AnchorPoint = Vector2.new(1, 0)
NumberssFrame.Size = UDim2.new(0.4047926, 0, 0.311, 0)
NumberssFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
NumberssFrame.BackgroundTransparency = 1
NumberssFrame.Position = UDim2.new(0.8847926, 0, 0, 0)
NumberssFrame.BorderSizePixel = 0
NumberssFrame.BackgroundColor3 = Color3.fromRGB(240, 255, 255)
NumberssFrame.Parent = SaveToEmoterFrame

local LayoutBox = Instance.new("TextBox")
LayoutBox.Name = "LayoutBox"
LayoutBox.Size = UDim2.new(0, 29, 0, 30)
LayoutBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
LayoutBox.LayoutOrder = 3
LayoutBox.Position = UDim2.new(0.5898618, 0, 0, 0)
LayoutBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LayoutBox.TextSize = 14
LayoutBox.TextColor3 = Color3.fromRGB(0, 0, 0)
LayoutBox.Text = "1"
LayoutBox.CursorPosition = -1
LayoutBox.Font = Enum.Font.SourceSansBold
LayoutBox.ClearTextOnFocus = false
LayoutBox.TextScaled = true
LayoutBox.Parent = NumberssFrame
AddHoverText(LayoutBox, "Category number (1-Dances, 2-Actions, 3-Walk&Run, 4-Weird, 5-Poses&Idles, 6-Attack)")

local FadeTimeBox = Instance.new("TextBox")
FadeTimeBox.Name = "FadeTimeBox"
FadeTimeBox.Size = UDim2.new(0, 57, 0, 30)
FadeTimeBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
FadeTimeBox.LayoutOrder = 5
FadeTimeBox.Position = UDim2.new(0.1302317, 0, 0, 0)
FadeTimeBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FadeTimeBox.TextSize = 14
FadeTimeBox.TextColor3 = Color3.fromRGB(0, 0, 0)
FadeTimeBox.Text = ".1"
FadeTimeBox.CursorPosition = -1
FadeTimeBox.Font = Enum.Font.SourceSansBold
FadeTimeBox.ClearTextOnFocus = false
FadeTimeBox.TextScaled = true
FadeTimeBox.Parent = NumberssFrame
AddHoverText(FadeTimeBox, "Fade Time of animation")

local AnimSpeedBox = Instance.new("TextBox")
AnimSpeedBox.Name = "AnimSpeedBox"
AnimSpeedBox.Size = UDim2.new(0, 82, 0, 30)
AnimSpeedBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
AnimSpeedBox.LayoutOrder = 6
AnimSpeedBox.Position = UDim2.new(0.3637507, 0, 0, 0)
AnimSpeedBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AnimSpeedBox.TextSize = 14
AnimSpeedBox.TextColor3 = Color3.fromRGB(0, 0, 0)
AnimSpeedBox.Text = "1"
AnimSpeedBox.CursorPosition = -1
AnimSpeedBox.Font = Enum.Font.SourceSansBold
AnimSpeedBox.ClearTextOnFocus = false
AnimSpeedBox.TextScaled = true
AnimSpeedBox.Parent = NumberssFrame
AddHoverText(AnimSpeedBox, "Animation Speed")

local UIListLayout9 = Instance.new("UIListLayout")
UIListLayout9.FillDirection = Enum.FillDirection.Horizontal
UIListLayout9.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout9.Wraps = true
UIListLayout9.VerticalFlex = Enum.UIFlexAlignment.SpaceBetween
UIListLayout9.Parent = NumberssFrame

local UIPadding9 = Instance.new("UIPadding")
UIPadding9.PaddingTop = UDim.new(0, 3)
UIPadding9.PaddingBottom = UDim.new(0, 3)
UIPadding9.PaddingRight = UDim.new(0, 3)
UIPadding9.Parent = NumberssFrame

local ChoosableFrame = Instance.new("Frame")
ChoosableFrame.Name = "ChoosableFrame"
ChoosableFrame.ZIndex = -1
ChoosableFrame.AnchorPoint = Vector2.new(0, 1)
ChoosableFrame.Size = UDim2.new(0.398, 0, 0.0283019, 65)
ChoosableFrame.BackgroundTransparency = 1
ChoosableFrame.Position = UDim2.new(0.48, 0, 1, 0)
ChoosableFrame.Parent = SaveToEmoterFrame

local UIListLayout1 = Instance.new("UIListLayout")
UIListLayout1.FillDirection = Enum.FillDirection.Horizontal
UIListLayout1.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout1.Wraps = true
UIListLayout1.VerticalFlex = Enum.UIFlexAlignment.SpaceBetween
UIListLayout1.Padding = UDim.new(0, 5)
UIListLayout1.Parent = ChoosableFrame

local PriorityBox = Instance.new("Frame")
PriorityBox.Name = "PriorityBox"
PriorityBox.Size = UDim2.new(0, 62, 0, 45)
PriorityBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
PriorityBox.LayoutOrder = 1
PriorityBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PriorityBox.Parent = ChoosableFrame
AddHoverText(PriorityBox, "Priority of animation")

local LowButton = Instance.new("TextButton")
LowButton.Name = "LowButton"
LowButton.Size = UDim2.new(1, 0, 0, 20)
LowButton.BackgroundTransparency = 1
LowButton.TextTransparency = 1
LowButton.Parent = PriorityBox

local CheckImage = Instance.new("ImageLabel")
CheckImage.Name = "CheckImage"
CheckImage.AnchorPoint = Vector2.new(0, 0.5)
CheckImage.Size = UDim2.new(0, 15, 0, 15)
CheckImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
CheckImage.BorderSizePixel = 1
CheckImage.Position = UDim2.new(0, 0, 0.5, 0)
CheckImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CheckImage.Image = "rbxassetid://130396712201457"
CheckImage.ImageColor3 = Color3.fromRGB(0, 0, 0)
CheckImage.Parent = LowButton

local UIListLayout2 = Instance.new("UIListLayout")
UIListLayout2.FillDirection = Enum.FillDirection.Horizontal
UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout2.Padding = UDim.new(0, 5)
UIListLayout2.Parent = LowButton

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(0.9500334, -10, 0, 25)
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0.115608, 0, 0, 0)
TextLabel.TextSize = 14
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.Text = "Low"
TextLabel.Font = Enum.Font.SourceSans
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = LowButton

local UIPadding1 = Instance.new("UIPadding")
UIPadding1.PaddingBottom = UDim.new(0, 2)
UIPadding1.Parent = TextLabel

local HighButton = Instance.new("TextButton")
HighButton.Name = "HighButton"
HighButton.Size = UDim2.new(1, 0, 0, 20)
HighButton.BackgroundTransparency = 1
HighButton.TextTransparency = 1
HighButton.Parent = PriorityBox

local CheckImage1 = Instance.new("ImageLabel")
CheckImage1.Name = "CheckImage"
CheckImage1.AnchorPoint = Vector2.new(0, 0.5)
CheckImage1.Size = UDim2.new(0, 15, 0, 15)
CheckImage1.BorderColor3 = Color3.fromRGB(0, 0, 0)
CheckImage1.BorderSizePixel = 1
CheckImage1.Position = UDim2.new(0, 0, 0.5, 0)
CheckImage1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CheckImage1.ImageColor3 = Color3.fromRGB(0, 0, 0)
CheckImage1.Parent = HighButton

local UIListLayout3 = Instance.new("UIListLayout")
UIListLayout3.FillDirection = Enum.FillDirection.Horizontal
UIListLayout3.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout3.Padding = UDim.new(0, 5)
UIListLayout3.Parent = HighButton

local TextLabel1 = Instance.new("TextLabel")
TextLabel1.Size = UDim2.new(0.9500334, -10, 0, 25)
TextLabel1.BackgroundTransparency = 1
TextLabel1.Position = UDim2.new(0.115608, 0, 0, 0)
TextLabel1.TextSize = 14
TextLabel1.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel1.Text = "High"
TextLabel1.Font = Enum.Font.SourceSans
TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
TextLabel1.Parent = HighButton

local UIPadding2 = Instance.new("UIPadding")
UIPadding2.PaddingBottom = UDim.new(0, 2)
UIPadding2.Parent = TextLabel1

local UIPadding3 = Instance.new("UIPadding")
UIPadding3.PaddingLeft = UDim.new(0, 5)
UIPadding3.Parent = PriorityBox

local UIListLayout4 = Instance.new("UIListLayout")
UIListLayout4.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout4.Parent = PriorityBox

local ScrollingFrameBox = Instance.new("Frame")
ScrollingFrameBox.Name = "ScrollingFrameBox"
ScrollingFrameBox.Size = UDim2.new(0, 56, 1, 0)
ScrollingFrameBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
ScrollingFrameBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScrollingFrameBox.Parent = ChoosableFrame
AddHoverText(ScrollingFrameBox, "Scrolling frame animation will be shown in (SPECific one is recomended)")

local R6Button = Instance.new("TextButton")
R6Button.Name = "R6Button"
R6Button.Size = UDim2.new(1, 0, 0, 20)
R6Button.BackgroundTransparency = 1
R6Button.TextTransparency = 1
R6Button.Parent = ScrollingFrameBox

local CheckImage2 = Instance.new("ImageLabel")
CheckImage2.Name = "CheckImage"
CheckImage2.AnchorPoint = Vector2.new(0, 0.5)
CheckImage2.Size = UDim2.new(0, 15, 0, 15)
CheckImage2.BorderColor3 = Color3.fromRGB(0, 0, 0)
CheckImage2.BorderSizePixel = 1
CheckImage2.Position = UDim2.new(0, 0, 0.5, 0)
CheckImage2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CheckImage2.ImageColor3 = Color3.fromRGB(0, 0, 0)
CheckImage2.Parent = R6Button

local UIListLayout5 = Instance.new("UIListLayout")
UIListLayout5.FillDirection = Enum.FillDirection.Horizontal
UIListLayout5.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout5.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout5.Padding = UDim.new(0, 5)
UIListLayout5.Parent = R6Button

local TextLabel2 = Instance.new("TextLabel")
TextLabel2.Size = UDim2.new(0.9500334, -10, 0, 25)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Position = UDim2.new(0.115608, 0, 0, 0)
TextLabel2.TextSize = 14
TextLabel2.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel2.Text = "R6"
TextLabel2.Font = Enum.Font.SourceSans
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
TextLabel2.Parent = R6Button

local UIPadding4 = Instance.new("UIPadding")
UIPadding4.PaddingBottom = UDim.new(0, 2)
UIPadding4.Parent = TextLabel2

local R15Button = Instance.new("TextButton")
R15Button.Name = "R15Button"
R15Button.Size = UDim2.new(1, 0, 0, 20)
R15Button.BackgroundTransparency = 1
R15Button.TextTransparency = 1
R15Button.Parent = ScrollingFrameBox

local CheckImage3 = Instance.new("ImageLabel")
CheckImage3.Name = "CheckImage"
CheckImage3.AnchorPoint = Vector2.new(0, 0.5)
CheckImage3.Size = UDim2.new(0, 15, 0, 15)
CheckImage3.BorderColor3 = Color3.fromRGB(0, 0, 0)
CheckImage3.BorderSizePixel = 1
CheckImage3.Position = UDim2.new(0, 0, 0.5, 0)
CheckImage3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CheckImage3.ImageColor3 = Color3.fromRGB(0, 0, 0)
CheckImage3.Parent = R15Button

local UIStroke5 = Instance.new("UIStroke")
UIStroke5.Parent = CheckImage3

local UIListLayout6 = Instance.new("UIListLayout")
UIListLayout6.FillDirection = Enum.FillDirection.Horizontal
UIListLayout6.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout6.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout6.Padding = UDim.new(0, 5)
UIListLayout6.Parent = R15Button

local TextLabel3 = Instance.new("TextLabel")
TextLabel3.Size = UDim2.new(0.9500334, -10, 0, 25)
TextLabel3.BackgroundTransparency = 1
TextLabel3.Position = UDim2.new(0.115608, 0, 0, 0)
TextLabel3.TextSize = 14
TextLabel3.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel3.Text = "R15"
TextLabel3.Font = Enum.Font.SourceSans
TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
TextLabel3.Parent = R15Button

local UIPadding5 = Instance.new("UIPadding")
UIPadding5.PaddingBottom = UDim.new(0, 2)
UIPadding5.Parent = TextLabel3

local SpecificButton = Instance.new("TextButton")
SpecificButton.Name = "SpecificButton"
SpecificButton.Size = UDim2.new(1, 0, 0, 20)
SpecificButton.LayoutOrder = 2
SpecificButton.BackgroundTransparency = 1
SpecificButton.TextTransparency = 1
SpecificButton.Parent = ScrollingFrameBox

local CheckImage4 = Instance.new("ImageLabel")
CheckImage4.Name = "CheckImage"
CheckImage4.AnchorPoint = Vector2.new(0, 0.5)
CheckImage4.Size = UDim2.new(0, 15, 0, 15)
CheckImage4.BorderColor3 = Color3.fromRGB(0, 0, 0)
CheckImage4.BorderSizePixel = 1
CheckImage4.Position = UDim2.new(0, 0, 0.5, 0)
CheckImage4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CheckImage4.Image = "rbxassetid://130396712201457"
CheckImage4.ImageColor3 = Color3.fromRGB(0, 0, 0)
CheckImage4.Parent = SpecificButton

local UIListLayout7 = Instance.new("UIListLayout")
UIListLayout7.FillDirection = Enum.FillDirection.Horizontal
UIListLayout7.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout7.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout7.Padding = UDim.new(0, 5)
UIListLayout7.Parent = SpecificButton

local TextLabel4 = Instance.new("TextLabel")
TextLabel4.Size = UDim2.new(0.9500334, -10, 0, 25)
TextLabel4.BackgroundTransparency = 1
TextLabel4.Position = UDim2.new(0.115608, 0, 0, 0)
TextLabel4.TextSize = 14
TextLabel4.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel4.Text = "Spec"
TextLabel4.Font = Enum.Font.SourceSans
TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
TextLabel4.Parent = SpecificButton

local UIPadding6 = Instance.new("UIPadding")
UIPadding6.PaddingBottom = UDim.new(0, 2)
UIPadding6.Parent = TextLabel4

local UIListLayout8 = Instance.new("UIListLayout")
UIListLayout8.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout8.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout8.Parent = ScrollingFrameBox

local UIPadding7 = Instance.new("UIPadding")
UIPadding7.PaddingLeft = UDim.new(0, 5)
UIPadding7.Parent = ScrollingFrameBox

local UIPadding8 = Instance.new("UIPadding")
UIPadding8.PaddingBottom = UDim.new(0, 3)
UIPadding8.Parent = ChoosableFrame

local LoopBox = Instance.new("ImageButton")
LoopBox.Name = "LoopBox"
LoopBox.Size = UDim2.new(0, 40, 0, 40)
LoopBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
LoopBox.LayoutOrder = 2
LoopBox.BackgroundColor3 = Color3.new(0, 1, 0)
LoopBox.ImageColor3 = Color3.fromRGB(0, 0, 0)
LoopBox.Image = "rbxassetid://127077202039990"
LoopBox.Parent = ChoosableFrame
AddHoverText(LoopBox, "Loopable animation")

local PlayableAnimSaveButton = Instance.new("ImageButton")
PlayableAnimSaveButton.Name = "PlayableAnimSaveButton"
PlayableAnimSaveButton.AnchorPoint = Vector2.new(1, 0)
PlayableAnimSaveButton.Size = UDim2.new(0, 50, 0, 25)
PlayableAnimSaveButton.LayoutOrder = 1
PlayableAnimSaveButton.Position = UDim2.new(1, 0, 0, 0)
PlayableAnimSaveButton.BackgroundColor3 = Color3.fromRGB(37, 255, 26)
PlayableAnimSaveButton.ScaleType = Enum.ScaleType.Fit
PlayableAnimSaveButton.Image = "rbxassetid://6087549875"
PlayableAnimSaveButton.Parent = SaveToEmoterFrame
AddHoverText(PlayableAnimSaveButton, "Save anim to play it in Emoter")

local DefaultAnimSaveButton = Instance.new("ImageButton")
DefaultAnimSaveButton.Name = "DefaultAnimSaveButton"
DefaultAnimSaveButton.AnchorPoint = Vector2.new(1, 0.5)
DefaultAnimSaveButton.Size = UDim2.new(0, 50, 0, 25)
DefaultAnimSaveButton.LayoutOrder = 1
DefaultAnimSaveButton.Position = UDim2.new(1, 0, 0.3584906, 0)
DefaultAnimSaveButton.BackgroundColor3 = Color3.fromRGB(99, 102, 255)
DefaultAnimSaveButton.ScaleType = Enum.ScaleType.Fit
DefaultAnimSaveButton.Image = "rbxassetid://6087549875"
DefaultAnimSaveButton.Parent = SaveToEmoterFrame
AddHoverText(DefaultAnimSaveButton, "Save anim to DefaultAnims Blacklist")

local ToolIdleSaveButton = Instance.new("ImageButton")
ToolIdleSaveButton.Name = "ToolIdleSaveButton"
ToolIdleSaveButton.AnchorPoint = Vector2.new(1, 0.5)
ToolIdleSaveButton.Size = UDim2.new(0, 50, 0, 25)
ToolIdleSaveButton.LayoutOrder = 1
ToolIdleSaveButton.Position = UDim2.new(1, 0, 0.6132075, 0)
ToolIdleSaveButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToolIdleSaveButton.ScaleType = Enum.ScaleType.Fit
ToolIdleSaveButton.Image = "rbxassetid://6087549875"
ToolIdleSaveButton.Parent = SaveToEmoterFrame
AddHoverText(ToolIdleSaveButton, "Save anim to ToolIdleAnims Whitelist")

local ToolActionSaveButton = Instance.new("ImageButton")
ToolActionSaveButton.Name = "ToolActionSaveButton"
ToolActionSaveButton.AnchorPoint = Vector2.new(1, 1)
ToolActionSaveButton.Size = UDim2.new(0, 50, 0, 25)
ToolActionSaveButton.LayoutOrder = 1
ToolActionSaveButton.Position = UDim2.new(1, 0, 1, -1)
ToolActionSaveButton.BackgroundColor3 = Color3.fromRGB(255, 238, 0)
ToolActionSaveButton.ScaleType = Enum.ScaleType.Fit
ToolActionSaveButton.Image = "rbxassetid://6087549875"
ToolActionSaveButton.Parent = SaveToEmoterFrame
AddHoverText(ToolActionSaveButton, "Save anim to ToolActionAnims Whitelist")


-- UI Decorations
local UiCornerParts = {"LaunchEmoterButton", "SaveToEmoterButton", "GuiTopFrame", "DestroyGUI", "GuiBottomFrame", "CharStartButton", "ObjectStartButton", "ModelValue", "ObjectModelValue", "ViewportFrame", "AnimTypeButton", "DetectDefaultAnimsButton"}
local UiStrokeParts = {"PlayableAnimSaveButton", "DefaultAnimSaveButton", "ToolIdleSaveButton", "ToolActionSaveButton", "GuiTopFrame", "GuiBottomFrame", "CharStartButton", "ObjectStartButton", "ModelValue", "ObjectModelValue", "ResultsListFrame", "AnimObjResultsListFrame", "ExportButton"}
local UiStroke1Parts = {"ModelValue", "ModelValue", "ObjectModelValue"}
local UiGradientParts = {"LaunchEmoterButton", "PlayableAnimSaveButton", "DefaultAnimSaveButton", "ToolIdleSaveButton", "ToolActionSaveButton", "SaveToEmoterButton", "GuiTopFrame", "GuiBottomFrame", "DestroyGUI", "CharStartButton", "ObjectStartButton", "AnimTypeButton", "DetectDefaultAnimsButton", "ExportButton"}
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
	CharStartButton.Visible = not CharStartButton.Visible
	ObjectStartButton.Visible = not ObjectStartButton.Visible
	ModelValue.Visible = not ModelValue.Visible
	ObjectModelValue.Visible = not ObjectModelValue.Visible
	if ResultsListFrame.Visible == true then
		AnimTypeButton.Image = "rbxassetid://88751076321975"
	else
		AnimTypeButton.Image = "rbxassetid://85975257618857"
	end
end)

SaveToEmoterButton.MouseButton1Click:Connect(function()
	SaveToEmoterFrame.Visible = not SaveToEmoterFrame.Visible
end)

DetectDefaultAnimsButton.MouseButton1Click:Connect(function()
	DetectDefaultAnims = not DetectDefaultAnims
	if DetectDefaultAnims == true then	
		DetectDefaultAnimsButton.BackgroundColor3 = Color3.fromRGB(137, 165, 255)
	else
		DetectDefaultAnimsButton.BackgroundColor3 = Color3.fromRGB(198, 211, 255)
	end
end)

LaunchEmoterButton.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Fixel656/Roblox-Emotes-GUI-Script-R6-R15/refs/heads/main/MainScript.lua",true))()
end)

R6Button.MouseButton1Click:Connect(function()
	ScrollFrameType = "R6"
	R6Button.CheckImage.Image = "rbxassetid://130396712201457"
	R15Button.CheckImage.Image = ""
	SpecificButton.CheckImage.Image = ""
end)
R15Button.MouseButton1Click:Connect(function()
	ScrollFrameType = "R15"
	R6Button.CheckImage.Image = ""
	R15Button.CheckImage.Image = "rbxassetid://130396712201457"
	SpecificButton.CheckImage.Image = ""
end)
SpecificButton.MouseButton1Click:Connect(function()
	ScrollFrameType = "Spec"
	R6Button.CheckImage.Image = ""
	R15Button.CheckImage.Image = ""
	SpecificButton.CheckImage.Image = "rbxassetid://130396712201457"
end)

LowButton.MouseButton1Click:Connect(function()
	AnimType = "PriorLow"
	LowButton.CheckImage.Image = "rbxassetid://130396712201457"
	HighButton.CheckImage.Image = ""
end)
HighButton.MouseButton1Click:Connect(function()
	AnimType = "PriorHigh"
	LowButton.CheckImage.Image = ""
	HighButton.CheckImage.Image = "rbxassetid://130396712201457"
end)

LoopBox.MouseButton1Click:Connect(function()
	Looped = not Looped
	print(Looped)
	if Looped then
		LoopBox.BackgroundColor3 = Color3.new(0, 1, 0)
	else
		LoopBox.BackgroundColor3 = Color3.new(1, 0, 0)
	end
end)

local function FormatJSON(data)
	local result = "{\n"

	-- 1. Processing CustomEmotes
	local customEmotes = data["CustomEmotes"] or {}
	result = result .. '\t"CustomEmotes": [\n'
	for j, item in ipairs(customEmotes) do
		result = result .. "\t["
		for k, val in ipairs(item) do
			if type(val) == "string" then
				result = result .. '"' .. val .. '"'
			else
				result = result .. tostring(val)
			end
			if k < #item then result = result .. ", " end
		end
		result = result .. "]"
		if j < #customEmotes then result = result .. ",\n" else result = result .. "\n" end
	end
	result = result .. "\t],\n"

	-- 2. Processing DefaultAnims
	local defaultAnims = data["DefaultAnims"] or {}
	result = result .. '\t"DefaultAnims": \n\t\t['
	for j, id in ipairs(defaultAnims) do
		result = result .. '"' .. tostring(id) .. '"'
		if j < #defaultAnims then result = result .. ", " end
	end
	result = result .. "],\n"

	-- 3. Processing ToolActionAnims
	local toolAction = data["ToolActionAnims"] or {}
	result = result .. '\t"ToolActionAnims": \n\t\t['
	for j, id in ipairs(toolAction) do
		result = result .. '"' .. tostring(id) .. '"'
		if j < #toolAction then result = result .. ", " end
	end
	result = result .. "],\n"

	-- 4. Processing ToolIdleAnims
	local toolIdle = data["ToolIdleAnims"] or {}
	result = result .. '\t"ToolIdleAnims": \n\t\t['
	for j, id in ipairs(toolIdle) do
		result = result .. '"' .. tostring(id) .. '"'
		if j < #toolIdle then result = result .. ", " end
	end
	result = result .. "],\n"

	-- 5. Processing EmoteWheelEmotes
	local EmoteWheel = data["EmoteWheelEmotes"] or {}
	result = result .. '\t"EmoteWheelEmotes": \n\t\t['
	for j, id in ipairs(EmoteWheel) do
		result = result .. '"' .. tostring(id) .. '"'
		if j < #EmoteWheel then result = result .. ", " end
	end
	result = result .. "]\n" --No comma since it's the last element

	result = result .. "}"
	return result
end

local function AddNewEmote(Category, ButtonName, ButtonText, ScrollFrameType, LayoutOrder, AnimId, FadeTime, AnimSpeed, AnimType, Looped)
	local targetNumber = tostring(game.GameId)
	local folderPath = "EmoterData/SpecificAnims"
	local targetFilePath = nil
	local fileFound = false

	if AnimId == "" or AnimId == nil then
		game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Error!", Text = "You need to have AnimId to add new animation!", Duration = 3})
		return
	elseif (ButtonName == "" or ButtonText == "") and Category == "Emote" then
		game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Error!", Text = "You need to have ButtonName and ButtonText to add new emote!", Duration = 3})
		return
	end

	local success, files = pcall(listfiles, folderPath)
	if not success then
		warn("[AnimId Detector]: Your exploit doesn't support function listfiles() or folder id empty")
		return
	end
	for _, filePath in ipairs(files) do
		local fileName = filePath:match("[^/\\]+$") or filePath
		local extractedNumber = fileName:match("(%d+)")

		if extractedNumber then
			--print("[AnimId Detector]: Found file: " .. fileName .. " | Extracted number: " .. extractedNumber)
			if extractedNumber == targetNumber then
				print("[AnimId Detector]: Found file: " .. filePath)
				fileFound = true
				targetFilePath = filePath

				break
			end
		end
	end
	if not fileFound then
		warn("[AnimId Detector]: File with Id " .. targetNumber .. "hasn't found in files, Creating a new one")
		targetFilePath = "EmoterData/SpecificAnims/"..targetNumber.." (".. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name ..").lua"
	end

	local fileContent
	local successRead = pcall(function() fileContent = readfile(targetFilePath) end)

	local data = {
		["CustomEmotes"] = {},
		["DefaultAnims"] = {},
		["ToolActionAnims"] = {},
		["ToolIdleAnims"] = {}
	}

	if successRead and fileContent then
		local successDecode, decoded = pcall(function() return HttpService:JSONDecode(fileContent) end)
		if successDecode and decoded then 
			data = decoded 
		else
			warn("[AnimId Detector]: Error in JSON structure in file. Please fix an error and try again.")
			game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Error", Text = "Error in JSON structure in file. Please fix an error and try again", Duration = 3})
			return
		end
	else
		warn("[AnimId Detector]: File hasn't found. Creating a new one...")
	end

	local animIdStr = tostring(AnimId)
	local FinalName = ButtonName

	--Searching for Id dublicate
	local SameId = false
	if Category == "Emote" then
		for _, emote in ipairs(data["CustomEmotes"]) do
			if emote[5] == tonumber(animIdStr) then
				warn(string.format("[AnimId Detector]: There's already anim with Id %s named '%s'", animIdStr, emote[1]))
				SameId = true
				break
			end
		end
	elseif Category == "DefaultAnim" then
		for _, emote in ipairs(data["DefaultAnims"]) do
			if emote == animIdStr then
				warn(string.format("[AnimId Detector]: There's already anim with Id %s", animIdStr))
				SameId = true
				break
			end
		end
	elseif Category == "ToolActionAnim" then
		for _, emote in ipairs(data["ToolActionAnims"]) do
			if emote == animIdStr then
				warn(string.format("[AnimId Detector]: There's already anim with Id %s", animIdStr))
				SameId = true
				break
			end
		end
	elseif Category == "ToolIdleAnim" then
		for _, emote in ipairs(data["ToolIdleAnims"]) do
			if emote == animIdStr then
				warn(string.format("[AnimId Detector]: There's already anim with Id %s", animIdStr))
				SameId = true
				break
			end
		end
	end
	if SameId then return end

	--Find duplicates by name and auto-add numbers
	local nameExists = true
	local counter = 0
	if Category == "Emote" then
		while nameExists do
			nameExists = false
			-- If not first iteration, collect a new name
			if counter > 0 then
				FinalName = ButtonName .. tostring(counter)
			end

			for _, emote in ipairs(data["CustomEmotes"]) do
				if emote[1] == FinalName then
					nameExists = true
					counter = counter + 1
					break
				end
			end
		end
	end

	if counter > 0 then
		print("[AnimId Detector]: There's already anim with this name, changing to: " .. FinalName)
	end

	local newEmoteArray = {
		FinalName, 
		ButtonText,
		ScrollFrameType, 
		LayoutOrder, 
		animIdStr, 
		FadeTime, 
		AnimSpeed, 
		AnimType, 
		Looped
	}

	if Category == "Emote" then
		table.insert(data["CustomEmotes"], newEmoteArray)
	elseif Category == "DefaultAnim" then
		table.insert(data["DefaultAnims"], animIdStr)
	elseif Category == "ToolActionAnim" then
		table.insert(data["ToolActionAnims"], animIdStr)
	elseif Category == "ToolIdleAnim" then
		table.insert(data["ToolIdleAnims"], animIdStr)
	end

	local FormatedText = FormatJSON(data)

	local successWrite, errWrite = pcall(function()
		writefile(targetFilePath, FormatedText)
	end)

	if successWrite then
		print("[AnimId Detector]: Animation '" ..FinalName.." and Id " ..animIdStr.. "' Successfully Added")

		if Category == "Emote" then
			game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Saved as Emote!", Text = "Added Emote to SpecAnims file", Duration = 3})
		elseif Category == "DefaultAnim" then
			game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Saved as DefaultAnim!", Text = "Added DefaultAnim to SpecAnims file", Duration = 3})
		elseif Category == "ToolActionAnim" then
			game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Saved as ToolActionAnim!", Text = "Added ToolActionAnim to SpecAnims file", Duration = 3})
		elseif Category == "ToolIdleAnim" then
			game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Saved as ToolIdleAnim!", Text = "Added ToolIdleAnim to SpecAnims file", Duration = 3})
		end
	else
		warn("[AnimId Detector]: An error occured while saving: " .. tostring(errWrite))
		game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Error", Text = "An error occured while saving", Duration = 3})
	end
end

PlayableAnimSaveButton.MouseButton1Click:Connect(function()
	AddNewEmote("Emote", ObjectNameBox.Text, TextNameBox.Text, ScrollFrameType, tonumber(LayoutBox.Text), tonumber(AnimIdBox.Text), tonumber(FadeTimeBox.Text), tonumber(AnimSpeedBox.Text), AnimType, Looped)
end)
DefaultAnimSaveButton.MouseButton1Click:Connect(function()
	AddNewEmote("DefaultAnim", ObjectNameBox.Text, TextNameBox.Text, ScrollFrameType, LayoutBox.Text, AnimIdBox.Text, FadeTimeBox.Text, AnimSpeedBox.Text, AnimType, Looped)
end)
ToolIdleSaveButton.MouseButton1Click:Connect(function()
	AddNewEmote("ToolIdleAnim", ObjectNameBox.Text, TextNameBox.Text, ScrollFrameType, LayoutBox.Text, AnimIdBox.Text, FadeTimeBox.Text, AnimSpeedBox.Text, AnimType, Looped)
end)
ToolActionSaveButton.MouseButton1Click:Connect(function()
	AddNewEmote("ToolActionAnim", ObjectNameBox.Text, TextNameBox.Text, ScrollFrameType, LayoutBox.Text, AnimIdBox.Text, FadeTimeBox.Text, AnimSpeedBox.Text, AnimType, Looped)
end)

local function DetectPlayingAnimations()

	local Humanoid = nil
	local Animator = nil

	if Character:FindFirstChild("Humanoid") then
		Humanoid = Character:FindFirstChild("Humanoid")
		Animator = Humanoid:FindFirstChild("Animator")
	else
		CharStartButton.Image = "rbxassetid://8215093320"
		CharOperationActive = false
		return
	end
	local playingTracks = Animator:GetPlayingAnimationTracks()
	CharFunctionActive = false

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
				wait(0.05)
			end

		end
	end
	CharFunctionActive = true
end

local function DetectAnimationObjects()
	ObjectFunctionActive = false

	if ObjectModel == TargetAnimObjServices then
		for _, service in ipairs(ObjectModel) do
			for i, Object in ipairs(service:GetDescendants()) do
				if Object:IsA("Animation") then

					local IdNumberString = string.match(Object.AnimationId, "%d+") 
					local SameResult = false

					for i, Result in ipairs(AnimObjResultsListFrame:GetDescendants()) do
						if Result.Name == "AnimIdText" and Result.Text == IdNumberString then
							SameResult = true
							break
						end
					end
					if Object:findFirstAncestor("Animate") and DetectDefaultAnims == false then
						SameResult = true
					end

					if SameResult == false then
						AddResult(Object.Name, IdNumberString, 0, Object:GetFullName())
						wait(0.05)
					end

				end
			end
		end
	else
		for i, Object in ipairs(ObjectModel:GetDescendants()) do
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
					AddResult(Object.Name, IdNumberString, 0, Object:GetFullName())
					wait(0.05)
				end

			end
		end
	end
	ObjectFunctionActive = true
end

task.spawn(function()
	while true do
		if CharOperationActive and 	CharFunctionActive then
			DetectPlayingAnimations()
		end
		if ObjectOperationActive and ObjectFunctionActive then
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
		for _, v in ipairs(service:GetDescendants()) do
			if v.Name == name and v:IsA("Model") and v:FindFirstChild("Humanoid") then
				return v
			end
		end
	end
	return nil
end

local function findObjectByPath(pathString, IsObjectModel)
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


	if currentObject:IsA("Model") and currentObject:FindFirstChild("Humanoid") then
		return currentObject
	elseif IsObjectModel == true then
		return currentObject
	end

	return nil
end

CharStartButton.MouseButton1Click:connect(function()
	CharOperationActive = not CharOperationActive
	if CharOperationActive then
		CharStartButton.Image = "rbxassetid://99514193135085"

		local pathInput = ModelValue.Text
		if pathInput == "" then
			Character = Player.Character or Player.CharacterAdded:Wait()
			game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Start", Text = "Searching for animations...", Duration = 3})
			return
		end
		local foundObject = findObjectByPath(pathInput)

		if foundObject then
			game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Start", Text = "Searching for animations...", Duration = 3})
			Character = foundObject
		else
			game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Error", Text = "No such Character!", Duration = 3})
		end
	else
		CharStartButton.Image = "rbxassetid://8215093320"
	end
end)

ObjectStartButton.MouseButton1Click:connect(function()
	ObjectOperationActive = not ObjectOperationActive
	if ObjectOperationActive then
		ObjectStartButton.Image = "rbxassetid://99514193135085"

		local pathInput = ObjectModelValue.Text
		if pathInput == "" then
			ObjectModel = TargetAnimObjServices
			game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Start", Text = "Searching for animations...", Duration = 3})
			return
		end
		local foundModelObject = findObjectByPath(pathInput, true)

		if foundModelObject then
			game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Start", Text = "Searching for animations...", Duration = 3})
			ObjectModel = foundModelObject
		else
			game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Error", Text = "No such Object!", Duration = 3})
		end
	else
		ObjectStartButton.Image = "rbxassetid://8215093320"
	end
end)

ExportButton.MouseButton1Click:connect(function()
	if game:GetService("RunService"):IsStudio() then return function() error("Cannot run in Roblox Studio!") end end
	local Params = {
		RepoURL = "https://raw.githubusercontent.com/luau/SynSaveInstance/main/",
		SSI = "saveinstance",
	}
	local synsaveinstance = loadstring(game:HttpGet(Params.RepoURL .. Params.SSI .. ".luau", true), Params.SSI)()
	local Options = {
		ReadMe = false,
		SafeMode = false, -- Kicks you before Saving, which prevents you from being detected in any game. Default: false
		AntiIdle = true,
		mode = "invalid",
		FilePath = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name.."_Animations_"..os.date("%d-%m-%Y_%H-%M-%S"),
		Object = game.CoreGui.AnimsFolder,
	}
	synsaveinstance(Options)
end)
