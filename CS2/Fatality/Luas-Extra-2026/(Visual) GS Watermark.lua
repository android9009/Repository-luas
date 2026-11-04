local global_vars = csgo.interface_handler:get_global_vars( );
local entity_list = csgo.interface_handler:get_entity_list( );
local engine_client = csgo.interface_handler:get_engine_client( );

local config = fatality.config
local menu = fatality.menu
local render = fatality.render;

local watermark_item = config:add_item( "gs_watermark", 1.0 );
local watermark_checkbox = menu:add_checkbox( "Watermark", "visuals", "misc", "various", watermark_item );

local watermark_item_rainbow = config:add_item( "gs_watermarkrainbow", 1.0 );
local watermark_rainbow_checkbox = menu:add_checkbox( "Watermark rainbow", "visuals", "misc", "various", watermark_item_rainbow );

local offset_x, offset_y = -193, 15;

local frame_rate = 0.0
function get_abs_fps( )
  frame_rate = 0.9 * frame_rate + ( 1.0 - 0.9 ) * global_vars.frametime;
  return math.floor( ( 1.0 / frame_rate ) + 0.5 );
end

function draw_container( x, y, w, h )
    local c = {10, 60, 40, 40, 40, 60, 20};
    for i = 0,6,1 do
        render:rect_filled( x+i, y+i, w-(i*2), h-(i*2), csgo.color( c[i+1], c[i+1], c[i+1], 255 ) );
    end
end

local small_12 = render:create_font( "Small Fonts", 12, 400, true );
local small_13 = render:create_font( "Small Fonts", 15, 650, false );

function on_paint( )
    if ( watermark_item:get_bool( ) ) then
        local local_player = entity_list:get_localplayer( );
        if ( local_player == nil ) then
            return end
        local velocity = local_player:get_var_vector( "CBasePlayer->m_vecVelocity[0]" );
        if ( velocity ) then
            vel_2d = math.ceil( math.sqrt( math.abs( velocity.x ) * math.abs( velocity.x ) + math.abs( velocity.y ) * math.abs( velocity.y ) ) );
            velocity_text = string.format( "%d", vel_2d );
        end    

        local screen_size = render:screen_size( );
        local x = offset_x >= 0 and offset_x or screen_size.x + offset_x;
        local y = offset_y >= 0 and offset_y or screen_size.y + offset_y
        local offset_x_temp = 16.5;
    
        if ( watermark_item_rainbow:get_bool( ) ) then
            r,g,b = math.floor( math.sin( global_vars.realtime * 2) * 127 + 128 ), math.floor( math.sin( global_vars.realtime * 2 + 2 ) * 127 + 128 ), math.floor( math.sin( global_vars.realtime * 2 + 4 ) * 127 + 128 );
        else
            r,g,b = 255,255,255;
        end
    
        draw_container( x-offset_x_temp+10, y, 184+offset_x_temp, 30 );
        render:text( small_13, x+23-offset_x_temp, y+8, "fata", csgo.color( 255, 255, 255, 230 ) ); --11
        render:text( small_13, x+46-offset_x_temp, y+8, "lity", csgo.color( 149, 184, 6, 230 ) );
        render:text( small_12, x+69-offset_x_temp, y+8, "|", csgo.color( 255, 255, 255, 230 ) );
    
        local fps_r, fps_g, fps_b = r, g, b;
        if ( get_abs_fps( ) < ( 1 / global_vars.interval_per_tick ) ) then
            fps_r, fps_g, fps_b = 255, 0, 0
        end
        --fps part
        local fps_x = 86-offset_x_temp;
        render:text( small_12, x+fps_x-9.9, y+8, tostring( get_abs_fps( ) ), csgo.color( fps_r, fps_g, fps_b, 230 ) );
        render:text( small_12, x+fps_x+7.4, y+8.3, "fps", csgo.color( r, g, b, 230 ) );
        render:text( small_12, x+fps_x+23.5, y+8, "|", csgo.color( 255, 255, 255, 230 ) );
    
        --ping part
        local ping_r, ping_g, ping_b = r, g, b;
        if ( engine_client:get_ping( ) > 100 ) then
            ping_r, ping_g, ping_b = 255, 0, 0;
        end
        local ping_x = 129-offset_x_temp;
        if ( engine_client:get_ping( ) > 99 ) then
            custom_x = x+ping_x+4;
        else
            custom_x = x+ping_x+2.2;
        end
        if ( engine_client:get_ping( ) < 1 ) then  --if in bot match
            custom_x = x+ping_x-0.8;
        end
        render:text( small_12, x+ping_x-13.5, y+8, engine_client:get_ping( ), csgo.color( ping_r, ping_g, ping_b, 230 ) );
        render:text( small_12, custom_x, y+8.3, "ping", csgo.color( ping_r, ping_g, ping_b, 230 ) );
        render:text( small_12, x+ping_x+26.2, y+8, "|", csgo.color( 255, 255, 255, 230 ) );
    
        --velocity part
        local velocity_x = 143-offset_x_temp;
        if ( vel_2d > 99 ) then
            custom_velocity_x = x+velocity_x + 38;
        else
            custom_velocity_x = x+velocity_x + 31.5;
        end
        if ( vel_2d < 1 ) then
            custom_velocity_x = x+velocity_x + 28.5;
        end
        render:text( small_12, x+velocity_x+18, y+8, velocity_text, csgo.color( r, g, b, 230 ) );
        render:text( small_12, custom_velocity_x, y+8.3, "u / t", csgo.color( r, g, b, 230 ) );
    end
end

local callbacks = fatality.callbacks;
callbacks:add( "paint", on_paint );