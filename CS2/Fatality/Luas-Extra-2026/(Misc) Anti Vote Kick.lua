local game_events = csgo.interface_handler:get_events( );
local engine_client = csgo.interface_handler:get_engine_client( );
local entity_list = csgo.interface_handler:get_entity_list( );
local global_vars = csgo.interface_handler:get_global_vars( );

local kick_command_id = 1;
local kick_potential_votes = 0;
local kick_yes_voters = 0;
local kick_getting_kicked = false;
local kick_last_command_time = global_vars.curtime;

function event( e )
    local local_player = entity_list:get_localplayer( );
    if ( local_player == nil ) then
        return end
    local_index = local_player:get_index( );

    if ( e:get_name( ) == "game_start" ) then
        kick_last_command_time = nil;
        return;
    end

    if ( e:get_name( ) == "vote_changed" ) then
        kick_potential_votes = e:get_int( "potentialVotes");
        return;
    end

    if ( e:get_name( ) == "vote_cast" ) then
        local vote_option = e:get_int( "vote_option" );
        local voter_id = e:get_int( 'entityid' );

        if ( local_index ~= voter_id and vote_option == 0 ) then
            kick_yes_voters = kick_yes_voters + 1;
        end
        if ( local_index == voter_id and vote_option == 1 ) then
            kick_getting_kicked = true;
            kick_yes_voters = 1;
        end
        if ( kick_getting_kicked == false ) then
            return;
        end
        local kick_percentage = ( ( kick_yes_voters - 1 ) / ( kick_potential_votes / 2 ) * 100 );
        if ( kick_yes_voters > 0 and kick_potential_votes > 0 and kick_percentage >= 80 and ( kick_last_command_time == nil or global_vars.curtime - kick_last_command_time > 120 ) ) then
            if ( kick_command_id == 1 ) then
                engine_client:client_cmd( "callvote SwapTeams" );
                kick_command_id = 2;
            elseif ( kick_command_id == 2 ) then
                engine_client:client_cmd( "callvote ScrambleTeams" );
                kick_command_id = 3;
            elseif ( kick_command_id == 3 ) then
                engine_client:client_cmd( "callvote ChangeLevel " .. engine_client:get_map_name( ) );
                kick_command_id = 1;
            end

            kick_last_command_time = global_vars.curtime;
     
        end
    end
end

game_events:add_event( "vote_cast" );
game_events:add_event( "vote_changed" );
game_events:add_event( "game_start" );

local callbacks = fatality.callbacks;
callbacks:add( "events", event );