local menu = fatality.menu
local input = fatality.input
local config = fatality.config

local key = 0x43 -- C Key
local menu_adn = "crimsync_"

--[[
    Key codes link:
    https://docs.microsoft.com/en-us/windows/desktop/inputdev/virtual-key-codes
]]

local cfg = {
    active = config:add_item(menu_adn .. "active", 0),
    inverted = config:add_item(menu_adn .. "inverted", 0),
    key_type = config:add_item(menu_adn .. "key_type", 1),

    ["standing"] = {
        bodylean = config:add_item(menu_adn .. "stand_blean", 55),
        bodylean_inv = config:add_item(menu_adn .. "stand_blean_inv", 55),
    },

    ["moving"] = {
        bodylean = config:add_item(menu_adn .. "moving_blean", 55),
        bodylean_inv = config:add_item(menu_adn .. "moving_blean_inv", 55),
    },

    ["air"] = {
        bodylean = config:add_item(menu_adn .. "air_blean", 55),
        bodylean_inv = config:add_item(menu_adn .. "air_blean_inv", 55),
    },
}

local m_items = {
    is_active = menu:add_checkbox("Fake angles", "RAGE", "ANTI-AIM", "General", cfg.active),
    key_type = menu:add_combo("Switch key type", "RAGE", "ANTI-AIM", "General", cfg.key_type),

    ["standing"] = {
        prototype = "standing",
        body_lean = menu:add_slider("Body lean (%)", "RAGE", "ANTI-AIM", "Standing", cfg.standing.bodylean, 0, 100, 55),
        body_lean_inv = menu:add_slider("Body lean inverted (%)", "RAGE", "ANTI-AIM", "Standing", cfg.standing.bodylean_inv, 0, 100, 55),

        add = menu:get_reference("RAGE", "ANTI-AIM", "Standing", "Yaw add"),
        add_val = menu:get_reference("RAGE", "ANTI-AIM", "Standing", "Add"),
        amount = menu:get_reference("RAGE", "ANTI-AIM", "Standing", "Fake amount"),
        type = menu:get_reference("RAGE", "ANTI-AIM", "Standing", "Fake type"),
        freestand = menu:get_reference("RAGE", "ANTI-AIM", "Standing", "Freestand"),
    },

    ["moving"] = {
        prototype = "moving",
        body_lean = menu:add_slider("Body lean (%)", "RAGE", "ANTI-AIM", "Moving", cfg.moving.bodylean, 0, 100, 55),
        body_lean_inv = menu:add_slider("Body lean inverted (%)", "RAGE", "ANTI-AIM", "Moving", cfg.moving.bodylean_inv, 0, 100, 55),

        add = menu:get_reference("RAGE", "ANTI-AIM", "Moving", "Yaw add"),
        add_val = menu:get_reference("RAGE", "ANTI-AIM", "Moving", "Add"),
        amount = menu:get_reference("RAGE", "ANTI-AIM", "Moving", "Fake amount"),
        type = menu:get_reference("RAGE", "ANTI-AIM", "Moving", "Fake type"),
        freestand = menu:get_reference("RAGE", "ANTI-AIM", "Moving", "Freestand"),
    },

    ["air"] = {
        prototype = "air",
        body_lean = menu:add_slider("Body lean (%)", "RAGE", "ANTI-AIM", "Air", cfg.air.bodylean, 0, 100, 55),
        body_lean_inv = menu:add_slider("Body lean inverted (%)", "RAGE", "ANTI-AIM", "Air", cfg.air.bodylean_inv, 0, 100, 55),

        add = menu:get_reference("RAGE", "ANTI-AIM", "Air", "Yaw add"),
        add_val = menu:get_reference("RAGE", "ANTI-AIM", "Air", "Add"),
        amount = menu:get_reference("RAGE", "ANTI-AIM", "Air", "Fake amount"),
        type = menu:get_reference("RAGE", "ANTI-AIM", "Air", "Fake type"),
        freestand = menu:get_reference("RAGE", "ANTI-AIM", "Air", "Freestand"),
    },
}

m_items.key_type:add_item("Hold", cfg.key_type)
m_items.key_type:add_item("Toggle", cfg.key_type)

fatality.callbacks:add("paint", function()
    if cfg.key_type:get_int() == 0 then
        cfg.inverted:set_bool(input:is_key_down(key))
    else
        if input:is_key_pressed(key) then
            cfg.inverted:set_bool(not cfg.inverted:get_bool())
        end
    end

    if not cfg.active:get_bool() then
        return
    end

    local inverted = cfg.inverted:get_bool()
    local calculate_body_lean = function(inverted, data)
        local inflean = inverted and data[1] or data[2]
        local lean = 59 - (0.59 * inflean)
    
        return inverted and -lean or lean
    end

    for i in pairs(m_items) do
        local prototype = m_items[i].prototype

        if prototype ~= nil then
            m_items[i].add:set_bool(true)

            local body_lean = calculate_body_lean(inverted, {
                cfg[prototype].bodylean:get_int(),
                cfg[prototype].bodylean_inv:get_int()
            })

            m_items[i].add_val:set_float(body_lean)
            m_items[i].amount:set_float(inverted and 100 or -100)
            m_items[i].type:set_int(2)
            m_items[i].freestand:set_bool(false)
        end
    end
end)


Ëåãèòû:
Maf kWaXSxcni0F0
legit AJiDvzP6vF1P
feet L2zIXEulXK5v
Ìàô 0DAriMxo45Cd
Ôóëë ëåãèò ìàô- Y6ff0CPfgzGx

RAGE:
feet v3FEVL6S9Fy0
rage 7hC5MC8KsdCs
rage EPKvO6Wy1KeQ
rage UV2CPovfhIuh

Maf Ëåãèò- 0DAriMxo45Cd
Ôóëë ëåãèò- Y6ff0CPfgzGx 0DAriMxo45Cd
77MPDZRAqKv9
rMDuJ2OBpi5p
EPKvO6Wy1KeQ
EPKvO6Wy1KeQ - ðåéäæ
zwOHUpjCYrOT - ëåãèò
KjBUWtYlFSBj - ëåãèò2
GbfN5liC1bI7 - ëåãèò3
jbMh8vW1BgAR - ëåãèò(æîñêèé)
rW09BrUpckv8 - ìàô
jz47voWSFXq8 - ëåãèò4
rMDuJ2OBpi5p - ðàãå
kWaXScni0F0
Y6ff0CPfgzGx - ìàô
gOEsgnbdWZhU - rage cfg
0DAriMxo45Cd - õç