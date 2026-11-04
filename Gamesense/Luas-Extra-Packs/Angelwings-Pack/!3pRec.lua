-- Регистрация элементов интерфейса в меню Skeet (Максимум увеличен до 200%)
local enable_cb = ui.new_checkbox("VISUALS", "Effects", "Thirdperson Recoil x2")
local pitch_slider = ui.new_slider("VISUALS", "Effects", "Recoil Pitch Factor", 0, 200, 100, true, "%")
local yaw_slider = ui.new_slider("VISUALS", "Effects", "Recoil Yaw Factor", 0, 200, 100, true, "%")

-- Хранение базовых углов
local last_pitch = 0
local last_yaw = 0

-- Основная функция, работающая каждый кадр
local function on_override_view(view)
    if not ui.get(enable_cb) then 
        return 
    end

    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then
        client.set_cvar("c_mindistance", 0)
        return 
    end

    -- Получение m_aimPunchAngle (вектор отдачи оружия)
    local punch_pitch, punch_yaw = entity.get_prop(local_player, "m_aimPunchAngle")
    
    if punch_pitch ~= nil and punch_yaw ~= nil then
        -- Рассчитываем силу смещения (значение 200% умножит отдачу в 2 раза)
        local modifier_pitch = ui.get(pitch_slider) / 100
        local modifier_yaw = ui.get(yaw_slider) / 100

        -- Сглаживание и интерполяция
        last_pitch = last_pitch + (punch_pitch * modifier_pitch - last_pitch) * 0.15
        last_yaw = last_yaw + (punch_yaw * modifier_yaw - last_yaw) * 0.15

        -- Применение увеличенных углов к камере
        view.pitch = view.pitch + last_pitch
        view.yaw = view.yaw + last_yaw
    else
        -- Плавный возврат камеры
        last_pitch = last_pitch * 0.9
        last_yaw = last_yaw * 0.9
        view.pitch = view.pitch + last_pitch
        view.yaw = view.yaw + last_yaw
    end
end

-- Сброс настроек при выгрузке скрипта
local function on_shutdown()
    client.set_cvar("c_maxpitch", 90)
    client.set_cvar("c_minpitch", -90)
end

-- Регистрация ивентов
client.set_event_callback("override_view", on_override_view)
client.set_event_callback("shutdown", on_shutdown)
