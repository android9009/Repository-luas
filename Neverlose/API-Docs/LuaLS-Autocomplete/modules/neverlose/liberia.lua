local liberia = {}
liberia.anti_aim = {}
liberia.anti_aim.condition = {}

local current_condition = "G"

local function detect_condition()
    local ply = entity.get_local_player()
    if not ply or not ply:is_alive() then
        return "G"
    end

    local on_ground = bit.band(ply.m_fFlags, 1) == 1
    local vel = math.sqrt(ply.m_vecVelocity.x^2 + ply.m_vecVelocity.y^2)
    local ducking = ply.m_flDuckAmount > 0.5
    local slowwalking = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get()

    if not on_ground and ducking then
        return "AC"
    elseif not on_ground then
        return "A"
    elseif ducking then
        return "C"
    elseif slowwalking then
        return "SW"
    elseif vel > 5 then
        return "M"
    else
        return "S"
    end
end

function liberia.anti_aim.condition.get(overrides)
    local raw = detect_condition()

    if overrides then
        local map = { S = 1, M = 2, SW = 3, C = 4, A = 5, AC = 6 }
        local idx = map[raw]
        if idx and overrides[idx] and overrides[idx] ~= "" then
            return overrides[idx]
        end
        return "G"
    end

    return raw
end

function liberia.anti_aim.condition.update()
    current_condition = detect_condition()
end

return liberia
