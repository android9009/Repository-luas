-- https://fatality.win/threads/color-correction-lua.908/

local engine_client = csgo.interface_handler:get_engine_client()
local cvar = csgo.interface_handler:get_cvar()
local config = fatality.config
local menu = fatality.menu

colorcor_item = config:add_item("Colorcorrection", 0)
colorcor_r = config:add_item("Colorcorrection_r", 0.50)
colorcor_g = config:add_item("Colorcorrection_g", 0.50)
colorcor_b = config:add_item("Colorcorrection_b", 0.50)

colorcor_checkbox = menu:add_checkbox("Color correction", "VISUALS", "MISC", "Various", colorcor_item)

colorcor_slider_r = menu:add_slider("Red", "VISUALS", "MISC", "Various", colorcor_r, -0.50, 1.00, 0.05)
colorcor_slider_g = menu:add_slider("Green", "VISUALS", "MISC", "Various", colorcor_g, -0.50, 1.00, 0.05)
colorcor_slider_b = menu:add_slider("Blue", "VISUALS", "MISC", "Various", colorcor_b, -0.50, 1.00, 0.05)

local mat_amb_r = cvar:find_var("mat_ambient_light_r")
local mat_amb_g = cvar:find_var("mat_ambient_light_g")
local mat_amb_b = cvar:find_var("mat_ambient_light_b")

fatality.callbacks:add("paint", function()
    if(not engine_client:is_in_game()) then
        return
    end

    if(colorcor_item:get_bool()) then
        mat_amb_r:set_float(colorcor_r:get_float())
        mat_amb_g:set_float(colorcor_g:get_float())
        mat_amb_b:set_float(colorcor_b:get_float())
     else
        mat_amb_r:set_float(0)
        mat_amb_g:set_float(0)
        mat_amb_b:set_float(0)
    end
end)