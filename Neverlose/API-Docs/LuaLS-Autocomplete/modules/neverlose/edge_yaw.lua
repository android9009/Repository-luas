-- neverlose library: edge_yaw — get the edge yaw angle.
-- Usage: local edge_yaw = require("neverlose/edge_yaw")
-- LSP definition stub: neverlose loads the real library at runtime; this only provides types.

local edge_yaw = {}

---Returns the edge yaw angle. Feed it to a Yaw Offset override, e.g.
---`ui.find("Aimbot","Anti Aim","Angles","Yaw","Offset"):override(edge_yaw.get())`.
---Call from the `createmove` event.
---@return number angle Edge yaw angle
function edge_yaw.get() return 0 end

return edge_yaw
