local render = fatality.render;
local callbacks = fatality.callbacks;

local entity_list = csgo.interface_handler:get_entity_list();
local global_vars = csgo.interface_handler:get_global_vars();

local data = {
    alpha = 0
}

local function on_event(event)
    if event:get_name() == 'player_hurt' then
        local me = entity_list:get_localplayer();

        local victim = entity_list:get_player_from_id(event:get_int('userid'));
        local attacker = entity_list:get_player_from_id(event:get_int('attacker'));

        if victim and attacker then
            if victim:get_index() ~= me:get_index() and attacker:get_index() == me:get_index() then
                if event:get_int('health') <= 0 then     
                    data.alpha = 100;
                end
            end
        end
    end
end

local function on_paint()
    if data.alpha > 0 then
        local screen = render:screen_size();

        render:rect_fade(0, 0, screen.x, screen.y * 0.25, csgo.color(145, 187, 255, math.ceil(data.alpha)), csgo.color(145, 187, 255, 0), false);
        render:rect_fade(0, 0, screen.x * 0.25, screen.y, csgo.color(145, 187, 255, math.ceil(data.alpha)), csgo.color(145, 187, 255, 0), true);
        render:rect_fade(screen.x - screen.x * 0.25, 0, screen.x, screen.y, csgo.color(145, 187, 255, 0), csgo.color(145, 187, 255, math.ceil(data.alpha)), true);
        render:rect_fade(0, screen.y - screen.y * 0.25, screen.x, screen.y, csgo.color(145, 187, 255, 0), csgo.color(145, 187, 255, math.ceil(data.alpha)), false);

        local factor = 100.0 * global_vars.frametime;
        data.alpha = data.alpha - factor;
    end
end

callbacks:add('paint', on_paint);
callbacks:add('events', on_event);