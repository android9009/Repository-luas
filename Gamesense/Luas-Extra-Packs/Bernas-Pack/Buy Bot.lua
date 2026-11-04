client.log("Dev: bernas198")

local ui_get, ui_new_checkbox, ui_new_combobox, ui_new_multiselect, console_cmd = 
    ui.get, ui.new_checkbox, ui.new_combobox, ui.new_multiselect, client.exec

-- UI
local auto_buy_enabled = ui_new_checkbox("MISC", "Miscellaneous", "Auto Buy")
local primary_weapon = ui_new_combobox("MISC", "Miscellaneous", "Primary weapon", "None", "AWP", "SCOUT", "Auto Sniper")
local secondary_weapon = ui_new_combobox("MISC", "Miscellaneous", "Secondary weapon", "None", "Desert Eagle/Revolver", "Five Seven")
local extra_items = ui_new_multiselect("MISC", "Miscellaneous", "Extra items", 
    "Kevlar + Helmet", "Defuse Kit", "Tazer", "HE Grenade", "Smoke", "Molotov")


local weapon_map = {
    ["AWP"] = "buy awp;",
    ["SCOUT"] = "buy ssg08;",
    ["Auto Sniper"] = "buy g3sg1; buy scar20;", -- FIXED
    ["Desert Eagle/Revolver"] = "buy deagle; buy revolver;",
    ["Five Seven"] = "buy fiveseven;"
}

local extra_map = {
    ["Kevlar + Helmet"] = "buy vesthelm;",
    ["Defuse Kit"] = "buy defuser;",
    ["Tazer"] = "buy taser;",
    ["HE Grenade"] = "buy hegrenade;",
    ["Smoke"] = "buy smokegrenade;",
    ["Molotov"] = "buy molotov; buy incgrenade;"
}

local function build_buy()
    local cmds = {}

    table.insert(cmds, weapon_map[ui_get(primary_weapon)] or "")
    table.insert(cmds, weapon_map[ui_get(secondary_weapon)] or "")

    for _, item in ipairs(ui_get(extra_items) or {}) do
        table.insert(cmds, extra_map[item] or "")
    end

    return table.concat(cmds, " ")
end


local function do_buy()
    if not ui_get(auto_buy_enabled) then return end

    local cmd = build_buy()


    console_cmd(cmd)

 
    client.delay_call(0.3, function()
        console_cmd(cmd)
    end)


    client.delay_call(0.6, function()
        console_cmd(cmd)
    end)
end


client.set_event_callback("round_start", function()
    client.delay_call(0.1, do_buy)
end)
