local render = fatality.render
local menu = fatality.menu
local config = fatality.config
local input = fatality.input
local entity_list = csgo.interface_handler:get_entity_list()
local global_vars = csgo.interface_handler:get_global_vars()
 local screen_size = render:screen_size()
 local fake_mode_item = config:add_item("fake_mode", 0)
 local fake_direction_stand = menu:get_reference("RAGE", "ANTI-AIM", "Standing", "Fake direction")
local fake_direction_move = menu:get_reference("RAGE", "ANTI-AIM", "Moving", "Fake direction")
local fake_mode_combo = menu:add_combo("AA Mode", "RAGE", "ANTI-AIM", "General", fake_mode_item)
 local hotkey = 0x43
local side = false
local tickcount = 0
 local local_player 

function get_rainbow()
    local r = math.floor(math.sin(global_vars.realtime * 2) * 127 + 128)
    local g =  math.floor(math.sin(global_vars.realtime * 2 + 2 ) * 127 + 128)
    local b = math.floor(math.sin(global_vars.realtime * 2 + 4 ) * 127 + 128)
    return csgo.color(r, g, b, 255)
end
 function draw_disabled_arrow(x, y, size, color, side)
    if(side) then
        for i = 0, (size - 1) do
            render:rect(x + i, y + (i / 2) + 1, 1, size - i, color)
        end
        
    else
        for i = 0, (size - 1) do
            render:rect(x - i, y + (i / 2) + 1, 1, size - i, color)
        end 
    end
end
function draw_arrow(x, y, size, color, side)
    if(side) then
        for i = 0, (size - 1) do
            render:rect(x - i, y + (i / 2) + 1, 1, size - i, color)
        end
    else
        for i = 0, (size - 1) do
            render:rect(x + i, y + (i / 2) + 1, 1, size - i, color)
        end
    end
end
function set_direction(dir)
    fake_direction_stand:set_int(dir)
    fake_direction_move:set_int(dir)
end
 function on_paint()
    if(tickcount > global_vars.tickcount) then tickcount = 0 end
    local_player = entity_list:get_localplayer()
    if(local_player ~= nil and local_player:is_alive()) then
        if(fake_mode_item:get_int() == 0) then
           if(input:is_key_pressed(6)) then
                side = not side
            end
 if(side) then 
                draw_arrow(screen_size.x / 2 - 10 - 30 + 1, screen_size.y / 2 - 10, 20 + 2, csgo.color(255,255,255,255), side)
                draw_arrow(screen_size.x / 2 - 10 - 30, screen_size.y / 2 - 10, 20, csgo.color(255,255,255,230), side)

                draw_disabled_arrow(screen_size.x / 2 + 10 + 30, screen_size.y / 2 - 10, 20, csgo.color(0,255,7,180), side)

                set_direction(2)
            else 
                draw_arrow(screen_size.x / 2 + 10 + 30 - 1, screen_size.y / 2 - 10, 20 + 2, csgo.color(255,255,255,255), side)
                draw_arrow(screen_size.x / 2 + 10 + 30, screen_size.y / 2 - 10, 20, csgo.color(255,255,255,230), side)

                draw_disabled_arrow(screen_size.x / 2 - 10 - 30, screen_size.y / 2 - 10, 20, csgo.color(0,255,7,180), side)
                set_direction(3)
            end
        elseif(fake_mode_item:get_int() == 1) then
            if(global_vars.tickcount > (tickcount + 1)) then
                tickcount = global_vars.tickcount
             
                side = not side
                if(side) then
                    set_direction(2)
                else
                    set_direction(3)
                end
            end
        end
    end
end
 
local callbacks = fatality.callbacks
callbacks:add("paint", on_paint)