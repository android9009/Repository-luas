---@meta
-- neverlose CS:GO API — esp module. Auto-generated from docs-csgo.neverlose.cc.
-- Do not edit by hand; regenerate from the raw docs instead.

---The `esp` module registers custom ESP elements to a class.
---Available ESP classes: `enemy`, `team`, `self`.
---@class esp
---@field enemy esp_class ESP elements drawn on enemy players.
---@field team esp_class ESP elements drawn on team players.
---@field self esp_class ESP elements drawn on the local player.
esp = {}

---An ESP class (`esp.enemy`, `esp.team`, `esp.self`) to which custom ESP elements
---(text, bars, items) can be registered.
---@class esp_class
local esp_class = {}

---Registers ESP text to the specified class. The callback function is called every
---frame. It is passed an entity pointer. Return a string in order to manage the output.
---@param name string ESP element picker text
---@param preview string ESP preview text
---@param callback fun(entity: entity): string? Function that will be called for each entity while drawing the ESP
---@return ESPGroup
function esp_class:new_text(name, preview, callback) end

---Registers an ESP bar to the specified class. The callback function is called every
---frame. Access the entity pointer using the arguments of the specified callback.
---Return a boolean followed by the number in the range [0.0, 1.0].
---@param name string ESP element picker text
---@param callback fun(entity: entity): boolean, number Function that will be called for each entity while drawing the ESP
---@return ESPGroup
function esp_class:new_bar(name, callback) end

---Registers an ESP item that is neither text nor a bar.
---@param name string ESP element picker text
---@return ESPGroup
function esp_class:new_item(name) end

---An ESP element handle returned by `esp_class:new_text`, `:new_bar` and `:new_item`.
---@class ESPGroup
local ESPGroup = {}

---Returns the value of the item.
---@return any
function ESPGroup:get() end

---Sets the value of the item.
---@param value any The value to set.
function ESPGroup:set(value) end

---Returns the name of the item. If the argument is present, the name is set to the new value.
---@param value string? Optional. New name to set.
---@return string
function ESPGroup:name(value) end

---Attaches a `group` to the current item.
---@return MenuGroup
function ESPGroup:create() end
