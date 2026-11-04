local chat = require("chat")
local hitgroup_names = {"通用", "头部", "胸部", "胃部", "左臂", "右臂", "左腿", "右腿", "脖子", "?", "脚趾"}
local TextColors = {"{white}", "{darkred}", "{team}", "{green}", "{lightgreen}", "{lime}", "{red}", "{grey}", "{yellow}", "{bluegrey}", "{blue}", "{darkblue}", "{purple}", "{violet}", "{lightred}", "{orange}"}
local textbox = gui.add_textbox("Log Prefix", "LUA>TAB A")
local Prefixcolr = gui.add_combo("Prefix color", "LUA>TAB A", {"white", "darkred", "team", "green" ,"lightgreen" , "lime", "red", "grey", "yellow", "bluegrey", "blue", "darkblue", "purple", "violet", "lightred", "orange"})
local textclr = gui.add_combo("Text Color", "LUA>TAB A", {"white", "darkred", "team", "green" ,"lightgreen" , "lime", "red", "grey", "yellow", "bluegrey", "blue", "darkblue", "purple", "violet", "lightred", "orange"})
local misscolor = gui.add_combo("Miss Color", "LUA>TAB A", {"white", "darkred", "team", "green" ,"lightgreen" , "lime", "red", "grey", "yellow", "bluegrey", "blue", "darkblue", "purple", "violet", "lightred", "orange"})
function on_shot_registered(shot)
    if shot.manual then return end
    local p = entities.get_entity(shot.target)
    local n = p:get_player_info()
    local hitgroup = shot.server_hitgroup
    local health = p:get_prop("m_iHealth")
    local Prefix = textbox:get_string()
    local Colors = {gui.get_combo_items("LUA>TAB A>Prefix color")}
    local precolr = Prefixcolr:get_int()
    local txtclr = textclr:get_int()
    local Missclr = misscolor:get_int()
    if shot.server_damage > 0 then
        chat.print( TextColors[txtclr + 1],"[", TextColors[precolr + 1], string.len(Prefix) ~= 0 and Prefix or "死亡",TextColors[txtclr + 1] ,"]: 击中 " , n.name  , " 的 ", hitgroup_names[hitgroup + 1]," 打掉 " , shot.server_damage, "血 ( 剩余血量: ", health, " )")
    else
        chat.print( TextColors[txtclr + 1],"[", TextColors[precolr + 1], string.len(Prefix) ~= 0 and Prefix or "死亡",TextColors[txtclr + 1] ,"]: 没击中 " , n.name  , " 因为 ", TextColors[Missclr + 1], shot.result)
    end
end