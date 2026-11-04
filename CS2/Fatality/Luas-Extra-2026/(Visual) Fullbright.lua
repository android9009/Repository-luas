-- Fatality interfaces.
local render = fatality.render
local config = fatality.config
local menu = fatality.menu
local cvar = csgo.interface_handler:get_cvar()
local engine_client = csgo.interface_handler:get_engine_client( )

-- Menu and config entries.
fullbright_item = config:add_item("fullbright", 0)
fullbright_checkbox = menu:add_checkbox("Fullbright", "visuals", "misc", "various", fullbright_item)

local mat_fullbright = cvar:find_var("mat_fullbright")

function on_paint()
    if not engine_client:is_in_game( ) then
        return end

    if fullbright_item:get_bool() then
        mat_fullbright:set_int(1)
     else
        mat_fullbright:set_int(0)
    end
end

local callbacks = fatality.callbacks
callbacks:add("paint", on_paint)