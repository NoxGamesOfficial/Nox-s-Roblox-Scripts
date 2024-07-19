local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local function isPlayerVisible(player)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return false
    end

    local humanoidRootPart = character.HumanoidRootPart
    local camera = Workspace.CurrentCamera
    local origin = camera.CFrame.Position
    local direction = (humanoidRootPart.Position - origin).unit
    local ray = Ray.new(origin, direction * 1000)
    
    local hit, position = Workspace:FindPartOnRay(ray, LocalPlayer.Character)
    
    return hit and hit:IsDescendantOf(character)
end

local function getClosestVisiblePlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if not LocalPlayer.Team or player.Team ~= LocalPlayer.Team then
                if isPlayerVisible(player) then
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).magnitude
                    if distance < shortestDistance then
                        closestPlayer = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

local function lockOntoPlayer(player)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local camera = Workspace.CurrentCamera
        local targetPosition = player.Character.HumanoidRootPart.Position
        camera.CFrame = CFrame.new(camera.CFrame.Position, targetPosition)
    end
end

local holdingRightClick = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton2 then
        holdingRightClick = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        holdingRightClick = false
    end
end)

RunService.RenderStepped:Connect(function()
    if holdingRightClick then
        local closestPlayer = getClosestVisiblePlayer()
        if closestPlayer then
            lockOntoPlayer(closestPlayer)
        end
    end
end)
