


local font = render.create_font("c:/windows/fonts/verdana.ttf", 13, render.font_flag_shadow, 0, 2056)


local highlight = render.color(174, 196, 0, 230)

local shots = {}
local hitgroup = {
    [0] = "generic",
    [1] = "head",
    [2] = "chest",
    [3] = "stomach",
    [4] = "left arm",
    [5] = "right arm",
    [6] = "left leg",
    [7] = "right leg",
    [10] = "gear"
}

local logger = function(array, font, x, y, alpha, shift)
    local size = 0
    local step_size = 0

    for _, v in pairs(array) do -- calc total size
        size = size + render.get_text_size(font, v[1])
      
        if shift then size = size * (math.min(alpha, 150)/150) end
    end

    for _, v in pairs(array) do
        if v[2] then
            v[2].a = alpha
        end
    
        render.text(font, x - size / 2 + step_size, y, v[1], v[2] or render.color(255, 255, 255, alpha))
      
        step_size = step_size + render.get_text_size(font, v[1])
    end
end

function on_player_hurt(e)
    local a = e:get_int("attacker")
    local a_idx = engine.get_player_for_user_id(a)
  
    if a_idx ~= engine.get_local_player() then return end
  
    local u_name = engine.get_player_info( engine.get_player_for_user_id( e:get_int("userid") ) ).name
    
    shots[#shots + 1] = {
        text = {
            {"Hit "}, 
            {u_name, highlight}, 
            {" in the "}, 
            {hitgroup[e:get_int("hitgroup")], highlight}, 
            {" for "}, 
            {("%s dmg "):format(e:get_int("dmg_health"), e:get_int("dmg_armor")), highlight}, 
            {"with "},
            {e:get_string("weapon"):upper(), highlight},
        },
        a = 0,
        time = global_vars.realtime + 3
    }
end

function on_paint()
    local offset = 0

    for _, v in pairs(shots) do     
        if v.a <= 0 and global_vars.realtime > v.time and _ == #shots then
            shots[_] = nil
        end
      
        v.a = global_vars.realtime < v.time and math.min(v.a + 5, 255) or math.max(v.a - 5, 0)
        
        logger(v.text, font, 970, 655 + 15 * offset, v.a)
  
        offset = offset + math.min(v.a/40, 1)
    end
end
