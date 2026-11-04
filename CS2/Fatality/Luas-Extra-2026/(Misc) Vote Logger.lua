local entity_list = csgo.interface_handler:get_entity_list()
local events = csgo.interface_handler:get_events()
local cvar = csgo.interface_handler:get_cvar()

local vote_options = {}

function on_event(e)
    if(e:get_name() == "vote_options") then
        vote_options = {}
        local count = e:get_int("count")
        for i = 0, count do
            vote_options[i] = e:get_string("option" .. (i + 1))
        end
    end
   
    if(e:get_name() == "vote_cast") then
        local player_name = (entity_list:get_player(e:get_int("entityid")):get_name())
        local vote_option = vote_options[e:get_int("vote_option")]
        cvar:print_console("[ VOTE ] ", csgo.color(0, 200, 255, 255))
        cvar:print_console(player_name .. " voted for " .. vote_option .. "\n", csgo.color(255, 255, 255, 200))
    end
end

local callbacks = fatality.callbacks

events:add_event("vote_options")
events:add_event("vote_cast")

callbacks:add("events", on_event)