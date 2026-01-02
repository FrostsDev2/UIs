--// library made by @typicaalusername
--// this is most likely not going to be maintained unless bugs are found
--// this was lazily made. thanks.

--[[

    Give me liberty or give me slop!
        - TypicaalUsername

    Here's some ultra scary documentation...

    To start off:

    local main = ui:create(string,{
        theme = "frappe", --// just a starter theme (i personally recommend it)
        size = Vector2.new(600,400) --// change to wtv u want but i havent tested everything so expect like random issues lol
    })

    main:changeTheme(string) --// u can add custom themes via the themes table in the code but you need the specific colors used in the code.

    main.customtransparency = 1 --// this can be used but beware itll result in random graphical glitches with the gradients.

    Oh my god! Tabs!

    local tab = lib:tab(name)

    local section = tab:section(name,false) --// the false argument results in the section being on the left. make it true for the section to be on the right.
    
    --// ^ fun fact about this is that you can actually add sections to that section!
    local subsection = section:addsection(name)

    Then the garbage...

    section:addbutton{
        Name = string,
        Callback = function()
            --// put whatever
        end
    }

    section:addkeybind{
        Name = string,
        Changed = function(v)
            --// this is what fires when the keybind is changed. not the same as it being pressed.
        end,
        Callback = function()
            --// this is what fires when the selected keybind is hit. doesnt need to be used, just here for easy keybinds lol
        end,
        Default = string
    }

    section:adddropdown{
        Name = string,
        Options = table,
        Default = string, --// defaults to the first member of the table btw
        Callback = function(selected)
            --// self explanatory
        end
    }
    
    section:addtoggle{
        Name = string,
        Callback = function(v)
            --// again self explanatory
        end
    }

    section:addslider{
        Name = string,
        Callback = function(v)
            --// ditto
        end,
        Max = int,
        Step = int,
        Minimum = int,
    }
    
    i think thats all you need but i dont know
    im lazy.

    btw put this at the bottom of ur script or it like wont work lol

    while lib.running do
        lib:step()
    end
    lib:Destroy()

    lib being the variable for ur created ui frame
]]

local ui = {}
do
    ui.__index = ui

    local plrs = game.Players
    local plr = plrs.LocalPlayer
    local mouse = plr:GetMouse()

    local clock = os.clock
    local rgb = Color3.fromRGB
    local v2 = Vector2.new

    local catppuccin = {
        mocha = {
            crust = rgb(17, 17, 27),
            mantle = rgb(24, 24, 37),
            base = rgb(30, 30, 46),
            surface0 = rgb(49, 50, 68),
            surface1 = rgb(69, 71, 90),
            surface2 = rgb(88, 91, 112),
            overlay0 = rgb(108, 112, 134),
            overlay1 = rgb(127, 132, 156),
            overlay2 = rgb(147, 153, 178),
            subtext0 = rgb(166, 173, 200),
            subtext1 = rgb(186, 194, 222),
            text = rgb(205, 214, 244),

            rosewater = rgb(245, 224, 220),
            flamingo = rgb(242, 205, 205),
            pink = rgb(245, 194, 231),
            mauve = rgb(203, 166, 247),
            red = rgb(243, 139, 168),
            maroon = rgb(235, 160, 172),
            peach = rgb(250, 179, 135),
            yellow = rgb(249, 226, 175),
            green = rgb(166, 227, 161),
            teal = rgb(148, 226, 213),
            sky = rgb(137, 220, 235),
            sapphire = rgb(116, 199, 236),
            blue = rgb(137, 180, 250),
            lavender = rgb(180, 190, 254),
            overlay = rgb(108, 112, 134),
        },

        latte = {
            crust = rgb(220, 224, 232),
            mantle = rgb(230, 233, 239),
            base = rgb(239, 241, 245),
            surface0 = rgb(204, 208, 218),
            surface1 = rgb(188, 192, 204),
            surface2 = rgb(172, 176, 190),
            overlay0 = rgb(156, 160, 176),
            overlay1 = rgb(140, 143, 161),
            overlay2 = rgb(124, 127, 147),
            subtext0 = rgb(108, 111, 133),
            subtext1 = rgb(92, 95, 119),
            text = rgb(76, 79, 105),

            rosewater = rgb(220, 138, 120),
            flamingo = rgb(221, 120, 120),
            pink = rgb(234, 118, 203),
            mauve = rgb(136, 57, 239),
            red = rgb(210, 15, 57),
            maroon = rgb(230, 69, 83),
            peach = rgb(254, 100, 11),
            yellow = rgb(223, 142, 29),
            green = rgb(64, 160, 43),
            teal = rgb(23, 146, 153),
            sky = rgb(4, 165, 229),
            sapphire = rgb(32, 159, 181),
            blue = rgb(30, 102, 245),
            lavender = rgb(114, 135, 253),
            overlay = rgb(156, 160, 176),
        },

        macchiato = {
            crust = rgb(24, 25, 38),
            mantle = rgb(30, 32, 48),
            base = rgb(36, 39, 58),
            surface0 = rgb(54, 58, 79),
            surface1 = rgb(73, 77, 100),
            surface2 = rgb(91, 96, 120),
            overlay0 = rgb(110, 115, 141),
            overlay1 = rgb(128, 135, 162),
            overlay2 = rgb(147, 154, 183),
            subtext0 = rgb(165, 173, 206),
            subtext1 = rgb(184, 192, 224),
            text = rgb(202, 211, 245),

            rosewater = rgb(244, 219, 214),
            flamingo = rgb(240, 198, 198),
            pink = rgb(245, 189, 230),
            mauve = rgb(198, 160, 246),
            red = rgb(237, 135, 150),
            maroon = rgb(238, 153, 160),
            peach = rgb(245, 169, 127),
            yellow = rgb(238, 212, 159),
            green = rgb(166, 218, 149),
            teal = rgb(139, 213, 202),
            sky = rgb(145, 215, 227),
            sapphire = rgb(125, 196, 228),
            blue = rgb(138, 173, 244),
            lavender = rgb(183, 189, 248),
            overlay = rgb(110, 115, 141),
        },

        frappe = {
            crust = rgb(35, 38, 52),
            mantle = rgb(41, 44, 60),
            base = rgb(48, 52, 70),
            surface0 = rgb(65, 69, 89),
            surface1 = rgb(81, 87, 109),
            surface2 = rgb(98, 104, 128),
            overlay0 = rgb(115, 121, 148),
            overlay1 = rgb(131, 138, 167),
            overlay2 = rgb(148, 156, 187),
            subtext0 = rgb(165, 173, 206),
            subtext1 = rgb(198, 208, 245),
            text = rgb(202, 211, 245),

            rosewater = rgb(242, 213, 207),
            flamingo = rgb(238, 190, 190),
            pink = rgb(244, 184, 228),
            mauve = rgb(202, 158, 230),
            red = rgb(231, 130, 132),
            maroon = rgb(234, 153, 156),
            peach = rgb(239, 159, 118),
            yellow = rgb(229, 200, 144),
            green = rgb(166, 209, 137),
            teal = rgb(129, 200, 190),
            sky = rgb(153, 209, 219),
            sapphire = rgb(133, 193, 220),
            blue = rgb(140, 170, 238),
            lavender = rgb(186, 187, 241),
            overlay = rgb(115, 121, 148),
        },
    }

    local function mp()
        return v2(mouse.X, mouse.Y)
    end

    local function mousebound(pos,size)
        local m = mp()
        return m.x >= pos.x and m.x <= (pos.x + size.x) and m.y >= pos.y and m.y <= (pos.y + size.y)
    end

    local function change(inst, tab)
        if typeof(inst) == "table" and #inst > 1 then
            for i_, v_ in inst do
                for i, v in tab do
                    v_[i] = v
                end
            end
        else
            for i, v in tab do
                inst[i] = v
            end
        end
    end

    local function create(drawing, properties)
        local d = Drawing.new(drawing)
        change(d, properties)
        return d
    end

    local function lerp(a, b, t)
        return a + (b - a) * t
    end

    local function getLerp(lerp,delta)
        return 1 - (0.5 ^ (delta * lerp * 60))
    end

    local function lerpRGB(c1, c2, t)
        local success,result = pcall(function()
            return rgb(
                math.floor(lerp(c1.R * 255, c2.R * 255, t)),
                math.floor(lerp(c1.G * 255, c2.G * 255, t)),
                math.floor(lerp(c1.B * 255, c2.B * 255, t))
            )
        end)
        if success then return result end
        if not success then return c1 end
    end

    local function textbound(str)
        return #str * 7, 7
    end

    local function centertext(str, position, size)
        local x,y = textbound(str)
        return v2(
            position.X + (size.X - x) / 2,
            position.Y + (size.Y - y*1.5) / 2
        )
    end

    local function createGradient(frameRect, colorStart, colorEnd, breaks)
        local colorStart = colorStart
        local colorEnd = colorEnd
        local bands = {}

        if not frameRect.Position then frameRect.Position = v2() end
        if not frameRect.Size then frameRect.Size = v2() end

        local breakHeight = frameRect.Size.Y / breaks

        for i = 0, breaks - 1 do
            local t = i / (breaks - 1)
            local color = lerpRGB(colorStart, colorEnd, t)

            local rect = Drawing.new("Square")
            rect.Filled = true
            rect.Color = color
            rect.Size = Vector2.new(frameRect.Size.X, breakHeight + 1)
            rect.Position = Vector2.new(frameRect.Position.X, frameRect.Position.Y + (i * breakHeight))
            table.insert(bands, rect)
        end

        return setmetatable({
            Remove = function()
                for i,v in bands do v:Remove() end
            end,
            ChangeColor = function(cs,ce)
                colorStart = cs
                colorEnd = ce

                for i,v in bands do
                    local t = i / (breaks - 1)
                    local color = lerpRGB(colorStart, colorEnd, t)

                    v.Color = color
                end
            end
        },{
            __index = function(_self,index)
                if index == "Size" then return frameRect.Size end
                return bands[1][index]
            end,
            __newindex = function(_self,index,val)
                for i,v in bands do
                    if index == "Size" then
                        frameRect.Size = val
                        breakHeight = frameRect.Size.Y / breaks
                        v.Size = v2(val.X, breakHeight+1)
                        v.Position = v2(frameRect.Position.X, frameRect.Position.Y + (i * breakHeight))
                    elseif index == "Position" then
                        frameRect.Position = val
                        v.Position = v2(frameRect.Position.X, frameRect.Position.Y + (i * breakHeight))
                    elseif index ~= "Color" then
                        v[index] = val
                    end
                end
            end
        })
    end

    local function createOutline(v, color, zindex)
        local out = Drawing.new("Square")
        change(out, {
            Position = v.Position + Vector2.new(1, 1),
            Size = v.Size + Vector2.new(-2,-2),
            Filled = true,
            Color = color or rgb(148, 156, 187),
            ZIndex = zindex or -1
        })
        return out
    end

    function ui:create(title,settings)
        local self = setmetatable({}, ui)
        local settings = settings or {}

        self.keys = {
            delete = { mem = 0x2E },
            minus = { mem = 0xBD },
            mouse1 = { mem = 0x01 },
            mouse2 = { mem = 0x02 },
            mouse3 = { mem = 0x04 },
            leftshift = { mem = 0xA0 },
            ["0"] = { mem = 0x30 },
            ["1"] = { mem = 0x31 },
            ["2"] = { mem = 0x32 },
            ["3"] = { mem = 0x33 },
            ["4"] = { mem = 0x34 },
            ["5"] = { mem = 0x35 },
            ["6"] = { mem = 0x36 },
            ["7"] = { mem = 0x37 },
            ["8"] = { mem = 0x38 },
            ["9"] = { mem = 0x39 },
            a = { mem = 0x41 },
            b = { mem = 0x42 },
            c = { mem = 0x43 },
            d = { mem = 0x44 },
            e = { mem = 0x45 },
            f = { mem = 0x46 },
            g = { mem = 0x47 },
            h = { mem = 0x48 },
            i = { mem = 0x49 },
            j = { mem = 0x4A },
            k = { mem = 0x4B },
            l = { mem = 0x4C },
            m = { mem = 0x4D },
            n = { mem = 0x4E },
            o = { mem = 0x4F },
            p = { mem = 0x50 },
            q = { mem = 0x51 },
            r = { mem = 0x52 },
            s = { mem = 0x53 },
            t = { mem = 0x54 },
            u = { mem = 0x55 },
            v = { mem = 0x56 },
            w = { mem = 0x57 },
            x = { mem = 0x58 },
            y = { mem = 0x59 },
            z = { mem = 0x5A },
            tab = { mem = 0x09 },
            backspace = { mem = 0x08 },
            numpad0 = { mem = 0x60 },
            numpad1 = { mem = 0x61 },
            numpad2 = { mem = 0x62 },
            numpad3 = { mem = 0x63 },
            numpad4 = { mem = 0x64 },
            numpad5 = { mem = 0x65 },
            numpad6 = { mem = 0x66 },
            numpad7 = { mem = 0x67 },
            numpad8 = { mem = 0x68 },
            numpad9 = { mem = 0x69 },
            multiply = { mem = 0x6A },
            add = { mem = 0x6B },
            separator = { mem = 0x6C },
            subtract = { mem = 0x6D },
            decimal = { mem = 0x6E },
            divide = { mem = 0x6F },
            f1 = { mem = 0x70 },
            f2 = { mem = 0x71 },
            f3 = { mem = 0x72 },
            f4 = { mem = 0x73 },
            f5 = { mem = 0x74 },
            f6 = { mem = 0x75 },
            f7 = { mem = 0x76 },
            f8 = { mem = 0x77 },
            f9 = { mem = 0x78 },
            f10 = { mem = 0x79 },
            f11 = { mem = 0x7A },
            f12 = { mem = 0x7B },
            f13 = { mem = 0x7C },
            f14 = { mem = 0x7D },
            f15 = { mem = 0x7E },
            f16 = { mem = 0x7F },
            f17 = { mem = 0x80 },
            f18 = { mem = 0x81 },
            f19 = { mem = 0x82 },
            f20 = { mem = 0x83 },
            f21 = { mem = 0x84 },
            f22 = { mem = 0x85 },
            f23 = { mem = 0x86 },
            f24 = { mem = 0x87 },
            numlock = { mem = 0x90 },
            lcontrol = { mem = 0xA2 },
            rcontrol = { mem = 0xA3 },
            leftalt = { mem = 0xA4 }, -- left menu
            rightalt = { mem = 0xA5 }, -- right menu
            rshift = { mem = 0xA1 },
        }

        for i, v in self.keys do
            v.click = false
            v.hold = false
        end

        self.w = 500
        self.h = 700

        if settings.size then
            self.w = settings.size.X
            self.h = settings.size.Y
        end

        local middle = (workspace.CurrentCamera.ViewportSize*.5) - (v2(self.w,self.h)*.5)
        self.x = middle.X
        self.y = middle.Y

        self.name = title or "n/a"
        self.padding = 3
        self.th = 25
        self.taboffset = 45

        self.tabs = {}
        self.currenttab = 1

        self.closebind = "minus"

        self.transparency = 0
        self.open = true
        self.running = true

        self.border = 4 --// mainly looks better with numbers divisible by two (for obvious reasons)

        self.colors = catppuccin[settings.theme] or catppuccin.latte

        self._last = clock()
        self._draggable = false

        local main = create("Square", {Filled = true, Color = self.colors.base})
        local main_outline = createOutline(main,self.colors.crust,-1)

        local mantle = create("Square",{Filled = true, Color = self.colors.mantle})
        local text = create("Text", {Text = self.name, Color = self.colors.text,ZIndex = 3, Outline = false})
        local gradient = createGradient({Position = v2(self.x,self.y), Size = v2(self.w,self.th)}, self.colors.base,self.colors.surface0,25)
        local gradient_outline = create("Line",{
            ZIndex = 1,
            Thickness = 2,
        })

        gradient.ZIndex = 2

        self._dcache = {main,main_outline,mantle,text,gradient,gradient_outline}

        self.theme = settings.theme
        self.themenames = {}
        for i,v in catppuccin do
            table.insert(self.themenames,i )
        end

        return self
    end

    function ui:changeTheme(name)
        self.theme = name

        local colors = catppuccin[name]
        self.colors = colors
        for i,v in self.tabs do
            v.button.ChangeColor(colors.base,colors.crust)

            for index,section in v .sections do
                for num, sub in section.sections do
                    for i, item in sub.elements do
                        if item.class == "toggle" then
                            item.togglebutton.ChangeColor(colors.mantle,colors.crust)
                        elseif item.class == "keybind" then
                            item.button.ChangeColor(colors.mantle,colors.crust)
                            item.outline.Color = colors.crust
                            change({item.text,item.statetext},{
                                Color = colors.text
                            })
                        elseif item.class == "dropdown" then
                            item.button.ChangeColor(colors.mantle,colors.crust)
                            item.buttonoutline.Color = colors.crust
                            item.labeltext.Color = colors.text
                            item.valuetext.Color = colors.subtext1
                            item.arrow.Color = colors.subtext1
                            item.optionsContainer.Color = colors.mantle
                            item.optionsOutline.Color = self.colors.crust
                        end
                    end
                end
            end
        end

        self._dcache[1].Color = colors.base
        self._dcache[2].Color = colors.crust
        self._dcache[3].Color = colors.mantle
        self._dcache[4].Color = colors.text
        self._dcache[5].ChangeColor(self.colors.base,self.colors.surface0)
        self._dcache[6].Color = colors.crust
    end

    local lastRefresh = clock()
    function ui:step()
        --if clock() - lastRefresh <= 1/60 then return end
        -- ^ this function goes unused due to tab tragging being weird (i dont want to fix it)
        lastRefresh = clock()

        local delta = clock() - self._last
        self._last = clock()

        local m = mp()

        setrobloxinput(not self.open)

        for i, v in self.keys do
            local keydown = iskeypressed(v.mem)
            if keydown then
                if not v.hold and not v.click then
                    v.click = true
                else
                    v.click = false
                end

                v.hold = true
            else
                v.hold = false
            end
        end

        if self.keys[self.closebind].click then self.open = not self.open end

        if not self.open then self.keys.mouse1.click = false self.keys.mouse1.hold = false end

        local function fetchtrans(transparency)
            return lerp(transparency,self.transparency,getLerp(.35,delta))
        end

        local _drawings = self._dcache
        local _colors = self.colors

        --self.taboffset = (#self.tabs<1 and 2.5 or 25)

        local _main = _drawings[1]
        local _mainoutline = _drawings[2]
        local _mantle = _drawings[3]
        local _text = _drawings[4]
        local _gradient = _drawings[5]
        local _gradientout = _drawings[6]

        change(_main,{
            Position = v2(self.x,self.y),
            Size = v2(self.w,self.h)
        })

        change(_mainoutline,{
            Position = v2(self.x,self.y)-(v2(.5,.5)*self.border),
            Size = v2(self.w+self.border,self.h+self.border)
        })

        change(_text,{
            Position = v2(self.x+5, self.y+self.th/2-5)
        })

        change(_mantle,{
            Position = v2(self.x+self.padding/2, self.y+(self.th+self.taboffset)+self.padding/2),
            Size = v2(self.w-self.padding,self.h-(self.th+self.taboffset)-self.padding)
        })

        change(_gradient,{Position = v2(self.x,self.y), Size = v2(self.w,self.th)})
        change(_gradientout,{
            From = v2(self.x,self.y+self.th+_gradientout.Thickness),
            To = v2(self.x+self.w,self.y+self.th+_gradientout.Thickness),
            Color = _colors.crust
        })

        for i,v in _drawings do
            v.Transparency = fetchtrans(v.Transparency)
        end

        self.transparency = self.open and (self.customtransparency or 1) or 0

        if mousebound(_main.Position,v2(self.w,self.th)) and self.open then
            if self.keys.mouse1.click then
                self._dragging = true
                self._dragoffset = m - v2(self.x,self.y)
            end
        end

        if self._dragging then
            if self.keys.mouse1.hold then
                self.x = m.x - self._dragoffset.x
                self.y = m.y - self._dragoffset.y
            else
                self._dragging = false
            end

            self.keys.mouse1.click = false
        end

        local tabWidth = (self.w - (self.padding * (#self.tabs + 1))) / math.max(#self.tabs, 1)
        local tabHeight = self.taboffset - self.padding

        for i, tab in self.tabs do
            local tabX = self.x+self.padding+(i - 1)*(tabWidth + self.padding)
            local tabY = self.y+self.th+self.padding+1

            change(tab.button, {
                Position = v2(tabX, tabY),
                Size = v2(tabWidth, tabHeight-self.padding*2),
                Transparency = fetchtrans(tab.button.Transparency),
                ZIndex = 2
            })

            change(tab.buttonoutline, {
                Position = tab.button.Position - v2(1, 1),
                Size = tab.button.Size + v2(2,3),
                Transparency = fetchtrans(tab.button.Transparency),
                Color = _colors.crust
            })

            if mousebound(tab.button.Position,tab.button.Size) and self.keys.mouse1.click then
                self.currenttab = i
            end

            change(tab.text, {
                Position = v2(tabX + 5, tabY + (tabHeight / 2) - 6),
                Transparency = fetchtrans(tab.text.Transparency),
                Color = (self.currenttab == i and _colors.text or _colors.subtext1)
            })

            if self.currenttab == i then
                setvisible(tab.sections,true)
                tab.button.ChangeColor(_colors.base,_colors.overlay)

                for index,section in tab.sections do
                    for i,v in section._dcache do
                        v.Transparency = fetchtrans(v.Transparency)
                    end

                    local section_container = section.section_container
                    local height = section.height
                    height = _mantle.Size.Y/(tab.side[section.side])--height == "half" and _mantle.Size.Y/2 or height == "third" and _mantle.Size.Y/3 or height == "whole" and _mantle.Size.Y or height
                    local width = _mantle.Size.X/2 - self.padding*2

                    change(section_container,{
                        Position = v2(self.padding+_mantle.Position.X+(section.side == "left" and 0 or width+self.padding*2),(self.padding+_mantle.Position.Y)+(section.sideindex*height)),
                        Size = v2(width,height-self.padding*2),
                        Color = _colors.base
                    })

                    change(section.section_outline,{
                        Position = section_container.Position - v2(1, 1),
                        Size = section_container.Size + v2(2,2),
                        Color = _colors.crust
                    })

                    change(section.buttonbg,{
                        Position = section_container.Position,
                        Size = v2(section_container.Size.X, 20),
                        Color = _colors.crust
                    })

                    for num, sub in section.sections do
                        local section_items = sub.elements
                        local selected = section.index == num

                        local itemStartPosition = (section_container.Position.Y+section.buttonbg.Size.Y+self.padding/2)+1

                        for _, item in section_items do
                            if not selected then
                                item.ignoreVisible = true
                                for i,v in item._dcache do
                                    v.Visible = false
                                end
                                continue
                            else
                                item.ignoreVisible = false
                            end

                            local type = item.class
                            local callback = item.callback
                            local drawings = item._dcache
                            local value  =  item.value
                            local containerSize = section_container.Size
                            local containerPos = section_container.Position

                            if type == "button" then
                                local buttonbase = item.buttonbase
                                local text = item.text
                                local buttonoutline = item.buttonoutline

                                local height = item.height
                                local buttonWidth = containerSize.X - self.padding * 2
                                
                                change(buttonbase, {
                                    Size = v2(buttonWidth-self.padding, height),
                                    Position = v2(containerPos.X + self.padding + 1, itemStartPosition),
                                    Transparency = fetchtrans(buttonbase.Transparency)
                                })
                                buttonbase.ChangeColor(self.colors.mantle,self.colors.crust)
                                change(text,{
                                    Position = centertext(text.Text,buttonbase.Position,buttonbase.Size),
                                    Transparency = fetchtrans(text.Transparency),
                                    Color = _colors.text
                                })

                                change(buttonoutline, {
                                    Position = buttonbase.Position - v2(1, 1),
                                    Size = buttonbase.Size + v2(2, 3),
                                    Transparency = fetchtrans(buttonoutline.Transparency),
                                    Color = _colors.crust
                                })

                                if mousebound(buttonbase.Position,buttonbase.Size) and self.keys.mouse1.click then
                                    item.callback()
                                end

                                itemStartPosition+=(item.height+self.padding*2)
                            elseif type == "toggle" then
                                local togglebutton = item.togglebutton
                                local outline = item.toggleoutline
                                local text = item.text

                                local height = item.height

                                change(togglebutton,{
                                    Size = v2(height,height),
                                    Position = v2(containerPos.X+self.padding+1, itemStartPosition),
                                    Transparency = fetchtrans(togglebutton.Transparency)
                                })
                                
                             	change(outline,{
                                    Position = togglebutton.Position - v2(1, 1),
                                    Size = togglebutton.Size + v2(2,3),
                                    Transparency = fetchtrans(outline.Transparency),
                                    Color = _colors.crust
                                })
                                change(text, {
                                    Position = v2(togglebutton.Position.X+height+self.padding*2, centertext(text.Text,togglebutton.Position,togglebutton.Size).Y),
                                    Transparency = fetchtrans(text.Transparency),
                                    Color = _colors.text
                                })

                                if mousebound(togglebutton.Position,togglebutton.Size) and self.keys.mouse1.click then
                                    item.state = not item.state
                                    item.callback(item.state)
                                end
                                
                                if item.state then
                                    togglebutton.ChangeColor(self.colors.teal,self.colors.sapphire)
                                else
                                    togglebutton.ChangeColor(self.colors.mantle,self.colors.crust)
                                end

                                itemStartPosition+=(height+self.padding*2)
                            elseif type == "keybind" then
                                local button = item.button
                                local outline = item.outline
                                local text = item.text
                                local statetext = item.statetext

                                local height = item.height

                                change(button,{
                                    Size = v2(height+(textbound(item.state)),height),
                                    Position = v2(containerPos.X+self.padding+1, itemStartPosition),
                                    Transparency = fetchtrans(button.Transparency)
                                })
                             	change(outline,{
                                    Position = button.Position - v2(1, 1),
                                    Size = button.Size + v2(2,3),
                                    Transparency = fetchtrans(outline.Transparency)
                                })
                                change(text, {
                                    Position = v2(button.Position.X+button.Size.X+self.padding*2, centertext(text.Text,button.Position,button.Size).Y),
                                    Transparency = fetchtrans(text.Transparency),
                                })
                                change(statetext, {
                                    Position = centertext(statetext.Text,button.Position,button.Size),
                                    Transparency = fetchtrans(statetext.Transparency),
                                    Text = (item.waiting and "..." or item.state)
                                })

                                if mousebound(button.Position,button.Size) then
                                    if self.keys.mouse1.click then
                                        self.keys.mouse1.click = false --// Stop automatically picking me!!!
                                        item.waiting = true
                                    end
                                end

                                if item.waiting then
                                    for key,variable in self.keys do
                                        if variable.click then
                                            item.state = key
                                            item.waiting = false
                                            variable.click = false

                                            item.onset(item.state)
                                        end
                                    end
                                else
                                    if self.keys[item.state] and self.keys[item.state].click then
                                        item.callback()
                                    end
                                end
                                
                                itemStartPosition+=(height+self.padding*2)
                            elseif type == "dropdown" then
                                local button = item.button
                                local outline = item.buttonoutline
                                local labeltext = item.labeltext
                                local valuetext = item.valuetext
                                local arrow = item.arrow
                                
                                local height = item.height
                                local buttonWidth = containerSize.X - self.padding * 2
                                
                                change(button, {
                                    Size = v2(buttonWidth-self.padding, height),
                                    Position = v2(containerPos.X + self.padding + 1, itemStartPosition),
                                    Transparency = fetchtrans(button.Transparency)
                                })
                                
                                change(outline, {
                                    Position = button.Position - v2(1, 1),
                                    Size = button.Size + v2(2, 3),
                                    Transparency = fetchtrans(outline.Transparency)
                                })
                                
                                change(labeltext, {
                                    Position = v2(button.Position.X + 5, centertext(labeltext.Text, button.Position, button.Size).Y),
                                    Transparency = fetchtrans(labeltext.Transparency)
                                })
                                
                                local valueWidth = textbound(item.selected)
                                change(valuetext, {
                                    Text = item.selected,
                                    Position = v2(
                                        button.Position.X + button.Size.X - valueWidth - 15,
                                        centertext(valuetext.Text, button.Position, button.Size).Y
                                    ),
                                    Transparency = fetchtrans(valuetext.Transparency)
                                })
                                
                                change(arrow, {
                                    Text = item.open and "-" or "+",
                                    Position = v2(
                                        button.Position.X + button.Size.X - 10,
                                        centertext(arrow.Text, button.Position, button.Size).Y
                                    ),
                                    Transparency = fetchtrans(arrow.Transparency)
                                })

                                if mousebound(button.Position, button.Size) and self.keys.mouse1.click then
                                    item.open = not item.open
                                end

                                --// optionElements

                                if item.open then
                                    local optionHeight = 16
                                    local totalHeight = #item.options * optionHeight

                                    change(item.optionsContainer, {
                                        Position = v2(button.Position.X, button.Position.Y + height + 2),
                                        Size = v2(buttonWidth-self.padding, totalHeight+self.padding*2),
                                        Transparency = fetchtrans(item.optionsContainer.Transparency)
                                    })
                                    
                                    change(item.optionsOutline, {
                                        Position = item.optionsContainer.Position - v2(1, 1),
                                        Size = item.optionsContainer.Size + v2(2, 2),
                                        Transparency = fetchtrans(item.optionsOutline.Transparency)
                                    })

                                    for i,v in item.optionElements do
                                        local centered = centertext(v.Text,item.optionsContainer.Position,item.optionsContainer.Size)
                                        change(v,{
                                            Position = v2(centered.X, item.optionsContainer.Position.Y+(self.padding*2)+(optionHeight*(i-1))),
                                            Transparency = fetchtrans(v.Transparency),
                                            Color = _colors.text
                                        })

                                        if mousebound(v.Position, v2(item.optionsContainer.Size.X,optionHeight)) and self.keys.mouse1.click and item.selected ~= v.Text then
                                            item.selected = v.Text
                                            item.callback(item.selected)
                                        end
                                    end
                                else
                                    change(item.optionsContainer,{
                                        Transparency = 0,
                                    })
                                    change(item.optionsOutline,{
                                        Transparency = 0
                                    })

                                    for i,v in item.optionElements do
                                        change(v,{
                                            Transparency = 0
                                        })
                                    end
                                end

                                itemStartPosition+=(height+self.padding*2)
                            elseif type == "slider" then
                                local sliderbackground = item.sliderbackground
                                local slidetext = item.text
                                local slideoutline = item.slideroutline
                                local slideframe = item.slideframe

               					local height = item.height
                                local sliderwidth = containerSize.X - self.padding * 2

                                change(sliderbackground,{
                                    Size = v2(sliderwidth-self.padding, height),
                                    Position = v2(containerPos.X + self.padding + 1, itemStartPosition+1),
                                    Transparency = fetchtrans(sliderbackground.Transparency),
                                    Color = _colors.mantle
                                })

                                change(slideoutline,{
                                    Position = sliderbackground.Position - v2(1, 1),
                                    Size = sliderbackground.Size + v2(2,3),
                                    Transparency = fetchtrans(slideoutline.Transparency),
                                    Color = _colors.crust
                                })

                                local function truncate(num, dp)
                                    local mult = 10^(dp or 0)
                                    return math.floor(num * mult) / mult
                                end

                                local function countDecimalPlaces(num)
                                    local str = tostring(num)
                                    local decimal_pos = string.find(str, "%.")
                                    if decimal_pos then
                                        return #str - decimal_pos
                                    end
                                    return 0
                                end

                                if self.keys.mouse1.hold and mousebound(sliderbackground.Position,sliderbackground.Size) then
                                    local fraction = math.clamp((mouse.X - sliderbackground.Position.X), 0, sliderbackground.Size.X) / sliderbackground.Size.X
                                    local factor = math.floor((item.max - item.min) * fraction / item.step + 0.5)
                                    local oldval = item.value
                                    item.value = truncate(item.min + factor * item.step,countDecimalPlaces(item.step))
                                    if item.value ~= oldval then
                                        item.callback(item.value)
                                    end
                                end

                                change(slidetext,{
                                    Position = centertext(slidetext.Text,sliderbackground.Position,sliderbackground.Size),
                                    Transparency = fetchtrans(slidetext.Transparency),
                                    Color = _colors.text,
                                    ZIndex = 6,
                                    Text = item.name.." ("..tostring(item.value)..item.suffix..")"
                                })

                                local ratio = (item.value-item.min)/(item.max-item.min)
                                change(slideframe,{
                                    Size = v2((math.clamp(ratio*sliderbackground.Size.X-2, 0, sliderbackground.Size.X-2)), height-2),
                                    Position = v2(containerPos.X + self.padding + 2, itemStartPosition+1),
                                    Transparency = fetchtrans(slideframe.Transparency),
                                })

                                slideframe.ZIndex = 5

                                itemStartPosition+=(item.height+self.padding*2)
                            end
                        end

                        local sbuttonwidth = textbound(sub.name)*1.1
                        local offset = section.sections[num-1] and (section.sections[num-1].button.Position.X+section.sections[num-1].button.Size.X) or section_container.Position.X
                        change(sub.button,{
                            Position = v2(offset,section_container.Position.Y),
                            Size = v2(sbuttonwidth+3,section.buttonbg.Size.Y-2)
                        })

                        change({sub.button,sub.buttontext},{Visible = true, Transparency = fetchtrans(sub.button.Transparency)})

                        if section.index == num then
                            sub.button.ChangeColor(_colors.mantle,_colors.base)
                        else
                            sub.button.ChangeColor(_colors.mantle,_colors.crust)
                        end

                        change(sub.buttontext,{
                            Position = centertext(sub.name,sub.button.Position,sub.button.Size),
                            Color = _colors.text
                        })

                        if mousebound(sub.button.Position,sub.button.Size) and self.keys.mouse1.click then
                            section.index = num
                        end
                    end
                end
            else
                setvisible(tab.sections,false)
                for index,section in tab.sections do
                    for i,section2 in section.sections do
                        for i,v in section2._dcache do
                            v.Visible = false
                        end
                    end
                end
                tab.button.ChangeColor(_colors.mantle,_colors.crust)
            end
        end
    end

    function ui:tab(name)
        local tab = {}

        tab.tabindex = #self.tabs+1
        tab.name = name
        tab.button = createGradient({Size = v2(200,20), ZIndex = 3},self.colors.mantle,self.colors.crust,15)
        tab.text = create("Text",{Text = tab.name, ZIndex = 4, Outline = false})
        tab.buttonoutline = createOutline(tab.button,self.colors.crust,1)

        tab.sections = {}
        tab.side = {
            right = 0,
            left = 0
        }
        tab.menu = self

        tab._dcache = {tab.button,tab.text,tab.buttonoutline}

        tab.section = section

        self.tabs[tab.tabindex] = tab

        return tab
    end

    function addsection(self,name)
        local section = {}
        
        section.colors = self.colors
        section.name = name
        section.section_container = self.section_container
        section.button = createGradient({Position = v2(),Size = v2()},self.colors.mantle,self.colors.base,25)
        section.button.ZIndex = 4
        section.buttontext = create("Text",{
            Text = name,
            Color = self.colors.text,
            ZIndex = 5,
            Outline = false
        })

        section.elements = {}
        section.addbutton = button
		section.addtoggle = toggle
        section.addkeybind = keybind
		section.adddropdown = dropdown
        section.addslider = slider

        section._dcache = {
            section.button,
            section.buttontext
        }

        table.insert(self.sections,section)

        return section
    end

    function section(self,name,side)
        local section = {}
        local tabindex = self.tabindex

        local side = side and "right" or "left"
        local containerheight = self.menu._dcache[3].Size.Y

        section.section_container = create("Square",{
            Filled = true,
            Color = self.menu.colors.base,
            ZIndex = 2
        })
        section.section_outline = createOutline(section.section_container,self.menu.colors.crust,1)

        section.buttonbg = create("Square",{
            Filled = true,
            Color = self.menu.colors.crust,
            ZIndex = 3,
        })

        section.button = createGradient({Position = v2(),Size = v2()},self.menu.colors.mantle,self.menu.colors.base,25)
        section.button.ZIndex = 4

        section.buttontext = create("Text",{
            Text = name,
            Color = self.menu.colors.text,
            ZIndex = 5,
            Outline = false
        })
        
        self.side[side] += 1

        section.colors = self.menu.colors
        section.name = name
        section.sections = {section}
        section.index = 1
        section.sideindex = self.side[side]-1
        section.side = side
        section.addsection = addsection

        section.addbutton = button
		section.addtoggle = toggle
        section.addkeybind = keybind
		section.adddropdown = dropdown
        section.addslider = slider

        section.elements = {}
        --section.height = height

        section._dcache = {
            section.section_container,
            section.section_outline,
            section.buttonbg,
            section.button,
            section.buttontext
        }

        table.insert(self.sections,section)

        return section
    end

    local function cleancache(tbl, visited)
        visited = visited or {}

        if visited[tbl] then return end
        visited[tbl] = true

        for index, value in pairs(tbl) do
            if type(value) == 'table' then
                if value._dcache then
                    for i,v in value._dcache do
                        v:Remove()
                    end
                end

                cleancache(value, visited)
            end
        end
    end

    function setvisible(tbl, visible, visited)
        visited = visited or {}

        if visited[tbl] then return end
        visited[tbl] = true

        for index, value in pairs(tbl) do
            if type(value) == 'table' then
                if value.ignoreVisible then continue end
                if value._dcache then
                    for i,v in value._dcache do
                        v.Visible = visible or false
                    end
                end

                setvisible(value, visible, visited)
            end
        end
    end

    function button(self,data)
        local name = data.Name
        local callback = data.Callback

        local button = {
            class = "button",
            callback = callback or function() end,
            index = #self.elements+1,
            height = 18
        }

        local offset = self.section_container.Position + v2(0,self.groupoffset)

        button.text = create("Text",{Text = name, Color = self.colors.text,ZIndex = 5,Outline = false})
        button.buttonbase = createGradient({Position = v2(),Size = v2()},self.colors.mantle,self.colors.crust,25)
        button.buttonbase.ZIndex = 4
        button.buttonoutline = createOutline(button.buttonbase,self.colors.crust,3)

        button._dcache = {
            button.buttonbase,
            button.buttonoutline,
            button.text
        }

        table.insert(self.elements,button)
        return button
    end

    function toggle(self,data)
        local name = data.Name
        local callback = data.Callback
        local enabled = data.Enabled

        local toggle = {
            height = 18,
            class = "toggle",
            callback = callback or function() end,
            index = #self.elements+1,
            state = false
        }
        local height = toggle.height

        local offset = self.section_container.Position + v2(0,self.groupoffset)

        toggle.text = create("Text",{Text = name, Color = self.colors.text,ZIndex = 5,Outline = false})
        toggle.togglebutton = createGradient({Position = v2(),Size = v2()},self.colors.mantle,self.colors.crust,25)
        toggle.togglebutton.ZIndex = 4

        toggle.toggleoutline = createOutline(toggle.togglebutton,self.colors.crust,3)

        toggle._dcache = {
            toggle.togglebutton,
            toggle.toggleoutline,
            toggle.text
        }

        table.insert(self.elements,toggle)
        return toggle
    end

    function keybind(self,data)
        local name = data.Name
        local default = data.Default
        local onset = data.Changed
        local callback = data.Callback

        local keybind = {
            height = 18,
            index = #self.elements+1,
            state = default or "",
            class = "keybind",
            onset = onset or function() end,
            callback = callback or function() end,
        }
        local height = keybind.height

        local offset = self.section_container.Position + v2(0,self.groupoffset)

        keybind.text = create("Text",{Text = name, Color = self.colors.text,ZIndex = 5,Outline = false})
        keybind.statetext = create("Text",{Text = default or "", Color = self.colors.subtext0,ZIndex = 5,Outline = false})
        keybind.button = createGradient({Position = v2(),Size = v2()},self.colors.mantle,self.colors.crust,25)
        keybind.button.ZIndex = 4

        keybind.outline = createOutline(keybind.button,self.colors.crust,3)

        keybind._dcache = {
            keybind.button,
            keybind.outline,
            keybind.text,
            keybind.statetext
        }

        table.insert(self.elements,keybind)
        return keybind
    end

    function dropdown(self, data)
        local name = data.Name
        local options = data.Options or {}
        local default = data.Default or (options[1] or "None")
        local callback = data.Callback

        local dropdown = {
            class = "dropdown",
            callback = callback or function() end,
            options = options,
            selected = default,
            open = false,
            height = 18,
            index = #self.elements+1,
            optionsContainer = nil,
            optionsOutline = nil,
            optionElements = {},
        }

        dropdown.button = createGradient({Position = v2(), Size = v2()},self.colors.mantle,self.colors.crust,15)
        dropdown.button.ZIndex = 4
        dropdown.buttonoutline = createOutline(dropdown.button, self.colors.crust, 3)
        dropdown.labeltext = create("Text", {Text = name,Color = self.colors.text,ZIndex = 5,Outline = false})
        dropdown.valuetext = create("Text", {Text = dropdown.selected,Color = self.colors.subtext0,ZIndex = 5,Outline = false})
        dropdown.arrow = create("Text", {Color = self.colors.subtext1,ZIndex = 5,Outline = false,})

        dropdown.optionsContainer = create("Square", {Filled = true,Color = self.colors.mantle,ZIndex = 10,Visible = false})
        dropdown.optionsOutline = createOutline(dropdown.optionsContainer, self.colors.crust, 9)
        dropdown.optionsOutline.Visible = false

        for i,v in options do
            dropdown.optionElements[i] = create("Text",{
                Text = v,
				ZIndex = 10,
                Outline = false,
            })
        end

        dropdown._dcache = {
            dropdown.button,
            dropdown.buttonoutline,
            dropdown.labeltext,
            dropdown.valuetext,
            dropdown.arrow,
            dropdown.optionsContainer,
            dropdown.optionsOutline,
        }

        for i,v in dropdown.optionElements do
            table.insert(dropdown._dcache,v)
        end

        table.insert(self.elements, dropdown)
        return dropdown
    end

    function slider(self,data)
        local name = data.Name
        local callback = data.Callback

        local slider = {
            class = "slider",
            callback = callback or function() end,
            max = data.Max or 100,
            min = data.Minimum or 0,
            step = data.Step or 1,
            suffix = data.Suffix or "",
            index = #self.elements+1,
            height = 18,
            name = name,
        }

        slider.min-=slider.step
        slider.value = data.Default or slider.min

        local offset = self.section_container.Position + v2(0,self.groupoffset)

        slider.text = create("Text",{Text = name, Color = self.colors.text,ZIndex = 5,Outline = false})
        slider.sliderbackground = create("Frame", {
            Color = self.colors.mantle,
            ZIndex = 4,
        })
        slider.slideroutline = createOutline(slider.sliderbackground,self.colors.crust,3)

        slider.slideframe = createGradient({Position = v2(), Size = v2()},self.colors.teal,self.colors.sapphire,15)

        slider._dcache = {
            slider.sliderbackground,
            slider.slideroutline,
            slider.text,
            slider.slideframe
        }

        table.insert(self.elements,slider)
        return slider
    end

    function ui:Destroy()
        cleancache(self)
        setrobloxinput(true)
    end
end

lib:Destroy()
