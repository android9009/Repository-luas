local ffi = require("ffi")
ffi.cdef[[
    typedef struct  {
		float x;
		float y;
		float z;	
	}vec3_t;
    struct beam_info_t {
        int			m_type;
        void* m_start_ent;
        int			m_start_attachment;
        void* m_end_ent;
        int			m_end_attachment;
        vec3_t		m_start;
        vec3_t		m_end;
        int			m_model_index;
        const char	*m_model_name;
        int			m_halo_index;
        const char	*m_halo_name;
        float		m_halo_scale;
        float		m_life;
        float		m_width;
        float		m_end_width;
        float		m_fade_length;
        float		m_amplitude;
        float		m_brightness;
        float		m_speed;
        int			m_start_frame;
        float		m_frame_rate;
        float		m_red;
        float		m_green;
        float		m_blue;
        bool		m_renderable;
        int			m_num_segments;
        int			m_flags;
        vec3_t		m_center;
        float		m_start_radius;
        float		m_end_radius;
    };
    typedef void (__thiscall* draw_beams_t)(void*, void*);
    typedef void*(__thiscall* create_beam_points_t)(void*, struct beam_info_t&);
]]

local render_beams_signature = "\xB9\xCC\xCC\xCC\xCC\xA1\xCC\xCC\xCC\xCC\xFF\x10\xA1\xCC\xCC\xCC\xCC\xB9"
local match = client.find_signature("client_panorama.dll", render_beams_signature) or error("render_beams_signature not found")
local render_beams = ffi.cast('void**', ffi.cast("char*", match) + 1)[0] or error("render_beams is nil") 
local render_beams_class = ffi.cast("void***", render_beams)
local render_beams_vtbl = render_beams_class[0]

local draw_beams = ffi.cast("draw_beams_t", render_beams_vtbl[6]) or error("couldn't cast draw_beams_t", 2)
local create_beam_points = ffi.cast("create_beam_points_t", render_beams_vtbl[12]) or error("couldn't cast create_beam_points_t", 2)

local local_player_bullet_beams = ui.new_checkbox("visuals", "Effects", "Local player bullet beams")
local local_player_bullet_beams_color = ui.new_color_picker("visuals", "Effects", "Local player bullet beams color", 150, 130, 255, 255)
local local_player_bullet_beams_style = ui.new_combobox("visuals", "effects", "\nstyle", {"Skeet", "Beam"})
local local_player_bullet_beams_thickness = ui.new_slider("visuals", "effects", "\nthickness", 10, 50, 20,  true, nil, .1)

local get_local_player = entity.get_local_player
local get_prop = entity.get_prop
local userid_to_entindex = client.userid_to_entindex
local eye_position = client.eye_position
local bor = bit.bor
local new = ffi.new
local get = ui.get

local function create_beams(startpos, red, green, blue, alpha)
    local beam_info = new("struct beam_info_t")
    beam_info.m_type = 0x00
    beam_info.m_model_index = -1
    beam_info.m_halo_scale = 0

    beam_info.m_life = 2
    beam_info.m_fade_length = 1

    beam_info.m_width = get(local_player_bullet_beams_thickness) * .1 -- multiplication is faster than division
    beam_info.m_end_width = get(local_player_bullet_beams_thickness) * .1 -- multiplication is faster than division

    if get(local_player_bullet_beams_style) == "Skeet" then 
        beam_info.m_model_name = "sprites/purplelaser1.vmt"    
    elseif get(local_player_bullet_beams_style) == "Beam" then 
        beam_info.m_model_name = "sprites/physbeam.vmt"
    end

    beam_info.m_amplitude = 2.3
    beam_info.m_speed = 0.2

    beam_info.m_start_frame = 0
    beam_info.m_frame_rate = 0

    beam_info.m_red = red 
    beam_info.m_green = green
    beam_info.m_blue = blue
    beam_info.m_brightness = alpha

    beam_info.m_num_segments = 2
    beam_info.m_renderable = true

    beam_info.m_flags = bor(0x00000100 + 0x00000200 + 0x00008000)

    beam_info.m_start = startpos
    beam_info.m_end = { eye_position() }

    local beam = create_beam_points(render_beams_class, beam_info) 
    if beam ~= nil then 
        draw_beams(render_beams, beam)
    end
end

client.set_event_callback("bullet_impact", function(e)
    if userid_to_entindex(e.userid) == get_local_player() and get(local_player_bullet_beams) then 
        local r,g,b,a = get(local_player_bullet_beams_color)
        create_beams({e.x, e.y, e.z}, r, g, b, a)
    end
end)