-- FrostsUI Library v1.0
-- A complete UI library for LuaU (Roblox Exploiting)
local FrostsUI = {}

-- Color constants
FrostsUI.Colors = {
    Background = Color3.fromRGB(25, 25, 30),
    Primary = Color3.fromRGB(0, 120, 215),
    Secondary = Color3.fromRGB(40, 40, 45),
    Text = Color3.fromRGB(240, 240, 240),
    Border = Color3.fromRGB(60, 60, 70),
    Success = Color3.fromRGB(76, 175, 80),
    Warning = Color3.fromRGB(255, 152, 0),
    Error = Color3.fromRGB(244, 67, 54),
    Info = Color3.fromRGB(33, 150, 243)
}

-- Get the Drawing library
local Drawing = Drawing or (function()
    local success, result = pcall(game.GetService, game, "RunService")
    if success then
        return Drawing
    end
    return nil
end)()

if not Drawing then
    warn("Drawing library not available!")
    return FrostsUI
end

-- UI Class
FrostsUI.Window = {}
FrostsUI.Window.__index = FrostsUI.Window

function FrostsUI.Window.new(title, position, size)
    local self = setmetatable({}, FrostsUI.Window)
    
    self.Title = title or "FrostsUI Window"
    self.Position = position or Vector2.new(50, 50)
    self.Size = size or Vector2.new(350, 450)
    self.Elements = {}
    self.Visible = true
    self.Active = true
    
    -- Create window background
    self.Background = Drawing.new("Square")
    self.Background.Size = self.Size
    self.Background.Position = self.Position
    self.Background.Color = FrostsUI.Colors.Background
    self.Background.Filled = true
    self.Background.Transparency = 0.95
    self.Background.ZIndex = 1
    
    -- Create window border
    self.Border = Drawing.new("Square")
    self.Border.Size = self.Size
    self.Border.Position = self.Position
    self.Border.Color = FrostsUI.Colors.Border
    self.Border.Filled = false
    self.Border.Thickness = 2
    self.Border.ZIndex = 2
    
    -- Create title bar
    self.TitleBar = Drawing.new("Square")
    self.TitleBar.Size = Vector2.new(self.Size.X, 30)
    self.TitleBar.Position = self.Position
    self.TitleBar.Color = FrostsUI.Colors.Secondary
    self.TitleBar.Filled = true
    self.TitleBar.Transparency = 0.8
    self.TitleBar.ZIndex = 3
    
    -- Title text
    self.TitleText = Drawing.new("Text")
    self.TitleText.Text = self.Title
    self.TitleText.Position = self.Position + Vector2.new(10, 8)
    self.TitleText.Color = FrostsUI.Colors.Text
    self.TitleText.Outline = true
    self.TitleText.Font = Drawing.Fonts.UI
    self.TitleText.Size = 14
    self.TitleText.ZIndex = 4
    
    -- Close button
    self.CloseButton = Drawing.new("Square")
    self.CloseButton.Size = Vector2.new(30, 30)
    self.CloseButton.Position = self.Position + Vector2.new(self.Size.X - 30, 0)
    self.CloseButton.Color = FrostsUI.Colors.Error
    self.CloseButton.Filled = true
    self.CloseButton.Transparency = 0.8
    self.CloseButton.ZIndex = 5
    
    -- Close button text
    self.CloseText = Drawing.new("Text")
    self.CloseText.Text = "X"
    self.CloseText.Position = self.CloseButton.Position + Vector2.new(12, 8)
    self.CloseText.Color = FrostsUI.Colors.Text
    self.CloseText.Outline = true
    self.CloseText.Font = Drawing.Fonts.UI
    self.CloseText.Size = 14
    self.CloseText.ZIndex = 6
    
    -- Setup mouse input for dragging and closing
    self:Draggable()
    self:SetupCloseButton()
    
    return self
end

function FrostsUI.Window:Draggable()
    local dragging = false
    local dragStart
    local startPos
    
    self.TitleBar.MouseButton1Down:Connect(function(input)
        if not self.Active then return end
        dragging = true
        dragStart = input.Position
        startPos = self.Position
        
        local connection
        connection = game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                self.Position = startPos + delta
                self:UpdatePositions()
            end
        end)
        
        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
                connection:Disconnect()
            end
        end)
    end)
end

function FrostsUI.Window:SetupCloseButton()
    self.CloseButton.MouseButton1Down:Connect(function()
        if self.Active then
            self:Destroy()
        end
    end)
end

function FrostsUI.Window:UpdatePositions()
    self.Background.Position = self.Position
    self.Border.Position = self.Position
    self.TitleBar.Position = self.Position
    self.TitleText.Position = self.Position + Vector2.new(10, 8)
    self.CloseButton.Position = self.Position + Vector2.new(self.Size.X - 30, 0)
    self.CloseText.Position = self.CloseButton.Position + Vector2.new(12, 8)
    
    -- Update all elements
    for _, element in pairs(self.Elements) do
        if element.UpdatePosition then
            element:UpdatePosition()
        end
    end
end

function FrostsUI.Window:SetTitle(title)
    self.Title = title
    self.TitleText.Text = title
end

function FrostsUI.Window:SetVisible(visible)
    self.Visible = visible
    self.Background.Visible = visible
    self.Border.Visible = visible
    self.TitleBar.Visible = visible
    self.TitleText.Visible = visible
    self.CloseButton.Visible = visible
    self.CloseText.Visible = visible
    
    for _, element in pairs(self.Elements) do
        if element.SetVisible then
            element:SetVisible(visible)
        end
    end
end

function FrostsUI.Window:Destroy()
    self.Active = false
    self.Background:Remove()
    self.Border:Remove()
    self.TitleBar:Remove()
    self.TitleText:Remove()
    self.CloseButton:Remove()
    self.CloseText:Remove()
    
    for _, element in pairs(self.Elements) do
        if element.Destroy then
            element:Destroy()
        end
    end
    self.Elements = {}
end

function FrostsUI.Window:AddElement(element)
    table.insert(self.Elements, element)
    return element
end

-- Button Class
FrostsUI.Button = {}
FrostsUI.Button.__index = FrostsUI.Button

function FrostsUI.Button.new(window, position, size, text, callback)
    local self = setmetatable({}, FrostsUI.Button)
    
    self.Window = window
    self.Position = position or Vector2.new(20, 50)
    self.Size = size or Vector2.new(120, 35)
    self.Text = text or "Button"
    self.Callback = callback
    self.Visible = true
    self.Color = FrostsUI.Colors.Primary
    
    -- Calculate absolute position
    self.AbsolutePosition = window.Position + self.Position
    
    -- Button background
    self.Background = Drawing.new("Square")
    self.Background.Size = self.Size
    self.Background.Position = self.AbsolutePosition
    self.Background.Color = self.Color
    self.Background.Filled = true
    self.Background.Transparency = 0.8
    self.Background.ZIndex = 10
    
    -- Button border
    self.Border = Drawing.new("Square")
    self.Border.Size = self.Size
    self.Border.Position = self.AbsolutePosition
    self.Border.Color = FrostsUI.Colors.Border
    self.Border.Filled = false
    self.Border.Thickness = 1
    self.Border.ZIndex = 11
    
    -- Button text
    self.Label = Drawing.new("Text")
    self.Label.Text = self.Text
    self.Label.Center = true
    self.Label.Position = self.AbsolutePosition + self.Size / 2 - Vector2.new(0, 8)
    self.Label.Color = FrostsUI.Colors.Text
    self.Label.Outline = true
    self.Label.Font = Drawing.Fonts.UI
    self.Label.Size = 14
    self.Label.ZIndex = 12
    
    -- Setup click event
    if callback then
        self.Background.MouseButton1Down:Connect(function()
            if self.Visible then
                callback()
            end
        end)
    end
    
    window:AddElement(self)
    return self
end

function FrostsUI.Button:SetText(text)
    self.Text = text
    self.Label.Text = text
end

function FrostsUI.Button:SetColor(color)
    self.Color = color
    self.Background.Color = color
end

function FrostsUI.Button:SetVisible(visible)
    self.Visible = visible
    self.Background.Visible = visible
    self.Border.Visible = visible
    self.Label.Visible = visible
end

function FrostsUI.Button:UpdatePosition()
    self.AbsolutePosition = self.Window.Position + self.Position
    self.Background.Position = self.AbsolutePosition
    self.Border.Position = self.AbsolutePosition
    self.Label.Position = self.AbsolutePosition + self.Size / 2 - Vector2.new(0, 8)
end

function FrostsUI.Button:Destroy()
    self.Background:Remove()
    self.Border:Remove()
    self.Label:Remove()
end

-- Label Class
FrostsUI.Label = {}
FrostsUI.Label.__index = FrostsUI.Label

function FrostsUI.Label.new(window, position, text, size, centered)
    local self = setmetatable({}, FrostsUI.Label)
    
    self.Window = window
    self.Position = position or Vector2.new(20, 50)
    self.Text = text or "Label"
    self.Size = size or 14
    self.Centered = centered or false
    self.Color = FrostsUI.Colors.Text
    self.Visible = true
    
    self.AbsolutePosition = window.Position + self.Position
    
    self.TextObject = Drawing.new("Text")
    self.TextObject.Text = self.Text
    self.TextObject.Position = self.AbsolutePosition
    self.TextObject.Color = self.Color
    self.TextObject.Outline = true
    self.TextObject.Font = Drawing.Fonts.UI
    self.TextObject.Size = self.Size
    self.TextObject.Center = self.Centered
    self.TextObject.ZIndex = 10
    
    window:AddElement(self)
    return self
end

function FrostsUI.Label:SetText(text)
    self.Text = text
    self.TextObject.Text = text
end

function FrostsUI.Label:SetColor(color)
    self.Color = color
    self.TextObject.Color = color
end

function FrostsUI.Label:SetVisible(visible)
    self.Visible = visible
    self.TextObject.Visible = visible
end

function FrostsUI.Label:UpdatePosition()
    self.AbsolutePosition = self.Window.Position + self.Position
    self.TextObject.Position = self.AbsolutePosition
end

function FrostsUI.Label:Destroy()
    self.TextObject:Remove()
end

-- Slider Class
FrostsUI.Slider = {}
FrostsUI.Slider.__index = FrostsUI.Slider

function FrostsUI.Slider.new(window, position, width, min, max, defaultValue, name, callback)
    local self = setmetatable({}, FrostsUI.Slider)
    
    self.Window = window
    self.Position = position or Vector2.new(20, 50)
    self.Width = width or 200
    self.Height = 20
    self.Min = min or 0
    self.Max = max or 100
    self.Value = defaultValue or self.Min
    self.Name = name or "Slider"
    self.Callback = callback
    self.Visible = true
    self.Dragging = false
    
    self.AbsolutePosition = window.Position + self.Position
    
    -- Slider track
    self.Track = Drawing.new("Square")
    self.Track.Size = Vector2.new(self.Width, 4)
    self.Track.Position = self.AbsolutePosition + Vector2.new(0, 20)
    self.Track.Color = FrostsUI.Colors.Secondary
    self.Track.Filled = true
    self.Track.ZIndex = 10
    
    -- Slider fill
    local fillWidth = ((self.Value - self.Min) / (self.Max - self.Min)) * self.Width
    self.Fill = Drawing.new("Square")
    self.Fill.Size = Vector2.new(fillWidth, 4)
    self.Fill.Position = self.Track.Position
    self.Fill.Color = FrostsUI.Colors.Primary
    self.Fill.Filled = true
    self.Fill.ZIndex = 11
    
    -- Slider thumb
    self.Thumb = Drawing.new("Circle")
    self.Thumb.Radius = 6
    self.Thumb.Position = self.Track.Position + Vector2.new(fillWidth, 2)
    self.Thumb.Color = FrostsUI.Colors.Primary
    self.Thumb.Filled = true
    self.Thumb.ZIndex = 12
    
    -- Name label
    self.NameLabel = FrostsUI.Label.new(window, self.Position, self.Name, 12)
    
    -- Value label
    self.ValueLabel = FrostsUI.Label.new(window, 
        self.Position + Vector2.new(self.Width + 10, 16), 
        tostring(math.floor(self.Value)), 12)
    
    -- Setup dragging
    self:SetupDragging()
    
    window:AddElement(self)
    return self
end

function FrostsUI.Slider:SetupDragging()
    self.Thumb.MouseButton1Down:Connect(function(input)
        if not self.Visible then return end
        self.Dragging = true
        self:Drag(input.Position.X)
        
        local connection
        connection = game:GetService("UserInputService").InputChanged:Connect(function(input)
            if self.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                self:Drag(input.Position.X)
            end
        end)
        
        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                self.Dragging = false
                if connection then
                    connection:Disconnect()
                end
            end
        end)
    end)
end

function FrostsUI.Slider:Drag(mouseX)
    local relativeX = mouseX - self.Track.Position.X
    relativeX = math.clamp(relativeX, 0, self.Width)
    
    local value = self.Min + (relativeX / self.Width) * (self.Max - self.Min)
    self:SetValue(value)
    
    if self.Callback then
        self.Callback(value)
    end
end

function FrostsUI.Slider:SetValue(value)
    self.Value = math.clamp(value, self.Min, self.Max)
    local fillWidth = ((self.Value - self.Min) / (self.Max - self.Min)) * self.Width
    
    self.Fill.Size = Vector2.new(fillWidth, 4)
    self.Thumb.Position = self.Track.Position + Vector2.new(fillWidth, 2)
    self.ValueLabel:SetText(tostring(math.floor(self.Value)))
end

function FrostsUI.Slider:SetVisible(visible)
    self.Visible = visible
    self.Track.Visible = visible
    self.Fill.Visible = visible
    self.Thumb.Visible = visible
    self.NameLabel:SetVisible(visible)
    self.ValueLabel:SetVisible(visible)
end

function FrostsUI.Slider:UpdatePosition()
    self.AbsolutePosition = self.Window.Position + self.Position
    self.Track.Position = self.AbsolutePosition + Vector2.new(0, 20)
    
    local fillWidth = ((self.Value - self.Min) / (self.Max - self.Min)) * self.Width
    self.Fill.Position = self.Track.Position
    self.Thumb.Position = self.Track.Position + Vector2.new(fillWidth, 2)
    
    self.NameLabel:UpdatePosition()
    self.ValueLabel:UpdatePosition()
end

function FrostsUI.Slider:Destroy()
    self.Track:Remove()
    self.Fill:Remove()
    self.Thumb:Remove()
    self.NameLabel:Destroy()
    self.ValueLabel:Destroy()
end

-- Checkbox Class
FrostsUI.Checkbox = {}
FrostsUI.Checkbox.__index = FrostsUI.Checkbox

function FrostsUI.Checkbox.new(window, position, text, defaultValue, callback)
    local self = setmetatable({}, FrostsUI.Checkbox)
    
    self.Window = window
    self.Position = position or Vector2.new(20, 50)
    self.Text = text or "Checkbox"
    self.Checked = defaultValue or false
    self.Callback = callback
    self.Visible = true
    self.Size = 16
    
    self.AbsolutePosition = window.Position + self.Position
    
    -- Checkbox background
    self.Background = Drawing.new("Square")
    self.Background.Size = Vector2.new(self.Size, self.Size)
    self.Background.Position = self.AbsolutePosition
    self.Background.Color = FrostsUI.Colors.Secondary
    self.Background.Filled = true
    self.Background.ZIndex = 10
    
    -- Checkbox border
    self.Border = Drawing.new("Square")
    self.Border.Size = Vector2.new(self.Size, self.Size)
    self.Border.Position = self.AbsolutePosition
    self.Border.Color = FrostsUI.Colors.Border
    self.Border.Filled = false
    self.Border.Thickness = 1
    self.Border.ZIndex = 11
    
    -- Checkmark
    self.Checkmark = Drawing.new("Line")
    self.Checkmark.From = self.AbsolutePosition + Vector2.new(3, 8)
    self.Checkmark.To = self.AbsolutePosition + Vector2.new(6, 11)
    self.Checkmark.Color = FrostsUI.Colors.Primary
    self.Checkmark.Thickness = 2
    self.Checkmark.ZIndex = 12
    self.Checkmark.Visible = self.Checked
    
    -- Checkmark (second part)
    self.Checkmark2 = Drawing.new("Line")
    self.Checkmark2.From = self.AbsolutePosition + Vector2.new(6, 11)
    self.Checkmark2.To = self.AbsolutePosition + Vector2.new(12, 3)
    self.Checkmark2.Color = FrostsUI.Colors.Primary
    self.Checkmark2.Thickness = 2
    self.Checkmark2.ZIndex = 12
    self.Checkmark2.Visible = self.Checked
    
    -- Text label
    self.Label = FrostsUI.Label.new(window, self.Position + Vector2.new(self.Size + 8, -2), self.Text, 12)
    
    -- Setup click event
    self.Background.MouseButton1Down:Connect(function()
        if self.Visible then
            self:Toggle()
        end
    end)
    
    window:AddElement(self)
    return self
end

function FrostsUI.Checkbox:Toggle()
    self.Checked = not self.Checked
    self.Checkmark.Visible = self.Checked
    self.Checkmark2.Visible = self.Checked
    
    if self.Callback then
        self.Callback(self.Checked)
    end
    
    return self.Checked
end

function FrostsUI.Checkbox:SetVisible(visible)
    self.Visible = visible
    self.Background.Visible = visible
    self.Border.Visible = visible
    self.Label:SetVisible(visible)
    self.Checkmark.Visible = visible and self.Checked
    self.Checkmark2.Visible = visible and self.Checked
end

function FrostsUI.Checkbox:UpdatePosition()
    self.AbsolutePosition = self.Window.Position + self.Position
    self.Background.Position = self.AbsolutePosition
    self.Border.Position = self.AbsolutePosition
    self.Checkmark.From = self.AbsolutePosition + Vector2.new(3, 8)
    self.Checkmark.To = self.AbsolutePosition + Vector2.new(6, 11)
    self.Checkmark2.From = self.AbsolutePosition + Vector2.new(6, 11)
    self.Checkmark2.To = self.AbsolutePosition + Vector2.new(12, 3)
    self.Label:UpdatePosition()
end

function FrostsUI.Checkbox:Destroy()
    self.Background:Remove()
    self.Border:Remove()
    self.Checkmark:Remove()
    self.Checkmark2:Remove()
    self.Label:Destroy()
end

-- Textbox Class (Input Field)
FrostsUI.Textbox = {}
FrostsUI.Textbox.__index = FrostsUI.Textbox

function FrostsUI.Textbox.new(window, position, size, placeholder, callback)
    local self = setmetatable({}, FrostsUI.Textbox)
    
    self.Window = window
    self.Position = position or Vector2.new(20, 50)
    self.Size = size or Vector2.new(150, 30)
    self.Placeholder = placeholder or "Type here..."
    self.Callback = callback
    self.Visible = true
    self.Text = ""
    self.Focused = false
    
    self.AbsolutePosition = window.Position + self.Position
    
    -- Background
    self.Background = Drawing.new("Square")
    self.Background.Size = self.Size
    self.Background.Position = self.AbsolutePosition
    self.Background.Color = FrostsUI.Colors.Secondary
    self.Background.Filled = true
    self.Background.ZIndex = 10
    
    -- Border
    self.Border = Drawing.new("Square")
    self.Border.Size = self.Size
    self.Border.Position = self.AbsolutePosition
    self.Border.Color = FrostsUI.Colors.Border
    self.Border.Filled = false
    self.Border.Thickness = 1
    self.Border.ZIndex = 11
    
    -- Text
    self.TextObject = Drawing.new("Text")
    self.TextObject.Text = self.Placeholder
    self.TextObject.Position = self.AbsolutePosition + Vector2.new(5, 8)
    self.TextObject.Color = Color3.fromRGB(150, 150, 150) -- Gray for placeholder
    self.TextObject.Outline = true
    self.TextObject.Font = Drawing.Fonts.UI
    self.TextObject.Size = 12
    self.TextObject.ZIndex = 12
    
    -- Cursor
    self.Cursor = Drawing.new("Line")
    self.Cursor.From = self.AbsolutePosition + Vector2.new(5, 10)
    self.Cursor.To = self.AbsolutePosition + Vector2.new(5, self.Size.Y - 10)
    self.Cursor.Color = FrostsUI.Colors.Text
    self.Cursor.Thickness = 1
    self.Cursor.ZIndex = 13
    self.Cursor.Visible = false
    
    -- Setup focus events
    self:SetupFocus()
    window:AddElement(self)
    return self
end

function FrostsUI.Textbox:SetupFocus()
    self.Background.MouseButton1Down:Connect(function()
        self:Focus()
    end)
    
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if not self:IsMouseOver() then
                self:Unfocus()
            end
        end
    end)
    
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if self.Focused and input.KeyCode == Enum.KeyCode.Return then
            self:Unfocus()
            if self.Callback then
                self.Callback(self.Text)
            end
        elseif self.Focused and input.KeyCode == Enum.KeyCode.Backspace then
            self.Text = self.Text:sub(1, -2)
            self:UpdateText()
        end
    end)
    
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if self.Focused and input.KeyCode ~= Enum.KeyCode.Backspace and input.KeyCode ~= Enum.KeyCode.Return then
            if input.KeyCode == Enum.KeyCode.Space then
                self.Text = self.Text .. " "
            else
                local char = self:KeyCodeToChar(input.KeyCode)
                if char then
                    self.Text = self.Text .. char
                end
            end
            self:UpdateText()
        end
    end)
end

function FrostsUI.Textbox:IsMouseOver()
    local mouse = game:GetService("UserInputService"):GetMouseLocation()
    return mouse.X >= self.AbsolutePosition.X and mouse.X <= self.AbsolutePosition.X + self.Size.X and
           mouse.Y >= self.AbsolutePosition.Y and mouse.Y <= self.AbsolutePosition.Y + self.Size.Y
end

function FrostsUI.Textbox:Focus()
    if not self.Focused then
        self.Focused = true
        self.Cursor.Visible = true
        if self.Text == "" then
            self.TextObject.Text = ""
            self.TextObject.Color = FrostsUI.Colors.Text
        end
        self.Border.Color = FrostsUI.Colors.Primary
    end
end

function FrostsUI.Textbox:Unfocus()
    if self.Focused then
        self.Focused = false
        self.Cursor.Visible = false
        if self.Text == "" then
            self.TextObject.Text = self.Placeholder
            self.TextObject.Color = Color3.fromRGB(150, 150, 150)
        end
        self.Border.Color = FrostsUI.Colors.Border
    end
end

function FrostsUI.Textbox:UpdateText()
    self.TextObject.Text = self.Text
    self.Cursor.From = self.AbsolutePosition + Vector2.new(5 + self.TextObject.TextBounds.X, 10)
    self.Cursor.To = self.AbsolutePosition + Vector2.new(5 + self.TextObject.TextBounds.X, self.Size.Y - 10)
end

function FrostsUI.Textbox:KeyCodeToChar(keyCode)
    local shift = game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) or 
                  game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.RightShift)
    
    local keyMap = {
        [Enum.KeyCode.A] = shift and "A" or "a",
        [Enum.KeyCode.B] = shift and "B" or "b",
        [Enum.KeyCode.C] = shift and "C" or "c",
        [Enum.KeyCode.D] = shift and "D" or "d",
        [Enum.KeyCode.E] = shift and "E" or "e",
        [Enum.KeyCode.F] = shift and "F" or "f",
        [Enum.KeyCode.G] = shift and "G" or "g",
        [Enum.KeyCode.H] = shift and "H" or "h",
        [Enum.KeyCode.I] = shift and "I" or "i",
        [Enum.KeyCode.J] = shift and "J" or "j",
        [Enum.KeyCode.K] = shift and "K" or "k",
        [Enum.KeyCode.L] = shift and "L" or "l",
        [Enum.KeyCode.M] = shift and "M" or "m",
        [Enum.KeyCode.N] = shift and "N" or "n",
        [Enum.KeyCode.O] = shift and "O" or "o",
        [Enum.KeyCode.P] = shift and "P" or "p",
        [Enum.KeyCode.Q] = shift and "Q" or "q",
        [Enum.KeyCode.R] = shift and "R" or "r",
        [Enum.KeyCode.S] = shift and "S" or "s",
        [Enum.KeyCode.T] = shift and "T" or "t",
        [Enum.KeyCode.U] = shift and "U" or "u",
        [Enum.KeyCode.V] = shift and "V" or "v",
        [Enum.KeyCode.W] = shift and "W" or "w",
        [Enum.KeyCode.X] = shift and "X" or "x",
        [Enum.KeyCode.Y] = shift and "Y" or "y",
        [Enum.KeyCode.Z] = shift and "Z" or "z",
        [Enum.KeyCode.Zero] = shift and ")" or "0",
        [Enum.KeyCode.One] = shift and "!" or "1",
        [Enum.KeyCode.Two] = shift and "@" or "2",
        [Enum.KeyCode.Three] = shift and "#" or "3",
        [Enum.KeyCode.Four] = shift and "$" or "4",
        [Enum.KeyCode.Five] = shift and "%" or "5",
        [Enum.KeyCode.Six] = shift and "^" or "6",
        [Enum.KeyCode.Seven] = shift and "&" or "7",
        [Enum.KeyCode.Eight] = shift and "*" or "8",
        [Enum.KeyCode.Nine] = shift and "(" or "9",
        [Enum.KeyCode.Period] = shift and ">" or ".",
        [Enum.KeyCode.Comma] = shift and "<" or ",",
        [Enum.KeyCode.Semicolon] = shift and ":" or ";",
        [Enum.KeyCode.Quote] = shift and '"' or "'",
        [Enum.KeyCode.LeftBracket] = shift and "{" or "[",
        [Enum.KeyCode.RightBracket] = shift and "}" or "]",
        [Enum.KeyCode.Slash] = shift and "?" or "/",
        [Enum.KeyCode.Backslash] = shift and "|" or "\\",
        [Enum.KeyCode.Minus] = shift and "_" or "-",
        [Enum.KeyCode.Equals] = shift and "+" or "=",
        [Enum.KeyCode.Tilde] = shift and "~" or "`"
    }
    
    return keyMap[keyCode]
end

function FrostsUI.Textbox:SetText(text)
    self.Text = text
    self:UpdateText()
    self.TextObject.Color = FrostsUI.Colors.Text
end

function FrostsUI.Textbox:SetVisible(visible)
    self.Visible = visible
    self.Background.Visible = visible
    self.Border.Visible = visible
    self.TextObject.Visible = visible
    self.Cursor.Visible = visible and self.Focused
end

function FrostsUI.Textbox:UpdatePosition()
    self.AbsolutePosition = self.Window.Position + self.Position
    self.Background.Position = self.AbsolutePosition
    self.Border.Position = self.AbsolutePosition
    self.TextObject.Position = self.AbsolutePosition + Vector2.new(5, 8)
    self:UpdateText()
end

function FrostsUI.Textbox:Destroy()
    self.Background:Remove()
    self.Border:Remove()
    self.TextObject:Remove()
    self.Cursor:Remove()
end

-- Utility Functions
function FrostsUI.CreateExampleUI()
    local window = FrostsUI.Window.new("FrostsUI Example", Vector2.new(100, 100), Vector2.new(400, 500))
    
    -- Title label
    FrostsUI.Label.new(window, Vector2.new(20, 50), "Welcome to FrostsUI!", 18)
    FrostsUI.Label.new(window, Vector2.new(20, 80), "A complete UI library for LuaU", 12)
    
    -- Slider
    local slider = FrostsUI.Slider.new(window, Vector2.new(20, 120), 300, 0, 100, 50, "Volume", function(value)
        print("Volume set to:", value)
    end)
    
    -- Checkbox
    FrostsUI.Checkbox.new(window, Vector2.new(20, 170), "Enable Sound", true, function(checked)
        print("Sound enabled:", checked)
    end)
    
    FrostsUI.Checkbox.new(window, Vector2.new(20, 200), "Show FPS", false, function(checked)
        print("Show FPS:", checked)
    end)
    
    -- Textbox
    FrostsUI.Textbox.new(window, Vector2.new(20, 240), Vector2.new(200, 30), "Enter your name...", function(text)
        print("Name entered:", text)
    end)
    
    -- Buttons
    FrostsUI.Button.new(window, Vector2.new(20, 290), Vector2.new(120, 35), "Apply", function()
        print("Settings applied!")
    end)
    
    FrostsUI.Button.new(window, Vector2.new(160, 290), Vector2.new(120, 35), "Cancel", function()
        window:Destroy()
    end)
    
    -- Status label
    local statusLabel = FrostsUI.Label.new(window, Vector2.new(20, 340), "Status: Ready", 12)
    
    -- Info button with custom color
    local infoBtn = FrostsUI.Button.new(window, Vector2.new(20, 380), Vector2.new(100, 30), "Info", function()
        statusLabel:SetText("Status: Info button clicked!")
    end)
    infoBtn:SetColor(FrostsUI.Colors.Info)
    
    -- Warning button
    local warnBtn = FrostsUI.Button.new(window, Vector2.new(140, 380), Vector2.new(100, 30), "Warning", function()
        statusLabel:SetText("Status: Warning button clicked!")
    end)
    warnBtn:SetColor(FrostsUI.Colors.Warning)
    
    -- Success button
    local successBtn = FrostsUI.Button.new(window, Vector2.new(260, 380), Vector2.new(100, 30), "Success", function()
        statusLabel:SetText("Status: Success button clicked!")
    end)
    successBtn:SetColor(FrostsUI.Colors.Success)
    
    return window
end

-- Create a simple function to quickly create UIs
function FrostsUI.CreateWindow(title, width, height)
    local centerX = (workspace.CurrentCamera.ViewportSize.X - width) / 2
    local centerY = (workspace.CurrentCamera.ViewportSize.Y - height) / 2
    return FrostsUI.Window.new(title, Vector2.new(centerX, centerY), Vector2.new(width, height))
end

return FrostsUI
