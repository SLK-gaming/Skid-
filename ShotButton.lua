local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Xoá GUI cũ nếu tồn tại
local oldGui = player:FindFirstChild("PlayerGui"):FindFirstChild("AutoSwingUI")
if oldGui then oldGui:Destroy() end

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.ResetOnSpawn = false
screenGui.Name = "AutoSwingUI"

-- Tâm bắn
local crosshair = Instance.new("Frame")
crosshair.Size = UDim2.new(0, 15, 0, 15)
crosshair.Position = UDim2.new(0.5, -7, 0.5, -7)
crosshair.BackgroundColor3 = Color3.new(1, 1, 1)
crosshair.BorderSizePixel = 0
crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
crosshair.BackgroundTransparency = 0
crosshair.Parent = screenGui

local uiCorner = Instance.new("UICorner", crosshair)
uiCorner.CornerRadius = UDim.new(1, 0)

-- Nút bắn
local fireButton = Instance.new("TextButton")
fireButton.Size = UDim2.new(0, 80, 0, 80)
fireButton.Position = UDim2.new(0, 50, 1, -150)
fireButton.AnchorPoint = Vector2.new(0, 0)
fireButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
fireButton.Text = ""
fireButton.BackgroundTransparency = 0.4
fireButton.BorderSizePixel = 0
fireButton.Parent = screenGui

local fireCorner = Instance.new("UICorner", fireButton)
fireCorner.CornerRadius = UDim.new(1, 0)

-- Nút khóa
local lockButton = Instance.new("TextButton")
lockButton.Size = UDim2.new(0, 40, 0, 40)
lockButton.Position = UDim2.new(0, 140, 1, -100)
lockButton.AnchorPoint = Vector2.new(0, 0)
lockButton.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
lockButton.BackgroundTransparency = 0.4
lockButton.Text = "🔒"
lockButton.TextSize = 20
lockButton.BorderSizePixel = 0
lockButton.Parent = screenGui

local lockCorner = Instance.new("UICorner", lockButton)
lockCorner.CornerRadius = UDim.new(1, 0)

-- Nút "X" để xóa GUI
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -60, 1, -60)
closeButton.AnchorPoint = Vector2.new(0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
closeButton.BackgroundTransparency = 0.4
closeButton.Text = "X"
closeButton.TextSize = 20
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.BorderSizePixel = 0
closeButton.Parent = screenGui

local closeCorner = Instance.new("UICorner", closeButton)
closeCorner.CornerRadius = UDim.new(1, 0)

-- Biến trạng thái
local fireLocked = false

-- Hàm kéo nút
local function makeDraggable(button, isFireButton)
	local dragging = false
	local dragStart, startPos

	button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			if isFireButton and fireLocked then return end
			dragging = true
			dragStart = input.Position
			startPos = button.Position
		end
	end)

	button.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
			local delta = input.Position - dragStart
			button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	button.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end

makeDraggable(fireButton, true)
makeDraggable(lockButton, false)
makeDraggable(closeButton, false)

-- Toggle khóa
lockButton.MouseButton1Click:Connect(function()
	fireLocked = not fireLocked
	lockButton.Text = fireLocked and "🔓" or "🔒"
end)

-- Click bắn
fireButton.MouseButton1Click:Connect(function()
	if fireLocked then return end

	local camSize = camera.ViewportSize
	local x, y = camSize.X / 2, camSize.Y / 2

	VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
	task.wait()
	VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
end)

-- Nút X xóa toàn bộ GUI
closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)
