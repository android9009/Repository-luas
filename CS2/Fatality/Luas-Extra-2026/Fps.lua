--Made by DerLi
--YouGame: https://yougame.biz/members/181265/
--Discord: DerLi#0238
--Stay Invise.pw
--Have fun, and fps :D
local engine_client = csgo.interface_handler:get_engine_client()
local cvar = csgo.interface_handler:get_cvar()
local config = fatality.config
local menu = fatality.menu
local interface_cvar = csgo.interface_handler:get_cvar( )
local var = interface_cvar:find_var( "sv_cheats" )
-----------------------------------------------------------------
local Sky = cvar:find_var( "r_3dsky");
local Shadows = cvar:find_var( "cl_csm_enabled");
local Shadows1 = cvar:find_var( "r_shadows");
local Shadows2 = cvar:find_var( "cl_csm_static_prop_shadows");
local Shadows3 = cvar:find_var( "cl_csm_shadows");
local Shadows4 = cvar:find_var( "cl_csm_world_shadows");
local Shadows5 = cvar:find_var( "cl_foot_contact_shadows");
local Shadows6 = cvar:find_var( "cl_csm_viewmodel_shadows");
local Shadows7 = cvar:find_var( "cl_csm_rope_shadows");
local Shadows8 = cvar:find_var( "cl_csm_sprite_shadows");
local PostProcess = cvar:find_var( "mat_postprocess_enable");
local Water_fog = cvar:find_var( "fog_enable_water_fog");
local Queue = cvar:find_var( "mat_queue_mode");
local Decals = cvar:find_var( "r_drawdecals");
local Draw_rain = cvar:find_var( "r_drawrain");
local Draw_rope = cvar:find_var( "r_drawropes");
local Draw_spirtes = cvar:find_var ( "r_drawsprites");
--Other--
local Help = cvar:find_var( "cl_showhelp");
local Auto_help = cvar:find_var( "cl_autohelp");
local Disable_html = cvar:find_var( "cl_disablehtmlmotd");
local Instructor = cvar:find_var( "gameinstructor_enable");
--Cam--
local Freeze_cam = cvar:find_var( "cl_disablefreezecam");
local Freeze_pos = cvar:find_var( "cl_freezecampanel_position_dynamic");
local Freeze_cam_effects = cvar:find_var( "cl_freezecameffects_showholiday");
--FPS--
local Fps_max = cvar:find_var( "fps_max");
local Fps_max_menu = cvar:find_var( "fps_max_menu");
-----------------------------------------------------------------
if var:get_int( ) == 0 then
    var:unlock( )
    var:set_int( 1 )
end
-----------------------------------------------------------------
fatality.callbacks:add("paint", function()
    if(not engine_client:is_in_game()) then
        return
    else
	    Sky:set_int(0)
		Shadows:set_int(0)
		Shadows1:set_int(0)
		Shadows2:set_int(0)
		Shadows3:set_int(0)
		Shadows4:set_int(0)
		Shadows5:set_int(0)
		Shadows6:set_int(0)
		Shadows7:set_int(0)
		Shadows8:set_int(0)
		PostProcess:set_int(0)
		Water_fog:set_int(0)
		Queue:set_int(-1)
		Decals:set_int(0)
		Draw_rain:set_int(0)
		Draw_rope:set_int(0)
		Draw_spirtes:set_int(0)
		--Other--
		Help:set_int(0)
		Auto_help:set_int(0)
		Disable_html:set_int(0)
		Instructor:set_int(0)
		--Cam--
		Freeze_cam:set_int(0)
		Freeze_pos:set_int(0)
		Freeze_cam_effects:set_int(0)
		--FPS--
		Fps_max:set_int(70)
		Fps_max_menu:set_int(60)
    end
end)