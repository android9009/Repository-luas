-- USERINPUT
local pos_x = 20
local pos_y = 1000
local VK_LEFT = 0x5 -- left
local VK_RIGHT = 0x6 -- right

-- FATALITY INTERFACE
local menu = fatality.menu
local config = fatality.config
local render = fatality.render
local input = fatality.input

-- LUA CONFIG
local hollow_sync_config = config:add_item("holsync_gay", 0)
local hollow_sync_bool = menu:add_checkbox("HOLLOW: Enable", "RAGE", "ANTi-AIM", "General", hollow_sync_config)

local fakelag_enable_config = config:add_item("holsync_fakelag", 0)
local fakelag_enable = menu:add_checkbox("HOLLOW: Enable Fakelag", "RAGE", "ANTi-AIM", "General", fakelag_enable_config)

-- FATALITY CONFIG
local fl_standing = menu:get_reference("RAGE", "ANTI-AIM", "Standing", "Base amount")
local fake_amount_standing = menu:get_reference("RAGE", "ANTI-AIM", "Standing", "Fake amount")
local fake_freestanding = menu:get_reference("RAGE", "ANTI-AIM", "Standing", "Freestand fake")
local freestanding = menu:get_reference("RAGE", "ANTI-AIM", "Standing", "Freestand")
local faketype = menu:get_reference("RAGE", "ANTI-AIM", "Standing", "Fake type")
local fl_moving = menu:get_reference("RAGE", "ANTI-AIM", "Moving", "Base amount")
local fake_amount_moving = menu:get_reference("RAGE", "ANTI-AIM", "Moving", "Fake amount")
local fake_freestanding_moving = menu:get_reference("RAGE", "ANTI-AIM", "Moving", "Freestand fake")
local freestanding_moving = menu:get_reference("RAGE", "ANTI-AIM", "Moving", "Freestand")
local faketype_moving = menu:get_reference("RAGE", "ANTI-AIM", "Moving", "Fake type")
local manual_left = menu:get_reference("RAGE", "ANTI-AIM", "General", "Left")
local manual_right = menu:get_reference("RAGE", "ANTI-AIM", "General", "Right")
local manual_back = menu:get_reference("RAGE", "ANTI-AIM", "General", "Back")
local jitter_bool = menu:get_reference("RAGE", "ANTI-AIM", "Standing", "Jitter")

-- ORIGINAL FATALITY CONFIG VALUES
local o_faketype = faketype:get_int()
local o_fake_amount_standing = fake_amount_standing:get_float()
local o_fake_freestanding = fake_freestanding:get_bool()
local o_freestanding = freestanding:get_bool()
local o_fl_standing = fl_standing:get_float()
local o_manual_right = manual_right:get_bool()
local o_manual_left = manual_left:get_bool()
local o_manual_back = manual_back:get_bool()

local o_faketype_moving = faketype_moving:get_int()
local o_fake_amount_moving = fake_amount_moving:get_float()
local o_fake_freestanding_moving = fake_freestanding_moving:get_bool()
local o_freestanding_moving = freestanding_moving:get_bool()
local o_fl_moving = fl_moving:get_float()

-- credits to eslipe

-- font colors
local white = csgo.color(255,255,255,255)
local black = csgo.color(0,0,0,255)
local neon = csgo.color(0,234,255,255)
local red = csgo.color(255,0,0,255)
local lime = csgo.color(149,255,0,255)

--< Fonts >--
local font_regular = render:create_font("Verdana", 25, 800, false)

--< A function to draw text with flags >--
function draw_custom_text(font, x, y, text, flags, text_color, outline_color)
  -- Enables outline flag (outline for text)
  if (flags == "OUTLINE_LIGHT") then
    render:text(font, x + 1, y + 1, text, outline_color)
    render:text(font, x - 1, y - 1, text, outline_color)
    render:text(font, x + 1, y - 1, text, outline_color)
    render:text(font, x - 1, y + 1, text, outline_color)
    render:text(font, x, y, text, text_color)
  elseif (flags == "OUTLINE_BOLD") then
    render:text(font, x + 2, y + 2, text, outline_color)
    render:text(font, x - 2, y - 2, text, outline_color)
    render:text(font, x - 2, y + 2, text, outline_color)
    render:text(font, x + 2, y - 2, text, outline_color)
    render:text(font, x, y, text, text_color)
    -- Enables dropshadow flag (shadow for text)
  elseif (flags == "SHADOW_LIGHT") then
    render:text(font, x + 1, y + 1, text, outline_color)
    render:text(font, x, y, text, text_color)
  elseif (flags == "SHADOW_BOLD") then
    render:text(font, x + 2, y + 2, text, outline_color)
    render:text(font, x, y, text, text_color)
    -- Disables all flags (ordinary text)
  elseif (flags == "" or "none") then
    render:text(font, x, y, text, text_color)
  end
end

-- CALLBACK DEFINITIONS
local loop = false
local refreshed_config = false
local right = false

-- CALLBACK
fatality.callbacks:add("paint", function()
    -- DRAW LABEL
    draw_custom_text(font_regular, pos_x, pos_y, hollow_sync_config:get_bool() == true and "HSYNC: ON" or "HSYNC: OFF", "SHADOW_LIGHT", hollow_sync_config:get_bool() == true and neon or white, black)

    -- CONFIG TOGGLE
    if (hollow_sync_config:get_bool()) then
        refreshed_config = false
        loop = not loop

        -- KEY INPUTS
        if (input:is_key_pressed(VK_LEFT)) then
            right = false;
        elseif (input:is_key_pressed(VK_RIGHT)) then
            right = true;
        end

        -- FAKELAG TOGGLE
        if (fakelag_enable_config:get_bool()) then
            draw_custom_text(font_regular, pos_x + 1, pos_y - 45, "FL", "SHADOW_LIGHT", lime, black)
            fl_standing:set_float(14)
            fl_moving:set_float(14)
        else
            fl_standing:set_float(1)
            fl_moving:set_float(1)
        end

      

        -- AA DIRECTION / HOLLOWSYNC
        if (right == true) then
            -- LABEL
            draw_custom_text(font_regular, pos_x + 1, pos_y - 25, "RIGHT", "SHADOW_LIGHT", red, black)

            -- RIGHT
            if (loop) then
                faketype:set_int(1)
                faketype_moving:set_int(1)
                fake_amount_standing:set_float(360)
                fake_amount_moving:set_float(360)
                manual_left:set_bool(true)
            else
                faketype:set_int(2)
                faketype_moving:set_int(2)
                fake_amount_standing:set_float(-360)
                fake_amount_moving:set_float(-360)
                manual_right:set_bool(true)
                manual_back:set_bool(true)
            end
        else
            -- LABEL
            draw_custom_text(font_regular, pos_x + 1, pos_y - 25, "LEFT", "SHADOW_LIGHT", red, black)

            -- LEFT
            if (loop) then
                faketype:set_int(1)
                faketype_moving:set_int(1)
                fake_amount_standing:set_float(260)
                fake_amount_moving:set_float(260)
                manual_left:set_bool(true)
            else
                faketype:set_int(2)
                faketype_moving:set_int(2)
                fake_amount_standing:set_float(-260)
                fake_amount_moving:set_float(-260)
                manual_right:set_bool(true)
                manual_back:set_bool(true)
            end
        end
    else
        if (refreshed_config == false) then
            refreshed_config = true
            faketype:set_int(o_faketype)
            fake_amount_standing:set_float(o_fake_amount_standing)
            manual_right:set_bool(o_manual_right)
            manual_left:set_bool(o_manual_left)
            manual_back:set_bool(o_manual_back)
            fake_freestanding:get_bool(o_fake_freestanding)
            freestanding:set_bool(o_freestanding)
            fl_standing:set_float(o_fl_standing)

            faketype_moving:set_int(o_faketype_moving)
            fake_amount_moving:set_float(o_fake_amount_moving)
            fake_freestanding_moving:set_bool(o_fake_freestanding_moving)
            freestanding_moving:set_bool(o_freestanding_moving)
            fl_moving:set_float(o_fl_moving)
        end
    end
end)