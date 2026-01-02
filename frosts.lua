-- FrostUI.lua
-- ImGui-style UI for Matcha LuaVM using Drawing.new

local FrostUI = {}

-- Fonts mapping
FrostUI.Fonts = {
    UI = Drawing.Fonts.UI,
    System = Drawing.Fonts.System,
    SystemBold = Drawing.Fonts.SystemBold,
    Minecraft = Drawing.Fonts.Minecraft,
    Monospace = Drawing.Fonts.Monospace,
    Pixel = Drawing.Fonts.Pixel,
    Fortnite = Drawing.Fonts.Fortnite
}

-- Utility functions
local function CreateDrawing(type)
    local obj = Drawing.new(type)
    obj.Visible = true
    obj.Transparency = 0
    obj.ZIndex = 2
    obj.Color = Color3.new(1, 1, 1)
    return obj
end

-- Base Window Class
local Window = {}
Window.__index = Window

function Window.new(title, size, position)
    local self = setmetatable({}, Window)
    self.Title = title or "Window"
    self.Size = size or Vector2.new(400, 300)
    self.Position = position or Vector2.new(200, 200)
    self.Visible = true
    self.Elements = {}

    -- Background
    self.bg = CreateDrawing("Square")
    self.bg.Size = self.Size
    self.bg.Position = self.Position
    self.bg.Color = Color3.fromRGB(30, 30, 30)
    self.bg.Filled = true

    -- Title Text
    self.titleText = CreateDrawing("Text")
    self.titleText.Text = self.Title
    self.titleText.Position = self.Position + Vector2.new(10, 10)
    self.titleText.Color = Color3.fromRGB(255, 255, 255)
    self.titleText.Size = 18
    self.titleText.Font = FrostUI.Fonts.UI
    self.titleText.Outline = true

    return self
end

function Window:AddButton(name, callback)
    local btn = {}
    btn.Name = name
    btn.Callback = callback

    -- Draw button background
    btn.bg = CreateDrawing("Square")
    btn.bg.Size = Vector2.new(120, 25)
    btn.bg.Position = self.Position + Vector2.new(20, 50 + #self.Elements*35)
    btn.bg.Color = Color3.fromRGB(50, 50, 50)
    btn.bg.Filled = true

    -- Draw button text
    btn.text = CreateDrawing("Text")
    btn.text.Text = name
    btn.text.Position = btn.bg.Position + Vector2.new(10, 2)
    btn.text.Color = Color3.fromRGB(255, 255, 255)
    btn.text.Size = 16
    btn.text.Font = FrostUI.Fonts.UI
    btn.text.Outline = true

    table.insert(self.Elements, btn)
    return btn
end

function Window:AddLabel(text)
    local lbl = {}
    lbl.text = CreateDrawing("Text")
    lbl.text.Text = text
    lbl.text.Position = self.Position + Vector2.new(20, 50 + #self.Elements*25)
    lbl.text.Color = Color3.fromRGB(200, 200, 200)
    lbl.text.Size = 16
    lbl.text.Font = FrostUI.Fonts.UI
    lbl.text.Outline = true

    table.insert(self.Elements, lbl)
    return lbl
end

function Window:AddToggle(name, default, callback)
    local toggle = {}
    toggle.State = default or false
    toggle.Callback = callback

    toggle.bg = CreateDrawing("Square")
    toggle.bg.Size = Vector2.new(16, 16)
    toggle.bg.Position = self.Position + Vector2.new(20, 50 + #self.Elements*25)
    toggle.bg.Color = Color3.fromRGB(80, 80, 80)
    toggle.bg.Filled = true

    toggle.check = CreateDrawing("Square")
    toggle.check.Size = Vector2.new(12, 12)
    toggle.check.Position = toggle.bg.Position + Vector2.new(2, 2)
    toggle.check.Color = Color3.fromRGB(0, 255, 0)
    toggle.check.Filled = true
    toggle.check.Visible = toggle.State

    toggle.text = CreateDrawing("Text")
    toggle.text.Text = name
    toggle.text.Position = toggle.bg.Position + Vector2.new(25, -2)
    toggle.text.Color = Color3.fromRGB(255, 255, 255)
    toggle.text.Size = 16
    toggle.text.Font = FrostUI.Fonts.UI
    toggle.text.Outline = true

    table.insert(self.Elements, toggle)
    return toggle
end

function Window:AddSlider(name, min, max, default, callback)
    local slider = {}
    slider.Value = default or min
    slider.Min = min
    slider.Max = max
    slider.Callback = callback

    slider.bg = CreateDrawing("Square")
    slider.bg.Size = Vector2.new(150, 6)
    slider.bg.Position = self.Position + Vector2.new(20, 50 + #self.Elements*35)
    slider.bg.Color = Color3.fromRGB(80, 80, 80)
    slider.bg.Filled = true

    slider.fill = CreateDrawing("Square")
    slider.fill.Size = Vector2.new((slider.Value - min)/(max - min) * 150, 6)
    slider.fill.Position = slider.bg.Position
    slider.fill.Color = Color3.fromRGB(0, 255, 0)
    slider.fill.Filled = true

    slider.text = CreateDrawing("Text")
    slider.text.Text = name .. ": " .. slider.Value
    slider.text.Position = slider.bg.Position + Vector2.new(0, -18)
    slider.text.Color = Color3.fromRGB(255, 255, 255)
    slider.text.Size = 16
    slider.text.Font = FrostUI.Fonts.UI
    slider.text.Outline = true

    table.insert(self.Elements, slider)
    return slider
end

-- Main library function to create a window
function FrostUI:CreateWindow(title, size, position)
    return Window.new(title, size, position)
end

-- Cleanup function
function FrostUI:DestroyWindow(win)
    if win.bg then win.bg:Remove() end
    if win.titleText then win.titleText:Remove() end
    for _, e in pairs(win.Elements) do
        if e.bg then e.bg:Remove() end
        if e.text then e.text:Remove() end
        if e.check then e.check:Remove() end
        if e.fill then e.fill:Remove() end
    end
end

return FrostUI
