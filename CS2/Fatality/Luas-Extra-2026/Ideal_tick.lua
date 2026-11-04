local screen_width, screen_height = render.get_screen_size( )
local x, y = screen_width / 2, screen_height / 2
local color = render.color(191, 117, 255, 255)

local idealtick = {
    autopeek_state = 0,
    doubletap_state = 0,
    freestanding_state = 0,

    active = true
}

local refs = {
   doubletap = gui.get_config_item("rage>aimbot>aimbot>double tap"),
   freestanding = gui.get_config_item("rage>anti-aim>angles>freestand"),
   autopeek = gui.get_config_item("misc>movement>peek assist")
}

local ideal_tick_master = gui.add_checkbox("Ideal tick", "misc>movement")
gui.add_keybind("misc>movement>ideal tick")

function on_paint()
    if not engine.is_in_game( ) then
        return
    end

    if ideal_tick_master:get_bool() then
    
        render.text( render.font_esp, x + 2, y + 30, "IDEAL", color, render.align_center, render.align_center )

        if idealtick.active then
            idealtick.autopeek_state = refs.autopeek:get_bool()
            idealtick.doubletap_state = refs.doubletap:get_bool()
            idealtick.freestanding_state = refs.freestanding:get_bool()

            idealtick.active = false
        end

        refs.doubletap:set_bool(true)
        refs.autopeek:set_bool(true)
        refs.freestanding:set_bool(true)
    else
        if not idealtick.active then
            refs.autopeek:set_bool(idealtick.autopeek_state)
            refs.doubletap:set_bool(idealtick.doubletap_state)
            refs.freestanding:set_bool(idealtick.freestanding_state)

            idealtick.active = true
        end
    end
end