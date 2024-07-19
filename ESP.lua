local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local ESPBoxes = {}
local ESPEnabled = false

local function createOrUpdateESP(player)
    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        if not LocalPlayer.Team or player.Team ~= LocalPlayer.Team then
            local box = ESPBoxes[player]
            if not box then
                box = Instance.new("BoxHandleAdornment")
                box.Size = player.Character.HumanoidRootPart.Size
                box.Color3 = Color3.new(1, 0, 0)
                box.Transparency = 0.5
                box.ZIndex = 10
                box.AlwaysOnTop = true
                box.Adornee = player.Character.HumanoidRootPart
                box.Parent = game.Workspace.CurrentCamera
                ESPBoxes[player] = box
            end
            box.Visible = ESPEnabled
        elseif ESPBoxes[player] then
            ESPBoxes[player].Visible = false
        end
    end
end

-- Function to update ESP for all players
local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        createOrUpdateESP(player)
    end
end

-- Function to toggle ESP on or off
local function toggleESP()
    ESPEnabled = not ESPEnabled
    for _, box in pairs(ESPBoxes) do
        box.Visible = ESPEnabled
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        wait(1) 
        createOrUpdateESP(player)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPBoxes[player] then
        ESPBoxes[player]:Destroy()
        ESPBoxes[player] = nil
    end
end)

RunService.Heartbeat:Connect(function()
    if ESPEnabled then
        updateESP()
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Z then
        toggleESP()
    end
end)

updateESP()
