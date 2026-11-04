local render = fatality.render
local config = fatality.config
local menu = fatality.menu

-- Get all accessable interfaces
local engine_client = csgo.interface_handler:get_engine_client( )
local render = fatality.render;
local global_vars = csgo.interface_handler:get_global_vars( );

-- Create config & menu items
local fatality_bar = config:add_item( "Fatality_Bar", 0.0 );

local fade_bar_Gradient = config:add_item( "fade_bar_Gradient", 0.0 );
local fade_bar_rainbow = config:add_item( "fade_bar_rainbow", 0.0 );

local example_combo = menu:add_combo( "Fatality Bar", "visuals", "misc", "various", fatality_bar )
example_combo:add_item( "Gradient", fade_bar_Gradient )
example_combo:add_item( "Rainbow", fade_bar_rainbow )

function on_paint()

-- Checks if Checkbox is ticked
    if fatality_bar:get_int( ) == 0 then

-- Draws Reactangle
    render:rect_fade( 0, 0, 4000, 3, csgo.color(66, 0, 255, 255), csgo.color(255, 0, 54, 255), true);
        return end
   
-- Rainbow Bar
    if not fatality_bar:get_int( ) == 1 then
        return end

-- Draws Rainbow Gradient
    local r = math.sin((global_vars.realtime / 8) * 3) * 127 + 128;
    local g = math.sin((global_vars.realtime / 8) * 5) * 127 + 128;
    local b = math.sin((global_vars.realtime / 8) * 7) * 127 + 128;

-- Draws Rainbow Reactangle
    render:rect_fade( 0, 0, 4000, 3, csgo.color(math.floor(r), math.floor(g), 255, 255), csgo.color(math.floor(r), math.floor(g), math.floor(b), 255), true);
    end
-- Register all callback functions that should be called
    local callbacks = fatality.callbacks
    callbacks:add( "paint", on_paint );