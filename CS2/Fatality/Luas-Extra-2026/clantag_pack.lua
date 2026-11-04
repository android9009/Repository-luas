-- https://fatality.win/threads/clantag.4902/

-- Created by Autumn <3
require "clantag_api"
local menu = fatality.menu
local config = fatality.config
local callbacks = fatality.callbacks
-------------------------------------
local clantag = config:add_item("ClanTag", 0.0)
local clantag_combo = menu:add_combo("Clantag Selection", "Misc", "", "Movement", clantag)
local clantag_ref_combo = menu:get_reference("Misc", "", "Movement", "Clantag Selection")

-------------- Configuration --------------
-- To add a clantag use the format shown here
-- and go to line 257
--local clantag_NAME = config:add_item("Clantag_NAME", 0.0)
--clantag_combo:add_item("Clantag_NAME", clantag_NAME)

-- DO NOT DELETE

local clantag_none = config:add_item("Clantag_None", 1.0)
clantag_combo:add_item("None", clantag_none)
--------------------------------------------

-------------- ClanTags --------------

-- ev0lve
local clantag_ev0 = config:add_item("Clantag_Ev0", 0.0)
clantag_combo:add_item("Ev0lve", clantag_ev0)
local ev0_switch = 80
local ev0_mode = 1
local ev0_timing = ev0_switch
local ev0_clantag = {
    [1]  = function() return "           " end,
    [2]  = function() return "         e" end,
    [3]  = function() return "        ev" end,
    [4]  = function() return "       ev0" end,
    [5]  = function() return "      ev0l" end,
    [6]  = function() return "     ev0lv" end,
    [7]  = function() return "    ev0lve" end,
    [8]  = function() return "   ev0lve." end,
    [9]  = function() return "  ev0lve.x " end,
    [10] = function() return " ev0lve.xy " end,
    [11] = function() return " ev0lve.xyz " end,
    [12] = function() return " ev0lve.xyz " end,
    [13] = function() return " ev0lve.xyz " end,
    [14] = function() return " ev0lve.xyz " end,
    [15] = function() return " ev0lve.xyz " end,
    [16] = function() return " ev0lve.xyz " end,
    [17] = function() return " ev0lve.xyz " end,
    [18] = function() return " ev0lve.xyz " end,
    [19] = function() return " ev0lve.xyz " end,
    [20] = function() return " ev0lve.xyz " end,
    [21] = function() return " ev0lve.xyz " end,
    [22] = function() return " v0lve.xyz " end,
    [23] = function() return " 0lve.xyz " end,
    [24] = function() return " lve.xyz " end,
    [25] = function() return "ve.xyz   " end,
    [26] = function() return "e.xyz    " end,
    [27] = function() return ".xyz     " end,
    [28] = function() return "xyz      " end,
    [29] = function() return "yz       " end,
    [30] = function() return "z        " end,
}

-- Skeet (gamesense)
local clantag_skeet = config:add_item("Clantag_Skeet", 0.0)
clantag_combo:add_item("Skeet", clantag_skeet)
local skeet_switch = 50
local skeet_mode = 0
local skeet_timing = skeet_switch
local skeet_clantag = {
    [1] = function() return "" end,
    [2] = function() return "ga" end,
    [3] = function() return "gam" end,
    [4] = function() return "gam" end,
    [5] = function() return "game" end,
    [6] = function() return "game" end,
    [7] = function() return "games" end,
    [8] = function() return "games" end,
    [9] = function() return "gamese" end,
    [10] = function() return "gamese" end,
    [11] = function() return "gamesen" end,
    [12] = function() return "gamesen" end,
    [13] = function() return "gamesens" end,
    [14] = function() return "gamesens" end,
    [15] = function() return "gamesense" end,
    [16] = function() return "gamesense" end,
    [17] = function() return "gamesense" end,
    [18] = function() return "gamesense" end,
    [19] = function() return "gamesens" end,
    [20] = function() return "gamesen" end,
    [21] = function() return "gamese" end,
    [22] = function() return "games" end,
    [23] = function() return "game" end,
    [24] = function() return "gam" end,
    [25] = function() return "ga" end,
    [26] = function() return "" end,
}
-- Fatality
local clantag_fatal = config:add_item("Clantag_fatal", 0.0)
clantag_combo:add_item("Fatal", clantag_fatal)
local fatal_switch = 20
local fatal_mode = 0
local fatal_timing = fatal_switch
local fatal_clantag = {
    [1]  = function() return " [|]" end,
    [2]  = function() return " [$]" end,
    [3]  = function() return " [$|]" end,
    [4]  = function() return " [$t]" end,
    [5]  = function() return " [$t|]" end,
    [6]  = function() return " [$ta]" end,
    [7]  = function() return " [$ta|]" end,
    [8]  = function() return " [$tay]" end,
    [9]  = function() return " [$tay|] " end,
    [10] = function() return " [$tay F] " end,
    [11] = function() return " [$tay F|] " end,
    [12] = function() return " [$tay Fa] " end,
    [13] = function() return " [$tay Fa|] " end,
    [14] = function() return " [$tay Fat] " end,
    [15] = function() return " [$tay Fat|] " end,
    [16] = function() return " [$tay Fata] " end,
    [17] = function() return " [$tay Fata|] " end,
    [18] = function() return " [$tay Fatal] " end,
    [19] = function() return " [$tay Fatal] " end,
    [20] = function() return " [$tay Fatal]" end,
    [21] = function() return " [$tay Fatal] " end,
    [22] = function() return " [$tay Fata] " end,
    [23] = function() return " [$tay Fat] " end,
    [24] = function() return " [$tay Fa|] " end,
    [25] = function() return " [$tay F] " end,
    [26] = function() return " [$tay ] " end,
    [27] = function() return " [$ta] " end,
    [28] = function() return " [$t] " end,
    [29] = function() return " [$] " end,
    [30] = function() return " [] " end,
   
}


-- 911 Clantag
local clantag_twin = config:add_item("Clantag_twin", 0.0)
clantag_combo:add_item("911", clantag_twin)
local twin_switch = 25
local twin_mode = 0
local twin_timing = twin_switch
local twin_clantag = {
   
    [1] = function() return "✈__▌_▌" end,
    [2] = function() return "_✈_▌_▌" end,
    [3] = function() return "__✈▌_▌" end,
    [4] = function() return "___☠_▌" end,
    [5] = function() return "___☠✈▌" end,
    [6] = function() return "___☠_☠" end,
}

-- Not anxious
local clantag_notanxious = config:add_item("Clantag_notanxious", 0.0)
clantag_combo:add_item("NotAnxious", clantag_notanxious)
local function on_paint()
if clantag:get_int() == 0 then
    SET_CLANTAG_MADE_BY_DUCARII("")
    return
end
-- Ev0lve
if clantag:get_int() == 1 then
    ev0_timing = ev0_timing + 1
    if ev0_timing >= ev0_switch then
    ev0_mode = ev0_mode + 1
    if ev0_mode > #ev0_clantag then
    ev0_mode = 1
    end
    SET_CLANTAG_MADE_BY_DUCARII(ev0_clantag[ev0_mode]())
    ev0_timing = 1
    end
end
-- Skeet (Gamesense)
if clantag:get_int() == 2 then
    skeet_timing = skeet_timing + 1
    if skeet_timing >= skeet_switch then
        skeet_mode = skeet_mode + 1
        if skeet_mode > #skeet_clantag then
            skeet_mode = 1
        end
       
        SET_CLANTAG_MADE_BY_DUCARII(skeet_clantag[skeet_mode]())
        skeet_timing = 0
    end
end
-- Fatality (Better Ig?)
if clantag:get_int() == 3 then
    fatal_timing = fatal_timing + 1
    if fatal_timing >= fatal_switch then
        fatal_mode = fatal_mode + 1
        if fatal_mode > #fatal_clantag then
            fatal_mode = 1
        end
     
        SET_CLANTAG_MADE_BY_DUCARII(fatal_clantag[fatal_mode]())
        fatal_timing = 0
    end
end
-- 911
if clantag:get_int() == 4 then
    twin_timing = twin_timing + 1
    if twin_timing >= twin_switch then
        twin_mode = twin_mode + 1
        if twin_mode > #twin_clantag then
            twin_mode = 1
        end
     
        SET_CLANTAG_MADE_BY_DUCARII(twin_clantag[twin_mode]())
        twin_timing = 0
    end
end

if clantag:get_int() == 5 then
    SET_CLANTAG_MADE_BY_DUCARII("notanxious")
end
------- Custom Clantag -------
-- To add you clantag
-- Copy this example
-- * means the next number, since the last one above is 5 the next will be 6 etc.
-- If you would like a custom clantag please contact me on fatal forums UID: 6299
--  if clantag:get_int() == * then
--  SET_CLANTAG_MADE_BY_DUCARII("YOUR CLANTAG")
--  end


end

callbacks:add("paint", on_paint)