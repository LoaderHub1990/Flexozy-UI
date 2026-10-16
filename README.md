# Flexozy UI

**A modern, customizable Roblox Lua UI library.**

Flexozy UI is a customizable interface library featuring animated UI elements, tabs, groups, interactive controls, theme customization, language support, notifications, and configuration management.

[![Version](https://img.shields.io/badge/version-3.3.0-8B5CF6?style=for-the-badge)](https://github.com/LoaderHub1990/Flexozy-UI)
[![Language](https://img.shields.io/badge/language-Lua-2563EB?style=for-the-badge)](https://www.lua.org/)
[![Platform](https://img.shields.io/badge/platform-Roblox-111827?style=for-the-badge)](https://www.roblox.com/)

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [CreateWindow](#createwindow)
- [Window Configuration](#window-configuration)
- [Tabs](#tabs)
- [Groups](#groups)
- [UI Controls](#ui-controls)
- [Callbacks and Flags](#callbacks-and-flags)
- [Theme and Appearance](#theme-and-appearance)
- [Language System](#language-system)
- [Notifications](#notifications)
- [Configuration Management](#configuration-management)
- [Window Methods](#window-methods)
- [Built-in Settings](#built-in-settings)
- [Compatibility](#compatibility)
- [License](#license)

---

## Features

- Modern dark UI with animated gradients and glowing borders
- Draggable windows
- Responsive scaling and automatic screen fitting
- Tabs with icons and subtitles
- Left/right group layouts
- Collapsible groups
- Interactive UI controls
- Custom accent colors
- English and Thai language support
- Translation dictionaries
- Searchable UI elements
- Tooltips
- Notification system
- Configuration save/load support
- FPS and ping display
- Keyboard shortcuts
- Anti-AFK option
- Automatic rejoin option
- UI unload and connection cleanup

## Installation

Load the library from the official repository source:

```lua
local Flexozy = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/LoaderHub1990/Flexozy-UI/refs/heads/main/FlexozyUI.lua"
))()
```

The library requires an environment capable of loading the source as Lua code. Some optional features rely on environment-specific APIs.

## Quick Start

```lua
local Flexozy = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/LoaderHub1990/Flexozy-UI/refs/heads/main/FlexozyUI.lua"
))()

local Window = Flexozy:CreateWindow({
    Title = "Flexozy Hub",
    SubTitle = "Welcome to Flexozy",
    Monogram = "FX",
    Accent = "Violet",
    ToggleKey = Enum.KeyCode.RightControl,
    Language = "EN",
})

local MainTab = Window:Tab({
    Title = "Main",
    Subtitle = "Main Features",
    Icon = "Grid",
})

local MainGroup = MainTab:Group("General")

MainGroup:Button({
    Title = "Test Button",
    Desc = "Click to run an action",
    Callback = function()
        Window:Notify({
            Title = "Flexozy",
            Content = "Button clicked successfully!",
            Type = "Success",
            Duration = 3,
        })
    end,
})

MainGroup:Toggle({
    Title = "Example Toggle",
    Desc = "Enable or disable a feature",
    Default = false,
    Flag = "Main.ExampleToggle",
    Callback = function(value)
        print("Enabled:", value)
    end,
})
```

---

## CreateWindow

Create a new Flexozy UI window.

```lua
local Window = Flexozy:CreateWindow({
    Title = "My Script",
    SubTitle = "Powered by Flexozy",
    Monogram = "FX",
    Size = Vector2.new(720, 520),
    Accent = "Violet",
    ToggleKey = Enum.KeyCode.RightControl,
    Language = "EN",
    LanguageScope = "All",
    AutoSave = true,
    ConfigName = "default",
    Folder = "Flexozy",
    StatsPill = true,
})
```

### Window Configuration

| Parameter | Type | Default | Description |
|---|---|---|---|
| `Title` | string | `"Flexozy"` | Main window title |
| `SubTitle` | string | `"Script Hub"` | Secondary title displayed under the main title |
| `Monogram` | string | `"FX"` | Short text displayed in the logo area when no custom logo is loaded |
| `Logo` | number/string | `nil` | Optional image asset ID, supported asset URI, or image URL where the environment supports it |
| `Size` | Vector2 | `Vector2.new(720, 520)` | Initial window dimensions |
| `Accent` | string/Color3 | `"Violet"` | Accent theme color |
| `ToggleKey` | Enum.KeyCode | `RightControl` | Keyboard key used to show or hide the window |
| `Language` | string | `"EN"` | Initial language |
| `LanguageScope` | string | `"All"` | Translation scope |
| `AutoSave` | boolean | `true` | Enables automatic configuration saving behavior |
| `ConfigName` | string | `"default"` | Default configuration filename without the extension |
| `Folder` | string | `"Flexozy"` | Folder used for configuration files |
| `StatsPill` | boolean | `true` | Initial preference for the FPS/ping pill |

### Parameter Details

#### `Title`

Sets the main title.

```lua
Title = "Flexozy Hub"
```

#### `SubTitle`

Sets the secondary title.

```lua
SubTitle = "Premium Script Hub"
```

#### `Monogram`

Sets the fallback logo text.

```lua
Monogram = "FX"
```

#### `Logo`

Supports a numeric asset ID, a numeric string, or supported asset URIs. HTTP(S) image URLs depend on filesystem and custom-asset support.

```lua
Logo = 135253158468501
```

#### `Size`

Controls the initial width and height.

```lua
Size = Vector2.new(720, 520)
```

The automatic fitting system can reduce the displayed scale on smaller screens.

#### `Accent`

Selects a built-in theme color or a custom Roblox `Color3`.

```lua
Accent = "Blue"
```

Custom color:

```lua
Accent = Color3.fromRGB(59, 130, 246)
```

Built-in colors:

- `Violet`
- `Blue`
- `Cyan`
- `Green`
- `Yellow`
- `Orange`
- `Red`
- `Pink`

#### `ToggleKey`

Defines the keyboard shortcut for the UI.

```lua
ToggleKey = Enum.KeyCode.RightControl
```

#### `Language`

Sets the initial language.

```lua
Language = "EN"
```

Supported values include `EN`, `TH`, `English`, `ไทย`, and `Thai`.

#### `LanguageScope`

Controls which strings are translated.

| Value | Description |
|---|---|
| `"All"` | Translate supported UI text and features |
| `"Tabs"` | Translate tab-related text |
| `"Functions"` | Translate feature-related text |

#### `AutoSave`

```lua
AutoSave = true
```

Enables automatic saving when supported and after the configuration system is ready.

#### `ConfigName`

```lua
ConfigName = "default"
```

The resulting filename is `default.json`.

#### `Folder`

```lua
Folder = "Flexozy"
```

Sets the directory used for configuration files.

#### `StatsPill`

```lua
StatsPill = true
```

Controls the initial FPS/ping display preference.

---

## Tabs

Tabs organize the interface into separate pages.

### Syntax

```lua
local MainTab = Window:Tab({
    Title = "Main",
    Subtitle = "Main Features",
    Icon = "Grid",
})
```

A title-only shorthand is also supported:

```lua
local MainTab = Window:Tab("Main")
```

### Tab Parameters

| Parameter | Type | Description |
|---|---|---|
| `Title` | string/table | Tab name |
| `Subtitle` | string | Supporting text displayed in the tab header |
| `Icon` | string/number | Icon URI, asset ID, or supported icon name |
| `Bottom` | boolean | Places the tab in the bottom navigation area |

### Example

```lua
local MainTab = Window:Tab({
    Title = "Main",
    Subtitle = "Main Features",
    Icon = "Grid",
})

local PlayerTab = Window:Tab({
    Title = "Player",
    Subtitle = "Player Settings",
    Icon = "Sword",
})

local SettingsTab = Window:Tab({
    Title = "Settings",
    Subtitle = "Customize your UI",
    Icon = "Settings",
})
```

### Built-in Icon Names

The library defines these icon mappings:

| Name | Purpose |
|---|---|
| `Grid` | Main/general |
| `Sword` | Combat/player |
| `Skull` | Combat |
| `Zap` | Fast actions |
| `Server` | Server |
| `Eye` | Visibility |
| `Settings` | Settings |
| `Refresh` | Refresh |
| `Teleport` | Teleport |

You can also supply a numeric Roblox asset ID or a supported image URI.

---

## Groups

Groups place controls inside cards within a tab.

### Basic Group

```lua
local MainGroup = MainTab:Group("General")
```

### Left and Right Layout

```lua
local LeftGroup = MainTab:Group("Player", "Left")
local RightGroup = MainTab:Group("Movement", "Right")
```

### Group Parameters

| Parameter | Type | Description |
|---|---|---|
| `gtitle` | string/table/nil | Group heading |
| `side` | string/table | Optional column placement or group options |
| `gopts` | table | Additional group options |

Supported column values:

- `"Left"`
- `"Right"`

When no column is supplied, the group uses the regular page layout.

### Collapsible Groups

```lua
local AdvancedGroup = MainTab:Group("Advanced", "Right", {
    Collapsible = true,
    Collapsed = false,
})
```

| Option | Type | Description |
|---|---|---|
| `Collapsible` | boolean | Allows the group to collapse |
| `Collapsed` | boolean | Initial collapsed state |

A collapsible group can also be created using the options-table shorthand:

```lua
local AdvancedGroup = MainTab:Group("Advanced", {
    Side = "Right",
    Collapsible = true,
    Collapsed = true,
})
```

### Collapse Methods

```lua
AdvancedGroup:SetCollapsed(true)
AdvancedGroup:SetCollapsed(false)
```

The method accepts a boolean.

---

## UI Controls

Controls are added to a group, not directly to the window.

The library's control methods use configuration tables. The source also provides positional-argument handling for certain controls, but configuration tables are recommended for readability.

### 1. Button

Runs a callback when clicked.

```lua
MainGroup:Button({
    Title = "Execute",
    Desc = "Run an action",
    Callback = function()
        print("Executed")
    end,
})
```

| Parameter | Type | Description |
|---|---|---|
| `Title` | string | Button title |
| `Desc` | string | Optional description |
| `Callback` | function | Function called when clicked |

Example:

```lua
MainGroup:Button({
    Title = "Notify",
    Desc = "Display a notification",
    Callback = function()
        Window:Notify({
            Title = "Hello",
            Content = "Action completed",
            Type = "Success",
        })
    end,
})
```

### 2. Toggle

Represents an enabled or disabled state.

```lua
MainGroup:Toggle({
    Title = "Auto Feature",
    Desc = "Enable or disable the feature",
    Default = false,
    Flag = "Main.AutoFeature",
    Callback = function(value)
        print(value)
    end,
})
```

| Parameter | Type | Description |
|---|---|---|
| `Title` | string | Toggle title |
| `Desc` | string | Optional description |
| `Default` | boolean | Initial state |
| `Flag` | string | Optional identifier for state/config storage |
| `Callback` | function | Receives the new boolean state |

Possible callback values:

```lua
true
false
```

### 3. Slider

Selects a numeric value from a range.

```lua
MainGroup:Slider({
    Title = "Speed",
    Min = 1,
    Max = 100,
    Default = 10,
    Step = 1,
    Suffix = "x",
    Flag = "Player.Speed",
    Callback = function(value)
        print("Speed:", value)
    end,
})
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `Title` | string | `"Slider"` | Slider title |
| `Min` | number | `0` | Minimum value |
| `Max` | number | `100` | Maximum value |
| `Default` | number | `Min` | Initial value |
| `Step` | number | `1` | Increment and snapping interval |
| `Suffix` | string | `""` | Text appended to the displayed value |
| `Flag` | string | none | State/config identifier |
| `Callback` | function | no-op | Receives the current numeric value |
| `OnRelease` | boolean | false/nil | Defers callback delivery during dragging until release behavior is processed |

Example with decimal steps:

```lua
MainGroup:Slider({
    Title = "Multiplier",
    Min = 0.1,
    Max = 5,
    Default = 1,
    Step = 0.1,
    Suffix = "x",
    Callback = function(value)
        print(value)
    end,
})
```

The selected value is clamped to the minimum and maximum and snapped to the configured step.

### 4. Dropdown

Allows users to select an option or multiple options.

Basic example:

```lua
MainGroup:Dropdown({
    Title = "Select Mode",
    Options = {
        "Easy",
        "Normal",
        "Hard",
    },
    Default = "Normal",
    Callback = function(value)
        print(value)
    end,
})
```

| Parameter | Type | Description |
|---|---|---|
| `Title` | string | Dropdown title |
| `Options` | table | Available options |
| `Default` | string/value | Initial selection |
| `Flag` | string | Optional state/config identifier |
| `Callback` | function | Receives the selection |
| `Multi` | boolean | Enables multiple selection where supported |

Example with multiple selections:

```lua
MainGroup:Dropdown({
    Title = "Select Items",
    Options = {
        "Item A",
        "Item B",
        "Item C",
    },
    Multi = true,
    Default = {},
    Callback = function(values)
        for _, value in ipairs(values) do
            print(value)
        end
    end,
})
```

For multi-selection, the selected values are represented as a table. For single selection, the callback receives the selected option.

### 5. Input

Accepts text input.

```lua
MainGroup:Input({
    Title = "Player Name",
    Placeholder = "Enter a name",
    Default = "",
    Flag = "Player.Name",
    Callback = function(value)
        print(value)
    end,
})
```

| Parameter | Type | Description |
|---|---|---|
| `Title` | string | Input title |
| `Placeholder` | string | Placeholder text |
| `Default` | string | Initial text |
| `Flag` | string | Optional state/config identifier |
| `Callback` | function | Receives the input value |

### 6. Keybind

Allows a user to choose a keyboard key.

```lua
MainGroup:Keybind({
    Title = "Action Key",
    Default = Enum.KeyCode.G,
    Flag = "Main.ActionKey",
    Callback = function(key)
        print("Pressed:", key.Name)
    end,
    Changed = function(key)
        print("New key:", key.Name)
    end,
})
```

| Parameter | Type | Description |
|---|---|---|
| `Title` | string | Keybind title |
| `Default` | Enum.KeyCode | Initial key |
| `Flag` | string | Optional state/config identifier |
| `Callback` | function | Runs when the configured key is pressed |
| `Changed` | function | Receives a newly selected key |

The user can click the keybind button to enter key-selection mode. Escape cancels selection; Backspace clears the binding.

### 7. Paragraph

Displays a title and content block.

```lua
MainGroup:Paragraph({
    Title = "Information",
    Content = "This is an information paragraph.",
})
```

| Parameter | Type | Description |
|---|---|---|
| `Title` | string | Optional paragraph heading |
| `Content` | string | Paragraph content |

### 8. Label

Displays a simple text label.

```lua
MainGroup:Label("Welcome to Flexozy UI")
```

Use labels for information that does not require user interaction.

### 9. Divider

Adds a visual separator.

```lua
MainGroup:Divider()
```

Use dividers to separate related controls.

---

## Callbacks and Flags

### Callback

A callback is a Lua function executed when a control triggers an action or changes value.

```lua
Callback = function(value)
    print(value)
end
```

The callback argument depends on the control:

| Control | Callback argument |
|---|---|
| Button | No required argument |
| Toggle | Boolean |
| Slider | Number |
| Dropdown, single | Selected option |
| Dropdown, multi | Table of selected options |
| Input | Text value |
| Keybind | Selected/pressed key, where applicable |

### Flag

A `Flag` provides a stable identifier for a control's value.

```lua
Flag = "Player.Speed"
```

Use unique names to avoid collisions.

Recommended naming patterns:

- `Player.Speed`
- `Player.JumpPower`
- `Combat.Enabled`
- `Settings.Language`

The library registers flagged values for its state and configuration system. Flags do not automatically create game functionality; your callback must implement the actual behavior.

### Default

`Default` determines the initial control value.

Examples:

```lua
Default = false
Default = 25
Default = "Normal"
Default = ""
```

Use a value that matches the type expected by the control.

---

## Theme and Appearance

### Set Accent Color

```lua
Window:SetAccent("Blue")
```

Built-in accent names:

```lua
"Violet"
"Blue"
"Cyan"
"Green"
"Yellow"
"Orange"
"Red"
"Pink"
```

Custom color:

```lua
Window:SetAccent(Color3.fromRGB(59, 130, 246))
```

### Set UI Scale

```lua
Window:SetUIScale(1)
```

| Value | Meaning |
|---|---|
| `0.5` | 50% scale |
| `1` | 100% scale |
| `1.5` | 150% scale |
| `2` | 200% scale |

The method clamps the requested scale to a supported range of `0.25` through `3`. Automatic screen fitting may reduce the effective displayed scale.

### Set Window Opacity

```lua
Window:SetOpacity(0.8)
```

The value is clamped between `0.2` and `1`.

- `1` = fully opaque background
- `0.8` = slightly transparent background
- `0.2` = more transparent background

### Show or Hide the UI

```lua
Window:Toggle(false) -- Hide
Window:Toggle(true)  -- Show
Window:Toggle()      -- Toggle current visibility
```

### Unload the UI

```lua
Window:Unload()
```

Unloading is intended to remove the UI and clean up its registered connections.

---

## Language System

### Set Language

```lua
Window:SetLanguage("TH")
```

or:

```lua
Window:SetLanguage("EN")
```

### Set Translation Scope

```lua
Window:SetLanguageScope("All")
```

Supported scopes:

| Scope | Description |
|---|---|
| `All` | All supported translatable UI strings |
| `Tabs` | Tab-related text |
| `Functions` | Feature-related text |

### Add Custom Translations

```lua
Window:AddTranslations({
    ["My Feature"] = "ฟีเจอร์ของฉัน",
    ["Enable"] = "เปิดใช้งาน",
    ["Disable"] = "ปิดใช้งาน",
})
```

The translation map uses English strings as keys and Thai strings as values. Register translations before creating the relevant controls where possible.

---

## Notifications

Display a notification toast.

```lua
Window:Notify({
    Title = "Flexozy",
    Content = "Operation completed.",
    Type = "Success",
    Duration = 3,
})
```

### Notification Parameters

| Parameter | Type | Description |
|---|---|---|
| `Title` | string | Notification heading |
| `Content` | string | Notification message |
| `Type` | string | Notification style |
| `Duration` | number | Display duration |

Common notification types include:

- `Success`
- `Warning`
- `Error`

Example:

```lua
Window:Notify({
    Title = "Warning",
    Content = "Please check your settings.",
    Type = "Warning",
    Duration = 4,
})
```

---

## Configuration Management

Flexozy UI provides configuration methods that store flagged control values.

### Save Configuration

```lua
local success, err = Window:SaveConfig()
```

Save to a specific configuration name:

```lua
local success, err = Window:SaveConfig("profile2")
```

### Load Configuration

```lua
local success, err = Window:LoadConfig()
```

Load a specific configuration:

```lua
local success, err = Window:LoadConfig("profile2")
```

### Reset UI Settings

```lua
Window:ResetSettings()
```

This resets registered settings whose flags use the `UI.` prefix to their registered defaults.

### Configuration Requirements

Saving and loading depend on filesystem functions supplied by the execution environment, including:

- `writefile`
- `readfile`
- `isfile`

Folder creation may also use:

- `makefolder`
- `isfolder`

The configuration system stores values as JSON. If the required filesystem functions are unavailable, the operation may return an error instead of succeeding.

### Auto-Save

```lua
AutoSave = true
```

Auto-save is debounced to reduce repeated writes. Flagged values must be registered, and the configuration system must be ready before automatic saves occur.

---

## Window Methods

The following methods are defined by the library's window object.

| Method | Purpose |
|---|---|
| `Window:Tab(options)` | Create a tab |
| `Window:Section(name)` | Add a navigation section heading |
| `Window:Notify(options)` | Show a notification |
| `Window:SetAccent(color)` | Change the accent color |
| `Window:SetUIScale(scale)` | Change UI scale |
| `Window:SetOpacity(value)` | Change background opacity |
| `Window:SetLanguage(language)` | Change language |
| `Window:SetLanguageScope(scope)` | Change translation scope |
| `Window:AddTranslations(map)` | Register custom translations |
| `Window:SetAntiAfk(enabled)` | Enable or disable Anti-AFK behavior |
| `Window:SetAutoRejoin(enabled)` | Enable or disable automatic rejoining |
| `Window:SaveConfig(name)` | Save flagged values |
| `Window:LoadConfig(name)` | Load flagged values |
| `Window:ResetSettings()` | Reset registered UI settings |
| `Window:Toggle(show)` | Show or hide the window |
| `Window:Unload()` | Remove the UI and clean up connections |

---

## Built-in Settings

The library includes its own settings interface for common configuration tasks.

Depending on the selected settings and environment, it provides options for:

- Accent color
- UI scale and quick sizing
- Automatic fitting on smaller screens
- Language and translation scope
- Toggle key
- FPS/ping display
- Notifications
- Anti-AFK
- Automatic rejoin
- Auto-save
- Configuration name
- Save and load configuration
- Resetting UI settings
- User profile information

### Anti-AFK

```lua
Window:SetAntiAfk(true)
```

Disable it with:

```lua
Window:SetAntiAfk(false)
```

This feature attempts to simulate input when the player becomes idle. Roblox behavior and environment restrictions may affect whether it works.

### Auto Rejoin

```lua
Window:SetAutoRejoin(true)
```

Disable it with:

```lua
Window:SetAutoRejoin(false)
```

This feature listens for certain Roblox error prompts and attempts to teleport the local player back to the current place. It cannot guarantee recovery from every disconnect or server error.

---

## Compatibility

Flexozy UI uses Roblox services and UI classes, including:

- `TweenService`
- `UserInputService`
- `RunService`
- `Players`
- `CoreGui`
- `Stats`
- `MarketplaceService`
- `HttpService`

Some features may additionally depend on environment-provided functions such as `gethui`, `getcustomasset`, `writefile`, and `readfile`.

Compatibility varies by execution environment. Features that require filesystem access, custom asset loading, or simulated input may not work everywhere.

Use custom Lua code only in environments and Roblox experiences where you have permission to run it.

---

## Troubleshooting

### UI does not appear

- Check that the source URL is accessible.
- Verify that the loading environment supports the required Lua features.
- Check the console for errors.
- Try running a minimal example first.

### Configuration does not save

- Confirm filesystem support.
- Check whether the configuration directory can be created.
- Check the return values from `SaveConfig()` and `LoadConfig()`.

### Logo does not load

- Verify the asset ID or image URI.
- For HTTP image URLs, confirm that the environment supports the required download and custom-asset functions.

### Some translations do not change

- Check `LanguageScope`.
- Register custom translations with `AddTranslations()`.
- Confirm that the text matches the dictionary key.

---

## Source Code

- **Repository:** https://github.com/LoaderHub1990/Flexozy-UI
- **Raw source:** https://raw.githubusercontent.com/LoaderHub1990/Flexozy-UI/refs/heads/main/FlexozyUI.lua

## License

Add a `LICENSE` file to the repository to define permitted use, modification, and redistribution. Without an explicit license, do not assume that the source is freely redistributable.

---

**Flexozy UI — Built for customizable Roblox interfaces.**
