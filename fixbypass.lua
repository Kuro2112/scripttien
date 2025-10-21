local Players = game:GetService("Players")
local v6 = Players.LocalPlayer

-- Lấy bypass list từ config ngoài
local bypassList = {}
if getgenv().ConfigV4 and getgenv().ConfigV4["Bypass Kick"] then
    for _, username in pairs(getgenv().ConfigV4["Bypass Kick"]) do
        if username ~= "" then
            table.insert(bypassList, username:lower())
        end
    end
end

local function createGui()
    local screen = Instance.new("ScreenGui")
    screen.Name = "TierHUD"
    screen.ResetOnSpawn = false
    screen.Parent = v6:WaitForChild("PlayerGui")
    local label = Instance.new("TextLabel")
    label.Name = "TierLabel"
    label.Size = UDim2.fromOffset(180, 40)
    label.Position = UDim2.new(0, 12, 0, 12)
    label.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    label.BackgroundTransparency = 0.15
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = "Tier: ..."
    label.Parent = screen
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = label
    return label
end

local tierLabel = createGui()

local function buildKickMessage(tier)
    return ("You were kicked from this experience:\nReason: lock gear. your tier: %s"):format(tostring(tier or "N/A"))
end

local function getRaceAndTier(timeoutSec)
    timeoutSec = timeoutSec or 1
    local race, tier
    pcall(function()
        local d = v6:FindFirstChild("Data") or v6:WaitForChild("Data", timeoutSec)
        if d then
            for _, c in pairs(d:GetDescendants()) do
                if c:IsA("StringValue") and c.Name:lower() == "race" then
                    race = c.Value
                elseif c:IsA("ValueBase") and c.Name == "C" then
                    tier = tostring(c.Value)
                end
            end
        end
    end)
    return race, tier
end

local function isPlayerBypassed()
    local username = v6.Name:lower()
    return table.find(bypassList, username) ~= nil
end

task.spawn(function()
    while v6 and v6.Parent do
        local _, tier = getRaceAndTier(0)
        local n = tonumber(tostring(tier or ""))
        tierLabel.Text = "Tier: " .. (n and tostring(n) or "N/A")
        
        if n and n >= 6 and not isPlayerBypassed() then
            v6:Kick(buildKickMessage(n))
            break
        end
        task.wait(1)
    end
end)
