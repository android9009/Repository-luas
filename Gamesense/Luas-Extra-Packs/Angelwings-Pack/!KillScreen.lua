-- ==============================================================================
-- ★ MIDAS AIM LOGGER v2.4 ★ — Плавное всё, drag работает, виден в меню
-- ==============================================================================

local ENABLED = true
local DISPLAY_DURATION = 4.0
local ANIMATION_SPEED = 0.25
local MAX_ENTRIES = 10
local BOX_WIDTH = 290
local HIDE_TIMEOUT = 3.0

local ANIMATION_TYPE = "left"

-- Позиция
local panel_x = 8
local panel_y = 6
local panel_header_h = 20

-- Drag
local dragging = false
local drag_offset_x = 0
local drag_offset_y = 0

-- ============================== ЦВЕТА ==============================
local COLORS = {
    hit_accent = {100, 255, 100, 255},
    hit_damage = {150, 255, 150, 255},
    miss_accent = {255, 80, 80, 255},
    miss_reason = {255, 140, 100, 255},
    bg = {12, 12, 15, 225},
    bg_header = {15, 15, 20, 240},
    header_drag_hint = {100, 160, 255, 200},
    separator = {35, 35, 45, 180},
    text_white = {240, 240, 245, 255},
    text_dim = {160, 160, 170, 200},
}

local HITGROUPS = {
    [0] = "Body", [1] = "Head", [2] = "Chest", [3] = "Stomach",
    [4] = "L. Arm", [5] = "R. Arm", [6] = "L. Leg", [7] = "R. Leg", [8] = "Neck",
}

local MISS_REASONS = {
    spread = "Spread", resolver = "Resolver", prediction = "Prediction",
    occlusion = "Occlusion", death = "Dead", dormant = "Dormant",
    smoke = "Smoke", distance = "Range", autowall = "Wall", unknown = "?",
}

-- ============================== СОСТОЯНИЕ ==============================
local entries = {}
local total_hits = 0
local total_misses = 0
local last_hit_time = 0
local last_hit_target = 0
local last_miss_time = 0
local DUPLICATE_WINDOW = 0.15
local last_entry_time = 0
local panel_alpha = 0
local target_panel_alpha = 0

-- Флаг: открыто ли меню чита
local menu_open = false

-- ============================== ХЕЛПЕРЫ ==============================

local function draw_rect(x, y, w, h, r, g, b, a)
    renderer.rectangle(x, y, w, h, r, g, b, a)
end

local function draw_text(x, y, r, g, b, a, flags, size, text)
    if not text or text == "" then return end
    pcall(function() renderer.text(x, y, r, g, b, a, flags or "", size or 0, text) end)
end

-- Получение позиции мыши
local function get_mouse_pos()
    -- Способ 1: ui.mouse_position (работает в меню)
    local mx, my = 0, 0
    pcall(function()
        local x, y = ui.mouse_position()
        if x then mx, my = x, y end
    end)
    
    -- Способ 2: globals
    if mx == 0 and my == 0 then
        pcall(function()
            mx = globals.real_mouse_x()
            my = globals.real_mouse_y()
        end)
    end
    
    -- Способ 3: прямой опрос через screen_size и key_state
    -- (используем постоянный трекинг в paint)
    
    return mx, my
end

-- ============================== АНТИ-ДУБЛИКАТ ==============================
local function is_duplicate_hit(target)
    local now = globals.realtime()
    if now - last_hit_time < DUPLICATE_WINDOW and target == last_hit_target then
        return true
    end
    last_hit_time = now
    last_hit_target = target
    return false
end

-- ============================== АНИМАЦИИ ==============================

local function ease_out_expo(t) return t >= 1 and 1 or 1 - 2 ^ (-10 * t) end
local function ease_in_expo(t) return t <= 0 and 0 or 2 ^ (10 * (t - 1)) end
local function ease_in_out(t) return t < 0.5 and 2 * t * t or 2 * t * (2 - t) - 1 end

local function get_entry_alpha(entry, now)
    local age = now - entry.time
    if age < ANIMATION_SPEED then return ease_out_expo(age / ANIMATION_SPEED) end
    if age < DISPLAY_DURATION - ANIMATION_SPEED then return 1.0 end
    if age < DISPLAY_DURATION then return 1.0 - ease_in_expo((age - (DISPLAY_DURATION - ANIMATION_SPEED)) / ANIMATION_SPEED) end
    return 0.0
end

local function get_anim_offset(entry, now)
    local age = now - entry.time
    local ox, oy = 0, 0
    
    if ANIMATION_TYPE == "left" then
        if age < ANIMATION_SPEED then ox = -50 + 50 * ease_out_expo(age / ANIMATION_SPEED) end
    elseif ANIMATION_TYPE == "right" then
        if age < ANIMATION_SPEED then ox = 50 - 50 * ease_out_expo(age / ANIMATION_SPEED) end
    elseif ANIMATION_TYPE == "bottom" then
        if age < ANIMATION_SPEED then oy = 25 - 25 * ease_out_expo(age / ANIMATION_SPEED) end
    end
    
    return ox, oy
end

-- ПЛАВНОЕ появление/исчезновение панели
local function update_panel_alpha(now)
    local should_show = false
    
    -- Показываем если меню открыто (для драга)
    if menu_open then
        should_show = true
    end
    
    -- Или есть свежие записи
    if #entries > 0 and (now - last_entry_time) < HIDE_TIMEOUT then
        should_show = true
    end
    
    -- Или драгаем
    if dragging then
        should_show = true
    end
    
    target_panel_alpha = should_show and 1.0 or 0.0
    
    -- ПЛАВНЫЙ переход (lerp)
    local speed = 0.06  -- меньше = плавнее
    panel_alpha = panel_alpha + (target_panel_alpha - panel_alpha) * speed
    
    -- Фикс: если разница очень маленькая — приравниваем
    if math.abs(target_panel_alpha - panel_alpha) < 0.001 then
        panel_alpha = target_panel_alpha
    end
end

-- ============================== DRAG ==============================

local function is_mouse_in_header(mx, my)
    return mx >= panel_x and mx <= panel_x + BOX_WIDTH 
       and my >= panel_y and my <= panel_y + panel_header_h
end

-- Отслеживание позиции мыши через paint (постоянный трекинг)
local last_mx = 0
local last_my = 0
local mouse_moved = false

-- ============================== ДОБАВЛЕНИЕ ЗАПИСЕЙ ==============================

local function add_hit(target, hitgroup, damage, backtrack)
    if is_duplicate_hit(target) then return end
    table.insert(entries, 1, {
        type = "hit", time = globals.realtime(),
        target = target, hitgroup = hitgroup, damage = damage, backtrack = backtrack,
    })
    while #entries > 50 do table.remove(entries) end
    total_hits = total_hits + 1
    last_entry_time = globals.realtime()
end

local function add_miss(target, reason, resolver)
    local now = globals.realtime()
    if now - last_miss_time < DUPLICATE_WINDOW then return end
    last_miss_time = now
    table.insert(entries, 1, {
        type = "miss", time = now,
        target = target, reason = reason, resolver_state = resolver,
    })
    while #entries > 50 do table.remove(entries) end
    total_misses = total_misses + 1
    last_entry_time = globals.realtime()
end

-- ============================== ОБРАБОТЧИКИ ==============================

client.set_event_callback("aim_hit", function(e)
    if not ENABLED then return end
    add_hit(entity.get_player_name(e.target) or "?", e.hitgroup or 0, e.damage or 0, e.backtrack or 0)
end)

client.set_event_callback("aim_miss", function(e)
    if not ENABLED then return end
    add_miss(entity.get_player_name(e.target) or "?", e.reason or "unknown", e.resolver_state or "")
end)

client.set_event_callback("player_hurt", function(e)
    if not ENABLED then return end
    local attacker = client.userid_to_entindex(e.attacker)
    if attacker ~= entity.get_local_player() then return end
    local victim = client.userid_to_entindex(e.userid)
    if not victim or not entity.is_enemy(victim) then return end
    add_hit(entity.get_player_name(victim) or "?", e.hitgroup or 0, e.dmg_health or 0, 0)
end)

-- ============================== ОТСЛЕЖИВАНИЕ МЕНЮ ==============================

-- Проверяем открыто ли меню чита (пробуем разные способы)
local function check_menu_open()
    -- Способ 1: через ui.is_menu_open
    pcall(function()
        if ui.is_menu_open then
            menu_open = ui.is_menu_open()
        end
    end)
    
    -- Способ 2: проверяем видимость какого-нибудь элемента меню
    if not menu_open then
        pcall(function()
            -- Пробуем получить состояние меню через референс
            local test = ui.find("LUA", "A")
            if test then
                menu_open = ui.is_menu_open()
            end
        end)
    end
    
    -- Способ 3: по клавише (INSERT обычно открывает меню)
    if client.key_state(0x2D) then  -- VK_INSERT
        menu_open = not menu_open
    end
end

-- ============================== PAINT ==============================

client.set_event_callback("paint", function()
    if not ENABLED then return end
    
    local now = globals.realtime()
    local sw, sh = client.screen_size()
    
    -- Получаем позицию мыши
    local mx, my = get_mouse_pos()
    
    -- Если ui.mouse_position не работает — используем отслеживание через движения
    if mx == 0 and my == 0 then
        -- Используем последние известные координаты
        mx, my = last_mx, last_my
    else
        last_mx = mx
        last_my = my
    end
    
    -- Проверяем меню
    check_menu_open()
    
    -- Обновляем плавность панели
    update_panel_alpha(now)
    
    -- Чистим старые записи
    for i = #entries, 1, -1 do
        if now - entries[i].time > DISPLAY_DURATION then
            table.remove(entries, i)
        end
    end
    
    -- Обработка драга
    local mouse_down = client.key_state(0x01)  -- левая кнопка
    
    if mouse_down and not dragging then
        if is_mouse_in_header(mx, my) and panel_alpha > 0.3 then
            dragging = true
            drag_offset_x = mx - panel_x
            drag_offset_y = my - panel_y
            client.exec("-attack; -attack2")
        end
    elseif not mouse_down and dragging then
        dragging = false
    end
    
    if dragging then
        panel_x = mx - drag_offset_x
        panel_y = my - drag_offset_y
        panel_x = math.max(0, math.min(panel_x, sw - BOX_WIDTH))
        panel_y = math.max(0, math.min(panel_y, sh - 100))
        
        -- Каждые 500мс отпускаем атаку
        if math.floor(now * 2) % 2 == 0 then
            client.exec("-attack; -attack2")
        end
    end
    
    -- Если панель невидима — не рисуем
    if panel_alpha < 0.005 and not dragging then return end
    
    local pa = panel_alpha
    
    -- Считаем записи для отображения
    local visible_count = math.min(#entries, MAX_ENTRIES)
    if visible_count == 0 and not menu_open and not dragging then
        -- Нет записей, меню закрыто, не драгаем — скрываем
        if pa < 0.01 then return end
    end
    
    -- === ХЕДЕР ===
    if pa > 0.01 then
        draw_rect(panel_x, panel_y, BOX_WIDTH, panel_header_h,
            COLORS.bg_header[1], COLORS.bg_header[2], COLORS.bg_header[3],
            math.floor(COLORS.bg_header[4] * pa))
        
        -- Подсветка при наведении
        if is_mouse_in_header(mx, my) or dragging then
            draw_rect(panel_x, panel_y, BOX_WIDTH, panel_header_h,
                COLORS.header_drag_hint[1], COLORS.header_drag_hint[2], COLORS.header_drag_hint[3],
                math.floor(35 * pa))
        end
        
        local accuracy = total_hits + total_misses > 0
            and math.floor(total_hits / (total_hits + total_misses) * 100) or 0
        local ht = string.format("aim log  •  %dh / %dm  •  %d%%", total_hits, total_misses, accuracy)
        draw_text(panel_x + 8, panel_y + 4,
            COLORS.text_dim[1], COLORS.text_dim[2], COLORS.text_dim[3], math.floor(220 * pa),
            "", 0, ht)
        
        local hint = dragging and "dragging..." or (is_mouse_in_header(mx, my) and "drag me" or "")
        if hint ~= "" then
            draw_text(panel_x + BOX_WIDTH - 8, panel_y + 4,
                COLORS.header_drag_hint[1], COLORS.header_drag_hint[2], COLORS.header_drag_hint[3],
                math.floor(180 * pa), "br", 0, hint)
        end
    end
    
    -- === ЗАПИСИ ===
    local y = panel_y + panel_header_h + 2
    
    for i = 1, visible_count do
        local entry = entries[i]
        local alpha = get_entry_alpha(entry, now) * pa
        local ox, oy = get_anim_offset(entry, now)
        
        if alpha > 0.005 then
            local ax = panel_x + ox
            local ay = y + oy
            local h = 28
            
            if entry.type == "hit" then
                draw_rect(ax, ay, BOX_WIDTH, h, COLORS.bg[1], COLORS.bg[2], COLORS.bg[3],
                    math.floor(COLORS.bg[4] * alpha))
                draw_rect(ax, ay + 4, 2, h - 8,
                    COLORS.hit_accent[1], COLORS.hit_accent[2], COLORS.hit_accent[3],
                    math.floor(COLORS.hit_accent[4] * alpha))
                draw_rect(ax + 8, ay + h - 1, BOX_WIDTH - 16, 1,
                    COLORS.separator[1], COLORS.separator[2], COLORS.separator[3],
                    math.floor(COLORS.separator[4] * alpha * 0.5))
                
                draw_text(ax + 14, ay + 7, COLORS.hit_accent[1], COLORS.hit_accent[2], COLORS.hit_accent[3],
                    math.floor(255 * alpha), "", 0, "HIT")
                draw_text(ax + 48, ay + 7, COLORS.text_white[1], COLORS.text_white[2], COLORS.text_white[3],
                    math.floor(COLORS.text_white[4] * alpha), "", 0, entry.target)
                
                local dmg = "-" .. entry.damage
                draw_text(ax + BOX_WIDTH - 8, ay + 7, COLORS.hit_damage[1], COLORS.hit_damage[2], COLORS.hit_damage[3],
                    math.floor(COLORS.hit_damage[4] * alpha), "br", 0, dmg)
                
                local hg = HITGROUPS[entry.hitgroup] or ""
                draw_text(ax + BOX_WIDTH - 8 - #dmg * 8 - 16, ay + 7,
                    COLORS.text_dim[1], COLORS.text_dim[2], COLORS.text_dim[3],
                    math.floor(COLORS.text_dim[4] * alpha), "br", 0, hg)
            else
                draw_rect(ax, ay, BOX_WIDTH, h, COLORS.bg[1], COLORS.bg[2], COLORS.bg[3],
                    math.floor(COLORS.bg[4] * alpha))
                draw_rect(ax, ay + 4, 2, h - 8,
                    COLORS.miss_accent[1], COLORS.miss_accent[2], COLORS.miss_accent[3],
                    math.floor(COLORS.miss_accent[4] * alpha))
                draw_rect(ax + 8, ay + h - 1, BOX_WIDTH - 16, 1,
                    COLORS.separator[1], COLORS.separator[2], COLORS.separator[3],
                    math.floor(COLORS.separator[4] * alpha * 0.5))
                
                draw_text(ax + 14, ay + 7, COLORS.miss_accent[1], COLORS.miss_accent[2], COLORS.miss_accent[3],
                    math.floor(255 * alpha), "", 0, "MISS")
                draw_text(ax + 56, ay + 7, COLORS.text_white[1], COLORS.text_white[2], COLORS.text_white[3],
                    math.floor(COLORS.text_white[4] * alpha), "", 0, entry.target)
                
                local reason = MISS_REASONS[entry.reason] or entry.reason or "?"
                draw_text(ax + BOX_WIDTH - 8, ay + 7, COLORS.miss_reason[1], COLORS.miss_reason[2], COLORS.miss_reason[3],
                    math.floor(COLORS.miss_reason[4] * alpha), "br", 0, reason)
            end
        end
        
        y = y + 29
    end
end)

-- ============================== UI ==============================

pcall(function()
    local refs = {}
    
    refs.enable = ui.new_checkbox("LUA", "A", "Aim Logger")
    ui.set(refs.enable, ENABLED)
    ui.set_callback(refs.enable, function() ENABLED = ui.get(refs.enable) end)
    
    refs.anim = ui.new_combobox("LUA", "A", "Animation", {"Fade", "Left", "Right", "Bottom"})
    local anim_map = {Fade = "fade", Left = "left", Right = "right", Bottom = "bottom"}
    ui.set(refs.anim, ANIMATION_TYPE:gsub("^%l", string.upper))
    ui.set_callback(refs.anim, function()
        ANIMATION_TYPE = anim_map[ui.get(refs.anim)] or "fade"
    end)
    
    refs.speed = ui.new_slider("LUA", "A", "Anim speed", 0, 100, ANIMATION_SPEED * 100, true, "%")
    ui.set_callback(refs.speed, function()
        ANIMATION_SPEED = ui.get(refs.speed) / 100
    end)
    
    refs.hide_time = ui.new_slider("LUA", "A", "Hide after (s)", 1, 10, HIDE_TIMEOUT, true, "%.0f")
    ui.set_callback(refs.hide_time, function()
        HIDE_TIMEOUT = ui.get(refs.hide_time)
    end)
    
    refs.hit_c = ui.new_color_picker("LUA", "A", "Hit color",
        COLORS.hit_accent[1], COLORS.hit_accent[2], COLORS.hit_accent[3], COLORS.hit_accent[4])
    ui.set_callback(refs.hit_c, function()
        local r, g, b, a = ui.get(refs.hit_c)
        COLORS.hit_accent = {r, g, b, a}
        COLORS.hit_damage = {r, g, b, math.floor(a * 0.8)}
    end)
    
    refs.miss_c = ui.new_color_picker("LUA", "A", "Miss color",
        COLORS.miss_accent[1], COLORS.miss_accent[2], COLORS.miss_accent[3], COLORS.miss_accent[4])
    ui.set_callback(refs.miss_c, function()
        local r, g, b, a = ui.get(refs.miss_c)
        COLORS.miss_accent = {r, g, b, a}
        COLORS.miss_reason = {r, math.floor(g * 0.7), math.floor(b * 0.5), math.floor(a * 0.9)}
    end)
    
    refs.reset = ui.new_button("LUA", "A", "Reset", function()
        total_hits = 0; total_misses = 0; entries = {}
    end)
end)

-- ============================== ГОТОВО ==============================
client.color_log(100, 255, 100, "[aim log] v2.4 — плавный fade + drag в меню\0")
