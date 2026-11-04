-- shoutout reahly for min dmg on key
-- shoutout ffaed for the hotkeys table
-- shoutout me for doing nothing :thumbsup:
-- all i did is redesign table and added dmg on button
-- https://fatality.win/threads/hotkey-table-with-min-damage-on-key.4029/

local global_vars         = csgo.interface_handler:get_global_vars( );
local entity_list         = csgo.interface_handler:get_entity_list( );
local engine_client        = csgo.interface_handler:get_engine_client( );
local entity_list         = csgo.interface_handler:get_entity_list( )
local input             = fatality.input;

local config             = fatality.config
local menu                 = fatality.menu
local render             = fatality.render;

local hotkey_item         = config:add_item( "hotkeys", 1.0 );
local hotkey_checkbox     = menu:add_checkbox( "hotkey", "visuals", "misc", "various", hotkey_item );

--dmg things
--dmg things
--dmg things

local auto_cfg, awp_cfg, pistols_cfg, scout_cfg, heavyp_cfg, other_cfg =
    config:add_item( "auto_cfg", 0 ),
    config:add_item( "awp_cfg", 0 ),
    config:add_item( "pistols_cfg", 0 ),
    config:add_item( "scout_cfg", 0 ),
    config:add_item( "heavyp_cfg", 0 ),
    config:add_item( "other_cfg", 0 );

local auto_menu, awp_menu, pistols_menu, scout_menu, heavyp_menu, other_menu =
       menu:add_slider( "Min-damage bind", "Rage", "Weapons", "Auto", auto_cfg, 0, 100, 0 ),
       menu:add_slider( "Min-damage bind", "Rage", "Weapons", "AWP", awp_cfg, 0, 100, 0 ),
       menu:add_slider( "Min-damage bind", "Rage", "Weapons", "Pistols", pistols_cfg, 0, 100, 0 ),
       menu:add_slider( "Min-damage bind", "Rage", "Weapons", "Scout", scout_cfg, 0, 100, 0 ),
       menu:add_slider( "Min-damage bind", "Rage", "Weapons", "Heavy pistols", heavyp_cfg, 0, 100, 0 ),
       menu:add_slider( "Min-damage bind", "Rage", "Weapons", "Other", other_cfg, 0, 100, 0 );

local backups = {
    auto_mindmg = menu:get_reference( "Rage", "Weapons", "Auto", "Min-damage" ):get_int( );
    awp_mindmg = menu:get_reference( "Rage", "Weapons", "AWP", "Min-damage" ):get_int( );
    pistols_mindmg = menu:get_reference( "Rage", "Weapons", "Pistols", "Min-damage" ):get_int( );
    scout_mindmg = menu:get_reference( "Rage", "Weapons", "Scout", "Min-damage" ):get_int( );
    heavyp_mindmg = menu:get_reference( "Rage", "Weapons", "Heavy pistols", "Min-damage" ):get_int( );
    other_mindmg = menu:get_reference( "Rage", "Weapons", "Other", "Min-damage" ):get_int( );
};

function manage_menu( toggle )
    if ( toggle ) then
        menu:get_reference( "Rage", "Weapons", "Auto", "Min-damage" ):set_int( auto_cfg:get_int( ) );
        menu:get_reference( "Rage", "Weapons", "AWP", "Min-damage" ):set_int( awp_cfg:get_int( ) );
        menu:get_reference( "Rage", "Weapons", "Pistols", "Min-damage" ):set_int( pistols_cfg:get_int( ) );
        menu:get_reference( "Rage", "Weapons", "Scout", "Min-damage" ):set_int( scout_cfg:get_int( ) );
        menu:get_reference( "Rage", "Weapons", "Heavy pistols", "Min-damage" ):set_int( heavyp_cfg:get_int( ) );
        menu:get_reference( "Rage", "Weapons", "Other", "Min-damage" ):set_int( other_cfg:get_int( ) );
    else
        menu:get_reference( "Rage", "Weapons", "Auto", "Min-damage" ):set_int( backups.auto_mindmg );
        menu:get_reference( "Rage", "Weapons", "AWP", "Min-damage" ):set_int( backups.awp_mindmg );
        menu:get_reference( "Rage", "Weapons", "Pistols", "Min-damage" ):set_int( backups.pistols_mindmg );
        menu:get_reference( "Rage", "Weapons", "Scout", "Min-damage" ):set_int( backups.scout_mindmg );
        menu:get_reference( "Rage", "Weapons", "Heavy pistols", "Min-damage" ):set_int( backups.heavyp_mindmg );
        menu:get_reference( "Rage", "Weapons", "Other", "Min-damage" ):set_int( backups.other_mindmg );
    end
end

local key = 0x06; -- change here ur key
local last_timer = global_vars.tickcount;

--dmg things
--dmg things
--dmg things

local offset_x, offset_y = -193, 15;

--box drawing function
function draw_container( x, y, w, h )
    local c = {10, 60, 40, 40, 40, 60, 20};
    for i = 0,6,1 do
        render:rect_filled( x+i, y+i, w-(i*2), h-(i*2), csgo.color( c[i+1], c[i+1], c[i+1], 255 ) );
    end
end

--references
local slide = menu:get_reference( "misc", "", "movement", "slide" );
local forcebaim = menu:get_reference( "rage", "aimbot", "aimbot", "force fallback" );
local dt = menu:get_reference( "rage", "weapons", "auto", "double tap" );
local fd = menu:get_reference( "misc", "", "movement", "fake duck");

--fonts
local small_12 = render:create_font( "Small Fonts", 12, 400, true );
local small_13 = render:create_font( "Small Fonts", 15, 650, false );

function on_paint( )

    local menusize = 24
  
        if ( dt:get_bool() ) then
      
            menusize = menusize + 11
        end
        if ( forcebaim:get_bool() ) then
  
        menusize = menusize + 11
        end
        if ( fd:get_bool() ) then
  
        menusize = menusize + 11
        end 
        if ( input:is_key_down( key ) and global_vars.tickcount - last_timer > 20 ) then
            toggled = not toggled;
            last_timer = global_vars.tickcount;
        end
  
        if ( toggled ) then
        menusize = menusize + 11
        end
      
        --rainbow shit
        local r = math.floor( math.sin( global_vars.realtime * 2) * 127 + 128 )
        local g = math.floor( math.sin( global_vars.realtime * 2 + 2 ) * 127 + 128 )
        local b = math.floor( math.sin( global_vars.realtime * 2 + 4 ) * 127 + 128 );

        local distance = 438

        if ( hotkey_item:get_bool( ) ) then
            local local_player = entity_list:get_localplayer( );
            if ( local_player == nil ) then
            return end

            local screen_size = render:screen_size( );
            local x = offset_x >= 0 and offset_x or screen_size.x + offset_x;
            local y = offset_y >= 0 and offset_y or screen_size.y + offset_y
            local offset_x_temp = 16.5;
          
          
            local local_player = entity_list:get_localplayer()
          
            --checking if the player is alive
            if(local_player ~= nil and local_player:is_alive()) then
                  
              
          

            --drawing the box with the rainbow shit
                if not ( dt:get_bool() or forcebaim:get_bool() or fd:get_bool() or toggled) then
                else
                    draw_container( 30, y + 440, 210, menusize ); 
                    render:rect_filled(36, y + 446, 198 , 1, csgo.color(r,g,b, 255));
                end
              
              
            --double tap
                if ( dt:get_bool() ) then
                    distance = distance + 12
                  
                    if not ( fd:get_bool() ) then
                  
                        render:text( small_12, 40, y + distance, "Double tap", csgo.color( 255, 255, 255, 230 ) );
                        render:text( small_12, 200, y + distance, "[ on ]", csgo.color( 149, 184, 6, 230 ) );
                    else
                  
                        render:text( small_12, 40, y + distance, "Double tap", csgo.color( 255, 255, 255, 230 ) );
                        render:text( small_12, 200, y + distance, "[ off ]", csgo.color( 255, 0, 72, 230 ) );
                    end
                end
            --force baim   
                if ( forcebaim:get_bool() ) then
                    distance = distance + 12
              
                    render:text( small_12, 40, y + distance, "Force baim", csgo.color( 255, 255, 255, 230 ) );
                    render:text( small_12, 200, y + distance, "[ on ]", csgo.color( 149, 184, 6, 230 ) );
                  
                end
            --fake duck 
                if ( fd:get_bool() ) then
                    distance = distance + 12
              
                    render:text( small_12, 40, y + distance, "Duck peek assist", csgo.color( 255, 255, 255, 230 ) );
                    render:text( small_12, 200, y + distance, "[ on ]", csgo.color( 149, 184, 6, 230 ) );
                end     
            --dmg
                if ( toggled ) then
              
                distance = distance + 12
          
                render:text( small_12, 40, y + distance, "Damage override", csgo.color( 255, 255, 255, 230 ) );
                render:text( small_12, 200, y + distance, "[ on ]", csgo.color( 149, 184, 6, 230 ) );
              
                    manage_menu( true );
                else
                    manage_menu( false );
                end
            --slide
                if ( slide:get_bool() ) then
              
                    distance = distance + 12
                  
                    render:text( small_12, 40, y + distance, "Slide", csgo.color( 255, 255, 255, 230 ) );
                    render:text( small_12, 200, y + distance, "[ on ]", csgo.color( 149, 184, 6, 230 ) );
                end
            end
        end
  
end

local callbacks = fatality.callbacks;
callbacks:add( "paint", on_paint );