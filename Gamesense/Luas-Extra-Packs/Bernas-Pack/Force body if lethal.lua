local force_baim = ui.new_checkbox("RAGE", "Other", "Force body aim if lethal")

local enabled_weapons = ui.new_multiselect("RAGE", "Other", "Enabled weapons", {
    "Scout",
    "Awp",
    "Auto",
    "R8 revolver",
    "Deagle",
    "Other"
})

local weapons = require("gamesense/csgo_weapons")
local vector = require("vector")

-- Check multiselect
local function contains(tbl_ref, value)
    local selected = ui.get(tbl_ref)

    for i=1, #selected do
        if selected[i] == value then
            return true
        end
    end

    return false
end

-- Weapon whitelist
local function is_weapon_enabled(idx)
    if (idx == 38 or idx == 11) and contains(enabled_weapons, "Auto") then
        return true
    end

    if idx == 40 and contains(enabled_weapons, "Scout") then
        return true
    end

    if idx == 9 and contains(enabled_weapons, "Awp") then
        return true
    end

    if idx == 64 and contains(enabled_weapons, "R8 revolver") then
        return true
    end

    if idx == 1 and contains(enabled_weapons, "Deagle") then
        return true
    end

    if contains(enabled_weapons, "Other") then
        return true
    end

    return false
end

-- Lethal check
local function is_lethal(enemy)
    local me = entity.get_local_player()

    if not me or not entity.is_alive(me) then
        return false
    end

    if not entity.is_alive(enemy) then
        return false
    end

    local weapon_ent = entity.get_player_weapon(me)

    if not weapon_ent then
        return false
    end

    local weapon_idx = entity.get_prop(weapon_ent, "m_iItemDefinitionIndex")

    if not weapon_idx then
        return false
    end

    weapon_idx = bit.band(weapon_idx, 0xFFFF)

    local weapon_data = weapons[weapon_idx]

    if not weapon_data then
        return false
    end

    if not is_weapon_enabled(weapon_idx) then
        return false
    end

    if not ui.get(force_baim) then
        return false
    end

    local enemy_origin = vector(entity.get_prop(enemy, "m_vecOrigin"))
    local local_origin = vector(entity.get_prop(me, "m_vecOrigin"))

    local distance = enemy_origin:dist(local_origin)

    local health = entity.get_prop(enemy, "m_iHealth")
    local armor = entity.get_prop(enemy, "m_ArmorValue")

    -- damage calc
    local damage = weapon_data.damage * math.pow(weapon_data.range_modifier, distance * 0.002)

    local final_damage = damage

    if armor > 0 then
        final_damage = damage * weapon_data.armor_ratio * 0.5
    end

    return final_damage >= health
end

-- Force BAIM
client.set_event_callback("run_command", function()
    local enemies = entity.get_players(true)

    for i=1, #enemies do
        local enemy = enemies[i]

        plist.set(enemy, "Override prefer body aim",
            is_lethal(enemy) and "Force" or "-"
        )
    end
end)

-- ESP Flag
client.register_esp_flag("BAIM", 255, 20, 20, function(ent)
    return is_lethal(ent)
end)

client.log("[Force BAIM] Loaded successfully!")
