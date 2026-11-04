local global_vars		= csgo.interface_handler:get_global_vars()
local entity_list		= csgo.interface_handler:get_entity_list()
local render			= fatality.render
local menu				= fatality.menu
local config			= fatality.config

local red_heart =
{
	{{r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 0, g = 0, b = 0, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 255, g = 132, b = 135, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 136, g = 0, b = 21, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 0, g = 0, b = 0, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 136, g = 0, b = 21, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 136, g = 0, b = 21, a = 255}, {r = 0, g = 0, b = 0, a = 255}, },
	{{r = 0, g = 0, b = 0, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 136, g = 0, b = 21, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 0, g = 0, b = 0, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 136, g = 0, b = 21, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 237, g = 28, b = 36, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
}

local green_heart =
{
	{{r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 0, g = 0, b = 0, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 99, g = 228, b = 124, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 16, g = 92, b = 31, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 0, g = 0, b = 0, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 16, g = 92, b = 31, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 16, g = 92, b = 31, a = 255}, {r = 0, g = 0, b = 0, a = 255}, },
	{{r = 0, g = 0, b = 0, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 16, g = 92, b = 31, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 0, g = 0, b = 0, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 16, g = 92, b = 31, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 31, g = 180, b = 61, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
}

local yellow_heart =
{
	{{r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 0, g = 0, b = 0, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 249, g = 253, b = 96, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 149, g = 153, b = 2, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 0, g = 0, b = 0, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 149, g = 153, b = 2, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 149, g = 153, b = 2, a = 255}, {r = 0, g = 0, b = 0, a = 255}, },
	{{r = 0, g = 0, b = 0, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 149, g = 153, b = 2, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 0, g = 0, b = 0, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 149, g = 153, b = 2, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 220, g = 225, b = 4, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
}

local orange_heart =
{
	{{r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 249, g = 253, b = 96, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 193, g = 78, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 193, g = 78, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 193, g = 78, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, },
	{{r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 193, g = 78, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 193, g = 78, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 255, g = 127, b = 39, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
	{{r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 0, g = 0, b = 0, a = 255}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, {r = 255, g = 255, b = 255, a = 0}, },
}

local heartmarker_cfg	= config:add_item("p9_heartmarker", 1)
local heartmarker_ref	= menu:add_combo("Heartmarker", "VISUALS", "MISC", "Various", heartmarker_cfg)
heartmarker_ref:add_item("Off", heartmarker_cfg)
heartmarker_ref:add_item("Damage based", heartmarker_cfg)
heartmarker_ref:add_item("Red", heartmarker_cfg)

local hearts = {}

function draw_heart(pic, x, y, scale, alpha)
	for i = 1, #pic do
		for j = 1, #pic[i] do
			-- don't draw white background color
			if(pic[j][i].r + pic[j][i].g + pic[j][i].b == 255 * 3) then
				render:rect_filled(x + (j-1) * scale, y + (i-1) * scale, scale, scale, csgo.color(pic[j][i].r, pic[j][i].g, pic[j][i].b, 0))
			else
				render:rect_filled(x + (j-1) * scale, y + (i-1) * scale, scale, scale, csgo.color(pic[j][i].r, pic[j][i].g, pic[j][i].b, alpha))
			end			
		end
	end
end

fatality.callbacks:add("registered_shot", function(e)
	enemy = entity_list:get_player(e.victim)
	if(enemy == nil) then
		return end
		
	if(e.hurt) then
		table.insert(hearts, {
				hitpos = csgo.vector3(e.hitpos.x, e.hitpos.y, e.hitpos.z),
				damage = e.hit_damage,
				start_time = global_vars.realtime,
				frame_time = global_vars.realtime
			})
	end
end)

fatality.callbacks:add("paint", function()
	if(heartmarker_cfg:get_int() == 0) then
		return end
	
	local realtime = global_vars.realtime
	
	for i = 1, #hearts do
		if(hearts[i] == nil) then
			return end
			
		local hitpos = csgo.vector3(hearts[i].hitpos.x, hearts[i].hitpos.y, hearts[i].hitpos.z)
		
		local alpha = math.floor(255 - 255 * (realtime - hearts[i].start_time))
		if(realtime - hearts[i].start_time >= 1) then
			alpha = 0
		end
		
		if(hitpos:to_screen()) then
			if(heartmarker_cfg:get_int() == 1) then
				if(hearts[i].damage <= 15) then
					draw_heart(green_heart, hitpos.x - 8, hitpos.y - 8, 2, alpha)
				elseif(hearts[i].damage <= 30) then
					draw_heart(yellow_heart, hitpos.x - 8, hitpos.y - 8, 2, alpha)
				elseif(hearts[i].damage <= 60) then
					draw_heart(orange_heart, hitpos.x - 8, hitpos.y - 8, 2, alpha)
				else
					draw_heart(red_heart, hitpos.x - 8, hitpos.y - 8, 2, alpha)
				end
			else
				draw_heart(red_heart, hitpos.x - 8, hitpos.y - 8, 2, alpha)
			end
		end
		
		hearts[i].hitpos.z = hearts[i].hitpos.z + (realtime - hearts[i].frame_time) * 50
		hearts[i].frame_time = realtime
		
		if(realtime - hearts[i].start_time >= 1) then
			table.remove(hearts, i)
		end
	end
end)