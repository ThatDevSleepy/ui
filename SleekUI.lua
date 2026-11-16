--[[
	SleekUI v3 - UI library

	USING IT IN YOUR OWN SCRIPT
	  local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatDevSleepy/ui/main/SleekUI.lua"))()
	  -- (or loadstring(readfile("SleekUI.lua"))() for a local copy)
	  local Window  = Library:CreateWindow{ Title = "My Script" }
	  local Main    = Window:AddPage{ Name = "Main", Icon = "combat" }:AddSubPage("General")
	  local Sec     = Main:AddSection{ Name = "Features" }
	  Sec:AddToggle{ Name = "Enabled", Flag = "Enabled", Callback = function(on) ... end }
	  Window:AddSettingsPage{ Title = "My Script" }        -- configs, theme, menu key
	  Library:OnUnload(function() ... end)                  -- your cleanup
	  -- read values anywhere: Library.Flags.Enabled ; stop loops with: if Library.Unloaded then break end
	  -- errors inside your callbacks are caught and shown as a notification (Library.NotifyErrors = false to hide)
	  -- loading this file never opens anything by itself; demo.lua shows every feature in use

	SIDEBAR
	  left-click an icon   -> open that page (remembers its last subpage)
	  right-click an icon  -> flyout listing the page's subpages, right-click again to close
	  dot on an icon       -> page has subpages

	WINDOW
	  Library:CreateWindow{ Title, LogoIcon = "paw", Logo = "R" (text fallback), ToggleKey, Size, Dim = true }
	  Window:AddPage{ Name, Icon = "combat" | "rbxassetid://..." | "X", Fallback = "X", Order }
	  Page:AddSubPage(name)          Page:AddSection{...}  (single page, no subpages)
	  SubPage:AddSection{ Name, Side = "Left"|"Right", Collapsed = false }
	  Window:AddSettingsPage{ Title }    -> Menu / Configs / Theme
	  Window:SetOpen(bool)  Window:SetToggleKey(key)  Window:SetScale(n)  Window:Center()
	  Window:SetDim(bool)            darken the game behind the open menu (also a switch in Settings)
	  Window:SetCursor(bool)         small arrow cursor in the accent color, only while the menu is open (Cursor = false in CreateWindow)
	                                 Library.CursorColor = Color3.new(0, 0, 0) before CreateWindow for a fixed color instead
	                                 Library.CursorLead = 1 draws it one frame ahead so it keeps up with the mouse (0 = off)
	  Window:SetOpacity(0.3 - 1)     see-through window and cards (also a slider in Settings)
	  Library.ClickRipple = false    no pulse where a button or toggle is pressed (also a switch in Settings)
	  search box in the top left (Ctrl+F) searches every page; click a result to jump to it
	  click a section header to collapse it

	ELEMENTS - every element takes a table. Shared options on all of them:
	  Flag = "name"  (saved in configs, readable in Library.Flags)
	  Tooltip = "text"   Disabled = true   NoSave = true
	  Risky = true | "why"   red [!] after the name; a risky toggle asks once before the user switches it on
	                         (keybinds, configs and :Set() from a script are never interrupted)
	  every element returns an object with :Set :Get :SetVisible :SetDisabled (where it makes sense)
	  right-click most elements for a context menu (reset, copy/paste, clear, ...)

	  Section:AddToggle      { Name, Default, Callback(bool) }      -> :AddKeybind{} :AddColorPicker{}
	  Section:AddSlider      { Name, Min, Max, Default, Increment, Suffix, Callback(n) }
	                         mouse wheel or Left / Right arrows move it one step while the mouse rests on its
	                         track (the page holds still meanwhile); Library.SliderWheel = false turns that off
	  Section:AddRangeSlider { Name, Min, Max, Default = {lo, hi}, Increment, Suffix, Callback({lo, hi}) }
	  Section:AddDropdown    { Name, Options, Default, Multi, Search, Callback(v) }  -> :Refresh(list)
	  Section:AddKeybind     { Name, Default, Mode = "Toggle"|"Hold"|"Always", Callback(active), Pressed, Changed }
	  Section:AddColorPicker { Name, Default, Transparency = 0-1, NoTransparency, Callback(color, transparency) }
	                         the panel shows the last 8 colours you picked by hand; click one to use it again
	  Section:AddTextbox     { Name, Placeholder, Default, Numeric, Callback(text), OnEnter }
	  Section:AddButton      { Name, Callback, Confirm = true (click twice) }
	  Section:AddButtons     { {Name, Callback}, ... }
	  Section:AddProgress    { Name, Default (0-1), Suffix }   -> :Set(0-1)
	  Section:AddLabel(text, {Tooltip})  -> :Set(text) :AddKeybind{} :AddColorPicker{}
	  Section:AddParagraph   { Title, Text }
	  Section:AddDivider(text?)
	  Section:AddListbox     { Name, Options, Default, Height, Callback(v), OnDoubleClick(v), ContextItems(v) }
	  Section:AddPlayerList  { Name, Height, Priorities, Callback(player), PriorityChanged(player, p) }
	  Section:AddCharacterPreview { Height, AutoRotate, ESP = {Box, Name, Health, Distance}, Colors }
	  Section:AddDependency(element, condition?)  -> group that only shows while the element is on
	  Toggle:AddOptions(function(card) ... end)   -> "•••" button with a floating settings card
	  Description = "second line"   (toggles, dropdowns, sliders, keybinds, colors, textboxes)
	  element:OnChanged(fn)         extra listener on any element
	  SubPage:AddSection{ Icon, Tooltip, Toggle = { Flag, Default, Callback } }  (header switch locks the section)

	OVERLAYS / EXTRAS
	  Library:Notify{ Title, Text, Duration, Type = "info"|"success"|"warning"|"error" }
	    hover pauses its timer, x (or a click) closes it, the same one again shows x2 / x3 instead of stacking
	  Library.KeyConflictWarnings = false   (no warning when a key is bound that another feature already uses)
	  Library:Dialog{ Title, Text, Input = {Placeholder, Default}, Buttons = { {Text, Callback(inputText), Style = "primary"|"danger"} } }
	  Library:SetNotificationPosition("BottomRight"|"TopRight"|"BottomLeft"|"TopLeft")
	  Library:CreateLoader{ Title, Subtitle } -> :SetStatus(text, progress) :Finish(cb)
	  Library:RenameConfig / DuplicateConfig / ExportConfig / ImportConfig
	  Library:SetAccent(color)
	  Library:OpenContextMenu(title, items)
	  Library:CreateWatermark{ Title }     Library:CreateKeybindList()
	  Library:SetTheme(key, value)  Library:ApplyTheme(name|table)  Library:SetFont(name)
	  Library:SaveConfig / LoadConfig / DeleteConfig / ListConfigs / SetAutoload
	  configs also hold the look (theme colours + font); Library.ThemeInConfigs = false keeps them to settings only
	  Library:SetGameAutoload(name)  a config for the game you are in; LoadAutoload picks it over the general one
	  Library:SetAutoSave(bool)      writes changes back into the config last loaded or saved (GetActiveConfig)
	                                 load your config after building the whole menu, or late settings save as defaults
	  Library.Animations = false   (turns every tween instant)
	  Library:Unload()
]]

---------------------------------------------------------------- re-exec guard
pcall(function()
	if getgenv and getgenv().SleekUI and getgenv().SleekUI.Unload then
		getgenv().SleekUI:Unload()
	end
end)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local TextService = game:GetService("TextService")
local LocalPlayer = Players.LocalPlayer

local Library = {
	Flags = {},
	SetFlags = {},
	NoSave = {},
	Connections = {},
	ThemeCallbacks = {},
	_unloadFns = {},
	_bindRefreshers = {},
	Unloaded = false,
	Directory = "SleekUI",
	Animations = true,
	_binding = false,
	_ctxBlock = nil,
	_disabledRows = setmetatable({}, { __mode = "k" }), -- row -> true while greyed out
	_pendingFlags = {}, -- config values loaded before their element existed
}

---------------------------------------------------------------- themes
local ThemeKeys = { "Accent", "Background", "Card", "Element", "ElementHover", "Stroke", "Text", "SubText" }

local function rgb(r, g, b) return Color3.fromRGB(r, g, b) end
local Presets = {
	Default  = { Accent = rgb(88, 140, 255),  Background = rgb(17, 17, 19), Card = rgb(23, 23, 26), Element = rgb(32, 32, 36), ElementHover = rgb(42, 42, 47), Stroke = rgb(40, 40, 46), Text = rgb(235, 235, 240), SubText = rgb(135, 135, 145) },
	Graphite = { Accent = rgb(190, 195, 205), Background = rgb(14, 14, 15), Card = rgb(20, 20, 22), Element = rgb(34, 34, 38), ElementHover = rgb(48, 48, 53), Stroke = rgb(38, 38, 42), Text = rgb(225, 225, 230), SubText = rgb(115, 115, 122) },
	Vapor    = { Accent = rgb(255, 120, 200), Background = rgb(14, 12, 19), Card = rgb(21, 18, 29), Element = rgb(36, 30, 52), ElementHover = rgb(50, 42, 72), Stroke = rgb(44, 36, 62), Text = rgb(240, 232, 250), SubText = rgb(135, 118, 160) },
	Oxide    = { Accent = rgb(225, 115, 60),  Background = rgb(16, 13, 11), Card = rgb(23, 18, 15), Element = rgb(44, 32, 25), ElementHover = rgb(62, 45, 35), Stroke = rgb(48, 36, 28), Text = rgb(238, 224, 210), SubText = rgb(135, 110, 90) },
	Glacier  = { Accent = rgb(140, 210, 240), Background = rgb(11, 14, 17), Card = rgb(16, 21, 26), Element = rgb(28, 38, 48), ElementHover = rgb(40, 54, 68), Stroke = rgb(32, 44, 56), Text = rgb(222, 236, 246), SubText = rgb(105, 130, 150) },
	Nectar   = { Accent = rgb(245, 190, 45),  Background = rgb(14, 13, 10), Card = rgb(21, 19, 13), Element = rgb(40, 35, 22), ElementHover = rgb(56, 49, 30), Stroke = rgb(44, 38, 24), Text = rgb(242, 232, 205), SubText = rgb(140, 125, 85) },
	Poison   = { Accent = rgb(90, 240, 120),  Background = rgb(11, 15, 11), Card = rgb(15, 22, 15), Element = rgb(26, 42, 28), ElementHover = rgb(36, 60, 40), Stroke = rgb(28, 46, 30), Text = rgb(212, 245, 212), SubText = rgb(95, 135, 100) },
	Circuit  = { Accent = rgb(0, 240, 195),   Background = rgb(9, 13, 15),  Card = rgb(13, 19, 23), Element = rgb(22, 40, 44), ElementHover = rgb(32, 56, 62), Stroke = rgb(22, 44, 48), Text = rgb(205, 245, 240), SubText = rgb(85, 135, 130) },
}
local PresetOrder = { "Default", "Graphite", "Vapor", "Oxide", "Glacier", "Nectar", "Poison", "Circuit" }

local FontPresets = {
	Gotham      = { "GothamMedium", "GothamBold" },
	BuilderSans = { "BuilderSansMedium", "BuilderSansBold" },
	Montserrat  = { "MontserratMedium", "MontserratBold" },
	SourceSans  = { "SourceSansSemibold", "SourceSansBold" },
	Arial       = { "Arial", "ArialBold" },
	Ubuntu      = { "Ubuntu", "Ubuntu" },
	-- Styled fonts, named after Discord's display-name styles. Roblox can only draw its own
	-- built-in fonts, so each name uses the closest built-in one, not Discord's actual font file.
	-- Most have a single weight, so regular and bold are the same font.
	Tempo       = { "Merriweather", "Merriweather" },       -- serif
	Sakura      = { "FredokaOne", "FredokaOne" },           -- soft and rounded
	Jellybean   = { "DenkOne", "DenkOne" },                 -- chunky and bouncy
	Modern      = { "Jura", "Jura" },                       -- thin geometric
	Medieval    = { "GrenzeGotisch", "GrenzeGotisch" },     -- blackletter
	["8bit"]    = { "Arcade", "Arcade" },                   -- pixel (runs wide)
	Vampyre     = { "Creepster", "Creepster" },             -- horror
	["Monkey Bars"] = { "LuckiestGuy", "LuckiestGuy" },     -- playful capitals
	Mainframe   = { "RobotoMono", "RobotoMono" },           -- terminal monospace
	Headbang    = { "Bangers", "Bangers" },                 -- loud poster capitals
	Journal     = { "PatrickHand", "PatrickHand" },         -- handwriting
}
local FontOrder = {
	"Gotham", "BuilderSans", "Montserrat", "SourceSans", "Arial", "Ubuntu",
	"Tempo", "Sakura", "Jellybean", "Modern", "Medieval", "8bit", "Vampyre", "Monkey Bars", "Mainframe", "Headbang", "Journal",
}
local function fontEnum(name, fallback)
	local ok, f = pcall(function() return Enum.Font[name] end)
	return ok and f or fallback
end

local Theme = {}
for k, v in pairs(Presets.Default) do Theme[k] = v end
Theme.Font = Enum.Font.GothamMedium
Theme.FontBold = Enum.Font.GothamBold
Theme.FontName = "Gotham"

Library.Theme = Theme
Library.Presets = Presets
Library.PresetOrder = PresetOrder
Library.ThemeKeys = ThemeKeys
Library.FontOrder = FontOrder

local ThemeRegistry = setmetatable({}, { __mode = "k" }) -- instance -> { Property = ThemeKey }

-- Roblox can garbage-collect the script-side handle of an instance that nothing in the script
-- points at any more, even while the instance is still on screen. Its weak ThemeRegistry entry
-- goes with it, and that element then silently stops following theme changes (the watermark logo
-- stayed on the old accent this way). A Destroying listener holds the handle, so the entry lives
-- exactly as long as the instance does.
local function pinThemed(inst)
	pcall(function()
		inst.Destroying:Connect(function() ThemeRegistry[inst] = nil end)
	end)
end

---------------------------------------------------------------- helpers
local TEXT_CLASSES = { TextLabel = true, TextButton = true, TextBox = true }

local function create(class, props, children)
	local inst = Instance.new(class)
	local parent, themed, bold
	for k, v in pairs(props or {}) do
		if k == "Parent" then parent = v
		elseif k == "Themed" then themed = v
		elseif k == "Bold" then bold = v
		else inst[k] = v end
	end
	-- every text object follows the theme font automatically. Bold = true asks for the theme's
	-- bold font; it is a flag and not a font comparison because single-weight fonts use the same
	-- font for both, and comparing would remember every label built under one as bold.
	if TEXT_CLASSES[class] and not (themed and themed.Font) then
		themed = themed and table.clone(themed) or {}
		themed.Font = bold and "FontBold" or "Font"
	end
	if themed then
		for prop, key in pairs(themed) do inst[prop] = Theme[key] end
		ThemeRegistry[inst] = themed
		pinThemed(inst)
	end
	for _, c in ipairs(children or {}) do c.Parent = inst end
	if parent then inst.Parent = parent end
	return inst
end

local function corner(r) return create("UICorner", { CornerRadius = UDim.new(0, r or 6) }) end

local function stroke(key)
	return create("UIStroke", { Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Themed = { Color = key or "Stroke" } })
end

-- subtle depth for accent-coloured fills. A UIGradient's colours multiply with the frame's own
-- colour, so the frame keeps following the theme and its colour tweens; this only shades one end.
local function shade(rotation, from, to)
	return create("UIGradient", {
		Rotation = rotation or 0,
		Color = ColorSequence.new(Color3.new(from, from, from), Color3.new(to, to, to)),
	})
end

-- soft accent ring around a slider knob, reads as a glow
local function halo()
	local s = stroke("Accent")
	s.Thickness = 2
	s.Transparency = 0.6
	return s
end

-- click ripple: a soft circle that grows from where the button was pressed and fades out.
-- It gets its own clipping frame, so nothing about the button itself changes. `input` is the
-- press (its Position is in the same space as AbsolutePosition); without one it starts in the
-- middle. Library.ClickRipple = false turns it off.
local ripple

local function padding(t, l, b, r)
	return create("UIPadding", {
		PaddingTop = UDim.new(0, t), PaddingLeft = UDim.new(0, l or t),
		PaddingBottom = UDim.new(0, b or t), PaddingRight = UDim.new(0, r or l or t),
	})
end

local function list(pad, horizontal, props)
	local l = create("UIListLayout", {
		Padding = UDim.new(0, pad or 0), SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = horizontal and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical,
	})
	for k, v in pairs(props or {}) do l[k] = v end
	return l
end

local function tween(obj, t, props, style, dir)
	if not Library.Animations then t = 0 end
	local tw = TweenService:Create(obj, TweenInfo.new(t, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
	tw:Play()
	return tw
end

function ripple(target, input)
	if not Library.Animations or Library.ClickRipple == false then return end
	-- pcall: purely decorative, so nothing in here may ever reach the console
	pcall(function()
		local scale = Library:_scale()
		local size = target.AbsoluteSize / scale
		local x, y = size.X / 2, size.Y / 2
		if input then
			x = math.max(math.min((input.Position.X - target.AbsolutePosition.X) / scale, size.X), 0)
			y = math.max(math.min((input.Position.Y - target.AbsolutePosition.Y) / scale, size.Y), 0)
		end
		local clip = create("Frame", {
			Name = "Ripple", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
			ClipsDescendants = true, Active = false, ZIndex = target.ZIndex, Parent = target,
		})
		local dot = create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(0, 0),
			BackgroundColor3 = Theme.Text, BackgroundTransparency = 0.82, BorderSizePixel = 0, Parent = clip,
		}, { create("UICorner", { CornerRadius = UDim.new(1, 0) }) })
		local d = math.max(size.X, size.Y) * 2
		tween(dot, 0.45, { Size = UDim2.fromOffset(d, d), BackgroundTransparency = 1 }, Enum.EasingStyle.Quad)
		task.delay(0.5, function() clip:Destroy() end)
	end)
end
-- runs the ripple whenever `target` is pressed with the left mouse button or a finger
local function rippleOnPress(target)
	target.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			ripple(target, input)
		end
	end)
end

-- fade a freshly built popup in at its real size (a UIScale "pop" makes the text visibly grow).
-- Reads each object's current look as the target, so only use it on content built just now.
local function fadeIn(root, t)
	local function each(o)
		if o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox") then
			local target = o.TextTransparency
			o.TextTransparency = 1
			tween(o, t, { TextTransparency = target })
		end
		if o:IsA("ImageLabel") or o:IsA("ImageButton") then
			local target = o.ImageTransparency
			o.ImageTransparency = 1
			tween(o, t, { ImageTransparency = target })
		end
		if o:IsA("GuiObject") then
			local target = o.BackgroundTransparency
			if target < 1 then
				o.BackgroundTransparency = 1
				tween(o, t, { BackgroundTransparency = target })
			end
		elseif o:IsA("UIStroke") then
			local target = o.Transparency
			o.Transparency = 1
			tween(o, t, { Transparency = target })
		end
	end
	each(root)
	for _, d in ipairs(root:GetDescendants()) do each(d) end
end
-- fade everything out (for popups that get destroyed afterwards); returns the root's tween
local function fadeOut(root, t)
	for _, d in ipairs(root:GetDescendants()) do
		if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then tween(d, t, { TextTransparency = 1 }, Enum.EasingStyle.Quad) end
		if d:IsA("ImageLabel") or d:IsA("ImageButton") then tween(d, t, { ImageTransparency = 1 }, Enum.EasingStyle.Quad) end
		if d:IsA("GuiObject") then tween(d, t, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad)
		elseif d:IsA("UIStroke") then tween(d, t, { Transparency = 1 }, Enum.EasingStyle.Quad) end
	end
	return tween(root, t, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad)
end

function Library:Connect(signal, fn)
	local c = signal:Connect(fn)
	table.insert(self.Connections, c)
	return c
end
local function connect(signal, fn) return Library:Connect(signal, fn) end

-- Mouse-move and per-frame signals are shared: every slider, colour picker, drag handle and
-- dependency group used to hold its own connection, so one mouse move woke up hundreds of
-- them. Now each signal has ONE real connection that walks a plain list, which costs a
-- fraction of that. pcall keeps one broken handler from stopping the rest (or reaching the
-- console). Handlers here must not yield.
local function sharedSignal(signal)
	local fns = {}
	connect(signal, function(a, b)
		for i = 1, #fns do pcall(fns[i], a, b) end
	end)
	return function(fn) fns[#fns + 1] = fn end
end
local onInputChanged = sharedSignal(UserInputService.InputChanged)
local onInputEnded = sharedSignal(UserInputService.InputEnded)
local onHeartbeat = sharedSignal(RunService.Heartbeat)
local onRenderStepped = sharedSignal(RunService.RenderStepped)

-- every user callback goes through here: runs in its own thread, and an error inside it is
-- caught (no red console spam) and shown as a notification instead, so one broken callback
-- never breaks the UI. Library.NotifyErrors = false silences the toast.
local function fire(cb, ...)
	if type(cb) ~= "function" then return end
	local args = table.pack(...)
	task.spawn(function()
		local ok, err = pcall(cb, table.unpack(args, 1, args.n))
		if not ok then
			Library.LastError = err
			if Library.NotifyErrors ~= false and Library.Notify and Library._gui then
				Library:Notify({ Title = "Callback error", Text = tostring(err), Type = "error", Duration = 5 })
			end
		end
	end)
end

-- text going into a RichText label: & < > would otherwise be read as markup
local function escapeRich(s)
	return (tostring(s):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function onTheme(fn)
	table.insert(Library.ThemeCallbacks, fn)
end

local function setClipboard(text)
	local fn = setclipboard or toclipboard or (syn and syn.write_clipboard)
	if typeof(fn) == "function" then pcall(fn, text) return true end
	return false
end

function Library:_scale()
	local w = self.Window
	return (w and w._uiScale and w._uiScale.Scale) or 1
end

local function textLabel(props)
	local base = {
		BackgroundTransparency = 1, Font = Theme.Font, TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left, Themed = { TextColor3 = "Text" },
	}
	for k, v in pairs(props) do base[k] = v end
	return create("TextLabel", base)
end

local function registerFlag(o, setter, initial)
	if not o.Flag then return end
	Library.Flags[o.Flag] = initial
	Library.SetFlags[o.Flag] = setter
	if o.NoSave then Library.NoSave[o.Flag] = true end
end

local function makeDraggable(handle, target)
	local dragging, dragStart, startPos, startAbs
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging, dragStart, startPos, startAbs = true, input.Position, target.Position, target.AbsolutePosition
		end
	end)
	onInputChanged(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local d = input.Position - dragStart
			-- keep at least 40px on screen and the top edge reachable, so it can't be lost off-screen
			local parent = target.Parent
			if parent and parent:IsA("GuiBase2d") then
				-- everything relative to the parent: AbsolutePosition and the screen edges must be
				-- measured from the same origin (the topbar inset can shift one but not the other)
				local origin, screen, size = parent.AbsolutePosition, parent.AbsoluteSize, target.AbsoluteSize
				local sx, sy = startAbs.X - origin.X, startAbs.Y - origin.Y
				-- max/min instead of math.clamp: clamp errors if min > max (tiny / not-yet-sized screen)
				local x = math.max(math.min(sx + d.X, screen.X - 40), 40 - size.X)
				local y = math.max(math.min(sy + d.Y, screen.Y - 40), 0)
				d = Vector3.new(x - sx, y - sy, 0)
			end
			target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	onInputEnded(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

-- Roblox's MouseLeave is unreliable: it gets skipped when the mouse moves fast between neighbours,
-- or when a row scrolls / hides under the cursor, which leaves rows stuck looking hovered.
-- A hover group makes sure only one row of a list is ever hovered: entering a row un-hovers the
-- previous one, and group:clear() (called when the mouse leaves the whole list or it closes)
-- un-hovers whatever is left.
local function hoverGroup()
	local group = { current = nil }
	function group:bind(gui, enter, leave)
		gui.MouseEnter:Connect(function()
			local prev = group.current
			if prev and prev.gui ~= gui then prev.leave() end
			group.current = { gui = gui, leave = leave }
			enter()
		end)
		gui.MouseLeave:Connect(function()
			if group.current and group.current.gui == gui then group.current = nil end
			leave()
		end)
	end
	function group:clear()
		local prev = group.current
		group.current = nil
		if prev then prev.leave() end
	end
	return group
end
-- one shared group for every toggle row / button in the window, so at most one is ever lit
Library._rowHover = hoverGroup()

local function visibleOnScreen(gui)
	local g = gui
	while g and not g:IsA("LayerCollector") do
		if g:IsA("GuiObject") and not g.Visible then return false end
		g = g.Parent
	end
	return g ~= nil
end

-- marks a sub-control (key chip, swatch) so the row's right-click menu doesn't also open.
-- The block only counts while that control is still on screen, so a missed MouseLeave
-- (control hidden or destroyed under the mouse) can't disable right-click menus for good.
local function blockRowContext(gui)
	gui.MouseEnter:Connect(function() Library._ctxBlock = gui end)
	gui.MouseLeave:Connect(function() if Library._ctxBlock == gui then Library._ctxBlock = nil end end)
end
local function rowContextBlocked()
	local g = Library._ctxBlock
	if not g then return false end
	if typeof(g) ~= "Instance" or not g.Parent or not visibleOnScreen(g) then
		Library._ctxBlock = nil
		return false
	end
	return true
end

-- Mouse wheel / arrow keys on sliders. The slider the mouse is resting on "claims" the wheel:
-- the page stops scrolling while it holds the claim, and every wheel tick (or Left / Right
-- arrow) moves it one step. A slider that only passes under the mouse while the page is being
-- scrolled does not claim, so scrolling a page can never change a value by accident.
-- Library.SliderWheel = false turns it off.
local nudge = { target = nil, lastScroll = 0 }
Library._nudge = nudge
function nudge.release()
	local t = nudge.target
	nudge.target = nil
	if t and t.scroll then pcall(function() t.scroll.ScrollingEnabled = true end) end
end
function nudge.claim(gui, step, isDisabled, fallbackScroll)
	if Library.SliderWheel == false then return end
	if nudge.target and nudge.target.gui == gui then return end
	if os.clock() - nudge.lastScroll < 0.35 then return end -- the page is moving right now
	nudge.release()
	local scroll
	pcall(function() scroll = gui:FindFirstAncestorWhichIsA("ScrollingFrame") end)
	scroll = scroll or fallbackScroll
	nudge.target = { gui = gui, step = step, disabled = isDisabled, scroll = scroll }
	if scroll then pcall(function() scroll.ScrollingEnabled = false end) end
end
-- still the slider under the mouse? If not (mouse left, row hidden / disabled / destroyed) the
-- claim is dropped, which also gives the page its scrolling back. `pos` is the mouse position
-- in AbsolutePosition space (InputObject.Position), or nil to skip that part.
function nudge.valid(pos)
	local t = nudge.target
	if not t then return false end
	local ok, res = pcall(function()
		if not t.gui.Parent or not visibleOnScreen(t.gui) or t.disabled() then return false end
		if pos then
			local p, s = t.gui.AbsolutePosition, t.gui.AbsoluteSize
			-- a few px of slack so the claim doesn't flicker at the edge of the thin track
			if pos.X < p.X - 4 or pos.X > p.X + s.X + 4 or pos.Y < p.Y - 4 or pos.Y > p.Y + s.Y + 4 then return false end
		end
		return true
	end)
	if ok and res then return true end
	nudge.release()
	return false
end
onInputChanged(function(input)
	if not nudge.target then return end
	if input.UserInputType == Enum.UserInputType.MouseWheel then
		if nudge.valid(nil) then pcall(nudge.target.step, input.Position.Z > 0 and 1 or -1) end
	elseif input.UserInputType == Enum.UserInputType.MouseMovement then
		nudge.valid(input.Position)
	end
end)
connect(UserInputService.InputBegan, function(input)
	if not nudge.target then return end
	local dir = (input.KeyCode == Enum.KeyCode.Right and 1) or (input.KeyCode == Enum.KeyCode.Left and -1) or nil
	if not dir or UserInputService:GetFocusedTextBox() then return end
	if nudge.valid(nil) then pcall(nudge.target.step, dir) end
end)

-- right-click (on release) opens a context menu built by itemsFn
local function attachContext(target, title, itemsFn)
	target.InputEnded:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton2 then return end
		if rowContextBlocked() then return end
		-- greyed-out element: no menu (its "Turn on" / "Reset" would change it anyway)
		local g = target
		for _ = 1, 3 do
			if not g then break end
			if Library._disabledRows[g] then return end
			g = g.Parent
		end
		local items = itemsFn()
		if items and #items > 0 then Library:OpenContextMenu(title, items) end
	end)
end

-- mouse position in gui space (corrects for the topbar inset when the gui doesn't ignore it)
local function mousePos()
	return UserInputService:GetMouseLocation()
end

---------------------------------------------------------------- keys
local ShortKeys = {
	LeftShift = "LShift", RightShift = "RShift", LeftControl = "LCtrl", RightControl = "RCtrl",
	LeftAlt = "LAlt", RightAlt = "RAlt", MouseButton1 = "MB1", MouseButton2 = "MB2", MouseButton3 = "MB3",
	Return = "Enter", Backspace = "Back", CapsLock = "Caps", Zero = "0", One = "1", Two = "2", Three = "3",
	Four = "4", Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9", Insert = "Ins", Delete = "Del",
	PageUp = "PgUp", PageDown = "PgDn", Semicolon = ";", Quote = "'", Comma = ",", Period = ".", Slash = "/",
	BackSlash = "\\", LeftBracket = "[", RightBracket = "]", Minus = "-", Equals = "=", Backquote = "`",
}
local function keyName(k)
	if not k then return "None" end
	return ShortKeys[k.Name] or k.Name
end
local function keyToString(k)
	if not k then return "None" end
	return (k.EnumType == Enum.KeyCode and "KeyCode." or "UserInputType.") .. k.Name
end
local function parseKey(s)
	if typeof(s) == "EnumItem" then return s end
	if type(s) ~= "string" or s == "" or s == "None" then return nil end
	local kind, name = s:match("^(%w+)%.(%w+)$")
	if not kind then kind, name = "KeyCode", s end
	local ok, res = pcall(function() return Enum[kind][name] end)
	return ok and res or nil
end
local function inputMatches(input, key)
	if not key then return false end
	if key.EnumType == Enum.KeyCode then return input.KeyCode == key end
	return input.UserInputType == key
end

---------------------------------------------------------------- gui root
function Library:_getGui()
	if self._gui then return self._gui end
	if self.Unloaded then return nil end
	local gui = create("ScreenGui", {
		Name = HttpService:GenerateGUID(false):sub(1, 8), ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true, DisplayOrder = 999,
	})
	local ok = false
	if gethui then ok = pcall(function() gui.Parent = gethui() end) end
	if not ok or not gui.Parent then ok = pcall(function() gui.Parent = CoreGui end) end
	if not ok or not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
	self._gui = gui

	self._notifHolder = create("Frame", {
		AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -16, 1, -16), Size = UDim2.fromOffset(260, 600),
		BackgroundTransparency = 1, ZIndex = 300, Parent = gui,
	}, { list(8, false, { VerticalAlignment = Enum.VerticalAlignment.Bottom }) })
	if self._notifPosition then self:SetNotificationPosition(self._notifPosition) end
	return gui
end

-- "BottomRight" (default) | "TopRight" | "BottomLeft" | "TopLeft"
function Library:SetNotificationPosition(pos)
	self._notifPosition = pos
	local holder = self._notifHolder
	if not holder then return end
	local top = pos == "TopRight" or pos == "TopLeft"
	local left = pos == "BottomLeft" or pos == "TopLeft"
	self._notifSide = left and -1 or 1
	holder.AnchorPoint = Vector2.new(left and 0 or 1, top and 0 or 1)
	holder.Position = UDim2.new(left and 0 or 1, left and 16 or -16, top and 0 or 1, top and 16 or -16)
	local l = holder:FindFirstChildOfClass("UIListLayout")
	if l then l.VerticalAlignment = top and Enum.VerticalAlignment.Top or Enum.VerticalAlignment.Bottom end
end

---------------------------------------------------------------- theming api
local function setProp(inst, prop, value) inst[prop] = value end
function Library:SetTheme(key, value)
	if value == nil then return end
	Theme[key] = value
	-- inside ApplyTheme / SetFont several keys change at once: just note them, one pass at the end
	local batch = self._themeBatch
	if batch then batch[key] = true return end
	for inst, map in pairs(ThemeRegistry) do
		for prop, k in pairs(map) do
			if k == key then pcall(setProp, inst, prop, value) end
		end
	end
	for _, cb in ipairs(self.ThemeCallbacks) do pcall(cb, key) end
end
-- Runs fn with theme changes held back, then recolours everything in ONE pass. A preset used to
-- walk every themed object and re-render every toggle once per colour (ten times over).
function Library:_batchTheme(fn)
	if self._themeBatch then return fn() end -- already inside a batch
	local batch = {}
	self._themeBatch = batch
	local ok, res = pcall(fn)
	self._themeBatch = nil
	if next(batch) ~= nil then
		for inst, map in pairs(ThemeRegistry) do
			for prop, k in pairs(map) do
				if batch[k] then pcall(setProp, inst, prop, Theme[k]) end
			end
		end
		for _, cb in ipairs(self.ThemeCallbacks) do pcall(cb) end
	end
	if ok then return res end
	return false
end
Library.SetThemeColor = Library.SetTheme
function Library:SetAccent(c) self:SetTheme("Accent", c) end

function Library:SetFont(name)
	local p = FontPresets[name]
	if not p then return false end
	Theme.FontName = name
	self:_batchTheme(function()
		self:SetTheme("Font", fontEnum(p[1], Enum.Font.GothamMedium))
		self:SetTheme("FontBold", fontEnum(p[2], Enum.Font.GothamBold))
	end)
	return true
end

function Library:ApplyTheme(t)
	if type(t) == "string" then t = Presets[t] end
	if type(t) ~= "table" then return false end
	self:_batchTheme(function()
		for _, key in ipairs(ThemeKeys) do
			local c = t[key]
			if type(c) == "string" then pcall(function() c = Color3.fromHex(c) end) end
			if typeof(c) == "Color3" then
				self:SetTheme(key, c)
				local setter = self.SetFlags["Theme_" .. key]
				if setter then setter(c, true) end
			end
		end
		if type(t.Font) == "string" and FontPresets[t.Font] then
			self:SetFont(t.Font)
			local setter = self.SetFlags["Theme_Font"]
			if setter then setter(t.Font, true) end
		end
	end)
	return true
end

---------------------------------------------------------------- files / configs
local FS = {}
FS.ok = typeof(writefile) == "function" and typeof(readfile) == "function" and typeof(isfile) == "function"
	and typeof(isfolder) == "function" and typeof(makefolder) == "function" and typeof(listfiles) == "function"
Library.FileSupport = FS.ok

local function ensureFolders()
	if not FS.ok then return false end
	for _, p in ipairs({ Library.Directory, Library.Directory .. "/configs", Library.Directory .. "/themes", Library.Directory .. "/assets" }) do
		if not isfolder(p) then makefolder(p) end
	end
	return true
end

local function cleanName(name)
	name = tostring(name or ""):gsub("[^%w%s%-_]", ""):gsub("^%s+", ""):gsub("%s+$", "")
	return name
end

local function listJson(folder)
	local out = {}
	if not ensureFolders() then return out end
	for _, f in ipairs(listfiles(Library.Directory .. "/" .. folder)) do
		local n = tostring(f):match("([^/\\]+)%.json$")
		if n then table.insert(out, n) end
	end
	table.sort(out)
	return out
end

function Library:GetConfig()
	local out = {}
	for flag, v in pairs(self.Flags) do
		if self.NoSave[flag] or tostring(flag):sub(1, 6) == "Theme_" then continue end
		local t = typeof(v)
		if t == "Color3" then
			out[flag] = { __type = "Color3", Hex = v:ToHex() }
		elseif t == "table" and v.__keybind then
			out[flag] = { __type = "Keybind", Key = keyToString(v.Key), Mode = v.Mode, ShowInList = v.ShowInList }
		elseif t == "EnumItem" then
			out[flag] = { __type = "Keybind", Key = keyToString(v), Mode = "Toggle" }
		elseif t == "boolean" or t == "number" or t == "string" or t == "table" then
			out[flag] = v
		end
	end
	-- the look travels with the config: all theme colours plus the font. It is one "__theme"
	-- entry (not the Theme_ flags) so it works with or without a Settings page.
	-- Library.ThemeInConfigs = false keeps configs to settings only.
	if self.ThemeInConfigs ~= false then
		local look = { Font = Theme.FontName }
		for _, key in ipairs(ThemeKeys) do
			if typeof(Theme[key]) == "Color3" then look[key] = Theme[key]:ToHex() end
		end
		out.__theme = look
	end
	return HttpService:JSONEncode(out)
end

local function decodeValue(v)
	if type(v) == "table" then
		if v.__type == "Color3" then return Color3.fromHex(v.Hex) end
		if v.__type == "Keybind" then return { Key = parseKey(v.Key), Mode = v.Mode, ShowInList = v.ShowInList } end
	end
	return v
end

function Library:ApplyConfig(json)
	local ok, data = pcall(function() return HttpService:JSONDecode(json) end)
	if not ok or type(data) ~= "table" then return false, "bad json" end
	-- callbacks run while the config applies; any popups they raise are held back so loading
	-- shows one "Loaded" notice instead of one per feature (errors still show)
	self._applyingConfig = true
	-- the saved look (colours + font). Older configs have none and leave the theme alone.
	local look = data.__theme
	data.__theme = nil
	if type(look) == "table" and self.ThemeInConfigs ~= false then
		-- pcall: a hand-edited config with junk in it must not stop the rest from loading
		pcall(function()
			-- only what actually differs, so loading a config with the same look recolours nothing
			local diff, any = {}, false
			for _, key in ipairs(ThemeKeys) do
				local code = look[key]
				if type(code) == "string" and typeof(Theme[key]) == "Color3" and (code:lower():gsub("#", "")) ~= Theme[key]:ToHex() then
					diff[key] = code
					any = true
				end
			end
			if type(look.Font) == "string" and look.Font ~= Theme.FontName then
				diff.Font = look.Font
				any = true
			end
			if any then self:ApplyTheme(diff) end
		end)
	end
	for flag, v in pairs(data) do
		local setter = self.SetFlags[flag]
		-- decode inside pcall too: a broken value (bad hex) must not stop the load half-way
		local okValue, value = pcall(decodeValue, v)
		if okValue then
			if setter then
				pcall(setter, value)
			else
				-- nothing owns this flag yet (watermark / keybind list not created): keep the value
				-- and apply it when that thing gets created
				self._pendingFlags[flag] = value
			end
		end
	end
	self._applyingConfig = false
	return true
end

-- Saves a draggable overlay's position under `flag` (it goes into configs like any other flag)
-- and restores it on load. A saved spot that would be off this screen is pulled back on.
function Library:_trackPosition(frame, flag)
	local function save()
		local p = frame.Position
		self.Flags[flag] = { p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset }
	end
	local function keepOnScreen()
		local parent = frame.Parent
		if not (parent and parent:IsA("GuiBase2d")) then return end
		local screen, size = parent.AbsoluteSize, frame.AbsoluteSize
		if screen.X <= 0 or screen.Y <= 0 then return end
		local rel = frame.AbsolutePosition - parent.AbsolutePosition
		local x = math.max(math.min(rel.X, screen.X - math.min(size.X, 40)), 0)
		local y = math.max(math.min(rel.Y, screen.Y - math.min(size.Y, 30)), 0)
		if x ~= rel.X or y ~= rel.Y then frame.Position = frame.Position + UDim2.fromOffset(x - rel.X, y - rel.Y) end
	end
	self.SetFlags[flag] = function(v)
		if type(v) ~= "table" then return end
		-- this overlay was removed: keep the value for the next one that gets created
		if not frame.Parent then self._pendingFlags[flag] = v return end
		local xs, xo, ys, yo = tonumber(v[1]), tonumber(v[2]), tonumber(v[3]), tonumber(v[4])
		if not (xs and xo and ys and yo) then return end
		frame.Position = UDim2.new(xs, xo, ys, yo)
		task.defer(keepOnScreen) -- after the new position has been laid out
	end
	frame:GetPropertyChangedSignal("Position"):Connect(save)
	save()
	local pending = self._pendingFlags[flag]
	if pending ~= nil then
		self._pendingFlags[flag] = nil
		self.SetFlags[flag](pending)
	end
end

function Library:SaveConfig(name)
	name = cleanName(name)
	if not ensureFolders() then return false, "file functions unavailable" end
	if name == "" then return false, "empty name" end
	writefile(self.Directory .. "/configs/" .. name .. ".json", self:GetConfig())
	self._activeConfig = name
	return true
end

function Library:LoadConfig(name)
	name = cleanName(name)
	if not ensureFolders() then return false, "file functions unavailable" end
	local path = self.Directory .. "/configs/" .. name .. ".json"
	if not isfile(path) then return false, "config not found" end
	local ok, err = self:ApplyConfig(readfile(path))
	if ok then self._activeConfig = name end
	return ok, err
end

-- The active config is the one last loaded or saved. With auto-save on, later changes are
-- written back into it by themselves, a moment after you stop changing things.
-- Load your config AFTER building the whole menu: a setting created later would be saved back
-- with its default value. The choice is remembered in autosave.txt, separate from configs.
function Library:GetActiveConfig() return self._activeConfig end

function Library:GetAutoSave()
	if self.AutoSave ~= nil then return self.AutoSave end
	local on = false
	pcall(function()
		if not ensureFolders() then return end
		local p = self.Directory .. "/autosave.txt"
		on = isfile(p) and readfile(p) == "1"
	end)
	return on
end

function Library:_autoSaveTick()
	local name = self._activeConfig
	if not name or not ensureFolders() then return end
	local data = self:GetConfig()
	if self._autoSaveFor ~= name then
		-- another config just became active: note how it looks now, save nothing yet
		self._autoSaveFor, self._autoSaveData, self._autoSavePending = name, data, nil
		return
	end
	if data == self._autoSaveData then self._autoSavePending = nil return end
	-- still changing (a slider being dragged)? wait until two checks in a row agree
	if data ~= self._autoSavePending then self._autoSavePending = data return end
	self._autoSavePending = nil
	local path = self.Directory .. "/configs/" .. name .. ".json"
	if not isfile(path) then self._activeConfig = nil return end -- deleted from outside
	writefile(path, data)
	self._autoSaveData = data
end

function Library:SetAutoSave(on)
	on = on and true or false
	self.AutoSave = on
	pcall(function()
		if ensureFolders() then writefile(self.Directory .. "/autosave.txt", on and "1" or "0") end
	end)
	if not on or self._autoSaveLoop then return end
	self._autoSaveLoop = true
	local lastCheck = 0
	self:Connect(RunService.Heartbeat, function()
		if not self.AutoSave or self.Unloaded or self._applyingConfig then return end
		local now = os.clock()
		if now - lastCheck < 1 then return end
		lastCheck = now
		pcall(function() self:_autoSaveTick() end) -- file errors must never reach the console
	end)
end

function Library:DeleteConfig(name)
	name = cleanName(name)
	if not ensureFolders() or typeof(delfile) ~= "function" then return false, "file functions unavailable" end
	local path = self.Directory .. "/configs/" .. name .. ".json"
	if not isfile(path) then return false, "config not found" end
	delfile(path)
	-- don't leave autoload pointing at a file that's gone
	if self:GetAutoload() == name then self:SetAutoload("") end
	if self:GetGameAutoload() == name then self:SetGameAutoload("") end
	if self._activeConfig == name then self._activeConfig = nil end
	return true
end

function Library:ReadConfig(name)
	if not ensureFolders() then return nil end
	local path = self.Directory .. "/configs/" .. cleanName(name) .. ".json"
	return isfile(path) and readfile(path) or nil
end

function Library:RenameConfig(old, new)
	old, new = cleanName(old), cleanName(new)
	if new == "" then return false, "empty name" end
	local data = self:ReadConfig(old)
	if not data then return false, "config not found" end
	if self:ConfigExists(new) then return false, '"' .. new .. '" already exists' end
	writefile(self.Directory .. "/configs/" .. new .. ".json", data)
	if typeof(delfile) == "function" then delfile(self.Directory .. "/configs/" .. old .. ".json") end
	if self:GetAutoload() == old then self:SetAutoload(new) end
	if self:GetGameAutoload() == old then self:SetGameAutoload(new) end
	if self._activeConfig == old then self._activeConfig = new end
	return true
end

function Library:DuplicateConfig(name)
	local data = self:ReadConfig(name)
	if not data then return false, "config not found" end
	local base = cleanName(name) .. " copy"
	local new, n = base, 2
	while self:ConfigExists(new) do new = base .. " " .. n; n += 1 end
	writefile(self.Directory .. "/configs/" .. new .. ".json", data)
	return true, new
end

-- export copies the config JSON to the clipboard; import takes pasted JSON
function Library:ExportConfig(name)
	local data = name and self:ReadConfig(name) or self:GetConfig()
	if not data then return false, "config not found" end
	if not setClipboard(data) then return false, "clipboard not available" end
	return true
end

function Library:ImportConfig(name, json)
	name = cleanName(name)
	if name == "" then return false, "empty name" end
	local ok, data = pcall(function() return HttpService:JSONDecode(json) end)
	if not ok or type(data) ~= "table" then return false, "that isn't valid config text" end
	if not ensureFolders() then return false, "file functions unavailable" end
	writefile(self.Directory .. "/configs/" .. name .. ".json", json)
	return true
end

function Library:ConfigExists(name)
	if not ensureFolders() then return false end
	return isfile(self.Directory .. "/configs/" .. cleanName(name) .. ".json")
end

function Library:ListConfigs() return listJson("configs") end

function Library:GetAutoload()
	if not ensureFolders() then return "" end
	local p = self.Directory .. "/autoload.txt"
	return isfile(p) and readfile(p) or ""
end

function Library:SetAutoload(name)
	if not ensureFolders() then return false end
	writefile(self.Directory .. "/autoload.txt", cleanName(name))
	return true
end

-- Per-game autoload: one config per game (kept in autoload_<game id>.txt). When the game you
-- are in has one, LoadAutoload loads it instead of the general autoload config.
local function gameKey()
	local ok, id = pcall(function() return game.GameId end)
	if ok and type(id) == "number" and id > 0 then return tostring(id) end
	ok, id = pcall(function() return game.PlaceId end)
	if ok and type(id) == "number" and id > 0 then return tostring(id) end
	return nil
end

function Library:GetGameAutoload()
	local id = gameKey()
	if not id or not ensureFolders() then return "" end
	local p = self.Directory .. "/autoload_" .. id .. ".txt"
	return isfile(p) and readfile(p) or ""
end

function Library:SetGameAutoload(name)
	local id = gameKey()
	if not id then return false, "this game has no id" end
	if not ensureFolders() then return false, "file functions unavailable" end
	writefile(self.Directory .. "/autoload_" .. id .. ".txt", cleanName(name))
	return true
end

function Library:LoadAutoload()
	local name = self:GetGameAutoload()
	if name == "" or not self:ConfigExists(name) then name = self:GetAutoload() end
	if name == "" then return false, "none" end
	local ok, err = self:LoadConfig(name)
	return ok, ok and name or err
end

function Library:GetThemeJson()
	local out = { Font = Theme.FontName }
	for _, key in ipairs(ThemeKeys) do out[key] = Theme[key]:ToHex() end
	return HttpService:JSONEncode(out)
end

function Library:SaveTheme(name)
	name = cleanName(name)
	if not ensureFolders() then return false, "file functions unavailable" end
	if name == "" then return false, "empty name" end
	writefile(self.Directory .. "/themes/" .. name .. ".json", self:GetThemeJson())
	return true
end

function Library:LoadTheme(name)
	name = cleanName(name)
	if not ensureFolders() then return false, "file functions unavailable" end
	local path = self.Directory .. "/themes/" .. name .. ".json"
	if not isfile(path) then return false, "theme not found" end
	local ok, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
	if not ok then return false, "bad json" end
	return self:ApplyTheme(data)
end

function Library:ListThemes() return listJson("themes") end

---------------------------------------------------------------- embedded icons
-- White-on-transparent 256x256 PNGs stored as base64. On first use each one is decoded,
-- written to workspace/<Directory>/assets and loaded with getcustomasset, so it renders at full
-- resolution and can be tinted with ImageColor3. Where that isn't possible (Studio) pages fall back
-- to a text glyph. Add your own: Library.Icons.myicon = "<base64 png>" then Icon = "myicon".
Library.Icons = {
	settings = "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",
	movement = "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",
	combat = "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",
	visuals = "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",
	paw = "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",
}
local ICON_VERSION = 1 -- bump when icon data changes so stale cached files get rewritten

local B64_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function b64decode(data)
	-- executor builtins first (fast), pure Luau fallback after
	local builtins = {
		function() return crypt.base64decode(data) end,
		function() return crypt.base64_decode(data) end,
		function() return base64_decode(data) end,
		function() return base64.decode(data) end,
	}
	for _, fn in ipairs(builtins) do
		local ok, out = pcall(fn)
		if ok and type(out) == "string" and #out > 0 then return out end
	end
	local map = {}
	for i = 1, 64 do map[B64_CHARS:byte(i)] = i - 1 end
	local out, bits, nbits = table.create(math.floor(#data * 3 / 4)), 0, 0
	for i = 1, #data do
		local v = map[data:byte(i)]
		if v then
			bits = bits * 64 + v
			nbits += 6
			if nbits >= 8 then
				nbits -= 8
				local p = 2 ^ nbits
				table.insert(out, string.char(math.floor(bits / p) % 256))
				bits = bits % p
			end
		end
	end
	return table.concat(out)
end

local iconCache = {}
function Library:GetIcon(name)
	if not name then return nil end
	if iconCache[name] ~= nil then return iconCache[name] or nil end
	local data = self.Icons[name]
	local getasset = getcustomasset or getsynasset
	if not data or not FS.ok or typeof(getasset) ~= "function" then
		iconCache[name] = false
		return nil
	end
	local ok, asset = pcall(function()
		ensureFolders()
		local path = self.Directory .. "/assets/" .. name .. "_v" .. ICON_VERSION .. ".png"
		if not isfile(path) then writefile(path, b64decode(data)) end
		return getasset(path)
	end)
	iconCache[name] = (ok and type(asset) == "string" and asset ~= "") and asset or false
	return iconCache[name] or nil
end

---------------------------------------------------------------- tooltips
-- hover any element with Tooltip = "..." for ~0.4s
local tipToken = 0
function Library:_tooltip()
	if self._tip and self._tip.Parent then return self._tip end
	local tipStroke = stroke()
	local tip = create("TextLabel", {
		Visible = false, Size = UDim2.fromOffset(0, 0), AutomaticSize = Enum.AutomaticSize.XY, TextSize = 12,
		Font = Theme.Font, ZIndex = 400, Themed = { BackgroundColor3 = "Card", TextColor3 = "Text" }, Parent = self:_getGui(),
	}, { corner(6), tipStroke, padding(5, 9, 5, 9) })
	self._tipStroke = tipStroke
	onRenderStepped(function()
		if tip.Visible then
			-- the hovered element was hidden/removed under the mouse (no MouseLeave comes then)
			local owner = Library._tipOwner
			if owner and (not owner.Parent or not visibleOnScreen(owner)) then
				tip.Visible = false
				return
			end
			local m = mousePos()
			tip.Position = UDim2.fromOffset(m.X + 14, m.Y + 16)
		end
	end)
	self._tip = tip
	return tip
end

function Library:AttachTooltip(gui, text)
	if not text or text == "" then return end
	gui.MouseEnter:Connect(function()
		tipToken += 1
		local my = tipToken
		task.delay(0.4, function()
			if my ~= tipToken or Library.Unloaded then return end
			local tip = Library:_tooltip()
			Library._tipOwner = gui
			tip.Text = text
			-- place it at the mouse before showing (no jump from where it was last time), then fade in
			local m = mousePos()
			tip.Position = UDim2.fromOffset(m.X + 14, m.Y + 16)
			tip.BackgroundTransparency, tip.TextTransparency = 1, 1
			Library._tipStroke.Transparency = 1
			tip.Visible = true
			tween(tip, 0.12, { BackgroundTransparency = 0, TextTransparency = 0 }, Enum.EasingStyle.Quad)
			tween(Library._tipStroke, 0.12, { Transparency = 0 }, Enum.EasingStyle.Quad)
		end)
	end)
	gui.MouseLeave:Connect(function()
		tipToken += 1
		if Library._tip then Library._tip.Visible = false end
	end)
end

---------------------------------------------------------------- notifications
local NotifColors = { success = rgb(80, 220, 120), error = rgb(255, 85, 85), warning = rgb(255, 185, 60) }

function Library:Notify(o)
	if self.Unloaded then return { Close = function() end } end
	if type(o) == "string" then o = { Title = "Notice", Text = o } end
	o = o or {}
	-- raised by a callback while a config is being applied: skip (errors still get through)
	if self._applyingConfig and o.Type ~= "error" then return { Close = function() end } end
	self:_getGui()

	-- the same notification again while it's still on screen: bump its counter and restart its
	-- timer instead of stacking a copy
	local title, text = tostring(o.Title or "Notice"), tostring(o.Text or "")
	local key = tostring(o.Type or "") .. "\0" .. title .. "\0" .. text
	self._notifKeys = self._notifKeys or {}
	local existing = self._notifKeys[key]
	if existing then return existing.bump(o) end

	-- explicit order: with equal LayoutOrders the list doesn't promise to keep arrival order
	self._notifCount = (self._notifCount or 0) + 1
	local outer = create("Frame", {
		Size = UDim2.fromOffset(260, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
		LayoutOrder = self._notifCount, Parent = self._notifHolder,
	})
	local card = create("Frame", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UDim2.fromOffset(280 * (Library._notifSide or 1), 0),
		Themed = { BackgroundColor3 = "Card" }, Parent = outer,
	}, { corner(8), stroke() })
	local typeColor = NotifColors[o.Type or ""]
	local accentThemed = (not typeColor) and { BackgroundColor3 = "Accent" } or nil
	local body = create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = card }, { padding(11, 14, 22, 14), list(5) })
	local head = create("Frame", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, LayoutOrder = 1, Parent = body })
	-- icon: embedded image when given (o.Icon), otherwise a colored dot
	local iconAsset = o.Icon and Library:GetIcon(o.Icon)
	if iconAsset then
		create("ImageLabel", {
			AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1,
			Image = iconAsset, ScaleType = Enum.ScaleType.Fit, ImageColor3 = typeColor or Theme.Accent,
			Themed = (not typeColor) and { ImageColor3 = "Accent" } or nil, Parent = head,
		})
	else
		create("Frame", {
			AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0), Size = UDim2.fromOffset(8, 8),
			BackgroundColor3 = typeColor or Theme.Accent, Themed = accentThemed, Parent = head,
		}, { corner(4) })
	end
	textLabel({
		Position = UDim2.fromOffset(24, 0), Size = UDim2.new(1, -74, 1, 0), Text = title, Bold = true, TextSize = 14,
		TextTruncate = Enum.TextTruncate.AtEnd, Parent = head,
	})
	-- "x2", "x3"... shown once the same notification repeats
	local repeatLabel = textLabel({
		AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -22, 0, 0), Size = UDim2.fromOffset(26, 18), Text = "", TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right, Visible = false, Themed = { TextColor3 = "SubText" }, Parent = head,
	})
	local closeBtn = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 4, 0.5, 0), Size = UDim2.fromOffset(20, 20),
		BackgroundTransparency = 1, AutoButtonColor = false, Text = "x", TextSize = 13, Bold = true,
		Themed = { TextColor3 = "SubText" }, Parent = head,
	})
	-- text on the left, live countdown on the right
	local line = create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = 2, Parent = body })
	textLabel({
		Size = UDim2.new(1, -48, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = text, TextSize = 12,
		TextWrapped = true, Themed = { TextColor3 = "SubText" }, Parent = line,
	})
	local countdown = textLabel({
		AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0), Size = UDim2.fromOffset(44, 14), TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right, Themed = { TextColor3 = "SubText" }, Parent = line,
	})
	local barTrack = create("Frame", {
		AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 14, 1, -10), Size = UDim2.new(1, -28, 0, 3),
		BorderSizePixel = 0, BackgroundTransparency = 1, Parent = card,
	})
	local timer = create("Frame", {
		Size = UDim2.fromScale(1, 1), BorderSizePixel = 0, BackgroundColor3 = typeColor or Theme.Accent, Themed = accentThemed, Parent = barTrack,
	}, { corner(2) })

	local dur = math.max(tonumber(o.Duration) or 3, 0.1)
	local remaining = dur
	local closed = false
	local handle = {}
	local entry = {}
	local function close()
		if closed then return end
		closed = true
		local i = table.find(Library._notifs, close)
		if i then table.remove(Library._notifs, i) end
		if Library._notifKeys[key] == entry then Library._notifKeys[key] = nil end
		tween(card, 0.3, { Position = UDim2.fromOffset(280 * (Library._notifSide or 1), 0) }, Enum.EasingStyle.Quad)
		task.delay(0.3, function() outer:Destroy() end)
	end
	handle.Close = close
	local repeats = 1
	function entry.bump(again)
		repeats += 1
		repeatLabel.Text = "x" .. repeats
		repeatLabel.Visible = true
		dur = math.max(tonumber(again.Duration) or dur, 0.1)
		remaining = dur
		return handle
	end
	Library._notifKeys[key] = entry
	-- spamming notifications would stack them off the screen: keep the newest few
	Library._notifs = Library._notifs or {}
	table.insert(Library._notifs, close)
	if #Library._notifs > (Library.MaxNotifications or 6) then Library._notifs[1]() end
	tween(card, 0.4, { Position = UDim2.fromOffset(0, 0) })

	-- hovering pauses the timer. MouseLeave can get skipped, so the flag is double-checked
	-- against where the mouse really is (both measured from the gui's own corner).
	local hovering = false
	card.MouseEnter:Connect(function() hovering = true end)
	card.MouseLeave:Connect(function() hovering = false end)
	local function isHovered()
		if not hovering then return false end
		local gui = Library._gui
		if not gui then return false end
		local m, a, s = mousePos(), card.AbsolutePosition - gui.AbsolutePosition, card.AbsoluteSize
		if m.X < a.X - 8 or m.X > a.X + s.X + 8 or m.Y < a.Y - 8 or m.Y > a.Y + s.Y + 8 then hovering = false end
		return hovering
	end
	-- the bar is a timer, so it is driven by hand: it keeps counting with Animations off
	-- and can stand still while the notification is hovered
	task.spawn(function()
		local last = os.clock()
		local shown
		while not closed and not Library.Unloaded do
			local now = os.clock()
			local paused = isHovered()
			if not paused then remaining -= now - last end
			last = now
			local left = math.max(remaining, 0)
			timer.Size = UDim2.fromScale(math.min(left / dur, 1), 1)
			timer.BackgroundTransparency = paused and 0.5 or 0
			local label = (left >= 10 and string.format("%ds", math.ceil(left)) or string.format("%.1fs", left)):gsub("%.0s$", "s")
			if label ~= shown then
				shown = label
				countdown.Text = label
			end
			if left <= 0 then
				close()
				break
			end
			task.wait()
		end
	end)
	-- click the x (or anywhere on the card) to dismiss early
	closeBtn.MouseEnter:Connect(function() closeBtn.TextColor3 = Theme.Text end)
	closeBtn.MouseLeave:Connect(function() closeBtn.TextColor3 = Theme.SubText end)
	closeBtn.MouseButton1Click:Connect(close)
	card.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then close() end
	end)
	return handle
end

---------------------------------------------------------------- context menu
local ContextMenu

function Library:CloseContextMenu()
	local menu = ContextMenu
	if not menu then return end
	ContextMenu = nil
	self._ctxHover = false
	-- fade out at full size (no shrink), then remove. Item clicks check ContextMenu == menu,
	-- so nothing in a closing menu can run its action
	fadeOut(menu, 0.1).Completed:Connect(function() menu:Destroy() end)
end

--[[ items: { Text, Hint?, Kind = "radio"|"check"|nil, Checked?, Danger?, Callback } or "-" for a divider ]]
function Library:OpenContextMenu(title, items)
	local gui = self:_getGui()
	if not gui then return nil end
	if ContextMenu then ContextMenu:Destroy(); ContextMenu = nil end

	if not self._ctxHooked then
		self._ctxHooked = true
		connect(UserInputService.InputBegan, function(input)
			if not ContextMenu then return end
			local t = input.UserInputType
			if (t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.MouseButton2 or t == Enum.UserInputType.Touch)
				and not Library._ctxHover then
				Library:CloseContextMenu()
			elseif input.KeyCode == Enum.KeyCode.Escape then
				Library:CloseContextMenu()
			end
		end)
	end

	local m = mousePos()
	local menu = create("Frame", {
		Position = UDim2.fromOffset(m.X + 4, m.Y + 4), Size = UDim2.fromOffset(190, 0), AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 200, Themed = { BackgroundColor3 = "Card" }, Parent = gui,
	}, { corner(8), stroke(), padding(6), list(2) })
	self._ctxHover = false
	-- only the live menu counts as hovered (a fading one is destroyed without a MouseLeave)
	menu.MouseEnter:Connect(function() if ContextMenu == menu then Library._ctxHover = true end end)
	menu.MouseLeave:Connect(function() if ContextMenu == menu then Library._ctxHover = false end end)
	ContextMenu = menu
	local hg = hoverGroup()
	menu.MouseLeave:Connect(function() hg:clear() end)

	if title then
		local head = textLabel({ Size = UDim2.new(1, 0, 0, 22), Text = string.upper(title), Bold = true, TextSize = 11, LayoutOrder = 0, Themed = { TextColor3 = "SubText" }, Parent = menu })
		padding(0, 8, 0, 0).Parent = head
	end

	for i, item in ipairs(items) do
		if item == "-" then
			local d = create("Frame", { Size = UDim2.new(1, 0, 0, 7), BackgroundTransparency = 1, LayoutOrder = i, Parent = menu })
			create("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 6, 0.5, 0), Size = UDim2.new(1, -12, 0, 1), BorderSizePixel = 0, Themed = { BackgroundColor3 = "Stroke" }, Parent = d })
		else
			local b = create("TextButton", {
				Size = UDim2.new(1, 0, 0, item.Hint and 34 or 26), BackgroundTransparency = item.Checked and item.Kind == "radio" and 0.4 or 1,
				Text = "", AutoButtonColor = false, LayoutOrder = i, Themed = { BackgroundColor3 = "Element" }, Parent = menu,
			}, { corner(6) })
			local x = 10
			if item.Kind == "radio" then
				-- selected option = solid filled circle, others = empty ring
				create("Frame", {
					AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 9, 0.5, 0), Size = UDim2.fromOffset(10, 10),
					BackgroundColor3 = Theme.Accent, BackgroundTransparency = item.Checked and 0 or 1, Parent = b,
				}, {
					corner(5), create("UIStroke", { Thickness = 1, Color = item.Checked and Theme.Accent or Theme.SubText }),
				})
				x = 28
			elseif item.Kind == "check" then
				create("Frame", {
					AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 9, 0.5, 0), Size = UDim2.fromOffset(10, 10),
					BackgroundColor3 = item.Checked and Theme.Accent or Theme.Element, Parent = b,
				}, { corner(3), create("UIStroke", { Thickness = 1, Color = item.Checked and Theme.Accent or Theme.SubText }) })
				x = 28
			end
			local textColor = item.Danger and rgb(255, 95, 95) or ((item.Checked and item.Kind == "radio") and Theme.Accent or Theme.Text)
			textLabel({
				Position = UDim2.fromOffset(x, item.Hint and 4 or 0), Size = UDim2.new(1, -x, 0, item.Hint and 15 or 26),
				Text = tostring(item.Text or ""), Themed = { Font = "Font" }, TextColor3 = textColor, Parent = b,
			})
			if item.Hint then
				textLabel({ Position = UDim2.fromOffset(x, 18), Size = UDim2.new(1, -x, 0, 12), Text = item.Hint, TextSize = 10, Themed = { Font = "Font" }, TextColor3 = Theme.SubText, Parent = b })
			end
			local rest = b.BackgroundTransparency
			hg:bind(b, function() tween(b, 0.1, { BackgroundTransparency = 0 }) end, function() tween(b, 0.1, { BackgroundTransparency = rest }) end)
			b.MouseButton1Click:Connect(function()
				if ContextMenu ~= menu then return end -- menu is already fading out
				Library:CloseContextMenu()
				fire(item.Callback)
			end)
		end
	end

	fadeIn(menu, 0.12) -- full size from the start; no scale pop
	task.defer(function()
		if not menu.Parent then return end
		-- measure relative to the gui: AbsolutePosition may be counted from below the topbar
		-- inset while Position offsets (IgnoreGuiInset gui) start at the very top of the screen,
		-- so writing AbsolutePosition back as an offset would make the menu jump up
		local vp = gui.AbsoluteSize
		local p, s = menu.AbsolutePosition - gui.AbsolutePosition, menu.AbsoluteSize
		local nx = (p.X + s.X > vp.X - 8) and (m.X - s.X - 4) or p.X
		local ny = (p.Y + s.Y > vp.Y - 8) and (vp.Y - s.Y - 8) or p.Y
		menu.Position = UDim2.fromOffset(math.max(nx, 8), math.max(ny, 8))
	end)
	return menu
end

---------------------------------------------------------------- dialog
-- modal over the window: Library:Dialog{ Title, Text, Buttons = { {Text, Callback, Style} } }
function Library:Dialog(o)
	o = o or {}
	if self.Unloaded then return { Close = function() end } end
	-- over the window when it's open; full screen when the window is hidden (or there is none),
	-- otherwise the dialog would be invisible but still answer to Enter / Escape
	local win = self.Window
	local inWindow = win and win.Main and win._open
	local parent = inWindow and win.Main or self:_getGui()
	local overlay = create("TextButton", {
		Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1,
		Text = "", AutoButtonColor = false, ZIndex = 60, Parent = parent,
	}, { corner(10) })
	-- the whole card is one CanvasGroup so it fades as a single piece (no per-child pop-in).
	-- Its 1px border is the group's own background showing around an inset frame, because a
	-- UIStroke would be clipped by the group.
	local shell = create("CanvasGroup", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 12), Size = UDim2.fromOffset(o.Width or 310, 0),
		AutomaticSize = Enum.AutomaticSize.Y, Active = true, ZIndex = 61, GroupTransparency = 1,
		Themed = { BackgroundColor3 = "Stroke" }, Parent = overlay,
	}, { corner(10), padding(1) })
	local card = create("Frame", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Active = true,
		Themed = { BackgroundColor3 = "Card" }, Parent = shell,
	}, { corner(9), padding(16, 18, 16, 18), list(8) })

	textLabel({ Size = UDim2.new(1, 0, 0, 20), Text = o.Title or "Are you sure?", Bold = true, TextSize = 15, LayoutOrder = 1, Parent = card })
	if o.Text then
		textLabel({
			Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = o.Text, TextSize = 13, TextWrapped = true,
			LayoutOrder = 2, Themed = { TextColor3 = "SubText" }, Parent = card,
		})
	end
	-- optional text field: Input = { Placeholder, Default }; button callbacks then get the text
	local input
	if o.Input then
		local inStroke = stroke()
		input = create("TextBox", {
			Size = UDim2.new(1, 0, 0, 30), Text = o.Input.Default or "", PlaceholderText = o.Input.Placeholder or "", TextSize = 13,
			ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 3,
			Themed = { BackgroundColor3 = "Element", TextColor3 = "Text", PlaceholderColor3 = "SubText" }, Parent = card,
		}, { corner(6), inStroke, padding(0, 10, 0, 10) })
		input.Focused:Connect(function() tween(inStroke, 0.15, { Color = Theme.Accent }) end)
		input.FocusLost:Connect(function() tween(inStroke, 0.15, { Color = Theme.Stroke }) end)
		task.defer(function() input:CaptureFocus() end)
	end
	local row = create("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = 4, Parent = card }, {
		list(8, true, { HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Bottom }),
	})
	padding(6, 0, 0, 0).Parent = row

	local closed = false
	local Dialog = {}
	function Dialog:Close()
		if closed then return end
		closed = true
		if Library._dialogs then Library._dialogs[Dialog] = nil end
		if input then input:ReleaseFocus() end
		-- card and backdrop leave together
		tween(overlay, 0.18, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad)
		tween(shell, 0.18, { GroupTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 8) }, Enum.EasingStyle.Quad)
		task.delay(0.2, function() overlay:Destroy() end)
	end

	local buttons = o.Buttons or { { "OK" } }
	local primaryAction
	for i, b in ipairs(buttons) do
		local text, cb, style = tostring(b.Text or b[1] or "OK"), b.Callback or b[2], b.Style or b[3]
		local primary, danger = style == "primary", style == "danger"
		local btn = create("TextButton", {
			Size = UDim2.fromOffset(0, 28), AutomaticSize = Enum.AutomaticSize.X, AutoButtonColor = false, Text = text,
			TextSize = 13, LayoutOrder = i, Parent = row,
			BackgroundColor3 = danger and rgb(200, 60, 60) or Theme.Accent,
			TextColor3 = (primary or danger) and Color3.new(1, 1, 1) or Theme.Text,
			Themed = (not primary and not danger) and { BackgroundColor3 = "Element", TextColor3 = "Text" } or (primary and { BackgroundColor3 = "Accent" } or nil),
		}, { corner(6), padding(0, 14, 0, 14) })
		if not primary and not danger then stroke().Parent = btn else shade(90, 1, 0.8).Parent = btn end
		btn.MouseEnter:Connect(function() tween(btn, 0.12, { BackgroundTransparency = 0.15 }) end)
		btn.MouseLeave:Connect(function() tween(btn, 0.12, { BackgroundTransparency = 0 }) end)
		local function press()
			if closed then return end
			local text = input and input.Text or nil
			Dialog:Close()
			-- run after the close animation so heavy callbacks (unload, file writes) can't stutter it.
			-- Through fire(): an error in the callback becomes a notification, not a console error
			if cb then task.delay(0.2, function() fire(cb, text) end) end
		end
		btn.MouseButton1Click:Connect(press)
		if primary then primaryAction = press end
	end

	if o.Dismissable ~= false then
		overlay.MouseButton1Click:Connect(function() Dialog:Close() end)
	end
	local keyConn
	keyConn = UserInputService.InputBegan:Connect(function(key)
		if closed then keyConn:Disconnect() return end
		-- only react to keys meant for this dialog: not while typing in chat / another box
		local focused = UserInputService:GetFocusedTextBox()
		if focused and focused ~= input then return end
		if key.KeyCode == Enum.KeyCode.Escape and o.Dismissable ~= false then
			Dialog:Close()
		elseif (key.KeyCode == Enum.KeyCode.Return or key.KeyCode == Enum.KeyCode.KeypadEnter) and primaryAction then
			-- called directly: a real Roblox signal has no :Fire(), so firing the click would error
			primaryAction()
		end
	end)
	table.insert(Library.Connections, keyConn)
	-- hiding the menu cancels its dialogs (a hidden dialog could otherwise still be confirmed)
	Library._dialogs = Library._dialogs or {}
	if inWindow then Library._dialogs[Dialog] = true end
	-- fade the backdrop in and float the card up into place
	tween(overlay, 0.25, { BackgroundTransparency = 0.45 }, Enum.EasingStyle.Quad)
	tween(shell, 0.28, { GroupTransparency = 0, Position = UDim2.fromScale(0.5, 0.5) })
	return Dialog
end

---------------------------------------------------------------- keybind list
function Library:CreateKeybindList(o)
	if self.KeyList then return self.KeyList end
	o = o or {}
	local gui = self:_getGui()
	local frame = create("Frame", {
		Position = o.Position or UDim2.new(0, 16, 0.5, -60), Size = UDim2.fromOffset(190, 0), AutomaticSize = Enum.AutomaticSize.Y,
		Themed = { BackgroundColor3 = "Card" }, Parent = gui,
	}, { corner(8), stroke(), padding(8, 10, 8, 10), list(4) })
	local header = create("Frame", { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, LayoutOrder = 0, Parent = frame })
	textLabel({ Size = UDim2.fromScale(1, 1), Text = "KEYBINDS", Bold = true, TextSize = 11, Themed = { TextColor3 = "SubText" }, Parent = header })
	local countLabel = textLabel({
		AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0), Size = UDim2.new(0, 40, 1, 0), Text = "0",
		TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, Themed = { TextColor3 = "Accent" }, Parent = header,
	})
	local empty = textLabel({ Size = UDim2.new(1, 0, 0, 18), Text = "no keys bound", TextSize = 11, LayoutOrder = 99999, Themed = { TextColor3 = "SubText" }, Parent = frame })
	makeDraggable(frame, frame)
	self:_trackPosition(frame, "UI_KeyListPos") -- where you dragged it is saved in configs

	local KeyList = { Frame = frame }
	local entries = {}
	local count = 0
	local function refreshCount()
		local active, shown = 0, 0
		for _, e in ipairs(entries) do
			if e.visible then shown += 1 end
			if e.visible and e.active then active += 1 end
		end
		countLabel.Text = tostring(active)
		empty.Visible = shown == 0
	end

	function KeyList:Add()
		count += 1
		local row = create("Frame", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Visible = false, LayoutOrder = count, Parent = frame })
		local name = textLabel({ Size = UDim2.new(1, -74, 1, 0), TextSize = 12, TextTruncate = Enum.TextTruncate.AtEnd, Parent = row })
		local key = textLabel({ AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0), Size = UDim2.new(0, 74, 1, 0), TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, Parent = row })
		local state = { active = false, visible = false }
		table.insert(entries, state)
		local function color()
			tween(name, 0.15, { TextColor3 = state.active and Theme.Text or Theme.SubText })
			tween(key, 0.15, { TextColor3 = state.active and Theme.Accent or Theme.SubText })
		end
		onTheme(color)
		local Entry = {}
		function Entry:Update(n, k, mode, active, visible)
			state.active, state.visible = active, visible
			name.Text = n
			key.Text = "[" .. k .. "] " .. string.lower(mode)
			row.Visible = visible
			color()
			refreshCount()
		end
		function Entry:Remove()
			local i = table.find(entries, state)
			if i then table.remove(entries, i) end
			row:Destroy()
			refreshCount()
		end
		return Entry
	end
	function KeyList:SetVisible(v) frame.Visible = v end

	refreshCount()
	self.KeyList = KeyList
	for _, refresh in ipairs(self._bindRefreshers) do pcall(refresh) end
	return KeyList
end

---------------------------------------------------------------- watermark
function Library:CreateWatermark(o)
	if self.Watermark then return self.Watermark end
	o = o or {}
	local gui = self:_getGui()
	local frame = create("Frame", {
		Position = o.Position or UDim2.fromOffset(16, 16), Size = UDim2.fromOffset(0, 30), AutomaticSize = Enum.AutomaticSize.X,
		Themed = { BackgroundColor3 = "Card" }, Parent = gui,
	}, { corner(8), stroke(), padding(0, 12, 0, 12), list(8, true, { VerticalAlignment = Enum.VerticalAlignment.Center }) })
	local logoAsset = self:GetIcon(o.Icon or "paw")
	local logoImg
	if logoAsset then
		logoImg = create("ImageLabel", {
			Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1, Image = logoAsset, ScaleType = Enum.ScaleType.Fit,
			LayoutOrder = 1, Themed = { ImageColor3 = "Accent" }, Parent = frame,
		})
	end
	local label = textLabel({ Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, RichText = true, TextSize = 12, LayoutOrder = 2, Parent = frame })
	makeDraggable(frame, frame)
	self:_trackPosition(frame, "UI_WatermarkPos") -- where you dragged it is saved in configs

	local Watermark = { Frame = frame, Title = o.Title or "SleekUI", Show = { FPS = true, Ping = true, Time = true } }
	if o.Show then for k, v in pairs(o.Show) do Watermark.Show[k] = v end end

	local frames, fps, last = 0, 0, os.clock()
	onRenderStepped(function()
		frames += 1
		local now = os.clock()
		if now - last >= 0.5 then
			fps = math.floor(frames / (now - last) + 0.5)
			frames, last = 0, now
		end
	end)

	local function render()
		-- the logo follows the accent together with the title (set here as well as through the
		-- theme registry, so the two can never end up in different colours)
		if logoImg then logoImg.ImageColor3 = Theme.Accent end
		local sep = string.format('  <font color="#%s">/</font>  ', Theme.Stroke:ToHex())
		local parts = { string.format('<font color="#%s"><b>%s</b></font>', Theme.Accent:ToHex(), escapeRich(Watermark.Title)) }
		if Watermark.Show.FPS then table.insert(parts, fps .. " fps") end
		if Watermark.Show.Ping then
			-- GetNetworkPing = pure network round trip (what the game's ping shows).
			-- "Data Ping" also counts server/client processing + queueing, so it reads ~2x higher.
			local ok, ping = pcall(function() return math.floor(Players.LocalPlayer:GetNetworkPing() * 1000 + 0.5) end)
			if not ok then
				ok, ping = pcall(function() return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
			end
			table.insert(parts, (ok and ping or 0) .. " ms")
		end
		if Watermark.Show.Time then table.insert(parts, os.date("%H:%M:%S")) end
		label.Text = table.concat(parts, sep)
	end
	task.spawn(function()
		while frame.Parent do
			render()
			task.wait(0.5)
		end
	end)
	onTheme(render)

	function Watermark:SetTitle(t) Watermark.Title = t; render() end
	function Watermark:SetVisible(v) frame.Visible = v end
	self.Watermark = Watermark
	return Watermark
end

---------------------------------------------------------------- shared builders
-- key chip used by Section:AddKeybind, Toggle:AddKeybind and Label:AddKeybind
-- right-click the chip for: mode (Toggle / Hold / Always), show in keybind list, rebind, clear
local VALID_MODES = { Toggle = true, Hold = true, Always = true }
-- every key chip that exists, so a new bind can be checked against the keys already taken
Library._binds = {}
local function bindsSharing(key, except)
	local names = {}
	if not key then return names end
	for _, b in ipairs(Library._binds) do
		-- skip itself, removed chips, and "Always" binds (those ignore their key)
		if b ~= except and b.state.Key == key and b.state.Mode ~= "Always" and b.box.Parent then
			table.insert(names, tostring(b.name))
		end
	end
	return names
end
local function sharedText(names)
	local shown = {}
	for i = 1, math.min(#names, 3) do shown[i] = names[i] end
	local text = table.concat(shown, ", ")
	if #names > 3 then text ..= " +" .. (#names - 3) .. " more" end
	return text
end

local function buildKeyChip(parent, o, layoutOrder)
	local state = { __keybind = true, Key = parseKey(o.Default), Mode = VALID_MODES[o.Mode] and o.Mode or "Toggle", Active = false, ShowInList = o.ShowInList ~= false }
	if state.Mode == "Always" then state.Active = true end
	local listening = false

	local bStroke = stroke()
	local box = create("TextButton", {
		Size = UDim2.fromOffset(0, 20), AutomaticSize = Enum.AutomaticSize.X, AutoButtonColor = false, RichText = true,
		TextSize = 11, Text = "", LayoutOrder = layoutOrder or 1,
		Themed = { BackgroundColor3 = "Element", TextColor3 = "SubText" }, Parent = parent,
	}, { corner(5), bStroke, padding(0, 8, 0, 8) })
	blockRowContext(box)

	local entry
	local Bind = { State = state, Box = box }
	local registered = { state = state, box = box, name = o.Name or "Keybind" }
	table.insert(Library._binds, registered)

	-- the list entry is created lazily, so binds made before CreateKeybindList still appear
	local function updateEntry()
		if not entry and Library.KeyList then entry = Library.KeyList:Add() end
		if entry then
			entry:Update(o.Name or "Keybind", keyName(state.Key), state.Mode, state.Active, state.Key ~= nil and state.ShowInList)
		end
	end
	table.insert(Library._bindRefreshers, updateEntry)
	local dots = 0
	local function render()
		if listening then
			box.Text = string.rep(".", dots % 3 + 1)
		elseif state.Mode ~= "Toggle" and not o.NoModes then
			box.Text = string.format('%s <font size="9" color="#%s">%s</font>', keyName(state.Key), Theme.Accent:ToHex(), string.lower(state.Mode))
		else
			box.Text = keyName(state.Key)
		end
		bStroke.Color = listening and Theme.Accent or Theme.Stroke
		box.TextColor3 = (listening or state.Active) and Theme.Text or Theme.SubText
		updateEntry()
	end
	onTheme(render)

	local function syncFlag()
		if o.Flag then Library.Flags[o.Flag] = state end
	end

	function Bind:SetActive(a, silent)
		a = a and true or false
		if state.Mode == "Always" then a = true end
		if state.Active == a then render(); return end
		state.Active = a
		syncFlag()
		render()
		if not silent then fire(o.Callback, a) end
	end

	function Bind:Set(v, silent)
		local oldKey = state.Key
		local newMode
		if typeof(v) == "table" then -- a saved {Key, Mode} table (EnumItems are not plain tables)
			state.Key = parseKey(v.Key)
			if VALID_MODES[v.Mode] and v.Mode ~= state.Mode and not o.NoModes then newMode = v.Mode end
			if v.ShowInList ~= nil then state.ShowInList = v.ShowInList end
		else
			state.Key = parseKey(v)
		end
		listening = false
		-- go through SetMode so the active state (and an attached toggle) follow the new mode
		if newMode then Bind:SetMode(newMode) end
		syncFlag()
		render()
		-- little pulse so you see it took
		box.Size = UDim2.fromOffset(0, 22)
		tween(box, 0.25, { Size = UDim2.fromOffset(0, 20) }, Enum.EasingStyle.Back)
		-- Changed means the key changed: reloading the same key (config load) stays quiet
		if not silent and state.Key ~= oldKey then fire(o.Changed, state.Key) end
	end

	function Bind:SetMode(m)
		if not VALID_MODES[m] then return end
		local prev = state.Mode
		state.Mode = m
		if m == "Always" then
			Bind:SetActive(true)
		elseif m == "Hold" or prev == "Always" then
			Bind:SetActive(false)
		end
		syncFlag()
		render()
	end
	function Bind:SetShowInList(b)
		state.ShowInList = b and true or false
		syncFlag()
		render()
	end
	function Bind:Get() return state.Key end

	local function startListening()
		listening = true
		Library._binding = true
		render()
		task.spawn(function()
			while listening and box.Parent do
				dots += 1
				render()
				task.wait(0.3)
			end
			-- key box removed while waiting: don't leave every other key blocked
			if listening and not box.Parent then listening = false; Library._binding = false end
		end)
	end

	box.MouseButton1Click:Connect(startListening)
	box.MouseButton2Click:Connect(function()
		local items = {}
		if not o.NoModes then
			table.insert(items, { Text = "Toggle", Hint = "press to switch on / off", Kind = "radio", Checked = state.Mode == "Toggle", Callback = function() Bind:SetMode("Toggle") end })
			table.insert(items, { Text = "Hold", Hint = "on only while held", Kind = "radio", Checked = state.Mode == "Hold", Callback = function() Bind:SetMode("Hold") end })
			table.insert(items, { Text = "Always", Hint = "always on, key ignored", Kind = "radio", Checked = state.Mode == "Always", Callback = function() Bind:SetMode("Always") end })
			table.insert(items, "-")
		end
		if Library.KeyList and o.ShowInList ~= false then
			table.insert(items, { Text = "Show in keybind list", Kind = "check", Checked = state.ShowInList, Callback = function() Bind:SetShowInList(not state.ShowInList) end })
			table.insert(items, "-")
		end
		local shared = bindsSharing(state.Key, registered)
		if #shared > 0 then
			table.insert(items, { Text = "Key shared with", Hint = sharedText(shared) })
			table.insert(items, "-")
		end
		table.insert(items, { Text = "Rebind", Callback = startListening })
		table.insert(items, { Text = "Clear key", Danger = true, Callback = function() Bind:Set(nil) end })
		Library:OpenContextMenu(o.Name or "Keybind", items)
	end)

	connect(UserInputService.InputBegan, function(input, gp)
		if listening then
			local t = input.UserInputType
			local k
			-- Escape, or a click somewhere else, cancels and keeps the old key
			if (t == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Escape)
				or t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.MouseButton2 then
				listening = false
				render()
				task.defer(function() Library._binding = false end)
				return
			end
			if t == Enum.UserInputType.Keyboard then
				k = input.KeyCode
				if k == Enum.KeyCode.Backspace then k = nil end -- Backspace clears the key
			elseif t == Enum.UserInputType.MouseButton3 then
				k = t
			else
				return -- mouse movement, wheel, etc.
			end
			Bind:Set(k)
			task.defer(function() Library._binding = false end)
			-- picked a key another feature already uses: say which, so two things never fire
			-- together by accident (Library.KeyConflictWarnings = false turns this off)
			local shared = bindsSharing(k, registered)
			if #shared > 0 and Library.KeyConflictWarnings ~= false then
				Library:Notify({
					Title = "Key already in use", Type = "warning", Duration = 4,
					Text = keyName(k) .. " is also bound to " .. sharedText(shared),
				})
			end
			return
		end
		if UserInputService:GetFocusedTextBox() then return end
		if Library._binding then return end -- another key box is waiting for this key
		-- greyed out (SetDisabled / section switched off): the key does nothing either
		if Bind.Disabled or (o._isDisabled and o._isDisabled()) then return end
		-- Ctrl+F is the window's search shortcut, not a press of a bind on F
		if input.KeyCode == Enum.KeyCode.F and Library.Window and Library.Window._open
			and (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
			return
		end
		if input.UserInputType == Enum.UserInputType.Keyboard and gp then return end
		if inputMatches(input, state.Key) then
			fire(o.Pressed)
			if state.Mode == "Toggle" then Bind:SetActive(not state.Active)
			elseif state.Mode == "Hold" then Bind:SetActive(true) end
		end
	end)
	onInputEnded(function(input)
		if state.Mode == "Hold" and inputMatches(input, state.Key) then Bind:SetActive(false) end
	end)

	registerFlag(o, function(v) Bind:Set(v) end, state)
	render()
	return Bind
end

-- color swatch + expandable picker panel (SV square, hue bar, optional alpha bar, hex box)
-- Recently used colours, shared by every picker: newest first, at most 8, shown as a row of
-- small squares in the picker panel and remembered between sessions (recent_colors.json).
-- Only colours the user picked by hand get in, not ones set by a script or a config.
local RECENT_MAX = 8
local function recentColors()
	if Library._recentColors then return Library._recentColors end
	local out = {}
	pcall(function()
		if not ensureFolders() then return end
		local p = Library.Directory .. "/recent_colors.json"
		if not isfile(p) then return end
		local data = HttpService:JSONDecode(readfile(p))
		if type(data) ~= "table" then return end
		for _, code in ipairs(data) do
			if #out < RECENT_MAX and type(code) == "string" and pcall(Color3.fromHex, code) then table.insert(out, code) end
		end
	end)
	Library._recentColors = out
	return out
end
local function rememberColor(c)
	local recent = recentColors()
	local code = c:ToHex()
	for i = #recent, 1, -1 do
		if recent[i] == code then table.remove(recent, i) end
	end
	table.insert(recent, 1, code)
	while #recent > RECENT_MAX do table.remove(recent) end
	pcall(function()
		if ensureFolders() then writefile(Library.Directory .. "/recent_colors.json", HttpService:JSONEncode(recent)) end
	end)
end

local function buildColorPicker(section, swatchParent, panelOrder, o)
	o = o or {}
	-- Default may be a Color3, a hex string ("#ff0000") or { r, g, b } (0-255)
	local default = o.Default
	if type(default) == "string" then
		local ok, c = pcall(Color3.fromHex, default)
		default = ok and c or nil
	elseif type(default) == "table" then
		default = Color3.fromRGB(tonumber(default[1]) or 255, tonumber(default[2]) or 255, tonumber(default[3]) or 255)
	end
	if typeof(default) ~= "Color3" then default = Color3.new(1, 1, 1) end
	local color = default
	local h, s, v = color:ToHSV()
	-- every picker gets the transparency bar; NoTransparency = true hides it (theme colors use that)
	local hasAlpha = o.NoTransparency ~= true
	local alpha = o.Transparency or 0
	local defaultAlpha = alpha
	local rainbow = false
	local open = false
	local PANEL_H = hasAlpha and 170 or 154 -- the last 20px are the row of recent colours

	local swatchHolder = create("Frame", { Size = UDim2.fromOffset(28, 16), BackgroundTransparency = 1, LayoutOrder = 2, Parent = swatchParent })
	-- dark backing so transparency is visible on the swatch
	create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = rgb(20, 20, 20), Parent = swatchHolder }, { corner(4) })
	local swatch = create("TextButton", {
		Size = UDim2.fromScale(1, 1), BackgroundColor3 = color, BackgroundTransparency = alpha * 0.85, Text = "", AutoButtonColor = false, Parent = swatchHolder,
	}, { corner(4), stroke() })
	blockRowContext(swatch)

	local panel = create("Frame", { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, ClipsDescendants = true, Visible = false, LayoutOrder = panelOrder, Parent = section.Frame })
	local inner = create("Frame", { Position = UDim2.fromOffset(6, 2), Size = UDim2.new(1, -12, 0, PANEL_H - 6), Themed = { BackgroundColor3 = "Element" }, Parent = panel }, { corner(6), stroke() })

	local sv = create("Frame", { Position = UDim2.fromOffset(6, 6), Size = UDim2.new(1, -36, 0, 92), BackgroundColor3 = Color3.fromHSV(h, 1, 1), Parent = inner }, { corner(4) })
	create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = sv }, {
		corner(4), create("UIGradient", { Transparency = NumberSequence.new(0, 1) }),
	})
	create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, Parent = sv }, {
		corner(4), create("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(1, 0) }),
	})
	local svHit = create("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 4, Parent = sv })
	local svCursor = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(12, 12), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 5, Parent = sv,
	}, { corner(6), create("UIStroke", { Color = Color3.new(0, 0, 0), Transparency = 0.45, Thickness = 1 }) })
	local svFill = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(8, 8), BackgroundColor3 = color, ZIndex = 6, Parent = svCursor,
	}, { corner(4) })

	local kps = {}
	for i = 0, 6 do table.insert(kps, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV((i / 6) % 1, 1, 1))) end
	local hue = create("Frame", { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -6, 0, 6), Size = UDim2.fromOffset(16, 92), BackgroundColor3 = Color3.new(1, 1, 1), Parent = inner }, {
		corner(4), create("UIGradient", { Rotation = 90, Color = ColorSequence.new(kps) }),
	})
	local hueHit = create("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 4, Parent = hue })
	local hueCursor = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(1, 6, 0, 8), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 5, Parent = hue,
	}, { corner(3), create("UIStroke", { Color = Color3.new(0, 0, 0), Transparency = 0.45, Thickness = 1 }) })
	local hueFill = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(1, -4, 0, 4), BackgroundColor3 = Color3.fromHSV(h, 1, 1), ZIndex = 6, Parent = hueCursor,
	}, { corner(2) })

	local alphaBar, alphaFill, alphaHit, alphaCursor
	if hasAlpha then
		local back = create("Frame", { Position = UDim2.fromOffset(6, 104), Size = UDim2.new(1, -12, 0, 10), BackgroundColor3 = rgb(25, 25, 25), Parent = inner }, { corner(4) })
		alphaBar = back
		alphaFill = create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = color, BorderSizePixel = 0, Parent = back }, {
			corner(4), create("UIGradient", { Transparency = NumberSequence.new(0, 1) }),
		})
		alphaHit = create("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 4, Parent = back })
		alphaCursor = create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 6, 1, 6), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 5, Parent = back,
		}, { corner(3), create("UIStroke", { Color = Color3.new(0, 0, 0), Transparency = 0.45, Thickness = 1 }) })
	end

	local hex = create("TextBox", {
		Position = UDim2.fromOffset(6, hasAlpha and 120 or 104), Size = UDim2.new(1, -12, 0, 20), ClearTextOnFocus = false,
		TextSize = 12, Text = "", TextXAlignment = Enum.TextXAlignment.Left,
		Themed = { BackgroundColor3 = "Card", TextColor3 = "Text" }, Parent = inner,
	}, { corner(4), padding(0, 6, 0, 6) })

	local Picker = { Swatch = swatch }

	local function render()
		color = Color3.fromHSV(h, s, v)
		swatch.BackgroundColor3 = color
		swatch.BackgroundTransparency = alpha * 0.85
		sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
		svCursor.Position = UDim2.fromScale(s, 1 - v)
		svFill.BackgroundColor3 = color
		hueCursor.Position = UDim2.fromScale(0.5, h)
		hueFill.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
		if hasAlpha then
			alphaFill.BackgroundColor3 = color
			alphaCursor.Position = UDim2.fromScale(alpha, 0.5)
		end
		if not hex:IsFocused() then
			hex.Text = "#" .. color:ToHex():upper() .. (hasAlpha and string.format("   %d%%", math.floor((1 - alpha) * 100 + 0.5)) or "")
		end
	end

	local function commit(silent)
		render()
		if o.Flag then
			Library.Flags[o.Flag] = color
			if hasAlpha then Library.Flags[o.Flag .. "_Transparency"] = alpha end
		end
		if not silent then fire(o.Callback, color, alpha) end
	end

	function Picker:Set(c, silent, a)
		if type(c) == "string" then
			local ok, res = pcall(Color3.fromHex, c)
			c = ok and res or nil
		end
		if typeof(c) ~= "Color3" then return end
		h, s, v = c:ToHSV()
		if a ~= nil then alpha = math.clamp(a, 0, 1) end
		commit(silent)
	end
	function Picker:SetTransparency(a, silent)
		alpha = math.clamp(tonumber(a) or 0, 0, 1)
		commit(silent)
	end
	function Picker:Get() return color, alpha end
	function Picker:SetRainbow(b) rainbow = b and true or false end

	-- row of recently used colours under the hex box; empty slots stay as blank squares
	local recentSlots = {}
	local function refreshRecent()
		local recent = recentColors()
		for i, slot in ipairs(recentSlots) do
			local ok, c = pcall(Color3.fromHex, recent[i] or "")
			slot.BackgroundColor3 = (recent[i] ~= nil and ok) and c or Theme.Card
		end
	end
	for i = 1, RECENT_MAX do
		local slot = create("TextButton", {
			Position = UDim2.fromOffset(6 + (i - 1) * 18, (hasAlpha and 120 or 104) + 24), Size = UDim2.fromOffset(14, 14),
			Text = "", AutoButtonColor = false, BackgroundColor3 = Theme.Card, Parent = inner,
		}, { corner(3), stroke() })
		recentSlots[i] = slot
		slot.MouseButton1Click:Connect(function()
			local code = recentColors()[i]
			if not code then return end
			rainbow = false
			Picker:Set(code)
		end)
	end
	onTheme(function() if open then refreshRecent() end end) -- closed panels refresh when they open
	Picker._refreshRecent = refreshRecent

	function Picker:SetOpen(state)
		open = state
		if open then
			refreshRecent()
			panel.Visible = true
			tween(panel, 0.3, { Size = UDim2.new(1, 0, 0, PANEL_H) })
		else
			tween(panel, 0.2, { Size = UDim2.new(1, 0, 0, 0) }).Completed:Connect(function()
				if not open then panel.Visible = false end
			end)
		end
	end
	function Picker:Reset() rainbow = false; alpha = defaultAlpha; Picker:Set(default) end

	local function contextItems()
		local items = {
			{ Text = "Copy hex", Callback = function()
				Library._clipColor = color
				setClipboard("#" .. color:ToHex():upper())
				Library:Notify({ Title = "Copied", Text = "#" .. color:ToHex():upper(), Duration = 1.5 })
			end },
		}
		if Library._clipColor then
			table.insert(items, { Text = "Paste", Hint = "#" .. Library._clipColor:ToHex():upper(), Callback = function()
				Picker:Set(Library._clipColor)
				rememberColor(color)
				refreshRecent()
			end })
		end
		table.insert(items, { Text = "Rainbow", Kind = "check", Checked = rainbow, Callback = function() Picker:SetRainbow(not rainbow) end })
		table.insert(items, "-")
		table.insert(items, { Text = "Reset", Danger = true, Callback = function() Picker:Reset() end })
		return items
	end
	swatch.MouseButton2Click:Connect(function() Library:OpenContextMenu(o.Name or "Color", contextItems()) end)
	Picker._contextItems = contextItems

	-- Positions come straight from InputObject.Position, which lives in the same space as
	-- AbsolutePosition (topbar inset already removed). GetMouseLocation does NOT, which is what
	-- made the dot sit away from the cursor before.
	local dragging = nil
	local function update(m)
		if dragging == "sv" then
			s = math.clamp((m.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
			v = 1 - math.clamp((m.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
		elseif dragging == "hue" then
			h = math.clamp((m.Y - hue.AbsolutePosition.Y) / hue.AbsoluteSize.Y, 0, 0.999)
		elseif dragging == "alpha" then
			alpha = math.clamp((m.X - alphaBar.AbsolutePosition.X) / alphaBar.AbsoluteSize.X, 0, 1)
		end
		commit()
	end
	local cursors = { sv = svCursor, hue = hueCursor, alpha = alphaCursor }
	local grow = { sv = UDim2.fromOffset(15, 15), hue = UDim2.new(1, 8, 0, 10), alpha = UDim2.new(0, 8, 1, 8) }
	local rest = { sv = UDim2.fromOffset(12, 12), hue = UDim2.new(1, 6, 0, 8), alpha = UDim2.new(0, 6, 1, 6) }
	local function hook(hitArea, kind)
		hitArea.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
			rainbow = false
			dragging = kind
			tween(cursors[kind], 0.12, { Size = grow[kind] })
			update(input.Position)
		end)
	end
	hook(svHit, "sv")
	hook(hueHit, "hue")
	if alphaHit then hook(alphaHit, "alpha") end
	onInputChanged(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			update(input.Position)
		end
	end)
	onInputEnded(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			tween(cursors[dragging], 0.12, { Size = rest[dragging] })
			-- the colour the drag ended on goes into the recent row (not for the transparency bar)
			if dragging ~= "alpha" then
				rememberColor(color)
				refreshRecent()
			end
			dragging = nil
		end
	end)
	onHeartbeat(function()
		if rainbow then
			h = (os.clock() * 0.15) % 1
			commit()
		end
	end)
	hex.Focused:Connect(function() hex.Text = "#" .. color:ToHex():upper() end)
	hex.FocusLost:Connect(function()
		local txt = hex.Text:gsub("#", ""):gsub("%s", ""):sub(1, 6)
		if #txt == 6 and txt:match("^%x+$") then
			Picker:Set(txt)
			rememberColor(color)
			refreshRecent()
		else
			render()
		end
	end)
	swatch.MouseButton1Click:Connect(function() Picker:SetOpen(not open) end)

	-- config load: only run the callback when the color is actually different
	registerFlag(o, function(c, silent)
		if type(c) == "string" then
			local ok, res = pcall(Color3.fromHex, c)
			c = ok and res or nil
		end
		if typeof(c) ~= "Color3" then return end
		-- compare as hex: configs store 0-255 values, the picker holds exact HSV floats
		Picker:Set(c, silent or c:ToHex() == color:ToHex())
	end, color)
	if hasAlpha and o.Flag then
		Library.Flags[o.Flag .. "_Transparency"] = alpha
		Library.SetFlags[o.Flag .. "_Transparency"] = function(a)
			a = tonumber(a)
			if not a then return end
			Picker:SetTransparency(a, math.abs(a - alpha) < 1e-4)
		end
		if o.NoSave then Library.NoSave[o.Flag .. "_Transparency"] = true end
	end
	render()
	return Picker
end

-- floating "more options" card used by Toggle:AddOptions / Label:AddOptions
function Library:_optionsPopup(ownerSection, slot, title, build, layoutOrder)
	local btn = create("TextButton", {
		Size = UDim2.fromOffset(24, 20), Text = "•••", TextSize = 9, AutoButtonColor = false, BackgroundTransparency = 1,
		LayoutOrder = layoutOrder or 0, Themed = { TextColor3 = "SubText", BackgroundColor3 = "Element" }, Parent = slot,
	}, { corner(5) })
	blockRowContext(btn)
	local btnHover = false
	btn.MouseEnter:Connect(function() btnHover = true; tween(btn, 0.12, { BackgroundTransparency = 0, TextColor3 = Theme.Text }) end)
	btn.MouseLeave:Connect(function() btnHover = false; tween(btn, 0.12, { BackgroundTransparency = 1, TextColor3 = Theme.SubText }) end)

	local host = (self.Window and self.Window.Main) or self:_getGui()
	local W = 240
	local popup = create("Frame", {
		Visible = false, Size = UDim2.fromOffset(W, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 42,
		Themed = { BackgroundColor3 = "Card" }, Parent = host,
	}, { corner(8), stroke() })
	-- no UIScale pop here: it made the text grow from small to big. The card simply appears at
	-- full size (its contents are live controls, so a fade could leave them half-transparent)
	textLabel({ Position = UDim2.fromOffset(14, 8), Size = UDim2.new(1, -28, 0, 18), Text = string.upper(title), Bold = true, TextSize = 11, Themed = { TextColor3 = "SubText" }, Parent = popup })
	local content = create("Frame", {
		Position = UDim2.fromOffset(6, 30), Size = UDim2.new(1, -12, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = popup,
	}, { list(4), padding(0, 0, 8, 0) })
	local card = setmetatable({ Frame = content, Elements = {}, _order = 0, Sub = ownerSection.Sub, Title = title, _noIndex = true }, Library._SectionMT)
	if build then build(card) end

	local open, hover = false, false
	popup.MouseEnter:Connect(function() hover = true end)
	popup.MouseLeave:Connect(function() hover = false end)

	local Popup = { Button = btn, Section = card }
	local function place()
		local s = Library:_scale()
		local hp, bp, bs = host.AbsolutePosition, btn.AbsolutePosition, btn.AbsoluteSize
		local x = math.max((bp.X - hp.X + bs.X) / s - W, 8)
		local y = (bp.Y - hp.Y + bs.Y) / s + 6
		local h = popup.AbsoluteSize.Y / s
		if y + h > host.AbsoluteSize.Y / s - 8 then y = math.max((bp.Y - hp.Y) / s - 6 - h, 8) end
		popup.Position = UDim2.fromOffset(x, y)
	end
	function Popup:Open()
		if open then return end
		if Library._openOptions and Library._openOptions ~= Popup then Library._openOptions:Close() end
		Library._openOptions = Popup
		open = true
		popup.Visible = true
		place()
		task.defer(place) -- again once AutomaticSize has measured the card
		btn.TextColor3 = Theme.Accent
	end
	function Popup:Close()
		if not open then return end
		open = false
		hover = false
		if Library._openOptions == Popup then Library._openOptions = nil end
		btn.TextColor3 = Theme.SubText
		if Library._openDropdown then Library._openDropdown:Close() end
		popup.Visible = false
	end
	btn.MouseButton1Click:Connect(function() if open then Popup:Close() else Popup:Open() end end)
	connect(UserInputService.InputBegan, function(input)
		if not open then return end
		local t = input.UserInputType
		if (t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch)
			and not hover and not btnHover and not Library._dropdownHover and not Library._ctxHover then
			Popup:Close()
		end
	end)
	if ownerSection.Sub and ownerSection.Sub.Scroll then
		ownerSection.Sub.Scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function() if open then Popup:Close() end end)
	end
	Library:AttachTooltip(btn, "More options")
	return Popup
end

-- right side "extras" slot that shrinks a row's label so attachments never overlap it
local function extrasSlot(row, label, rightOffset, baseInset)
	local extras = create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, rightOffset, 0.5, 0), Size = UDim2.fromOffset(0, 20),
		AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Parent = row,
	}, { list(6, true, { HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Center }) })
	extras:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		local px = extras.AbsoluteSize.X / Library:_scale()
		label.Size = UDim2.new(1, -(baseInset + (px > 0 and px + 6 or 0)), label.Size.Y.Scale, label.Size.Y.Offset)
	end)
	return extras
end

---------------------------------------------------------------- section / elements
local Section = {}
Section.__index = Section
Library._SectionMT = Section

function Section:_next()
	self._order += 10
	return self._order
end

-- every element goes through here: search index, tooltip, disable overlay, visibility
-- small "[?]" next to an element's name; hovering it shows the tooltip
-- risk = true makes it the red "[!]" of a Risky element instead. A row can have both: `shift`
-- moves this marker right past the other one, `reserve` keeps room for the other one.
local RISK_COLOR = rgb(255, 95, 95)
local function helpMarker(label, text, risk, shift, reserve)
	shift, reserve = shift or 0, reserve or 0
	local parent = label.Parent
	local marker = create("TextButton", {
		AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.fromOffset(22, 16), BackgroundTransparency = 1, AutoButtonColor = false,
		Text = risk and "[!]" or "[?]", TextSize = 10, TextColor3 = risk and RISK_COLOR or nil,
		Themed = (not risk) and { TextColor3 = "SubText" } or nil, Parent = parent,
	})
	local function place()
		-- measure the text unscaled (TextBounds may or may not include the window's UIScale)
		local ok, size = pcall(function()
			return TextService:GetTextSize(label.Text, label.TextSize, label.Font, Vector2.new(10000, 10000))
		end)
		local w = (ok and typeof(size) == "Vector2") and size.X or label.TextBounds.X / Library:_scale()
		-- a long, truncated name: keep the marker inside the label instead of on top of the controls
		local maxW = label.AbsoluteSize.X / Library:_scale()
		if maxW > 30 + reserve then w = math.min(w, maxW - 26 - reserve) end
		local yScale = label.Position.Y.Scale + label.Size.Y.Scale / 2
		local yOff = label.Position.Y.Offset + label.Size.Y.Offset / 2
		marker.Position = UDim2.new(label.Position.X.Scale, label.Position.X.Offset + w + 4 + shift, yScale, yOff)
	end
	label:GetPropertyChangedSignal("TextBounds"):Connect(place)
	label:GetPropertyChangedSignal("Position"):Connect(place) -- Description moves the name up
	label:GetPropertyChangedSignal("Size"):Connect(place)
	label:GetPropertyChangedSignal("AbsoluteSize"):Connect(place) -- key box attached, window resized
	label:GetPropertyChangedSignal("Font"):Connect(place) -- theme font changed
	place()
	if not risk then
		marker.MouseEnter:Connect(function() tween(marker, 0.12, { TextColor3 = Theme.Accent }) end)
		marker.MouseLeave:Connect(function() tween(marker, 0.12, { TextColor3 = Theme.SubText }) end)
	end
	blockRowContext(marker)
	Library:AttachTooltip(marker, text)
	return marker
end

function Section:_register(row, name, api, o, label)
	o = o or {}
	local el = { Row = row, Name = string.lower(name or ""), Display = name, Api = api, Hidden = false, Match = true, Section = self }
	table.insert(self.Elements, el)
	if Library.Window and not self._noIndex then table.insert(Library.Window._index, el) end
	-- Risky = true (or a reason string): red "[!]" after the name; hovering it shows the reason
	local risky = o.Risky and label and label.Parent and true or false
	if risky then
		local why = type(o.Risky) == "string" and o.Risky or "Risky: this one is more likely to get you noticed."
		helpMarker(label, why, true, 0, o.Tooltip and 20 or 0)
	end
	if o.Tooltip then
		if label and label.Parent then
			helpMarker(label, o.Tooltip, false, risky and 20 or 0, risky and 20 or 0)
		else
			Library:AttachTooltip(row, o.Tooltip)
		end
	end

	local overlay
	local selfDisabled, sectionLocked = false, false
	local function applyDisabled()
		local b = selfDisabled or sectionLocked
		api.Disabled = b
		Library._disabledRows[row] = b or nil
		-- a floating list / options card opened from this row would stay usable on top of the lock
		if b then
			if Library._openDropdown then Library._openDropdown:Close() end
			if Library._openOptions then Library._openOptions:Close() end
			-- color picker panels sit below the row, outside the overlay: close them too
			if api.SetOpen and api.Swatch then api:SetOpen(false) end
			for _, p in ipairs(api._pickers or {}) do p:SetOpen(false) end
		end
		if b and not overlay then
			overlay = create("TextButton", {
				Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 20,
				Themed = { BackgroundColor3 = "Card" }, Parent = row,
			}, { corner(6) })
			if o.Tooltip then Library:AttachTooltip(overlay, o.Tooltip) end
		end
		if overlay then
			if b then overlay.Visible = true end
			tween(overlay, 0.2, { BackgroundTransparency = b and 0.35 or 1 })
			for _, d in ipairs(overlay:GetChildren()) do
				if d:IsA("TextLabel") then tween(d, 0.2, { TextTransparency = b and 0 or 1 }) end
			end
			if not b then task.delay(0.2, function() if not api.Disabled then overlay.Visible = false end end) end
		end
	end
	function api:SetDisabled(b) selfDisabled = b and true or false; applyDisabled() end
	function api:_setSectionLocked(b) sectionLocked = b and true or false; applyDisabled() end
	function api:SetVisible(b)
		el.Hidden = not b
		row.Visible = b and el.Match
	end

	-- :OnChanged(fn) - extra listeners on top of Callback (used by dependency groups)
	-- elements read o.Callback when they fire, so wrapping it here covers all of them
	local listeners = {}
	local userCallback = o.Callback
	o.Callback = function(...)
		if userCallback then userCallback(...) end
		for _, fn in ipairs(listeners) do task.spawn(fn, ...) end
	end
	function api:OnChanged(fn) table.insert(listeners, fn) end

	-- Description = "second line" under the name
	if o.Description and label and label.Parent then
		local grow = 14
		if label.Size.Y.Scale == 1 then
			-- full-height label (toggle, keybind, color): pin the name to the top line
			label.Size = UDim2.new(label.Size.X.Scale, label.Size.X.Offset, 0, 30)
			label.Position = UDim2.new(label.Position.X.Scale, label.Position.X.Offset, 0, -3)
			local desc = textLabel({
				Position = UDim2.new(label.Position.X.Scale, label.Position.X.Offset, 0, 20), Size = UDim2.new(label.Size.X.Scale, label.Size.X.Offset, 0, 14),
				Text = o.Description, TextSize = 11, TextTruncate = Enum.TextTruncate.AtEnd, Themed = { TextColor3 = "SubText" }, Parent = label.Parent,
			})
			-- the name shrinks when a key box / color gets attached; the description has to as well
			label:GetPropertyChangedSignal("Size"):Connect(function()
				desc.Size = UDim2.new(label.Size.X.Scale, label.Size.X.Offset, 0, 14)
			end)
		else
			local y = label.Position.Y.Offset + label.Size.Y.Offset - 2
			-- things pinned below the name from the top (list box, search bar, preview) move down
			-- to make room; things pinned to the bottom move with the row growing
			for _, c in ipairs(label.Parent:GetChildren()) do
				if c ~= label and c:IsA("GuiObject") and c.Position.Y.Scale == 0 and c.Position.Y.Offset >= y then
					c.Position = c.Position + UDim2.fromOffset(0, grow)
				end
			end
			textLabel({
				Position = UDim2.new(label.Position.X.Scale, label.Position.X.Offset, 0, y), Size = UDim2.new(1, -16, 0, 14),
				Text = o.Description, TextSize = 11, TextTruncate = Enum.TextTruncate.AtEnd, Themed = { TextColor3 = "SubText" }, Parent = label.Parent,
			})
		end
		row.Size = row.Size + UDim2.fromOffset(0, grow)
	end

	if o.Disabled then api:SetDisabled(true) end
	if self._lock and self._lock.locked then api:_setSectionLocked(true) end
	return api
end

-- Section:AddDependency(element, condition?) -> a group whose elements only show while
-- condition(element:Get()) is true (default: the toggle is on). Add elements to it like a section.
function Section:AddDependency(target, condition)
	condition = condition or function(v) return v == true end
	local wrap = create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = self:_next(), Parent = self.Frame })
	-- thin accent line on the left shows the nesting
	local line = create("Frame", { Position = UDim2.fromOffset(9, 2), Size = UDim2.new(0, 2, 1, -4), BorderSizePixel = 0, BackgroundTransparency = 0.5, Themed = { BackgroundColor3 = "Accent" }, Parent = wrap }, { corner(1) })
	local holder = create("Frame", { Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -10, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = wrap }, { list(4) })
	local dep = setmetatable({
		Frame = holder, Elements = self.Elements, _order = 0, Sub = self.Sub, Title = self.Title, Card = self.Card, Inner = self.Inner, _noIndex = self._noIndex, _lock = self._lock,
		_parent = self,
	}, Section)
	local shown = nil
	local function probe() return condition(target:Get()) end -- built once, not once per frame
	local function update()
		-- runs every frame, so nothing in here may throw (bad target / condition = hidden)
		local ok, res = pcall(probe)
		local show = ok and res and true or false
		if show == shown then return end
		shown = show
		wrap.Visible = show
		if show then
			line.Size = UDim2.new(0, 2, 0, 0)
			tween(line, 0.35, { Size = UDim2.new(0, 2, 1, -4) })
		end
	end
	if target.OnChanged then target:OnChanged(update) end
	-- silent :Set(v, true) calls don't run callbacks, so also follow the value itself
	onHeartbeat(function() if wrap.Parent then update() end end)
	task.defer(update)
	return dep
end

function Section:AddLabel(text, o)
	o = o or {}
	local section = self
	local order = self:_next()
	local attach = 0
	local row = create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = order, Parent = self.Frame })
	local lbl = textLabel({
		Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -16, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = text or "",
		TextSize = 12, TextWrapped = true, Themed = { TextColor3 = "SubText" }, Parent = row,
	})
	padding(5, 0, 5, 0).Parent = lbl
	local extras = extrasSlot(row, lbl, -8, 16)

	local Label = { _pickers = {} }
	function Label:Set(t) lbl.Text = t end
	function Label:Get() return lbl.Text end
	local function promote()
		-- a label with controls attached reads like a setting row
		ThemeRegistry[lbl] = { TextColor3 = "Text", Font = "Font" }
		lbl.TextColor3 = Theme.Text
		lbl.TextSize = 13
	end
	function Label:AddKeybind(ko)
		ko = ko or {}
		ko.Name = ko.Name or text
		ko._isDisabled = function() return Label.Disabled end
		promote()
		attach += 1
		return buildKeyChip(extras, ko, attach)
	end
	function Label:AddColorPicker(co)
		co = co or {}
		co.Name = co.Name or text
		promote()
		attach += 1
		local p = buildColorPicker(section, extras, order + attach, co)
		table.insert(Label._pickers, p)
		attachContext(row, co.Name, p._contextItems)
		return p
	end
	function Label:AddOptions(build)
		promote()
		return Library:_optionsPopup(section, extras, text, build, 0).Section
	end
	return self:_register(row, text, Label, o)
end

function Section:AddParagraph(o)
	o = o or {}
	-- outer frame has no layout (so overlays can sit on it), the inner one stacks the text
	local holder = create("Frame", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = self:_next(),
		Themed = { BackgroundColor3 = "Element" }, BackgroundTransparency = 0.4, Parent = self.Frame,
	}, { corner(6) })
	local inner = create("Frame", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = holder,
	}, { padding(8, 10, 8, 10), list(3) })
	local title = textLabel({ Size = UDim2.new(1, 0, 0, 16), Text = o.Title or "Paragraph", Bold = true, LayoutOrder = 1, Parent = inner })
	local body = textLabel({
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = o.Text or "", TextSize = 12,
		TextWrapped = true, LayoutOrder = 2, Themed = { TextColor3 = "SubText" }, Parent = inner,
	})
	local P = {}
	function P:SetTitle(t) title.Text = t end
	function P:SetText(t) body.Text = t end
	return self:_register(holder, o.Title, P, o)
end

function Section:AddDivider(text)
	local row = create("Frame", { Size = UDim2.new(1, 0, 0, text and 20 or 9), BackgroundTransparency = 1, LayoutOrder = self:_next(), Parent = self.Frame })
	if text then
		local lbl = textLabel({
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(0, 14),
			AutomaticSize = Enum.AutomaticSize.X, Text = string.upper(text), TextSize = 10, Bold = true,
			TextXAlignment = Enum.TextXAlignment.Center, Themed = { TextColor3 = "SubText" }, Parent = row,
		})
		padding(0, 8, 0, 8).Parent = lbl
		local left = create("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0), Size = UDim2.new(0.5, -50, 0, 1), BorderSizePixel = 0, Themed = { BackgroundColor3 = "Stroke" }, Parent = row })
		local right = create("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Size = UDim2.new(0.5, -50, 0, 1), BorderSizePixel = 0, Themed = { BackgroundColor3 = "Stroke" }, Parent = row })
		-- keep the lines hugging the text whatever its width
		lbl:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			local half = lbl.AbsoluteSize.X / Library:_scale() / 2
			left.Size = UDim2.new(0.5, -(half + 10), 0, 1)
			right.Size = UDim2.new(0.5, -(half + 10), 0, 1)
		end)
	else
		create("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0), Size = UDim2.new(1, -16, 0, 1), BorderSizePixel = 0, Themed = { BackgroundColor3 = "Stroke" }, Parent = row })
	end
	return self:_register(row, text or "", {}, {})
end

function Section:AddToggle(o)
	o = o or {}
	local section = self
	local default = o.Default and true or false
	local value = default
	local order = self:_next()
	local attachCount = 0

	local row = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
		LayoutOrder = order, Themed = { BackgroundColor3 = "Element" }, Parent = self.Frame,
	}, { corner(6) })
	local label = textLabel({ Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -60, 1, 0), Text = o.Name or "Toggle", TextTruncate = Enum.TextTruncate.AtEnd, Parent = row })
	local track = create("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Size = UDim2.fromOffset(34, 18), Parent = row }, { corner(9), stroke(), shade(90, 1, 0.78) })
	local knob = create("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0), Size = UDim2.fromOffset(12, 12), Parent = track }, { corner(6) })
	local extras = extrasSlot(row, label, -50, 60)

	local function render(instant)
		local t = instant and 0 or 0.22
		tween(track, t, { BackgroundColor3 = value and Theme.Accent or Theme.Element })
		tween(knob, t, {
			Position = value and UDim2.new(1, -15, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
			BackgroundColor3 = value and Color3.new(1, 1, 1) or Theme.SubText,
		})
		tween(label, t, { TextColor3 = value and Theme.Text or Theme.SubText })
	end
	onTheme(function() render(true) end)

	local Toggle = {}
	local attachedBind
	local pickers = {}
	Toggle._pickers = pickers -- so disabling the row can close their panels
	function Toggle:Set(b, silent)
		value = b and true or false
		render()
		-- squish the knob for a bit of life
		knob.Size = UDim2.fromOffset(15, 10)
		tween(knob, 0.25, { Size = UDim2.fromOffset(12, 12) }, Enum.EasingStyle.Back)
		if o.Flag then Library.Flags[o.Flag] = value end
		if attachedBind then
			-- switching off a toggle whose key is "Always" would leave the key showing active;
			-- turning it off means it's no longer always on, so the key goes back to Toggle mode
			if not value and attachedBind.State.Mode == "Always" then attachedBind:SetMode("Toggle") end
			attachedBind:SetActive(value, true)
		end
		if not silent then fire(o.Callback, value) end
	end
	function Toggle:Get() return value end
	function Toggle:SetText(t) label.Text = t end

	function Toggle:AddKeybind(ko)
		ko = ko or {}
		ko.Name = ko.Name or o.Name
		ko._isDisabled = function() return Toggle.Disabled end
		local userCb = ko.Callback
		ko.Callback = function(active)
			if Toggle:Get() ~= active then Toggle:Set(active) end
			fire(userCb, active)
		end
		attachedBind = buildKeyChip(extras, ko, 1)
		if attachedBind.State.Mode == "Always" then
			Toggle:Set(true)
		else
			attachedBind:SetActive(value, true)
		end
		return attachedBind
	end

	function Toggle:AddColorPicker(co)
		co = co or {}
		co.Name = co.Name or o.Name
		attachCount += 1
		local p = buildColorPicker(section, extras, order + attachCount, co)
		table.insert(pickers, p)
		return p
	end

	-- "•••" button that opens a floating card with extra settings for this feature
	-- Toggle:AddOptions(function(card) card:AddSlider{...} end)  -> returns the card (a section)
	function Toggle:AddOptions(build)
		local popup = Library:_optionsPopup(section, extras, o.Name or "Options", build, 0)
		return popup.Section
	end

	Library._rowHover:bind(row,
		function() tween(row, 0.15, { BackgroundTransparency = 0.6 }) end,
		function() tween(row, 0.15, { BackgroundTransparency = 1 }) end)
	-- Risky toggles ask once before the user switches them on by hand. Keybinds, config loads
	-- and :Set() from a script go straight through: a popup in the middle of a fight is worse.
	local riskAccepted = false
	local function userSet(b)
		if b and o.Risky and not riskAccepted then
			local why = type(o.Risky) == "string" and o.Risky or "It is more likely to get you noticed."
			Library:Dialog({
				Title = "Risky feature", Text = tostring(o.Name or "This") .. " is marked as risky. " .. why .. " Turn it on anyway?",
				Buttons = { { "Cancel" }, { "Turn on", function() riskAccepted = true; Toggle:Set(true) end, "danger" } },
			})
			return
		end
		Toggle:Set(b)
	end
	rippleOnPress(row)
	row.MouseButton1Click:Connect(function() userSet(not value) end)
	attachContext(row, o.Name, function()
		local items = {
			{ Text = value and "Turn off" or "Turn on", Callback = function() userSet(not value) end },
			{ Text = "Reset to default", Hint = default and "on" or "off", Callback = function() Toggle:Set(default) end },
		}
		if attachedBind then
			table.insert(items, "-")
			table.insert(items, { Text = "Clear keybind", Danger = true, Callback = function() attachedBind:Set(nil) end })
		end
		for _, p in ipairs(pickers) do
			table.insert(items, "-")
			for _, it in ipairs(p._contextItems()) do table.insert(items, it) end
		end
		return items
	end)

	-- config load: a toggle that's already in the saved state doesn't re-run its callback
	registerFlag(o, function(b) Toggle:Set(b, (b and true or false) == value) end, value)
	render(true)
	return self:_register(row, o.Name, Toggle, o, label)
end

-- Min/Max/Increment from a script: Min > Max would make math.clamp error, Increment <= 0
-- divides by zero (value turns into nan and the slider breaks)
local function sliderRange(o)
	local min, max = tonumber(o.Min) or 0, tonumber(o.Max) or 100
	if min > max then min, max = max, min end
	local inc = tonumber(o.Increment) or 1
	if inc <= 0 then inc = 1 end
	return min, max, inc
end

function Section:AddSlider(o)
	o = o or {}
	local min, max, inc = sliderRange(o)
	local suffix = o.Suffix or ""
	local decimals = 0
	while decimals < 6 and math.abs(inc * 10 ^ decimals - math.floor(inc * 10 ^ decimals + 0.5)) > 1e-7 do
		decimals += 1
	end
	local default = tonumber(o.Default) or min -- "50" works, junk falls back to Min
	local value
	local dragging = false

	local row = create("Frame", { Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, LayoutOrder = self:_next(), Parent = self.Frame })
	local label = textLabel({ Position = UDim2.fromOffset(8, 2), Size = UDim2.new(1, -100, 0, 18), Text = o.Name or "Slider", Parent = row })
	local box = create("TextBox", {
		AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, 2), Size = UDim2.fromOffset(90, 18),
		BackgroundTransparency = 1, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right,
		ClearTextOnFocus = false, Text = "", Themed = { TextColor3 = "SubText" }, Parent = row,
	})
	local track = create("Frame", { Position = UDim2.new(0, 8, 1, -13), Size = UDim2.new(1, -16, 0, 4), BorderSizePixel = 0, Themed = { BackgroundColor3 = "Element" }, Parent = row }, { corner(2) })
	local fill = create("Frame", { Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, Themed = { BackgroundColor3 = "Accent" }, Parent = track }, { corner(2), shade(0, 0.6, 1) })
	local knob = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.fromOffset(10, 10), BackgroundColor3 = Color3.new(1, 1, 1), Parent = track }, { corner(6), halo() })
	local hit = create("TextButton", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = "", Parent = track })

	local function fmt(x) return string.format("%." .. decimals .. "f", x) end

	local Slider = {}
	function Slider:Set(x, silent, force)
		x = tonumber(x) or value or min
		x = math.clamp(math.floor((x - min) / inc + 0.5) * inc + min, min, max)
		x = tonumber(fmt(x))
		local changed = x ~= value
		-- dragging fires on every mouse move, and most moves land on the step it is already on:
		-- nothing to redraw then (force = redraw anyway: range changed, typed text to restore)
		if not changed and not force then return end
		value = x
		local pct = (max - min) == 0 and 0 or (value - min) / (max - min)
		local t = dragging and 0.06 or 0.25
		tween(fill, t, { Size = UDim2.fromScale(pct, 1) })
		tween(knob, t, { Position = UDim2.fromScale(pct, 0.5) })
		box.Text = fmt(value) .. suffix
		if o.Flag then Library.Flags[o.Flag] = value end
		if changed and not silent then fire(o.Callback, value) end
	end
	function Slider:Get() return value end
	function Slider:SetText(t) label.Text = t end
	function Slider:SetRange(newMin, newMax)
		min, max = sliderRange({ Min = newMin, Max = newMax, Increment = inc })
		Slider:Set(value, true, true)
	end

	local function fromX(x)
		local pct = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		Slider:Set(min + (max - min) * pct)
	end
	hit.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			tween(knob, 0.15, { Size = UDim2.fromOffset(14, 14) })
			fromX(input.Position.X)
		end
	end)
	hit.MouseEnter:Connect(function() if not dragging then tween(knob, 0.15, { Size = UDim2.fromOffset(12, 12) }) end end)
	hit.MouseLeave:Connect(function() if not dragging then tween(knob, 0.15, { Size = UDim2.fromOffset(10, 10) }) end end)
	-- mouse wheel / Left and Right arrows move it one step while the mouse rests on the track
	local sectionScroll = self.Sub and self.Sub.Scroll or nil
	local function step(dir) Slider:Set(value + dir * inc) end
	local function claim() nudge.claim(hit, step, function() return Slider.Disabled == true end, sectionScroll) end
	Slider._step = step
	hit.MouseEnter:Connect(claim)
	hit.MouseMoved:Connect(claim)
	hit.MouseLeave:Connect(function() if nudge.target and nudge.target.gui == hit then nudge.release() end end)
	onInputChanged(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			fromX(input.Position.X)
		end
	end)
	onInputEnded(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragging = false
			tween(knob, 0.15, { Size = UDim2.fromOffset(10, 10) })
		end
	end)
	box.Focused:Connect(function() box.Text = fmt(value); box.TextColor3 = Theme.Text end)
	box.FocusLost:Connect(function()
		box.TextColor3 = Theme.SubText
		local n = tonumber((box.Text:gsub("[^%d%.%-]", "")))
		if n then Slider:Set(n, false, true) else box.Text = fmt(value) .. suffix end
	end)
	attachContext(row, o.Name, function()
		return {
			{ Text = "Reset to default", Hint = fmt(default) .. suffix, Callback = function() Slider:Set(default) end },
			{ Text = "Set to minimum", Hint = fmt(min) .. suffix, Callback = function() Slider:Set(min) end },
			{ Text = "Set to maximum", Hint = fmt(max) .. suffix, Callback = function() Slider:Set(max) end },
			"-",
			{ Text = "Copy value", Callback = function() setClipboard(fmt(value)) end },
		}
	end)

	Slider:Set(default, true)
	registerFlag(o, function(x) Slider:Set(x) end, value)
	return self:_register(row, o.Name, Slider, o, label)
end

function Section:AddRangeSlider(o)
	o = o or {}
	local min, max, inc = sliderRange(o)
	local suffix = o.Suffix or ""
	local decimals = 0
	while decimals < 6 and math.abs(inc * 10 ^ decimals - math.floor(inc * 10 ^ decimals + 0.5)) > 1e-7 do
		decimals += 1
	end
	-- Default must be { lo, hi }; anything else (a single number, nil) means the full range
	local default = type(o.Default) == "table" and o.Default or { min, max }
	local lo, hi = tonumber(default[1]) or min, tonumber(default[2]) or max
	local dragging = nil

	local row = create("Frame", { Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, LayoutOrder = self:_next(), Parent = self.Frame })
	local nameText = textLabel({ Position = UDim2.fromOffset(8, 2), Size = UDim2.new(1, -130, 0, 18), Text = o.Name or "Range", Parent = row })
	local valText = textLabel({
		AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, 2), Size = UDim2.fromOffset(120, 18), TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right, Themed = { TextColor3 = "SubText" }, Parent = row,
	})
	local track = create("Frame", { Position = UDim2.new(0, 8, 1, -13), Size = UDim2.new(1, -16, 0, 4), BorderSizePixel = 0, Themed = { BackgroundColor3 = "Element" }, Parent = row }, { corner(2) })
	local fill = create("Frame", { BorderSizePixel = 0, Themed = { BackgroundColor3 = "Accent" }, Parent = track }, { corner(2), shade(0, 0.7, 1) })
	local knobLo = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(10, 10), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 2, Parent = track }, { corner(6), halo() })
	local knobHi = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(10, 10), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 2, Parent = track }, { corner(6), halo() })
	local hit = create("TextButton", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = "", ZIndex = 3, Parent = track })

	local function fmt(x) return string.format("%." .. decimals .. "f", x) end
	local function snap(x) return tonumber(fmt(math.clamp(math.floor((x - min) / inc + 0.5) * inc + min, min, max))) end

	local Range = {}
	local function render()
		local a = (max - min) == 0 and 0 or (lo - min) / (max - min)
		local b = (max - min) == 0 and 0 or (hi - min) / (max - min)
		local t = dragging and 0.06 or 0.25
		tween(knobLo, t, { Position = UDim2.fromScale(a, 0.5) })
		tween(knobHi, t, { Position = UDim2.fromScale(b, 0.5) })
		tween(fill, t, { Position = UDim2.fromScale(a, 0), Size = UDim2.fromScale(b - a, 1) })
		valText.Text = fmt(lo) .. suffix .. "  -  " .. fmt(hi) .. suffix
	end
	function Range:Set(t, silent)
		if type(t) ~= "table" then return end
		local nlo, nhi = snap(tonumber(t[1]) or lo), snap(tonumber(t[2]) or hi)
		if nlo > nhi then nlo, nhi = nhi, nlo end
		local changed = nlo ~= lo or nhi ~= hi
		lo, hi = nlo, nhi
		render()
		if o.Flag then Library.Flags[o.Flag] = { lo, hi } end
		if changed and not silent then fire(o.Callback, { lo, hi }) end
	end
	function Range:Get() return { lo, hi } end

	local function fromX(x)
		local val = snap(min + (max - min) * math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1))
		if dragging == "lo" then
			if val > hi then dragging = "hi"; Range:Set({ hi, val }) else Range:Set({ val, hi }) end
		else
			if val < lo then dragging = "lo"; Range:Set({ val, lo }) else Range:Set({ lo, val }) end
		end
	end
	hit.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local x = input.Position.X
			local dLo = math.abs(x - knobLo.AbsolutePosition.X)
			local dHi = math.abs(x - knobHi.AbsolutePosition.X)
			dragging = dLo <= dHi and "lo" or "hi"
			tween(dragging == "lo" and knobLo or knobHi, 0.15, { Size = UDim2.fromOffset(14, 14) })
			fromX(x)
		end
	end)
	onInputChanged(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			fromX(input.Position.X)
		end
	end)
	onInputEnded(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragging = nil
			tween(knobLo, 0.15, { Size = UDim2.fromOffset(10, 10) })
			tween(knobHi, 0.15, { Size = UDim2.fromOffset(10, 10) })
		end
	end)
	attachContext(row, o.Name, function()
		return {
			{ Text = "Reset to default", Hint = fmt(default[1] or min) .. " - " .. fmt(default[2] or max), Callback = function() Range:Set(default) end },
			{ Text = "Full range", Callback = function() Range:Set({ min, max }) end },
		}
	end)

	render()
	registerFlag(o, function(t) Range:Set(t) end, { lo, hi })
	return self:_register(row, o.Name, Range, o, nameText)
end

function Section:AddDropdown(o)
	o = o or {}
	local section = self
	local options = o.Options or {}
	local multi = o.Multi and true or false
	local selected = {}
	local single = nil
	local open = false
	local query = ""
	local ROW, MAXROWS = 26, 7
	local searchable = o.Search or #options > 8
	local TOP = searchable and 34 or 4

	-- name on top, value box underneath (like a form field)
	local row = create("Frame", { Size = UDim2.new(1, 0, 0, 52), BackgroundTransparency = 1, LayoutOrder = self:_next(), Parent = self.Frame })
	local nameLabel = textLabel({ Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -16, 0, 18), Text = o.Name or "Dropdown", Parent = row })
	local bStroke = stroke()
	local box = create("TextButton", {
		AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 6, 1, -2), Size = UDim2.new(1, -12, 0, 28), Text = "", AutoButtonColor = false,
		Themed = { BackgroundColor3 = "Element" }, Parent = row,
	}, { corner(6), bStroke })
	local valLabel = textLabel({ Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -36, 1, 0), TextSize = 12, TextTruncate = Enum.TextTruncate.AtEnd, Parent = box })
	local chev = textLabel({
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(1, -14, 0.5, -1), Size = UDim2.fromOffset(12, 12), Rotation = 90,
		Text = "›", TextSize = 17, TextXAlignment = Enum.TextXAlignment.Center, Themed = { TextColor3 = "SubText" }, Parent = box,
	})
	local boxHover = false
	Library._rowHover:bind(box,
		function() boxHover = true; if not open then tween(box, 0.15, { BackgroundColor3 = Theme.ElementHover }) end end,
		function() boxHover = false; tween(box, 0.15, { BackgroundColor3 = Theme.Element }) end)

	-- floating list: lives on the window (not inside the section) so it overlaps instead of pushing things down
	local host = (Library.Window and Library.Window.Main) or Library:_getGui()
	local popup = create("Frame", {
		Visible = false, Size = UDim2.fromOffset(100, 0), ZIndex = 46, ClipsDescendants = true,
		Themed = { BackgroundColor3 = "Card" }, Parent = host,
	}, { corner(6), stroke() })
	local popHover = false
	local rowHover = hoverGroup()
	popup.MouseEnter:Connect(function() popHover = true; Library._dropdownHover = true end)
	popup.MouseLeave:Connect(function() popHover = false; Library._dropdownHover = false; rowHover:clear() end)

	local searchBox
	if searchable then
		searchBox = create("TextBox", {
			Position = UDim2.fromOffset(6, 6), Size = UDim2.new(1, -12, 0, 24), PlaceholderText = "Search...", Text = "",
			TextSize = 12, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left,
			Themed = { BackgroundColor3 = "Element", TextColor3 = "Text", PlaceholderColor3 = "SubText" }, Parent = popup,
		}, { corner(5), padding(0, 8, 0, 8) })
	end
	local listFrame = create("ScrollingFrame", {
		Position = UDim2.fromOffset(4, TOP), Size = UDim2.new(1, -8, 1, -(TOP + 4)), BackgroundTransparency = 1, BorderSizePixel = 0,
		ScrollBarThickness = 2, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Themed = { ScrollBarImageColor3 = "Stroke" }, Parent = popup,
	}, { list(2) })
	local noResults = textLabel({ Size = UDim2.new(1, 0, 0, ROW), Text = "no results", TextSize = 12, TextXAlignment = Enum.TextXAlignment.Center, Visible = false, LayoutOrder = 999999, Themed = { TextColor3 = "SubText" }, Parent = listFrame })

	local Dropdown = {}
	local buttons = {}

	local function isSelected(opt)
		if multi then return selected[opt] == true end
		return single == opt
	end
	local function getValue()
		if not multi then return single end
		local out = {}
		for _, opt in ipairs(options) do
			if selected[opt] then table.insert(out, opt) end
		end
		return out
	end
	-- selected rows get an accent bar on the left
	local function paintRow(opt, b, instant)
		local on = isSelected(opt)
		local t = instant and 0 or 0.15
		tween(b.Bar, t, { Size = UDim2.fromOffset(3, on and 14 or 0) })
		tween(b.Label, t, { TextColor3 = on and Theme.Text or Theme.SubText, Position = UDim2.fromOffset(on and 14 or 10, 0) })
		-- tweened (not set directly) so it always overrides a hover tween that's still running
		tween(b.Button, t, { BackgroundTransparency = on and 0.5 or 1 })
	end
	local function updateText()
		if multi then
			local sel = getValue()
			valLabel.Text = #sel > 0 and table.concat(sel, ", ") or "None"
		else
			valLabel.Text = single ~= nil and tostring(single) or "None"
		end
		for opt, b in pairs(buttons) do paintRow(opt, b) end
	end
	onTheme(function() for opt, b in pairs(buttons) do paintRow(opt, b, true) end end)

	local function visibleCount()
		local n = 0
		for _, b in pairs(buttons) do if b.Button.Visible then n += 1 end end
		return n
	end
	local function popupHeight()
		return TOP + math.max(math.min(visibleCount(), MAXROWS), 1) * (ROW + 2) + 4
	end
	-- where to put the popup: under the box, or above it if there's no room below
	local function place()
		local s = Library:_scale()
		local hostPos, hostSize = host.AbsolutePosition, host.AbsoluteSize
		local p, sz = box.AbsolutePosition, box.AbsoluteSize
		local x = (p.X - hostPos.X) / s
		local below = (p.Y - hostPos.Y + sz.Y) / s + 4
		local above = (p.Y - hostPos.Y) / s - 4
		local h = popupHeight()
		local up = below + h > hostSize.Y / s - 8 and above - h > 8
		return x, up and above or below, sz.X / s, h, up
	end

	local function setOpen(state)
		if state == open then return end
		open = state
		if open then
			if Library._openDropdown and Library._openDropdown ~= Dropdown then Library._openDropdown:Close() end
			Library._openDropdown = Dropdown
			local x, y, w, h, up = place()
			popup.AnchorPoint = up and Vector2.new(0, 1) or Vector2.new(0, 0)
			popup.Position = UDim2.fromOffset(x, y)
			popup.Size = UDim2.fromOffset(w, 0)
			popup.Visible = true
			tween(popup, 0.25, { Size = UDim2.fromOffset(w, h) })
			tween(chev, 0.25, { Rotation = up and -90 or 270 })
		else
			if Library._openDropdown == Dropdown then Library._openDropdown = nil end
			popHover = false
			Library._dropdownHover = false
			rowHover:clear()
			if searchBox then searchBox:ReleaseFocus() end
			tween(popup, 0.18, { Size = UDim2.fromOffset(popup.Size.X.Offset, 0) }, Enum.EasingStyle.Quad).Completed:Connect(function()
				if not open then
					popup.Visible = false
					if searchBox and searchBox.Text ~= "" then searchBox.Text = "" end
				end
			end)
			tween(chev, 0.25, { Rotation = 90 })
		end
	end

	local function resize()
		if not open then return end
		local _, _, w, h = place()
		tween(popup, 0.2, { Size = UDim2.fromOffset(w, h) })
	end

	local function applyQuery()
		local any = false
		for opt, b in pairs(buttons) do
			local m = query == "" or string.lower(tostring(opt)):find(query, 1, true) ~= nil
			b.Button.Visible = m
			if m then any = true end
		end
		noResults.Visible = not any
		resize()
	end

	local function commit(silent)
		updateText()
		if o.Flag then Library.Flags[o.Flag] = getValue() end
		if not silent then fire(o.Callback, getValue()) end
	end

	function Dropdown:Refresh(newOptions, keepSelection)
		options = newOptions or options
		for _, b in pairs(buttons) do b.Button:Destroy() end
		buttons = {}
		if not keepSelection then
			local valid = {}
			for _, opt in ipairs(options) do valid[opt] = true end
			for opt in pairs(selected) do if not valid[opt] then selected[opt] = nil end end
			if single ~= nil and not valid[single] then single = nil end
		end
		for i, opt in ipairs(options) do
			local b = create("TextButton", {
				Size = UDim2.new(1, -4, 0, ROW), BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
				LayoutOrder = i, Themed = { BackgroundColor3 = "Element" }, Parent = listFrame,
			}, { corner(5) })
			local bar = create("Frame", {
				AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 4, 0.5, 0), Size = UDim2.fromOffset(3, 0),
				BorderSizePixel = 0, Themed = { BackgroundColor3 = "Accent" }, Parent = b,
			}, { corner(2) })
			local lbl = textLabel({ Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -14, 1, 0), Text = tostring(opt), TextSize = 12, Themed = { Font = "Font" }, TextColor3 = Theme.SubText, Parent = b })
			local entry = { Button = b, Label = lbl, Bar = bar }
			rowHover:bind(b, function()
				tween(b, 0.12, { BackgroundTransparency = 0 })
				if not isSelected(opt) then tween(lbl, 0.12, { TextColor3 = Theme.Text }) end
			end, function() paintRow(opt, entry) end)
			b.MouseButton1Click:Connect(function()
				if multi then
					if selected[opt] then selected[opt] = nil else selected[opt] = true end
				else
					local same = single == opt
					single = opt
					setOpen(false)
					if same then return end
				end
				commit()
			end)
			buttons[opt] = entry
			paintRow(opt, entry, true)
		end
		updateText()
		applyQuery()
		-- options that vanished were dropped from the selection: the flag has to follow
		if o.Flag then Library.Flags[o.Flag] = getValue() end
	end

	function Dropdown:Set(val, silent)
		if multi then
			table.clear(selected)
			if type(val) == "table" then
				for _, x in ipairs(val) do selected[x] = true end
			elseif val ~= nil then
				selected[val] = true
			end
		else
			single = val
		end
		commit(silent)
	end
	function Dropdown:Get() return getValue() end
	function Dropdown:SetText(t) nameLabel.Text = t end
	function Dropdown:Open() setOpen(true) end
	function Dropdown:Close() setOpen(false) end
	function Dropdown:Add(opt)
		if table.find(options, opt) then return end
		local copy = table.clone(options)
		table.insert(copy, opt)
		Dropdown:Refresh(copy, true)
	end
	function Dropdown:Remove(opt)
		local copy = table.clone(options)
		local i = table.find(copy, opt)
		if not i then return end
		table.remove(copy, i)
		Dropdown:Refresh(copy)
		commit(true)
	end

	box.MouseButton1Click:Connect(function() setOpen(not open) end)
	connect(UserInputService.InputBegan, function(input)
		if not open then return end
		local t = input.UserInputType
		if (t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.MouseButton2 or t == Enum.UserInputType.Touch) and not popHover and not boxHover then
			setOpen(false)
		end
	end)
	-- the list floats, so close it if the page underneath scrolls
	if section.Sub and section.Sub.Scroll then
		section.Sub.Scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function() if open then setOpen(false) end end)
	end
	if searchBox then
		searchBox:GetPropertyChangedSignal("Text"):Connect(function()
			query = string.lower(searchBox.Text)
			applyQuery()
		end)
	end
	attachContext(box, o.Name, function()
		local items = {}
		if multi then
			table.insert(items, { Text = "Select all", Callback = function() Dropdown:Set(options) end })
		end
		table.insert(items, { Text = "Clear selection", Danger = true, Callback = function() Dropdown:Set(multi and {} or nil) end })
		return items
	end)

	Dropdown:Refresh(options, true)
	Dropdown:Set(o.Default, true)
	-- config load: no callback when the saved selection is what's already selected
	local function sameAs(val)
		if not multi then return val == single end
		local want = {}
		if type(val) == "table" then for _, x in ipairs(val) do want[x] = true end
		elseif val ~= nil then want[val] = true end
		for k in pairs(want) do if not selected[k] then return false end end
		for k in pairs(selected) do if not want[k] then return false end end
		return true
	end
	registerFlag(o, function(val) Dropdown:Set(val, sameAs(val)) end, getValue())
	return self:_register(row, o.Name, Dropdown, o, nameLabel)
end

function Section:AddKeybind(o)
	o = o or {}
	local row = create("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = self:_next(), Parent = self.Frame })
	local label = textLabel({ Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -100, 1, 0), Text = o.Name or "Keybind", Parent = row })
	local slot = extrasSlot(row, label, -8, 16)
	local bind = buildKeyChip(slot, o, 1)
	return self:_register(row, o.Name, bind, o, label)
end

function Section:AddColorPicker(o)
	o = o or {}
	local order = self:_next()
	local row = create("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = order, Parent = self.Frame })
	local label = textLabel({ Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -60, 1, 0), Text = o.Name or "Color", Parent = row })
	local slot = extrasSlot(row, label, -8, 16)
	local picker = buildColorPicker(self, slot, order + 1, o)
	attachContext(row, o.Name, picker._contextItems)
	return self:_register(row, o.Name, picker, o, label)
end

function Section:AddTextbox(o)
	o = o or {}
	-- always a string: the box's Text is compared to it (5 ~= "5" fired the callback for nothing)
	local default = o.Default ~= nil and tostring(o.Default) or ""
	local value = default
	local row = create("Frame", { Size = UDim2.new(1, 0, 0, o.Name and 52 or 32), BackgroundTransparency = 1, LayoutOrder = self:_next(), Parent = self.Frame })
	local nameText = o.Name and textLabel({ Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -16, 0, 18), Text = o.Name, Parent = row })
	local bStroke = stroke()
	local box = create("TextBox", {
		AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 6, 1, -2), Size = UDim2.new(1, -12, 0, 26),
		TextSize = 12, Text = value, PlaceholderText = o.Placeholder or "",
		ClearTextOnFocus = o.ClearOnFocus or false, TextXAlignment = Enum.TextXAlignment.Left,
		Themed = { BackgroundColor3 = "Element", TextColor3 = "Text", PlaceholderColor3 = "SubText" }, Parent = row,
	}, { corner(6), bStroke, padding(0, 8, 0, 8) })

	local Textbox = {}
	-- Numeric = true: scripts get a number (or nil when empty)
	local function out() if o.Numeric then return tonumber(value) end return value end
	function Textbox:Set(t, silent)
		value = tostring(t or "")
		box.Text = value
		if o.Flag then Library.Flags[o.Flag] = out() end
		if not silent then fire(o.Callback, out()) end
	end
	function Textbox:Get() return out() end
	function Textbox:Focus() box:CaptureFocus() end

	if o.Numeric then
		box:GetPropertyChangedSignal("Text"):Connect(function()
			local cleaned = box.Text:gsub("[^%d%.%-]", "")
			if cleaned ~= box.Text then box.Text = cleaned end
		end)
	end
	box.Focused:Connect(function() tween(bStroke, 0.15, { Color = Theme.Accent }) end)
	box.FocusLost:Connect(function(enter)
		tween(bStroke, 0.15, { Color = Theme.Stroke })
		if o.ClearOnFocus and box.Text == "" then box.Text = value end
		if box.Text ~= value then Textbox:Set(box.Text) end
		if enter then fire(o.OnEnter, out()) end
	end)
	attachContext(row, o.Name, function()
		return {
			{ Text = "Copy", Callback = function() setClipboard(value) end },
			{ Text = "Reset to default", Callback = function() Textbox:Set(default) end },
			{ Text = "Clear", Danger = true, Callback = function() Textbox:Set("") end },
		}
	end)
	registerFlag(o, function(t) Textbox:Set(t, tostring(t or "") == value) end, out())
	return self:_register(row, o.Name or o.Placeholder, Textbox, o, nameText)
end

local function styleButton(btn, o)
	local armed = false
	local armId = 0
	local original = btn.Text
	-- press-in effect (fixed sizes so it can never drift)
	local function release() tween(btn, 0.2, { Size = UDim2.new(1, 0, 1, 0) }, Enum.EasingStyle.Back) end
	Library._rowHover:bind(btn,
		function() tween(btn, 0.15, { BackgroundColor3 = Theme.ElementHover }) end,
		function() tween(btn, 0.15, { BackgroundColor3 = Theme.Element }); release() end)
	btn.MouseButton1Down:Connect(function() tween(btn, 0.08, { Size = UDim2.new(1, -4, 1, -3) }) end)
	btn.MouseButton1Up:Connect(release)
	rippleOnPress(btn)
	btn.MouseButton1Click:Connect(function()
		if o.Confirm and not armed then
			-- first click arms, second click within 2.5s runs
			armed = true
			armId += 1
			local my = armId
			btn.Text = o.ConfirmText or "Click again to confirm"
			btn.TextColor3 = Theme.Accent
			task.delay(2.5, function()
				if armed and armId == my then armed = false; btn.Text = original; btn.TextColor3 = Theme.Text end
			end)
			return
		end
		armed = false
		btn.Text = original
		btn.TextColor3 = Theme.Text
		btn.BackgroundColor3 = Theme.Accent
		tween(btn, 0.45, { BackgroundColor3 = Theme.ElementHover })
		fire(o.Callback)
	end)
end

function Section:AddButton(o)
	o = o or {}
	local holder = create("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = self:_next(), Parent = self.Frame })
	local btn = create("TextButton", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(1, 0, 1, 0),
		AutoButtonColor = false, Text = o.Name or "Button", TextSize = 13,
		Themed = { BackgroundColor3 = "Element", TextColor3 = "Text" }, Parent = holder,
	}, { corner(6), stroke() })
	styleButton(btn, o)
	local Button = { Instance = btn }
	function Button:SetText(t) btn.Text = t end
	function Button:Press() fire(o.Callback) end
	return self:_register(holder, o.Name, Button, o)
end

function Section:AddButtons(buttons, o)
	o = o or {}
	local n = #buttons
	local row = create("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = self:_next(), Parent = self.Frame })
	local strip = create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = row }, { list(6, true) })
	local out = {}
	local names = {}
	for i, b in ipairs(buttons) do
		local name = b.Name or b[1] or "Button"
		table.insert(names, name)
		local cell = create("Frame", { Size = UDim2.new(1 / n, -math.ceil(6 * (n - 1) / n), 1, 0), BackgroundTransparency = 1, LayoutOrder = i, Parent = strip })
		local btn = create("TextButton", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(1, 0, 1, 0), AutoButtonColor = false, Text = name,
			TextSize = 12, Themed = { BackgroundColor3 = "Element", TextColor3 = "Text" }, Parent = cell,
		}, { corner(6), stroke() })
		styleButton(btn, { Callback = b.Callback or b[2], Confirm = b.Confirm })
		if b.Tooltip then Library:AttachTooltip(btn, b.Tooltip) end
		table.insert(out, btn)
	end
	local api = { Buttons = out }
	return self:_register(row, table.concat(names, " "), api, o)
end

function Section:AddProgress(o)
	o = o or {}
	local value = math.clamp(tonumber(o.Default) or 0, 0, 1)
	local row = create("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, LayoutOrder = self:_next(), Parent = self.Frame })
	local label = textLabel({ Position = UDim2.fromOffset(8, 2), Size = UDim2.new(1, -80, 0, 16), Text = o.Name or "Progress", Parent = row })
	local pct = textLabel({
		AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, 2), Size = UDim2.fromOffset(70, 16), TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right, Themed = { TextColor3 = "SubText" }, Parent = row,
	})
	local track = create("Frame", { Position = UDim2.new(0, 8, 1, -12), Size = UDim2.new(1, -16, 0, 6), BorderSizePixel = 0, Themed = { BackgroundColor3 = "Element" }, Parent = row }, { corner(3) })
	local fill = create("Frame", { Size = UDim2.fromScale(value, 1), BorderSizePixel = 0, ClipsDescendants = true, Themed = { BackgroundColor3 = "Accent" }, Parent = track }, { corner(3), shade(0, 0.6, 1) })
	-- moving shine across the fill
	local shine = create("Frame", {
		Size = UDim2.new(0, 40, 1, 0), Position = UDim2.new(0, -40, 0, 0), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = fill,
	}, { create("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.7), NumberSequenceKeypoint.new(1, 1) }) }) })
	task.spawn(function()
		while row.Parent do
			shine.Position = UDim2.new(0, -40, 0, 0)
			tween(shine, 1.2, { Position = UDim2.new(1, 0, 0, 0) }, Enum.EasingStyle.Linear)
			task.wait(2)
		end
	end)

	local Progress = {}
	function Progress:Set(v)
		value = math.clamp(tonumber(v) or 0, 0, 1)
		tween(fill, 0.4, { Size = UDim2.fromScale(value, 1) })
		pct.Text = o.Format and o.Format(value) or (math.floor(value * 100 + 0.5) .. "%")
	end
	function Progress:Get() return value end
	function Progress:SetText(t) label.Text = t end
	Progress:Set(value)
	return self:_register(row, o.Name, Progress, o, label)
end

-- scrollable list box with a single selection (configs, players, anything)
-- { Name, Options, Default, Height, Empty, Callback(v), OnDoubleClick(v), ContextItems(v) -> items }
function Section:AddListbox(o)
	o = o or {}
	local options = o.Options or {}
	local selectedValue = o.Default
	local H = o.Height or 120
	local top = o.Name and 20 or 2
	local row = create("Frame", { Size = UDim2.new(1, 0, 0, top + H + 4), BackgroundTransparency = 1, LayoutOrder = self:_next(), Parent = self.Frame })
	local nameText = o.Name and textLabel({ Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -16, 0, 18), Text = o.Name, Parent = row })
	local box = create("Frame", {
		Position = UDim2.fromOffset(6, top), Size = UDim2.new(1, -12, 0, H), ClipsDescendants = true,
		Themed = { BackgroundColor3 = "Background" }, Parent = row,
	}, { corner(6), stroke() })
	local sc = create("ScrollingFrame", {
		Position = UDim2.fromOffset(4, 4), Size = UDim2.new(1, -8, 1, -8), BackgroundTransparency = 1, BorderSizePixel = 0,
		ScrollBarThickness = 2, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Themed = { ScrollBarImageColor3 = "Stroke" }, Parent = box,
	}, { list(2) })
	local empty = textLabel({
		Size = UDim2.fromScale(1, 1), Text = o.Empty or "nothing here", TextSize = 12, TextXAlignment = Enum.TextXAlignment.Center,
		Visible = false, Themed = { TextColor3 = "SubText" }, Parent = box,
	})

	local Listbox = {}
	local rows = {}
	local rowHover = hoverGroup()
	box.MouseLeave:Connect(function() rowHover:clear() end)
	local function paint(v, r, instant)
		local on = selectedValue == v
		local t = instant and 0 or 0.15
		tween(r.Bar, t, { Size = UDim2.fromOffset(3, on and 14 or 0) })
		tween(r.Label, t, { TextColor3 = on and Theme.Text or Theme.SubText, Position = UDim2.fromOffset(on and 14 or 10, 0) })
		tween(r.Button, t, { BackgroundTransparency = on and 0.3 or 1 })
	end
	onTheme(function() for v, r in pairs(rows) do paint(v, r, true) end end)

	function Listbox:Set(v, silent)
		selectedValue = v
		for val, r in pairs(rows) do paint(val, r) end
		if o.Flag then Library.Flags[o.Flag] = v end
		if not silent then fire(o.Callback, v) end
	end
	function Listbox:Get() return selectedValue end
	function Listbox:Refresh(newOptions)
		options = newOptions or options
		for _, r in pairs(rows) do r.Button:Destroy() end
		rows = {}
		if selectedValue ~= nil and not table.find(options, selectedValue) then
			selectedValue = nil
			if o.Flag then Library.Flags[o.Flag] = nil end
		end
		for i, v in ipairs(options) do
			local b = create("TextButton", {
				Size = UDim2.new(1, -4, 0, 26), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = i,
				Themed = { BackgroundColor3 = "Element" }, Parent = sc,
			}, { corner(5) })
			local bar = create("Frame", {
				AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 4, 0.5, 0), Size = UDim2.fromOffset(3, 0),
				BorderSizePixel = 0, Themed = { BackgroundColor3 = "Accent" }, Parent = b,
			}, { corner(2) })
			local lbl = textLabel({ Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -14, 1, 0), Text = tostring(v), TextSize = 12, Themed = { Font = "Font" }, TextColor3 = Theme.SubText, Parent = b })
			local r = { Button = b, Bar = bar, Label = lbl }
			rows[v] = r
			local lastClick = 0
			rowHover:bind(b, function()
				if selectedValue ~= v then tween(b, 0.12, { BackgroundTransparency = 0.6 }); tween(lbl, 0.12, { TextColor3 = Theme.Text }) end
			end, function() paint(v, r) end)
			b.MouseButton1Click:Connect(function()
				local now = os.clock()
				Listbox:Set(v)
				if now - lastClick < 0.35 then fire(o.OnDoubleClick, v) end
				lastClick = now
			end)
			b.MouseButton2Click:Connect(function()
				if not o.ContextItems then return end
				Listbox:Set(v)
				Library:OpenContextMenu(tostring(v), o.ContextItems(v))
			end)
			paint(v, r, true)
		end
		empty.Visible = #options == 0
	end
	function Listbox:Add(v)
		if table.find(options, v) then return end
		local copy = table.clone(options)
		table.insert(copy, v)
		Listbox:Refresh(copy)
	end
	function Listbox:Remove(v)
		local copy = table.clone(options)
		local i = table.find(copy, v)
		if i then table.remove(copy, i); Listbox:Refresh(copy) end
	end

	Listbox:Refresh(options)
	registerFlag(o, function(v) Listbox:Set(v, v == selectedValue) end, selectedValue)
	return self:_register(row, o.Name, Listbox, o, nameText)
end

-- live 3D preview of your own character in a ViewportFrame with a mock ESP overlay on top.
-- { Name, Height, AutoRotate = true, ESP = { Box = true, Name = true, Health = true, Distance = false }, Colors = { Box, Name, Health } }
-- methods: :SetAutoRotate(b) :SetAngle(deg) :Reload() :SetESP(key, enabled, color?)
function Section:AddCharacterPreview(o)
	o = o or {}
	local H = o.Height or 240
	local top = o.Name and 20 or 2
	local row = create("Frame", { Size = UDim2.new(1, 0, 0, top + H + 4), BackgroundTransparency = 1, LayoutOrder = self:_next(), Parent = self.Frame })
	local nameText = o.Name and textLabel({ Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -16, 0, 18), Text = o.Name, Parent = row })
	local box = create("Frame", {
		Position = UDim2.fromOffset(6, top), Size = UDim2.new(1, -12, 0, H), ClipsDescendants = true,
		Themed = { BackgroundColor3 = "Background" }, Parent = row,
	}, { corner(8), stroke() })

	local vp = create("ViewportFrame", {
		Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Ambient = Color3.fromRGB(160, 160, 170),
		LightColor = Color3.new(1, 1, 1), LightDirection = Vector3.new(-1, -1, -1), Parent = box,
	})
	local world = Instance.new("WorldModel")
	world.Parent = vp
	local cam = Instance.new("Camera")
	cam.FieldOfView = 40
	cam.Parent = vp
	vp.CurrentCamera = cam

	local status = textLabel({ Size = UDim2.fromScale(1, 1), Text = "no character", TextSize = 12, TextXAlignment = Enum.TextXAlignment.Center, Visible = false, ZIndex = 4, Themed = { TextColor3 = "SubText" }, Parent = box })
	local hint = textLabel({
		AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -6), Size = UDim2.fromOffset(160, 14), Text = "drag to rotate",
		TextSize = 10, TextXAlignment = Enum.TextXAlignment.Center, TextTransparency = 0.4, ZIndex = 4, Themed = { TextColor3 = "SubText" }, Parent = box,
	})

	-- mock ESP overlay
	local esp = { Box = true, Name = true, Health = true, Distance = false }
	for k, v in pairs(o.ESP or {}) do esp[k] = v end
	local colors = { Box = Color3.fromRGB(255, 255, 255), Name = Color3.new(1, 1, 1), Health = Color3.fromRGB(80, 220, 120) }
	for k, v in pairs(o.Colors or {}) do colors[k] = v end
	local espBox = create("Frame", { BackgroundTransparency = 1, ZIndex = 3, Parent = box })
	local boxStroke = create("UIStroke", { Thickness = 1, Color = colors.Box, Parent = espBox })
	local nameTag = create("TextLabel", {
		AnchorPoint = Vector2.new(0.5, 1), Size = UDim2.fromOffset(160, 14), BackgroundTransparency = 1, Text = LocalPlayer.DisplayName,
		TextSize = 12, Bold = true, TextColor3 = colors.Name, TextStrokeTransparency = 0.5, ZIndex = 3, Parent = box,
	})
	local distTag = create("TextLabel", {
		AnchorPoint = Vector2.new(0.5, 0), Size = UDim2.fromOffset(160, 14), BackgroundTransparency = 1, Text = "0 studs",
		TextSize = 11, TextColor3 = Color3.new(1, 1, 1), TextStrokeTransparency = 0.5, ZIndex = 3, Parent = box,
	})
	local hpBack = create("Frame", { AnchorPoint = Vector2.new(1, 0), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.4, BorderSizePixel = 0, ZIndex = 3, Parent = box })
	local hpFill = create("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.fromScale(1, 1), BackgroundColor3 = colors.Health, BorderSizePixel = 0, ZIndex = 3, Parent = hpBack })

	local model, center, height, width
	local angle = math.rad(o.Angle or 0)
	local auto = o.AutoRotate ~= false
	local dragging, lastX = false, 0

	local Preview = {}
	function Preview:Reload()
		if model then model:Destroy(); model = nil end
		local char = LocalPlayer.Character
		if not char then status.Visible = true; return end
		local ok, clone = pcall(function()
			local prev = char.Archivable
			char.Archivable = true
			local c = char:Clone()
			char.Archivable = prev
			return c
		end)
		if not ok or not clone then status.Visible = true; return end
		for _, d in ipairs(clone:GetDescendants()) do
			if d:IsA("BaseScript") or d:IsA("Sound") or d:IsA("ForceField") or d:IsA("BillboardGui") then
				d:Destroy()
			elseif d:IsA("BasePart") then
				d.Anchored = true
				d.CanCollide = false
			end
		end
		local hum = clone:FindFirstChildOfClass("Humanoid")
		if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
		clone.Parent = world
		-- GetBoundingBox throws on a model with no parts (character still loading right after
		-- a respawn); a zero-size box would also divide by zero in the camera math below
		local okBox, cf, size = pcall(function() return clone:GetBoundingBox() end)
		if not okBox or size.Y <= 0 then
			clone:Destroy()
			status.Visible = true
			return
		end
		center, height, width = cf.Position, size.Y, math.max(size.X, size.Z)
		model = clone
		status.Visible = false
	end
	function Preview:SetAutoRotate(b) auto = b and true or false end
	function Preview:SetAngle(deg) angle = math.rad(tonumber(deg) or 0) end
	function Preview:SetESP(key, enabled, color)
		if enabled ~= nil then esp[key] = enabled and true or false end
		if color then colors[key] = color end
	end

	-- drag to spin
	local dragArea = create("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 5, Parent = box })
	dragArea.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging, lastX = true, input.Position.X
			tween(hint, 0.2, { TextTransparency = 1 })
		end
	end)
	onInputChanged(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			angle -= (input.Position.X - lastX) * 0.012
			lastX = input.Position.X
		end
	end)
	onInputEnded(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragging = false
		end
	end)

	onRenderStepped(function(dt)
		if not model or not box.Parent or box.AbsoluteSize.X <= 0 then return end
		if not visibleOnScreen(box) then return end
		if auto and not dragging then angle += dt * 0.6 end
		local tanV = math.tan(math.rad(cam.FieldOfView / 2))
		local d = (height / 2) / tanV / 0.74
		cam.CFrame = CFrame.lookAt(center + Vector3.new(math.sin(angle) * d, height * 0.04, math.cos(angle) * d), center)

		-- project the character's extents to place the 2D overlay
		local aspect = box.AbsoluteSize.X / box.AbsoluteSize.Y
		local halfH = 0.74 / 2
		local halfW = ((width * 0.62) / 2) / (d * tanV * aspect) / 2
		espBox.Visible = esp.Box
		espBox.Position = UDim2.fromScale(0.5 - halfW, 0.5 - halfH)
		espBox.Size = UDim2.fromScale(halfW * 2, halfH * 2)
		boxStroke.Color = colors.Box
		nameTag.Visible = esp.Name
		nameTag.Position = UDim2.new(0.5, 0, 0.5 - halfH, -3)
		nameTag.TextColor3 = colors.Name
		distTag.Visible = esp.Distance
		distTag.Position = UDim2.new(0.5, 0, 0.5 + halfH, 3)
		hpBack.Visible = esp.Health
		hpBack.Position = UDim2.new(0.5 - halfW, -4, 0.5 - halfH, 0)
		hpBack.Size = UDim2.new(0, 3, halfH * 2, 0)
		local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		local hp = hum and hum.MaxHealth > 0 and math.clamp(hum.Health / hum.MaxHealth, 0, 1) or 1
		hpFill.Size = UDim2.fromScale(1, hp)
		hpFill.BackgroundColor3 = colors.Health
	end)

	if o.AutoReload ~= false then
		connect(LocalPlayer.CharacterAdded, function() task.delay(1, function() Preview:Reload() end) end)
	end
	attachContext(dragArea, o.Name or "Preview", function()
		return {
			{ Text = "Auto rotate", Kind = "check", Checked = auto, Callback = function() auto = not auto end },
			{ Text = "Reset angle", Callback = function() angle = 0 end },
			{ Text = "Reload character", Callback = function() Preview:Reload() end },
		}
	end)
	task.defer(function() Preview:Reload() end)
	return self:_register(row, o.Name or "Preview", Preview, o, nameText)
end

-- live player list with avatars, search and per-player priority
-- { Name, Height = 200, Priorities = {"Neutral","Friendly","Target"}, Callback(player), PriorityChanged(player, priority) }
-- methods: :Get() selected player  :GetPriority(player)  :SetPriority(player, priority)  :Refresh()
local PriorityColors = { Friendly = rgb(80, 220, 120), Target = rgb(255, 85, 85), Neutral = nil }

function Section:AddPlayerList(o)
	o = o or {}
	local H = o.Height or 200
	local priorities = o.Priorities or { "Neutral", "Friendly", "Target" }
	local top = o.Name and 20 or 2
	local row = create("Frame", { Size = UDim2.new(1, 0, 0, top + 30 + H + 4), BackgroundTransparency = 1, LayoutOrder = self:_next(), Parent = self.Frame })
	local nameText = o.Name and textLabel({ Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -60, 0, 18), Text = o.Name, Parent = row })
	local countText = textLabel({
		AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, 0), Size = UDim2.fromOffset(60, 18), TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Right, Themed = { TextColor3 = "SubText" }, Parent = row,
	})
	local search = create("TextBox", {
		Position = UDim2.fromOffset(6, top), Size = UDim2.new(1, -12, 0, 26), PlaceholderText = "Search players...", Text = "",
		TextSize = 12, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left,
		Themed = { BackgroundColor3 = "Element", TextColor3 = "Text", PlaceholderColor3 = "SubText" }, Parent = row,
	}, { corner(6), stroke(), padding(0, 9, 0, 9) })
	local box = create("Frame", {
		Position = UDim2.fromOffset(6, top + 30), Size = UDim2.new(1, -12, 0, H), ClipsDescendants = true,
		Themed = { BackgroundColor3 = "Background" }, Parent = row,
	}, { corner(6), stroke() })
	local sc = create("ScrollingFrame", {
		Position = UDim2.fromOffset(4, 4), Size = UDim2.new(1, -8, 1, -8), BackgroundTransparency = 1, BorderSizePixel = 0,
		ScrollBarThickness = 2, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Themed = { ScrollBarImageColor3 = "Stroke" }, Parent = box,
	}, { list(2) })

	local PlayerList = {}
	local rows = {}
	local rowHover = hoverGroup()
	box.MouseLeave:Connect(function() rowHover:clear() end)
	local priority = {}
	local selected = nil
	local query = ""

	local function paint(plr, r)
		local on = selected == plr
		tween(r.Button, 0.15, { BackgroundTransparency = on and 0.3 or 1 })
		tween(r.Bar, 0.15, { Size = UDim2.fromOffset(3, on and 20 or 0) })
		local p = priority[plr] or priorities[1]
		r.Tag.Text = p
		r.Tag.TextColor3 = PriorityColors[p] or Theme.SubText
	end
	onTheme(function() for plr, r in pairs(rows) do paint(plr, r) end end)

	local function updateCount()
		local n = 0
		for _ in pairs(rows) do n += 1 end
		countText.Text = n .. (n == 1 and " player" or " players")
	end

	local function applyQuery()
		for plr, r in pairs(rows) do
			r.Button.Visible = query == "" or string.lower(plr.Name):find(query, 1, true) ~= nil or string.lower(plr.DisplayName):find(query, 1, true) ~= nil
		end
	end

	function PlayerList:SetPriority(plr, p)
		priority[plr] = p
		if rows[plr] then paint(plr, rows[plr]) end
		fire(o.PriorityChanged, plr, p)
	end
	function PlayerList:GetPriority(plr) return priority[plr] or priorities[1] end
	function PlayerList:Get() return selected end
	function PlayerList:Set(plr, silent)
		selected = plr
		for p, r in pairs(rows) do paint(p, r) end
		if not silent then fire(o.Callback, plr) end
	end

	-- you first, then everyone by display name (equal LayoutOrders shuffle as people join)
	local function resort()
		local list = {}
		for p in pairs(rows) do if p ~= LocalPlayer then table.insert(list, p) end end
		table.sort(list, function(a, b) return string.lower(a.DisplayName) < string.lower(b.DisplayName) end)
		for i, p in ipairs(list) do rows[p].Button.LayoutOrder = i end
	end

	local function addPlayer(plr)
		if rows[plr] then return end
		local isMe = plr == LocalPlayer
		local b = create("TextButton", {
			Size = UDim2.new(1, -4, 0, 38), BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
			LayoutOrder = isMe and 0 or 1, Themed = { BackgroundColor3 = "Element" }, Parent = sc,
		}, { corner(6) })
		local bar = create("Frame", {
			AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0), Size = UDim2.fromOffset(3, 0),
			BorderSizePixel = 0, Themed = { BackgroundColor3 = "Accent" }, Parent = b,
		}, { corner(2) })
		local avatar = create("ImageLabel", {
			AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0), Size = UDim2.fromOffset(26, 26), Image = "",
			Themed = { BackgroundColor3 = "Element" }, Parent = b,
		}, { corner(13) })
		task.spawn(function()
			local ok, img = pcall(function() return Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48) end)
			if ok and img then avatar.Image = img end
		end)
		textLabel({ Position = UDim2.fromOffset(44, 4), Size = UDim2.new(1, -120, 0, 16), Text = plr.DisplayName .. (isMe and "  (you)" or ""), TextSize = 13, TextTruncate = Enum.TextTruncate.AtEnd, Parent = b })
		textLabel({ Position = UDim2.fromOffset(44, 19), Size = UDim2.new(1, -120, 0, 14), Text = "@" .. plr.Name, TextSize = 11, TextTruncate = Enum.TextTruncate.AtEnd, Themed = { TextColor3 = "SubText" }, Parent = b })
		local tag = textLabel({
			AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(70, 14), TextSize = 11,
			Bold = true, TextXAlignment = Enum.TextXAlignment.Right, Themed = { Font = "FontBold" }, TextColor3 = Theme.SubText, Parent = b,
		})
		local r = { Button = b, Bar = bar, Tag = tag }
		rows[plr] = r
		rowHover:bind(b, function() if selected ~= plr then tween(b, 0.12, { BackgroundTransparency = 0.6 }) end end, function() paint(plr, r) end)
		b.MouseButton1Click:Connect(function() PlayerList:Set(plr) end)
		b.MouseButton2Click:Connect(function()
			local items = {}
			for _, p in ipairs(priorities) do
				table.insert(items, { Text = p, Kind = "radio", Checked = PlayerList:GetPriority(plr) == p, Callback = function() PlayerList:SetPriority(plr, p) end })
			end
			table.insert(items, "-")
			table.insert(items, { Text = "Copy username", Callback = function() setClipboard(plr.Name) end })
			table.insert(items, { Text = "Copy user id", Callback = function() setClipboard(tostring(plr.UserId)) end })
			Library:OpenContextMenu(plr.DisplayName, items)
		end)
		-- slide in
		b.BackgroundTransparency = 1
		paint(plr, r)
		updateCount()
		applyQuery()
		resort()
	end
	local function removePlayer(plr)
		local r = rows[plr]
		if not r then return end
		rows[plr] = nil
		priority[plr] = nil
		-- the selected player left: tell the script (otherwise it keeps acting on someone gone)
		if selected == plr then
			selected = nil
			fire(o.Callback, nil)
		end
		tween(r.Button, 0.2, { BackgroundTransparency = 1 })
		task.delay(0.2, function() r.Button:Destroy() end)
		updateCount()
	end
	function PlayerList:Refresh()
		for _, plr in ipairs(Players:GetPlayers()) do addPlayer(plr) end
	end

	search:GetPropertyChangedSignal("Text"):Connect(function()
		query = string.lower(search.Text)
		applyQuery()
	end)
	connect(Players.PlayerAdded, addPlayer)
	connect(Players.PlayerRemoving, removePlayer)
	PlayerList:Refresh()
	return self:_register(row, o.Name or "Players", PlayerList, o, nameText)
end

---------------------------------------------------------------- loader
-- splash card before the window shows up:
-- local L = Library:CreateLoader{ Title, Subtitle }  L:SetStatus("Fetching...", 0.4)  L:Finish(function() ... end)
function Library:CreateLoader(o)
	o = o or {}
	local gui = self:_getGui()
	-- fades + slides up at full size (no UIScale: scaling made the text grow from small to big)
	local card = create("CanvasGroup", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 12), Size = UDim2.fromOffset(300, 150),
		GroupTransparency = 1, ZIndex = 500, Themed = { BackgroundColor3 = "Card" }, Parent = gui,
	}, { corner(10) })
	local asset = self:GetIcon(o.Icon or "paw")
	if asset then
		create("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 20), Size = UDim2.fromOffset(34, 34), BackgroundTransparency = 1,
			Image = asset, ScaleType = Enum.ScaleType.Fit, Themed = { ImageColor3 = "Accent" }, Parent = card,
		})
	end
	textLabel({ Position = UDim2.fromOffset(0, 62), Size = UDim2.new(1, 0, 0, 20), Text = o.Title or "Loading", Bold = true, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Center, Parent = card })
	local status = textLabel({ Position = UDim2.fromOffset(0, 84), Size = UDim2.new(1, 0, 0, 16), Text = o.Subtitle or "starting...", TextSize = 12, TextXAlignment = Enum.TextXAlignment.Center, Themed = { TextColor3 = "SubText" }, Parent = card })
	local track = create("Frame", { Position = UDim2.new(0, 30, 0, 116), Size = UDim2.new(1, -60, 0, 4), BorderSizePixel = 0, Themed = { BackgroundColor3 = "Element" }, Parent = card }, { corner(2) })
	local fill = create("Frame", { Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, Themed = { BackgroundColor3 = "Accent" }, Parent = track }, { corner(2), shade(0, 0.6, 1) })

	tween(card, 0.4, { GroupTransparency = 0, Position = UDim2.fromScale(0.5, 0.5) })

	local Loader = {}
	function Loader:SetStatus(text, progress)
		if text then
			status.Text = text
			status.TextTransparency = 1
			tween(status, 0.2, { TextTransparency = 0 })
		end
		if progress then tween(fill, 0.35, { Size = UDim2.fromScale(math.clamp(progress, 0, 1), 1) }) end
	end
	local finished = false
	function Loader:Finish(cb)
		if finished then return end -- a second call would run cb twice and destroy twice
		finished = true
		tween(fill, 0.25, { Size = UDim2.fromScale(1, 1) })
		task.delay(0.35, function()
			tween(card, 0.3, { GroupTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, -8) }, Enum.EasingStyle.Quad)
			task.delay(0.3, function()
				card:Destroy()
				fire(cb)
			end)
		end)
	end
	return Loader
end

---------------------------------------------------------------- custom cursor
-- A small solid arrow that replaces the system pointer, only while the menu is open. It is one
-- flat colour with no outline: the theme accent (so presets and custom themes recolour it), or
-- Library.CursorColor = Color3 set before CreateWindow for a fixed colour such as black.
-- Library.CustomCursor = false (or the switch in Settings / Window:SetCursor(false)) turns it off
-- and leaves the normal pointer alone.
function Library:_refreshCursor()
	local win = self.Window
	local show = not self.Unloaded and win ~= nil and win._open == true and self.CustomCursor ~= false
		and UserInputService.MouseEnabled ~= false
	local cursor = self._cursorFrame
	if cursor and not cursor.Parent then cursor = nil end -- its gui was destroyed
	if show and not cursor then
		local gui = self:_getGui()
		if not gui then return end
		-- the tip of the arrow is the top-left corner, so that corner sits exactly on the mouse
		cursor = create("Frame", {
			Name = "Cursor", Size = UDim2.fromOffset(10, 16), BackgroundTransparency = 1,
			Active = false, Visible = false, ZIndex = 1000, Parent = gui,
		})
		-- a small solid arrow pointer, drawn as 1px rows (no image file needed, stays sharp):
		-- each entry is { row, first column, width }
		local ARROW = {
			{ 0, 0, 1 }, { 1, 0, 2 }, { 2, 0, 3 }, { 3, 0, 4 }, { 4, 0, 5 }, { 5, 0, 6 }, { 6, 0, 7 }, { 7, 0, 8 },
			{ 8, 0, 9 }, { 9, 0, 10 }, { 10, 0, 6 },
			{ 11, 0, 2 }, { 11, 4, 3 }, { 12, 0, 1 }, { 12, 4, 3 }, -- the tail splits off the body
			{ 13, 5, 3 }, { 14, 5, 3 }, { 15, 6, 1 },
		}
		-- one flat colour: the theme accent, or Library.CursorColor when a script sets one
		local fixed = typeof(self.CursorColor) == "Color3" and self.CursorColor or nil
		for _, r in ipairs(ARROW) do
			create("Frame", {
				Position = UDim2.fromOffset(r[2], r[1]), Size = UDim2.fromOffset(r[3], 1), BorderSizePixel = 0,
				BackgroundColor3 = fixed, Themed = (not fixed) and { BackgroundColor3 = "Accent" } or nil, Parent = cursor,
			})
		end
		self._cursorFrame = cursor
		-- follow the mouse; if the game switches its own pointer back on, hide it again
		-- A drawn cursor reaches the screen about a frame after the real pointer moved, so it
		-- trails behind. Drawing it where the mouse will be one frame from now (its last
		-- movement added on) cancels that. Library.CursorLead = frames to lead by, 0 = off.
		local last
		onRenderStepped(function()
			if not cursor.Visible then last = nil return end
			local m = mousePos()
			local x, y = m.X, m.Y
			local lead = tonumber(Library.CursorLead) or 1
			if last and lead > 0 then
				local dx, dy = (m.X - last.X) * lead, (m.Y - last.Y) * lead
				-- a jump this large is a teleport (menu reopened, mouse recentred), not movement
				if math.abs(dx) <= 80 and math.abs(dy) <= 80 then x, y = x + dx, y + dy end
			end
			last = m
			cursor.Position = UDim2.fromOffset(math.floor(x + 0.5), math.floor(y + 0.5))
			-- the whole handler already runs protected, so no extra pcall (and no new closure) per frame
			if UserInputService.MouseIconEnabled then UserInputService.MouseIconEnabled = false end
		end)
	end
	if cursor then
		if show then
			local m = mousePos()
			cursor.Position = UDim2.fromOffset(m.X, m.Y)
		end
		cursor.Visible = show
	end
	-- hide the system pointer while ours is shown, and put it back exactly as it was after
	pcall(function()
		if show then
			if self._savedMouseIcon == nil then self._savedMouseIcon = UserInputService.MouseIconEnabled end
			UserInputService.MouseIconEnabled = false
		elseif self._savedMouseIcon ~= nil then
			UserInputService.MouseIconEnabled = self._savedMouseIcon
			self._savedMouseIcon = nil
		end
	end)
end

---------------------------------------------------------------- window
function Library:CreateWindow(opts)
	opts = opts or {}
	local SIDEBAR_W, TOP_H = 58, 44
	local MIN_W, MIN_H = 560, 360

	local Window = { Pages = {}, _index = {}, ActivePage = nil, ToggleKey = opts.ToggleKey or Enum.KeyCode.RightShift }
	Library.Window = Window
	local gui = self:_getGui()
	Window.Gui = gui

	-- darkens the game a little while the menu is open so the window stands out. A plain frame
	-- under everything else: it never takes clicks and nothing is added outside this gui.
	-- One frame per gui: a second window reuses it instead of dimming twice.
	local dim = self._dimFrame
	if not dim or dim.Parent ~= gui then
		dim = create("Frame", {
			Name = "Dim", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1,
			BorderSizePixel = 0, Active = false, ZIndex = 0, Parent = gui,
		})
		self._dimFrame = dim
	end
	Window._dim = opts.Dim ~= false

	local main = create("Frame", {
		Name = "Main", Size = opts.Size or UDim2.fromOffset(680, 460), Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0, Themed = { BackgroundColor3 = "Background" }, Parent = gui,
	}, { corner(10), stroke() })
	local uiScale = create("UIScale", { Parent = main })
	Window.Main = main
	Window._uiScale = uiScale

	-- sidebar: same color as the window, just a faint divider
	local sidebar = create("Frame", { Size = UDim2.new(0, SIDEBAR_W, 1, 0), BackgroundTransparency = 1, Parent = main })
	create("Frame", {
		Size = UDim2.new(0, 1, 1, -24), Position = UDim2.new(1, 0, 0, 12), BorderSizePixel = 0, BackgroundTransparency = 0.3,
		Themed = { BackgroundColor3 = "Stroke" }, Parent = sidebar,
	})

	-- logo: embedded image (LogoIcon, default "paw") tinted with the accent, text as fallback
	local logoAsset = Library:GetIcon(opts.LogoIcon or "paw")
	local logo
	if logoAsset then
		logo = create("Frame", { Size = UDim2.new(1, 0, 0, TOP_H + 8), BackgroundTransparency = 1, Parent = sidebar })
		local logoImg = create("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(26, 26),
			BackgroundTransparency = 1, Image = logoAsset, ScaleType = Enum.ScaleType.Fit, Themed = { ImageColor3 = "Accent" }, Parent = logo,
		})
		logo.MouseEnter:Connect(function() tween(logoImg, 0.35, { Rotation = -12, Size = UDim2.fromOffset(29, 29) }, Enum.EasingStyle.Back) end)
		logo.MouseLeave:Connect(function() tween(logoImg, 0.35, { Rotation = 0, Size = UDim2.fromOffset(26, 26) }, Enum.EasingStyle.Back) end)
	else
		logo = textLabel({
			Size = UDim2.new(1, 0, 0, TOP_H + 8), Text = opts.Logo or string.sub(opts.Title or "S", 1, 1), Bold = true,
			TextSize = 22, TextXAlignment = Enum.TextXAlignment.Center, Themed = { TextColor3 = "Accent" }, Parent = sidebar,
		})
	end

	local indicator = create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromOffset(0, TOP_H + 34), Size = UDim2.fromOffset(3, 20),
		BorderSizePixel = 0, BackgroundTransparency = 1, ZIndex = 3, Themed = { BackgroundColor3 = "Accent" }, Parent = sidebar,
	}, { corner(2) })
	local showUser = opts.ShowUser ~= false
	local iconHolder = create("ScrollingFrame", {
		Position = UDim2.fromOffset(0, TOP_H + 14), Size = UDim2.new(1, 0, 1, -(TOP_H + 14 + (showUser and 52 or 0))), BackgroundTransparency = 1,
		BorderSizePixel = 0, ScrollBarThickness = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y, Parent = sidebar,
	}, { list(6, false, { HorizontalAlignment = Enum.HorizontalAlignment.Center }) })

	-- your avatar at the bottom of the sidebar (click for a quick menu)
	if showUser then
		local avatarBtn = create("ImageButton", {
			AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -14), Size = UDim2.fromOffset(32, 32),
			AutoButtonColor = false, Image = "", Themed = { BackgroundColor3 = "Element" }, Parent = sidebar,
		}, { corner(16), stroke() })
		local online = create("Frame", {
			AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, 1, 1, 1), Size = UDim2.fromOffset(9, 9), BackgroundColor3 = rgb(80, 220, 120), ZIndex = 2, Parent = avatarBtn,
		}, { corner(5), create("UIStroke", { Thickness = 2, Themed = { Color = "Background" } }) })
		Library:AttachTooltip(online, "In game")
		task.spawn(function()
			local ok, img = pcall(function()
				return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
			end)
			if ok and img then avatarBtn.Image = img end
		end)
		local avScale = create("UIScale", { Parent = avatarBtn })
		avatarBtn.MouseEnter:Connect(function() tween(avScale, 0.2, { Scale = 1.08 }, Enum.EasingStyle.Back) end)
		avatarBtn.MouseLeave:Connect(function() tween(avScale, 0.2, { Scale = 1 }) end)
		Library:AttachTooltip(avatarBtn, LocalPlayer.DisplayName .. "  (@" .. LocalPlayer.Name .. ")")
		avatarBtn.MouseButton1Click:Connect(function()
			local items = {}
			if Window._settingsPage then
				table.insert(items, { Text = "Settings", Callback = function() Window:Select(Window._settingsPage) end })
			end
			table.insert(items, { Text = "Hide menu", Hint = keyName(Window.ToggleKey) .. " brings it back", Callback = function() Window:SetOpen(false) end })
			table.insert(items, "-")
			table.insert(items, { Text = "Unload", Danger = true, Callback = function()
				Library:Dialog({ Title = "Unload UI?", Text = "This removes the menu and everything it created.",
					Buttons = { { "Cancel" }, { "Unload", function() Library:Unload() end, "danger" } } })
			end })
			Library:OpenContextMenu(LocalPlayer.DisplayName, items)
		end)
	end

	-- content
	local content = create("Frame", { Position = UDim2.fromOffset(SIDEBAR_W, 0), Size = UDim2.new(1, -SIDEBAR_W, 1, 0), BackgroundTransparency = 1, Parent = main })
	local topbar = create("Frame", { Size = UDim2.new(1, 0, 0, TOP_H), BackgroundTransparency = 1, Parent = content })
	local crumb = textLabel({ AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -16, 0, 0), Size = UDim2.new(1, -260, 1, 0), RichText = true, Bold = true, TextXAlignment = Enum.TextXAlignment.Right, Parent = topbar })
	create("Frame", {
		Position = UDim2.fromOffset(12, TOP_H), Size = UDim2.new(1, -24, 0, 1), BorderSizePixel = 0, BackgroundTransparency = 0.3,
		Themed = { BackgroundColor3 = "Stroke" }, Parent = content,
	})
	local pagesHolder = create("Frame", {
		Position = UDim2.fromOffset(0, TOP_H + 1), Size = UDim2.new(1, 0, 1, -(TOP_H + 1)), BackgroundTransparency = 1, ClipsDescendants = true, Parent = content,
	})
	-- page transitions fade through this cover instead of fading the page itself (cheap, no CanvasGroup)
	local pageCover = create("Frame", {
		Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 10, Visible = false,
		Themed = { BackgroundColor3 = "Background" }, Parent = pagesHolder,
	})

	-- search box (top left, searches every page)
	local searchStroke = stroke()
	local search = create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 14, 0.5, 0), Size = UDim2.fromOffset(170, 26),
		Themed = { BackgroundColor3 = "Element" }, Parent = topbar,
	}, { corner(6), searchStroke })
	create("Frame", { Position = UDim2.fromOffset(9, 7), Size = UDim2.fromOffset(9, 9), BackgroundTransparency = 1, Parent = search }, {
		corner(5), create("UIStroke", { Thickness = 1.5, Themed = { Color = "SubText" } }),
	})
	create("Frame", {
		Position = UDim2.fromOffset(15, 16), Size = UDim2.fromOffset(2, 5), Rotation = -45, BorderSizePixel = 0,
		Themed = { BackgroundColor3 = "SubText" }, Parent = search,
	}, { corner(1) })
	local searchBox = create("TextBox", {
		Position = UDim2.fromOffset(26, 0), Size = UDim2.new(1, -50, 1, 0), BackgroundTransparency = 1, Text = "",
		PlaceholderText = "Search features...  (Ctrl+F)", TextSize = 12, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left,
		Themed = { TextColor3 = "Text", PlaceholderColor3 = "SubText" }, Parent = search,
	})
	local clearBtn = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -6, 0.5, 0), Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1,
		Text = "×", TextSize = 16, Visible = false, Themed = { TextColor3 = "SubText" }, Parent = search,
	})

	-- resize grip
	local grip = create("TextButton", {
		AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -3, 1, -3), Size = UDim2.fromOffset(14, 14),
		BackgroundTransparency = 1, Text = "", ZIndex = 5, Parent = main,
	})
	for i = 0, 2 do
		create("Frame", {
			AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -i * 4, 1, 0), Size = UDim2.fromOffset(2, 2 + i * 4),
			BorderSizePixel = 0, Themed = { BackgroundColor3 = "Stroke" }, Parent = grip,
		})
	end
	do
		local resizing, startMouse, startSize, lastSize
		grip.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				resizing, startMouse, startSize = true, input.Position, main.AbsoluteSize / uiScale.Scale
				lastSize = startSize
				if Library._openDropdown then Library._openDropdown:Close() end
				if Library._openOptions then Library._openOptions:Close() end
			end
		end)
		onInputChanged(function(input)
			if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
				local d = (input.Position - startMouse) / uiScale.Scale
				local newW = math.max(MIN_W, startSize.X + d.X)
				local newH = math.max(MIN_H, startSize.Y + d.Y)
				-- track the size ourselves: main.Size may be scale-based (Offset 0) the first time
				local oldW, oldH = lastSize.X, lastSize.Y
				lastSize = Vector2.new(newW, newH)
				main.Size = UDim2.fromOffset(newW, newH)
				main.Position = main.Position + UDim2.fromOffset((newW - oldW) / 2 * uiScale.Scale, (newH - oldH) / 2 * uiScale.Scale)
			end
		end)
		onInputEnded(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then resizing = false end
		end)
	end

	-- sidebar tooltip + subpage flyout
	local tooltip = create("TextLabel", {
		Visible = false, AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.fromOffset(0, 24), AutomaticSize = Enum.AutomaticSize.X,
		TextSize = 12, ZIndex = 9, Themed = { BackgroundColor3 = "Card", TextColor3 = "Text" }, Parent = main,
	}, { corner(6), stroke(), padding(0, 10, 0, 10) })
	-- no UIScale on the flyout: scaling it made the text visibly grow from small to big.
	-- It fades + slides instead.
	local flyStroke = stroke()
	local flyout = create("Frame", {
		Visible = false, Size = UDim2.fromOffset(176, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 10,
		Themed = { BackgroundColor3 = "Card" }, Parent = main,
	}, { corner(8), flyStroke, padding(6), list(2) })
	local flyHeader = textLabel({ Size = UDim2.new(1, 0, 0, 22), TextSize = 11, Bold = true, LayoutOrder = 0, Themed = { TextColor3 = "SubText" }, Parent = flyout })
	padding(0, 8, 0, 0).Parent = flyHeader
	local flyOwner = nil
	local flyHover = false
	local flyRows = hoverGroup()
	local lastClosedPage, lastClosedAt = nil, 0
	local sideHover = hoverGroup()
	sidebar.MouseLeave:Connect(function() sideHover:clear() end)
	flyout.MouseEnter:Connect(function() flyHover = true end)
	flyout.MouseLeave:Connect(function() flyHover = false; flyRows:clear() end)

	makeDraggable(topbar, main)
	makeDraggable(logo, main)

	local function relY(g)
		return (g.AbsolutePosition.Y - main.AbsolutePosition.Y) / uiScale.Scale
	end

	---------------------------------------------------------- flyout
	local function closeFlyout()
		if not flyout.Visible or not flyOwner then return end
		lastClosedPage, lastClosedAt = flyOwner, os.clock()
		flyOwner = nil
		flyHover = false
		-- fade everything out at its real size, then hide
		local OUT = 0.12
		for _, d in ipairs(flyout:GetDescendants()) do
			if d:IsA("TextLabel") then
				tween(d, OUT, { TextTransparency = 1 }, Enum.EasingStyle.Quad)
			elseif d:IsA("GuiObject") then
				tween(d, OUT, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad)
			end
		end
		tween(flyStroke, OUT, { Transparency = 1 }, Enum.EasingStyle.Quad)
		tween(flyout, OUT, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad).Completed:Connect(function()
			if not flyOwner then flyout.Visible = false end
		end)
	end

	local function openFlyout(page)
		for _, c in ipairs(flyout:GetChildren()) do
			if c:IsA("TextButton") then c:Destroy() end
		end
		flyHeader.Text = string.upper(page.Name)
		for i, sub in ipairs(page.SubPages) do
			local current = Window.ActivePage == page and page.Current == sub
			local opt = create("TextButton", {
				Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = Theme.Element, BackgroundTransparency = current and 0.4 or 1,
				Text = "", AutoButtonColor = false, LayoutOrder = i, Parent = flyout,
			}, { corner(6) })
			create("Frame", {
				AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 9, 0.5, 0), Size = UDim2.fromOffset(4, 4),
				BackgroundColor3 = current and Theme.Accent or Theme.Stroke, Parent = opt,
			}, { corner(2) })
			local lbl = textLabel({
				Position = UDim2.fromOffset(22, 0), Size = UDim2.new(1, -22, 1, 0), Text = sub.Name,
				Themed = { Font = "Font" }, TextColor3 = current and Theme.Accent or Theme.Text, Parent = opt,
			})
			-- stagger the rows in
			lbl.TextTransparency = 1
			task.delay(0.03 * i, function() tween(lbl, 0.2, { TextTransparency = 0 }) end)
			flyRows:bind(opt, function()
				tween(opt, 0.12, { BackgroundTransparency = 0 }); tween(lbl, 0.12, { Position = UDim2.fromOffset(25, 0) })
			end, function()
				tween(opt, 0.12, { BackgroundTransparency = current and 0.4 or 1 }); tween(lbl, 0.12, { Position = UDim2.fromOffset(22, 0) })
			end)
			opt.MouseButton1Click:Connect(function()
				Window:Select(page, sub)
				closeFlyout()
			end)
		end
		tooltip.Visible = false
		flyOwner = page
		local y = relY(page.Button)
		flyout.Position = UDim2.fromOffset(SIDEBAR_W + 2, y)
		-- fade the card in at full size while it slides out from the sidebar (rows fade in above)
		flyout.BackgroundTransparency, flyStroke.Transparency, flyHeader.TextTransparency = 1, 1, 1
		flyout.Visible = true
		tween(flyout, 0.18, { BackgroundTransparency = 0, Position = UDim2.fromOffset(SIDEBAR_W + 8, y) })
		tween(flyStroke, 0.18, { Transparency = 0 })
		tween(flyHeader, 0.18, { TextTransparency = 0 })
	end

	connect(UserInputService.InputBegan, function(input)
		if not flyout.Visible then return end
		local t = input.UserInputType
		if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.MouseButton2 or t == Enum.UserInputType.Touch then
			if flyHover then return end
			if flyOwner and flyOwner.Hovered then return end
			closeFlyout()
		end
	end)

	---------------------------------------------------------- open / close
	connect(UserInputService.InputBegan, function(input, gp)
		if gp or Library._binding then return end
		if UserInputService:GetFocusedTextBox() then return end
		if inputMatches(input, Window.ToggleKey) then Window:SetOpen(not Window._open) end
	end)

	local targetScale = 1
	Window._open = true
	local function refreshDim()
		local show = Window._open and Window._dim
		tween(dim, show and 0.3 or 0.18, { BackgroundTransparency = show and 0.55 or 1 }, Enum.EasingStyle.Quad)
	end
	-- Window:SetDim(false) stops the game from darkening behind the open menu
	function Window:SetDim(on)
		Window._dim = on and true or false
		refreshDim()
	end
	refreshDim()
	-- Window:SetOpacity(0.3 .. 1) makes the window and its cards see-through so the game shows
	-- behind the menu. The controls themselves (text, toggles, sliders) stay solid and readable.
	Window._opacity = 1
	function Window:SetOpacity(x)
		x = math.clamp(tonumber(x) or 1, 0.3, 1)
		Window._opacity = x
		main.BackgroundTransparency = 1 - x
		for _, page in ipairs(Window.Pages) do
			for _, sub in ipairs(page.SubPages or {}) do
				for _, sec in ipairs(sub.Sections or {}) do
					if sec.Inner then sec.Inner.BackgroundTransparency = 1 - x end
				end
				if sub._updateFades then sub._updateFades(true) end
			end
		end
		local slider = Window._opacitySlider
		if slider and math.abs((slider:Get() or 0) - x * 100) > 0.5 then slider:Set(x * 100, true) end
	end
	-- Window:SetCursor(false) keeps the normal system pointer instead of the themed one
	if opts.Cursor == false then Library.CustomCursor = false end
	function Window:SetCursor(on)
		Library.CustomCursor = on and true or false
		Library:_refreshCursor()
	end
	Library:_refreshCursor()
	function Window:SetOpen(state)
		Window._open = state
		refreshDim()
		Library:_refreshCursor()
		if state then
			main.Visible = true
			uiScale.Scale = targetScale * 0.92
			tween(uiScale, 0.3, { Scale = targetScale }, Enum.EasingStyle.Back)
			if Window._refreshIndicator then Window._refreshIndicator() end
		else
			flyout.Visible = false; flyOwner = nil; tooltip.Visible = false
			local focusedBox = UserInputService:GetFocusedTextBox()
			if focusedBox and focusedBox:IsDescendantOf(main) then focusedBox:ReleaseFocus() end
			Library:CloseContextMenu()
			if Library._tip then Library._tip.Visible = false end
			if Library._openDropdown then Library._openDropdown:Close() end
			if Library._openOptions then Library._openOptions:Close() end
			for d in pairs(Library._dialogs or {}) do d:Close() end
			if Library._rowHover then Library._rowHover:clear() end
			nudge.release() -- a slider holding the mouse wheel gives the page its scrolling back
			tween(uiScale, 0.14, { Scale = targetScale * 0.92 }, Enum.EasingStyle.Quad).Completed:Connect(function()
				if not Window._open then
					main.Visible = false
					uiScale.Scale = targetScale
				end
			end)
		end
	end
	function Window:SetToggleKey(k)
		-- a key, or a mouse button the key box allows (MB3); clearing it keeps the old key so the
		-- menu can never become impossible to open
		k = parseKey(k)
		if not k then return end
		if k.EnumType ~= Enum.KeyCode and k ~= Enum.UserInputType.MouseButton3 then return end
		Window.ToggleKey = k
		-- keep the Settings key box in step when a script sets the key directly
		local box = Window._menuKeyBind
		if box and box:Get() ~= k then box:Set(k, true) end
	end
	function Window:SetScale(s)
		-- 0 / negative / junk would make the window vanish with no way back
		s = math.clamp(tonumber(s) or 1, 0.3, 3)
		targetScale = s
		uiScale.Scale = s
		local slider = Window._scaleSlider
		if slider and math.abs((slider:Get() or 0) - s) > 1e-3 then slider:Set(s, true) end
	end
	function Window:Center() tween(main, 0.4, { Position = UDim2.fromScale(0.5, 0.5) }) end

	---------------------------------------------------------- breadcrumb
	local crumbToken = 0
	local function renderCrumb(animate)
		local page = Window.ActivePage
		if not page or not page.Current then return end
		local dim = Theme.SubText:ToHex()
		local text
		if #page.SubPages > 1 or page.Current.Name ~= page.Name then
			text = string.format('<font color="#%s">%s</font>  <font color="#%s">›</font>  %s', dim, escapeRich(page.Name), Theme.Accent:ToHex(), escapeRich(page.Current.Name))
		else
			text = escapeRich(page.Name)
		end
		crumbToken += 1
		local token = crumbToken
		if animate ~= true then
			crumb.Text = text
			crumb.TextTransparency = 0
			crumb.Position = UDim2.new(1, -16, 0, 0)
			return
		end
		tween(crumb, 0.1, { TextTransparency = 1, Position = UDim2.new(1, -16, 0, -5) }, Enum.EasingStyle.Quad)
		task.delay(0.1, function()
			if token ~= crumbToken then return end
			crumb.Text = text
			crumb.Position = UDim2.new(1, -16, 0, 6)
			tween(crumb, 0.25, { TextTransparency = 0, Position = UDim2.new(1, -16, 0, 0) })
		end)
	end
	onTheme(function() renderCrumb(false) end)

	local function moveIndicator(page, instant)
		task.defer(function()
			if not page.Button.Parent then return end
			local s = uiScale.Scale
			local y = (page.Button.AbsolutePosition.Y - sidebar.AbsolutePosition.Y) / s + page.Button.AbsoluteSize.Y / s / 2
			-- hide the bar if the active icon is scrolled out of the sidebar's icon area
			local top = (iconHolder.AbsolutePosition.Y - sidebar.AbsolutePosition.Y) / s
			local bottom = top + iconHolder.AbsoluteSize.Y / s
			indicator.BackgroundTransparency = (y < top or y > bottom) and 1 or 0
			if instant then
				indicator.Position = UDim2.fromOffset(0, y)
			else
				tween(indicator, 0.12, { Size = UDim2.fromOffset(3, 30) }, Enum.EasingStyle.Quad)
				tween(indicator, 0.35, { Position = UDim2.fromOffset(0, y) })
				task.delay(0.16, function() tween(indicator, 0.25, { Size = UDim2.fromOffset(3, 20) }) end)
			end
		end)
	end

	Window._refreshIndicator = function()
		if Window.ActivePage then moveIndicator(Window.ActivePage, true) end
	end
	-- keep the accent bar on the active icon when the sidebar scrolls
	iconHolder:GetPropertyChangedSignal("CanvasPosition"):Connect(Window._refreshIndicator)

	---------------------------------------------------------- global search
	-- typing in the top-left box slides a results panel down; click a result to jump to it
	local currentSub = nil
	local RESULT_H, MAX_RESULTS = 38, 7
	local results = create("Frame", {
		Visible = false, Position = UDim2.fromOffset(SIDEBAR_W + 14, TOP_H + 4), Size = UDim2.fromOffset(300, 0),
		ZIndex = 45, ClipsDescendants = true, Themed = { BackgroundColor3 = "Card" }, Parent = main,
	}, { corner(8), stroke() })
	local resultsInner = create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = results }, { padding(6), list(2) })
	local resultsHead = textLabel({ Size = UDim2.new(1, 0, 0, 20), TextSize = 11, Bold = true, LayoutOrder = 0, Themed = { TextColor3 = "SubText" }, Parent = resultsInner })
	padding(0, 8, 0, 0).Parent = resultsHead
	local resultsHover = false
	local resultRows = hoverGroup()
	results.MouseEnter:Connect(function() resultsHover = true end)
	results.MouseLeave:Connect(function() resultsHover = false; resultRows:clear() end)
	local resultsOpen = false
	local firstResult = nil
	local searchHover = false
	search.MouseEnter:Connect(function() searchHover = true end)
	search.MouseLeave:Connect(function() searchHover = false end)

	-- highlight drawn on pagesHolder (no layout there), following the target's on-screen box.
	-- It must never be parented into the target itself: cards/rows use list layouts and
	-- AutomaticSize, so a full-size child gets laid out as another row and blows them up.
	local function flash(target)
		local f = create("Frame", {
			BackgroundTransparency = 0.7, BorderSizePixel = 0, ZIndex = 15, Themed = { BackgroundColor3 = "Accent" }, Parent = pagesHolder,
		}, { corner(8) })
		local function follow()
			local s = uiScale.Scale
			local hp = pagesHolder.AbsolutePosition
			f.Position = UDim2.fromOffset((target.AbsolutePosition.X - hp.X) / s, (target.AbsolutePosition.Y - hp.Y) / s)
			f.Size = UDim2.fromOffset(target.AbsoluteSize.X / s, target.AbsoluteSize.Y / s)
		end
		follow()
		local conn = RunService.RenderStepped:Connect(follow)
		tween(f, 1.4, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad)
		task.delay(1.4, function()
			conn:Disconnect()
			f:Destroy()
		end)
	end

	-- jump to an element (or a section): switch page, expand, scroll it into view, flash it
	function Window:Reveal(el)
		local sec = el.Section or el
		local sub = sec.Sub
		if not sub then return end
		Window:Select(sub.Page, sub)
		-- an element inside a dependency group lives in the group's parent section: expand that one
		local top = sec
		while top._parent do top = top._parent end
		if top.Collapsed and top.SetCollapsed then top:SetCollapsed(false) end
		-- wait for the page transition (0.13 + 0.32s) and a section expand to finish, or the
		-- target is measured mid-slide and the scroll lands a bit off
		task.delay(0.5, function()
			local target = el.Row or sec.Inner
			local scroll = sub.Scroll
			local s = uiScale.Scale
			local y = (target.AbsolutePosition.Y - scroll.AbsolutePosition.Y) / s + scroll.CanvasPosition.Y - 30
			tween(scroll, 0.4, { CanvasPosition = Vector2.new(0, math.max(y, 0)) })
			task.delay(0.25, function() flash(target) end)
		end)
	end

	local function setResultsOpen(state, height)
		resultsOpen = state
		if state then
			results.Visible = true
			tween(results, 0.25, { Size = UDim2.fromOffset(300, height) })
		else
			tween(results, 0.18, { Size = UDim2.fromOffset(300, 0) }, Enum.EasingStyle.Quad).Completed:Connect(function()
				if not resultsOpen then results.Visible = false end
			end)
		end
	end

	local function runSearch()
		for _, c in ipairs(resultsInner:GetChildren()) do
			if c:IsA("TextButton") then c:Destroy() end
		end
		firstResult = nil
		local q = string.lower((searchBox.Text:gsub("^%s+", ""):gsub("%s+$", "")))
		clearBtn.Visible = q ~= ""
		if q == "" then setResultsOpen(false) return end

		-- collect matches: elements and section titles, names that start with the query first
		local found = {}
		local seenSections = {}
		for _, el in ipairs(Window._index) do
			local name = el.Display and string.lower(el.Display) or ""
			-- hidden rows (dependency off, SetVisible(false)) can't be scrolled to, so leave them out
			-- a collapsed section is fine (Reveal expands it), so its content frame is skipped
			local shown = not el.Hidden
			if shown then
				local g = el.Row
				local stop = el.Section and el.Section.Card
				local top = el.Section
				while top and top._parent do top = top._parent end
				local collapsible = top and top.Frame
				while g and g ~= stop do
					if g ~= collapsible and g:IsA("GuiObject") and not g.Visible then shown = false break end
					g = g.Parent
				end
			end
			if name ~= "" and shown and name:find(q, 1, true) then
				-- tostring: a numeric Name would make the sort below compare number < string and throw
				table.insert(found, { el = el, title = tostring(el.Display), kind = "", starts = name:sub(1, #q) == q })
			end
			local sec = el.Section
			if sec and sec.Title and not seenSections[sec] and string.lower(sec.Title):find(q, 1, true) then
				seenSections[sec] = true
				table.insert(found, { el = sec, title = tostring(sec.Title), kind = "Section", starts = string.lower(sec.Title):sub(1, #q) == q })
			end
		end
		table.sort(found, function(a, b)
			if a.starts ~= b.starts then return a.starts end
			return a.title < b.title
		end)

		resultsHead.Text = #found == 0 and "NO RESULTS" or (#found .. (#found == 1 and " RESULT" or " RESULTS"))
		for i = 1, math.min(#found, MAX_RESULTS) do
			local r = found[i]
			local sec = r.el.Section or r.el
			local sub = sec.Sub
			local path = sub.Page.Name .. ((sub.Name ~= sub.Page.Name) and ("  ·  " .. sub.Name) or "") .. "  ·  " .. (r.kind ~= "" and r.kind or (sec.Title or "Section"))
			local b = create("TextButton", {
				Size = UDim2.new(1, 0, 0, RESULT_H), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = i,
				Themed = { BackgroundColor3 = "Element" }, Parent = resultsInner,
			}, { corner(6) })
			create("Frame", {
				AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 6, 0.5, 0), Size = UDim2.fromOffset(3, 22),
				BorderSizePixel = 0, Themed = { BackgroundColor3 = "Accent" }, Parent = b,
			}, { corner(2) })
			local t1 = textLabel({ Position = UDim2.fromOffset(16, 4), Size = UDim2.new(1, -20, 0, 16), Text = r.title, Parent = b })
			local t2 = textLabel({ Position = UDim2.fromOffset(16, 20), Size = UDim2.new(1, -20, 0, 13), Text = path, TextSize = 11, TextTruncate = Enum.TextTruncate.AtEnd, Themed = { TextColor3 = "SubText" }, Parent = b })
			-- rows slide in one after another
			t1.TextTransparency, t2.TextTransparency = 1, 1
			t1.Position = UDim2.fromOffset(24, 4)
			task.delay(0.025 * i, function()
				tween(t1, 0.25, { TextTransparency = 0, Position = UDim2.fromOffset(16, 4) })
				tween(t2, 0.25, { TextTransparency = 0 })
			end)
			resultRows:bind(b, function() tween(b, 0.12, { BackgroundTransparency = 0 }) end, function() tween(b, 0.12, { BackgroundTransparency = 1 }) end)
			local function go()
				searchBox.Text = ""
				searchBox:ReleaseFocus()
				Window:Reveal(r.el)
			end
			b.MouseButton1Click:Connect(go)
			if i == 1 then firstResult = go end
		end
		local shown = math.min(#found, MAX_RESULTS)
		setResultsOpen(true, 12 + 20 + 2 + shown * (RESULT_H + 2))
	end

	searchBox:GetPropertyChangedSignal("Text"):Connect(runSearch)
	searchBox.Focused:Connect(function()
		tween(search, 0.25, { Size = UDim2.fromOffset(230, 26) })
		tween(searchStroke, 0.2, { Color = Theme.Accent })
		if searchBox.Text ~= "" and not resultsOpen then runSearch() end
	end)
	searchBox.FocusLost:Connect(function(enter)
		tween(searchStroke, 0.2, { Color = Theme.Stroke })
		if enter and firstResult then firstResult() end
		if searchBox.Text == "" then tween(search, 0.25, { Size = UDim2.fromOffset(170, 26) }) end
		-- give a click on a result time to land before hiding
		task.delay(0.15, function()
			if not resultsHover and not searchBox:IsFocused() then setResultsOpen(false) end
		end)
	end)
	clearBtn.MouseButton1Click:Connect(function()
		searchBox.Text = ""
		tween(search, 0.25, { Size = UDim2.fromOffset(170, 26) })
	end)
	-- Ctrl+F focuses the search
	connect(UserInputService.InputBegan, function(input, gp)
		if gp or not Window._open then return end
		if input.KeyCode == Enum.KeyCode.F and (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
			task.defer(function() searchBox:CaptureFocus() end)
		end
	end)
	connect(UserInputService.InputBegan, function(input)
		if not resultsOpen then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 and not resultsHover and not searchHover and not searchBox:IsFocused() then
			setResultsOpen(false)
		end
	end)

	---------------------------------------------------------- selection + transitions
	local SLIDE = 22
	function Window:Select(page, sub)
		Window._settingsAuto = false -- any real selection ends "Settings shown only by default"
		sub = sub or page.Current or page.SubPages[1]
		if not sub then return end
		local prev = currentSub
		for _, p in ipairs(Window.Pages) do p:_setActive(p == page) end
		if not prev or prev.Page ~= page then moveIndicator(page, prev == nil) end
		page.Current = sub
		Window.ActivePage = page
		renderCrumb(prev ~= nil and prev ~= sub)
		if prev == sub then return end
		currentSub = sub
		Library._rowHover:clear() -- rows on the page we're leaving never get their MouseLeave
		if Library._openDropdown then Library._openDropdown:Close() end
		if Library._openOptions then Library._openOptions:Close() end

		-- direction: page lower in the sidebar slides up, later subpage slides in from the right
		local dx, dy = 0, 0
		if prev then
			if prev.Page == page then
				local a, b = table.find(page.SubPages, prev) or 0, table.find(page.SubPages, sub) or 0
				dx = b > a and 1 or -1
			else
				local a, b = table.find(Window.Pages, prev.Page) or 0, table.find(Window.Pages, page) or 0
				dy = b > a and 1 or -1
			end
		end

		local new = sub.Group
		local function showOnly(target)
			for _, p in ipairs(Window.Pages) do
				for _, s2 in ipairs(p.SubPages) do s2.Group.Visible = s2.Group == target end
			end
		end
		if not prev or not Library.Animations then
			showOnly(new)
			new.Position = UDim2.fromOffset(0, 0)
			pageCover.Visible = false
			return
		end
		-- 1) old page slides away while the cover fades in over it
		local OUT, IN = 0.13, 0.32
		pageCover.Visible = true
		tween(prev.Group, OUT, { Position = UDim2.fromOffset(-dx * SLIDE, -dy * SLIDE) }, Enum.EasingStyle.Quad)
		tween(pageCover, OUT, { BackgroundTransparency = 1 - (Window._opacity or 1) }, Enum.EasingStyle.Quad)
		-- 2) swap pages under the cover, then the new one slides in as the cover fades out
		task.delay(OUT, function()
			if currentSub ~= sub then return end -- switched again in the meantime; that switch takes over
			showOnly(new)
			new.Position = UDim2.fromOffset(dx * SLIDE, dy * SLIDE)
			tween(new, IN, { Position = UDim2.fromOffset(0, 0) })
			tween(pageCover, IN * 0.8, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad).Completed:Connect(function()
				if currentSub == sub and pageCover.BackgroundTransparency >= 0.99 then pageCover.Visible = false end
			end)
			-- cards rise in one after another
			for i, sec in ipairs(sub.Sections) do
				local c = sec.Inner
				c.Position = UDim2.fromOffset(0, 10)
				task.delay(0.03 * i, function() tween(c, 0.35, { Position = UDim2.fromOffset(0, 0) }) end)
			end
		end)
	end

	---------------------------------------------------------- pages
	function Window:AddPage(popts)
		if type(popts) == "string" then popts = { Name = popts } end
		popts = popts or {}
		-- tostring: a numeric name would crash Name:sub() below
		local Page = { Name = tostring(popts.Name or "Page"), SubPages = {}, Current = nil, Active = false }
		table.insert(Window.Pages, Page)

		local btn = create("TextButton", {
			Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
			LayoutOrder = popts.Order or #Window.Pages, Parent = iconHolder,
		})
		Page.Button = btn
		local tile = create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(38, 38),
			BackgroundTransparency = 1, Themed = { BackgroundColor3 = "Element" }, Parent = btn,
		}, { corner(8) })
		local tileScale = create("UIScale", { Parent = tile })
		-- faint accent wash on the active tile, strongest on the indicator side
		local wash = create("Frame", {
			Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Themed = { BackgroundColor3 = "Accent" }, Parent = tile,
		}, { corner(8), create("UIGradient", { Transparency = NumberSequence.new(0, 1) }) })

		local iconStr = popts.Icon ~= nil and tostring(popts.Icon) or Page.Name:sub(1, 1)
		if iconStr:match("^%d+$") then iconStr = "rbxassetid://" .. iconStr end
		if Library.Icons[iconStr] then
			iconStr = Library:GetIcon(iconStr) or popts.Fallback or Page.Name:sub(1, 1)
		end
		local isImage = iconStr:find("rbxasset") ~= nil or iconStr:find("^http") ~= nil
		if not isImage and (utf8.len(iconStr) or #iconStr) > 2 then
			iconStr = popts.Fallback or Page.Name:sub(1, 1)
		end
		local icon, colorProp
		if isImage then
			icon = create("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(20, 20),
				BackgroundTransparency = 1, Image = iconStr, ImageColor3 = Theme.SubText, ScaleType = Enum.ScaleType.Fit, Parent = tile,
			})
			colorProp = "ImageColor3"
		else
			icon = create("TextLabel", {
				Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = iconStr, Bold = true, TextSize = 18,
				TextColor3 = Theme.SubText, Parent = tile,
			})
			colorProp = "TextColor3"
		end
		-- subpage dot uses the same color as the icon so the sidebar reads as one color
		local subDot = create("Frame", {
			AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -5, 1, -5), Size = UDim2.fromOffset(4, 4),
			BackgroundColor3 = Theme.SubText, BackgroundTransparency = 0.3, Visible = false, Parent = tile,
		}, { corner(2) })

		function Page:_setActive(active, instant)
			Page.Active = active
			local t = instant and 0 or 0.25
			tween(tile, t, { BackgroundTransparency = active and 0 or 1 })
			tween(wash, t, { BackgroundTransparency = active and 0.78 or 1 })
			tween(icon, t, { [colorProp] = active and Theme.Accent or Theme.SubText })
			tween(subDot, t, { BackgroundColor3 = active and Theme.Accent or Theme.SubText })
		end
		onTheme(function() Page:_setActive(Page.Active, true) end)

		-- grouped so a missed MouseLeave can't leave two icons lit / the name tooltip stuck
		sideHover:bind(btn, function()
			Page.Hovered = true
			if not Page.Active then
				tween(tile, 0.15, { BackgroundTransparency = 0.5 })
				tween(icon, 0.15, { [colorProp] = Theme.Text })
			end
			if not flyout.Visible then
				tooltip.Text = Page.Name .. (#Page.SubPages > 1 and "   ·   right-click" or "")
				tooltip.Position = UDim2.fromOffset(SIDEBAR_W + 8, relY(btn) + 20)
				tooltip.Visible = true
			end
		end, function()
			Page.Hovered = false
			if not Page.Active then
				tween(tile, 0.15, { BackgroundTransparency = 1 })
				tween(icon, 0.15, { [colorProp] = Theme.SubText })
			end
			tooltip.Visible = false
		end)
		btn.MouseButton1Down:Connect(function() tween(tileScale, 0.08, { Scale = 0.9 }) end)
		btn.MouseButton1Up:Connect(function() tween(tileScale, 0.3, { Scale = 1 }, Enum.EasingStyle.Back) end)
		btn.MouseLeave:Connect(function() tween(tileScale, 0.2, { Scale = 1 }) end)
		btn.MouseButton1Click:Connect(function()
			closeFlyout()
			Window:Select(Page)
		end)
		btn.MouseButton2Click:Connect(function()
			if #Page.SubPages <= 1 then
				closeFlyout()
				Window:Select(Page)
				return
			end
			if flyOwner == Page then
				closeFlyout()
			elseif lastClosedPage == Page and os.clock() - lastClosedAt < 0.3 then
				return
			else
				openFlyout(Page)
			end
		end)

		function Page:AddSubPage(name)
			local Sub = { Name = name ~= nil and tostring(name) or ("Sub " .. (#Page.SubPages + 1)), Page = Page, Sections = {} }
			table.insert(Page.SubPages, Sub)
			subDot.Visible = #Page.SubPages > 1

			-- plain Frame: a CanvasGroup re-renders its whole contents whenever anything inside changes
			-- (scrolling, hovers, sliders), which makes pages stutter and can blank ViewportFrames
			local group = create("Frame", {
				Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false, Parent = pagesHolder,
			})
			local scroll = create("ScrollingFrame", {
				Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
				ScrollBarThickness = 2, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollingDirection = Enum.ScrollingDirection.Y, Themed = { ScrollBarImageColor3 = "Stroke" }, Parent = group,
			})
			Sub.Group = group
			Sub.Scroll = scroll
			scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
				if Library._tip and Library._tip.Visible then Library._tip.Visible = false end
				nudge.lastScroll = os.clock() -- sliders don't take the wheel while the page moves
			end)
			-- soft fade on the top / bottom edge while there is more page in that direction, so
			-- rows don't get cut off hard. Plain frames above the scroller: they never take clicks.
			local function edgeFade(top)
				return create("Frame", {
					AnchorPoint = Vector2.new(0, top and 0 or 1), Position = UDim2.fromScale(0, top and 0 or 1), Size = UDim2.new(1, -6, 0, 26),
					BackgroundTransparency = 1, BorderSizePixel = 0, Active = false, ZIndex = 5,
					Themed = { BackgroundColor3 = "Background" }, Parent = group,
				}, { create("UIGradient", { Rotation = 90, Transparency = top and NumberSequence.new(0, 1) or NumberSequence.new(1, 0) }) })
			end
			local fadeTop, fadeBottom = edgeFade(true), edgeFade(false)
			local showTop, showBottom = false, false
			local function updateFades(force)
				-- pcall: runs from layout signals, nothing here may ever reach the console
				pcall(function()
					local y = scroll.CanvasPosition.Y
					local max = (scroll.AbsoluteCanvasSize.Y - scroll.AbsoluteWindowSize.Y) / Library:_scale()
					local t, b = y > 4, y < max - 4
					-- a see-through window (Window:SetOpacity) gets fades that are just as see-through
					local shown = 1 - (Window._opacity or 1)
					force = force == true -- the signals pass their own arguments in
					if t ~= showTop or force then
						showTop = t
						tween(fadeTop, 0.15, { BackgroundTransparency = t and shown or 1 }, Enum.EasingStyle.Quad)
					end
					if b ~= showBottom or force then
						showBottom = b
						tween(fadeBottom, 0.15, { BackgroundTransparency = b and shown or 1 }, Enum.EasingStyle.Quad)
					end
				end)
			end
			Sub._updateFades = updateFades
			scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(updateFades)
			scroll:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateFades)
			scroll:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(updateFades)
			-- two columns side by side via a horizontal list (no overlap possible)
			local inner = create("Frame", {
				Position = UDim2.fromOffset(14, 14), Size = UDim2.new(1, -28, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1, Parent = scroll,
			}, { list(12, true, { VerticalAlignment = Enum.VerticalAlignment.Top }), padding(0, 0, 14, 0) })
			local function column(order)
				return create("Frame", {
					Size = UDim2.new(0.5, -6, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
					LayoutOrder = order, Parent = inner,
				}, { list(10) })
			end
			local left, right = column(1), column(2)
			local count = 0

			function Sub:AddSection(so)
				if type(so) == "string" then so = { Name = so } end
				so = so or {}
				count += 1
				local col = (string.lower(tostring(so.Side or "left")) == "right") and right or left
				-- slot keeps the layout position while the card itself can animate
				local slot = create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = count, Parent = col })
				local card = create("Frame", {
					Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1 - (Window._opacity or 1), Themed = { BackgroundColor3 = "Card" }, Parent = slot,
				}, { corner(8), stroke(), padding(6, 6, 8, 6), list(4) })
				local contentFrame = create("Frame", {
					Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = 1, Parent = card,
				}, { list(4) })
				local section = setmetatable({
					Frame = contentFrame, Card = slot, Inner = card, Name = string.lower(so.Name or ""), Title = so.Name, Elements = {}, _order = 0, Sub = Sub, Collapsed = false,
					_lock = { locked = false },
				}, Section)
				table.insert(Sub.Sections, section)

				local chev
				if so.Name then
					local header = create("TextButton", { Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = 0, Parent = card })
					-- optional header icon (embedded icon name, asset id or a glyph)
					local titleX = 8
					if so.Icon then
						local iconText = tostring(so.Icon)
						local asset = Library.Icons[so.Icon] and Library:GetIcon(so.Icon)
							or (iconText:find("rbxasset") and iconText)
							or (iconText:match("^%d+$") and "rbxassetid://" .. iconText)
						if asset then
							create("ImageLabel", {
								AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0), Size = UDim2.fromOffset(13, 13), BackgroundTransparency = 1,
								Image = asset, ScaleType = Enum.ScaleType.Fit, Themed = { ImageColor3 = "SubText" }, Parent = header,
							})
							titleX = 27
						elseif not Library.Icons[so.Icon] and (utf8.len(iconText) or #iconText) <= 2 then
							-- a glyph like "◎"; an icon name whose image couldn't load gets no icon
							-- (the word would be squeezed into 14px on top of the title)
							textLabel({ Position = UDim2.fromOffset(8, 0), Size = UDim2.new(0, 14, 1, 0), Text = iconText, TextSize = 12, Themed = { TextColor3 = "SubText" }, Parent = header })
							titleX = 27
						end
					end
					local title = textLabel({
						Position = UDim2.fromOffset(titleX, 0), Size = UDim2.new(1, -(titleX + 60), 1, 0), Text = string.upper(so.Name), Bold = true, TextSize = 11,
						Themed = { TextColor3 = "SubText" }, Parent = header,
					})
					if so.Tooltip then helpMarker(title, so.Tooltip) end

					-- optional master switch in the header: Toggle = { Flag, Default, Callback }
					if so.Toggle then
						local to = type(so.Toggle) == "table" and so.Toggle or {}
						local on = to.Default ~= false
						local sw = create("TextButton", {
							AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -28, 0.5, 0), Size = UDim2.fromOffset(28, 15),
							Text = "", AutoButtonColor = false, Parent = header,
						}, { corner(8), stroke() })
						local dot = create("Frame", { AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.fromOffset(9, 9), Parent = sw }, { corner(5) })
						blockRowContext(sw)
						local function paint(instant)
							local t = instant and 0 or 0.2
							tween(sw, t, { BackgroundColor3 = on and Theme.Accent or Theme.Element })
							tween(dot, t, { Position = on and UDim2.new(1, -12, 0.5, 0) or UDim2.new(0, 3, 0.5, 0), BackgroundColor3 = on and Color3.new(1, 1, 1) or Theme.SubText })
						end
						local function apply(silent)
							paint()
							if to.Flag then Library.Flags[to.Flag] = on end
							-- switching a section off locks everything inside it
							if to.LockContent ~= false then
								section._lock.locked = not on
								for _, el in ipairs(section.Elements) do
									if el.Api._setSectionLocked then el.Api:_setSectionLocked(not on) end
								end
							end
							if not silent then fire(to.Callback, on) end
						end
						function section:SetEnabled(b, silent) on = b and true or false; apply(silent) end
						function section:GetEnabled() return on end
						sw.MouseButton1Click:Connect(function() section:SetEnabled(not on) end)
						onTheme(function() paint(true) end)
						paint(true)
						registerFlag(to, function(b) section:SetEnabled(b, (b and true or false) == on) end, on)
						task.defer(function() if not on then apply(true) end end)
					end
					chev = textLabel({
						AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(1, -12, 0.5, -1), Size = UDim2.fromOffset(12, 12), Rotation = 90,
						Text = "›", TextSize = 16, TextXAlignment = Enum.TextXAlignment.Center, TextTransparency = 0.5, Themed = { TextColor3 = "SubText" }, Parent = header,
					})
					header.MouseEnter:Connect(function() tween(title, 0.15, { TextColor3 = Theme.Text }); tween(chev, 0.15, { TextTransparency = 0 }) end)
					header.MouseLeave:Connect(function() tween(title, 0.15, { TextColor3 = Theme.SubText }); tween(chev, 0.15, { TextTransparency = 0.5 }) end)
					header.MouseButton1Click:Connect(function() section:SetCollapsed(not section.Collapsed) end)
				end

				local layout = contentFrame:FindFirstChildOfClass("UIListLayout")
				function section:SetCollapsed(b, instant)
					section.Collapsed = b and true or false
					if Library._openDropdown then Library._openDropdown:Close() end
					if Library._openOptions then Library._openOptions:Close() end
					if chev then tween(chev, 0.25, { Rotation = b and 0 or 90 }) end
					contentFrame.ClipsDescendants = true
					if b then
						local full = layout.AbsoluteContentSize.Y / uiScale.Scale
						contentFrame.AutomaticSize = Enum.AutomaticSize.None
						contentFrame.Size = UDim2.new(1, 0, 0, full)
						tween(contentFrame, instant and 0 or 0.28, { Size = UDim2.new(1, 0, 0, 0) }).Completed:Connect(function()
							if section.Collapsed then contentFrame.Visible = false end
						end)
					else
						contentFrame.AutomaticSize = Enum.AutomaticSize.None
						contentFrame.Size = UDim2.new(1, 0, 0, 0)
						contentFrame.Visible = true
						task.spawn(function()
							RunService.Heartbeat:Wait() -- let the layout measure its rows again
							if section.Collapsed then return end
							local full = layout.AbsoluteContentSize.Y / uiScale.Scale
							tween(contentFrame, instant and 0 or 0.28, { Size = UDim2.new(1, 0, 0, full) }).Completed:Connect(function()
								if not section.Collapsed then
									contentFrame.AutomaticSize = Enum.AutomaticSize.Y
									contentFrame.Size = UDim2.new(1, 0, 0, 0)
									contentFrame.ClipsDescendants = false
								end
							end)
						end)
					end
				end
				if so.Collapsed then task.defer(function() section:SetCollapsed(true, true) end) end
				return section
			end

			if not Window.ActivePage then
				Window:Select(Page, Sub)
				Window._settingsAuto = Page == Window._settingsPage
			elseif Window._settingsAuto and Page ~= Window._settingsPage then
				-- Settings was only shown because it was added first: open on the first real page
				Window:Select(Page, Sub)
			end
			return Sub
		end

		function Page:AddSection(so)
			if not Page._default then Page._default = Page:AddSubPage(Page.Name) end
			return Page._default:AddSection(so)
		end

		Page:_setActive(false, true)
		return Page
	end

	---------------------------------------------------------- built-in settings page
	function Window:AddSettingsPage(o)
		o = o or {}
		local Settings = Window:AddPage({ Name = o.Name or "Settings", Icon = o.Icon or "settings", Fallback = "≡", Order = 999 })
		Window._settingsPage = Settings
		local MenuSub = Settings:AddSubPage("Menu")
		local ConfigSub = Settings:AddSubPage("Configs")
		local ThemeSub = Settings:AddSubPage("Theme")

		-- MENU
		local menu = MenuSub:AddSection({ Name = "Menu" })
		local menuKey
		menuKey = menu:AddKeybind({ Name = "Menu Key", Default = Window.ToggleKey, Flag = "UI_MenuKey", NoModes = true, ShowInList = false,
			Tooltip = "Key that opens and closes this window",
			Changed = function(k)
				Window:SetToggleKey(k)
				-- the menu always needs a key: a cleared / unusable key snaps back to the real one
				if Window.ToggleKey ~= k and menuKey then menuKey:Set(Window.ToggleKey, true) end
			end })
		Window._menuKeyBind = menuKey
		Window._scaleSlider = menu:AddSlider({ Name = "UI Scale", Min = 0.6, Max = 1.4, Increment = 0.05, Default = 1, Flag = "UI_Scale",
			Callback = function(v) Window:SetScale(v) end })
		menu:AddToggle({ Name = "Animations", Default = true, Flag = "UI_Animations", Tooltip = "Turn off to make every transition instant",
			Callback = function(v) Library.Animations = v end })
		menu:AddToggle({ Name = "Dim Background", Default = Window._dim, Flag = "UI_Dim", Tooltip = "Darken the game behind the menu while it is open",
			Callback = function(v) Window:SetDim(v) end })
		menu:AddToggle({ Name = "Custom Cursor", Default = Library.CustomCursor ~= false, Flag = "UI_Cursor", Tooltip = "Show the themed cursor while the menu is open",
			Callback = function(v) Window:SetCursor(v) end })
		Window._opacitySlider = menu:AddSlider({ Name = "Menu Opacity", Min = 30, Max = 100, Increment = 5, Default = math.floor((Window._opacity or 1) * 100 + 0.5),
			Suffix = "%", Flag = "UI_Opacity", Tooltip = "Lower it to see the game through the menu",
			Callback = function(v) Window:SetOpacity(v / 100) end })
		menu:AddToggle({ Name = "Click Ripple", Default = Library.ClickRipple ~= false, Flag = "UI_Ripple", Tooltip = "Small pulse where you press a button or toggle",
			Callback = function(v) Library.ClickRipple = v end })
		menu:AddButtons({
			{ "Center", function() Window:Center() end, Tooltip = "Move the window back to the middle" },
			{ "Unload", function()
				Library:Dialog({
					Title = "Unload UI?", Text = "This removes the menu and everything it created.",
					Buttons = { { "Cancel" }, { "Unload", function() Library:Unload() end, "danger" } },
				})
			end },
		})

		local overlays = MenuSub:AddSection({ Name = "Overlays", Side = "Right" })
		overlays:AddToggle({ Name = "Watermark", Default = Library.Watermark ~= nil, Flag = "UI_Watermark", Callback = function(v)
			if v and not Library.Watermark then
				-- created late: pick up the title / info settings chosen while it didn't exist
				local wm = Library:CreateWatermark({ Title = o.Title })
				local title = Library.Flags.UI_WatermarkTitle
				if type(title) == "string" and title ~= "" then wm:SetTitle(title) end
				local info = Library.Flags.UI_WatermarkInfo
				if type(info) == "table" then
					local set = {}
					for _, x in ipairs(info) do set[x] = true end
					wm.Show = { FPS = set.FPS or false, Ping = set.Ping or false, Time = set.Time or false }
				end
			end
			if Library.Watermark then Library.Watermark:SetVisible(v) end
		end })
		overlays:AddToggle({ Name = "Keybind List", Default = Library.KeyList ~= nil, Flag = "UI_KeyList", Callback = function(v)
			if v then Library:CreateKeybindList() end
			if Library.KeyList then Library.KeyList:SetVisible(v) end
		end })
		overlays:AddDropdown({ Name = "Watermark Info", Multi = true, Options = { "FPS", "Ping", "Time" }, Default = { "FPS", "Ping", "Time" },
			Flag = "UI_WatermarkInfo", Callback = function(sel)
				if not Library.Watermark then return end
				local set = {}
				for _, x in ipairs(sel) do set[x] = true end
				Library.Watermark.Show = { FPS = set.FPS or false, Ping = set.Ping or false, Time = set.Time or false }
			end })
		overlays:AddTextbox({ Name = "Watermark Title", Default = o.Title or "SleekUI", Flag = "UI_WatermarkTitle",
			Callback = function(t) if Library.Watermark then Library.Watermark:SetTitle(t) end end })
		overlays:AddDropdown({ Name = "Notifications", Options = { "BottomRight", "TopRight", "BottomLeft", "TopLeft" }, Default = "BottomRight",
			Flag = "UI_NotifPos", Description = "Where pop-ups appear",
			Callback = function(v)
				local prev = Library._notifPosition or "BottomRight"
				Library:SetNotificationPosition(v)
				-- only when it actually moved (config loads / autoload re-apply the same value)
				if v ~= prev then Library:Notify({ Title = "Notifications", Text = "They'll show up here now.", Duration = 2 }) end
			end })

		-- CONFIGS (profiles: list of saved configs, a name box, stacked actions)
		local cfg = ConfigSub:AddSection({ Name = "Profiles", Icon = "settings" })
		local cfgName = ""
		local cfgSelected
		local function report(ok, err, okText)
			Library:Notify({ Title = "Config", Text = ok and okText or tostring(err), Type = ok and "success" or "error", Duration = 2.5 })
		end
		local cfgList
		local autoLabel
		local function refresh()
			cfgList:Refresh(Library:ListConfigs())
			if cfgSelected and not Library:ConfigExists(cfgSelected) then cfgSelected = nil end
		end
		local gameLabel
		local function syncAutoLabel()
			if not autoLabel then return end
			local current = Library:GetAutoload()
			autoLabel:Set("Autoload: " .. (current ~= "" and current or "none"))
			if gameLabel then
				local here = Library:GetGameAutoload()
				gameLabel:Set("In this game: " .. (here ~= "" and here or "same as above"))
			end
		end
		local function loadSelected(name)
			name = name or cfgSelected
			if not name then return report(false, "Select a config first") end
			local ok, err = Library:LoadConfig(name)
			report(ok, err, 'Loaded "' .. name .. '"')
		end
		local function overwriteSelected()
			if not cfgSelected then return report(false, "Select a config first") end
			local target = cfgSelected
			Library:Dialog({ Title = "Overwrite config?", Text = '"' .. target .. '" will be replaced with your current settings.',
				Buttons = { { "Cancel" }, { "Overwrite", function()
					local ok, err = Library:SaveConfig(target)
					report(ok, err, 'Saved "' .. target .. '"')
				end, "primary" } } })
		end
		local function deleteSelected()
			if not cfgSelected then return report(false, "Select a config first") end
			local target = cfgSelected
			Library:Dialog({ Title = "Delete config?", Text = '"' .. target .. '" will be removed for good.',
				Buttons = { { "Cancel" }, { "Delete", function()
					local ok, err = Library:DeleteConfig(target)
					report(ok, err, 'Deleted "' .. target .. '"')
					cfgSelected = nil
					refresh()
					syncAutoLabel()
				end, "danger" } } })
		end
		local function setAutoload(name)
			local ok = Library:SetAutoload(name)
			syncAutoLabel()
			return ok
		end

		cfgList = cfg:AddListbox({
			Name = "Configs", Options = Library:ListConfigs(), Height = 130, Empty = FS.ok and "no configs yet" or "file access unavailable",
			Tooltip = "Double-click to load, right-click for more",
			Callback = function(v) cfgSelected = v end,
			OnDoubleClick = function(v) loadSelected(v) end,
			ContextItems = function(v)
				return {
					{ Text = "Load", Callback = function() loadSelected(v) end },
					{ Text = "Overwrite", Callback = overwriteSelected },
					{ Text = "Set as autoload", Callback = function()
						local ok = setAutoload(v)
						report(ok, "file functions unavailable", '"' .. v .. '" will autoload')
					end },
					{ Text = "Autoload in this game", Hint = "only here", Callback = function()
						local ok, err = Library:SetGameAutoload(v)
						syncAutoLabel()
						report(ok, err, '"' .. v .. '" will autoload in this game')
					end },
					"-",
					{ Text = "Rename", Callback = function()
						Library:Dialog({ Title = "Rename config", Input = { Default = v, Placeholder = "new name" },
							Buttons = { { "Cancel" }, { "Rename", function(newName)
								local ok, err = Library:RenameConfig(v, newName or "")
								report(ok, err, 'Renamed to "' .. cleanName(newName or "") .. '"')
								if ok then cfgSelected = cleanName(newName); refresh(); cfgList:Set(cfgSelected, true); syncAutoLabel() end
							end, "primary" } } })
					end },
					{ Text = "Duplicate", Callback = function()
						local ok, res = Library:DuplicateConfig(v)
						report(ok, res, 'Created "' .. tostring(res) .. '"')
						refresh()
					end },
					{ Text = "Copy to clipboard", Hint = "share it as text", Callback = function()
						local ok, err = Library:ExportConfig(v)
						report(ok, err, "Config copied to clipboard")
					end },
					"-",
					{ Text = "Delete", Danger = true, Callback = deleteSelected },
				}
			end,
		})
		cfg:AddTextbox({ Name = "Config Name", Placeholder = "Config name", NoSave = true, Callback = function(t) cfgName = t end })
		local function createConfig()
			local name = cleanName(cfgName)
			local function doIt()
				local ok, err = Library:SaveConfig(name)
				report(ok, err, 'Created "' .. name .. '"')
				refresh()
				if ok then cfgList:Set(name, true); cfgSelected = name end
			end
			if name ~= "" and Library:ConfigExists(name) then
				Library:Dialog({ Title = "Overwrite config?", Text = '"' .. name .. '" already exists.',
					Buttons = { { "Cancel" }, { "Overwrite", doIt, "primary" } } })
			else
				doIt()
			end
		end
		cfg:AddButton({ Name = "Create", Callback = createConfig })
		cfg:AddButton({ Name = "Load", Callback = function() loadSelected() end })
		cfg:AddButton({ Name = "Delete", Callback = deleteSelected })
		cfg:AddButton({ Name = "Overwrite", Callback = overwriteSelected })
		-- remembered in its own file, not inside configs (loading a config must not switch it)
		local autoSaveOn = Library:GetAutoSave()
		cfg:AddToggle({ Name = "Auto Save", Default = autoSaveOn, NoSave = true, Flag = "UI_AutoSave",
			Tooltip = "Saves your changes into the config you last loaded or saved, by itself",
			Callback = function(v) Library:SetAutoSave(v) end })
		if autoSaveOn then Library:SetAutoSave(true) end

		local auto = ConfigSub:AddSection({ Name = "Autoload", Side = "Right" })
		autoLabel = auto:AddLabel("Autoload: " .. (Library:GetAutoload() ~= "" and Library:GetAutoload() or "none"))
		auto:AddButtons({
			{ "Set Selected", function()
				if not cfgSelected then return report(false, "Select a config first") end
				report(setAutoload(cfgSelected), "file functions unavailable", '"' .. cfgSelected .. '" will autoload')
			end },
			{ "Clear", function()
				report(setAutoload(""), "file functions unavailable", "Autoload cleared")
			end },
		})
		-- a different config for the game you are in right now; it wins over the one above
		gameLabel = auto:AddLabel("In this game: same as above")
		auto:AddButtons({
			{ "Set For Game", function()
				if not cfgSelected then return report(false, "Select a config first") end
				local ok, err = Library:SetGameAutoload(cfgSelected)
				syncAutoLabel()
				report(ok, err, '"' .. cfgSelected .. '" will autoload in this game')
			end, Tooltip = "Autoload the selected config only in this game" },
			{ "Clear Game", function()
				local ok, err = Library:SetGameAutoload("")
				syncAutoLabel()
				report(ok, err, "This game uses the normal autoload again")
			end },
		})
		syncAutoLabel()
		auto:AddButton({ Name = "Refresh List", Callback = refresh })
		auto:AddButton({ Name = "Import From Text", Tooltip = "Paste config text someone shared with you", Callback = function()
			Library:Dialog({ Title = "Import config", Text = "Paste the config text, then name it.", Input = { Placeholder = "paste config text here" },
				Buttons = { { "Cancel" }, { "Next", function(json)
					Library:Dialog({ Title = "Name it", Input = { Placeholder = "config name" },
						Buttons = { { "Cancel" }, { "Import", function(name)
							local ok, err = Library:ImportConfig(name or "", json or "")
							report(ok, err, 'Imported "' .. cleanName(name or "") .. '"')
							refresh()
						end, "primary" } } })
				end, "primary" } } })
		end })
		auto:AddButton({ Name = "Copy Current Settings", Tooltip = "Copies your current settings as text", Callback = function()
			local ok, err = Library:ExportConfig(nil)
			report(ok, err, "Settings copied to clipboard")
		end })
		auto:AddLabel(FS.ok and ("Files live in workspace/" .. Library.Directory .. "/configs") or "File functions are not available here, configs are disabled.")

		-- THEME
		local th = ThemeSub:AddSection({ Name = "Colors" })
		th:AddDropdown({ Name = "Preset", Options = PresetOrder, Default = "Default", NoSave = true, Flag = "Theme_Preset",
			Callback = function(name) Library:ApplyTheme(name) end })
		th:AddDivider()
		-- dragging a theme picker fires many times per frame; recolouring the whole UI each time lags,
		-- so changes are collected and applied once per frame
		local pendingTheme = {}
		onHeartbeat(function()
			if next(pendingTheme) == nil then return end
			local batch = pendingTheme
			pendingTheme = {}
			Library:_batchTheme(function()
				for key, c in pairs(batch) do Library:SetTheme(key, c) end
			end)
		end)
		for _, key in ipairs(ThemeKeys) do
			th:AddColorPicker({ Name = key, Default = Theme[key], Flag = "Theme_" .. key, NoTransparency = true,
				Callback = function(c) pendingTheme[key] = c end })
		end

		local fonts = ThemeSub:AddSection({ Name = "Text", Side = "Right" })
		fonts:AddDropdown({ Name = "Font", Options = FontOrder, Default = Theme.FontName, Flag = "Theme_Font",
			Callback = function(name) Library:SetFont(name) end })

		local saved = ThemeSub:AddSection({ Name = "Saved Themes", Side = "Right" })
		local themeName, themeSel = "", nil
		saved:AddTextbox({ Name = "Theme Name", Placeholder = "my theme", NoSave = true, Callback = function(t) themeName = t end })
		local themeList = saved:AddDropdown({ Name = "Saved", Options = Library:ListThemes(), NoSave = true, Callback = function(v) themeSel = v end })
		local function refreshThemes() themeList:Refresh(Library:ListThemes()) end
		saved:AddButtons({
			{ "Save", function()
				local ok, err = Library:SaveTheme(themeName ~= "" and themeName or (themeSel or ""))
				Library:Notify({ Title = "Theme", Text = ok and "Saved" or tostring(err), Type = ok and "success" or "error", Duration = 2 })
				refreshThemes()
			end },
			{ "Load", function()
				if not themeSel then return end
				local ok, err = Library:LoadTheme(themeSel)
				Library:Notify({ Title = "Theme", Text = ok and ("Loaded " .. themeSel) or tostring(err), Type = ok and "success" or "error", Duration = 2 })
			end },
			{ "Refresh", refreshThemes },
		})

		task.delay(o.AutoloadDelay or 0.5, function()
			if Library.Unloaded or o.Autoload == false then return end
			local ok, res = Library:LoadAutoload()
			if ok then Library:Notify({ Title = "Config", Text = 'Autoloaded "' .. res .. '"', Type = "success" }) end
		end)
		return Settings
	end

	function Window:Destroy()
		Window._open = false
		Library:_refreshCursor() -- gives the system pointer back
		gui:Destroy()
	end

	-- pop in on creation
	uiScale.Scale = 0.92
	task.defer(function() tween(uiScale, 0.4, { Scale = targetScale }, Enum.EasingStyle.Back) end)

	return Window
end

-- Library:OnUnload(fn) runs fn when the UI is unloaded (put your cleanup here)
function Library:OnUnload(fn)
	table.insert(self._unloadFns, fn)
end

function Library:Unload()
	if self.Unloaded then return end
	self.Unloaded = true
	pcall(function() self:_refreshCursor() end) -- gives the system pointer back
	for _, fn in ipairs(self._unloadFns) do pcall(fn) end
	for _, c in ipairs(self.Connections) do pcall(function() c:Disconnect() end) end
	table.clear(self.Connections)
	local gui = self._gui
	if gui then
		-- shrink the window out and slide the overlays away, then remove everything
		local win = self.Window
		if win and win._open and win.Main and win._uiScale then
			local s = win._uiScale.Scale
			TweenService:Create(win._uiScale, TweenInfo.new(0.18, Enum.EasingStyle.Quad), { Scale = s * 0.92 }):Play()
		end
		for _, overlay in ipairs({ self.Watermark and self.Watermark.Frame, self.KeyList and self.KeyList.Frame }) do
			if overlay then
				TweenService:Create(overlay, TweenInfo.new(0.18, Enum.EasingStyle.Quad), { Position = overlay.Position - UDim2.fromOffset(0, 12) }):Play()
			end
		end
		task.delay(0.18, function() gui:Destroy() end)
	end
	self._gui, self.Watermark, self.KeyList, self.Window, self._tip = nil, nil, nil, nil, nil
	pcall(function() if getgenv and getgenv().SleekUI == self then getgenv().SleekUI = nil end end)
end

pcall(function() if getgenv then getgenv().SleekUI = Library end end)

return Library
