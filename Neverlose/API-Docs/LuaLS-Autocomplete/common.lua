---@meta
-- neverlose CS:GO API — common module. Auto-generated from docs-csgo.neverlose.cc.
-- Do not edit by hand; regenerate from the raw docs instead.

common = {}

---Returns the formatted date.
---@param format string Date format (strftime)
---@param unix_time number? Optional. Unix-format time
---@return string
function common.get_date(format, unix_time) end

---Returns the number of seconds that have elapsed since the unix epoch (1 January 1970 00:00:00).
---@return number
function common.get_unixtime() end

---Returns high precision timestamp in milliseconds.
---@return number
function common.get_timestamp() end

---Returns the windows time as a table containing the `year`, `month`, `day`, `hours`,
---`minutes`, and `seconds` values.
---@return table
function common.get_system_time() end

---Returns the product version of the game client.
---@return number
function common.get_product_version() end

---Returns the path to the game client folder.
---@return string
function common.get_game_directory() end

---Returns a table containing the `name`, `shortname`, and `group` values.
---@return table
function common.get_map_data() end

---Returns your Neverlose username.
---@return string
function common.get_username() end

---Returns the name of the currently loaded config.
---@return string
function common.get_config_name() end

---Returns a table of strings containing the names of the loaded scripts.
---@return table
function common.get_active_scripts() end

---Returns a value that indicates the amount that the mouse wheel has changed.
---@return number
function common.get_mouse_wheel_delta() end

---Returns `true` if the camera is in thirdperson.
---@return boolean
function common.is_in_thirdperson() end

---Reloads current script.
function common.reload_script() end

---Unloads current script.
function common.unload_script() end

---Forces the server to send a full update packet.
function common.force_full_update() end

---Sets your in-game clan tag.
---@param text string New clan tag
function common.set_clan_tag(text) end

---Sets your in-game name.
---@param text string New name
function common.set_name(text) end

---Prints the text into the upper-left neverlose event panel.
---@param text string Text to print to into the upper-left panel.
---@param icon_name string? Optional. Fontawesome icon name.
function common.add_event(text, icon_name) end

---Draws the notification.
---@param title string Text to print to into the title.
---@param text string Text to print to into the body of the notification.
---@param duration number? How long the notification stays, in seconds. Optional.
function common.add_notify(title, text, duration) end

---Returns `true` if the button is down, or nil on failure.
---See https://docs.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes for key codes.
---@param key number Key to check
---@return boolean
function common.is_button_down(key) end

---Returns `true` if the button is released, or nil on failure.
---@param key number Key to check
---@return boolean
function common.is_button_released(key) end
