local FrostsUI = loadstring(game:HttpGet("PASTEBIN_RAW_URL_HERE"))()

local window = FrostsUI.CreateWindow("Game Cheats", 350, 400)

-- Title
FrostsUI.Label.new(window, Vector2.new(20, 40), "🎮 Game Cheats Menu", 18)

-- Speed hack
local speedSlider = FrostsUI.Slider.new(window, Vector2.new(20, 80), 250, 16, 200, 16, "Walk Speed", function(value)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = value
    end
end)

-- Jump power
local jumpSlider = FrostsUI.Slider.new(window, Vector2.new(20, 130), 250, 50, 300, 50, "Jump Power", function(value)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = value
    end
end)

-- Noclip toggle
local noclipCheck = FrostsUI.Checkbox.new(window, Vector2.new(20, 180), "Noclip", false, function(checked)
    if checked then
        print("Noclip enabled")
    else
        print("Noclip disabled")
    end
end)

-- Fly toggle
local flyCheck = FrostsUI.Checkbox.new(window, Vector2.new(20, 210), "Fly", false, function(checked)
    if checked then
        print("Fly enabled")
    else
        print("Fly disabled")
    end
end)

-- Buttons
FrostsUI.Button.new(window, Vector2.new(20, 260), Vector2.new(140, 35), "TP to Spawn", function()
    print("Teleporting to spawn...")
end)

FrostsUI.Button.new(window, Vector2.new(180, 260), Vector2.new(140, 35), "Give Tools", function()
    print("Giving tools...")
end)

-- Status
local statusLabel = FrostsUI.Label.new(window, Vector2.new(20, 320), "Status: Ready", 12)
