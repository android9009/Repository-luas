-- Slide Fake Lag, Created By Toes
local menu = fatality.menu
local render = fatality.render
local input = fatality.input
local config = fatality.config
-- Menu Additions
local slide_lag = menu:get_reference("RAGE", "ANTI-AIM", "Moving", "Fake Lag")
local keep_lag = menu:get_reference("RAGE", "ANTI-AIM", "General", "Keep jitter")
local slowalk_key_bind = config:add_item("slowalk_key_bind", 0)
local key_check = menu:add_checkbox("Slide Fake Lag", "RAGE", "ANTI-AIM", "General", slowalk_key_bind)
-- Slide Key Bind
local key = 0x10
-- Bind Logic
fatality.callbacks:add("paint", function()
    if slowalk_key_bind:get_int() == 1 then
        if(input:is_key_down(key)) then
            slide_lag:set_bool(true)
            if(keep_lag:get_bool(true)) then
        else
            keep_rlag:set_bool(true)
        end
-- Indicator Rendering
        local screen_size = render:screen_size( );
        render:indicator( screen_size.x / 110, screen_size.y / 1 - 300, "SLIDE LAG", true, -1 );
        else
        local screen_size = render:screen_size( );
        render:indicator( screen_size.x / 110, screen_size.y / 1 - 300, "SLIDE LAG", false, -1 );
         
        end
    end
   
end)