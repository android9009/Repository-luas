---@meta
-- neverlose CS:GO API — math module (neverlose extensions). Auto-generated from docs-csgo.neverlose.cc.
-- Do not edit by hand; regenerate from the raw docs instead.
--
-- Only the neverlose-added functions are declared here. Standard Lua math functions
-- (math.floor, math.abs, math.random, etc.) are provided by lua-language-server's
-- built-in definitions and are intentionally NOT redeclared to avoid clashes.

---Returns the clamped value.
---@param value number The value to clamp
---@param min number? The minimum value. Optional.
---@param max number? The maximum value. Optional.
---@return number
function math.clamp(value, min, max) end

---Linearly maps two number ranges and returns the mapped value.
---@param value number The value to map
---@param in_from number In minimum value
---@param in_to number In maximum value
---@param out_from number Out minimum value
---@param out_to number Out maximum value
---@param should_clamp boolean? Clamp `In` range. Optional.
---@return number
function math.map(value, in_from, in_to, out_from, out_to, should_clamp) end

---Returns the normalized yaw angle value.
---@param x number Number
---@return number
function math.normalize_yaw(x) end

---Returns the absolute difference between two numbers.
---@param a number First value
---@param b number Second value
---@return number
function math.difference(a, b) end
