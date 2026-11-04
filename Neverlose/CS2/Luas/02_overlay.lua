-- @author Example
-- @uid 1
-- A checkbox and a small overlay. Does not require Allow Insecure.

local tab = ui.tab("Lua Examples")
local group = tab:group("Overlay")
local enabled = group:checkbox("Show example", true)
local tint = color(220, 230, 255, 255)

events.on("paint", function()
    if not enabled:get() then
        return
    end

    render.rect_filled(20, 80, 190, 35, color(15, 18, 25, 210), 6)
    render.text(30, 90, tint, "Neverlose Lua example")
end)
