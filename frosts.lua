-- frostUI.lua / frost.lua
-- ImGui-style UI for Matcha LuaVM

local FrostUI = {}

-- Fonts
FrostUI.Fonts = {
    UI = Drawing.Fonts.UI,
    System = Drawing.Fonts.System,
    SystemBold = Drawing.Fonts.SystemBold,
    Minecraft = Drawing.Fonts.Minecraft,
    Monospace = Drawing.Fonts.Monospace,
    Pixel = Drawing.Fonts.Pixel,
    Fortnite = Drawing.Fonts.Fortnite
}

-- Utility for creating drawings
local function CreateDrawing(type)
    local obj = Drawing.new(type)
    obj.Visible = true
    obj.Transparency = 0
    obj.ZIndex = 2
    obj.Color = Color3.new(1,1,1)
    return obj
end

-- Window class
local Window = {}
Window.__index = Window

function Window.new(title, size, position)
    local self = setmetatable({}, Window)
    self.Title = title or "Window"
    self.Size = size or Vector2.new(400,300)
    self.Position = position or Vector2.new(200,200)
    self.Elements = {}

    -- Background
    self.bg = CreateDrawing("Square")
    self.bg.Size = self.Size
    self.bg.Position = self.Position
    self.bg.Color = Color3.fromRGB(30,30,30)
    self.bg.Filled = true

    -- Title
    self.titleText = CreateDrawing("Text")
    self.titleText.Text = self.Title
    self.titleText.Position = self.Position + Vector2.new(10,10)
    self.titleText.Color = Color3.fromRGB(255,255,255)
    self.titleText.Size = 18
    self.titleText.Font = FrostUI.Fonts.UI
    self.titleText.Outline = true

    return self
end

function Window:AddButton(name, callback)
    local btn = {}
    btn.Name = name
    btn.Callback = callback

    btn.bg = CreateDrawing("Square")
    btn.bg.Size = Vector2.new(120,25)
    btn.bg.Position = self.Position + Vector2.new(20,50 + #self.Elements*35)
    btn.bg.Color = Color3.fromRGB(50,50,50)
    btn.bg.Filled = true

    btn.text = CreateDrawing("Text")
    btn.text.Text = name
    btn.text.Position = btn.bg.Position + Vector2.new(10,2)
    btn.text.Color = Color3.fromRGB(255,255,255)
    btn.text.Size = 16
    btn.text.Font = FrostUI.Fonts.UI
    btn.text.Outline = true

    table.insert(self.Elements, btn)
    return btn
end

function FrostUI:CreateWindow(title, size, position)
    return Window.new(title, size, position)
end

-- IMPORTANT: Return the table!
return FrostUI
