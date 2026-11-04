--cool code starts here
local render = fatality.render
local config = fatality.config
local global_vars = csgo.interface_handler:get_global_vars( )
local menu = fatality.menu
local game_events = csgo.interface_handler:get_events( );

local hitboxes= {"Head","Chest","Stomach","Hand","Arm","Leg","Leg","Neck"};
local id=0
local font = render:create_font( "smallest pixel-7", 11, 100, true );
local aim_table = { }
local Elements = {
    palette = csgo.color(16, 22, 29, 160),

    table_size = 7,
  size_x = 300,
    size_y = 40


}

local entity_list = csgo.interface_handler:get_entity_list( )


function on_registered_shot( shot )
    local enemy = entity_list:get_player( shot.victim )

    local shot_info_t = shot.shot_info
    if enemy == nil then
        return
    end
    local nick = enemy:get_name( )
            local backtrack = shot_info_t.backtrack_ticks
            for i = Elements.table_size, 2, -1 do aim_table[i] = aim_table[i-1] end
  
              if backtrack==0 then
                backtrack = "broken rn"
              else
                backtrack = backtrack .. " Ticks"
              end
    local hit=0;
local rs = 0;
    local dmg=0;
    local hitgroup=0
    if shot.hurt then
        hit=1
        dmg=shot.hit_damage;
        hitgroup=shot.hit_hitgroup
rs="EZ Tap"
local colorr = 0,255,255
    elseif not shot.hurt and shot.hit then
        hit=0
        dmg="--"
        hitgroup=shot.target_hitgroup
    elseif not shot.hit then
        hit=-1
        dmg="-"
        hitgroup=shot.target_hitgroup
    end
if shot.hurt then
        hit=1
        dmg=shot.hit_damage;
        hitgroup=shot.hit_hitgroup
    elseif not shot.hurt and shot.hit then
        hit=0
        rs="Mucop  Resolver"
local colorr = 255,0,0
        hitgroup=shot.target_hitgroup
    elseif not shot.hit then
        hit=-1
        rs="Spread Issue"
local colorr = 255,0,0
        hitgroup=shot.target_hitgroup
    end

id=id+1;
  
            aim_table[1] = {
                ["id"] = id, ["hit"] = hit,
                ["player"] = string.sub(nick, 0, 14),
                ["dmg"] = dmg, ["bt"] = backtrack,
                ["box"] =hitboxes[ hitgroup],
                ["rs"] = rs
            }
  
      
end


local function drawTable( count, x, y, data)
    if data then
        local y = y + 4
        local pitch = x + 10
        local yaw = y + 15 + (count * 16)
        local r, g, b = 0, 0, 0
    
         if data.hit == 1 then
            r, g, b = 94, 230, 75

         elseif data.hit == 0 then
            r, g, b = 245, 127, 23
         else
             r, g, b = 118, 171, 255
        end
        render:rect_filled( x, yaw, 2, 15, csgo.color(r, g, b, 255))
        render:text(font, pitch - 3, yaw + 1,tostring(data.id), csgo.color(255, 255, 255, 255))
        render:text(font, pitch + 33, yaw + 1, tostring( data.player), csgo.color(255, 255, 255, 255))
        render:text(font, pitch + 116, yaw + 1,tostring(data.dmg), csgo.color(0, 255, 0, 255) )
        render:text(font, pitch + 153, yaw + 1, tostring( data.box),csgo.color(255, 255, 255, 255))
        render:text(font, pitch + 209, yaw + 1,tostring(data.bt), csgo.color(255, 255, 255, 255))
render:text(font, pitch + 271, yaw + 1,tostring(data.rs), csgo.color(209,228,34,255))
        return (count + 1)
    end
end
function  clear()
    id=0
    aim_table={}
end
menu:add_button( "Clear hit list", "visuals", "misc", "beams", clear )
function on_paint( )

    local x, y, d = Elements.size_x, Elements.size_y, 0



    local n = Elements.table_size
    local col_sz = 27 + (16 * (#aim_table > n and n or #aim_table))
  
    local width_s, nt = 0, { ["none"] = 0, ["predict"] = 0, ["breaking"] = 0, ["backtrack"] = 0 }

    local r = math.floor( math.sin( global_vars.realtime * 2) * 127 + 128 )
    local g =  math.floor( math.sin( global_vars.realtime * 2 + 2 ) * 127 + 128 )
    local b = math.floor( math.sin( global_vars.realtime * 2 + 4 ) * 127 + 128 );

    width_s = 380
    render:rect_filled( x, y, width_s, col_sz, csgo.color( 22, 20, 26, 100))
    render:rect_filled(x, y, width_s, 15, Elements.palette)
 render:rect_filled(x, y, width_s, 2, csgo.color(r,g,b, 160))
    render:text(font, x + 7, y + 3,"ID" ,csgo.color(255, 255, 255, 255))
    render:text(font, x + 8 + 35, y + 3,"PLAYER", csgo.color(255, 255, 255, 255))
    render:text(font, x + 7 + 114, y + 3, "DMG", csgo.color(255, 255, 255, 255))
    render:text(font, x + 10 + 153, y + 3, "HITBOX",csgo.color(255, 255, 255, 255))
    render:text(font, x + 10 + 201, y + 3, "BACKTRACK",csgo.color(255, 255, 255, 255))
   render:text(font, x + 10 + 271, y + 3, "REASON",csgo.color(255, 255, 255, 255))


    for i = 1, Elements.table_size, 1 do
        d = drawTable( d, x, y, aim_table[i])
   end
end 
function event( e )
    if ( e:get_name( ) == "round_start" ) then
        clear( );
    end
end
game_events:add_event( "round_start" );
local callbacks = fatality.callbacks
callbacks:add( "paint", on_paint )
callbacks:add( "registered_shot", on_registered_shot )
callbacks:add( "events", event );
--cool code ends here