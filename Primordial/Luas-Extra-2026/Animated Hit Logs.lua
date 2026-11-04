local main_font = render.create_font("Arial", 14, 200, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local warning_font = render.create_font("tables", 50, 100, e_font_flags.ANTIALIAS)
local interval = 0

local function rgb_health_based(percentage)
    local r = math.floor(124*2 - 124 * percentage)
    local g = math.floor(195 * percentage)
    local b = math.floor(13)
    return r, g, b
end

local function remap(val, newmin, newmax, min, max, clamp)
    min = min or 0
    max = max or 1

    local pct = (val-min)/(max-min)

    if clamp ~= false then
        pct = math.min(1, math.max(0, pct))
    end

    return newmin+(newmax-newmin)*pct
end

local function drawBar(modifier, r, g, b, a, text)
	interval = interval + (1-modifier) * 0.7 + 0.3
	local wa = math.floor(math.abs(interval*0.025 % 2 - 1) * 255)
	
	local screen = render.get_screen_size()
	local x, y = screen.x / 2 - 95, screen.y*0.35
    
    render.triangle_filled(vec2_t.new(x + 30, y + 15), 32, color_t(0, 0, 0, 255))
	render.triangle_filled(vec2_t.new(x + 30, y + 15), 32, color_t(r, g, b, wa))
	render.text(warning_font, "I", vec2_t.new(x + 10, y - 25), color_t(0, 0, 0, 255))
    render.text(main_font, string.format("%s %d%%", text, modifier * 100), vec2_t.new(x + 57, y - 15), color_t.new(255, 255, 255, 255 * a))

	local rx, ry, rw, rh = x + 55, y, 95, 12
	render.rect(vec2_t.new(rx, ry), vec2_t.new(rw + 1, rh), color_t.new(0, 0, 0, 255))
    render.rect_filled(vec2_t.new(rx + 1, ry + 1), vec2_t.new(rw - 1, rh - 2), color_t.new(16, 16, 16, 180 * a))
    render.rect_filled(vec2_t.new(rx + 1, ry + 1), vec2_t.new(math.floor(modifier * 94), rh-2), color_t.new(r, g, b, 180 * a))
end

callbacks.add(e_callbacks.PAINT, function()
	local lp = entity_list.get_local_player()
    if not lp or lp:get_prop("m_lifeState") ~= 0 then return end

	local modifier = lp:get_prop("m_flVelocityModifier")
	if modifier == 1 then return end

    local r, g, b = rgb_health_based(modifier)
    local a = math.floor(remap(modifier, 1, 0, 1, 1))
	drawBar(modifier, r, g, b, a, "Slowed down")
end)

local logs = {}
local fonts = nil

local function onPaint()
    if(fonts == nil) then
        fonts =
        {
            regular = render.create_font("Verdana", 12, 1, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW);
            bold = render.create_font("Verdana Bold", 12, 1, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW);
        }
    end

    if (engine.is_connected() ~= true) then
        return
    end

    local time = global_vars.frame_time()

    local screenSize = render.get_screen_size()
    local screenWidth = screenSize.x
    local screenHeight = screenSize.y

    for i = 1, #logs do
        local log = logs[i]
        if log == nil then goto continue
        end
        local x = screenWidth / 2
        local y = screenHeight / 1.25 + (i * 15)
        local alpha = 0

        if (log.state == 'appearing') then
            -- Fade in.
            local progress = log.currentTime / log.lifeTime.fadeIn
            x = x - Lerp(log.offset, 0, Ease(progress))
            alpha = Lerp(0, 255, Ease(progress))

            log.currentTime = log.currentTime + time
            if (log.currentTime >= log.lifeTime.fadeIn) then
                log.state = 'visible'

                -- Reset time.
                log.currentTime = 0
            end


        elseif(log.state == 'visible') then
        -- Fully opaque.
        alpha = 255

        log.currentTime = log.currentTime + time
        if (log.currentTime >= log.lifeTime.visible) then
            log.state = 'disappearing'

            -- Reset Time.
            log.currentTime = 0
        end

        elseif(log.state == 'disappearing') then
            -- Fade out.
            local progress = log.currentTime / log.lifeTime.fadeOut
            x = x + Lerp(0, log.offset, Ease(progress))
            alpha = Lerp(255, 0, Ease(progress))

            log.currentTime = log.currentTime + time
            if(log.currentTime >= log.lifeTime.fadeOut) then
                table.remove(logs, i)
                goto continue
            end
        end

        -- Increase the total time.
        log.totalTime = log.totalTime + time

        alpha = math.floor(alpha)
        local white = color_t(236, 236, 236, alpha)
        local accent_color_text, accent_color_color = unpack(menu.find("misc", "main", "config", "accent color"))
        local detail = accent_color_color:get()
        detail.a = alpha

        local message = {}

        -- Add header and body to message
        local combined = {}

        for a = 1, #log.header do
            local t = log.header[a]
            table.insert(combined, t)
        end

        for a = 1, #log.body do
            local t = log.body[a]
            table.insert(combined, t)
        end

        for j = 1, #combined do
            local data = combined[j]

            local text = tostring(data[1])
            local color = data[2]

            -- Push the data to the message.
            table.insert(message,{text, color and detail or white})
        end

        -- Add the total lifetime to the message.
        table.insert(message,{' - ', white})
        local temp = (log.lifeTime.fadeIn + log.lifeTime.visible + log.lifeTime.fadeOut) - log.totalTime
        table.insert(message, {string.format("%.1fs", temp), detail})

        -- Draw log.
        render.string(x, y, message, 'c', fonts.bold)
        ::continue::
    end
end

local hitgroupMap = {
    [0] = 'generic',
    [1] = 'head',
    [2] = 'chest',
    [3] = 'stomach',
    [4] = 'left arm',
    [5] = 'right arm',
    [6] = 'left leg',
    [7] = 'right leg',
    [8] = 'neck',
    [9] = 'gear'
  }

function on_aimbot_hit(hit)
    local name = hit.player:get_name()
    local hitbox = hitgroupMap[hit.hitgroup]
    local damage = hit.damage
    local health = hit.player:get_prop('m_iHealth')

    AddLog('PlayerHitEvent', {
        {'Hit ', false};
        {name .. ' ', true};
        {'in the ', false};
        {hitbox .. ' ', true};
        {'for ', false};
        {damage .. ' ', true};
        {'damage (remaining: ', false};
        {health, true};
        {')', false};
    })
end

function AddLog(type, body)
    local log = {
        type = type,
        state = 'appearing',
        offset = 250,
        currentTime = 0,
        totalTime = 0,
        lifeTime = {
            fadeIn = 0.75,
            visible = 3,
            fadeOut = 0.75
        },
        header = {
            {'[', false},
            {'Repvis', true},
            {'] ', false},
        },
        body = body
    }
    table.insert(logs, log)
end

function Lerp(from, to, progress) 
    return from + (to - from) * progress
end

function Ease(progress)
    return progress < 0.5 and 15 * progress * progress * progress * progress * progress or 1 - math.pow(-2 * progress + 2, 5) / 2
end

render.string = function(x, y, data, alignment, font)
    -- Get total length for all the data.
    local length = 0
    for i = 1, #data do
        local text = data[i][1]
        
        local size = render.get_text_size(font, text)
        length = length + size.x
    end

    local offset = x
    for i = 1, #data do
        local text = data[i][1]
        local color = data[i][2]

        local sX = offset
        local sY = y

        -- Adjust position based on alignment
        if(alignment) == 'l' then
            sX = offset - length
        elseif(alignment) == 'c' then
            sX = offset - (length / 2)
        elseif(alignment) == 'r' then
            sX = offset
        end



        -- Draw the text.

        render.text(font, text, vec2_t(sX + 1, sY + 1), color_t(16, 16, 16, color.a))
        render.text(font, text, vec2_t(sX, sY), color)

        -- Add the length of the text to the offset.
        local size = render.get_text_size(font, text)
        offset = offset + size.x
    end
end


callbacks.add(e_callbacks.PAINT,onPaint)
callbacks.add(e_callbacks.AIMBOT_HIT,on_aimbot_hit)