-- Carrega RedzHub (substitua pelo link do seu RedzHub final, ex: "https://raw.githubusercontent.com/SEUUSUARIO/SEUREPOSITORIO/main/SEUARQUIVO.lua")
local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

local Window = redzlib:MakeWindow({
    Title = "Lifting Simulator Script",
    SubTitle = "by SeuNome",
    SaveFolder = "lifting_sim_settings"
})

local Tab = Window:MakeTab({
    Title = "AutoFarm",
    Icon = "rbxassetid://106319096400681"
})

local selectedWeight = nil

CreateScrollableDropdown(Tab.Container, "Selecionar Peso", {
    "Barbell", "Bench Barbell", "Weight Plate Tree", "Squat Rack",
    "Dumbbell", "Pull-up Bar", "Deadlift Platform", "Kettlebell", "Rope",
    "Sandbag", "Atlas Stone", "Tire Flip", "Sled", "Power Rack", "Smith Machine",
    "Lat Pulldown", "Leg Press", "Leg Curl", "Hack Squat", "Chest Press"
}, function(option)
    selectedWeight = option
    print("[INFO] Peso selecionado:", selectedWeight)
end)

Tab:AddToggle({
    Name = "Ativar AutoLift",
    Default = false,
    Callback = function(state)
        getgenv().autoLift = state
        if state then
            print("[INFO] AutoLift ativado!")
            startAutoLift()
        else
            print("[INFO] AutoLift desativado!")
        end
    end
})

function startAutoLift()
    spawn(function()
        while getgenv().autoLift do
            if selectedWeight then
                local args = {[1] = selectedWeight}
                game:GetService("ReplicatedStorage").Remotes.Lift:FireServer(unpack(args))
            end
            task.wait(0.2)
        end
    end)
end

function CreateScrollableDropdown(parent, title, options, callback)
    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.fromOffset(200, 30)
    dropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    dropdown.Parent = parent

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.fromScale(1, 1)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Text = title .. ": [Clique]"
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.SourceSans
    titleLabel.TextSize = 16
    titleLabel.Parent = dropdown

    local dropButton = Instance.new("TextButton")
    dropButton.Size = UDim2.fromScale(1, 1)
    dropButton.BackgroundTransparency = 1
    dropButton.Text = ""
    dropButton.Parent = dropdown

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 0, 0)
    scrollFrame.CanvasSize = UDim2.fromOffset(0, #options * 25)
    scrollFrame.Position = UDim2.fromScale(0, 1)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.Visible = false
    scrollFrame.Parent = dropdown

    local uiList = Instance.new("UIListLayout")
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Padding = UDim.new(0, 2)
    uiList.Parent = scrollFrame

    for _, option in ipairs(options) do
        local item = Instance.new("TextButton")
        item.Size = UDim2.new(1, -6, 0, 25)
        item.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        item.TextColor3 = Color3.fromRGB(255, 255, 255)
        item.Text = option
        item.Font = Enum.Font.SourceSans
        item.TextSize = 14
        item.BorderSizePixel = 0
        item.Parent = scrollFrame

        item.MouseButton1Click:Connect(function()
            titleLabel.Text = title .. ": " .. option
            scrollFrame.Visible = false
            scrollFrame.Size = UDim2.new(1, 0, 0, 0)
            if callback then callback(option) end
        end)
    end

    dropButton.MouseButton1Click:Connect(function()
        scrollFrame.Visible = not scrollFrame.Visible
        scrollFrame.Size = scrollFrame.Visible and UDim2.new(1, 0, 0, math.min(#options * 25, 200)) or UDim2.new(1, 0, 0, 0)
    end)
end