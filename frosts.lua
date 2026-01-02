-- UI Drawing Library for LuaU
local Drawing = Drawing or {}
local DrawingNew = Drawing.new

-- Color constants
local Colors = {
    Background = Color3.fromRGB(25, 25, 30),
    Primary = Color3.fromRGB(0, 120, 215),
    Secondary = Color3.fromRGB(40, 40, 45),
    Text = Color3.fromRGB(240, 240, 240),
    Border = Color3.fromRGB(60, 60, 70),
    Success = Color3.fromRGB(76, 175, 80),
    Warning = Color3.fromRGB(255, 152, 0),
    Error = Color3.fromRGB(244, 67, 54)
}

-- UI Class
local UI = {}
UI.__index = UI

function UI.new(position, size)
    local self = setmetatable({}, UI)
    
    self.Position = position or Vector2.new(50, 50)
    self.Size = size or Vector2.new(300, 400)
    self.Elements = {}
    self.Visible = true
    
    -- Create window background
    self.Background = DrawingNew("Square")
    self.Background.Size = self.Size
    self.Background.Position = self.Position
    self.Background.Color = Colors.Background
    self.Background.Filled = true
    self.Background.Transparency = 0.1
    self.Background.ZIndex = 1
    
    -- Create window border
    self.Border = DrawingNew("Square")
    self.Border.Size = self.Size
    self.Border.Position = self.Position
    self.Border.Color = Colors.Border
    self.Border.Filled = false
    self.Border.Thickness = 2
    self.Border.ZIndex = 2
    
    -- Create title bar
    self.TitleBar = DrawingNew("Square")
    self.TitleBar.Size = Vector2.new(self.Size.X, 30)
    self.TitleBar.Position = self.Position
    self.TitleBar.Color = Colors.Secondary
    self.TitleBar.Filled = true
    self.TitleBar.ZIndex = 3
    
    -- Title text
    self.Title = DrawingNew("Text")
    self.Title.Text = "UI Window"
    self.Title.Position = self.Position + Vector2.new(10, 8)
    self.Title.Color = Colors.Text
    self.Title.Outline = true
    self.Title.Font = Drawing.Fonts.UI
    self.Title.Size = 14
    self.Title.ZIndex = 4
    
    return self
end

function UI:SetTitle(title)
    self.Title.Text = title
end

function UI:SetVisible(visible)
    self.Visible = visible
    self.Background.Visible = visible
    self.Border.Visible = visible
    self.TitleBar.Visible = visible
    self.Title.Visible = visible
    
    for _, element in pairs(self.Elements) do
        element:SetVisible(visible)
    end
end

function UI:Remove()
    self.Background:Remove()
    self.Border:Remove()
    self.TitleBar:Remove()
    self.Title:Remove()
    
    for _, element in pairs(self.Elements) do
        element:Remove()
    end
end

-- Button Class
local Button = {}
Button.__index = Button

function Button.new(parent, position, size, text)
    local self = setmetatable({}, Button)
    
    self.Parent = parent
    self.Position = position or Vector2.new(20, 50)
    self.Size = size or Vector2.new(100, 30)
    self.Text = text or "Button"
    self.Visible = true
    self.OnClick = nil
    
    -- Button background
    self.Background = DrawingNew("Square")
    self.Background.Size = self.Size
    self.Background.Position = self.Parent.Position + self.Position
    self.Background.Color = Colors.Primary
    self.Background.Filled = true
    self.Background.Transparency = 0.1
    self.Background.ZIndex = 5
    
    -- Button border
    self.Border = DrawingNew("Square")
    self.Border.Size = self.Size
    self.Border.Position = self.Background.Position
    self.Border.Color = Colors.Border
    self.Border.Filled = false
    self.Border.Thickness = 1
    self.Border.ZIndex = 6
    
    -- Button text
    self.Label = DrawingNew("Text")
    self.Label.Text = self.Text
    self.Label.Center = true
    self.Label.Position = self.Background.Position + self.Size / 2 - Vector2.new(0, 6)
    self.Label.Color = Colors.Text
    self.Label.Outline = true
    self.Label.Font = Drawing.Fonts.UI
    self.Label.Size = 12
    self.Label.ZIndex = 7
    
    table.insert(parent.Elements, self)
    
    return self
end

function Button:SetText(text)
    self.Text = text
    self.Label.Text = text
end

function Button:SetVisible(visible)
    self.Visible = visible
    self.Background.Visible = visible
    self.Border.Visible = visible
    self.Label.Visible = visible
end

function Button:Remove()
    self.Background:Remove()
    self.Border:Remove()
    self.Label:Remove()
end

-- Label Class
local Label = {}
Label.__index = Label

function Label.new(parent, position, text)
    local self = setmetatable({}, Label)
    
    self.Parent = parent
    self.Position = position or Vector2.new(20, 50)
    self.Text = text or "Label"
    self.Visible = true
    
    self.TextObject = DrawingNew("Text")
    self.TextObject.Text = self.Text
    self.TextObject.Position = self.Parent.Position + self.Position
    self.TextObject.Color = Colors.Text
    self.TextObject.Outline = true
    self.TextObject.Font = Drawing.Fonts.UI
    self.TextObject.Size = 14
    self.TextObject.ZIndex = 5
    
    table.insert(parent.Elements, self)
    
    return self
end

function Label:SetText(text)
    self.Text = text
    self.TextObject.Text = text
end

function Label:SetVisible(visible)
    self.Visible = visible
    self.TextObject.Visible = visible
end

function Label:Remove()
    self.TextObject:Remove()
end

-- Slider Class
local Slider = {}
Slider.__index = Slider

function Slider.new(parent, position, width, min, max, defaultValue)
    local self = setmetatable({}, Slider)
    
    self.Parent = parent
    self.Position = position or Vector2.new(20, 50)
    self.Width = width or 200
    self.Height = 20
    self.Min = min or 0
    self.Max = max or 100
    self.Value = defaultValue or self.Min
    self.Visible = true
    
    -- Slider track
    self.Track = DrawingNew("Square")
    self.Track.Size = Vector2.new(self.Width, 4)
    self.Track.Position = self.Parent.Position + self.Position + Vector2.new(0, 8)
    self.Track.Color = Colors.Secondary
    self.Track.Filled = true
    self.Track.ZIndex = 5
    
    -- Slider fill
    self.Fill = DrawingNew("Square")
    local fillWidth = ((self.Value - self.Min) / (self.Max - self.Min)) * self.Width
    self.Fill.Size = Vector2.new(fillWidth, 4)
    self.Fill.Position = self.Track.Position
    self.Fill.Color = Colors.Primary
    self.Fill.Filled = true
    self.Fill.ZIndex = 6
    
    -- Slider thumb
    self.Thumb = DrawingNew("Circle")
    self.Thumb.Radius = 6
    self.Thumb.Position = self.Track.Position + Vector2.new(fillWidth, 0)
    self.Thumb.Color = Colors.Primary
    self.Thumb.Filled = true
    self.Thumb.ZIndex = 7
    
    -- Value label
    self.ValueLabel = DrawingNew("Text")
    self.ValueLabel.Text = tostring(self.Value)
    self.ValueLabel.Position = self.Track.Position + Vector2.new(self.Width + 10, -4)
    self.ValueLabel.Color = Colors.Text
    self.ValueLabel.Outline = true
    self.ValueLabel.Font = Drawing.Fonts.UI
    self.ValueLabel.Size = 12
    self.ValueLabel.ZIndex = 8
    
    -- Name label
    self.NameLabel = DrawingNew("Text")
    self.NameLabel.Text = "Slider"
    self.NameLabel.Position = self.Track.Position - Vector2.new(0, 18)
    self.NameLabel.Color = Colors.Text
    self.NameLabel.Outline = true
    self.NameLabel.Font = Drawing.Fonts.UI
    self.NameLabel.Size = 12
    self.NameLabel.ZIndex = 8
    
    table.insert(parent.Elements, self)
    
    return self
end

function Slider:SetValue(value)
    self.Value = math.clamp(value, self.Min, self.Max)
    local fillWidth = ((self.Value - self.Min) / (self.Max - self.Min)) * self.Width
    
    self.Fill.Size = Vector2.new(fillWidth, 4)
    self.Thumb.Position = self.Track.Position + Vector2.new(fillWidth, 0)
    self.ValueLabel.Text = tostring(math.floor(self.Value))
end

function Slider:SetName(name)
    self.NameLabel.Text = name
end

function Slider:SetVisible(visible)
    self.Visible = visible
    self.Track.Visible = visible
    self.Fill.Visible = visible
    self.Thumb.Visible = visible
    self.ValueLabel.Visible = visible
    self.NameLabel.Visible = visible
end

function Slider:Remove()
    self.Track:Remove()
    self.Fill:Remove()
    self.Thumb:Remove()
    self.ValueLabel:Remove()
    self.NameLabel:Remove()
end

-- Checkbox Class
local Checkbox = {}
Checkbox.__index = Checkbox

function Checkbox.new(parent, position, text, defaultState)
    local self = setmetatable({}, Checkbox)
    
    self.Parent = parent
    self.Position = position or Vector2.new(20, 50)
    self.Text = text or "Checkbox"
    self.State = defaultState or false
    self.Visible = true
    
    local size = 16
    
    -- Checkbox background
    self.Background = DrawingNew("Square")
    self.Background.Size = Vector2.new(size, size)
    self.Background.Position = self.Parent.Position + self.Position
    self.Background.Color = Colors.Secondary
    self.Background.Filled = true
    self.Background.ZIndex = 5
    
    -- Checkbox border
    self.Border = DrawingNew("Square")
    self.Border.Size = Vector2.new(size, size)
    self.Border.Position = self.Background.Position
    self.Border.Color = Colors.Border
    self.Border.Filled = false
    self.Border.Thickness = 1
    self.Border.ZIndex = 6
    
    -- Checkmark
    self.Checkmark = DrawingNew("Line")
    self.Checkmark.From = self.Background.Position + Vector2.new(3, 8)
    self.Checkmark.To = self.Background.Position + Vector2.new(6, 11)
    self.Checkmark.Color = Colors.Primary
    self.Checkmark.Thickness = 2
    self.Checkmark.ZIndex = 7
    self.Checkmark.Visible = self.State
    
    -- Checkmark (second part)
    self.Checkmark2 = DrawingNew("Line")
    self.Checkmark2.From = self.Background.Position + Vector2.new(6, 11)
    self.Checkmark2.To = self.Background.Position + Vector2.new(12, 3)
    self.Checkmark2.Color = Colors.Primary
    self.Checkmark2.Thickness = 2
    self.Checkmark2.ZIndex = 7
    self.Checkmark2.Visible = self.State
    
    -- Text label
    self.Label = DrawingNew("Text")
    self.Label.Text = self.Text
    self.Label.Position = self.Background.Position + Vector2.new(size + 8, -2)
    self.Label.Color = Colors.Text
    self.Label.Outline = true
    self.Label.Font = Drawing.Fonts.UI
    self.Label.Size = 12
    self.Label.ZIndex = 8
    
    table.insert(parent.Elements, self)
    
    return self
end

function Checkbox:Toggle()
    self.State = not self.State
    self.Checkmark.Visible = self.State
    self.Checkmark2.Visible = self.State
    return self.State
end

function Checkbox:SetVisible(visible)
    self.Visible = visible
    self.Background.Visible = visible
    self.Border.Visible = visible
    self.Label.Visible = visible
    self.Checkmark.Visible = visible and self.State
    self.Checkmark2.Visible = visible and self.State
end

function Checkbox:Remove()
    self.Background:Remove()
    self.Border:Remove()
    self.Checkmark:Remove()
    self.Checkmark2:Remove()
    self.Label:Remove()
end

-- Panel (Container) Class
local Panel = {}
Panel.__index = Panel

function Panel.new(parent, position, size)
    local self = setmetatable({}, Panel)
    
    self.Parent = parent
    self.Position = position or Vector2.new(10, 40)
    self.Size = size or Vector2.new(280, 100)
    self.Elements = {}
    self.Visible = true
    
    -- Panel background
    self.Background = DrawingNew("Square")
    self.Background.Size = self.Size
    self.Background.Position = self.Parent.Position + self.Position
    self.Background.Color = Colors.Secondary
    self.Background.Filled = true
    self.Background.Transparency = 0.2
    self.Background.ZIndex = 5
    
    -- Panel border
    self.Border = DrawingNew("Square")
    self.Border.Size = self.Size
    self.Border.Position = self.Background.Position
    self.Border.Color = Colors.Border
    self.Border.Filled = false
    self.Border.Thickness = 1
    self.Border.ZIndex = 6
    
    table.insert(parent.Elements, self)
    
    return self
end

function Panel:AddElement(element)
    table.insert(self.Elements, element)
end

function Panel:SetVisible(visible)
    self.Visible = visible
    self.Background.Visible = visible
    self.Border.Visible = visible
    
    for _, element in pairs(self.Elements) do
        element:SetVisible(visible)
    end
end

function Panel:Remove()
    self.Background:Remove()
    self.Border:Remove()
    
    for _, element in pairs(self.Elements) do
        element:Remove()
    end
end

-- Example Usage Function
function CreateExampleUI()
    -- Create main window
    local window = UI.new(Vector2.new(50, 50), Vector2.new(320, 450))
    window:SetTitle("UI Example")
    
    -- Add a label
    local titleLabel = Label.new(window, Vector2.new(20, 40), "Welcome to the UI System")
    
    -- Create a panel
    local panel = Panel.new(window, Vector2.new(10, 70), Vector2.new(300, 120))
    
    -- Add elements to panel
    local panelLabel = Label.new(panel, Vector2.new(10, 10), "Settings Panel")
    
    -- Add a slider to panel
    local slider = Slider.new(panel, Vector2.new(20, 40), 200, 0, 100, 50)
    slider:SetName("Volume")
    
    -- Add a checkbox to panel
    local checkbox = Checkbox.new(panel, Vector2.new(20, 80), "Enable Sound", true)
    
    -- Add a button below panel
    local button = Button.new(window, Vector2.new(20, 210), Vector2.new(120, 35), "Apply Settings")
    
    -- Add another button
    local exitButton = Button.new(window, Vector2.new(180, 210), Vector2.new(120, 35), "Exit")
    exitButton.Background.Color = Colors.Error
    
    -- Create another panel
    local statsPanel = Panel.new(window, Vector2.new(10, 260), Vector2.new(300, 170))
    
    -- Add statistics labels
    local statsTitle = Label.new(statsPanel, Vector2.new(10, 10), "Statistics")
    local fpsLabel = Label.new(statsPanel, Vector2.new(20, 40), "FPS: 60")
    local pingLabel = Label.new(statsPanel, Vector2.new(20, 65), "Ping: 25ms")
    local memoryLabel = Label.new(statsPanel, Vector2.new(20, 90), "Memory: 120MB")
    local playersLabel = Label.new(statsPanel, Vector2.new(20, 115), "Players: 12/20")
    
    -- Return the window for external control
    return window
end

-- Export the classes
UI.Button = Button
UI.Label = Label
UI.Slider = Slider
UI.Checkbox = Checkbox
UI.Panel = Panel
UI.Colors = Colors

-- Create and show example UI
local exampleUI = CreateExampleUI()

-- Example of how to update UI elements
--[[
    To update slider value:
    slider:SetValue(75)
    
    To toggle checkbox:
    checkbox:Toggle()
    
    To change button text:
    button:SetText("New Text")
    
    To hide/show UI:
    exampleUI:SetVisible(false)
    
    To remove UI:
    exampleUI:Remove()
]]

return UI
