# SleekUI

A clean Roblox UI library: an icon sidebar with right-click subpages, configs, themes, keybinds with Toggle / Hold / Always modes, a watermark, a keybind list, search across every page, and more.

## Load it

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatDevSleepy/ui/main/SleekUI.lua"))()
```

Loading the library doesn't open anything by itself. To see every element in action, run [`demo.lua`](demo.lua).

## Quick start

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatDevSleepy/ui/main/SleekUI.lua"))()

local Window = Library:CreateWindow({ Title = "My Script" })

local Combat = Window:AddPage({ Name = "Combat", Icon = "combat" })
local Aim    = Combat:AddSubPage("Aimbot")

local Main = Aim:AddSection({ Name = "Main" })
Main:AddToggle({ Name = "Enabled", Flag = "Aim_Enabled", Callback = function(on) end })
	:AddKeybind({ Default = Enum.KeyCode.Q, Flag = "Aim_Bind" })
Main:AddSlider({ Name = "FOV", Min = 0, Max = 360, Default = 90, Flag = "Aim_FOV" })
Main:AddDropdown({ Name = "Target Part", Options = { "Head", "Torso" }, Default = "Head", Flag = "Aim_Part" })

Window:AddSettingsPage({ Title = "My Script" }) -- menu key, UI scale, configs, themes

Library:OnUnload(function()
	-- your cleanup
end)

-- read any value anywhere
print(Library.Flags.Aim_FOV)
```

Built-in icons: `combat`, `movement`, `visuals`, `settings`, `paw`. You can also pass an `rbxassetid://` id or a single character.

## Elements

On a section you can add:

- `AddToggle`, which can also take `:AddKeybind`, `:AddColorPicker` and `:AddOptions`
- `AddSlider`
- `AddRangeSlider`
- `AddDropdown`, single or `Multi`, with `Search`
- `AddKeybind`
- `AddColorPicker`, with a transparency bar
- `AddTextbox`, with `Numeric` for numbers only
- `AddButton` and `AddButtons`, with `Confirm` for a click-twice button
- `AddLabel`, `AddParagraph` and `AddDivider`
- `AddProgress`
- `AddListbox`
- `AddPlayerList`
- `AddCharacterPreview`
- `AddDependency`, a group that only shows while a toggle is on

Every element accepts these options:

- `Flag`: saves the element in configs
- `Callback`
- `Tooltip`: shows a `[?]` marker next to the name
- `Description`: a grey second line under the name
- `Disabled`
- `NoSave`

Every element also has these methods:

- `:Set`
- `:Get`
- `:SetDisabled`
- `:SetVisible`
- `:OnChanged`

The full list of options is in the comment block at the top of [`SleekUI.lua`](SleekUI.lua).

## Overlays and extras

```lua
Library:Notify({ Title = "Hi", Text = "Hello", Duration = 3, Type = "success" })
Library:Dialog({ Title = "Sure?", Buttons = { { "Cancel" }, { "Yes", function() end, "primary" } } })
Library:CreateWatermark({ Title = "My Script" })
Library:CreateKeybindList()
Library:Unload()
```

Configs and themes are saved in `workspace/SleekUI/` with your executor's file functions. That includes every flag, plus the watermark and keybind list positions.

## Small things that help

- **Notifications**: hovering one pauses its timer, the `x` (or a click) closes it, and the same notification sent again shows `x2`, `x3` instead of stacking.
- **Key conflicts**: binding a key that another feature already uses shows a warning naming that feature. Turn it off with `Library.KeyConflictWarnings = false`.
- **Scroll edge fades**: a page with more content above or below fades out softly at that edge instead of cutting rows off.
- **Dim background**: the game darkens slightly while the menu is open. Switch it off in Settings, with `Window:SetDim(false)`, or with `Dim = false` in `CreateWindow`.
