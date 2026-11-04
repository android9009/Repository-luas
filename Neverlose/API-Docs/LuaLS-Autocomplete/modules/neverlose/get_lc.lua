-- neverlose library: get_lc — the local player's lag-compensation state.
-- Usage: local get_lc = require("neverlose/get_lc")
-- LSP definition stub: neverlose loads the real library at runtime; this only provides types.

---Returns the local player's lag-compensation state:
--- * `-1` = not breaking LC
--- * `0`  = normal
--- * `1`  = breaking LC
---@return integer state
local function get_lc() return 0 end

return get_lc
