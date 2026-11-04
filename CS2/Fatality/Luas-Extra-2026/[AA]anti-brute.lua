local active_bruteforce = false
local jitteractive = gui.get_config_item('rage>anti-aim>angles>jitter')
local fakeamt = gui.get_config_item('rage>anti-aim>desync>fake amount')
local fsfake = gui.get_config_item('rage>anti-aim>desync>freestand fake')
local lastfs = fsfake:get_int()
local lastjitter = jitteractive:get_bool()
local brute_timer = utils.new_timer(5000, function()
    active_buretforce = false
end)


local function flip_desync(dist) --flip func
    brute_timer:set_delay(5000)
    if not brute_timer:is_active() then
        brute_timer:start()
    end

    active_buretforce = true
    if dist < 0 then
        fakeamt:set_int(100)
    else
        fakeamt:set_int(-100)
    end
end

local fcount = global_vars.framecount
function on_game_event(event)--bullet calculations
    if event:get_name() == "bullet_impact" and fcount + 30 <= global_vars.framecount then
        
        local person = entities.get_entity(engine.get_player_for_user_id(event:get_int("userid")))
        local lp = entities.get_entity(engine.get_local_player())
        if not person or not lp or not lp:is_alive() or lp:get_index() == person:get_index() then return end
     
        local x = event:get_int("x")
        local y = event:get_int("y")
        local z = event:get_int("z")
        local endpos = math.vec3(x, y, z)
     
        local startpos = math.vec3(person:get_eye_position())
        local localpos = math.vec3(lp:get_eye_position())
     
        local headang = startpos:calc_angle(localpos)
        local shotang = startpos:calc_angle(endpos)
     
        dist = math.vec3((headang.x - shotang.x), (headang.y - shotang.y))
        posdist = math.vec3((headang.x - shotang.x), (headang.y - shotang.y))
     
        if posdist.y < 0 then posdist.y = posdist.y * -1 end
        if posdist.y <= 8 and dist.x < 1.5 then
            flip_desync(dist.y)
            fcount = global_vars.framecount
        end
    end
end

function on_player_hurt(event) --just incase
    if fcount + 30 <= global_vars.framecount then
        
        local person = entities.get_entity(engine.get_player_for_user_id(event:get_int("userid")))
        local lp = entities.get_entity(engine.get_local_player())
        if not person or not lp or not lp:is_alive() then return end
        if lp:get_index() == person:get_index() then
            flip_desync(fakeamt:get_int())
            fcount = global_vars.framecount
        end
    end
end


local switcher = false
function on_create_move(cmd)
    if not active_buretforce then
        if switcher then
            jitteractive:set_bool(lastjitter)
            fsfake:set_int(lastfs)
            switcher = false
        end
    else
        if not switcher then
            lastjitter = jitteractive:get_bool()
            lastfs = fsfake:get_int()
            switcher = true
        end
 
        jitteractive:set_bool(false)
        fsfake:set_int(0)
    end
end