---@meta
-- neverlose CS:GO API — ui module. Auto-generated from docs-csgo.neverlose.cc.
-- Do not edit by hand; regenerate from the raw docs instead.

--=============================================================================
-- ui module
--=============================================================================

---@class ui
ui = {}

---Returns the menu opacity as a unit interval (value in the range [0, 1]).
---@return number
function ui.get_alpha() end

---Returns the current menu size.
---@return vector
function ui.get_size() end

---Returns the current menu position.
---@return vector
function ui.get_position() end

---Returns the current mouse position.
---@return vector
function ui.get_mouse_position() end

---Returns a table of pointers to hotkeys.
---@return Hotkey[]
function ui.get_binds() end

---Returns the color of the Style Option. Pass `nil` to return a table with the style options.
---@param name string? Optional. Style option name. Pass `nil` to return a table with all the style options.
---@return color|table
function ui.get_style(name) end

---Returns the unicode converted string corresponding the fontawesome icon.
---@param name string Icon name
---@return string
function ui.get_icon(name) end

---Creates and returns a menu group object.
---
---Group overload: `ui.create(group)` creates a group.
---Tab overload: `ui.create(tab, group[, column])` creates a group within a tab.
---@param group string Group name
---@return MenuGroup
---@overload fun(tab: string, group: string, column?: number): MenuGroup
function ui.create(group) end

---Returns the menu object that corresponds to the specified path.
---
---This can return multiple items or `nil` on failure.
---
---Overloads cover items, sub-items, groups, global items, and ESP items:
---- `ui.find(category, tab, group, item)` → `MenuItem`
---- `ui.find(category, tab, sub_tab, group, item)` → `MenuItem`
---- `ui.find(category, tab, group, item, sub_item)` → `MenuItem`
---- `ui.find(category, tab, sub_tab, group, item, sub_item)` → `MenuItem`
---- `ui.find(category, tab, group)` → `MenuGroup`
---- `ui.find(category, tab, sub_tab, group)` → `MenuGroup`
---- `ui.find(group_name, item_name)` → `MenuItem` (global item)
---- `ui.find(category, tab, sub_tab, group, item_category, item)` → `ESPGroup`
---@param category string Category name, e.g. "Aimbot" or "Visuals".
---@param tab string Tab name that belongs to the category.
---@param group string Name of group with the item.
---@param item string The needed item.
---@return MenuItem?
---@overload fun(category: string, tab: string, sub_tab: string, group: string, item: string): MenuItem?
---@overload fun(category: string, tab: string, group: string, item: string, sub_item: string): MenuItem?
---@overload fun(category: string, tab: string, sub_tab: string, group: string, item: string, sub_item: string): MenuItem?
---@overload fun(category: string, tab: string, group: string): MenuGroup?
---@overload fun(category: string, tab: string, sub_tab: string, group: string): MenuGroup?
---@overload fun(group_name: string, item_name: string): MenuItem?
---@overload fun(category: string, tab: string, sub_tab: string, group: string, item_category: string, item: string): ESPGroup?
function ui.find(category, tab, group, item) end

---Gets or sets the sidebar tab name and an icon.
---Brand icons are currently not supported.
---@param name string? Optional. Sidebar tab name
---@param icon_name string? Optional. Icon name
---@return string name
---@return string icon_name
function ui.sidebar(name, icon_name) end

---Returns the localized string for the specified language code.
---If `localized` is present, the `str` will be localized accordingly.
---@param lang string Language code.
---@param str string String to localize or to get the localized string from.
---@param localized string? Optional. The localized variant.
---@return string? localized
function ui.localize(lang, str, localized) end

--=============================================================================
-- MenuGroup object
--=============================================================================

---A menu group object returned by `ui.create` / `MenuItem:create`.
---Groups expose control-creation methods that add items to the menu.
---@class MenuGroup
local MenuGroup = {}

---Creates and returns a menu item object, or throws an error on failure.
---@param name string Item name
---@param init boolean? Default value
---@return MenuItem
function MenuGroup:switch(name, init) end

---Creates and returns a menu item object, or throws an error on failure.
---@param name string Item name
---@param min number Minimum allowed value
---@param max number Maximum allowed value
---@param init number? Optional. Default value
---@param scale number? Optional. Display value multiplier. Can be used for decimal places.
---@param tooltip string|fun(value: number): any Optional. A string appends itself to the display value. A function allows you to access the raw display value and displays anything it returns.
---@return MenuItem
function MenuGroup:slider(name, min, max, init, scale, tooltip) end

---Creates and returns a menu item object, or throws an error on failure.
---@param name string Item name
---@param items any One or more comma separated values that will be added to the combo. Alternatively, a table of strings that will be added.
---@param ... any Additional values to add to the combo.
---@return MenuItem
function MenuGroup:combo(name, items, ...) end

---Creates and returns a menu item object, or throws an error on failure.
---@param name string Item name
---@param items any One or more comma separated values that will be added. Alternatively, a table of strings that will be added.
---@param ... any Additional values to add.
---@return MenuItem
function MenuGroup:selectable(name, items, ...) end

---Creates and returns a menu item object, or throws an error on failure.
---
---Simple overload: `group:color_picker(name[, color])`.
---Multi-Color overload: `group:color_picker(name, colors)` where `colors` is a
---table containing tables with a string index, each holding one or more color objects.
---@param name string Item name
---@param color color? Optional. Initial color value
---@return MenuItem
---@overload fun(self: MenuGroup, name: string, colors: table): MenuItem
function MenuGroup:color_picker(name, color) end

---Creates and returns a menu item object, or throws an error on failure.
---@param name string Item name
---@param callback fun(item: MenuItem)? Optional. Function that will be called when the button is clicked
---@param alt_style boolean? Optional. Pass `true` to enable the alternative style for the specified button
---@return MenuItem
function MenuGroup:button(name, callback, alt_style) end

---Creates and returns a menu item object, or throws an error on failure.
---@param name string Item name
---@param default_key number? Optional. Default key (Windows virtual-key code)
---@return MenuItem
function MenuGroup:hotkey(name, default_key) end

---Creates and returns a menu item object, or throws an error on failure.
---@param name string Item name
---@param text string? Optional. Default value
---@return MenuItem
function MenuGroup:input(name, text) end

---Creates and returns a menu item object, or throws an error on failure.
---@param name string Item name
---@param items any One or more comma separated values that will be added. Alternatively, a table of strings that will be added.
---@param ... any Additional values to add.
---@return MenuItem
function MenuGroup:list(name, items, ...) end

---Creates and returns a menu item object, or throws an error on failure.
---@param name string Item name
---@param items any One or more comma separated values that will be added. Alternatively, a table of strings that will be added.
---@param ... any Additional values to add.
---@return MenuItem
function MenuGroup:listable(name, items, ...) end

---Creates and returns a menu item object, or throws an error on failure.
---@param text string Label text
---@return MenuItem
function MenuGroup:label(text) end

---Creates and returns a menu item object, or throws an error on failure.
---Create the texture via the `render.load_image` function.
---@param texture ImgObject Image object
---@param size vector? Optional. Size of the image
---@param color color? Optional. Color of the texture
---@param mode string? Optional. `f` for fill, `r` for repeat
---@param rounding number? Optional. Image border rounding
---@return MenuItem
function MenuGroup:texture(texture, size, color, mode, rounding) end

--=============================================================================
-- MenuItem object
--=============================================================================

---A menu item object returned by the `MenuGroup` control-creation methods and by `ui.find`.
---@class MenuItem
local MenuItem = {}

---Returns the value of the menu item.
---@return any
function MenuItem:get() end

---Returns the unique id of the menu item.
---@return number
function MenuItem:id() end

---Returns the list of items. `combo` / `selectable` menu item objects only.
---@return table
function MenuItem:list() end

---Returns the type of the menu item.
---@return string
function MenuItem:type() end

---Overrides the item value without changing the menu / config values.
---If the `value` argument is `nil` or missing, the override is undone.
---@param value any? The value to which the menu item will be set. Pass `nil` or omit to undo the override.
---@param ... any Additional values.
function MenuItem:override(value, ...) end

---Returns the value of the menu item it's overriden to.
---@return any
function MenuItem:get_override() end

---Updates the values of the menu item.
---@param ... any
function MenuItem:update(...) end

---Resets the menu item to it's original value.
function MenuItem:reset() end

---Sets the value of the menu item.
---@param value any The value to which the menu item will be set
---@param ... any Additional values.
function MenuItem:set(value, ...) end

---Gets or sets the name of the menu item.
---@param value any? New name. Omit to get the current name.
function MenuItem:name(value) end

---Gets or sets the tooltip of the menu item (depending on the presence of the `value` parameter).
---@param value any? New tooltip text. Omit to get the current tooltip.
function MenuItem:tooltip(value) end

---Gets or sets the menu item visibility depending on the value of `state`.
---@param state boolean? New visibility state. Omit to get the current visibility.
function MenuItem:visibility(state) end

---Gets or sets the menu item disabled state depending on the value of `state`.
---@param state boolean? New disabled state. Omit to get the current disabled state.
function MenuItem:disabled(state) end

---Sets the callback to the specified menu item.
---@param callback fun(item: MenuItem) Function that will be called when the menu item is interacted with
---@param force_call boolean? Pass `true` to call the callback function after setup
function MenuItem:set_callback(callback, force_call) end

---Unsets the callback that was set via the `:set_callback` function.
---@param callback fun(item: MenuItem) Lua function that was passed to the `:set_callback` function
function MenuItem:unset_callback(callback) end

---Attaches a color picker to the current menu item object.
---
---Simple overload: `item:color_picker([color])`.
---Multi-Color overload: `item:color_picker([colors])` where `colors` is a table
---containing tables with a string index, each holding one or more color objects.
---@param color color? Optional. Initial color value
---@return MenuItem
---@overload fun(self: MenuItem, colors: table): MenuItem
function MenuItem:color_picker(color) end

---Attaches a group (gear) to the current menu item object.
---@return MenuGroup
function MenuItem:create() end

---Returns the parent object of the menu item.
---@return MenuItem|MenuGroup
function MenuItem:parent() end

--=============================================================================
-- ESPGroup object
--=============================================================================

---An ESP group object returned by the ESP-item overload of `ui.find`.
---@class ESPGroup
local ESPGroup = {}

--=============================================================================
-- Hotkey struct
--=============================================================================

---A hotkey descriptor, as returned in the table from `ui.get_binds()`.
---@class Hotkey
---@field name string Hotkey name
---@field mode number Hotkey mode (`1`: Hold, `2`: Toggle)
---@field value any Hotkey value
---@field active boolean Hotkey state
---@field reference MenuItem Pointer to the menu item
