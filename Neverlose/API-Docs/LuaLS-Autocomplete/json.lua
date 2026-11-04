---@meta
-- neverlose CS:GO API — json module. Auto-generated from docs-csgo.neverlose.cc.
-- Do not edit by hand; regenerate from the raw docs instead.

json = {}

---Will deserialize any UTF-8 JSON string into a Lua value or table.
---@param json_text string UTF-8 JSON text
---@return any
function json.parse(json_text) end

---Will serialize a Lua value into a string containing the JSON representation.
---@param value any A lua boolean, number, string, table or nil
---@return string
function json.stringify(value) end
