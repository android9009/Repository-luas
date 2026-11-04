local h,m,sm = 0,0,0;

local cb = fatality.callbacks

local render = fatality.render;

function shot_hit(s)
	if csgo.interface_handler:get_entity_list():get_player(s.victim) == nil then return end
	if s.hurt then
		h=h+1
	elseif not s.hurt and s.hit then
		m=m+1
	elseif not s.hit then
		sm = sm + 1
	end
end

function paint()
	if csgo.interface_handler:get_engine_client():is_in_game() then
		local screen_size = render:screen_size();
		render:indicator(screen_size.x / 110,screen_size.y / 2,"Hits: "..tostring(h),true,-1)
		render:indicator(screen_size.x / 110,screen_size.y / 2+24,"Misses: "..tostring(m+sm),true,-1)
		render:indicator(screen_size.x / 110,screen_size.y / 2+48,"Total: "..tostring(h+m+sm),true,-1)
		if h == 0 and m == 0 and sm == 0 then
			render:indicator(screen_size.x / 110,screen_size.y / 2+72,"Percent: 0.0%",true,-1)
		else
			render:indicator(screen_size.x / 110,screen_size.y / 2+72,"Percent: "..string.format("%.1f",(h/(m+sm+h)*100) or 0).."%",true,-1)
		end
	end
end

function event_handler(e)
	local evn = e:get_name()
	
	if evn == "round_announce_match_start" then
		h,m,sm = 0,0,0
	end
end

cb:add("registered_shot", shot_hit)
cb:add("paint",paint)
cb:add("events", event_handler)