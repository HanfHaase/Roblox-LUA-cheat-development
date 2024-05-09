local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local highlight = Instance.new("Highlight")
highlight.Name = "Highlight"

local espEnabled = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESPGui"

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleESP"
ToggleButton.Size = UDim2.new(0, 80, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 0, 700)
ToggleButton.BackgroundTransparency = 0.5
ToggleButton.BackgroundColor3 = Color3.new(0, 0, 0)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "ESP: OFF"
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.TextSize = 7 -- Half font size
ToggleButton.TextStrokeTransparency = 0 -- No transparency for text stroke
ToggleButton.TextStrokeColor3 = Color3.new(0, 0, 0) -- Black color for text stroke
ToggleButton.Parent = ScreenGui

local function makeWallsTransparent()
    local workspace = game:GetService("Workspace")
    local walls = workspace:FindFirstChild("Walls")
    
    if walls then
        for _, wall in ipairs(walls:GetDescendants()) do
            if wall:IsA("BasePart") then
                wall.SurfaceTransparency = 1 -- transparency 100%
            end
        end
    end
end

local function updatePlayerHighlights()
    if espEnabled then
        for i, v in ipairs(game:GetService("Players"):GetPlayers()) do
            repeat wait() until v.Character
            
            local highlightClone = v.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("Highlight")
            
            if not highlightClone then
                highlightClone = highlight:Clone()
                highlightClone.Adornee = v.Character
                highlightClone.Parent = v.Character:FindFirstChild("HumanoidRootPart")
                highlightClone.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlightClone.Name = "Highlight"
            end
            
            highlightClone.FillColor = v.Team and v.Team.TeamColor.Color or Color3.new(1, 1, 1) -- team color if available, otherwise white
            highlightClone.OutlineColor = v.Team and v.Team.TeamColor.Color or Color3.new(1, 1, 1) -- team color if available, otherwise white
        end
    else
        for i, v in ipairs(game:GetService("Players"):GetPlayers()) do
            local highlightClone = v.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("Highlight")
            if highlightClone then
                highlightClone.Transparency = 1 -- transparency 100% remove highlights
            end
        end
    end
    
    makeWallsTransparent()
end

local function toggleESP()
    espEnabled = not espEnabled
    ToggleButton.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    
    if espEnabled then
        updatePlayerHighlights() -- Update highlights - ESP
    else
        for i, v in ipairs(game:GetService("Players"):GetPlayers()) do
            local highlightClone = v.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("Highlight")
            if highlightClone then
                highlightClone:Destroy()
            end
        end
    end
end

local function removeESP()
    espEnabled = false
    ToggleButton.Text = "ESP: OFF"
    
    for i, v in ipairs(game:GetService("Players"):GetPlayers()) do
        local highlightClone = v.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("Highlight")
        if highlightClone then
            highlightClone:Destroy()
        end
    end
end

ToggleButton.MouseButton1Click:Connect(toggleESP)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.M then
        ToggleButton:Destroy()
    elseif input.KeyCode == Enum.KeyCode.P then
        removeESP()
    end
end)

ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

game.Players.PlayerAdded:Connect(function(player)
    repeat wait() until player.Character
    updatePlayerHighlights()
end)

game.Players.PlayerRemoving:Connect(function(playerRemoved)
    local highlightClone = playerRemoved.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("Highlight")
    if highlightClone then
        highlightClone:Destroy()
    end
end)

RunService.Heartbeat:Connect(function()
    if espEnabled then
        updatePlayerHighlights() -- update
end)

updatePlayerHighlights() -- Initial update