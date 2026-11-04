

--lua ver v1.1 have fun using it when theres a issue just tell me here kiraw#2412 
--this is like my first real lua wich im making on my own so yea not that much expirence hope its still usable hf ^^


--lua ref
local player_state = gui.add_combo("condition", "lua>tab a", {"none", "standing","moving", "slowwalking","in air","crouching"})

    --cheat ref
local yaw_add_check = gui.get_config_item("Rage>Anti-Aim>Angles>Yaw Add")
local yaw_add = gui.get_config_item("Rage>Anti-Aim>Angles>Add")
local fake = gui.get_config_item("Rage>Anti-Aim>Desync>Fake amount")
local comp_angle = gui.get_config_item("Rage>Anti-Aim>Desync>Compensate angle")
local roll_mode_menu = gui.get_config_item("Rage>Anti-Aim>Desync>Roll lean")
local roll_amount_menu = gui.get_config_item("Rage>Anti-Aim>Desync>Lean amount")
local jitter_menu = gui.get_config_item("Rage>Anti-Aim>Angles>Jitter")
local jitter_range = gui.get_config_item("Rage>Anti-Aim>Angles>Jitter range")
local sw_key = gui.get_config_item("Misc>Movement>Slide")
local crouching = input.is_key_down(0x11)
local flip_fake = gui.get_config_item("Rage>Anti-Aim>Desync>Flip fake with jitter")

--crouching
local crouchkey = gui.add_checkbox("crouch key", "lua>tab a")
gui.add_keybind("lua>tab a>crouch key")
local yaw_add_crouching_check = gui.add_checkbox("[crouching] yaw add", "lua>tab a")
local yaw_add_amount_crouching = gui.add_slider("[crouching] yaw amount", "lua>tab a", -180, 180, 1)
local jitter_crouching_check = gui.add_checkbox("[crouching] jitter", "lua>tab a")
local jitter_amount_crouching = gui.add_slider("[crouching] jitter amount", "lua>tab a", 0, 360, 1)
local desync_amount_crouching = gui.add_slider("[crouching] desync amount", "lua>tab a", -100, 100, 1)
local comp_angle_crouching = gui.add_slider("[crouching] comp angle amount", "lua>tab a", 0, 100, 0)
local roll_crouching = gui.add_combo("[crouching] roll.mode", "lua>tab b", {"None","Static", "Extend fake", "freestand","freestand opposite","jitter", "invert fake"})
local roll_amount_crouching = gui.add_slider("[crouching] roll amount", "lua>tab b", -100, 100, 1)
local flip_fake_crouching = gui.add_checkbox("[crouching] flip fake", "lua>tab b")




--standing

local yaw_add_standing_check = gui.add_checkbox("[standing] yaw add", "lua>tab a")
local yaw_add_amount_standing = gui.add_slider("[standing] yaw amount", "lua>tab a", -180, 180, 1)
local jitter_standing_check = gui.add_checkbox("[standing] jitter", "lua>tab a")
local jitter_amount_standing = gui.add_slider("[standing] jitter amount", "lua>tab a", 0, 360, 1)
local desync_amount_standing = gui.add_slider("[standing] desync amount", "lua>tab a", -100, 100, 1)
local comp_angle_standing = gui.add_slider("[standing] comp angle amount", "lua>tab a", 0, 100, 0)
local roll_standing = gui.add_combo("[standing] roll.mode", "lua>tab b", {"None","Static", "Extend fake", "freestand","freestand opposite","jitter", "invert fake"})
local roll_amount_standing = gui.add_slider("[standing] roll amount", "lua>tab b", -50, 50, 1)
local flip_fake_standing = gui.add_checkbox("[standing] flip fake", "lua>tab b")
--moving--

local yaw_add_moving_check = gui.add_checkbox("[moving] yaw add", "lua>tab a")
local yaw_add_amount_moving = gui.add_slider("[moving] yaw amount", "lua>tab a", -180, 180, 1)
local jitter_moving_check = gui.add_checkbox("[moving] jitter", "lua>tab a")
local jitter_amount_moving = gui.add_slider("[moving] jitter amount", "lua>tab a", 0, 360, 1)
local desync_amount_moving = gui.add_slider("[moving] desync amount", "lua>tab a", -100, 100, 1)
local comp_angle_moving = gui.add_slider("[moving] comp angle amount", "lua>tab a", 0, 100, 0)
local roll_moving = gui.add_combo("[moving] roll.mode", "lua>tab b", {"None","Static", "Extend fake", "freestand","freestand opposite","jitter", "invert fake"})
local roll_amount_moving = gui.add_slider("[moving] roll amount", "lua>tab b", -100, 100, 1)
local flip_fake_moving = gui.add_checkbox("[moving] flip fake", "lua>tab b")
-- slowwalking

local yaw_add_slowwalking_check = gui.add_checkbox("[slowwalking] yaw add", "lua>tab a")
local yaw_add_amount_slowwalking = gui.add_slider("[slowwalking] yaw amount", "lua>tab a", -180, 180, 1)
local jitter_slowwalking_check = gui.add_checkbox("[slowwalking] jitter", "lua>tab a")
local jitter_amount_slowwalking = gui.add_slider("[slowwalking] jitter amount", "lua>tab a", 0, 360, 1)
local desync_amount_slowwalking = gui.add_slider("[slowwalking] desync amount", "lua>tab a", -100, 100, 1)
local comp_angle_slowwalking = gui.add_slider("[slowwalking] comp angle amount", "lua>tab a", 0, 100, 0)
local roll_slowwalking = gui.add_combo("[slowwalking] roll.mode", "lua>tab b", {"None","Static", "Extend fake", "freestand","freestand opposite","jitter", "invert fake"})
local roll_amount_slowwalking = gui.add_slider("[slowwalking] roll amount", "lua>tab b", -100, 100, 1)
local flip_fake_slowwalking = gui.add_checkbox("[slowwalking] flip fake", "lua>tab b")


--in air

local yaw_add_in_air_check = gui.add_checkbox("[in air] yaw add", "lua>tab a")
local yaw_add_amount_in_air = gui.add_slider("[in air] yaw amount", "lua>tab a", -180, 180, 1)
local jitter_in_air_check = gui.add_checkbox("[in air] jitter", "lua>tab a")
local jitter_amount_in_air = gui.add_slider("[in air] jitter amount", "lua>tab a", 0, 360, 1)
local desync_amount_in_air = gui.add_slider("[in air] desync amount", "lua>tab a", -100, 100, 1)
local comp_angle_in_air = gui.add_slider("[in air] comp angle amount", "lua>tab a", 0, 100, 0)
local roll_in_air = gui.add_combo("[in air] roll.mode", "lua>tab b", {"None","Static", "Extend fake", "freestand","freestand opposite","jitter", "invert fake"})
local roll_amount_in_air = gui.add_slider("[in air] roll amount", "lua>tab b", -100, 100, 1)
local flip_fake_in_air = gui.add_checkbox("[in air] flip fake", "lua>tab b")


--misc-- 
local default_cfg = gui.add_checkbox("set default config", "lua>tab b")


--menu function
function on_paint()

    local current_state = player_state:get_int()
	
if current_state == 0 then 

    gui.set_visible("lua>tab a>[crouching] yaw add", false)
    gui.set_visible("lua>tab a>[crouching] yaw amount", false)
    gui.set_visible("lua>tab a>[crouching] jitter", false)
    gui.set_visible("lua>tab a>[crouching] jitter amount", false)
    gui.set_visible("lua>tab a>[crouching] desync amount", false)
    gui.set_visible("lua>tab a>[crouching] comp angle amount", false)
    gui.set_visible("lua>tab b>[crouching] roll.mode", false)
    gui.set_visible("lua>tab b>[crouching] roll amount", false)
    gui.set_visible("lua>tab b>[crouching] flip fake", false)
    gui.set_visible("lua>tab a>crouch key",false)

    

    gui.set_visible("lua>tab a>[standing] yaw add", false)
    gui.set_visible("lua>tab a>[standing] yaw amount", false)
    gui.set_visible("lua>tab a>[standing] jitter", false)
    gui.set_visible("lua>tab a>[standing] jitter amount", false)
    gui.set_visible("lua>tab a>[standing] desync amount", false)
    gui.set_visible("lua>tab a>[standing] comp angle amount", false)
    gui.set_visible("lua>tab b>[standing] roll.mode", false)
    gui.set_visible("lua>tab b>[standing] roll amount", false)
    gui.set_visible("lua>tab b>[standing] flip fake", false)

    gui.set_visible("lua>tab a>[moving] yaw add", false)
    gui.set_visible("lua>tab a>[moving] yaw amount", false)
    gui.set_visible("lua>tab a>[moving] jitter", false)
    gui.set_visible("lua>tab a>[moving] jitter amount", false)
    gui.set_visible("lua>tab a>[moving] desync amount", false)
    gui.set_visible("lua>tab a>[moving] comp angle amount", false)
    gui.set_visible("lua>tab b>[moving] roll.mode", false)
    gui.set_visible("lua>tab b>[moving] roll amount", false)
    gui.set_visible("lua>tab b>[moving] flip fake", false)

    
    gui.set_visible("lua>tab a>[slowwalking] yaw add", false)
    gui.set_visible("lua>tab a>[slowwalking] yaw amount", false)
    gui.set_visible("lua>tab a>[slowwalking] jitter", false)
    gui.set_visible("lua>tab a>[slowwalking] jitter amount", false)
    gui.set_visible("lua>tab a>[slowwalking] desync amount", false)
    gui.set_visible("lua>tab a>[slowwalking] comp angle amount", false)
    gui.set_visible("lua>tab b>[slowwalking] roll.mode", false)
    gui.set_visible("lua>tab b>[slowwalking] roll amount", false)
    gui.set_visible("lua>tab b>[slowwalking] flip fake", false)


    gui.set_visible("lua>tab a>[in air] yaw add", false)
    gui.set_visible("lua>tab a>[in air] yaw amount", false)
    gui.set_visible("lua>tab a>[in air] jitter", false)
    gui.set_visible("lua>tab a>[in air] jitter amount", false)
    gui.set_visible("lua>tab a>[in air] desync amount", false)
    gui.set_visible("lua>tab a>[in air] comp angle amount", false)
    gui.set_visible("lua>tab b>[in air] roll.mode", false)
    gui.set_visible("lua>tab b>[in air] roll amount", false)
    gui.set_visible("lua>tab b>[in air] flip fake", false)


    
    
    
    
else if current_state == 1 then

    

        gui.set_visible("lua>tab a>[standing] yaw add", true)
        gui.set_visible("lua>tab a>[standing] yaw amount", true)
        gui.set_visible("lua>tab a>[standing] jitter", true)
        gui.set_visible("lua>tab a>[standing] jitter amount", true)
        gui.set_visible("lua>tab a>[standing] desync amount", true)
        gui.set_visible("lua>tab a>[standing] comp angle amount", true)
        gui.set_visible("lua>tab b>[standing] roll.mode", true)
        gui.set_visible("lua>tab b>[standing] roll amount", true)
        gui.set_visible("lua>tab b>[standing] flip fake", true)
        gui.set_visible("lua>tab a>crouch key",false)

        gui.set_visible("lua>tab a>[crouching] yaw add", false)
        gui.set_visible("lua>tab a>[crouching] yaw amount", false)
        gui.set_visible("lua>tab a>[crouching] jitter", false)
        gui.set_visible("lua>tab a>[crouching] jitter amount", false)
        gui.set_visible("lua>tab a>[crouching] desync amount", false)
        gui.set_visible("lua>tab a>[crouching] comp angle amount", false)
        gui.set_visible("lua>tab b>[crouching] roll.mode", false)
        gui.set_visible("lua>tab b>[crouching] roll amount", false)
        gui.set_visible("lua>tab b>[crouching] flip fake", false)


        gui.set_visible("lua>tab a>[moving] yaw add", false)
        gui.set_visible("lua>tab a>[moving] yaw amount", false)
        gui.set_visible("lua>tab a>[moving] jitter", false)
        gui.set_visible("lua>tab a>[moving] jitter amount", false)
        gui.set_visible("lua>tab a>[moving] desync amount", false)
        gui.set_visible("lua>tab a>[moving] comp angle amount", false)
        gui.set_visible("lua>tab b>[moving] roll.mode", false)
        gui.set_visible("lua>tab b>[moving] roll amount", false)
        gui.set_visible("lua>tab b>[moving] flip fake", false)


        
        gui.set_visible("lua>tab a>[slowwalking] yaw add", false)
        gui.set_visible("lua>tab a>[slowwalking] yaw amount", false)
        gui.set_visible("lua>tab a>[slowwalking] jitter", false)
        gui.set_visible("lua>tab a>[slowwalking] jitter amount", false)
        gui.set_visible("lua>tab a>[slowwalking] desync amount", false)
        gui.set_visible("lua>tab a>[slowwalking] comp angle amount", false)
        gui.set_visible("lua>tab b>[slowwalking] roll.mode", false)
        gui.set_visible("lua>tab b>[slowwalking] roll amount", false)
        gui.set_visible("lua>tab b>[slowwalking] flip fake", false)


        gui.set_visible("lua>tab a>[in air] yaw add", false)
        gui.set_visible("lua>tab a>[in air] yaw amount", false)
        gui.set_visible("lua>tab a>[in air] jitter", false)
        gui.set_visible("lua>tab a>[in air] jitter amount", false)
        gui.set_visible("lua>tab a>[in air] desync amount", false)
        gui.set_visible("lua>tab a>[in air] comp angle amount", false)
        gui.set_visible("lua>tab b>[in air] roll.mode", false)
        gui.set_visible("lua>tab b>[in air] roll amount", false)
        gui.set_visible("lua>tab b>[in air] flip fake", false)






    else if current_state == 2 then

     
        gui.set_visible("lua>tab a>[standing] yaw add", false)
        gui.set_visible("lua>tab a>[standing] yaw amount", false)
        gui.set_visible("lua>tab a>[standing] jitter", false)
        gui.set_visible("lua>tab a>[standing] jitter amount", false)
        gui.set_visible("lua>tab a>[standing] desync amount", false)
        gui.set_visible("lua>tab a>[standing] comp angle amount", false)
        gui.set_visible("lua>tab b>[standing] roll.mode", false)
        gui.set_visible("lua>tab b>[standing] roll amount", false)
        gui.set_visible("lua>tab b>[standing] flip fake", false)
        gui.set_visible("lua>tab a>crouch key",false)

        gui.set_visible("lua>tab a>[crouching] yaw add", false)
        gui.set_visible("lua>tab a>[crouching] yaw amount", false)
        gui.set_visible("lua>tab a>[crouching] jitter", false)
        gui.set_visible("lua>tab a>[crouching] jitter amount", false)
        gui.set_visible("lua>tab a>[crouching] desync amount", false)
        gui.set_visible("lua>tab a>[crouching] comp angle amount", false)
        gui.set_visible("lua>tab b>[crouching] roll.mode", false)
        gui.set_visible("lua>tab b>[crouching] roll amount", false)
        gui.set_visible("lua>tab b>[crouching] flip fake", false)


        gui.set_visible("lua>tab a>[slowwalking] yaw add", false)
        gui.set_visible("lua>tab a>[slowwalking] yaw amount", false)
        gui.set_visible("lua>tab a>[slowwalking] jitter", false)
        gui.set_visible("lua>tab a>[slowwalking] jitter amount", false)
        gui.set_visible("lua>tab a>[slowwalking] desync amount", false)
        gui.set_visible("lua>tab a>[slowwalking] comp angle amount", false)
        gui.set_visible("lua>tab b>[slowwalking] roll.mode", false)
        gui.set_visible("lua>tab b>[slowwalking] roll amount", false)
        gui.set_visible("lua>tab b>[slowwalking] flip fake", false)


        gui.set_visible("lua>tab a>[in air] yaw add", false)
        gui.set_visible("lua>tab a>[in air] yaw amount", false)
        gui.set_visible("lua>tab a>[in air] jitter", false)
        gui.set_visible("lua>tab a>[in air] jitter amount", false)
        gui.set_visible("lua>tab a>[in air] desync amount", false)
        gui.set_visible("lua>tab a>[in air] comp angle amount", false)
        gui.set_visible("lua>tab b>[in air] roll.mode", false)
        gui.set_visible("lua>tab b>[in air] roll amount", false)
        gui.set_visible("lua>tab b>[in air] flip fake", false)


        gui.set_visible("lua>tab a>[moving] yaw add", true)
        gui.set_visible("lua>tab a>[moving] yaw amount", true)
        gui.set_visible("lua>tab a>[moving] jitter", true)
        gui.set_visible("lua>tab a>[moving] jitter amount", true)
        gui.set_visible("lua>tab a>[moving] desync amount", true)
        gui.set_visible("lua>tab a>[moving] comp angle amount", true)
        gui.set_visible("lua>tab b>[moving] roll.mode", true)
        gui.set_visible("lua>tab b>[moving] roll amount", true)
        gui.set_visible("lua>tab b>[moving] flip fake", true)


    else if current_state == 3 then 
        
       

        gui.set_visible("lua>tab a>[standing] yaw add", false)
        gui.set_visible("lua>tab a>[standing] yaw amount", false)
        gui.set_visible("lua>tab a>[standing] jitter", false)
        gui.set_visible("lua>tab a>[standing] jitter amount", false)
        gui.set_visible("lua>tab a>[standing] desync amount", false)
        gui.set_visible("lua>tab a>[standing] comp angle amount", false)
        gui.set_visible("lua>tab b>[standing] roll.mode", false)
        gui.set_visible("lua>tab b>[standing] roll amount", false)
        gui.set_visible("lua>tab b>[standing] flip fake", false)
        gui.set_visible("lua>tab a>crouch key",false)

        gui.set_visible("lua>tab a>[crouching] yaw add", false)
        gui.set_visible("lua>tab a>[crouching] yaw amount", false)
        gui.set_visible("lua>tab a>[crouching] jitter", false)
        gui.set_visible("lua>tab a>[crouching] jitter amount", false)
        gui.set_visible("lua>tab a>[crouching] desync amount", false)
        gui.set_visible("lua>tab a>[crouching] comp angle amount", false)
        gui.set_visible("lua>tab b>[crouching] roll.mode", false)
        gui.set_visible("lua>tab b>[crouching] roll amount", false)
        gui.set_visible("lua>tab b>[crouching] flip fake", false)


        gui.set_visible("lua>tab a>[moving] yaw add", false)
        gui.set_visible("lua>tab a>[moving] yaw amount", false)
        gui.set_visible("lua>tab a>[moving] jitter", false)
        gui.set_visible("lua>tab a>[moving] jitter amount", false)
        gui.set_visible("lua>tab a>[moving] desync amount", false)
        gui.set_visible("lua>tab a>[moving] comp angle amount", false)
        gui.set_visible("lua>tab b>[moving] roll.mode", false)
        gui.set_visible("lua>tab b>[moving] roll amount", false)
        gui.set_visible("lua>tab b>[moving] flip fake", false)


        gui.set_visible("lua>tab a>[in air] yaw add", false)
        gui.set_visible("lua>tab a>[in air] yaw amount", false)
        gui.set_visible("lua>tab a>[in air] jitter", false)
        gui.set_visible("lua>tab a>[in air] jitter amount", false)
        gui.set_visible("lua>tab a>[in air] desync amount", false)
        gui.set_visible("lua>tab a>[in air] comp angle amount", false)
        gui.set_visible("lua>tab b>[in air] roll.mode", false)
        gui.set_visible("lua>tab b>[in air] roll amount", false)
        gui.set_visible("lua>tab b>[in air] flip fake", false)

        
        gui.set_visible("lua>tab a>[slowwalking] yaw add", true)
        gui.set_visible("lua>tab a>[slowwalking] yaw amount", true)
        gui.set_visible("lua>tab a>[slowwalking] jitter", true)
        gui.set_visible("lua>tab a>[slowwalking] jitter amount", true)
        gui.set_visible("lua>tab a>[slowwalking] desync amount", true)
        gui.set_visible("lua>tab a>[slowwalking] comp angle amount", true)
        gui.set_visible("lua>tab b>[slowwalking] roll.mode", true)
        gui.set_visible("lua>tab b>[slowwalking] roll amount", true)
        gui.set_visible("lua>tab b>[slowwalking] flip fake", true)



    else if current_state == 4 then 

    

        gui.set_visible("lua>tab a>[standing] yaw add", false)
        gui.set_visible("lua>tab a>[standing] yaw amount", false)
        gui.set_visible("lua>tab a>[standing] jitter", false)
        gui.set_visible("lua>tab a>[standing] jitter amount", false)
        gui.set_visible("lua>tab a>[standing] desync amount", false)
        gui.set_visible("lua>tab a>[standing] comp angle amount", false)
        gui.set_visible("lua>tab b>[standing] roll.mode", false)
        gui.set_visible("lua>tab b>[standing] roll amount", false)
        gui.set_visible("lua>tab b>[standing] flip fake", false)
    gui.set_visible("lua>tab a>crouch key",false)

        gui.set_visible("lua>tab a>[crouching] yaw add", false)
        gui.set_visible("lua>tab a>[crouching] yaw amount", false)
        gui.set_visible("lua>tab a>[crouching] jitter", false)
        gui.set_visible("lua>tab a>[crouching] jitter amount", false)
        gui.set_visible("lua>tab a>[crouching] desync amount", false)
        gui.set_visible("lua>tab a>[crouching] comp angle amount", false)
        gui.set_visible("lua>tab b>[crouching] roll.mode", false)
        gui.set_visible("lua>tab b>[crouching] roll amount", false)
        gui.set_visible("lua>tab b>[crouching] flip fake", false)


        gui.set_visible("lua>tab a>[moving] yaw add", false)
        gui.set_visible("lua>tab a>[moving] yaw amount", false)
        gui.set_visible("lua>tab a>[moving] jitter", false)
        gui.set_visible("lua>tab a>[moving] jitter amount", false)
        gui.set_visible("lua>tab a>[moving] desync amount", false)
        gui.set_visible("lua>tab a>[moving] comp angle amount", false)
        gui.set_visible("lua>tab b>[moving] roll.mode", false)
        gui.set_visible("lua>tab b>[moving] roll amount", false)
        gui.set_visible("lua>tab b>[moving] flip fake", false)


        
        gui.set_visible("lua>tab a>[slowwalking] yaw add", false)
        gui.set_visible("lua>tab a>[slowwalking] yaw amount", false)
        gui.set_visible("lua>tab a>[slowwalking] jitter", false)
        gui.set_visible("lua>tab a>[slowwalking] jitter amount", false)
        gui.set_visible("lua>tab a>[slowwalking] desync amount", false)
        gui.set_visible("lua>tab a>[slowwalking] comp angle amount", false)
        gui.set_visible("lua>tab b>[slowwalking] roll.mode", false)
        gui.set_visible("lua>tab b>[slowwalking] roll amount", false)
        gui.set_visible("lua>tab b>[slowwalking] flip fake", false)


        gui.set_visible("lua>tab a>[in air] yaw add", true)
        gui.set_visible("lua>tab a>[in air] yaw amount", true)
        gui.set_visible("lua>tab a>[in air] jitter", true)
        gui.set_visible("lua>tab a>[in air] jitter amount", true)
        gui.set_visible("lua>tab a>[in air] desync amount", true)
        gui.set_visible("lua>tab a>[in air] comp angle amount", true)
        gui.set_visible("lua>tab b>[in air] roll.mode", true)
        gui.set_visible("lua>tab b>[in air] roll amount", true)
        gui.set_visible("lua>tab b>[in air] flip fake", true)



    else if current_state == 5 then


        gui.set_visible("lua>tab a>[crouching] yaw add", true)
        gui.set_visible("lua>tab a>[crouching] yaw amount", true)
        gui.set_visible("lua>tab a>[crouching] jitter", true)
        gui.set_visible("lua>tab a>[crouching] jitter amount", true)
        gui.set_visible("lua>tab a>[crouching] desync amount", true)
        gui.set_visible("lua>tab a>[crouching] comp angle amount", true)
        gui.set_visible("lua>tab b>[crouching] roll.mode", true)
        gui.set_visible("lua>tab b>[crouching] roll amount", true)
        gui.set_visible("lua>tab b>[crouching] flip fake", true)
        gui.set_visible("lua>tab a>crouch key",true)
        
        gui.set_visible("lua>tab a>[standing] yaw add", false)
        gui.set_visible("lua>tab a>[standing] yaw amount", false)
        gui.set_visible("lua>tab a>[standing] jitter", false)
        gui.set_visible("lua>tab a>[standing] jitter amount", false)
        gui.set_visible("lua>tab a>[standing] desync amount", false)
        gui.set_visible("lua>tab a>[standing] comp angle amount", false)
        gui.set_visible("lua>tab b>[standing] roll.mode", false)
        gui.set_visible("lua>tab b>[standing] roll amount", false)
        gui.set_visible("lua>tab b>[standing] flip fake", false)
    
        gui.set_visible("lua>tab a>[moving] yaw add", false)
        gui.set_visible("lua>tab a>[moving] yaw amount", false)
        gui.set_visible("lua>tab a>[moving] jitter", false)
        gui.set_visible("lua>tab a>[moving] jitter amount", false)
        gui.set_visible("lua>tab a>[moving] desync amount", false)
        gui.set_visible("lua>tab a>[moving] comp angle amount", false)
        gui.set_visible("lua>tab b>[moving] roll.mode", false)
        gui.set_visible("lua>tab b>[moving] roll amount", false)
        gui.set_visible("lua>tab b>[moving] flip fake", false)
    
        
        gui.set_visible("lua>tab a>[slowwalking] yaw add", false)
        gui.set_visible("lua>tab a>[slowwalking] yaw amount", false)
        gui.set_visible("lua>tab a>[slowwalking] jitter", false)
        gui.set_visible("lua>tab a>[slowwalking] jitter amount", false)
        gui.set_visible("lua>tab a>[slowwalking] desync amount", false)
        gui.set_visible("lua>tab a>[slowwalking] comp angle amount", false)
        gui.set_visible("lua>tab b>[slowwalking] roll.mode", false)
        gui.set_visible("lua>tab b>[slowwalking] roll amount", false)
        gui.set_visible("lua>tab b>[slowwalking] flip fake", false)
    
    
        gui.set_visible("lua>tab a>[in air] yaw add", false)
        gui.set_visible("lua>tab a>[in air] yaw amount", false)
        gui.set_visible("lua>tab a>[in air] jitter", false)
        gui.set_visible("lua>tab a>[in air] jitter amount", false)
        gui.set_visible("lua>tab a>[in air] desync amount", false)
        gui.set_visible("lua>tab a>[in air] comp angle amount", false)
        gui.set_visible("lua>tab b>[in air] roll.mode", false)
        gui.set_visible("lua>tab b>[in air] roll amount", false)
        gui.set_visible("lua>tab b>[in air] flip fake", false)
    end
end
    end
    end



    end

--yaw menu func
    if yaw_add_standing_check:get_bool() and current_state == 1 then

        gui.set_visible("lua>tab a>[standing] yaw amount", true)

    else

        gui.set_visible("lua>tab a>[standing] yaw amount", false)
    end

    if yaw_add_crouching_check:get_bool() and current_state == 5 then

        gui.set_visible("lua>tab a>[crouching] yaw amount", true)

    else

        gui.set_visible("lua>tab a>[crouching] yaw amount", false)
    end

    if yaw_add_moving_check:get_bool() and current_state == 2 then

        gui.set_visible("lua>tab a>[moving] yaw amount", true)

    else

        gui.set_visible("lua>tab a>[moving] yaw amount", false)
    end

    if yaw_add_in_air_check:get_bool() and current_state == 4 then

        gui.set_visible("lua>tab a>[in air] yaw amount", true)

    else

        gui.set_visible("lua>tab a>[in air] yaw amount", false)
    end

    if yaw_add_slowwalking_check:get_bool() and current_state == 3 then

        gui.set_visible("lua>tab a>[slowwalking] yaw amount", true)

    else

        gui.set_visible("lua>tab a>[slowwalking] yaw amount", false)
    end

--end


--jitter menu func

if jitter_standing_check:get_bool() and current_state == 1 then

    gui.set_visible("lua>tab a>[standing] jitter amount", true)

else

    gui.set_visible("lua>tab a>[standing] jitter amount", false)
end

if jitter_crouching_check:get_bool() and current_state == 5 then

    gui.set_visible("lua>tab a>[crouching] jitter amount", true)

else

    gui.set_visible("lua>tab a>[crouching] jitter amount", false)
end

if jitter_moving_check:get_bool() and current_state == 2 then

    gui.set_visible("lua>tab a>[moving] jitter amount", true)

else

    gui.set_visible("lua>tab a>[moving] jitter amount", false)
end

if jitter_in_air_check:get_bool() and current_state == 4 then

    gui.set_visible("lua>tab a>[in air] jitter amount", true)

else

    gui.set_visible("lua>tab a>[in air] jitter amount", false)
end

if jitter_slowwalking_check:get_bool() and current_state == 3 then

    gui.set_visible("lua>tab a>[slowwalking] jitter amount", true)

else

    gui.set_visible("lua>tab a>[slowwalking] jitter amount", false)
end

    --end

end

--default cfg

if default_cfg:get_bool() then



    default_cfg:set_bool(false)

    yaw_add_check:set_bool(false)
yaw_add_amount_slowwalking:set_int(0)
desync_amount_slowwalking:set_int(-77)
jitter_amount_slowwalking:set_int(12)
jitter_slowwalking_check:set_bool(true)
comp_angle_slowwalking:set_int(79)
roll_slowwalking:set_int(0)
roll_amount_slowwalking:set_int(0)
flip_fake_slowwalking:set_bool(false)

yaw_add_in_air_check:set_bool(true)
yaw_add_amount_in_air:set_int(-8)
desync_amount_in_air:set_int(87)
jitter_amount_in_air:set_int(12)
jitter_in_air_check:set_bool(true)
comp_angle_in_air:set_int(90)
    roll_in_air:set_int(0)
 roll_amount_in_air:set_int(0)
 flip_fake_in_air:set_bool(true)

 yaw_add_standing_check:set_bool(true)
yaw_add_amount_standing:set_int(9)
 desync_amount_standing:set_int(36)
  jitter_amount_standing:set_int(21)
  jitter_standing_check:set_bool(true)
  comp_angle_standing:set_int(45)
 roll_standing:set_int(0)
  roll_amount_standing:set_int(0)
  flip_fake_standing:set_bool(false)

   yaw_add_moving_check:set_bool(true)
  yaw_add_amount_moving:set_int(-8)
    desync_amount_moving:set_int(-75)
  jitter_amount_moving:set_int(44)
   jitter_moving_check:set_bool(true)
   comp_angle_moving:set_int(82)
    roll_moving:set_int(0)
    roll_amount_moving:set_int(0)
    flip_fake_moving:set_int(0)

    yaw_add_crouching_check:set_bool(true)
    yaw_add_amount_crouching:set_int(9)
    desync_amount_crouching:set_int(-84)
   jitter_amount_crouching:set_int(15)
   jitter_crouching_check:set_bool(true)
    comp_angle_crouching:set_int(90)
    roll_crouching:set_int(0)
    roll_amount_crouching:set_int(0)
    flip_fake_crouching:set_bool(false)


    print("[AA Builder] default config has successfully been loaded")

end

end








function on_create_move()



    local isSW = sw_key:get_bool()
    local local_player = entities.get_entity(engine.get_local_player())
	local flag = local_player:get_prop("m_fFlags")
	local inAir = local_player:get_prop("m_hGroundEntity") == -1
	local vel_x = math.floor(local_player:get_prop("m_vecVelocity[0]"))
	local vel_y = math.floor(local_player:get_prop("m_vecVelocity[1]"))
	local speed = math.sqrt(vel_x ^ 2 + vel_y ^ 2)




--slowwalking
if isSW and not inAir and flag ~= 263 then

    yaw_add_check:set_int(yaw_add_slowwalking_check:get_int())
    yaw_add:set_int(yaw_add_amount_slowwalking:get_int())
    fake:set_int(desync_amount_slowwalking:get_int())
    jitter_range:set_int(jitter_amount_slowwalking:get_int())
    jitter_menu:set_bool(jitter_slowwalking_check:get_bool())
    comp_angle:set_int(comp_angle_slowwalking:get_int())
    roll_mode_menu:set_int(roll_slowwalking:get_int())
    roll_amount_menu:set_int(roll_amount_slowwalking:get_int())
    flip_fake:set_int(flip_fake_slowwalking:get_int())

    
    --in air

else if inAir and flag ~= 262 then
    
    yaw_add_check:set_int(yaw_add_in_air_check:get_int())
    yaw_add:set_int(yaw_add_amount_in_air:get_int())
    fake:set_int(desync_amount_in_air:get_int())
    jitter_range:set_int(jitter_amount_in_air:get_int())
    jitter_menu:set_bool(jitter_in_air_check:get_bool())
    comp_angle:set_int(comp_angle_in_air:get_int())
    roll_mode_menu:set_int(roll_in_air:get_int())
    roll_amount_menu:set_int(roll_amount_in_air:get_int())
    flip_fake:set_int(flip_fake_in_air:get_int())

    --standing

else if speed <= 2 and flag == 257 then

    yaw_add_check:set_int(yaw_add_standing_check:get_int())
    yaw_add:set_int(yaw_add_amount_standing:get_int())
    fake:set_int(desync_amount_standing:get_int())
    jitter_range:set_int(jitter_amount_standing:get_int())
    jitter_menu:set_bool(jitter_standing_check:get_bool())
    comp_angle:set_int(comp_angle_standing:get_int())
    roll_mode_menu:set_int(roll_standing:get_int())
    roll_amount_menu:set_int(roll_amount_standing:get_int())
    flip_fake:set_int(flip_fake_standing:get_int())

--moving

else if speed > 2 and not inAir and not crouchkey:get_bool() then

    yaw_add_check:set_int(yaw_add_moving_check:get_int())
    yaw_add:set_int(yaw_add_amount_moving:get_int())
    fake:set_int(desync_amount_moving:get_int())
    jitter_range:set_int(jitter_amount_moving:get_int())
    jitter_menu:set_bool(jitter_moving_check:get_bool())
    comp_angle:set_int(comp_angle_moving:get_int())
    roll_mode_menu:set_int(roll_moving:get_int())
    roll_amount_menu:set_int(roll_amount_moving:get_int())
    flip_fake:set_int(flip_fake_moving:get_int())
    


else if crouchkey:get_bool() then 

    yaw_add_check:set_int(yaw_add_crouching_check:get_int())
    yaw_add:set_int(yaw_add_amount_crouching:get_int())
    fake:set_int(desync_amount_crouching:get_int())
    jitter_range:set_int(jitter_amount_crouching:get_int())
    jitter_menu:set_bool(jitter_crouching_check:get_bool())
    comp_angle:set_int(comp_angle_crouching:get_int())
    roll_mode_menu:set_int(roll_crouching:get_int())
    roll_amount_menu:set_int(roll_amount_crouching:get_int())
    flip_fake:set_bool(flip_fake_crouching:get_bool())


else if flag == 262 then

    yaw_add_check:set_int(yaw_add_crouching_check:get_int())
    yaw_add:set_int(yaw_add_amount_crouching:get_int())
    fake:set_int(desync_amount_crouching:get_int())
    jitter_range:set_int(jitter_amount_crouching:get_int())
    jitter_menu:set_bool(jitter_crouching_check:get_bool())
    comp_angle:set_int(comp_angle_crouching:get_int())
    roll_mode_menu:set_int(roll_crouching:get_int())
    roll_amount_menu:set_int(roll_amount_crouching:get_int())
    flip_fake:set_bool(flip_fake_crouching:get_bool())

end






end
end
end
end
end
end



