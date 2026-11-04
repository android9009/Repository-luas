print(",_____________________________________________________________________,")
print("|                                                                     |")
print("|                                                                     |")
print("|    HELL.YAW, cracked & decrypted by: corehacked | corehacked.com    |")
print("|                                                                     |")
print("|_____________________________________________________________________|")


local Get = gui.get_config_item

local AddCheckbox = gui.add_checkbox


local AddSlider = gui.add_slider


local AddCombo = gui.add_combo


function Clamp(x, min, max)


    if min > max then


        return math.min(math.max(x, max), min)


    else


        return math.min(math.max(x, min), max)


    end 


    return x


 end



--ui

--aa


local MenuSelection = gui.add_combo("Hell.Yaw Selection", "lua>tab b", {"Anti-Aim", "Visual", "Misc"})


local OverrideAntiaim = AddCheckbox("Enable Anti-Aim Presets", "lua>tab b>")


local AntiaimPreset = AddCombo("Hell.Yaw Presets", "lua>tab b>", {"None", "Tank Jitter", "Slow", "SpinPaste"})


local anim_breaker_combo = {


    gui.add_multi_combo('Anim.Breakers', 'lua>tab b', {


        'static legs in air',


        'zero pitch on land',


        'movelean',


        'lunny',

    })


}

--Visual


local sktind = gui.add_checkbox("Skeet indicators", "lua>tab b")


local hitlogi = gui.add_checkbox("Hitlogs", "lua>tab b")


local hitlogs_y = gui.add_slider( "Hitlogs y", "lua>tab b>", 0, 100, 0  )


local aspectratio_enable = gui.add_checkbox("Aspectratio", "lua>tab b>")


local aspect_ratio_slider = gui.add_slider("Aspect ratio", "lua>tab b>", 1, 200, 1)


local viewmodel_master_boolean = gui.add_checkbox( "Enable viewmodel changer", "lua>tab b>" ) 


local viewmodel_x_slider = gui.add_slider( "Viewmodel X", "lua>tab b>", -40, 40, 1 )


local viewmodel_y_slider = gui.add_slider( "Viewmodel Y", "lua>tab b>", -40, 40, 1 )


local viewmodel_z_slider = gui.add_slider( "Viewmodel Z", "lua>tab b>", -40, 40, 1 )


local path = "lua>tab b"


local keybindlist_m =  gui.add_checkbox("Keybinds", path)


local color = gui.add_colorpicker(path..">Keybinds", true)


local type_keybinds = gui.add_combo("Keybinds type", path,{"Static","Fade","Chroma"})


local second_color = gui.add_colorpicker(path..">Keybinds type", true)


local db = database.load("Xissayala_keybinds_data.db")


local checkbox = gui.add_checkbox("Indicator", "lua>tab b")


local indicator_color = gui.add_colorpicker(path..">Indicator", true)


local checkbox1 = gui.add_checkbox("dt waiting color", "lua>tab b")


local checkbox2 = gui.add_checkbox("dt active color", "lua>tab b")


local checkbox3 = gui.add_checkbox("hs acitve color", "lua>tab b")


local checkbox4 = gui.add_checkbox("idealtick ready color", "lua>tab b")


local checkbox5 = gui.add_checkbox("autopeek ready color", "lua>tab b")


local indicator_color1 = gui.add_colorpicker("lua>tab b>dt waiting color", true, render.color("#D98B7B"))


local indicator_color2 = gui.add_colorpicker("lua>tab b>dt active color", true, render.color("#AEFDBB"))


local indicator_color3 = gui.add_colorpicker("lua>tab b>hs acitve color", true, render.color("#B4FFF1"))

local indicator_color4 = gui.add_colorpicker("lua>tab b>idealtick ready color", true, render.color("#AEFDBB"))


local indicator_color5 = gui.add_colorpicker("lua>tab b>autopeek ready color", true, render.color("#AEFDBB"))

--misc


local tt = gui.add_checkbox("TrashTalk", "lua>tab b")


local clantag_main = gui.add_combo("Clantags", "Lua>Tab b", {"OFF","Gamesense","rnbclub","Hell.Yaw"})

--ind




local x, y = render.get_screen_size()


local binds = {


   --rage


   dormant = gui.get_config_item('rage>aimbot>aimbot>target dormant'),


   hideshots = gui.get_config_item('rage>aimbot>aimbot>hide shot'),


   doubletap = gui.get_config_item('rage>aimbot>aimbot>double tap'),


   forcebaim = gui.get_config_item('rage>aimbot>aimbot>force bodyaim'),


   hsonly = gui.get_config_item('rage>aimbot>aimbot>headshot only'),


   --antiaim


   freestand = gui.get_config_item('rage>anti-aim>angles>freestand'),


   manual_back = gui.get_config_item('rage>anti-aim>angles>back'),


   manual_left = gui.get_config_item('rage>anti-aim>angles>left'),


   manual_right = gui.get_config_item('rage>anti-aim>angles>right'),



   slowwalk = gui.get_config_item('misc>movement>slide'),


   autopeek = gui.get_config_item('misc>movement>peek assist'),






}


local function animation(check, name, value, speed) 


    if check then 


        return name + (value - name) * global_vars.frametime * speed / 1.5


    else 


        return name - (value + name) * global_vars.frametime * speed / 1.5


        


    end


end


local offset_scope = 0


local move_offset = 0


local crouch_offset = 0


local offset_scope_air = 0


local offset_scope_crouch = 0


local dormatn_y = 0


local slowwalk_offset = 0


local offset_scope_slowwalk = 0 


local main_alpha = 0


local moving_offset = 0


local offset_scope_moving = 0


local stand_offset = 0


local offset_scope_stand = 0


local offset_scope_hide = 0


local hide_offset = 0


local offset_scope_dt = 0


local dt_offset = 0


local offset_scope_dt1 = 0


local dt1_offset = 0


local offset_scope_it = 0


local it_offset = 0


local main_y = 0


local main_do = 0


local offset_scope_do = 0


local do_offset = 0


local offset_scope_it1 = 0


local it_offset1 = 0

--key


local HUD = {}


function HUD:new(x, y, w, h)


    self = setmetatable({}, {__index = HUD})


    self.x, self.y, self.w, self.h = x or 200, y or 400, w or 160, h or 20


    self.drag_x, self.drag_y = 0, 0


    self.is_dragging = false


    return self


end


function HUD:drag()


    local m = {} m.x, m.y = input.get_cursor_pos()


        local is_hovered = (m.x > (self.x) and m.x < (self.x + self.w) and m.y > (self.y) and m.y < (self.y + self.h))


    if is_hovered then


        if input.is_key_down(1) and not self.is_dragging then


            self.is_dragging = true


           


            self.drag_x = self.x - m.x


            self.drag_y = self.y - m.y


        end


    end


    if not input.is_key_down(1) then


        self.is_dragging = false


    end


    if self.is_dragging and gui.is_menu_open() then


        self.x = (self.drag_x + m.x)


        self.y = (self.drag_y + m.y)


    end


end


function HUD:paint() end


function HUD:draw()self:paint()self:drag()end





local binds_data = {

    {


        name = "Rage aimbot",


        path = "rage>aimbot>aimbot>aimbot" --aimbot


    },--[[aimbot]] --[=[aimbot]=]

    {


        name = "On shot anti-aim",


        path = "rage>aimbot>aimbot>hide shot"

    },


    {


        name = "Double tap",


        path = "rage>aimbot>aimbot>double tap"


    },

    {


        name = "Force safepoint",


        path = "rage>aimbot>aimbot>force extra safety"

    },

    {


        name = "Headshot only",


        path = "rage>aimbot>aimbot>headshot only"

    },


    {


        name = "Minimum damage",


        path = "rage>aimbot>autosniper>auto>override"


    },


    {


        name = "Autostop",


        path = "rage>aimbot>autosniper>extra>autostop"


    },


    {


        name = "Anti-aim enable",

        path = "rage>anti-aim>angles>anti-aim"


    },


    {


        name = "Freestand",


        path = "rage>anti-aim>angles>freestand"


    },


    {


        name = "Backwards",


        path = "rage>anti-aim>angles>back"


    },


    {


        name = "Left yaw",


        path = "rage>anti-aim>angles>Left"


    },


    {


        name = "Right yaw",


        path = "rage>anti-aim>angles>right"


    },

    {


        name = "Ensure lean",


        path = "rage>anti-aim>desync>ensure lean"

    },


    {


        name = "Legit aimbot",


        path = "legit>pistol>aimhelper>magnet"

    },


    {

        name = "Triggerbot",

        path = "legit>pistol>assists>triggerbot"

    },

    {

        name = "Esp enable",

        path = "visuals>esp>player>esp"

    },

    {

        name = "Chams enable",

        path = "visuals>models>general>chams"

    },

    {

        name = "Thirdperson",

        path = "visuals>misc>local>thirdperson"

    },

    {

        name = "Quick peek assist",

        path = "misc>movement>peek assist"

    },

    {

        name = "Slowwalk",

        path = "misc>movement>slide"

    },

    {

        name = "Duck peek assist",

        path = "misc>movement>fake duck"

    },

}

for _,v in pairs(binds_data)do

    v.item = gui.get_config_item(v.path)

end

local screen_size = {} screen_size.x,screen_size.y = render.get_screen_size()

if db == nil then

    database.save("Xissayala_keybinds_data.db",{x = 0,y = 0})

    db = {x = 0,y = 0}

end

function on_shutdown()

    database.save("Xissayala_keybinds_data.db",db)

end

local speed = 18

local m_alpha = 0

local m_active = {}

local font = render.create_font("Tahoma.ttf", 11, render.font_flag_shadow)

local keybindlist = HUD:new(

    db.x,

    db.y,

    160

)

--[=[]=]

local valtotype = function (b)

   return({"hold", "toggle"})[b] or nil

end

local lerp = function(a,b,c) return a + (b - a) *c*global_vars.frametime end

function keybindlist:paint()

    local isanybindactive = false

    local maximum_offset = 110

    local master_switch = keybindlist_m:get_bool()

    local x, y = self.x,self.y

    local c = color:get_color()

    local f = second_color:get_color()

    local itr = 1

    for c_key, c_data in pairs(binds_data) do

        local k = c_data.name

        local _, tybeB = gui.get_keybind(c_data.path)

        if c_data.item:get_bool() and valtotype(tybeB) then

            isanybindactive = true

            if m_active[k] == nil then

                m_active[k] = {value = "",alpha = 0,offset = 0,name = "",y_add = -8 + itr*16+5}

            end

            m_active[k].itr = itr

            m_active[k].name = k

            m_active[k].value = valtotype(tybeB)

            m_active[k].offsetr = ({render.get_text_size(font, "["..valtotype(tybeB).."]")})[1]

            m_active[k].offset = ({render.get_text_size(font, k)})[1]+m_active[k].offsetr+10

            m_active[k].alpha = lerp(m_active[k].alpha,1,speed)

            m_active[k].y_add = lerp(m_active[k].y_add, itr*16+5,speed)

            itr = itr + 1

        else

            if m_active[k] then

                if m_active[k].alpha then

                    m_active[k].alpha = lerp(m_active[k].alpha,0,speed)

                    --itr = itr + 1

                end

                if m_active[k].y_add then

                    m_active[k].y_add = lerp(m_active[k].y_add,-8  + m_active[k].itr*16+5,speed)

                end

                if m_active[k].alpha < 0.1 then

                    m_active[k] = nil

                end

            end

        end

        if m_active[k] and (m_active[k].offset) > maximum_offset then

            maximum_offset = m_active[k].offset

        end

    end

    self.w = math.floor(.5+lerp(self.w, maximum_offset, speed))

    if m_alpha > 0.01 then

        for _, c_data in pairs(m_active) do

            render.text(font, x, c_data.y_add + y, c_data.name, render.color(255, 255, 255, c_data.alpha*m_alpha*255))

            render.text(font, x+self.w-c_data.offsetr, y + c_data.y_add, "[".. c_data.value.."]", render.color(255, 255, 255, c_data.alpha*m_alpha*255))

            --itr = itr + 1

        end

        render.rect_filled(x, y, x+self.w, y+self.h, render.color(17,17,17,m_alpha*255))

        if type_keybinds:get_int() == 0 then

            render.rect_filled(x, y, x+self.w, y+2, render.color(c.r,c.g,c.b,m_alpha*c.a))

        elseif type_keybinds:get_int() == 1 then

            render.rect_filled_multicolor(x, y, x+self.w/2, y+2,

            render.color(f.r, f.g, f.b, m_alpha*f.a),

            render.color(c.r, c.g, c.b, m_alpha*c.a),

            render.color(c.r, c.g, c.b, m_alpha*c.a),

            render.color(f.r, f.g, f.b, m_alpha*f.a))

            render.rect_filled_multicolor(x+self.w/2, y, x+self.w, y+2,

            render.color(c.r, c.g, c.b, m_alpha*c.a),

            render.color(f.r, f.g, f.b, m_alpha*f.a),

            render.color(f.r, f.g, f.b, m_alpha*f.a),

            render.color(c.r, c.g, c.b, m_alpha*c.a))

        else

            render.rect_filled_multicolor(x, y, x+self.w/2, y+2,

            render.color(0, 255, 255, m_alpha*255),

            render.color(255, 0, 255, m_alpha*255),

            render.color(255, 0, 255, m_alpha*255),

            render.color(0, 255, 255, m_alpha*255))

            render.rect_filled_multicolor(x+self.w/2, y, x+self.w, y+2,

            render.color(255, 0, 255, m_alpha*255),

            render.color(255, 255, 0, m_alpha*255),

            render.color(255, 255, 0, m_alpha*255),

            render.color(255, 0, 255, m_alpha*255))

        end

        render.text(font, x+self.w/2, y+self.h/2, "keybinds", render.color(255, 255, 255, m_alpha*255), render.align_center, render.align_center)

    end

    db.x = self.x

    db.y = self.y

    m_alpha = lerp(m_alpha,((gui.is_menu_open() or isanybindactive) and master_switch) and 1 or 0 ,speed)

end

--animbreak

ffi.cdef[[

    typedef void*(__thiscall* get_client_entity_t)(void*, int);


    typedef struct

    {

        char pad20[24];

        uint32_t m_nSequence;

        float m_flPrevCycle;

        float m_flWeight;

        char pad20[8];

        float m_flCycle;

        void *m_pOwner;

        char pad_0038[ 4 ];

    } animation_layer_t;

    

    typedef struct

    { 

        char pad[ 3 ];

        char m_bForceWeaponUpdate; //0x4

        char pad1[ 91 ];

        void* m_pBaseEntity; //0x60

        void* m_pActiveWeapon; //0x64

        void* m_pLastActiveWeapon; //0x68

        float m_flLastClientSideAnimationUpdateTime; //0x6C

        int m_iLastClientSideAnimationUpdateFramecount; //0x70

        float m_flAnimUpdateDelta; //0x74

        float m_flEyeYaw; //0x78

        float m_flPitch; //0x7C

        float m_flGoalFeetYaw; //0x80

        float m_flCurrentFeetYaw; //0x84

        float m_flCurrentTorsoYaw; //0x88

        float m_flUnknownVelocityLean; //0x8C

        float m_flLeanAmount; //0x90

        char pad2[ 4 ];

        float m_flFeetCycle; //0x98

        float m_flFeetYawRate; //0x9C

        char pad3[ 4 ];

        float m_fDuckAmount; //0xA4

        float m_fLandingDuckAdditiveSomething; //0xA8

        char pad4[ 4 ];

        float m_vOriginX; //0xB0

        float m_vOriginY; //0xB4

        float m_vOriginZ; //0xB8

        float m_vLastOriginX; //0xBC

        float m_vLastOriginY; //0xC0

        float m_vLastOriginZ; //0xC4

        float m_vVelocityX; //0xC8

        float m_vVelocityY; //0xCC

        char pad5[ 4 ];

        float m_flUnknownFloat1; //0xD4

        char pad6[ 8 ];

        float m_flUnknownFloat2; //0xE0

        float m_flUnknownFloat3; //0xE4

        float m_flUnknown; //0xE8

        float m_flSpeed2D; //0xEC

        float m_flUpVelocity; //0xF0

        float m_flSpeedNormalized; //0xF4

        float m_flFeetSpeedForwardsOrSideWays; //0xF8

        float m_flFeetSpeedUnknownForwardOrSideways; //0xFC

        float m_flTimeSinceStartedMoving; //0x100

        float m_flTimeSinceStoppedMoving; //0x104

        bool m_bOnGround; //0x108

        bool m_bInHitGroundAnimation; //0x109

        float m_flTimeSinceInAir; //0x10A

        float m_flLastOriginZ; //0x10E

        float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112

        float m_flStopToFullRunningFraction; //0x116

        char pad7[ 4 ]; //0x11A

        float m_flMagicFraction; //0x11E

        char pad8[ 60 ]; //0x122

        float m_flWorldForce; //0x15E

        char pad9[ 462 ]; //0x162

        float m_flMaxYaw; //0x334

    } anim_state_t;

]]


local class_ptr = ffi.typeof('void***')

local uintptr_t = ffi.typeof('uintptr_t**')


local function this_call(call_function, parameters)

    return function(...)

        return call_function(parameters, ...)

    end

end


local VClientEntityList = ffi.cast(uintptr_t, utils.find_interface('client.dll', 'VClientEntityList003'))

local get_client_entity = this_call(ffi.cast('get_client_entity_t', VClientEntityList[0][3]), VClientEntityList)


local is_moving = false

local was_in_air = true


local anim_breakers = {

    -- static legs in air

    [1] = function(pointer)

        if was_in_air then

            ffi.cast('float*', ffi.cast('uintptr_t', pointer) + 10104)[6] = 1

        end

    end,


    -- zero pitch on land

    [2] = function(pointer)

        if not was_in_air then

            local anim_state = ffi.cast('anim_state_t**', ffi.cast('uintptr_t', pointer) + 0x9960)[0]


            if anim_state.m_bInHitGroundAnimation then

                ffi.cast('float*', ffi.cast('uintptr_t', pointer) + 10104)[12] = 0.5

            end

        end

    end,


    -- movement lean

    [3] = function(pointer)

        if is_moving then

            ffi.cast('animation_layer_t**', ffi.cast('uintptr_t', pointer) + 0x2990)[0][12].m_flWeight = 1

        end

    end,


    -- moonwalk

    [4] = function(pointer)

        if is_moving then

            ffi.cast('float*', ffi.cast('uintptr_t', pointer) + 10104)[7] = 0

            ffi.cast('animation_layer_t**', ffi.cast('uintptr_t', pointer) + 0x2990)[0][7].m_flWeight = 0

        end

    end,

}


--viewmodel

local function vtable_bind( class, _type, index )

    local this = ffi.cast( "void***", class )

    local ffitype = ffi.typeof( _type )

    return function ( ... )

        return ffi.cast( ffitype, this[ 0 ][ index ] )( this, ... )

    end

end


local IConsole = utils.find_interface( "vstdlib.dll", "VEngineCvar007" )

local GetConvarFN = vtable_bind( IConsole, "unsigned int(__thiscall*)(void*, char*)", 15 )


local BackupCallbackSize = { }


local function SetCallbacks( cvar, n )

    if not cvar then return end

    BackupCallbackSize[ cvar ] = ffi.cast( "unsigned int*", cvar + 0x60 )[ 0 ]

    ffi.cast( "unsigned int*", cvar + 0x60 )[ 0 ] = n or 0

end


SetCallbacks( GetConvarFN( ffi.cast( "char*", "viewmodel_offset_x" ) ) )

SetCallbacks( GetConvarFN( ffi.cast( "char*", "viewmodel_offset_y" ) ) )

SetCallbacks( GetConvarFN( ffi.cast( "char*", "viewmodel_offset_z" ) ) )



local viewmodel_x = cvar.viewmodel_offset_x

local viewmodel_y = cvar.viewmodel_offset_y

local viewmodel_z = cvar.viewmodel_offset_z

local cached_viewmodel_data = {

    cached_default_viewmodel_x = cvar.viewmodel_offset_x,

    cached_default_viewmodel_y = cvar.viewmodel_offset_y,

    cached_default_viewmodel_z = cvar.viewmodel_offset_z,

    cached_viewmodel = true

}



local function change_viewmodel( )

    if viewmodel_master_boolean:get_bool( ) then

        if cached_viewmodel_data.cached_viewmodel then

            cached_viewmodel_data.cached_default_viewmodel_x = viewmodel_x:get_float( )

            cached_viewmodel_data.cached_default_viewmodel_y = viewmodel_y:get_float( )

            cached_viewmodel_data.cached_default_viewmodel_z = viewmodel_z:get_float( )

            cached_viewmodel_data.cached_viewmodel = false

        end

        -- change our viewmodel!

        viewmodel_x:set_float( viewmodel_x_slider:get_float( ) )

        viewmodel_y:set_float( viewmodel_y_slider:get_float( ) )

        viewmodel_z:set_float( viewmodel_z_slider:get_float( ) )

     

    else

        if not cached_viewmodel_data.cached_viewmodel then

            viewmodel_x:set_float( cached_viewmodel_data.cached_default_viewmodel_x )

            viewmodel_y:set_float( cached_viewmodel_data.cached_default_viewmodel_y )

            viewmodel_z:set_float( cached_viewmodel_data.cached_default_viewmodel_z )

            cached_viewmodel_data.cached_viewmodel = true

        end

    end

end

--aspectratio

local r_aspectratio = cvar.r_aspectratio


local default_value = r_aspectratio:get_float()


local function set_aspect_ratio(multiplier)

    local screen_width,screen_height = render.get_screen_size()


    local value = (screen_width * multiplier) / screen_height


    if multiplier == 1 then

        value = 0

    end

    r_aspectratio:set_float(value)

end

--viewmscope

local function vtable_bind(class, _type, index)

    local this = ffi.cast("void***", class)

    local ffitype = ffi.typeof(_type)

    return function (...)

        return ffi.cast(ffitype, this[0][index])(this, ...)

    end

end

local WeaponSystem  = ffi.cast("void**", utils.find_pattern("client.dll", "8B 35 ? ? ? ? FF 10 0F B7 C0") + 2)[0]

local GetWeaponData = vtable_bind(WeaponSystem, "uintptr_t(__thiscall*)(void*, short)", 2)


local function GetWeaponDataAddress(player_index)

    local Player = entities.get_entity(player_index)

    if not Player or not Player:is_alive() then

        return nil

    end

    

    local Weapon = Player:get_weapon()

    if not Weapon then

        return nil

    end

    

    return GetWeaponData(Weapon:get_prop("m_iItemDefinitionIndex"))

end

--skeet ind

local list = {

    {text = 'DT', path = 'rage>aimbot>aimbot>double tap'},

    {text = 'SILENT', path = 'rage>aimbot>aimbot>hide shot'},

    {text = 'DUCK', path = 'misc>movement>fake duck'},

    {text = 'SAFE', path = 'rage>aimbot>aimbot>force extra safety'},

    {text = 'FREESTAND', path = 'rage>anti-aim>angles>freestand'},

    {text = 'HSONLY', path = 'rage>aimbot>aimbot>headshot only'},

    {text = 'LEFT', path = 'rage>anti-aim>angles>left'},

    {text = 'RIGHT', path = 'rage>anti-aim>angles>right'},

    {text = 'LEAN', path = 'rage>anti-aim>desync>ensure lean'},

}


local get_speed = function()

    local lp = entities.get_entity(engine.get_local_player())

    local vel0 = lp:get_prop('m_vecVelocity[0]')

    local vel1 = lp:get_prop('m_vecVelocity[1]')


    return math.sqrt(vel0 * vel0 + vel1 * vel1)

end

-- CBasePlayer > m_vecVelocity[1] [ float ] 

-- CBasePlayer > 

local get_binds = function()

    local active = {}

    for i, ind in pairs(list) do

        if gui.get_config_item(ind.path):get_bool() then

            table.insert(active, ind.text)

        end

        -- if get_speed() > 275

    end

    -- table.insert(active, 'LC')

    -- table.insert(active, 'FAKE')

    return active

end

local screen = math.vec3(render.get_screen_size())

--hitlogs

local font2 = render.create_font("verdana.ttf", 11,render.font_flag_shadow, 0, 2056)


local highlight = render.color(120,120,120,0)

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

    local y_logs = hitlogs_y:get_int()

    local size = 0

    local step_size = 0


    for _, v in pairs(array) do -- calc total size

        size = size + render.get_text_size(font2, v[1])

      

        if shift then size = size * (math.min(alpha, 150)/150) end

    end


    for _, v in pairs(array) do

        if v[2] then

            v[2].a = alpha

        end

    

        render.text(font2, x - size / 2 + step_size, y+y_logs*5, v[1], v[2] or render.color(255, 255, 255, alpha))

      

        step_size = step_size + render.get_text_size(font2, v[1])

    end

end

--aa

local Antiaim = {

    OverrideYaw = Get("Rage>Anti-Aim>Angles>Yaw add"),

    YawAmount = Get("Rage>Anti-Aim>Angles>Add"),

	Pitch = Get("Rage>Anti-Aim>Angles>Pitch"),


    OverrideSpin = Get("Rage>Anti-Aim>Angles>Spin"),

    SpinAmount = Get("Rage>Anti-Aim>Angles>Spin range"),

    SpinSpeed = Get("Rage>Anti-Aim>Angles>Spin speed"),


    OverrideJitter = Get("Rage>Anti-Aim>Angles>Jitter"),

    JitterAmount = Get("Rage>Anti-Aim>Angles>Jitter Range"),

    JitterRandomize = Get("Rage>Anti-Aim>Angles>Random"),


    DesyncAmount = Get("Rage>Anti-Aim>Desync>Fake amount"),

    DesyncCompensation = Get("Rage>Anti-Aim>Desync>Compensate angle"),

    DesyncJitter = Get("Rage>Anti-Aim>Desync>Flip fake with jitter")

}


local function JitterSide()

    local JitterSide = 0

    local SwapTimer = 0

    local Curtime = global_vars.curtime

    SwapTimer = math.ceil(Curtime * 32) % 2

	

	

    Clamp(SwapTimer, 0, 1)

    JitterSide = SwapTimer > 0.5 and 1 or -1

    return JitterSide

end


local function AntiaimSystem(cmd)

    local Curtime = global_vars.curtime


    if OverrideAntiaim:get_bool() then

        if AntiaimPreset:get_int() == 1 then

            Antiaim.OverrideSpin:set_bool(false)


            Antiaim.YawAmount:set_int(math.ceil(Curtime * 0) % 5 * JitterSide())

            Antiaim.DesyncAmount:set_int(70 * JitterSide())

            Antiaim.DesyncCompensation:set_int(20 + math.ceil(Curtime * 0) % 5)

        end


        if AntiaimPreset:get_int() == 2 then

            Antiaim.OverrideSpin:set_bool(true)

            Antiaim.YawAmount:set_int(math.ceil(Curtime * 0) % 2 * JitterSide())

        end


        if AntiaimPreset:get_int() == 3 then

            Antiaim.OverrideSpin:set_bool(true)


            Antiaim.SpinAmount:set_int(math.ceil(Curtime * 128) % 35)

            Antiaim.YawAmount:set_int(- Antiaim.SpinAmount:get_int())

            Antiaim.DesyncAmount:set_int(-60)

            Antiaim.DesyncCompensation:set_int(60)

        end

    end

end

--clantag

local main_Gamesense = {

    "                  ",

    "                 g",

    "                ga",

    "               gam",

    "              game",

    "             games",

    "            gamese",

    "           gamesen",

    "          gamesens",

    "         gamesense",

    "        gamesense ",

    "       gamesense  ",

    "      gamesense   ",

    "     gamesense    ",

    "    gamesense     ",

    "   gamesense      ",

    "  gamesense       ",

    " gamesense        ",

    "gamesense         ",

    "amesense          ",

    "mesense           ",

    "esense            ",

    "sense             ",

    "sens              ",

    "sen               ",

    "se                ",

    "s                 ",

}


local main_hellyaw = {

    "h ",

    "he ",

    "hel ",

    "hell ",

    "hell. ",

    "hell.y ",

    "hell.ya ",

    "hell.yaw ",

    "hell.yaw$ ",

    "hell.yaw$$$ ",
	
	"corehacked.com",

    "hell.yaw$$ ",

    "hell.yaw$ ",

    "hell.y ",

    "hell. ",

    "hell ",

    "hel " ,

    "he ",

    "h ",

    "h ",

    "h ",

}


local main_rnbclub = {

    " R",

    " RN",

    " RNB",

    " RNB C",

    " RNB CL",

    " RNB CLU",

    " RNB CLUB",

    " RNB CLU ",

    " RNB CL ",

    " RNB C ",

    " RNB  ",

    " RN ",

    " R ",

    " R ",

    " R ",

    "  ",

    " ",

}




local tags = 

{

    main_Gamesense,

    main_rnbclub,

    main_hellyaw,

}


local defaultct = gui.get_config_item("misc>various>clan tag") 

local old_tag_string   = nil

local can_reset = false


--trashtolk

local IVEngineClient = utils.find_interface("engine.dll", "VEngineClient014") or error("Engine client is invalid")

local IVEngineClientPtr = ffi.cast("void***", IVEngineClient)

local IVEngineClientVtable = IVEngineClientPtr[0]

local ClientCmdPtr = IVEngineClientVtable[108]

local ClientCmd = ffi.cast(ffi.typeof("void(__thiscall*)(void*, const char*)"), ClientCmdPtr)

local first = {

    'hellyaw - best lua for fatality - cracked by corehacked | corehacked.com',

    'fuck ephoria - get hellyaw - cracked by corehacked | corehacked.com',

    'hellyaw get u mad lol - cracked by corehacked | corehacked.com',

    'tapped by hellyaw techlonogy - cracked by corehacked | corehacked.com',

    'stop using pastes - get hellyaw - cracked by corehacked | corehacked.com',

    'by hellyaw antiaims - cracked by corehacked | corehacked.com',

    'damn hellyaw goin crazy - cracked by corehacked | corehacked.com',

    'hellyaw on the beat - cracked by corehacked | corehacked.com',

    'hellyaw - best codeine dealer - cracked by corehacked | corehacked.com',

    'hellyaw aa sys - nl resolver cry - cracked by corehacked | corehacked.com',

    'just (dont) buy hellyaw - get it free - cracked by corehacked | corehacked.com'

}

--calbacks   

function on_paint()

--setvis

    local menustate = MenuSelection:get_int()

	if menustate == 0 then

	 gui.set_visible("lua>tab b>Enable Anti-Aim Presets", true)

     gui.set_visible("lua>tab b>Hell.Yaw Presets", true)

     gui.set_visible("lua>tab b>Anim.Breakers", true)

	 gui.set_visible("LUA>Tab B>Skeet indicators", false)

     gui.set_visible("lua>tab b>Hitlogs", false)

     gui.set_visible("lua>tab b>Aspect ratio", false)

     gui.set_visible("lua>tab b>Enable viewmodel changer", false)

     gui.set_visible("lua>tab b>Viewmodel X", false)

     gui.set_visible("lua>tab b>Viewmodel Y", false)

     gui.set_visible("lua>tab b>Viewmodel Z", false)

     gui.set_visible("lua>tab b>Keybinds", false)

     gui.set_visible("lua>tab b>>Keybinds", false)

     gui.set_visible("lua>tab b>Keybinds type", false)

     gui.set_visible("lua>tab b>>Keybinds type", false)

	 gui.set_visible("lua>tab b>Indicator", false)

     gui.set_visible("lua>tab b>>Indicator", false)

     gui.set_visible("lua>tab b>dt waiting color", false)

     gui.set_visible("lua>tab b>dt active color", false)

     gui.set_visible("lua>tab b>hs acitve color", false)

     gui.set_visible("lua>tab b>autopeek ready color", false)

	 gui.set_visible("lua>tab b>dt waiting color", false)

     gui.set_visible("lua>tab b>dt active color", false)

     gui.set_visible("lua>tab b>hs acitve color", false)

     gui.set_visible("lua>tab b>idealtick ready color", false)  

	 gui.set_visible("lua>tab b>autopeek ready color", false) 

	 gui.set_visible("lua>tab b>TrashTalk", false)

     gui.set_visible("lua>tab b>Aspectratio", false)

     gui.set_visible("lua>tab b>Clantags", false)

     gui.set_visible("lua>tab b>Hitlogs y", false)     

	 else if menustate == 1 then

	 gui.set_visible("lua>tab b>Enable Anti-Aim Presets", false)

     gui.set_visible("lua>tab b>Hell.Yaw Presets", false)

     gui.set_visible("lua>tab b>Anim.Breakers", false)

	 gui.set_visible("LUA>Tab B>Skeet indicators", true)

     gui.set_visible("lua>tab b>Hitlogs", true)

     if hitlogi:get_bool() then

        gui.set_visible("lua>tab b>Hitlogs y", true)

     else

        gui.set_visible("lua>tab b>Hitlogs y", false)        

     end

     gui.set_visible("lua>tab b>Aspectratio", true)

     if aspectratio_enable:get_bool() then

     gui.set_visible("lua>tab b>Aspect ratio", true)

     else

      gui.set_visible("lua>tab b>Aspect ratio", false)       

     end

     gui.set_visible("lua>tab b>Enable viewmodel changer", true)

     if viewmodel_master_boolean:get_bool() then

     gui.set_visible("lua>tab b>Viewmodel X", true)

     gui.set_visible("lua>tab b>Viewmodel Y", true)

     gui.set_visible("lua>tab b>Viewmodel Z", true)

     else

        gui.set_visible("lua>tab b>Viewmodel X", false)

        gui.set_visible("lua>tab b>Viewmodel Y", false)

        gui.set_visible("lua>tab b>Viewmodel Z", false)

     end

     gui.set_visible("lua>tab b>Keybinds", true)

     gui.set_visible("lua>tab b>>Keybinds", true)

     gui.set_visible("lua>tab b>Keybinds type", true)

     gui.set_visible("lua>tab b>>Keybinds type", true)

	 gui.set_visible("lua>tab b>TrashTalk", false)

     gui.set_visible("lua>tab b>Clantags", false)

	 gui.set_visible("lua>tab b>Indicator", true)

     gui.set_visible("lua>tab b>>Indicator", true)

     gui.set_visible("lua>tab b>dt waiting color", true)

     gui.set_visible("lua>tab b>dt active color", true)

     gui.set_visible("lua>tab b>hs acitve color", true)

     gui.set_visible("lua>tab b>autopeek ready color", true)

	 gui.set_visible("lua>tab b>dt waiting color", true)

     gui.set_visible("lua>tab b>dt active color", true)

     gui.set_visible("lua>tab b>hs acitve color", true)

     gui.set_visible("lua>tab b>idealtick ready color", true)  

	 gui.set_visible("lua>tab b>autopeek ready color", true)

	 else if menustate == 2 then

	 	 gui.set_visible("lua>tab b>Enable Anti-Aim Presets", false)

     gui.set_visible("lua>tab b>Hell.Yaw Presets", false)

     gui.set_visible("lua>tab b>Anim.Breakers", false)

	 gui.set_visible("LUA>Tab B>Skeet indicators", false)

     gui.set_visible("lua>tab b>Hitlogs", false)

     gui.set_visible("lua>tab b>Aspect ratio", false)

     gui.set_visible("lua>tab b>Enable viewmodel changer", false)

     gui.set_visible("lua>tab b>Viewmodel X", false)

     gui.set_visible("lua>tab b>Hitlogs y", false)     

     gui.set_visible("lua>tab b>Viewmodel Y", false)

     gui.set_visible("lua>tab b>Viewmodel Z", false)

     gui.set_visible("lua>tab b>Keybinds", false)

     gui.set_visible("lua>tab b>>Keybinds", false)

     gui.set_visible("lua>tab b>Keybinds type", false)

     gui.set_visible("lua>tab b>>Keybinds type", false)

     gui.set_visible("lua>tab b>Aspectratio", false)

	 gui.set_visible("lua>tab b>Indicator", false)

     gui.set_visible("lua>tab b>>Indicator", false)

     gui.set_visible("lua>tab b>dt waiting color", false)

     gui.set_visible("lua>tab b>dt active color", false)

     gui.set_visible("lua>tab b>hs acitve color", false)

     gui.set_visible("lua>tab b>autopeek ready color", false)

	 gui.set_visible("lua>tab b>dt waiting color", false)

     gui.set_visible("lua>tab b>dt active color", false)

     gui.set_visible("lua>tab b>hs acitve color", false)

     gui.set_visible("lua>tab b>idealtick ready color", false)  

	 gui.set_visible("lua>tab b>autopeek ready color", false) 

	 gui.set_visible("lua>tab b>TrashTalk", true)

     gui.set_visible("lua>tab b>Clantags", true)

	end

  end

 end

 --indicatorss

    local lp = entities.get_entity(engine.get_local_player())

    if not lp then return end

    if not lp:is_alive() then return end

    local flags = lp:get_prop("m_fFlags")

    local scoped = lp:get_prop("m_bIsScoped")

    local alpha = math.floor(math.abs(math.sin(global_vars.curtime) * 2) * 255)

    local velocity_x = math.floor(lp:get_prop("m_vecVelocity[0]"))

    local velocity_y = math.floor(lp:get_prop("m_vecVelocity[1]"))

    local speed = math.sqrt(velocity_x ^ 2 + velocity_y ^ 2)

    local crouch = input.is_key_down(0x11)

    local air = lp:get_prop("m_hGroundEntity") == -1


    --scope offset

    if scoped then

        offset_scope = animation(0, offset_scope, 40, 40) 

        offset_scope_air = animation(0, offset_scope_air, 15, 40)   

        offset_scope_crouch = animation(0, offset_scope_crouch, 23, 40)   

        offset_scope_slowwalk = animation(0, offset_scope_slowwalk, 29, 40)   

        offset_scope_moving = animation(0, offset_scope_moving, 23, 40)            

        offset_scope_stand = animation(0, offset_scope_stand, 27, 40)        

        offset_scope_hide = animation(0, offset_scope_hide, 30, 40)   

        offset_scope_dt = animation(0, offset_scope_dt, 25, 40) 

        offset_scope_dt1 = animation(0, offset_scope_dt1, 26, 40)  

        offset_scope_do = animation(0, offset_scope_do, 23, 40) 

        offset_scope_it = animation(0, offset_scope_it, 40, 40) 

        offset_scope_it1 = animation(0, offset_scope_it1, 39, 40) 

    else

        offset_scope = animation(0, offset_scope, 0, 40)  

        offset_scope_air = animation(0, offset_scope_air, 0, 40)    

        offset_scope_crouch = animation(0, offset_scope_crouch, 0, 40)   

        offset_scope_slowwalk = animation(0, offset_scope_slowwalk, 0, 40)     

        offset_scope_moving = animation(0, offset_scope_moving, 0, 40) 

        offset_scope_stand = animation(0, offset_scope_stand, 0, 40) 

        offset_scope_hide = animation(0, offset_scope_hide, 0, 40) 

        offset_scope_dt = animation(0, offset_scope_dt, 0, 40) 

        offset_scope_dt1 = animation(0, offset_scope_dt1, 0, 40) 

        offset_scope_it = animation(0, offset_scope_it, 0, 40)

        offset_scope_it1 = animation(0, offset_scope_it1, 0, 40)

        offset_scope_do = animation(0, offset_scope_do, 0, 40)

    end


    --main

    if checkbox:get_bool() then

        main_alpha = animation(0, main_alpha, 255, 20)    

    else

        main_alpha = animation(0, main_alpha, 0, 20)             

    end


    --move_offset

    if flags == 262  and checkbox:get_bool() or flags == 256 and checkbox:get_bool() then

        move_offset = animation(0, move_offset, 255, 25)    

    else

        move_offset = animation(0, move_offset, 0, 25)             

    end

    if flags == 263 and checkbox:get_bool() and not air then

        crouch_offset = animation(0, crouch_offset, 255, 25)      

    else

        crouch_offset = animation(0, crouch_offset, 0, 25)        

    end

    if binds.slowwalk:get_bool() and checkbox:get_bool() and not air then

        slowwalk_offset = animation(0, slowwalk_offset, 255, 25)      

    else

        slowwalk_offset = animation(0, slowwalk_offset, 0, 25)        

    end

    if speed > 2 and not air and not crouch and not binds.slowwalk:get_bool() and checkbox:get_bool() then

        moving_offset = animation(0, moving_offset, 255, 25)      

    else

        moving_offset = animation(0, moving_offset, 0, 25)        

    end   

    if speed <= 2 and flags == 257 and checkbox:get_bool()  then

        stand_offset = animation(0, stand_offset, 255, 25)      

    else

        stand_offset = animation(0, stand_offset, 0, 25)              

    end    


    --binds

    if binds.hideshots:get_bool() and checkbox:get_bool() and not binds.doubletap:get_bool() then

        hide_offset = animation(0, hide_offset, 255, 25)      

    else

        hide_offset = animation(0, hide_offset, 0, 25)           

    end

    if binds.doubletap:get_bool() and checkbox:get_bool() and not binds.autopeek:get_bool() and info.fatality.can_fastfire  then

        dt_offset = animation(0, dt_offset, 255, 25)      

    else

        dt_offset = animation(0, dt_offset, 0, 25)           

    end   

    if binds.doubletap:get_bool() and checkbox:get_bool() and not binds.autopeek:get_bool() and not info.fatality.can_fastfire then

        dt1_offset = animation(0, dt1_offset, 255, 25)      

    else

        dt1_offset = animation(0, dt1_offset, 0, 25)           

    end      

    if binds.autopeek:get_bool() and binds.doubletap:get_bool() and checkbox:get_bool() then

        it_offset = animation(0, it_offset, 255, 25)      

    else

        it_offset = animation(0, it_offset, 0, 25)           

    end    

    if binds.autopeek:get_bool() and not binds.doubletap:get_bool() and not binds.hideshots:get_bool() and checkbox:get_bool() then

        it_offset1 = animation(0, it_offset1, 255, 25)      

    else

        it_offset1 = animation(0, it_offset1, 0, 25)           

    end     

    if binds.dormant:get_bool() and checkbox:get_bool() then

        do_offset = animation(0, do_offset, 255, 25)      

    else

        do_offset = animation(0, do_offset, 0, 25)           

    end

    

    --y_offset


    if binds.hideshots:get_bool() and checkbox:get_bool() or binds.doubletap:get_bool() and checkbox:get_bool() or binds.autopeek:get_bool() and checkbox:get_bool() then

        main_y = animation(0, main_y, 8, 40)      

    else

        main_y = animation(0, main_y, 0, 40)           

    end

    if binds.dormant:get_bool() and checkbox:get_bool() then

        main_do = animation(0, main_do, 9, 40)      

    else

        main_do = animation(0, main_do, 0, 40)           

    end

    render.text(render.font_esp, x/2 - 19 + offset_scope , y/2 + 25, "hellyaw", render.color(255,255,255, main_alpha), render.align_center, render.align_center)

  if  checkbox:get_bool() then

    render.text(render.font_esp, x/2 + 17 + offset_scope, y/2 + 25, "stable", render.color(indicator_color:get_color().r, indicator_color:get_color().g, indicator_color:get_color().b, alpha), render.align_center, render.align_center)

  end


    render.text(render.font_esp, x/2 - 1 + offset_scope_air, y/2 + 35, "-air-", render.color(255,255,255, move_offset), render.align_center, render.align_center)

    render.text(render.font_esp, x/2 - 1 + offset_scope_crouch, y/2 + 35, "-crouch-", render.color(255,255,255, crouch_offset), render.align_center, render.align_center)

    render.text(render.font_esp, x/2 - 1 + offset_scope_slowwalk, y/2 + 35, "-slowwalk-", render.color(255,255,255, slowwalk_offset), render.align_center, render.align_center)

    render.text(render.font_esp, x/2 - 1 + offset_scope_moving, y/2 + 35, "-moving-", render.color(255,255,255, moving_offset), render.align_center, render.align_center)    

    render.text(render.font_esp, x/2 - 1 + offset_scope_stand, y/2 + 35, "-standing-", render.color(255,255,255, stand_offset), render.align_center, render.align_center)   

    

    render.text(render.font_esp, x/2 - 17 + offset_scope_hide, y/2 + 36 + main_y, "hide", render.color(255,255,255, hide_offset), render.align_center, render.align_center)  

    render.text(render.font_esp, x/2 + 8 + offset_scope_hide, y/2 + 36 + main_y, "active", render.color(indicator_color3:get_color().r, indicator_color3:get_color().g, indicator_color3:get_color().b, hide_offset), render.align_center, render.align_center) 

    render.text(render.font_esp, x/2 - 17 + offset_scope_dt, y/2 + 36 + main_y, "dt", render.color(255,255,255, dt_offset), render.align_center, render.align_center) 

    render.text(render.font_esp, x/2 - 18 + offset_scope_dt1, y/2 + 36 + main_y, "dt", render.color(255,255,255, dt1_offset), render.align_center, render.align_center)

    render.text(render.font_esp, x/2 + 4 + offset_scope_dt1, y/2 + 36 + main_y, "waiting", render.color(indicator_color1:get_color().r, indicator_color1:get_color().g, indicator_color1:get_color().b, dt1_offset), render.align_center, render.align_center)

    render.text(render.font_esp, x/2 + 3 + offset_scope_dt, y/2 + 36 + main_y, "active", render.color(indicator_color2:get_color().r, indicator_color2:get_color().g, indicator_color2:get_color().b, dt_offset), render.align_center, render.align_center) 

    render.text(render.font_esp, x/2 - 16 + offset_scope_it, y/2 + 36 + main_y, "idealtick", render.color(255,255,255, it_offset), render.align_center, render.align_center)  

    render.text(render.font_esp, x/2 + 20 + offset_scope_it, y/2 + 36 + main_y, "ready", render.color(indicator_color4:get_color().r, indicator_color4:get_color().g, indicator_color4:get_color().b, it_offset), render.align_center, render.align_center) 

    render.text(render.font_esp, x/2 - 17 + offset_scope_it1, y/2 + 36 + main_y, "autopeek", render.color(255,255,255, it_offset1), render.align_center, render.align_center)  

    render.text(render.font_esp, x/2 + 17 + offset_scope_it1, y/2 + 36 + main_y, "ready", render.color(indicator_color5:get_color().r, indicator_color5:get_color().g, indicator_color5:get_color().b, it_offset1), render.align_center, render.align_center) 

    render.text(render.font_esp, x/2 - 2 + offset_scope_do, y/2 + 36 + main_y + main_do, "dormant", render.color(255,255,255, do_offset), render.align_center, render.align_center) 

--aspect

    if aspectratio_enable:get_bool() then

    local aspect_ratio = aspect_ratio_slider:get_int() * 0.01

    aspect_ratio = 2 - aspect_ratio

    set_aspect_ratio(aspect_ratio)

    end

--skeet

    local lp = entities.get_entity(engine.get_local_player())

    if not lp then return end

    local x, y = render.get_screen_size()

if sktind:get_bool() then

    for i, value in pairs(get_binds()) do

        local clr = render.color(150, 200, 30)

        if value == 'DT' then

            if not info.fatality.can_fastfire then

                clr = render.color(255, 20, 20)

            end

        end


        local pos = {

            x = 10,

            y = screen.y / 2 + 100 + 35 * (i - 1)

        }


        local text_size = math.vec3(render.get_text_size(render.font_indicator, value))


        -- if value == 'FAKE' then

        --     render.circle(pos.x + text_size.x + 20, pos.y + text_size.y / 2, 8, render.color(0, 0, 0), 3)

        -- end


        render.text(render.font_indicator, pos.x, pos.y, value, clr)

    end

end

        --clantag

    local tag_idx = clantag_main:get_int()

    local tag = tags[tag_idx]

    if tag then

        local curtime = math.floor((global_vars.curtime) * 2.5)

        local tag_string = tag[curtime % #tag + 1]

        if tag_string ~= old_tag_string then

            utils.set_clan_tag(tag_string)

            defaultct:set_bool(false)

            old_tag_string = tag_string

            can_reset = true

        end

    else

        if can_reset then

            utils.set_clan_tag(" ") 

            can_reset = false

        end

    end

--hitlogs

    local offset = 0


  if  hitlogi:get_bool() then 

    for _, v in pairs(shots) do     

        if v.a <= 0 and global_vars.realtime > v.time and _ == #shots then

            shots[_] = nil

        end

      

        v.a = global_vars.realtime < v.time and math.min(v.a + 5, 255) or math.max(v.a - 5, 0)

        

        logger(v.text, font2, x/2, y/2 + 15 * offset , v.a)

  

        offset = offset + math.min(v.a/40, 1)

    end

  end

    AntiaimSystem(cmd)

	change_viewmodel( )

	 keybindlist:draw()

end

function on_player_death(event)

    if tt:get_bool() then

    local lp = engine.get_local_player();

    local attacker = engine.get_player_for_user_id(event:get_int('attacker'));

    local userid = engine.get_player_for_user_id(event:get_int('userid'));

    local userInfo = engine.get_player_info(userid);

        if attacker == lp and userid ~= lp then

            engine.exec("say " .. first[utils.random_int(1, #first)])

        end

    else

    end

end

function on_player_hurt(e)

    local a = e:get_int("attacker")

    local a_idx = engine.get_player_for_user_id(a)

  

    if a_idx ~= engine.get_local_player() then return end

  

    local u_name = engine.get_player_info( engine.get_player_for_user_id( e:get_int("userid") ) ).name

    

    shots[#shots + 1] = {

        text = {

            {"[Hell.Yaw] Hit "}, 

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

function on_shutdown( )

    local pWeaponData = GetWeaponDataAddress(engine.get_local_player())

    if not pWeaponData then

        return

    end


    ffi.cast("bool*", tonumber(pWeaponData) + 0x1CD)[0] = true

	r_aspectratio:set_float(default_value)

end

function on_create_move(cmd)

    local index = engine.get_local_player()

    local player = entities.get_entity(index)


    if not (player and player:is_alive()) then

        return

    end


    local pointer = get_client_entity(index)


    local fFlags = player:get_prop('m_fFlags')

    local in_air = fFlags == 256 or fFlags == 262


    if in_air then

        was_in_air = true

    end


    is_moving = math.abs(player:get_prop('m_vecVelocity[0]') + player:get_prop('m_vecVelocity[1]')) > 3


    for i = 1, #anim_breaker_combo do

        if anim_breaker_combo[i]:get_bool() then

            anim_breakers[i](pointer)

        end

    end


    was_in_air = in_air

end
