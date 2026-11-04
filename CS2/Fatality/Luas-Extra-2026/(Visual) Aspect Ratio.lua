local render = fatality.render
local config = fatality.config
local menu = fatality.menu
local cvar = csgo.interface_handler:get_cvar()
local r_aspectratio = cvar:find_var("r_aspectratio")

local function set_aspect_ratio(multiplier)
    local screen_width = render:screen_size().x
    local screen_height = render:screen_size().y

    local value = (screen_width * multiplier) / screen_height

    if multiplier == 1 then
        value = 0
    end
    
    r_aspectratio:set_float(value)
end

local function gcd(m, n)
    while m ~= 0 do
        m, n = math_fmod(n, m), m;
    end

    return n
end

-- Menu entries.
local aspect_ratio_item = config:add_item( "aspect_ratio", 0.0 )
local aspect_ratio_slider = menu:add_slider( "Aspect ratio", "visuals", "misc", "various", aspect_ratio_item, 1, 200, 1 )

-- Doing it every frame because there is currently no item value update callback, and I'm lazy. I'll fix this later.
function on_paint( )
    local aspect_ratio = aspect_ratio_item:get_float() * 0.01
    aspect_ratio = 2 - aspect_ratio

    set_aspect_ratio(aspect_ratio)
end

-- Register all callback functions that should be called
local callbacks = fatality.callbacks
callbacks:add( "paint", on_paint )