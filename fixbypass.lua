local Players = game:GetService("Players")
local v6 = Players.LocalPlayer

-- Debug function
local function debugPrint(...)
    print("[BYPASS DEBUG]", ...)
end

-- Đợi config load
task.wait(0.5)

-- Lấy bypass list từ config ngoài
local bypassList = {}
debugPrint("Checking for config...")

if getgenv().ConfigV4 then
    debugPrint("ConfigV4 found!")
    if getgenv().ConfigV4["Bypass Kick"] then
        debugPrint("Bypass Kick found!")
        for i, username in pairs(getgenv().ConfigV4["Bypass Kick"]) do
            debugPrint("Processing username #"..i..":", username)
            if username and username ~= "" then
                local lowered = tostring(username):lower()
                table.insert(bypassList, lowered)
                debugPrint("Added to bypass list:", lowered)
            end
        end
    else
        debugPrint("Bypass Kick NOT found in config!")
    end
else
    debugPrint("ConfigV4 NOT found!")
end

debugPrint("Final bypass list:", table.concat(bypassList, ", "))
debugPrint("Current player username:", v6.Name)
debugPrint("Current player username (lowercase):", v6.Name:lower())

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
    for _, bypassName in pairs(bypassList) do
        if bypassName == username then
            debugPrint("MATCH FOUND! Player is bypassed!")
            return true
        end
    end
    return false
end

task.spawn(function()
    while v6 and v6.Parent do
        local _, tier = getRaceAndTier(0)
        local n = tonumber(tostring(tier or ""))
        tierLabel.Text = "Tier: " .. (n and tostring(n) or "N/A")
        
        local bypassed = isPlayerBypassed()
        debugPrint("Tier:", n, "| Bypassed:", bypassed)
        
        if n and n >= 6 then
            if not bypassed then
                debugPrint("KICKING PLAYER - Tier >= 6 and not bypassed")
                v6:Kick(buildKickMessage(n))
                break
            else
                debugPrint("Player is BYPASSED - Not kicking")
            end
        end
        task.wait(1)
    end
end)
