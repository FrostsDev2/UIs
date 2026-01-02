local lib = ui:create("numlock test ui",{
    theme = "frappe",
    size = Vector2.new(600,400)
})

local tab1 = lib:tab("visuals")
local tab2 = lib:tab("options")

local settings = tab2:section("ui settings",false)
local settings2 = settings:addsection("extras")

settings2:addbutton{
    Name = "Destroy UI",
    Callback = function()
        lib.running = false
    end
}

settings:addkeybind{
    Name = "Toggle UI",
    Changed = function(v)
        lib.closebind = v
    end,
    Default = lib.closebind
}

settings:adddropdown{
    Name = "Theme",
    Options = lib.themenames,
    Default = lib.theme,
    Callback = function(selected)
        lib:changeTheme(selected:lower())
    end
}

local visuals = tab1:section("visuals",false)
local vis2 = visuals:addsection("fancy stuff")

visuals:addtoggle{
    Name = "Enabled",
    Callback = function(v)
        print(v)
    end
}

visuals:addslider{
    Name = "Test Slider",
    Callback = function(v)
        print(v)
    end,
    Max = 200,
    Step = 5,
    Minimum = 30,
}

vis2:adddropdown{
    Name = "Shape",
    Options = {"triangle","cube","circle","octogon"},
    Callback = function(v)
        print(v)
    end,
}

while lib.running do
    lib:step()
end
