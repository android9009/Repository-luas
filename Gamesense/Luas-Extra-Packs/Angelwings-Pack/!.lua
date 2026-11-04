-- Регистрация элементов интерфейса в меню Skeet (VISUALS -> Effects)
local enable_cb = ui.new_checkbox("VISUALS", "Effects", "3D Overhead Halo Ultimate")
local style_combo = ui.new_combobox("VISUALS", "Effects", "Halo Style", {
    "Holy Angel", "Orbit Rings", "Crown of Thorns", "Sinister Glitch",
    "Double DNA", "Pentagram Magic", "Shield Matrix", "Saturn Ring",
    "Angel Wings", "Eclipse Ring", "Shard Crown", "Pulse Web"
})
local color_picker = ui.new_color_picker("VISUALS", "Effects", "Halo Color", 255, 215, 0, 255)
local radius_slider = ui.new_slider("VISUALS", "Effects", "Halo Radius", 5, 45, 18, true, "px")
local height_slider = ui.new_slider("VISUALS", "Effects", "Halo Height Base", -60, 50, 22, true, "u")
local speed_slider = ui.new_slider("VISUALS", "Effects", "Animation Speed", 1, 10, 5, true, "x")
local width_slider = ui.new_slider("VISUALS", "Effects", "Halo Line Width", 1, 6, 2, true, "px")
local firstperson_cb = ui.new_checkbox("VISUALS", "Effects", "Hide in Firstperson")

local glow_cb = ui.new_checkbox("VISUALS", "Effects", "Enable Neon Glow")
local move_cb = ui.new_checkbox("VISUALS", "Effects", "Move Halo")
local amp_slider = ui.new_slider("VISUALS", "Effects", "Movement Amplitude", 1, 20, 5, true, "u")
local scope_alpha_slider = ui.new_slider("VISUALS", "Effects", "Scope Alpha Modifier", 0, 100, 30, true, "%")

-- Функция симуляции толщины линий
local function draw_custom_line(x1, y1, x2, y2, r, g, b, a, thickness)
    if thickness <= 1 then
        renderer.line(x1, y1, x2, y2, r, g, b, a)
    else
        local offset = thickness * 0.5
        for x_off = -offset, offset, 1 do
            for y_off = -offset, offset, 1 do
                renderer.line(x1 + x_off, y1 + y_off, x2 + x_off, y2 + y_off, r, g, b, a)
            end
        end
    end
end

-- Функция математического расчета геометрии точки нимба в зависимости от стиля
local function get_halo_point(i, segments, radius, style, time)
    local angle = (i / segments) * math.pi * 2
    local x, y, z = math.cos(angle) * radius, math.sin(angle) * radius, 0

    if style == "Holy Angel" then
        z = math.sin(time * 10) * 3
    elseif style == "Orbit Rings" then
        local tilt = 0.4 
        local rot = time * 8
        local nx = x * math.cos(rot) - y * math.sin(rot)
        local ny = x * math.sin(rot) + y * math.cos(rot)
        x, y, z = nx, ny * math.cos(tilt), ny * math.sin(tilt)
    elseif style == "Crown of Thorns" then
        local spike = radius * 0.15 * (i % 2 == 0 and 1 or -1)
        x, y = math.cos(angle) * (radius + spike), math.sin(angle) * (radius + spike)
    elseif style == "Sinister Glitch" then
        math.randomseed(math.floor(time * 50) + i)
        if math.random(1, 100) > 92 then
            local g_offset = math.random(-3, 3)
            x, y, z = x + g_offset, y + g_offset, z + g_offset
        end
    elseif style == "Double DNA" then
        z = math.sin(angle * 2 + time * 8) * 4
    elseif style == "Shield Matrix" then
        z = math.sin(angle + time * 6) * 2
    elseif style == "Saturn Ring" then
        local pulse_r = math.cos(time * 5) * 2
        x, y = math.cos(angle) * (radius + pulse_r), math.sin(angle) * (radius + pulse_r)
    elseif style == "Angel Wings" then
        local factor = 1.0 + math.abs(math.sin(angle)) * 0.4
        x, y = math.cos(angle) * (radius * factor), math.sin(angle) * (radius * factor)
        z = math.sin(time * 6 + angle) * 3
    elseif style == "Eclipse Ring" then
        local shift = math.sin(time * 4) * 6
        x, y = x + shift, y + shift
    elseif style == "Shard Crown" then
        local rot = time * 3
        x, y = x * math.cos(rot) - y * math.sin(rot), x * math.sin(rot) + y * math.cos(rot)
    end

    return x, y, z
end

-- Функция рендеринга 3D окружности
local function draw_3d_circle(center_x, center_y, center_z, radius, r, g, b, a, style, speed, is_glow_layer, glow_thickness, base_width, time)
    local segments = 32

    for i = 1, segments do
        local x1, y1, z1 = get_halo_point(i, segments, radius, style, time)
        local x2, y2, z2 = get_halo_point(i + 1, segments, radius, style, time)

        local should_draw = true
        if style == "Shard Crown" and (i % 4 == 0 or i % 5 == 0) then
            should_draw = false
        end

        if should_draw then
            -- Отрезки нитей паутины / звезды
            local is_valid_style = (style == "Pentagram Magic" or style == "Pulse Web")
            if not is_glow_layer and i % 6 == 0 and is_valid_style then
                local pulse_factor = 1.0
                if style == "Pulse Web" then
                    pulse_factor = 0.3 + math.abs(math.sin(time * 5)) * 0.5
                end
                
                local p_sx, p_sy = renderer.world_to_screen(center_x, center_y, center_z)
                local node_sx, node_sy = renderer.world_to_screen(center_x + x1 * pulse_factor, center_y + y1 * pulse_factor, center_z)
                if p_sx and node_sx then
                    draw_custom_line(p_sx, p_sy, node_sx, node_sy, r, g, b, math.floor(a * 0.4), 1)
                end
            end

            local sx1, sy1 = renderer.world_to_screen(center_x + x1, center_y + y1, center_z + z1)
            local sx2, sy2 = renderer.world_to_screen(center_x + x2, center_y + y2, center_z + z2)

            if sx1 and sy1 and sx2 and sy2 then
                if is_glow_layer then
                    draw_custom_line(sx1, sy1, sx2, sy2, r, g, b, a, glow_thickness)
                else
                    draw_custom_line(sx1, sy1, sx2, sy2, r, g, b, a, base_width)
                end
            end
        end
    end
end

-- Хук отрисовки
local function on_paint()
    if not ui.get(enable_cb) then return end

    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then return end

    local hx, hy, hz = entity.get_prop(local_player, "m_vecOrigin")
    if not hx then return end

    -- Проверка первого лица через вектор камеры
    if ui.get(firstperson_cb) then
        local cam_x, cam_y, cam_z = client.camera_position()
        if cam_x and cam_y and cam_z then
            local eye_z = hz + 64 
            local current_distance = math.sqrt((hx - cam_x)^2 + (hy - cam_y)^2 + (eye_z - cam_z)^2)
            if current_distance < 12 then return end
        end
    end
    
    local player_height = 68 
    local total_z = hz + player_height + ui.get(height_slider)
    local speed = ui.get(speed_slider)
    local base_width = ui.get(width_slider)
    local time = globals.curtime() * (speed * 0.2)

    -- Расчет левитации
    if ui.get(move_cb) then
        total_z = total_z + math.sin(globals.curtime() * (speed * 1.5)) * ui.get(amp_slider)
    end

    local r, g, b, a = ui.get(color_picker)

    -- Модификация прозрачности в зуме
    local is_scoped = entity.get_prop(local_player, "m_bIsScoped")
    if is_scoped == 1 or is_scoped == true then
        local modifier = ui.get(scope_alpha_slider) / 100
        a = math.floor(a * modifier)
    end

    if a <= 0 then return end

    local radius = ui.get(radius_slider)
    local current_style = ui.get(style_combo)

    -- 1. Слой свечения Glow
    if ui.get(glow_cb) then
        draw_3d_circle(hx, hy, total_z, radius, r, g, b, math.floor(a * 0.04), current_style, speed, true, base_width + 10, base_width, time)
        draw_3d_circle(hx, hy, total_z, radius, r, g, b, math.floor(a * 0.08), current_style, speed, true, base_width + 6, base_width, time)
        draw_3d_circle(hx, hy, total_z, radius, r, g, b, math.floor(a * 0.16), current_style, speed, true, base_width + 3, base_width, time)
    end

    -- 2. Основной слой
    draw_3d_circle(hx, hy, total_z, radius, r, g, b, a, current_style, speed, false, 1, base_width, time)

    -- Дополнительный рендер для стиля Double DNA
    if current_style == "Double DNA" then
        if ui.get(glow_cb) then
            draw_3d_circle(hx, hy, total_z - 2, radius, r, g, b, math.floor(a * 0.16), "Holy Angel", speed, true, base_width + 3, base_width, time)
        end
        draw_3d_circle(hx, hy, total_z - 2, radius, r, g, b, a, "Holy Angel", speed, false, 1, base_width, time)
    end
end

client.set_event_callback("paint", on_paint)
