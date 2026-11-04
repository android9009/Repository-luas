-- https://fatality.win/threads/fakewalk-lua.1669/

 -- Fakewalk Lua by johnyy177

--inputs
local render = fatality.render
local config = fatality.config
local menu = fatality.menu
local cvar = csgo.interface_handler:get_cvar( )
local engine_client = csgo.interface_handler:get_engine_client( )
local entity_list = csgo.interface_handler:get_entity_list( )
local global_vars = csgo.interface_handler:get_global_vars( )
local input = fatality.input

--menu checkbox
local fakewalk_item = config:add_item( "fakewalk_rage_v2", 0.0 )
local fakewalk_checkbox = menu:add_checkbox( "Fakewalk", "RAGE", "AIMBOT", "Aimbot", fakewalk_item )

--references
local slowwalk = menu:get_reference( "RAGE", "AIMBOT", "Aimbot", "Slide" )
local autostop_off_auto = menu:get_reference( "RAGE", "WEAPONS", "Auto", "Autostop" )
local autostop_off_awp = menu:get_reference( "RAGE", "WEAPONS", "AWP", "Autostop" )
local autostop_off_pistols = menu:get_reference( "RAGE", "WEAPONS", "Pistols", "Autostop" )
local autostop_off_scout = menu:get_reference( "RAGE", "WEAPONS", "Scout", "Autostop" )
local autostop_off_heavy_pistols = menu:get_reference( "RAGE", "WEAPONS", "Heavy pistols", "Autostop" )
local autostop_off_other = menu:get_reference( "RAGE", "WEAPONS", "Other", "Autostop" )

--cvars
sidespeed = cvar:find_var( "cl_sidespeed" )

forwardspeed = cvar:find_var( "cl_forwardspeed" )

backspeed = cvar:find_var( "cl_backspeed" )

--newspeed function
function newspeed( new_speed )
    if ( sidespeed:get_int( ) == 450 and new_speed == 450 ) then
        return
    end
     sidespeed:set_float( new_speed )
     forwardspeed:set_float( new_speed )
     backspeed:set_float( new_speed )
end

--switches and tickcounts
local switch_bool = false
local switch_bool2 = false
local switch_bool3 = false
local tickcount = 0
local tickcount2 = 0
local tick = math.floor( 1.0 / global_vars.interval_per_tick )

function on_paint()
    --if you arent in game, return
    if not engine_client:is_in_game( ) then
       return end
        
    local local_player = entity_list:get_localplayer( )

    --if you arent alive, return
    if not local_player:is_alive( ) then
        return end

    --define shift key (its binded on shift)    
    local shift_key = input:is_key_down( 16 )
    
    --if not on shift key, set speed value to normal
    if not shift_key then
        newspeed( 450 )    
    else --else fakewalk code
        if fakewalk_item:get_bool( ) then
            slowwalk:set_bool( false )
            autostop_off_auto:set_int( 0 )
            autostop_off_awp:set_int( 0 )
            autostop_off_pistols:set_int( 0 )
            autostop_off_scout:set_int( 0 )
            autostop_off_heavy_pistols:set_int( 0 )
            autostop_off_other:set_int( 0 )
            if ( global_vars.tickcount > ( tickcount + 7 ) ) then     
                tickcount = global_vars.tickcount
                switch_bool = not switch_bool
                switch_bool2 = not switch_bool2
                switch_bool3 = not switch_bool3
                
                local final_val = 250 * 100 / 100  
                if switch_bool3 then
                    if switch_bool2 then
                        if switch_bool then
                            newspeed( 240 )
                        else
                            newspeed( final_val )
                        end    
                    else
                        if switch_bool then
                            newspeed( 48 )
                        else
                            newspeed( final_val / 15 )
                        end
                    end    
                else
                    newspeed( 14 )
                end
            end    
        end
    end
end --end

local callbacks = fatality.callbacks
callbacks:add( "paint", on_paint )