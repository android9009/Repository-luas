--main instances
local render = fatality.render
local menu = fatality.menu
local config = fatality.config
local fatalMath = fatality.math
local input = fatality.input
local globalVars = csgo.interface_handler:get_global_vars()
local events = csgo.interface_handler:get_events()
local engine_client = csgo.interface_handler:get_engine_client()
local entity_list = csgo.interface_handler:get_entity_list()
local screen_size = render:screen_size()
local font = render:create_font( 'smallest pixel-7', 30, 1, true )


--[[  __  ___  _______ ____    ____ 
     |  |/  / |   ____|\   \  /   / 
     |  '  /  |  |__    \   \/   /  
     |    <   |   __|    \_    _/   
     |  .  \  |  |____     |  |     
     |__|\__\ |_______|    |__|     ]]
local key = 0x4F --O-- Change it here https://docs.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
--[[  __  ___  _______ ____    ____ 
     |  |/  / |   ____|\   \  /   / 
     |  '  /  |  |__    \   \/   /  
     |    <   |   __|    \_    _/   
     |  .  \  |  |____     |  |     
     |__|\__\ |_______|    |__|     ]]
                               

local cfgItems = {
    multiCombo = config:add_item( 'multiCombo', 0 ),
    --------------------------------------------------
    auto = config:add_item( 'autoMulti', 0 ),
    scout = config:add_item( 'scoutMulti', 0 ),
    awp = config:add_item( 'awpMulti', 0 ),
    pistol = config:add_item( 'pistolMulti', 0 ),
    hPistol = config:add_item( 'hPistolMulti', 0 ),
    other = config:add_item( 'otherMulti', 0 ),
    --------------------------------------------------
    autoMin = config:add_item( 'AutoMin', 0 ),
    scoutMin = config:add_item( 'scoutMin', 0 ),
    awpMin = config:add_item( 'awpMin', 0 ),
    pistolMin = config:add_item( 'pistolMin', 0 ),
    hPistolMin = config:add_item( 'hPistolMin', 0 ),
    otherMin = config:add_item( 'otherMin', 0 ),
    --------------------------------------------------
    glitch = config:add_item( 'glitchBackground', 1 ),

}
local menuItems = {
    multiCombo = menu:add_multi_combo( 'Weapon Min', 'rage', 'aimbot', 'aimbot', cfgItems.multiCombo ),
    menu:add_checkbox( 'Glitch', 'rage', 'aimbot', 'aimbot', cfgItems.glitch ),
    menu:add_slider( 'Auto', 'rage', 'aimbot', 'aimbot', cfgItems.autoMin, 0, 100, 1 ),
    menu:add_slider( 'Scout', 'rage', 'aimbot', 'aimbot', cfgItems.scoutMin, 0, 100, 1 ),
    menu:add_slider( 'Awp', 'rage', 'aimbot', 'aimbot', cfgItems.awpMin, 0, 100, 1 ),
    menu:add_slider( 'Pistol', 'rage', 'aimbot', 'aimbot', cfgItems.pistolMin, 0, 100, 1 ),
    menu:add_slider( 'hPistol', 'rage', 'aimbot', 'aimbot', cfgItems.hPistolMin, 0, 100, 1 ),
    menu:add_slider( 'Other', 'rage', 'aimbot', 'aimbot', cfgItems.otherMin, 0, 100, 1 ),
    
}

menuItems.multiCombo:add_item('Auto', cfgItems.auto)
menuItems.multiCombo:add_item('Scout', cfgItems.scout)
menuItems.multiCombo:add_item('Awp', cfgItems.awp)
menuItems.multiCombo:add_item('Pistol', cfgItems.pistol)
menuItems.multiCombo:add_item('hPistol', cfgItems.hPistol)
menuItems.multiCombo:add_item('Other', cfgItems.other)


local oldMin = {
    auto = config:get_weapon_setting('autosniper', 'mindmg'):get_int(),
    scout = config:get_weapon_setting('scout', 'mindmg'):get_int(),
    awp = config:get_weapon_setting('awp', 'mindmg'):get_int(),
    pistol = config:get_weapon_setting('pistol', 'mindmg'):get_int(),
    hPistol = config:get_weapon_setting('heavy_pistol', 'mindmg'):get_int(),
    other = config:get_weapon_setting('other', 'mindmg'):get_int(),

}

local funcVars = {
    --Do it like this with multiple variables so you can update your old min damage realtime
    --auto
    auto_held = false,
    auto_toggle = false,
    auto_change = false,
    --scout
    scout_held = false,
    scout_toggle = false,
    scout_change = false,
    --awp
    awp_held = false,
    awp_toggle = false,
    awp_change = false,
    --pistol
    pistol_held = false,
    pistol_toggle = false,
    pistol_change = false,
    --hPistol
    hPistol_held = false,
    hPistol_toggle = false,
    hPistol_change = false,
    --other
    other_held = false,
    other_toggle = false,
    other_change = false,
}

function getweapon(pEnt)
    if pEnt == nil then
        return end

    local weapon = csgo.interface_handler:get_entity_list():get_from_handle(pEnt:get_var_handle( "CBaseCombatCharacter->m_hActiveWeapon" ) )

    if weapon == nil then
        return end
    weapon = weapon:get_class_id()

    if weapon == 244 or weapon == 238 or weapon == 257 or weapon == 268  or weapon == 245 or weapon == 257 or weapon == 240 then
        weapon = 'pistol'
    elseif  weapon == 46 then
        weapon = 'heavy_pistol'
    elseif weapon == 266 then
        weapon = 'scout'
    elseif weapon == 260 or weapon == 241 then
        weapon = 'autosniper'
    elseif weapon == 232 then
        weapon = 'awp'
    elseif weapon == 107 or weapon == 34 or weapon == 155 or weapon == 96 or weapon == 99 or weapon == 112 or weapon == 47 then
        weapon = 'knife'
    else 
        weapon = 'other'
    end
    return weapon
end

function setMin(cfgItem, gun, table, oldMinimum, newMin, gunHeld, gunToggle, gunChange)
    local localPlayer = entity_list:get_localplayer()
    if localPlayer == nil then 
        return end
    local curWep = getweapon(localPlayer)
    if curWep == nil then 
        return end
    if not cfgItem then
        if not newMin == table[oldMinimum] then
            table[oldMinimum] = config:get_weapon_setting(gun, 'mindmg'):get_int()
        end
        funcVars[gunHeld] = true
    return end
    if curWep ~= gun then
        funcVars[gunHeld] = true
        return end

    if input:is_key_down(key) then
        if not funcVars[gunHeld] then
            funcVars[gunToggle] = not funcVars[gunToggle]
            funcVars[gunHeld] = true
        end
    else       
        funcVars[gunHeld] = false
    end


    if funcVars[gunToggle] then
        config:get_weapon_setting(gun, 'mindmg'):set_int(newMin)
        funcVars[gunChange] = false
    else
        if not funcVars[gunChange] then
            config:get_weapon_setting(gun, 'mindmg'):set_int(table[oldMinimum])
            funcVars[gunChange] = true
        else
            table[oldMinimum] = config:get_weapon_setting(gun, 'mindmg'):get_int()
        end
    end
end
local pos = csgo.vector2(10,675)

local glitch = {
    glitch = csgo.vector2(10,675),
    realtime = globalVars.realtime,
    bool = true,
    range = 3,
}

function updateGlitch()
    if glitch.realtime + 0.08 > globalVars.realtime then
        if glitch.bool then
            glitch.glitch = csgo.vector2(math.random(pos.x - glitch.range, pos.x + glitch.range), math.random(pos.y - glitch.range, pos.y + glitch.range))
            glitch.bool = false
        end
    else
        glitch.bool = true
        glitch.realtime = globalVars.realtime
    end
end



function on_paint()

    if not engine_client:is_in_game() or entity_list:get_localplayer() == nil or not entity_list:get_localplayer():is_alive() then
        return end
    updateGlitch()
    setMin(cfgItems.auto:get_bool(), 'autosniper', oldMin, 'auto', cfgItems.autoMin:get_int(), 'auto_held', 'auto_toggle', 'auto_change')
    setMin(cfgItems.scout:get_bool(), 'scout', oldMin, 'scout', cfgItems.scoutMin:get_int(), 'scout_held', 'scout_toggle', 'scout_change')
    setMin(cfgItems.awp:get_bool(), 'awp', oldMin, 'awp', cfgItems.awpMin:get_int(), 'awp_held', 'awp_toggle', 'awp_change')
    setMin(cfgItems.pistol:get_bool(), 'pistol', oldMin, 'pistol', cfgItems.pistolMin:get_int(), 'pistol_held', 'pistol_toggle', 'pistol_change')
    setMin(cfgItems.hPistol:get_bool(), 'heavy_pistol', oldMin, 'hPistol', cfgItems.hPistolMin:get_int(), 'hPistol_held', 'hPistol_toggle', 'hPistol_change')
    setMin(cfgItems.other:get_bool(), 'other', oldMin, 'other', cfgItems.otherMin:get_int(), 'other_held', 'other_toggle', 'other_change')

    if getweapon(entity_list:get_localplayer()) == 'knife' then
        if cfgItems.glitch:get_bool() then
            render:text(font, glitch.glitch.x, glitch.glitch.y, 'No Minimum', csgo.color(255, 0, 238, 255))
        end
        render:text(font, pos.x, pos.y, 'No Minimum', csgo.color(255, 255, 255, 255))
    else
        if cfgItems.glitch:get_bool() then
            render:text(font, glitch.glitch.x, glitch.glitch.y, config:get_weapon_setting(getweapon(entity_list:get_localplayer()), 'mindmg'):get_int(), csgo.color(255, 0, 238, 255))
        end
        render:text(font, pos.x, pos.y, config:get_weapon_setting(getweapon(entity_list:get_localplayer()), 'mindmg'):get_int(), csgo.color(255, 255, 255, 255))
    end
end
fatality.callbacks:add('paint', on_paint)