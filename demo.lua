--[[
	SleekUI - full demo

	Shows everything the library can do, using only the public API, so you can copy any
	part of it into your own scripts. None of the controls touch the game; they just show
	notifications or update other parts of the menu.

	Run it in your executor (a baseplate is fine). RightShift opens / closes the menu.
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ElsDevs/ui/main/SleekUI.lua"))()

---------------------------------------------------------------------------------------------
-- Loader (optional splash card while your script sets up)
---------------------------------------------------------------------------------------------
local Loader = Library:CreateLoader({ Title = "SleekUI", Subtitle = "starting..." })
Loader:SetStatus("loading assets", 0.4)
task.wait(0.3)
Loader:SetStatus("building interface", 0.8)

---------------------------------------------------------------------------------------------
-- Overlays: create them before keybinds so every bind shows up in the list
---------------------------------------------------------------------------------------------
local Watermark = Library:CreateWatermark({ Title = "SleekUI", Show = { FPS = true, Ping = true, Time = true } })
local KeyList = Library:CreateKeybindList()

---------------------------------------------------------------------------------------------
-- Window
---------------------------------------------------------------------------------------------
local Window = Library:CreateWindow({
	Title = "SleekUI",
	LogoIcon = "paw",                    -- built-in icons: paw, combat, movement, visuals, settings
	ToggleKey = Enum.KeyCode.RightShift, -- also changeable in Settings > Menu
	-- Size = UDim2.fromOffset(680, 460),
	-- ShowUser = false,                 -- hide your avatar at the bottom of the sidebar
})
Window:SetOpen(false) -- stay hidden until the loader finishes

-- small helper used by the demo controls
local function notify(title, text, kind)
	Library:Notify({ Title = title, Text = text, Type = kind, Duration = 2 })
end

---------------------------------------------------------------------------------------------
-- PAGE 1: Home - notifications, dialogs, menus, progress
---------------------------------------------------------------------------------------------
local Home = Window:AddPage({ Name = "Home", Icon = "paw" })
local Welcome = Home:AddSubPage("Welcome")

local intro = Welcome:AddSection({ Name = "Welcome", Icon = "paw" })
intro:AddParagraph({
	Title = "Getting around",
	Text = "Left-click a sidebar icon to open a page, right-click it to pick a subpage. "
		.. "Right-click most controls for extra options. Ctrl+F searches every page.",
})
intro:AddLabel("Everything here is a demo: no control changes the game.")
intro:AddDivider("notifications")
intro:AddButtons({
	{ "Info", function() Library:Notify({ Title = "Info", Text = "A plain notification." }) end },
	{ "Success", function() Library:Notify({ Title = "Saved", Text = "It worked.", Type = "success" }) end },
	{ "Warning", function() Library:Notify({ Title = "Careful", Text = "Something looks off.", Type = "warning" }) end },
	{ "Error", function() Library:Notify({ Title = "Failed", Text = "Something went wrong.", Type = "error" }) end },
})
intro:AddButton({ Name = "Notification with an icon", Callback = function()
	Library:Notify({ Title = "Combat", Text = "Notifications can show a built-in icon.", Icon = "combat", Duration = 3 })
end })
intro:AddLabel("Hover a notification to pause it. Press the same button twice to see it count up.")
intro:AddDropdown({
	Name = "Notification corner", Options = { "BottomRight", "TopRight", "BottomLeft", "TopLeft" }, Default = "BottomRight",
	NoSave = true, Callback = function(corner) Library:SetNotificationPosition(corner) end,
})

local dialogs = Welcome:AddSection({ Name = "Dialogs & menus", Side = "Right" })
dialogs:AddButton({ Name = "Confirm dialog", Callback = function()
	Library:Dialog({
		Title = "Delete everything?", Text = "Dialogs sit over the window. Enter confirms, Escape cancels.",
		Buttons = { { "Cancel" }, { "Delete", function() notify("Dialog", "You picked Delete", "success") end, "danger" } },
	})
end })
dialogs:AddButton({ Name = "Dialog with a text field", Callback = function()
	Library:Dialog({
		Title = "Rename", Input = { Placeholder = "new name", Default = "My Script" },
		Buttons = { { "Cancel" }, { "Save", function(text) notify("Dialog", "You typed: " .. tostring(text), "success") end, "primary" } },
	})
end })
dialogs:AddButton({ Name = "Open a custom right-click menu", Callback = function()
	Library:OpenContextMenu("Example menu", {
		{ Text = "Plain item", Callback = function() notify("Menu", "Plain item") end },
		{ Text = "With a hint", Hint = "small grey second line", Callback = function() notify("Menu", "Hint item") end },
		"-",
		{ Text = "Radio A", Kind = "radio", Checked = true, Callback = function() notify("Menu", "Radio A") end },
		{ Text = "Radio B", Kind = "radio", Checked = false, Callback = function() notify("Menu", "Radio B") end },
		{ Text = "A checkbox", Kind = "check", Checked = true, Callback = function() notify("Menu", "Checkbox") end },
		"-",
		{ Text = "Dangerous", Danger = true, Callback = function() notify("Menu", "Danger item", "warning") end },
	})
end })
dialogs:AddButton({ Name = "Button that needs two clicks", Confirm = true, ConfirmText = "Click again to confirm",
	Callback = function() notify("Button", "Confirmed", "success") end })

local progressSec = Welcome:AddSection({ Name = "Progress", Side = "Right" })
local bar = progressSec:AddProgress({ Name = "Download", Default = 0.25 })
local percentBar = progressSec:AddProgress({ Name = "Custom format", Default = 0.5,
	Format = function(v) return string.format("%d / 200", math.floor(v * 200)) end })
progressSec:AddButtons({
	{ "Run", function()
		task.spawn(function()
			for i = 0, 20 do bar:Set(i / 20); percentBar:Set(i / 20); task.wait(0.06) end
			notify("Progress", "Done", "success")
		end)
	end },
	{ "Reset", function() bar:Set(0); percentBar:Set(0) end },
})

---------------------------------------------------------------------------------------------
-- PAGE 2: Elements - every control, with its options
---------------------------------------------------------------------------------------------
local Elements = Window:AddPage({ Name = "Elements", Icon = "combat" })
local Basics = Elements:AddSubPage("Toggles & sliders")
local Inputs = Elements:AddSubPage("Inputs")
local Lists = Elements:AddSubPage("Lists")

-- Toggles ------------------------------------------------------------------------------------
local toggles = Basics:AddSection({ Name = "Toggles", Icon = "combat", Tooltip = "Sections can have a [?] too" })
toggles:AddToggle({ Name = "Simple toggle", Flag = "Demo_Simple",
	Callback = function(on) notify("Toggle", on and "On" or "Off") end })
toggles:AddToggle({ Name = "With a description", Description = "A grey second line under the name", Flag = "Demo_Desc" })
toggles:AddToggle({ Name = "With a tooltip", Tooltip = "Hover the [?] to read this", Flag = "Demo_Tip" })

-- a toggle with a keybind (right-click the key box: Toggle / Hold / Always)
toggles:AddToggle({ Name = "With a keybind", Flag = "Demo_Bind" })
	:AddKeybind({ Default = Enum.KeyCode.Q, Flag = "Demo_BindKey" })

-- a toggle with a color picker (click the swatch; right-click it for copy / paste / rainbow)
toggles:AddToggle({ Name = "With a color", Default = true, Flag = "Demo_Color" })
	:AddColorPicker({ Default = Color3.fromRGB(255, 120, 200), Transparency = 0.2, Flag = "Demo_ColorValue" })

-- a toggle with extra settings in a floating "•••" card
local withOptions = toggles:AddToggle({ Name = "With more options", Flag = "Demo_Options" })
withOptions:AddOptions(function(card)
	card:AddSlider({ Name = "Thickness", Min = 1, Max = 5, Default = 2, Flag = "Demo_Thickness" })
	card:AddToggle({ Name = "Filled", Flag = "Demo_Filled" })
	card:AddDropdown({ Name = "Follow", Options = { "Mouse", "Center" }, Default = "Mouse", Flag = "Demo_Follow" })
end)

-- all three on one toggle (keep the toggle in a variable: :AddKeybind returns the key box)
local everything = toggles:AddToggle({ Name = "Key + color + options", Flag = "Demo_All" })
everything:AddKeybind({ Default = Enum.KeyCode.Z, Mode = "Hold", Flag = "Demo_AllKey" })
everything:AddColorPicker({ Default = Color3.fromRGB(255, 200, 90), Flag = "Demo_AllColor" })
everything:AddOptions(function(card)
	card:AddSlider({ Name = "Size", Min = 1, Max = 20, Default = 8, Flag = "Demo_AllSize" })
end)
toggles:AddToggle({ Name = "Disabled toggle", Disabled = true, Tooltip = "Greyed out with Disabled = true" })

-- Sliders ------------------------------------------------------------------------------------
local sliders = Basics:AddSection({ Name = "Sliders", Side = "Right" })
sliders:AddSlider({ Name = "Whole numbers", Min = 0, Max = 100, Default = 50, Flag = "Demo_Slider",
	Tooltip = "Click the number to type a value" })
sliders:AddSlider({ Name = "Decimals", Min = 0, Max = 1, Increment = 0.05, Default = 0.35, Flag = "Demo_Decimal" })
sliders:AddSlider({ Name = "With a suffix", Min = 0, Max = 360, Default = 90, Suffix = "°", Flag = "Demo_Angle" })
sliders:AddRangeSlider({ Name = "Range", Min = 0, Max = 1000, Default = { 100, 600 }, Increment = 10, Suffix = "m",
	Flag = "Demo_Range", Description = "Drag either end",
	Callback = function(range) Watermark:SetTitle(string.format("SleekUI  %d-%dm", range[1], range[2])) end })

-- Inputs -------------------------------------------------------------------------------------
local drops = Inputs:AddSection({ Name = "Dropdowns" })
drops:AddDropdown({ Name = "Single choice", Options = { "Head", "Torso", "Legs" }, Default = "Head", Flag = "Demo_Single" })
drops:AddDropdown({ Name = "Multiple choice", Multi = true, Options = { "Friends", "Teammates", "Invisible" },
	Default = { "Friends" }, Flag = "Demo_Multi" })
drops:AddDropdown({ Name = "With search", Search = true, Flag = "Demo_Search",
	Options = { "Apple", "Banana", "Cherry", "Grape", "Lemon", "Mango", "Orange", "Peach", "Pear", "Plum" } })

-- options can change at runtime
local fruits = drops:AddDropdown({ Name = "Editable list", Options = { "One", "Two" }, Default = "One", NoSave = true })
local added = 2
drops:AddButtons({
	{ "Add", function() added += 1; fruits:Add("Item " .. added) end },
	{ "Remove", function() local v = fruits:Get(); if v then fruits:Remove(v) end end },
	{ "Replace", function() fruits:Refresh({ "Red", "Green", "Blue" }) end },
})

local keys = Inputs:AddSection({ Name = "Keybinds", Side = "Right" })
keys:AddKeybind({ Name = "Toggle mode", Default = Enum.KeyCode.T, Flag = "Demo_KeyToggle",
	Callback = function(active) notify("Keybind", active and "Active" or "Inactive") end })
keys:AddKeybind({ Name = "Hold mode", Default = Enum.KeyCode.E, Mode = "Hold", Flag = "Demo_KeyHold",
	Description = "On only while the key is held" })
keys:AddKeybind({ Name = "Middle mouse", Default = Enum.UserInputType.MouseButton3, Flag = "Demo_KeyMouse" })
keys:AddKeybind({ Name = "Pressed only", Default = Enum.KeyCode.G, NoModes = true, ShowInList = false,
	Pressed = function() notify("Keybind", "G pressed") end,
	Changed = function(key) notify("Keybind", "Rebound to " .. (key and key.Name or "nothing")) end })
keys:AddLabel("Label with a key"):AddKeybind({ Default = Enum.KeyCode.X, Flag = "Demo_LabelKey" })

local colors = Inputs:AddSection({ Name = "Colors", Side = "Right" })
colors:AddColorPicker({ Name = "With transparency", Default = Color3.fromRGB(110, 190, 255), Transparency = 0.3, Flag = "Demo_Pick",
	Callback = function(color, transparency) end })
colors:AddColorPicker({ Name = "No transparency bar", Default = "#ffcc55", NoTransparency = true, Flag = "Demo_PickSolid" })
colors:AddLabel("Label with a color"):AddColorPicker({ Default = { 120, 255, 140 }, Flag = "Demo_LabelPick" })

local texts = Inputs:AddSection({ Name = "Text boxes" })
texts:AddTextbox({ Name = "Any text", Placeholder = "type here", Flag = "Demo_Text",
	OnEnter = function(text) notify("Textbox", "Enter: " .. tostring(text)) end })
texts:AddTextbox({ Name = "Numbers only", Placeholder = "123", Numeric = true, Flag = "Demo_Number",
	Callback = function(n) if n then notify("Textbox", "Number: " .. n) end end })
texts:AddTextbox({ Name = "Clears when clicked", Placeholder = "search...", ClearOnFocus = true, NoSave = true })

-- Lists --------------------------------------------------------------------------------------
local listSec = Lists:AddSection({ Name = "List box" })
local picked = listSec:AddLabel("Picked: Bravo")
listSec:AddListbox({
	Name = "Pick one", Options = { "Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot" }, Default = "Bravo", Height = 120,
	Flag = "Demo_List", Tooltip = "Double-click or right-click a row",
	Callback = function(v) picked:Set("Picked: " .. tostring(v)) end,
	OnDoubleClick = function(v) notify("List", "Double-clicked " .. v) end,
	ContextItems = function(v)
		return { { Text = "Say hi to " .. v, Callback = function() notify("List", "Hi " .. v) end } }
	end,
})

local playerSec = Lists:AddSection({ Name = "Players", Side = "Right", Icon = "visuals" })
local selectedPlayer = playerSec:AddLabel("Selected: nobody")
local players = playerSec:AddPlayerList({
	Height = 200, Priorities = { "Neutral", "Friendly", "Target" }, Tooltip = "Right-click a player to set a priority",
	Callback = function(plr) selectedPlayer:Set("Selected: " .. (plr and plr.DisplayName or "nobody")) end,
	PriorityChanged = function(plr, p) notify(plr.DisplayName, "Priority: " .. p) end,
})
playerSec:AddButtons({
	{ "Friendly", function() local p = players:Get(); if p then players:SetPriority(p, "Friendly") end end },
	{ "Target", function() local p = players:Get(); if p then players:SetPriority(p, "Target") end end },
	{ "Clear", function() local p = players:Get(); if p then players:SetPriority(p, "Neutral") end end },
})

---------------------------------------------------------------------------------------------
-- PAGE 3: Layout - sections, dependencies, live updates
---------------------------------------------------------------------------------------------
local Layout = Window:AddPage({ Name = "Layout", Icon = "movement" })
local SectionsSub = Layout:AddSubPage("Sections")
local LiveSub = Layout:AddSubPage("Live")

-- a section with a master switch in its header: switching it off locks everything inside
local master = SectionsSub:AddSection({ Name = "Header switch", Toggle = { Flag = "Demo_Master", Default = true,
	Callback = function(on) notify("Section", on and "Unlocked" or "Locked") end } })
master:AddToggle({ Name = "Locked with the section", Flag = "Demo_Locked" })
master:AddSlider({ Name = "Me too", Min = 0, Max = 10, Default = 5, Flag = "Demo_LockedSlider" })

-- a section that starts collapsed (click a header to collapse / expand)
local folded = SectionsSub:AddSection({ Name = "Starts collapsed", Collapsed = true })
folded:AddLabel("Click the header to fold this section again.")
folded:AddToggle({ Name = "Hidden until expanded", Flag = "Demo_Folded" })

-- dependency groups: only shown while a condition holds
local deps = SectionsSub:AddSection({ Name = "Dependencies", Side = "Right" })
local wall = deps:AddToggle({ Name = "Wall check", Flag = "Demo_Wall", Description = "Turn on to show more" })
local wallGroup = deps:AddDependency(wall) -- default: shown while the toggle is on
wallGroup:AddSlider({ Name = "Max walls", Min = 0, Max = 5, Default = 1, Flag = "Demo_Walls" })
wallGroup:AddToggle({ Name = "Ignore glass", Default = true, Flag = "Demo_Glass" })

local mode = deps:AddDropdown({ Name = "Mode", Options = { "Normal", "Custom" }, Default = "Normal", Flag = "Demo_Mode" })
local customGroup = deps:AddDependency(mode, function(v) return v == "Custom" end) -- any condition
customGroup:AddSlider({ Name = "Custom speed", Min = 1, Max = 10, Default = 5, Flag = "Demo_CustomSpeed" })

-- changing elements from code
local controls = SectionsSub:AddSection({ Name = "Change elements from code", Side = "Right" })
local target = controls:AddToggle({ Name = "Target toggle", Flag = "Demo_Target" })
controls:AddButtons({
	{ "Turn on", function() target:Set(true) end },
	{ "Silent off", function() target:Set(false, true) end, Tooltip = "Set(value, true) skips the callback" },
})
controls:AddButtons({
	{ "Disable", function() target:SetDisabled(true) end },
	{ "Enable", function() target:SetDisabled(false) end },
})
controls:AddButtons({
	{ "Hide", function() target:SetVisible(false) end },
	{ "Show", function() target:SetVisible(true) end },
	{ "Rename", function() target:SetText("Renamed toggle") end },
})

-- live: OnChanged listeners, reading Library.Flags, loops that stop on unload
local live = LiveSub:AddSection({ Name = "Live values" })
local echo = live:AddLabel("Move the slider")
local speed = live:AddSlider({ Name = "Speed", Min = 0, Max = 100, Default = 16, Flag = "Demo_Speed" })
speed:OnChanged(function(v) echo:Set("Speed is now " .. v) end) -- extra listener on top of Callback

local flagsSec = LiveSub:AddSection({ Name = "Library.Flags", Side = "Right" })
local flagsText = flagsSec:AddParagraph({ Title = "Read any value by its Flag", Text = "" })
local uptime = flagsSec:AddLabel("Running for 0s")

-- a loop that ends by itself when the UI is unloaded
task.spawn(function()
	local started = os.clock()
	while not Library.Unloaded do
		local f = Library.Flags
		flagsText:SetText(string.format("Demo_Speed = %s\nDemo_Simple = %s\nDemo_Single = %s",
			tostring(f.Demo_Speed), tostring(f.Demo_Simple), tostring(f.Demo_Single)))
		uptime:Set(string.format("Running for %ds", math.floor(os.clock() - started)))
		task.wait(0.5)
	end
end)

---------------------------------------------------------------------------------------------
-- PAGE 4: Visuals - live character preview with a mock ESP overlay
---------------------------------------------------------------------------------------------
local Visuals = Window:AddPage({ Name = "Visuals", Icon = "visuals" })
local EspSub = Visuals:AddSubPage("Preview")

local preview -- created below; the toggles drive it
local espSec = EspSub:AddSection({ Name = "ESP", Icon = "visuals" })
local function espToggle(name, key, default, color)
	local t = espSec:AddToggle({ Name = name, Default = default, Flag = "Demo_ESP_" .. key,
		Callback = function(on) if preview then preview:SetESP(key, on) end end })
	if color then
		t:AddColorPicker({ Default = color, Flag = "Demo_ESP_" .. key .. "Color",
			Callback = function(c) if preview then preview:SetESP(key, nil, c) end end })
	end
end
espToggle("Box", "Box", true, Color3.fromRGB(110, 190, 255))
espToggle("Name", "Name", true, Color3.new(1, 1, 1))
espToggle("Health bar", "Health", true, Color3.fromRGB(80, 220, 120))
espToggle("Distance", "Distance", false)

local previewSec = EspSub:AddSection({ Name = "Preview", Side = "Right" })
preview = previewSec:AddCharacterPreview({
	Height = 230, AutoRotate = true, Tooltip = "Drag to spin it, right-click for options",
	ESP = { Box = true, Name = true, Health = true, Distance = false },
	Colors = { Box = Color3.fromRGB(110, 190, 255) },
})
previewSec:AddToggle({ Name = "Auto rotate", Default = true, NoSave = true, Callback = function(on) preview:SetAutoRotate(on) end })
previewSec:AddSlider({ Name = "Angle", Min = 0, Max = 360, Default = 0, Suffix = "°", NoSave = true, Callback = function(v) preview:SetAngle(v) end })

---------------------------------------------------------------------------------------------
-- PAGE 5: Theme from code (Settings > Theme has the same controls for users)
---------------------------------------------------------------------------------------------
local ThemePage = Window:AddPage({ Name = "Theme", Icon = "T" }) -- a single character works as an icon
local themeSec = ThemePage:AddSection({ Name = "Theme API" })
themeSec:AddDropdown({ Name = "Preset", Options = Library.PresetOrder, Default = "Default", NoSave = true,
	Callback = function(name) Library:ApplyTheme(name) end })
themeSec:AddDropdown({ Name = "Font", Options = Library.FontOrder, Default = "Gotham", NoSave = true,
	Callback = function(name) Library:SetFont(name) end })
themeSec:AddColorPicker({ Name = "Accent", Default = Library.Theme.Accent, NoTransparency = true, NoSave = true,
	Callback = function(c) Library:SetAccent(c) end })
themeSec:AddToggle({ Name = "Animations", Default = true, NoSave = true, Callback = function(on) Library.Animations = on end })

local overlaySec = ThemePage:AddSection({ Name = "Overlays", Side = "Right" })
overlaySec:AddToggle({ Name = "Watermark", Default = true, NoSave = true, Callback = function(on) Watermark:SetVisible(on) end })
overlaySec:AddToggle({ Name = "Keybind list", Default = true, NoSave = true, Callback = function(on) KeyList:SetVisible(on) end })
overlaySec:AddTextbox({ Name = "Watermark title", Default = "SleekUI", NoSave = true, Callback = function(t) Watermark:SetTitle(t) end })
overlaySec:AddButtons({
	{ "Center window", function() Window:Center() end },
	{ "Hide window", function() Window:SetOpen(false) end },
})

---------------------------------------------------------------------------------------------
-- Settings page: menu key, UI scale, configs (save / load / autoload / share), themes
---------------------------------------------------------------------------------------------
Window:AddSettingsPage({ Title = "SleekUI" })

---------------------------------------------------------------------------------------------
-- Cleanup: runs when the user unloads from Settings or your script calls Library:Unload()
---------------------------------------------------------------------------------------------
Library:OnUnload(function()
	-- turn your features off / disconnect your own connections here
end)

-- show the window once everything is built
Loader:Finish(function()
	Window:SetOpen(true)
	Library:Notify({ Title = "SleekUI", Text = "Demo loaded. RightShift toggles the menu.", Icon = "paw", Duration = 4 })
end)
