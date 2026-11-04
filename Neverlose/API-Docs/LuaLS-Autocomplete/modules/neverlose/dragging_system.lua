local dragging_system = {}
local widgets = {}
local widget_count = 0
local active_drag = nil

local function make_widget(x_ref, y_ref, w, h, callback, alpha_val)
    widget_count = widget_count + 1
    local widget = {
        position = vector(x_ref:get() or 0, y_ref:get() or 0),
        size = vector(w or 100, h or 20),
        alpha = alpha_val or 0,
        global_alpha = 0,
        dragging = { active = false, offset = vector() },
        enable = true,
        name = "",
        name_menu = "",
        index = widget_count,
        x_ref = x_ref,
        y_ref = y_ref,
        callback = callback,
    }

    setmetatable(widget, {
        __index = function(t, k)
            if k == "is_dragging" then
                return widget.dragging.active
            end
            return rawget(t, k)
        end,
    })

    if callback then
        local ok, err = pcall(callback, widget)
        if not ok then end
    end

    widgets[widget_count] = widget
    return widget
end

function dragging_system.register(x_ref, y_ref, w, h, callback, alpha_val)
    return make_widget(x_ref, y_ref, w, h, callback, alpha_val)
end

function dragging_system.set_priority()
    local mouse = ui.get_mouse_position()
    if not mouse then return end

    for i = widget_count, 1, -1 do
        local w = widgets[i]
        if w and w.enable then
            local in_rect = mouse.x >= w.position.x and mouse.x <= w.position.x + w.size.x
                and mouse.y >= w.position.y and mouse.y <= w.position.y + w.size.y
            if in_rect and ui.is_key_pressed(0x01) and not active_drag then
                active_drag = i
                w.dragging.active = true
                w.dragging.offset = vector(w.position.x - mouse.x, w.position.y - mouse.y)
            elseif active_drag == i and not ui.is_key_pressed(0x01) then
                w.dragging.active = false
                active_drag = nil
                if w.x_ref and w.x_ref.set then
                    w.x_ref:set(w.position.x)
                end
                if w.y_ref and w.y_ref.set then
                    w.y_ref:set(w.position.y)
                end
            end
            if active_drag == i then
                w.position = vector(mouse.x + w.dragging.offset.x, mouse.y + w.dragging.offset.y)
            end
        end
    end
end

function dragging_system.get_anti_shot()
    if active_drag then
        return true
    end
    return false
end

return dragging_system
