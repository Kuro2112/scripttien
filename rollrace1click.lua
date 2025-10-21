local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local CommF_ = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

local function safeInvoke(...)
    local args = {...}
    local ok, res = pcall(function()
        local unpack = table.unpack or unpack
        return CommF_:InvokeServer(unpack(args))
    end)
    if not ok then
        warn("InvokeServer failed:", res)
        return nil, tostring(res)
    end
    return res, nil
end

local function canBuy(result)
    if result == true or result == 1 or result == "OK" then return true end
    if type(result) == "table" then
        if result.Success or result.ok or result[1] == true then return true end
        if result.status == "OK" or result.state == "purchasable" then return true end
    end
    return false
end

local function notify(title, text, dur)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "Thông báo",
            Text = text or "",
            Duration = dur or 5
        })
    end)
end

local function makeScreen()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local screen = Instance.new("ScreenGui")
    screen.Name = "RaceUtilitiesUI"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.Parent = playerGui
    return screen
end

local function buildMainPanel(parent)
    local frame = Instance.new("Frame")
    frame.Name = "MainPanel"
    frame.Size = UDim2.fromOffset(260, 190)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, -275)
    frame.BackgroundTransparency = 0.1
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -16, 0, 26)
    title.Position = UDim2.fromOffset(8, 8)
    title.BackgroundTransparency = 1
    title.Text = "Race Utilities"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -16, 0, 36)
    status.Position = UDim2.fromOffset(8, 38)
    status.BackgroundTransparency = 1
    status.Text = "Sẵn sàng."
    status.Font = Enum.Font.Gotham
    status.TextSize = 14
    status.TextWrapped = true
    status.TextColor3 = Color3.fromRGB(200, 200, 200)
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Parent = frame

    local btnCyborg = Instance.new("TextButton")
    btnCyborg.Size = UDim2.new(1, -16, 0, 34)
    btnCyborg.Position = UDim2.fromOffset(8, 72)
    btnCyborg.Text = "Đổi sang Cyborg"
    btnCyborg.Font = Enum.Font.GothamBold
    btnCyborg.TextSize = 16
    btnCyborg.BackgroundColor3 = Color3.fromRGB(60, 130, 250)
    btnCyborg.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnCyborg.AutoButtonColor = true
    btnCyborg.Parent = frame
    Instance.new("UICorner", btnCyborg).CornerRadius = UDim.new(0, 8)

    local btnGhoul = Instance.new("TextButton")
    btnGhoul.Size = UDim2.new(1, -16, 0, 34)
    btnGhoul.Position = UDim2.fromOffset(8, 112)
    btnGhoul.Text = "Đổi sang Ghoul"
    btnGhoul.Font = Enum.Font.GothamBold
    btnGhoul.TextSize = 16
    btnGhoul.BackgroundColor3 = Color3.fromRGB(100, 170, 255)
    btnGhoul.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnGhoul.AutoButtonColor = true
    btnGhoul.Parent = frame
    Instance.new("UICorner", btnGhoul).CornerRadius = UDim.new(0, 8)

    local btnReroll = Instance.new("TextButton")
    btnReroll.Size = UDim2.new(1, -16, 0, 34)
    btnReroll.Position = UDim2.fromOffset(8, 152)
    btnReroll.Text = "Reroll Race"
    btnReroll.Font = Enum.Font.GothamBold
    btnReroll.TextSize = 16
    btnReroll.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    btnReroll.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnReroll.AutoButtonColor = true
    btnReroll.Parent = frame
    Instance.new("UICorner", btnReroll).CornerRadius = UDim.new(0, 8)

    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    return frame, status, btnCyborg, btnGhoul, btnReroll
end

local function buildFloatingToggle(parent)
    local toggle = Instance.new("TextButton")
    toggle.Name = "RaceToggle"
    toggle.AnchorPoint = Vector2.new(1, 1)
    toggle.Position = UDim2.new(1, -20, 1, -90)
    toggle.Size = UDim2.fromOffset(60, 60)
    toggle.AutoButtonColor = true
    toggle.Text = "R"
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 18
    toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Parent = parent

    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(90, 90, 90)
    stroke.Thickness = 1.5
    stroke.Parent = toggle

    return toggle
end

local busy = false

local function doCyborgSwitch(setStatus)
    if busy then return end
    busy = true
    local function show(msg) if setStatus then setStatus(msg) end end
    show("Đang kiểm tra điều kiện (CyborgTrainer / Check)...")
    local checkRes = safeInvoke("CyborgTrainer", "Check")
    if not checkRes then
        show("Không gọi được Check. Thử lại sau.")
        busy = false
        return
    end
    if not canBuy(checkRes) then
        show("Chưa đủ điều kiện để đổi sang Cyborg.")
        busy = false
        return
    end
    show("Điều kiện OK. Đang mua/đổi sang Cyborg...")
    local buyRes = safeInvoke("CyborgTrainer", "Buy")
    safeInvoke("ZQuestProgress")
    if buyRes ~= nil then
        show("Đã gửi yêu cầu đổi sang Cyborg! Kiểm tra nhân vật.")
        notify("Cyborg", "Đã yêu cầu đổi sang Cyborg", 5)
    else
        show("Đổi thất bại hoặc không có phản hồi.")
        notify("Cyborg", "Đổi thất bại hoặc không có phản hồi.", 5)
    end
    busy = false
end

local function doGhoulSwitch(setStatus)
    if busy then return end
    busy = true
    local function show(msg) if setStatus then setStatus(msg) end end
    show("Đang kiểm tra điều kiện (Ectoplasm / slot 4)...")
    local buyCheck = safeInvoke("Ectoplasm", "BuyCheck", 4)
    if not buyCheck then
        show("Không gọi được BuyCheck. Thử lại sau.")
        busy = false
        return
    end
    if not canBuy(buyCheck) then
        show("Không đủ điều kiện để đổi (thiếu Ectoplasm hoặc yêu cầu khác).")
        busy = false
        return
    end
    show("Điều kiện OK. Đang đổi sang Ghoul...")
    local changeRes = safeInvoke("Ectoplasm", "Change", 4)
    safeInvoke("ZQuestProgress")
    if changeRes ~= nil then
        show("Đã gửi yêu cầu đổi race sang Ghoul! Kiểm tra nhân vật.")
        notify("Ghoul", "Đã yêu cầu đổi sang Ghoul", 5)
    else
        show("Đổi thất bại hoặc không có phản hồi.")
        notify("Ghoul", "Đổi thất bại hoặc không có phản hồi.", 5)
    end
    busy = false
end

local function rerollRace(setStatus)
    if busy then return end
    busy = true
    local function show(msg) if setStatus then setStatus(msg) end end
    show("Đang reroll race...")
    local ok, err = pcall(function()
        CommF_:InvokeServer("BlackbeardReward", "Reroll", "2")
    end)
    if ok then
        show("Đã reroll race thành công.")
        notify("Race Reroll", "Đã reroll race thành công", 5)
    else
        show("Lỗi khi reroll: " .. tostring(err))
        notify("Race Reroll", "Lỗi khi reroll: " .. tostring(err), 5)
    end
    busy = false
end

local screen = makeScreen()
local mainPanel, statusLabel, btnCyborg, btnGhoul, btnReroll = buildMainPanel(screen)
local toggleBtn = buildFloatingToggle(screen)

local panelVisible = false
local function setPanelVisible(v)
    panelVisible = v and true or false
    mainPanel.Visible = panelVisible
end
setPanelVisible(false)

toggleBtn.MouseButton1Click:Connect(function()
    setPanelVisible(not panelVisible)
end)

btnCyborg.MouseButton1Click:Connect(function()
    doCyborgSwitch(function(t) statusLabel.Text = t end)
end)

btnGhoul.MouseButton1Click:Connect(function()
    doGhoulSwitch(function(t) statusLabel.Text = t end)
end)

btnReroll.MouseButton1Click:Connect(function()
    rerollRace(function(t) statusLabel.Text = t end)
end)
